<?php

$defaultOrigins = [
    'http://localhost:3000',
    'http://localhost:3001',
    'http://localhost:3002',
    'http://localhost:5173',
    'http://127.0.0.1:3000',
    'http://127.0.0.1:3001',
    'http://127.0.0.1:3002',
    'http://127.0.0.1:5173',
];

$extraOrigins = array_filter(array_map('trim', explode(',', (string) env('CORS_ALLOWED_ORIGINS', ''))));

return [

    'paths' => ['api', '/api', 'api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => array_values(array_unique(array_merge($defaultOrigins, $extraOrigins))),

    // Allow any port on localhost / 127.0.0.1
    'allowed_origins_patterns' => [
        '#^https?://(localhost|127\.0\.0\.1)(:\d+)?$#',
    ],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];