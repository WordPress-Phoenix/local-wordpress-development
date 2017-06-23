# Install and Setup Code Sniffer with PHPStorm

## Prerequisites

- Composer
- VVV at `~/Sites/VVV/`

## Step 1: Installing PHP Code Sniffer

```
cd ~/Sites/VVV/ && composer require wp-coding-standards/wpcs:^0.10 && composer install && ./vendor/bin/phpcs --config-set installed_paths vendor/wp-coding-standards/wpcs/ && ./vendor/bin/phpcs -i && which $(pwd)/vendor/bin/phpcs ;
```


## Step 2: Getting WordPress Sniffing Rules

1. cd into your VVV folder
2. Copy and paste the following into terminal:
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
