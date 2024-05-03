<?php

namespace App\Controller;

class Route
{
    public static $routes = [];
    public $request;

    public static function get($route, $controllerMethod)
    {
        self::$routes[$route] = $controllerMethod;
    }
    public function get_request()
    {
        return $this->request;
    }

    public function __construct($request)
    {
        //if localhost 
        if (strpos($request, 'TRPanel') !== false) {
            $request = str_replace('TRPanel', '', $request);
        }
        $this->request = trim($request, '/');
    }

    public function run()
    {
        if (array_key_exists($this->request, Route::$routes)) {
            list($controller, $method) = explode('@', Route::$routes[$this->request]);
            $controller = new $controller;
            return $controller->$method();
        } else {
            http_response_code(404);
            throw new \Exception("Route not found");
        }
    }
}
