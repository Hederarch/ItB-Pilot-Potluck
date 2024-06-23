![ItBPP-export](https://github.com/Hederarch/ItB-Pilot-Potluck/assets/66890769/5cefd1b7-9091-4dad-bd69-1b7b211276db)
**A community project commemorating the Into the Breach modding server**

# For Players
TODO WHEN MOD RELEASES

# For Modders
Hello, and welcome to the pilot potluck! This here will be your guide to adding yourself into *Into the Breach*!
First things first, if you ever need help, head over to the Into the Breach discord and find the Pilot Potluck thread in #modding-creation. That will be your one-stop shop for help on art, programming, or github. Send a message in there and someone will help you!
## Cloning
The first step is to clone this github repo (repository) into your mods folder. If you haven't used github before, there's lots of tutorials online, but we're also happy to help you. I can't write out an entire tutorial on it because there are many different ways to set it up, and how you do it is up to you. You can also just download a copy of the repo, and then submit a PR on the github website when you're done, but that will have some potential issues with versions, so if you can get it cloned, that would be best!
A github tip: Make sure that you pull as often as possible. This will ensure that you're on the latest version and prevent merge conflicts
## Creating your Pilot
There are three main types of pilots, and this section will go over generally how to create these different types. All of the template files have code comments in them as well to guide you. And you're always welcome to do your own thing too! (as long as it stays organized)
Use the other pilots in the mod and from other mods as a guideline on your way.
### An Important Step
The first and most important step is to add your pilot to the automation. In `scripts/pilots/init.lua`, add your pilot to the `pilotnames` table on line 6, using the format given, generally `["Pilot_Name"] = "Name",`. It's important that `Pilot_Name` is the same as your file name. ex: `pilot_name.lua`. If it's not, your pilot will not be properly initialized.
Create a copy of one of the templates, and name it the same as your table entry, as shown above. The below three headers describe the three basic templates for pilots. Each one has comments to guide you through the template.
### "Normal" Skills
"Normal" Skills can be created using the `pilot_template.lua` file. Here, you can fill out the information and add hooks to trigger effects when you want.
### Replace Repair Skills
Replace Repair Skills are much like making a weapon. Use the `pilot_template_rr.lua` file as a template, and fill out the information. Besides a few things, it should mostly be just like creating a weapon.
### Move Skills
Move Skills can be created using the `pilot_template_move.lua` file. Much like the replace repair, it's just like creating a weapon skill, except for a move instead. As with the others, fill out the comments given and use other pilots as an example if you're struggling.
### Art
Pilot portraits should go in `img/portraits` and replace repair icons should go in `img/weapons`, but besides that, everything else can got where you best see fit. If you want to request art, either pilot portraits or other vfx, head to the Pilot Potluck thread.
You don't need to worry about appending your pilot portraits, but any other art needs to be appended in the init portion of your pilot file.
## Creating a PR (Pull Request)
The best way to add your pilot code is to create a pull request on github for the repo. This will let us review your code and suggest changes before merging it into the main mod. Usually, this involves creating a branch and then submitting the PR, where it will show up on our end. Same with cloning, there's tons of information online, but if you ever need assistance, head to the Pilot Potluck thread.
You can alternatively send us your pilot file in the thread, but if your file has issues, it'll be harder to deal with on its own then with a PR, and you'll be unable to make easy changes to files outside of your own pilot file.
## Libraries
If you ever want a library added for a pilot, you have two options
1. Follow the format that the other libraries follow and add it into your PR. Your PR will be requested for changes if the library does not properly follow the format of the other libraries
2. Ping @NamesAreHard in the Pilot Potluck thread, and I'll add it in for you!

## Need Help?
Message the Pilot Potluck thread! Please keep it in that thread to keep help in one place, and to help others who might be going through the same issues. If you need immediate help: ping @Hedera for art, concept, or coding help, and ping @NamesAreHard for coding, template, and mod structure help.
