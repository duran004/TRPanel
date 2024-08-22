<?php
error_reporting(E_ALL);
require_once 'vendor/autoload.php';

use App\Controller\Route;
use App\Helper\SysHelper;
use App\Controller\AppController;

$requestUri = $_SERVER['REQUEST_URI'];
$requestMethod = $_SERVER['REQUEST_METHOD'];


$route = new Route($requestUri, $requestMethod);
require_once 'app/routes.php';

$route->run();