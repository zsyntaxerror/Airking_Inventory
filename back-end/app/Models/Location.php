<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Location (ERD: location)
 * Table: locations
 * Fields: location_id (id), name, address, created_at
 */
class Location extends Model
{
    protected $table = 'locations';
    protected $primaryKey = 'location_id';

    public function getRouteKeyName(): string
    {
        return 'location_id';
    }

    protected $fillable = [
        'branch_id',
        'location_name',
        'address',
        'location_type',
        'city',
        'province',
        'region',
        'status_id',
    ];

    protected $appends = ['name'];

    public function getNameAttribute(): ?string
    {
        return $this->location_name;
    }

    public function status(): BelongsTo
    {
        return $this->belongsTo(StatusLookup::class, 'status_id', 'status_id');
    }

    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class, 'branch_id', 'id');
    }

    public function inventories(): HasMany
    {
        return $this->hasMany(Inventory::class, 'location_id', 'location_id');
    }

    public function sales(): HasMany
    {
        return $this->hasMany(Sale::class, 'location_id', 'location_id');
    }

    public function purchaseOrders(): HasMany
    {
        return $this->hasMany(PurchaseOrder::class, 'location_id', 'location_id');
    }

    public function issuances(): HasMany
    {
        return $this->hasMany(Issuance::class, 'location_id', 'location_id');
    }

    public function receivings(): HasMany
    {
        return $this->hasMany(Receiving::class, 'location_id', 'location_id');
    }

    public function adjustments(): HasMany
    {
        return $this->hasMany(Adjustment::class, 'location_id', 'location_id');
    }

    public function transfersFrom(): HasMany
    {
        return $this->hasMany(Transfer::class, 'from_location_id', 'location_id');
    }

    public function transfersTo(): HasMany
    {
        return $this->hasMany(Transfer::class, 'to_location_id', 'location_id');
    }
}
