---
layout: page
title: Presentations
permalink: /presentations/
---


{% assign presentations = site.presentations | sort : 'date' | reverse %}
{% for presentation in presentations %}

{% if presentation.nolinks %}
{% assign url = '#' %}
{% elsif presentation.slides %}
{% assign url = site.url | append: "/static/presentations/" | append: presentation.slides  %}
{% else %}
{% assign url = presentation.url | append:  ".html" %}
{% endif %}

## [{{ presentation.title }}]({{ url }})

{{ presentation.location }} - {{ presentation.date | date : "%B %Y" }}
 
{{ presentation.description -}}
<em>{{presentation.acknowledgments}}</em>

{% if presentation.nolinks -%}
slides and video are not yet available for this talk
{% else %}
{% if presentation.video -%}
[video]({{ presentation.video }}), 
{% endif -%}
[slides]({{ url }})
{% endif -%}

{% endfor %}


