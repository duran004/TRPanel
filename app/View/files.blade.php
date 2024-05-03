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

<div class="container-fluid bg-dark text-white px-3 py-0">
    <h1>File Manager</h1>
</div>
<div class="container-fluid bg-light px-3 py-0">
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">File Manager</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#">Home</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</div>


<x-files>
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
                $filepath = $basePath . $file;
                if ($file == '..' or $file == '.') {
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
