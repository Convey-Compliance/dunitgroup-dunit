EPC DUnit Plug-In for Delphi 5-7
================================

Thanks for installing our software. This file contains information about support, compilation and usage of the plug-in. You can find this file in the root directory of your installation. 

This plug-in works in conjunction with DUnit. If DUnit isn't installed, please download and install from http://dunit.sourceforge.net/ before compiling projects created by this plug-in.

SUPPORT

If you have any issues with the plug-in, or wish to be notified of updates, please join and post to our support mailing list.  Follow the Support link from http://xpro.com.au

For issues relating to using DUnit, please join the mailing lists at https://sourceforge.net/projects/dunit/

COMPILING

Go to the Wizard subdirectory within your installation and load the appropriate project group into the Delphi IDE, ie *50.bpg for Delphi5, *60.bpg for Delphi6, and  *70.bpg for Delphi7. This plug-in has not yet been ported to Kylix.

Build all the projects in the project group (MainMenu|Project|Build All Projects). Open the Project Manager (MainMenu|View|ProjectManager), right click the EPCDUnitWizard.bpl target and click 'Install' on the popup menu. 

After successful installation, a new item "DUnit" will appear on the IDE main menu, and two new items in the File|New... applet

USAGE

The IDE 'project group' and 'current project' are central concepts to effectively using this plug-in. The project group and all contained projects are visible in the IDE's Project Manager (MainMenu|View|Project Manager). The current project is highlighted in bold text, and can be switched by double-clicking on another project. I find it convenient to use Delphi's desktop feature and dock the Project Manager next to the IDE editor, so the Project Manager is always visible whenever I am using Delphi.

To start using the plug-in, select the menu item "DUnit" from the Delphi IDE main menu.
There are two functions:
1) "New Project..." to produce the skeleton code for a new DUnit project (GUI or console mode)
2) "New TestCase..." to produce the skeleton code for a new DUnit test case class

On selecting either item, a dialog will pop-up, prompting you for a name and location for the new project or test case. 

New Project
===========

When you select  "New Project...", the wizard takes note of the currently selected project in the IDE, and suggests a new project and location (folder) based on this value. You are free to override the suggestion. 

For example, the current project in the IDE is: "c:\Projects\MyApp.dpr" 
The suggested DUnit Project would be: "c:\Projects\dunit\MyAppTests.dpr"
The wizard is suggesting a project with a name suffix of "Tests" to be created in a sudirectory of the current project directory, named "dunit".
The wizard will automatically create any directories as needed.

If you have saved the current project group, ie it isn't the default $(DELPHI)\Bin\ProjectGroup1, then the new DUnit project will be added to the current project group. Otherwise the current project will be closed and the new DUnit project opened.

To switch between GUI and console DUnit projects, read the comments at the top of each DUnit project file (.dpr) and add or remove the comment bars from the {$APPTYPE CONSOLE} line accordingly.

New TestCase
============

When you select  "New TestCase...", the wizard takes note of the currently selected unit and project in the IDE, and suggests a new unit and location (folder) based on this value. You are free to override the suggestion. 
 
For example, the current project in the IDE is: "c:\Projects\dunit\MyAppTests.dpr" 
the current unit in the IDE is "c:\Projects\Source\MyClass.pas"
The suggested DUnit TestCase would be: "c:\Projects\Source\dunit\MyClassTests.dpr"
The wizard is suggesting a TestCase with a name suffix of "Tests" to be created in a sudirectory of the current unit's directory, named "dunit".
The wizard will automatically create any directories as needed.

** NOTE: The new TestCase will always be added to the *current* project, so ensure that your DUnit project is the current project in the IDE whenever you create a new TestCase. Read the notes about the Project Manager at the start of this USAGE section.

$Id: README.txt,v 1.1 2003/01/27 12:48:26 pvspain Exp $