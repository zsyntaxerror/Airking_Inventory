<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\AuditTrail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    /**
     * Register new user
     */
    public function register(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|unique:users,username|max:50',
            'email' => 'required|email|unique:users,email|max:100',
            'password' => 'required|min:8|confirmed',
            'first_name' => 'required|max:50',
            'last_name' => 'required|max:50',
            'role_id' => 'required|exists:roles,role_id',
        ]);

        $user = User::create([
            'username' => $validated['username'],
            'email' => $validated['email'],
            'password_hash' => Hash::make($validated['password']),
            'first_name' => $validated['first_name'],
            'last_name' => $validated['last_name'],
            'role_id' => $validated['role_id'],
            'status_id' => 1, // Active by default
        ]);

        $token = $user->createToken('auth-token')->plainTextToken;

        // Log registration
        AuditTrail::create([
            'user_id' => $user->user_id,
            'action' => 'register',
            'table_name' => 'users',
            'record_id' => $user->user_id,
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return response()->json([
            'message' => 'User registered successfully',
            'user' => $user->load('role', 'status'),
            'token' => $token,
        ], 201);
    }

    /**
     * Login user
     */
    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);

        $user = User::where('username', $request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password_hash)) {
            throw ValidationException::withMessages([
                'username' => ['The provided credentials are incorrect.'],
            ]);
        }

        // Check if user is active
        if ($user->status_id !== 1) {
            throw ValidationException::withMessages([
                'username' => ['Your account is inactive. Please contact administrator.'],
            ]);
        }

        // Revoke old tokens (optional - for single device login)
        // $user->tokens()->delete();

        $token = $user->createToken('auth-token')->plainTextToken;

        // Log login
        AuditTrail::create([
            'user_id' => $user->user_id,
            'action' => 'login',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return response()->json([
            'message' => 'Login successful',
            'user' => $user->load('role', 'status'),
            'token' => $token,
        ]);
    }

    /**
     * Logout user
     */
    public function logout(Request $request)
    {
        // Log logout
        AuditTrail::create([
            'user_id' => $request->user()->user_id,
            'action' => 'logout',
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Logged out successfully',
        ]);
    }

    /**
     * Get current user
     */
    public function user(Request $request)
    {
        return response()->json([
            'user' => $request->user()->load('role', 'status'),
        ]);
    }

    /**
     * Refresh token (optional)
     */
    public function refresh(Request $request)
    {
        $user = $request->user();
        
        // Delete old token
        $request->user()->currentAccessToken()->delete();
        
        // Create new token
        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'token' => $token,
        ]);
    }

    /**
     * Forgot password - generate a temporary password for the user.
     * This is a simple, API-driven flow for internal systems where email
     * delivery is not set up.
     */
    public function forgotPassword(Request $request)
    {
        $validated = $request->validate([
            'username' => 'required|string',
            'email'    => 'required|email',
        ]);

        $user = User::where('username', $validated['username'])
            ->where('email', $validated['email'])
            ->first();

        if (! $user) {
            throw ValidationException::withMessages([
                'username' => ['We could not find a matching account.'],
            ]);
        }

        // Generate a new temporary password
        $temporaryPassword = Str::random(10);
        $user->password_hash = Hash::make($temporaryPassword);
        $user->save();

        // Log password reset
        AuditTrail::create([
            'user_id'    => $user->user_id,
            'action'     => 'password_reset',
            'table_name' => 'users',
            'record_id'  => $user->user_id,
            'ip_address' => $request->ip(),
            'user_agent' => $request->userAgent(),
        ]);

        return response()->json([
            'message'            => 'Password has been reset. Use the temporary password to log in and then change it.',
            'temporary_password' => $temporaryPassword,
        ]);
    }
}