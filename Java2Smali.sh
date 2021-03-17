#!/bin/bash
#variables
a="${2##*/}"
b="${a%.*}"
line="$(grep "^package " $2.java)"
prm="${line//"package "/}"
spath="${prm//";"/}"
smalipath="${spath//./$'/'}"
checker="package []"
pkg="wget"
pkg1="zip"
apktoolsize=18871
apktool=/data/data/com.termux/files/home/apktool.jar
androidsize=45735
android=/data/data/com.termux/files/home/android.jar
d8size=22667
d8=/data/data/com.termux/files/home/d8.jar
#colors
purple="\033[0;35m"
cyan="\033[0;36m"
yellow="\033[1;33m"
red="\033[0;31m"
green="\033[0;32m"
white="\033[0;37m"
blue='\033[0;34m'


##########################
#  Checking Required Packages  #
##########################
if ! dpkg -s $pkg >/dev/null 2>&1; then
    pkg install $pkg -y &> /dev/null;
fi

if ! dpkg -s $pkg1 >/dev/null 2>&1; then
    pkg install $pkg1 -y &> /dev/null;
fi


###########################
# Checking Jars Are Valid Or Not #
###########################

requiredsize=$(du -k "$apktool" | cut -f 1)
if [ $requiredsize -le $apktoolsize ]; then
    echo -e "$yellow [×]Your apktool.jar Is Corrupted Downloading New...\n"
    rm ~/apktool.jar
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/apktool.jar -P ~
fi

requiredsize1=$(du -k "$android" | cut -f 1)
if [ $requiredsize1 -le $androidsize ]; then
    echo -e "$yellow [×]Your android.jar Is Corrupted Downloading New...\n"
    rm ~/android.jar
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/android.jar -P ~
fi

requiredsize2=$(du -k "$d8" | cut -f 1)
if [ $requiredsize2 -le $d8size ]; then
    echo -e "$yellow [×]Your d8.jar Is Corrupted Downloading New...\n"
    rm ~/d8.jar
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/d8.jar -P ~
fi


##########################
#          Checking Jars          #
##########################

if [ ! -f $HOME/android.jar ]; then
    echo -e "$purple [×]android.jar Not Found Downloading It"
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/android.jar -P ~
fi

if [ ! -f $HOME/d8.jar ]; then
    echo -e "$purple [×]d8.jar Not Found Downloading It"
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/d8.jar -P ~
fi

if [ ! -f $HOME/apktool.jar ]; then
    echo -e "$purple [×]apktool.jar Not Found Downloading It"
    wget https://raw.githubusercontent.com/Zylern/J2S_Files/master/apktool.jar -P ~
fi


#codes
clear
echo -e "$blue ╋╋┏┓╋╋╋╋╋╋╋╋┏━━━┳━━━┓╋╋╋╋╋┏┓"
echo -e "$blue ╋╋┃┃╋╋╋╋╋╋╋╋┃┏━┓┃┏━┓┃╋╋╋╋╋┃┃"
echo -e "$blue ╋╋┃┣━━┳┓┏┳━━╋┛┏┛┃┗━━┳┓┏┳━━┫┃┏┓"
echo -e "$blue ┏┓┃┃┏┓┃┗┛┃┏┓┣━┛┏┻━━┓┃┗┛┃┏┓┃┃┣┫"
echo -e "$blue ┃┗┛┃┏┓┣┓┏┫┏┓┃┃┗━┫┗━┛┃┃┃┃┏┓┃┗┫┃"
echo -e "$blue ┗━━┻┛┗┛┗┛┗┛┗┻━━━┻━━━┻┻┻┻┛┗┻━┻┛v2.0"
echo -e "$purple Project by Mahmud(@King_Mahmud_2005)"
echo -e "$blue Special thanks to Rahat(@BotXrahat){For d8 and r8 jar}\n Zylern(@Zylern){Design and Code Structure}""
echo -e "$yellow Always respect and love to Euzada(@euzada), Mhamad(@thestranger01), Qwerty(@qwerty_q101), Kirlif and Nijoo(@rockz5555)"
echo -e "$green Thanks to them for helping rise to the level i am currently on"
if [ $# -ne 2 ] ; then
echo -e "$white
Usage : bash $(basename "$0") -<OUTPUT-MODE> <JAVAFILE>
Options : 
-smali = Get output as .smali
-dex = Get output as .dex"
exit
fi
if test -f "$2.java"; then
    echo -e "$blue Compiling..."
    javac --release 8 -cp $HOME/android.jar $2.java
else
    echo -e "$red [×]Error File not found"
    echo -e "$white Check if the path is correct!"
    exit
fi
if test -f "$2.class"; then
    echo -e "$purple Dexing..."
    java -jar $HOME/d8.jar --release --no-desugaring --min-api 26 --lib $HOME/android.jar $2.class ; rm $2.class
else
    echo -e "$red [×]Error Compile failed! See logs for errors in java code!"
    echo -e "$white Try again after fixing"
    exit
fi
if [[ $1 = "-smali" ]]; then
echo -e "$blue Output Mode : Smali"
if test -f "classes.dex"; then
    echo -e "$cyan BakSmalling..."
    zip -q classes.zip classes.dex ; java -jar $HOME/apktool.jar -q d classes.zip ; rm classes.dex ; rm classes.zip
    if [[ $line=~$checker ]]; then
    mv classes.zip.out/smali/$smalipath/$b.smali $2.smali
    else
    mv classes.zip.out/smali/$b.smali $2.smali
    fi
    rm -rf classes.zip.out
else
    echo -e "$red [×]Error Something Went Wrong!"
    exit
fi
if test -f "$2.smali"; then
  echo -e "$green [✓]Output $2.smali"
  echo -e "$white Thanks for using"
  exit
else
  echo -e "$red [×]Error Something Went Wrong!"
  exit
fi
elif [[ $1 = "-dex" ]]; then
echo -e "$blue Output Mode : Dex"
if test -f "classes.dex"; then
Path="${2//"/$b"/}"
mv "classes.dex" $Path/classes.dex
echo -e "$green [✓]Output $Path/classes.dex"
echo -e "$white Thanks for using"
exit
else
echo -e "$red [×]Dex not found"
exit
fi
else
echo -e "$white No option passed"
fi
