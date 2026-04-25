<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SystemSetting;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class SystemConfigController extends Controller
{
    use ApiResponse;

    private const DEFAULTS = [
        'companyName' => 'Airking Air Conditioning',
        'systemEmail' => 'system@airking.com',
        'timeZone' => 'Asia/Manila',
        'currency' => 'PHP',
        'reorderLevel' => '20',
        'safetyStock' => '10',
        'autoGenerateSKU' => true,
        'lowStockAlerts' => true,
        'twoFactorAuth' => false,
        'sessionTimeout' => false,
        'passwordExpiry' => false,
        'loginAttempts' => true,
        'emailNotifications' => true,
        'dailyReports' => true,
        'transactionAlerts' => false,
        'notificationRecipients' => 'admin@airking.com, manager@airking.com',
    ];

    public function show()
    {
        $saved = SystemSetting::query()->pluck('setting_value', 'setting_key')->toArray();
        $data = self::DEFAULTS;

        foreach ($saved as $key => $raw) {
            $decoded = json_decode((string) $raw, true);
            $data[$key] = $decoded !== null ? $decoded : $raw;
        }

        return $this->success($data, 'System configuration retrieved successfully');
    }

    public function update(Request $request)
    {
        try {
            $validated = $request->validate([
                'companyName' => 'required|string|max:150',
                'systemEmail' => 'required|email|max:150',
                'timeZone' => 'required|string|max:100',
                'currency' => 'required|string|max:10',
                'reorderLevel' => 'required|integer|min:0|max:100',
                'safetyStock' => 'required|integer|min:0|max:100',
                'autoGenerateSKU' => 'required|boolean',
                'lowStockAlerts' => 'required|boolean',
                'twoFactorAuth' => 'required|boolean',
                'sessionTimeout' => 'required|boolean',
                'passwordExpiry' => 'required|boolean',
                'loginAttempts' => 'required|boolean',
                'emailNotifications' => 'required|boolean',
                'dailyReports' => 'required|boolean',
                'transactionAlerts' => 'required|boolean',
                'notificationRecipients' => 'nullable|string|max:500',
            ]);

            foreach ($validated as $key => $value) {
                SystemSetting::query()->updateOrCreate(
                    ['setting_key' => $key],
                    ['setting_value' => json_encode($value)]
                );
            }

            return $this->success($validated, 'System configuration saved successfully');
        } catch (ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Throwable $e) {
            return $this->error('Failed to save configuration: ' . $e->getMessage(), 500);
        }
    }
}
