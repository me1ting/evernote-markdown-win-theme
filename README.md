# evernote-markdown-win-theme

[中文](README-zh_CN.md)

> A markdown-theme of Chinese&Windows edition evernote.

![](https://github.com/hyboxu/evernote-markdown-win-theme/raw/master/preview.png)

# How it works

The markdown editor is not separated as files for evernote_china_win, but it is built in evernote.exe as resource files。

But if you replace it using [resource hacker](http://www.angusj.com/resourcehacker/#download) by new one, it not works well, the fonts can't be loaded.

There is a bug for evernote_china_win, it loads markdown editor form http://loadmarkdown, the evernote.exe will try access

Internet to get it.

So we can set up a local site to support own one, such like `http://localhost:555`。

# Features

The theme works well on my evernote : `6.18.14.753 (600753) Public (CE Build ce-62.1.8947, ME Build V1.0.28)`

Supply:

- `vue markdown theme` from[evernote-markdown-vue](https://github.com/timothyzhw/evernote-markdown-vue)
- fix some bugs for the theme
- preview default, double click to edit
- replace guide button to viewer button

# Usage

First, please make sure your evernote is Chinese Edition, if not, you can try it.

## 1. set up a local site

Nginx is recommended here, and the background cpu&memory is extremely low. Cache is very important here, each time you start evernote,  it  loads editor's resource files only once. Each time evernote render a page, it requests `index.html`, usually returning `304`, so the rendering efficiency is excellent.

Just for newer:

- Download [Windows version of Nginx](https://nginx.org/en/download.html) and extract it to the appropriate place, assuming its path is `C:\nginx`
- Copy all files under `vue` to the `C:\nginx\html\` directory
- Edit `C:\nginx\conf\nginx.conf`, modify `listen 80;` to `listen 555;`
- Run `C:\nginx\nginx.exe` and open a browser to access `http://localhost:555`, double click the html page and a markdown editor will appear

## 2. edit evernote.exe

Close evernote, backup it, and use a hex editor (such as [UltraEdit](https://www.ultraedit.com/)) to replace

`68007400740070003A002F002F006C006F00610064006D00610072006B0064006F0077006E002F0000000000`

to

`68007400740070003A002F002F006C006F00630061006C0068006F00730074003A003500350035002F000000`

, save and quit.

*(the work is replacing ``http://loadmardown/` to `http://localhost:555/`)*

# Suggests

## remove cache

Since http cache is taken, if you need to debug the theme or modify the theme to take effect, you should first try to restart evernote, or delete files in `C:\Users\{your_username}\Yinxiang Biji\LocalStorage\Cache\` . 

