# Goto Function

Hi!

Welcome to GotoFonction! This script is a little function that allow you to moove quickly between different favorite directories. It is a really light script which is pretty usefull if you doesn't like (like me) to have 46 shells open at the same time.

In fact, it was just a dumb shell script untill a friend of mine tells me :
 - Hey! That's pretty cool, push it to GitHub pls!
 - Oh, why not

Then I got some PRs with good improvements so... Here we are ;)

## Installation

clone it:
```
git clone https://github.com/Nephylhim/gotoFonction.git
```

add source to your .whateverYouUseRC (already tested with bash/zsh):
```
source ~/path/to/gotoFonction/gotoFct.sh
```

source your bashrc/zshrc:
```
source ~/.bashrc
source ~/.zshrc
```

BTW I recommand you to add this incredible alias to your bashrc/zshrc: `echo "alias resource='source ~/.zshrc'" >> ~/.zshrc` (example with zsh)

Here you go buddy!

## Use it

**Use Help (soon in english):**
```
goto -h
```

**Add a favorite directory:**
```
goto -a <alias> <pwd> 
```
ex:
```
goto -a gotoFct /home/$USER/myScripts/gotoFonction
```
If you're in the gotoFct dir (same result):
```
goto -a gotoFct 
```

**List your favorite directories:**
```
goto -l
```

**Remove a favorite directory:**
```
goto -r <alias>
```

## Contributing

Feel free to contribute by open issues, open pull requests or even discuss with me ;)

This isn't a big project and I want it to be a friendly project.

See ya!

## Bonus

**Fonction?**:

Yeah, the name is GotoFonction. I'm french, I pushed it quickly and function is in French. Can you handle it?