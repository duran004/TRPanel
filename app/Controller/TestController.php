<?php

namespace App\Controller;

use App\View\View;

class TestController
{
    public function index()
    {
        $data = [
            'name' => 'Duran Can Yılmaz',
            'age' => 30
        ];
        return View::view('test', $data);
    }
}