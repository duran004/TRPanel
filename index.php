<?php
error_reporting(E_ALL);
require_once 'vendor/autoload.php';

use App\Controller\Route;
use App\Helper\SysHelper;
use App\Controller\AppController;


$route = new Route($_SERVER['REQUEST_URI']);
Route::get('', AppController::class . '@file_manager');
Route::get('update', SysHelper::class . '@update');

$route->run();
