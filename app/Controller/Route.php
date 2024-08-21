<?php

namespace App\Controller;

class Route
{
    public static $routes = [
        'GET' => [],
        'POST' => []
    ];
    public $request;
    public $method;

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

    public function __construct($request, $method)
    {
        //if localhost 
        if (strpos($request, 'TRPanel') !== false) {
            $request = str_replace('TRPanel', '', $request);
        }
        $this->request = trim($request, '/');
        $this->method = strtoupper($method);
    }

    public function run()
    {
        if (!in_array($this->method, ['GET', 'POST'])) {
            http_response_code(405);
            throw new \Exception("Invalid HTTP method");
        }

        if (array_key_exists($this->request, Route::$routes[$this->method])) {
            list($controller, $method) = explode('@', Route::$routes[$this->method][$this->request]);
            $controller = new $controller;
            return $controller->$method();
        } else {
            http_response_code(404);
            throw new \Exception("Route not found");
        }
    }
}