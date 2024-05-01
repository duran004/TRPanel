<?php

namespace App\View;

class View
{
    public static function view($view, $data = [])
    {
        extract($data);
        require_once "app/View/$view.php";
    }
}
