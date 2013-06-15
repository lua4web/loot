# loot
## Introduction
loot is an object oriented template system for [Lua](http://www.lua.org/). loot uses a simple OOP implementation using metamethods. It can be found in the oop.lua file. 

loot provides a simple class called "base" which operates on a template. Template is just a string. It can contain several markers. Marker is a word surrounded by percentage signs. 
For example, in template "Hello, %username%!" there is one marker - "username". 

In order to make a template class, inherit it from the "base" class and provide a template in its "template" field:

    greeting_template = class(base)
    greeting_template.template = "Hello, %username%!"

Create an instance of this class to use the template.

    greeting = greeting_template()

The "base" class provides a method "__build" which returns the template with markers substituted with corresponding fields of the object calling this method. The needed data can be provided directly or using object initialization method:

    greeting.username = "Mr. Smith"
    greeting = greeting_template{username = "Mr. Smith"} -- the same

Finally, the usage of the above mentioned method "__build":

    print(greeting:__build()) -- Hello, Mr. Smith!

The "template" function is a shortcut for creating a template class and passing a template string to it:

    greeting_template = template "Hello, %username%!"

Not only strings can be used as the values of fields used by markers. In case of the needed data being of type "table", it is considered another template class inherited from the "base" class. An instance of it is created and initialized with all the data the main template object holds. Then its method "__build" is called and the result is used to substitute the marker. 

If a function is a value of marker is a function, it is called as a method and result is used to substitute the marker. 

This allows to build a structured system of templates, with smaller ones being used as elements of top-level elements.

## Status
loot is still under development. Current version seems to parse structured templates correctly.

## TODO
1. Rewrite markers_iter() in C to improve performance
2. Write a comprehensive manual
3. Test possibilities of complex systems of templates
   
