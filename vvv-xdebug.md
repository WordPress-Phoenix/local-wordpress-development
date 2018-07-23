# Using xDebug in PhpStorm with VVV

This document will show you how to setup and use xDebug with [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV)

## Tools and References

- PhpStorm
- xDebug

More information can be found at [VVV Code-Debugging](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Code-Debugging)

## Enable xDebug

From command line, change directory to your vagrant install. SSH into vagrant with `vagrant ssh`. Once you've ssh'd into vagrant, turn xdebug by running `xdebug_on`

You should see something like this, which may change if you are running different versions of PHP:
```
php5-fpm stop/waiting
php5-fpm start/running, process #####
```

xDebug is now turned on and you can exit out of ssh.

## Path Mapping

Now PhpStorm needs to know where your vagrant install is serving files from. Essentially giving it a server reference to the actual files. We do this mapping the file paths.

The easiest way to configure server paths is to let PHPStorm detect them automatically. 

This guide assumes that the project is open at the VVV root (which is usually at ~/Sites/VVV). Depending on your the root of your project, you may need to set additional path maps. This is possible but we will not be covering these complex mappings in this general guide.

#### Setting PHP Server Paths

The easiest way to configure server paths is to let PHPStorm detect them automatically. 
1. Click the phone icon in the top right corner to turn on xDebug listening for PHPStorm.
2. Set a breakpoint in the wp-config.php file on the first executable line of code (you cannot breakpoint a blank line or PHP comments).
3. Visit the root URL of the domain you would like to debug. Its important that you visit the root URL first or the automatic path mapping will not work properly. If you are not careful you will accidentally visit site.test/wp-admin or site.test/wp-login.php and your path mappings will not work right.
4. After visiting the URL your computer should switch focus to your PHPStorm application, if it doesn't navigate to that application yourself.
5. If xDebug was setup correctly there should be a prompt that pops up asking for a proper path mapping. 

>UPDATED IMAGE NEEDED HERE


##### Validation & Additional Debugging Port Setting
If xdebug still isn't running after following the above steps, you may need to adjust the port set under `Preferences > Languages & Frameworks > PHP > Debug` to `9000`. 

![PHP Debug Settings](https://github.com/fansided/fansided-knowledge-base/blob/master/assets/images/php-debug-settings.png "PHP Debug Settings")

Additionally, you may click the `Validate` link at the top of the above preferences screen to verify that everything has been correctly set. Before running Validation, be sure that the `Path to create validation script` field points to the local root directory of the site you're trying to run xdebug on, and the URL to validation script also points to the root of the local site, ie `http://site.test`.

## Usage
Now we can use xDebug!

1. Set a breakpoint in your code editor by clicking in the left column next to the line you want to debug.
2. Go back to your browser and execute an action or do a page refresh. Once xDebug hits your breakpoint, PhpStorm will be will be shown with the debug panel open.

Learn how to set breakpoints from this [youtube video](https://www.youtube.com/watch?v=4udxLwRpJ3w)

#### Happy Debugging!
