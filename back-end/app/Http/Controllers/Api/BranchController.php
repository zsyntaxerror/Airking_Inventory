<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;  // ← ADD THIS
use App\Models\Branch;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;  // ← ADD THIS

class BranchController extends Controller
{
    use ApiResponse;  // ← ADD THIS

    public function index(Request $request)
    {
        $query = Branch::query()->with(['users' => function ($q) {
            $q->select('user_id', 'first_name', 'last_name', 'username', 'branch_id', 'role_id');
        }]);

        // Search
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('code', 'like', "%{$search}%");
            });
        }

        // Filters
        if ($request->has('status')) {
            $query->where('is_active', $request->status === 'Active');
        }

        $perPage = $request->get('per_page', 50);
        $branches = $query->paginate($perPage);

        return $this->paginated($branches, 'Branches retrieved successfully');
    }

    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'name' => 'required|string|max:255',
                'code' => 'required|string|max:50|unique:branches',
                'region' => 'nullable|string|max:100',
                'city' => 'nullable|string|max:100',
                'address' => 'nullable|string|max:500',
                'contact_number' => 'nullable|string|max:50',
                'email' => 'nullable|email|max:255',
                'opening_date' => 'nullable|date',
                'capacity' => 'nullable|integer',
                'is_active' => 'sometimes|boolean',
            ]);

            $validated['is_active'] = $validated['is_active'] ?? true;
            $branch = Branch::create($validated);

            // ✅ USING ApiResponse trait
            return $this->success($branch, 'Branch created successfully', 201);

        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Failed to create branch: ' . $e->getMessage(), 500);
        }
    }

    public function show(Branch $branch)
    {
        $branch->load('users');
        return $this->success($branch, 'Branch retrieved successfully');
    }

    public function update(Request $request, Branch $branch)
    {
        try {
            $validated = $request->validate([
                'name' => 'sometimes|required|string|max:255',
                'code' => 'sometimes|required|string|max:50|unique:branches,code,' . $branch->id,
                'region' => 'nullable|string|max:100',
                'city' => 'nullable|string|max:100',
                'address' => 'nullable|string|max:500',
                'contact_number' => 'nullable|string|max:50',
                'email' => 'nullable|email|max:255',
                'opening_date' => 'nullable|date',
                'capacity' => 'nullable|integer',
                'is_active' => 'sometimes|boolean',
            ]);

            $branch->update($validated);

            // ✅ USING ApiResponse trait
            return $this->success($branch, 'Branch updated successfully');

        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->error('Failed to update branch: ' . $e->getMessage(), 500);
        }
    }

    public function destroy(Branch $branch)
    {
        try {
            $branch->delete();

            // ✅ USING ApiResponse trait
            return $this->success(null, 'Branch deleted successfully');

        } catch (\Exception $e) {
            return $this->error('Failed to delete branch: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Get branch inventory
     */
    public function inventory($id)
    {
        try {
            $branch = Branch::find($id);

            if (!$branch) {
                return $this->notFound('Branch not found');
            }

            // Get all inventory for this branch
            $inventory = $branch->inventories()->with('item')->get();

            return $this->success([
                'branch' => $branch,
                'inventory' => $inventory,
            ], 'Branch inventory retrieved successfully');

        } catch (\Exception $e) {
            return $this->error('Failed to retrieve inventory: ' . $e->getMessage(), 500);
        }
    }
}