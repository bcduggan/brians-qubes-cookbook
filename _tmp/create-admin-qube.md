---
title: Create admin qube
layout: default
adminvm-template: &adminvm-template adminvm-template
adminvm: &adminvm brian-adminvm
clone-template-for-adminvm:
  adminvm: dom0
  original-qube: *adminvm-template
  clone-qube: *adminvm
---
{%- include recipe.md ingredients=page.ingredients -%}
