jekyll-menu
===========

A Jekyll plugin that helps you generate nested and sorted menus.


## Installation

The following guide assumes Jekyll allows symlinks in _includes, which only works in unsafe mode. If you do not want to enable unsafe mode, copy files instead of symlinking them.

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

To include pages in this menu, there are some frontmatter settings that you can specify for each site:

```yaml
menu:
  name: something
  parent: main
  position: 42
```

Setting    | Meaning
-----------|--------
`name`     | The name to be displayed in the menu for this page (also the name referenced in parent). Defaults to the pages title attribute.
`parent`   | The menu entry under which to nest the menu item for this page. Specify `main` for top-level entries. Defaults to nothgin which leads to the page not getting a menu entry at all.
`position` | A position used for sorting The menu entries. Pages without this option are sorted by name and come after all pages that have a position set.

The output of the include tag is best described by example:

```html
<ul class="menu-level-0">
    <li>
        <a href="/">Index</a>
    </li>
    <li class="current-parent">
        <a href="/something/">A page with a subpage</a>
        <ul class="menu-level-1">
            <li class="current">
                <a href="/something/else/">The subpage (also the current page)</a>
            </li>
        </ul>
    </li>
</ul>
```

As you can see, the output is a list of links and lists. The list item for the current page has the class `current`, parent menu items have the class `current-parent`. Also, each list has a class corresponding to the nesting level of the menu it represents.
