import os, zipfile

folders = ['app', 'bootstrap', 'config', 'database', 'public', 'resources', 'routes', 'artisan', 'composer.json', 'composer.lock', 'server.php']

with zipfile.ZipFile('..\..\..\linux_safe_update.zip', 'w', zipfile.ZIP_DEFLATED) as zf:
    for item in folders:
        if os.path.isfile(item):
            zf.write(item, item.replace('\\', '/'))
        elif os.path.isdir(item):
            for root, dirs, files in os.walk(item):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = file_path.replace('\\', '/')
                    zf.write(file_path, arcname)

