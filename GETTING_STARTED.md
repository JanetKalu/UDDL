# Getting Started Guide


## Installing Relevant Open Source Tools.
1. Install a current version of the Java JDK. You can download [Temurin, an open source JDK from this page](https://www.eclipse.org/downloads/).
2. Install [Gradle](https://gradle.org). There is a version installed with Eclipse but it isn't current - and you'll need the current version.
3. Install [Eclipse](https://www.eclipse.org). Download the installer - you will need to click through several screens to pick the installer appropriate for you. You should be downloading Eclipse IDE 2022-12. 
When you start the installer, select **Eclipse IDE for Java and DSL Developers** (see screenshot)

![EclipseInstallerDSLSelection](https://user-images.githubusercontent.com/120406738/212499267-b34101e8-d71d-4831-a633-ffe6302e990f.png)

After selecting that, you should be presented witha dialog where you can select the JDK and installation folder:

![EclipseInstallerDSLChoices](https://user-images.githubusercontent.com/120406738/212499344-fea20154-97c1-414c-ae49-0c2eceffe44d.png)

1. Open Eclipse and select Help -> Eclipse Marketplace. This will bring up a dialog from which you can select additional tools to install. Install **Eclipse OCL 6.x**. Also install **EMF Compare**. Restart Eclipse after the installs complete. 

2. You also need to install **[XText2Langium](https://github.com/TypeFox/xtext2langium)**. In Eclipse, select Help -> Install New Software. 
You should see something like this:

![Screenshot 2023-01-14 at 2 27 54 PM](https://user-images.githubusercontent.com/120406738/212499889-fa2d00ff-a3bd-43b6-9d6e-4cafc2528345.png)

Clicke **Add** and fill in the form like this:
* Name: XText2Langium
* Location: https://typefox.github.io/xtext2langium/download/updates/v0.4.0/

![Screenshot 2023-01-14 at 2 27 11 PM](https://user-images.githubusercontent.com/120406738/212499957-585f28bf-48d4-4111-8caa-1672594666ec.png)

Then click **Add** on that dialog and **Apply and Close**. That defines the feature source. You should now be back to this dialog:

![Screenshot 2023-01-14 at 2 36 14 PM](https://user-images.githubusercontent.com/120406738/212500196-f75f14c4-b176-4936-a371-06a52a319d6b.png)

4. Select **XText2Langium** in the `Work with` field, then select XText2Langium Generator Fragment as in the screenshot. Then select **Finish** to install it. If you cannot click on **Finish**, select **Next** to bring up the next dialog from which you can select **Finish**

## Working on this code
When you opened Eclipse, you created a workspace. That workspace is where Eclipse expects the code you edit to be located. When you pull this repo from Github,
you can put it anywhere you want. ***I strongly recommend putting it in the Eclipse workspace you just created.*** While this is not absolutely required, if you 
do not do this, you will discover that when you edit files, they don't get stored where you think they should be (in the directory where the repo is). Instead, they
can get stored in the workspace. This will cause all sorts of mysterious build problems because the code that is being built won't be the code you are looking at.

You need 2 repos:
`com.epistimis.uddl.query`
`com.epistimis.uddl`

They should be built in that order

After you pull this repo, you need to build the existing code. In Eclipse:

1. Select File -> Open Projects from File System and click on the **Directory** button to navigate to the root directory of the repo you just pulled 

![Screenshot 2023-01-14 at 2 43 30 PM](https://user-images.githubusercontent.com/120406738/212500480-8401fbc2-7e56-4719-b9f8-a2b2faec757f.png)

Then click **Open**. This will then populate the dialog like this:

![Screenshot 2023-01-14 at 2 43 58 PM](https://user-images.githubusercontent.com/120406738/212500507-27433f5c-a80d-41aa-8ead-ae0a0791960b.png)

You should see the parent project and 8 nested projects. They should all be selected. Then click **Finish**. 

2. The repository does not store every file that the project uses. Some need to be generated. Before you do anything else, you must make sure the **Java Build Path** is properly set up for every project. Right click on the project in the project explorer and select **Properties** from the context menu:

![Screenshot 2023-01-15 at 8 15 32 AM](https://user-images.githubusercontent.com/120406738/212552934-e319f454-ee76-425e-ac69-535771c5e519.png)

The select **Java Build Path** (you can type it in the text field at the upper left of the dialog to narrow the choices) and then select the **Libraries** tab. Under the **Classpath** choice you should see **Plug-in Dependencies**.

![Screenshot 2023-01-15 at 8 16 34 AM](https://user-images.githubusercontent.com/120406738/212552898-99a08014-8109-4ae1-9512-b3160c06f918.png)

If you do not, click the **Add Library...** button to get:

![Screenshot 2023-01-15 at 8 16 56 AM](https://user-images.githubusercontent.com/120406738/212552883-f4d887d3-526a-4c30-9b8d-b621e8f48d48.png)

Select **Plug-in Dependencies** in the dialog, then click **Next** and **Finish**

3. Open /com.epistimis.uddl/src/com/epistimis/uddl/Uddl.xtext (see screenshot)
![Screenshot 2023-01-14 at 5 42 21 PM](https://user-images.githubusercontent.com/120406738/212508222-bf4b4003-a1e4-4c32-b1e8-067ce2daed04.png)

then right click in the edit window to bring up the context menu and select Run As -> Generate XText Artifacts

![Screenshot 2023-01-14 at 5 42 44 PM](https://user-images.githubusercontent.com/120406738/212508587-4423c56a-28e9-41de-920d-46c2eced07ca.png)

You should see results in the Console pane similar to those in the screenshot. ***If you do not, create an issue and include the content of your console window so I can figure out what happened***

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

At this point, you've got enough working that you can begin modifying code. See the issues for what needs to be done.

Before you do much coding, consider reading the [Notes on Tools](NOTES_ON_TOOLS.md) in addition to the tool doc itself.

### Tool Doc to reference:
* [XText](https://www.eclipse.org/Xtext/)
* [XTend](http://xtend-lang.org)
* [Sirius](https://www.eclipse.org/sirius/)
* [EMF](https://www.eclipse.org/modeling/emf/)

And Thanks for your interest and help!

