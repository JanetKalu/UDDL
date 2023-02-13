
**Your Interview will consist of improving the text formatting capability of the existing tool**

The Epistimis Toolkit consists of multiple layers. This repository contains only the first layer. The other layers
depend on it.  I have limited this repository to this layer to simplify the interview process.

This tooling is based on several Open Source tools. 

Your interview will consist of 
1. Installing the relevant open source tools according to the directions in this file
1. Reading some documentation about [XText document formatting](https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#formatting) and [XTend](https://www.eclipse.org/xtend/), the JVM based language being used.
1. Building this repo and its dependency (com.epistimis.uddl.query) and reviewing the existing content of a program file (UddlFormatter.xtend) and a data file (UDDL_SDM_Min.uddl )
1. Modification of UddlFormatter.xtend so that the data file formats in a way that is visually appealing.
1. Creation of a pull request that contains the changes you want me to review.  The commit description should explain any decisions you made. At a minimum you will need to modify UddlFormatter.xtend. You may find it useful to create or modify other files.

## Getting Started
See [the Getting Started Guide](GETTING_STARTED.md) for info on setting up your development environment

## Modifying the code
The code that formats the UDDL file can be found in 
```
/com.epistimis.uddl/src/com/epistimis/uddl/formatting2/UddlFormatter.xtend
```
It already contains a lot of work - but it is not yet complete. Nor is the sample UDDL file.  Your task is to use what you see as an example and extend the code to properly format 
- [ ] Everything you see in the existing UDDL file; 
- [ ] One or more larger UDDL files that contains at least 3 of each of the things described in the Uddl.xtext file.  

Note that the example UDDL file you see is already partially formatted. That won't always be the case. You should create sample files that take worst 
case formatted files (there are at least 2 worst cases - at opposite ends of the spectrum) and make sure your formatting works on them as well. You 
can create those worst case formatted files starting from the sample file if you want.

## What you should submit
Take as long as you want creating test files, and updating and testing your code changes. I don't expect you to completely finish though you're certainly 
welcome to if you want. When you decide to stop, create a pull request that includes your code changes and any additional 
test UDDL files you created. You should add a text/.md file describing what you did, why you did it, how long it took and anything else you want me to know.
Feel free to include info on any additional research you needed to do.

## What I'm looking for

1. Can you figure out what test files you need? And a good way to create them?
1. Why did I say that larger UDDL files should contain at least 3 of each of the things?
1. What are worst cases - and why are they worst cases? Are there more than 2?
1. What code changes did you make? Do they work? What do they do? What do they look like?

## ***NOTE*** 
I have not included with this any documentation explaining what the content of the UDDL means. It isn't necessary for the purpose of this exercise.
Your focus is on making the file format properly.  If you do happen to figure out what UDDL does, let me know what you found. That's bonus points.
