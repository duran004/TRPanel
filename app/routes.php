<?php

use App\Controller\Route;
use App\Helper\SysHelper;
use App\Controller\AppController;
use App\Controller\FileController;

Route::get('', AppController::class . '@index');
Route::get('phpinfo', AppController::class . '@phpinfo');
Route::get('filemanager/?{path}?', FileController::class . '@index');
Route::get('update', SysHelper::class . '@update');