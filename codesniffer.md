# Install and Setup Code Sniffer with PHPStorm

##Prerequisites##

- Homebrew is installed

##Step 1: Installing PHP Code Sniffer##

1. `brew install php-code-sniffer`
2. `which phpcs` and copy result into clipboard.

##Step 2: Getting WordPress Sniffing Rules

1. cd into your VVV folder
2. ```git clone git@github.com:WordPress-Coding-Standards/WordPress-Coding-Standards.git wpcs```
3. ```phpcs --config-set installed_paths YOURPATHHERE```

## Step 3: Integration with IntelliJ IDEA or PhpStorm###

1. Navigate to Preferences > PHP > Code Sniffer
2. Paste your clipboard into the path and hit 'validate', then apply.
3. Navigate to Preferences > Inspections > PHP > PHP Code Sniffer validation and tick checkbox to enable
4. Refresh 'Coding Standards' dropdown and select your preferred options
