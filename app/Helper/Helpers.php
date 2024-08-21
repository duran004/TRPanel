<?php
// Global değişkenler
//değişkenler
$baseDir = __DIR__ . '/../../';
global $env, $baseDir;
// .env dosyasını yükle
if (!function_exists('loadEnv')) {
    function loadEnv($path)
    {
        if (!file_exists($path)) {
            return [];
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        $env = [];

        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                continue;
            }

            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value);

            if (!empty($key)) {
                $env[$key] = $value;
            }
        }

        return $env;
    }
}

$envFilePath = $baseDir . '.env';
$env = loadEnv($envFilePath);
if (!function_exists('env')) {
    function env($key, $default = null)
    {
        global $env;
        if (isset($env[$key])) {
            return $env[$key];
        }
        return $default;
    }
}

if (!function_exists('dd')) {
    function dd($data)
    {
        echo '<pre>';
        var_dump($data);
        echo '</pre>';
        die();
    }
}

if (!class_exists('Log')) {
    class Log
    {
        public static function info($message)
        {
            $logFile = $GLOBALS['baseDir'] . 'logs/' . date('Y-m-d') . '.log';
            $message = date('Y-m-d H:i:s') . ' - ' . $message . PHP_EOL;
            file_put_contents($logFile, $message, FILE_APPEND);
        }
    }
}