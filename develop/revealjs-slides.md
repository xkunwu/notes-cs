# Pandoc based slides workflow

Slides are rendered thanks to reveal.js and mathjax javascript plugins, converted into html using pandoc, and then visualized with a web browser.

## Prepare

You will need pandoc and some javascript libraries:

- [pandoc](https://pandoc.org/)
- [mathjax](https://github.com/mathjax/MathJax/archive/master.zip)
- [reveal.js](https://github.com/hakimel/reveal.js/archive/master.zip)

Assume you have pandoc in your shell path and the following tree structure:

    some_directory
    |-- slides
    |-- mathjax
    |-- reveal.js

Some useful plugins for reveal.js:

- [chalkboard](https://github.com/rajgoel/reveal.js-plugins): a plugin adding a chalkboard and slide annotation
- [elapsed-time-bar](https://github.com/tkrkt/reveal.js-elapsed-time-bar): add progress bar of elapsed time
- [pdfexport](https://github.com/McShelby/reveal-pdfexport): easily switch between screen and the built-in PDF export mode by pressing a shortcut key.
- [spotlight](https://github.com/denniskniep/reveal.js-plugin-spotlight): highlight the current mouse position with a spotlight.

## Templates

### css template

Make sure the template is in the directory `some_directory/reveal.js/css/theme/`

### html template

Should be stored in `some_directory/slides/`

## Slides file

Should be stored in `some_directory/slides/`

The first part of the file is a header with basic information

    ---
    title: "My first slides"
    author: WU Xiaokun
    date: \today
    duration: 90
    published: false
    slideNumber: true
    theme: xwu
    width: 1600
    height: 1000
    transition: fade
    ...

## Converting to html

This will create a file `myfirstslides.html`

    pandoc -s --mathjax=../mathjax/MathJax.js -i -t revealjs myfirstslides.md --include-in-header=leftalign.md --template=template.md -V center=false -V history=false -V revealjs-url=../reveal.js -o myfirstslides.html

## Annotations

All your annotations are saved in a json format. To save them, you need to *download* the json file. At the end of the lecture, change the json file name to myfirstslides.json and add it to the directory some_directory/slides/

You can now recompile your slides with the command

    pandoc -s --mathjax=../mathjax/MathJax.js -i -t revealjs myfirstslides.md --include-in-header=leftalign.md --template=template.md -V center=false -V history=false -V revealjs-url=../reveal.js -V loadchalkboard=myfirstslides.json

All this does is tell reveal.js to load your previous annotations through the option `-V loadchalkboard=myfirstslides.json`. If you reload your slides, you will have access to your annotations. If needed, you can modify what you wrote and save the result to a new json file.
