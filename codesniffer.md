# Install and Setup Code Sniffer with PHPStorm

## Prerequisites

- Homebrew is installed

## Step 1: Installing PHP Code Sniffer

1. `brew install php-code-sniffer`
2. `which phpcs` and copy result into clipboard.

## Step 2: Getting WordPress Sniffing Rules

1. cd into your VVV folder
2. 
```
git clone git@github.com:WordPress-Coding-Standards/WordPress-Coding-Standards.git wpcs
```
3. ```phpcs --config-set installed_paths $(pwd)/wpcs/```

## Step 3: Integration with IntelliJ IDEA or PhpStorm###
[Screenshot Goes Here]()
1. Type `sniff` into the search field on the top left
2. Click `Code Sniffer`, and click the tripple dots to open up prefs.
2. Paste your clipboard (from which phpcs command) into the path and hit 'validate', then click apply.
3. Click on inspections and tick checkbox next to PHP Code Sniffer Validation
4. Click the blue arrows to Refresh 'Coding Standards' dropdown and select your preferred options (Like WordPress-Core)
5. Apply and OK.
