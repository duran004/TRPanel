files view
<x-files>
    <x-alert>File list:</x-alert>
    <ul>
        @foreach ($files as $file):
        <li>{{ $file }}</li>
        @endforeach
    </ul>
</x-files>