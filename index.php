<?php
error_reporting(E_ALL);
require_once 'vendor/autoload.php';

use App\Helper\SysHelper;
use App\Controller\AppController;

SysHelper::update();
$app = new AppController();