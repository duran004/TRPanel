<?php
error_reporting(E_ALL);
require_once 'vendor/autoload.php';

use App\Helper\SysHelper;
use App\Controller\TestController;

SysHelper::update();
$test = new TestController();
$test->index();


echo phpinfo();
