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
    <a href="/filemanager" class="text-white">
    <h1>File Manager</h1>
    </a>
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
                
                
              
                // $absolutePath = "C:\xampp\htdocs\TRPanel\app\Controller/../../app";

                
                // dd(is_dir($absolutePath));
                // dd($absolutePath);
            @endphp
            <tr>
                <td @if (is_dir($file->path)): class="dir_click" @endif data-path="{{ $file->path }}">
                    @if (is_dir($file->path)):
                        <div class="dir dir_click" data-path="{{ $file->path }}"></div>
                    @else
                        <div class="file"></div>
                    @endif
                </td>
                <td title="{{ $file->path }}" @if (is_dir($file->path)): class="dir_click" @endif data-path="{{ $file->path }}">{{ $file->name }}</td>
                <td>{{ @formatSizeUnits(filesize($file->path)) }}</td>
                <td>{{ @date('Y-m-d H:i:s', filemtime($file->path)) }}</td>
                <td>{{  is_dir(realpath($file->path)) ? 'Directory' : 'File' }}</td>
                <td>{{ @substr(sprintf('%o', fileperms($file->path)), -4) }}</td>
        @endforeach
    </table>
</x-files>
<script>
    document.addEventListener('DOMContentLoaded', function() {
    const dirs = document.querySelectorAll('.dir_click');

    dirs.forEach(function(dir) {
        dir.addEventListener('dblclick', function() {
            const dirPath = this.getAttribute('data-path');
            console.log('Selected Directory Path:', dirPath);
            window.location.href = '/filemanager?path=' + dirPath;
        });
    });
});

</script>