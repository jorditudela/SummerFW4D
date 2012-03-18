---
layout: page
title: "Download"
group: navigation
gallery: "ship/**/*.zip"
---
{% include JB/setup %}

## Latest stable versions

{% for item in page.gallery_items %}
* <a href="{{ item }}">{{ item | download_entry }}</a>
{% endfor %}

{{ gallery_items }}

## Contribute

* You can download the latest stable source version:

<a href="https://github.com/jcangas/SummerFW4D/zipball/master"><img border="0" width="90" src="https://github.com/images/modules/download/zip.png"></a>

* You can also clone the project using <a href="http://git-scm.com">Git</a> by running:

```
  c:\>git clone git://github.com/jcangas/SummerFW4D
```

* Or better: login into Github and fork [this project](http://github.com/jcangas/SummerFW4D)!

