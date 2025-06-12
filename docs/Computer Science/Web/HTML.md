# HTML

!!! Abstract 
    这是我的HTML笔记。

    为啥要学HTML？

    都学计算机了，总得学点前端吧。况且对于一个强迫症而言，我需要合适的工具来改进排版。

!!! Info
    HTML（HyperText Markup Language）是用来描述网页的一种**标记语言**。标记语言使用一套**标记标签**来描述内容。

## 01 HTML基础

### 01.1 HTML基本结构

下面是一个完整的HTML页面：

```html
<!DOCTYPE HTML>
<html>
    <head>
        <meta charset="utf-8">
        <title> 第一个HTML页面 </title>
    </head>

    <body>
        <h1> 第一个标题 </h1>
        <p> 第一个段落 </p>
    </body>
</html>
```

其中：
- `<!DOCTYPE HTML>` 声明了文档类型，为HTML5文档。
- `<html>` 元素是HTML页面的根元素，定义了整个HTML文档。
- `<head>` 元素包含了文档的元（meta）数据，如标题、链接到外部样式表等。
- `<meta charset="utf-8">` 这就是一个元数据，定义了网页的编码格式为**UTF-8**。
- `<title>` 元素描述了文档的标题。
- `<body>` 元素包含了可见的页面内容，定义了HTML文档的主体。
- `<h1>` 元素定义了一个大标题，这是最高级的标题，`<h6>` 定义了最低级的标题。
- `<p>` 元素定义了一个段落。

我们能看出来，HTML标签是由尖括号包围的关键词，比如`<html>`，并且大多数标签都是**成对出现**的，比如`<html>`和`</html>`，其中前者是**开始标签/开放标签**，后者是**结束标签/闭合标签**。

HTML元素和HTML标签表示的是一样的意思，但是严格来说，HTML元素包括了开始标签和结束标签，元素的内容就是标签之间塞进去的部分。

下面就是一个可视化的HTML页面结构：

<div style="width:99%;border:1px solid grey;padding:3px;margin:0;background-color:#ddd">&lt;html&gt;
<div style="width:90%;border:1px solid grey;padding:3px;margin:20px">&lt;head&gt;
<div style="width:90%;border:1px solid grey;padding:5px;margin:20px">&lt;title&gt;页面标题&lt;/title&gt;
</div>
&lt;/head&gt;
</div>
<div style="width:90%;border:1px solid grey;padding:3px;margin:20px;background-color:#fff">&lt;body&gt;
<div style="width:90%;border:1px solid grey;padding:5px;margin:20px">&lt;h1&gt;这是一个标题&lt;/h1&gt;</div>
<div style="width:90%;border:1px solid grey;padding:5px;margin:20px">&lt;p&gt;这是一个段落。&lt;/p&gt;</div>
<div style="width:90%;border:1px solid grey;padding:5px;margin:20px">&lt;p&gt;这是另外一个段落。&lt;/p&gt;</div>
&lt;/body&gt;
</div>
&lt;/html&gt;
</div><br>

### 01.2 最基础的语法

- 标题：标题是通过`<h1>`到`<h6>`标签来定义的，`<h1>`是最大的标题，`<h6>`是最小的标题。

    ```html
    <h1> 最大的标题</h1>
    <h2> 次大的标题</h2>
    <h3> 更小的标题</h3>
    ```

- 段落：段落是通过`<p>`标签来定义的。

    ```html
    <p> 这是一个段落。</p>
    <p> 这是另外一个段落。</p>
    ```

- 链接：链接是通过`<a>`标签来定义的，在href属性中指定连接的URL。

    ```html
    <a href="http://www.baidu.com"> 这是一个链接</a>
    ```

- 图像：图像是通过`<img>`标签来定义的，通过src属性指定图像的URL。图像的名称和尺寸是通过属性的方式指定的。

    ```html
    <img src="/images/logo.webp" width="258" height="39" />
    ```

### 01.3 HTML元素

HTML元素以开始标签开始，以结束标签终止，结束标签里边会塞一个斜杠`/`，中间塞的就是元素内容。值得注意的是：

- 某些标签具有**空内容**；
- 大多数元素可以具有**属性**；
- 空元素在开始标签就进行关闭；
- HTML元素可以嵌套，HTML文档就是由嵌套的元素构成的。

没有内容的HTML元素称为空元素，空元素在开始标签内关闭。比如定义换行的标签`<br>`就是没有关闭标签的空元素。尽管空元素给我们一种错觉，似乎空元素就不用关闭了，但是在开始标签内添加一个斜杠才是空元素的正确关闭方式，比如`<br />`，虽然现在的标准与当前的浏览器对于`<br>`都是有效的，但是XHTML、XML和未来版本的HTML都要求所有元素必须关闭。

HTML标签对于大小写不敏感，`<P>`和`<p>`是一样的，甚至很多网站都使用大写的HYML标签。但是标准推荐小写，并且在XHTML和未来版本的HTML中，都**强制使用小写**。

### 01.4 HTML属性

对于HTML属性，有下面信息：

- HTML元素可以设置属性；
- 属性可以在元素中添加附加信息；
- 属性一般描述于**开始标签**；
- 属性一般是以键值对的形式出现，比如`name="value"`；

我们拿链接元素来举例：

```html
<a href="http://baidu.com">这是定向到百度的超文本链接</a>
```

属性值应该始终被包括在引号之内，双引号是最常用的，但是单引号也可以，如果属性值本身就有了双引号，那么必须在外边使用单引号。

