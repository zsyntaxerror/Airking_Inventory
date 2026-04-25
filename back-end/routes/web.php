<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'success' => true,
        'message' => 'Web routes disabled. Use /api endpoints.',
    ]);
});
