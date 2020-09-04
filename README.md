# beamer_toolkit
my favourite latex beamer template and some tiny helper shell scripts


## getting started

clone this git, or download this folder as .zip and unpack

```
git clone https://github.com/acidbourbon/beamer_toolkit
cd beamer_toolkit

  - or (if you don't have git) -

wget https://github.com/acidbourbon/beamer_toolkit/archive/master.zip
unzip master.zip
cd beamer_toolkit-master
```

don't forget to install the required packages.

- latex (texlive)
- texlive-extra-utils
- xsel
- inotify-tools
- inkscape

on Ubuntu/Mint/Debian you can simply do:
```
sudo apt-get install texlive texlive-full texlive-extra-utils xsel inotify-tools inkscape
```


### "install" the helper scripts
go to the subfolder "shell_scripts" and make the contents executable,
then copy the scripts to your /home/<yourname>/bin folder. Create it,
if it does not exist:
```
cd shell_scripts
chmod +x *
mkdir -p $HOME/bin
cp * $HOME/bin
```
make sure $HOME/bin is in your $PATH. If needed, add the following to your .bashrc:
```
PATH=$HOME/bin:$PATH
```

### start the watch/compile loop
make loop.sh executable (if not already) and run it
```
chmod +x loop.sh
./loop.sh
```

if the compilation gets stuck (on a syntax error or a missing file),
you can either CTRL-C the whole loop - or (more elegantly)
enter "x" + RETURN in the latex compiler promt.

### edit slides.tex
Go ahead, fire up your favourite text editor and change some stuff in the tex file.
The pdf output file slides.pdf should automatically update for every change.
Mess around with the svg graphics in ./images/. This too should result in a change
of slides.pdf

### helper scripts
If the helper scripts are properly installed you should be able to generate a slide
with images directly from the command line:

```
graphicsframe images/spiral.pdf images/star.pdf
```
If the script works properly, the custom generated tex code should direcly land in your
clipboard.
