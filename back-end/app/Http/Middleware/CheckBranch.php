<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckBranch
{
    /**
     * Handle an incoming request.
     * Verifies that the user has access to the requested branch.
     */
    public function handle(Request $request, Closure $next, ...$branches)
    {
        if (!$request->user()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated',
            ], 401);
        }

        $user = $request->user();

        // Admin can access all branches
        if ($user->role && $user->role->role_name === 'admin') {
            return $next($request);
        }

        // If no specific branches are required, allow access
        if (empty($branches)) {
            return $next($request);
        }

        // Check if user's branch is in the allowed list
        $userBranchId = $user->branch_id;

        if (!in_array($userBranchId, $branches)) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. You do not have access to this branch.',
            ], 403);
        }

        return $next($request);
    }
}
