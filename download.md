---
layout: page
title: "Download"
group: navigation
gallery: "ship/**/*.zip"
---

## Latest stable versions

| Version |   IDE  | Config    |    |
|---------|--------|-----------|----| {% for item in page.gallery_items %}
| {{ item | download_entry }}  | <a href="{{ item }}">download</a> | {% endfor %}


## Contribute

### You can download the latest stable [source version](https://github.com/jcangas/SummerFW4D/zipball/master)

### You can also clone the project using [Git](http://git-scm.com) by running:

```
  c:\>git clone git://github.com/jcangas/SummerFW4D
```

### Or better: login into Github and fork [this project](http://github.com/jcangas/SummerFW4D)!

