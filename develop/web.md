---
---
{% raw %}
### General tips
- Whenever you create a form that alters data server-side, use method="post".
- You should always return an HttpResponseRedirect after successfully dealing with POST data.

### Django tips
- All POST forms that are targeted at internal URLs should use the {% csrf_token %} template tag.
{% endraw %}
