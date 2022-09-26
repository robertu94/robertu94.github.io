# Guides

A list of more "how to" vs "how to learn" documents


{% assign guides = site.guides | sort : 'date' | reverse %}
<div class="home">
   
  <h1 class="page-heading">Most Recent Guides</h1>

  <ul class="post-list">
    {% for post in guides %}
      <li>
        <p>{{ post.date | date: "%b %-d, %Y" }}
			  <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title | escape }}
        </a></p>
      </li>
    {% endfor %}
  </ul>
