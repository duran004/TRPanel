<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"
    integrity="sha512-jnSuA4Ss2PkkikSOLtYs8BlYIeeIK1h99ty4YfvRPAlzr377vr3CXDb7sb7eEEBYjDtcYj+AjBH3FLv5uSJuXg=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />
files view
<x-files>
    <x-alert>File list:</x-alert>
    <table class="table table-striped">
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
        $filepath= $basePath . $file;
        @endphp
        <tr>
            <td>
                @if (is_dir($filepath)):
                <img src="https://img.icons8.com/ios/50/000000/folder-invoices.png" />
                @else
                <img src="https://img.icons8.com/ios/50/000000/file.png" />
                @endif
            </td>
            <td title="{{ $filepath }}">{{ $file }}</td>
            <td>{{ @filesize($filepath) }}</td>
            <td>{{ @date('Y-m-d H:i:s', filemtime($filepath)) }}</td>
            <td>{{ @is_dir($filepath) ? 'Directory' : 'File' }}</td>
            <td>{{ @substr(sprintf('%o', fileperms($filepath)), -4) }}</td>
            @endforeach
    </table>
</x-files>