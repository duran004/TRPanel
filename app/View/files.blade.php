@php
    function formatSizeUnits($bytes)
    {
        if ($bytes >= 1073741824) {
            $bytes = number_format($bytes / 1073741824, 2) . ' GB';
        } elseif ($bytes >= 1048576) {
            $bytes = number_format($bytes / 1048576, 2) . ' MB';
        } elseif ($bytes >= 1024) {
            $bytes = number_format($bytes / 1024, 2) . ' KB';
        } elseif ($bytes > 1) {
            $bytes = $bytes . ' bytes';
        } elseif ($bytes == 1) {
            $bytes = $bytes . ' byte';
        } else {
            $bytes = '0 bytes';
        }
        return $bytes;
    }
@endphp
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
    integrity="sha512-jnSuA4Ss2PkkikSOLtYs8BlYIeeIK1h99ty4YfvRPAlzr377vr3CXDb7sb7eEEBYjDtcYj+AjBH3FLv5uSJuXg=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />
files view
<x-files>
    <x-alert>File list:</x-alert>
    <table class="table table-striped table-sm table-hover">
        <thead>
            <tr>
                <th>Icon</th>
                <th>Name</th>
                <th>Size</th>
                <th>Last Modified</th>
                <th>Type</th>
                <th>Permissions</th>
            </tr>
        </thead>
        @foreach ($files as $file):
            @php
                $filepath = $basePath  . $file;
                if ($file == '..' or $file == '.'){
                    continue;
                }
            @endphp
            <tr>
                <td>
                    @if (is_dir($filepath)):
                        <img width="21" src="https://img.icons8.com/ios/50/000000/folder-invoices.png" />
                    @else
                        <img width="21" src="https://img.icons8.com/ios/50/000000/file.png" />
                    @endif
                </td>
                <td title="{{ $filepath }}">{{ $file }}</td>
                <td>{{ @formatSizeUnits(filesize($filepath)) }}</td>
                <td>{{ @date('Y-m-d H:i:s', filemtime($filepath)) }}</td>
                <td>{{ @is_dir($filepath) ? 'Directory' : 'File' }}</td>
                <td>{{ @substr(sprintf('%o', fileperms($filepath)), -4) }}</td>
        @endforeach
    </table>
</x-files>
