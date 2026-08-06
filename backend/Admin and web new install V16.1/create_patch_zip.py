import os, zipfile

files = [
    'app/Models/DeliverymanWallet.php',
    'app/Models/PaymentRequest.php',
    'app/Models/ShippingAddress.php',
    'resources/themes/default/web-views/users-profile/inbox/index.blade.php',
    'resources/themes/theme_aster/theme-views/users-profile/inbox/index.blade.php',
    'resources/views/vendor-views/chatting/index.blade.php'
]

with zipfile.ZipFile('..\..\..\victorious_market_security_patch.zip', 'w', zipfile.ZIP_DEFLATED) as zf:
    for file in files:
        if os.path.exists(file):
            # Write the file with exactly the forward slash path
            zf.write(file, file)

