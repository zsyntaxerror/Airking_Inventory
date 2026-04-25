<?php

namespace App\Support;

use App\Models\AuditTrail;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

final class AuditTrailLogger
{
    /**
     * Best-effort audit row; never throws to callers.
     */
    public static function record(
        ?User $user,
        Request $request,
        string $action,
        ?string $tableName = null,
        ?int $recordId = null,
        ?array $newValues = null
    ): void {
        try {
            AuditTrail::create([
                'user_id' => $user?->user_id,
                'action' => Str::limit($action, 100, ''),
                'table_name' => $tableName !== null ? Str::limit($tableName, 100, '') : null,
                'record_id' => $recordId,
                'new_values' => $newValues,
                'ip_address' => $request->ip(),
                'user_agent' => Str::limit((string) $request->userAgent(), 255, ''),
            ]);
        } catch (\Throwable $e) {
            report($e);
        }
    }
}
