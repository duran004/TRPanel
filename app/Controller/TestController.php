<?php

namespace App\Controller;

use App\View\View;

class TestController
{
    public function index()
    {
        return View::view('test');
    }
}