<?php

namespace App\View;

class View
{
    public static function view($view, $data = [])
    {
        extract($data);
        $viewPath = __DIR__ . "/$view.blade.php";

        if (file_exists($viewPath)) {
            ob_start();
            include $viewPath;
            $output = ob_get_clean();

            // Replace special template tags
            $output = str_replace("{{", "<?=", $output);
            $output = str_replace("@elseif", "<?php elseif", $output);
            $output = str_replace("@foreach", "<?php foreach", $output);
            $output = str_replace("):", '): ?>', $output);
            $output = str_replace("@endforeach", '<?php endforeach; ?>', $output);
            $output = str_replace("@if", "<?php if", $output);
            $output = str_replace("}}", "?>", $output);
            $output = str_replace("@endif", "<?php endif; ?>", $output);
            $output = str_replace("@else", "<?php else: ?>", $output);
            $output = str_replace("@php", "<?php", $output);
            $output = str_replace("@endphp", "?>", $output);
            // return $output;
            return eval("?>$output");
        } else {
            throw new \Exception("View file '$view' not found");
        }
    }
}
