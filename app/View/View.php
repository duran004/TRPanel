<?php

namespace App\View;

class View
{
    public static function view($view, $data = [])
    {
        extract($data);
        $view = file_get_contents(__DIR__ . "/$view.php");
        $view = str_replace("{{", "<?=", $view);
        $view = str_replace("}}", "?>", $view);

$view = str_replace("@foreach", "<?php foreach", $view);
        $view = str_replace("@endforeach", "?>", $view);
$view = str_replace("@if", "<?php if", $view);
        $view = str_replace("@endif", "?>", $view);
$view = str_replace("@else", "<?php else: ?>", $view);
$view = str_replace("@elseif", "<?php elseif", $view);
        return eval('?>' . $view);
}
}