window.MathJax = {
    tex: {
        inlineMath: [['\\(', '\\)']],
        displayMath: [['\\[', '\\]']],
        processEscapes: true,
        processEnvironments: true,
    },
    options: {
        ignoreHtmlClass: '.*|',
        // md-ellipsis：目录里的标题文字带着原样的 \(...\)，也要交给 MathJax 渲染
        processHtmlClass: 'arithmatex|md-ellipsis',
    },
}
