# evernote-markdown-win-theme

提供Evernote中文版的Windows平台下的markdown编辑器的主题。

![](https://github.com/hyboxu/evernote-markdown-win-theme/raw/master/preview.png)

# 基本原理

与Mac版本不同，Evernote_China_Win并未通过本地的方式读取Markdown编辑器文件，而是打包到Evernote.exe的资源目录`ZIP/MARKDOWNEDITORRES`。因此[evernote-markdown-vue](https://github.com/timothyzhw/evernote-markdown-vue)的经验不能直接复用。

尝试使用[resourcehacker](http://www.angusj.com/resourcehacker/#download)替换`ZIP/MARKDOWNEDITORRES`，在版本`6.18.14.753 (600753) Public (CE Build ce-62.1.8947, ME Build V1.0.28)`下会遇到代码渲染延迟的问题，以及字体不生效，猜测原因是字体加载问题。

使用[Fiddler](https://www.telerik.com/fiddler)全局代理，会发现evernote会尝试访问`http://loadmarkdown`这样的地址来获取字体文件，而非获取打包文件中的字体文件，而且默认情况（未替换资源文件）也会出现这种错误。

个人猜测这是由于BUG导致的，由于Evernote对内部链接`http://loadmarkdown`的路由错误，导致其直接访问Internet。

基于这个BUG，我们可以替换掉Evernote.exe中的`http://loadmarkdown`为本地地址，如`http://localhost:555`。这样Evernote.exe在渲染Markdown文件时，将使用服务器上的编辑器，而非资源文件中的编辑器。

# 版本说明

兼容版本：6.18.14.753 (600753) Public (CE Build ce-62.1.8947, ME Build V1.0.28)

个人在[evernote-markdown-vue](https://github.com/timothyzhw/evernote-markdown-vue)的版本上做了一点轻微的修改，包括：

- `[TOC]`中的链接取消加粗
- 修复`.tui-editor-contents pre`导致的黑边问题
- 修复 `* {font-family: Microsoft Yahei, sans-serif}`导致代码渲染字体异常的问题

具体修改请使用`Beyond Compare`之类软件对比查看。

已知问题：

- 由于演示功能是通过`main.min.js`行内CSS加载的方式生成的html页面，无法以上修改对其无效。个人由于不使用该功能，因此未作修改。

# 使用方式

## 1. 搭建自定义服务器

这里推荐使用Nginx，后台占用内存极低。关键是支持缓存，每次启动Evernote只需加载一次资源文件，每次渲染页面请求一次`index.html`，通常返回`304`，渲染效率很高。

以下教程面向新手，熟悉Web服务器的开发人员可以跳过：

- 下载[Windows版本的Nginx](https://nginx.org/en/download.html)，解压到合适的地方，假设设其路径为`C:\nginx`

- 复制`vue`下的所有文件到`C:\nginx\html\`目录下
- 编辑`C:\nginx\conf\nginx.conf`，修改`listen       80;`为`listen       555;`
- 运行`C:\nginx\nginx.exe`，打开浏览器访问`http://localhost:555`，出现Markdown编辑器页面说明生效。

由于Nginx是后台服务，每次开机通常只需要执行一次。

## 2. 修改Evernote.exe

关闭Evernote程序，将Evernote.exe备份，使用16进制编辑器（如[UltraEdit](https://www.ultraedit.com/)），将：

`68007400740070003A002F002F006C006F00610064006D00610072006B0064006F0077006E002F0000000000`

替换为：

`68007400740070003A002F002F006C006F00630061006C0068006F00730074003A003500350035002F000000`

保存并退出

*(这里其实是将`http://loadmardown/`替换为`http://localhost:555/`)*

# 注意事项

## 删除缓存

由于采取了http缓存，如果你需要调试主题，或是修改主题后使其生效，需要退出Evernote.exe后删除`C:\Users\{your_username}\Yinxiang Biji\LocalStorage\Cache`目录下的所有文件。
