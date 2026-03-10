# Typst Learning Record

???- Info "实验模板报告 I"

    ```typst
    #set text(
        font: "Source Han Serif SC",
        size: 11pt,
    )
    #set par(
        leading: 11pt, 
        first-line-indent: 2.8em, 
        justify: true
    )

    #let fakepar = style(styles => {
        let b = par[#box()]
        let t = measure(b + b, styles);

        b
        v(-t.height)
    })

    #show heading: it => {
        it
        fakepar
    }

    #show raw.where(block: false): box.with(
        fill: luma(240),
        inset: (x: 3pt, y: 0pt),
        outset: (y: 3pt),
        radius: 2pt,
    )

    #let style-number(number) = text(gray)[#number]
    #show raw.where(block: true): it => {
        set text(font: ("Monaco", "Menlo", "'Courier New'", "monospace"))
        set par(leading: 7pt)
        h(0em); v(-1.2em)
        block(
            width: 100%,
            fill: luma(240),
            inset: 10pt,
            radius: 10pt,
            grid(
                columns: (10pt,400pt),
                align: (right, left),
                gutter: 0.5em,
                ..it.lines
                    .enumerate()
                    .map(((i, line)) => (style-number(i + 1), line))
                    .flatten()
            )
        )  
    }

    #set heading(numbering: (..args) => {
        let nums = args.pos()
        let level = nums.len()
        if level == 2 {
            numbering("1", nums.at(1))
        } else if level == 3 {
            [#numbering("1.1", nums.at(1),nums.at(2))]
        } else if level == 4 {
            numbering("1.1.1", nums.at(1),nums.at(2),nums.at(3))
        } else if level == 5 {
            [#numbering("1.1.1.1", nums.at(1),nums.at(2),nums.at(3),nums.at(4))]
        }
    })

    #show heading.where(
        level: 1
    ): it => {
        set align(center)
        set text(weight: "bold", size: 20pt, font: "Source Han Serif SC")
        it
        h(0em) 
        v(-1.2em)
    }

    #show heading.where(
        level: 2
    ): it => {
        set text(weight: "bold", size: 18pt, font: "Source Han Serif SC")
        set block(above: 1.5em, below: 15pt)
        it
    }

    #show heading.where(
        level: 3
    ): it => {
        set text(weight: "bold", size: 13pt, font: "Source Han Serif SC")
        set block(above: 1.5em, below: 1em)
        it
    }

    #let thickness = 0.8pt
    #let offset = 4pt
    #let ubox(..) = box(
        width: 1fr,
        baseline: offset,
        stroke: (bottom: thickness),
    )
    #let uline(body) = {
        ubox()
        underline(
            stroke: thickness,
            offset: offset,
        )[#body]
        ubox()
    }

    #set list(marker: ([•], [▹], [–]))

    #show figure: it => {it; h(0em); v(-1.2em)}

    #show figure.caption: it => [
        #set text(size: 8pt, font: "LXGW WenKai Mono")
        图#it.counter.display(it.numbering)：#it.body
    ]

    #set page(
        paper: "a4",

        header: [
            #set text(size: 10pt, baseline: 8pt, spacing: 3pt)
            #smallcaps[ZJU SYSTEM II]
            #h(1fr) _Lab 1 Report_
            #v(0.2em)
            #line(length: 100%, stroke: 0.7pt)
        ],
        footer: {
            set align(center)
            grid(
                columns: (5fr, 1fr, 5fr),
                line(length: 100%, stroke: 0.7pt),
                text(size: 10pt, baseline: -3pt, 
                counter(page).display("1")
                ),
                line(length: 100%, stroke: 0.7pt)
            )
        },
    )
    ```

每次需要修改 `page` 里的 `header` 就可以了。

???- Info "实验报告模版 II"

    ```typst
    #let course = "随便一门课"
    #let title = "随便一个标题"

    #let hanging = {
        v(1em)
        grid(
            columns: (0.5fr, 0.5fr),
            align(center)[
                #set text(font: "Source Han Serif SC", size: 13pt, weight: "bold")
                姓名：随便一个名字
            ],
            align(center)[
                #set text(font: "Source Han Serif SC", size: 13pt, weight: "bold")
                学号：随便一个学号
            ]
        )
    }

    #set text(
        font: ("Source Han Serif SC"),
        size: 11pt,
    )

    #set par(
        leading: 11pt, 
        first-line-indent: 2.8em, 
        justify: true
    )

    #let fakepar = context [
        #let b = par[#box()]
        #let t = measure(b + b);
        #b
        #v(-t.height)
    ]

    #set page(
        paper: "a4",
        header: [
            #set text(size: 10pt, baseline: 8pt, spacing: 3pt)
            #smallcaps[#course]
            #h(1fr) _ #title _
            #v(0.2em)
            #line(length: 100%, stroke: 0.7pt)
        ],
        footer: context [
            #set align(center)
            #grid(
                columns: (5fr, 1fr, 5fr),
                line(length: 100%, stroke: 0.7pt),
                text(size: 10pt, baseline: -3pt, 
                    counter(page).display("1")
                ),
                line(length: 100%, stroke: 0.7pt)
            )
        ]
    )

    #show raw.where(block: false): box.with(
        fill: luma(240),
        inset: (x: 3pt, y: 0pt),
        outset: (y: 3pt),
        radius: 2pt,
    )

    #let style-number(number) = text(gray)[#number]
    #show raw.where(block: true): it => {
        set text(font: ("Monaco", "Menlo"), size: 8pt)
        set par(leading: 7pt)
        h(0em); v(-1.2em)
        block(
            width: 100%,
            fill: luma(240),
            inset: 10pt,
            radius: 10pt,
            grid(
                columns: (10pt,400pt),
                align: (right, left),
                gutter: 0.5em,
                ..it.lines
                    .enumerate()
                    .map(((i, line)) => (style-number(i + 1), line))
                    .flatten()
            )
        )  
    }

    #set heading(numbering: (..args) => {
        let nums = args.pos()
        let level = nums.len()
        if level == 2 {
            numbering("一、", nums.at(1))
        } else if level == 3 {
            [#numbering("1.1", nums.at(1),nums.at(2))]
        } else if level == 4 {
            numbering("1.1.1", nums.at(1),nums.at(2),nums.at(3))
        } else if level == 5 {
            [#numbering("1.1.1.1", nums.at(1),nums.at(2),nums.at(3),nums.at(4))]
        }
    })

    #show heading.where(
        level: 1
    ): it => {
        set align(center)
        set text(weight: "bold", size: 20pt, font: "Source Han Serif SC")
        it
        h(0em) 
        v(-1.6em)
        hanging
    }

    #let line_under_heading() = {
        h(0em)
        v(-2.2em)
        line(length: 28%, stroke: 0.15pt)
    }

    #show heading.where(
        level: 2
    ): it => {
        set text(weight: "bold", size: 17pt, font: "Source Han Serif SC")
        set block(above: 1.5em, below: 20pt)
        it
        line_under_heading()
        fakepar
    }


    #show heading.where(
        level: 3
    ): it => {
        set text(weight: "bold", size: 13pt, font: "Source Han Serif SC")
        set block(above: 1.5em, below: 1em)
        it
    }

    #let thickness = 0.8pt
    #let offset = 4pt
    #let ubox(..) = box(
        width: 1fr,
        baseline: offset,
        stroke: (bottom: thickness),
    )
    #let uline(body) = {
        ubox()
        underline(
            stroke: thickness,
            offset: offset,
        )[#body]
        ubox()
    }

    #set list(
        marker: ([•], [▹], [–]),
        indent: 0.45em,
        body-indent: 0.5em,
    )

    #show list: it => {
        it
        fakepar
    }

    #show figure: it => {it; h(0em); v(-1.2em)}


    #show figure.caption: it => [
        #set text(size: 8pt, font: "LXGW WenKai Mono")
        图#it.counter.display(it.numbering)：#it.body
    ]

    = #title

    == 随便一个二级标题

    #figure(
        image("随便来点路径", width: 90%),
        caption: "随便一个标题"
    )

    *Question* #set text(font: "FZSongKeBenXiuKaiS-R-GB") 
    ：随便一个问题

    #set text(font: "Source Han Serif SC")
    *Answer* ：随便一个回答
    ```

这样更爽，只需要修改 `course` 和 `title` 就可以了，然后在每一个二级标题的下面我都设置了一个横线，看起来有力一点（
