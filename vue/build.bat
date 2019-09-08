@echo off

rem Remove last build.
rmdir /s/q out
mkdir out

rem Compress js file and copy other required files.
call node_modules\.bin\uglifyjs.cmd main.js -o out/main.min.js
xcopy /I fonts "out/fonts"
xcopy /I vue "out/vue"
copy index.html out
copy main.min.css out
copy markdown-win-version.txt out
copy vue.css out

echo "build success!"
pause