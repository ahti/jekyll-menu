jekyll-menu
===========

A Jekyll plugin that helps you generate nested and sorted menus.


## Installation

The following guide assumes Jekyll allows symlinks in _includes, whcih it does not currently do. This issue is tracked [here](https://github.com/mojombo/jekyll/issues/1552).

For the time being, just copy the file `menu.html` instead of symlinking it. 

### Your site is under version control with git

Open up a terminal and change to your sites root.
Then add a git submodule in the folder `_vendor` and symlink `menu.html` in `_includes` and `menu_generator.rb` in `_plugins`.

tl;dr:

```bash
mkdir _vendor
cd _vendor
git submodule add https://github.com/Ahti/jekyll-menu.git
cd ../_includes
ln -s ../_vendor/jekyll-menu/menu.html
cd ../_plugins
ln -s ../_vendor/jekyll-menu/menu_generator.rb
```

### Your site is not under version control or not using git

Start using git.

> But I don't want to!

Then at least check out this repo into _vendor and follow the steps outlined above.

Instead of

    git submodule add https://github.com/Ahti/jekyll-menu.git
    
use

    git clone https://github.com/Ahti/jekyll-menu.git

> I really don't want to use git at all >:(

If you insist, just download `menu.html` and `menu_generator.rb` and put them into your `_includes` and `_plugins` folder respectively

## Usage

In any of your layouts, insert this code anywhere. I would recommend putting it inside a nav-tag:

    {% include menu.html menu=site.menu %}
    
To include pages in this menu, include 

