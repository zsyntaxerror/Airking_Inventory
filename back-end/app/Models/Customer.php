<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Traits\Auditable;

class Customer extends Model
{
    use SoftDeletes, Auditable;

    protected $table = 'customers';
    protected $primaryKey = 'id';

    protected $fillable = [
        'customer_type',
        'customer_name',
        'customer_code',
        'contact_number',
        'email',
        'company_name',
        'address',
        'city',
        'province',
        'region',
        'tin',
        'notes',
        'is_active',
        'status_id',
        'credit_limit',
        'outstanding_balance',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'credit_limit' => 'decimal:2',
        'outstanding_balance' => 'decimal:2',
    ];

    public function getRouteKeyName()
    {
        return 'id';
    }

    // Relationships
    public function salesTransactions()
    {
        return $this->hasMany(Transaction::class, 'customer_id', 'customer_id');
    }

}