{% assign recipe = site.data.recipes[include.recipe] %}
{% assign template = site.data.qubes[include.qube].template %}
{% if recipe.template_recipe %}
{% assign template_for_dispvms = 
### Template:
  {% include solution.md adminvm=include.adminvm qube=template recipe=recipe.template_recipe %}
{% endif %}
{% include recipes/{{ include.recipe }}.md adminvm=include.adminvm qube=include.qube %}
