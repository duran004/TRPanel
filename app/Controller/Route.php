<?php

namespace App\Controller;

use App\View\View;

class Route
{
    public static $routes = [
        'GET' => [],
        'POST' => []
    ];
    public $request;
    public $method;
    public $queryParams = [];

    public static function get($route, $controllerMethod)
    {
        self::$routes['GET'][$route] = $controllerMethod;
    }

    public static function post($route, $controllerMethod)
    {
        self::$routes['POST'][$route] = $controllerMethod;
    }

    public function get_request()
    {
        return $this->request;
    }

    public function __construct($url, $method)
    {
        // Parse the URL to get the path and query parameters
        $parsedUrl = parse_url($url);
        $path = $parsedUrl['path'];
        $query = isset($parsedUrl['query']) ? $parsedUrl['query'] : '';

        // Parse query parameters into an associative array
        parse_str($query, $this->queryParams);

        // If localhost
        if (strpos($path, 'TRPanel') !== false) {
            $path = str_replace('TRPanel', '', $path);
        }
        $this->request = trim($path, '/');
        $this->method = strtoupper($method);
    }

    public function run()
    {
        if (!in_array($this->method, ['GET', 'POST'])) {
            http_response_code(405);
            throw new \Exception("Invalid HTTP method");
        }

        foreach (Route::$routes[$this->method] as $route => $controllerMethod) {
            $pattern = preg_replace('/\{[^\}]+\}/', '([^/]+)', $route);
            if (preg_match("#^$pattern$#", $this->request, $matches)) {
                array_shift($matches);
                list($controller, $method) = explode('@', $controllerMethod);
                $controller = new $controller;
                return call_user_func_array([$controller, $method], $matches);
            }
        }

        http_response_code(404);
        echo View::view('errors/404');
    }
}