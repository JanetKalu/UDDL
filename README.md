# com.epistimis.uddl.parent
Universal Data Definition Language


**Your Interview will consist of improving the text formatting capability of the existing tool**

The Epistimis Toolkit consists of multiple layers. This repository contains only the first layer. The other layers
depend on it.  I have limited this repository to this layer to simplify the interview process.

This tooling is based on several Open Source tools. 

Your interview will consist of 
1. Installing the relevant open source tools according to the directions in this file
1. Reading some documentation about [XText document formatting](https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#formatting) and [XTend](https://www.eclipse.org/xtend/), the JVM based language being used.
1. Pull this repo and review the existing content of a program file (UddlFormatter.xtend) and a data file ( )
1. Modification of UddlFormatter.xtend so that the data file formats in a way that is visually appealing.
1. Creation of a new branch on this repo named after you. That branch should contain the changes you want me to review.  The commit description should explain any decisions you made. At a minimum you will need to modify UddlFormatter.xtend. You may find it useful to create or modify other files.

## Installing Relevant Open Source Tools.
1. This tooling is built using a collection of Eclipse based tools so the first thing you need to do is install [Eclipse](https://www.eclipse.org). Download the installer - you will need to click through several screens to pick the installer appropriate for you. You should be downloading Eclipse IDE 2022-12. 
When you start the installer, select **Eclipse IDE for Java and DSL Developers** (see screenshot)
![EclipseInstallerDSLSelection](https://user-images.githubusercontent.com/120406738/212499267-b34101e8-d71d-4831-a633-ffe6302e990f.png)
After selecting that, you should be presented witha dialog where you can select the JDK and installation folder:
![EclipseInstallerDSLChoices](https://user-images.githubusercontent.com/120406738/212499344-fea20154-97c1-414c-ae49-0c2eceffe44d.png)
1. Open Eclipse and select Help -> Eclipse Marketplace. This will bring up a dialog from which you can select additional tools to install. Install **Eclipse OCL 6.x**
1. You also need to install **[XText2Langium](https://github.com/TypeFox/xtext2langium)**. In Eclipse, select Help -> Install New Software. 
You should see something like this:
![Screenshot 2023-01-14 at 2 27 54 PM](https://user-images.githubusercontent.com/120406738/212499889-fa2d00ff-a3bd-43b6-9d6e-4cafc2528345.png)

Clicke **Add** and fill in the form like this:
* Name: XText2Langium
* Location: https://typefox.github.io/xtext2langium/download/updates/v0.3.0/

![Screenshot 2023-01-14 at 2 27 11 PM](https://user-images.githubusercontent.com/120406738/212499957-585f28bf-48d4-4111-8caa-1672594666ec.png)

Then click **Add** on that dialog and **Apply and Close**. That defines the feature source. You should now be back to this dialog:
![Screenshot 2023-01-14 at 2 36 14 PM](https://user-images.githubusercontent.com/120406738/212500196-f75f14c4-b176-4936-a371-06a52a319d6b.png)

4. Select **XText2Langium** in the `Work with` field, then select XText2Langium Generator Fragment as in the screenshot. Then select **Finish** to install it.

## Working on this code
When you opened Eclipse, you created a workspace. That workspace is where Eclipse expects the code you edit to be located. When you pull this repo from Github,
you can put it anywhere you want. ***I strongly recommend putting it in the Eclipse workspace you just created.*** While this is not absolutely required, if you 
do not do this, you will discover that when you edit files, they don't get stored where you think they should be (in the directory where the repo is). Instead, they
can get stored in the workspace. This will cause all sorts of mysterious build problems because the code that is being built won't be the code you are looking at.

After you pull this repo, you need to build the existing code. In Eclipse:

1. Select File -> Open Projects from File System and click on the **Directory** button to navigate to the root directory of the repo you just pulled 
![Screenshot 2023-01-14 at 2 43 30 PM](https://user-images.githubusercontent.com/120406738/212500480-8401fbc2-7e56-4719-b9f8-a2b2faec757f.png)

Then click **Open**. This will then populate the dialog like this:
![Screenshot 2023-01-14 at 2 43 58 PM](https://user-images.githubusercontent.com/120406738/212500507-27433f5c-a80d-41aa-8ead-ae0a0791960b.png)

You should see the parent project and 8 nested projects. They should all be selected. Then click **Finish**. 

1. The repository does not store every file that the project uses. Some need to be generated. Open /com.epistimis.uddl/src/com/epistimis/uddl/Uddl.xtext (see screenshot)
![Screenshot 2023-01-14 at 5 42 21 PM](https://user-images.githubusercontent.com/120406738/212508222-bf4b4003-a1e4-4c32-b1e8-067ce2daed04.png)

then right click in the edit window to bring up the context menu and select Run As -> Generate XText Artifacts
![Screenshot 2023-01-14 at 5 42 44 PM](https://user-images.githubusercontent.com/120406738/212508587-4423c56a-28e9-41de-920d-46c2eced07ca.png)

You should see results in the Console pane similar to those in the screenshot. ***If you do not, send me the content of your console window so I can figure out what happened***

If everything completed successfully, you will be able to launch a second copy of Eclipse that will run the code you just generated. 
To do that select Run -> Run Configurations. You will see something like this:
![Screenshot 2023-01-14 at 5 50 38 PM](https://user-images.githubusercontent.com/120406738/212510514-a8ee4b8a-4867-455a-93f2-66e6e4f6910a.png)

Select Eclipse Application and then click the 'New' icon (the leftmost icon in the icon row in the upper left - it has the + sign) to create a new launch configuration.
You can use the defaults (rename it if you want) - just click **Run**. This will launch a second Eclipse. 

In that second Eclipse, 
1. create a new blank project (File -> New -> Project or File->New->Other->General->Project) and  click **Next**. 
1. Give it a name and click **Finish**. 
1. Then copy the following file from the first Eclipse to the new project: 
```
/com.epistimis.uddl.tests/src/com/epistimis/uddl/tests/UDDL_SDM_Min.uddl
```
1. Open the UDDL file in the new project.
1. Select the edit window, and use Cmd-Shift-F on Mac or Alt-Shift-F on Windows to format the file. 

## Modifying the code
The code that formats the UDDL file can be found in 
```
/com.epistimis.uddl/src/com/epistimis/uddl/formatting2/UddlFormatter.xtend
```
It already contains a lot of work - but it is not yet complete. Nor is the sample UDDL file.  Your task is to use what you see as an example and extend 
the code to properly format A) Everything you see in the existing UDDL file; B) A larger UDDL file that contains at least 3 of each of the things described
in the Uddl.xtext file.  

Note that the exaxmple UDDL file you see is already partially formatted. That won't always be the case. You should create sample files that take worst case 
formatted files (there are at least 2 worst cases - at opposite ends of the spectrum) and make sure your formatting works on them as well. You can create 
those worst case formatted files starting from the sample file if you want.

## What you should submit
Take as long as you want creating test files, and updating and testing your code changes. I don't expect you to completely finish though you're certainly 
welcome to if you want. When you decide to stop, create a branch named after yourself and a pull request that includes your code changes and any additional 
test UDDL files you created. You should add a text/.md file describing what you did, why you did it, how long it took and anything else you want me to know.
Feel free to include info on any additional research you needed to do.

## What I'm looking for

1. Can you figure out what test files you need? And a good way to create them?
1. What code changes did you make? Do they work? What do they do? What do they look like?

## ***NOTE*** I have not included with this any documentation explaining what the content of the UDDL means. It isn't necessary for the purpose of this exercise.
Your focus is on making the file format properly.  If you do happen to figure it out, let me know what you found.
