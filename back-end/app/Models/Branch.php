<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use App\Traits\Auditable;
use App\Models\User;

class Branch extends Model
{

    use Auditable;

    protected $fillable = [
        'code',
        'name',
        'region',
        'city',
        'address',
        'contact_number',
        'email',
        'opening_date',
        'capacity',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'capacity' => 'integer',
        'opening_date' => 'date',
    ];

    public function inventories()
    {
        return $this->hasMany(Inventory::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    /**
     * Users assigned to this branch (from User Management).
     */
    public function users()
    {
        return $this->hasMany(User::class, 'branch_id');
    }
}