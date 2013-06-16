# loot

## Introduction

loot is an object oriented template system for [Lua](http://www.lua.org/). loot uses a simple OOP implementation using metamethods. It can be found in oop.lua. 

loot provides a simple class called "base" which operates on a template string. It can contain several markers. Marker is a word surrounded by percentage signs. 
Use loot.template() function to create a new template class. 

    local loot = require "loot"
    greeting_template = loot.template "Hello, %username%!" -- creating a template class
    greeting_object = greeting_template{                   -- creating a template object
        username = "mrsmith"
    }
    greeting_text = greeting_object()                      -- parsing template
    print(greeting_text)                                   -- Hello, mrsmith!


### Advanced usage

When a template_object of is parsed, %marker% is substituted with template_object.marker. Due to OOP mechanics, template_object.marker can refer to field of template_object, field of template_class(the class of template_object) or field of any class template_class inherited from. 

If template_object.marker is a function, then it is called as method of template_object(the result is used to substitute the marker). This can be used to add complex behaviour to template. 

If template_object.marker is a table, then it is considered another template class. It is parsed and the result is used to substitute the marker. This can be used to build a structured system of linked templates. 

An example of these techniques can be found in test.lua.

## Reference

### loot.template(string || class)

Returns a new template class.
If the argument is a string, it's used as the template for the created class. 
If the argument is a class, it's used as the parent to inherit from. 

### template_class(table)

Creates a new object of the template class and initializes it with provided table of markers. 

### template_object()

Returns parsed template using markers provided to the template object. 

## Status

loot is still under development. 
