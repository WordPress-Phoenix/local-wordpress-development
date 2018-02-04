# Install and Setup Code Sniffer with PHPStorm

## Prerequisites

- Composer
- VVV at `~/Sites/VVV/`

## Step 1: Installing PHP Code Sniffer

```
cd ~/Sites/VVV/ && composer require wp-coding-standards/wpcs:^0.10 && composer install && $(pwd)/vendor/bin/phpcs --config-set installed_paths $(pwd)/vendor/wp-coding-standards/wpcs/ && $(pwd)/vendor/bin/phpcs -i && which $(pwd)/vendor/bin/phpcs ;
```

## Step 2: Integration with IntelliJ IDEA or PhpStorm###
[Screenshot Gif Coming Soon]()
1. Type `sniff` into the search field on the top left
2. Click `Code Sniffer`, and click the triple dots to open up prefs.
3. If Local is not an option on the left pane, delete all left pane values, click apply, then close and reopen the prefs.
4. Click on Local then Paste your clipboard (from the above install command) into the path and hit 'validate', then click apply.
5. Click on inspections and tick checkbox next to PHP Code Sniffer Validation
4. Click the blue arrows to Refresh 'Coding Standards' dropdown and select your preferred options (Like WordPress-Core)
5. Apply and OK.

## Note about coming change:

We learned phpcs is part of VVV natively:
```
VVV/www/default/database-admin/vendor/squizlabs/php_codesniffer/scripts/phpcs
```

We have a todo here to fix up these instructions to connect this phpcs file to the wordpress rulesets.
