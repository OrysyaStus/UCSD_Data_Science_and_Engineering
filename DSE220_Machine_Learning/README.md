## DSE-220

This is the official github repository of DSE 220 (Spring'17).

### Useful links for Git

* [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
* [Git for Beginners](https://www.sitepoint.com/git-for-beginners/)


### Jupyter Notebook Installation Instructions

Jupyter can be installed using Anaconda or pip. Anaconda is recommended for new users. 
You can follow the steps from [here](http://jupyter.readthedocs.io/en/latest/install.html).
Installation steps using Anaconda are also given below. Note that we prefer Python 3.6. All sample iPython notebooks will use Python 3.6.

**For Windows:**

Download the Anaconda installer from [here](http://continuum.io/downloads.html).
Double-click the Anaconda installer and follow the prompts to install to the default location.

NOTE: Install Anaconda to a directory path that does not contain spaces or unicode characters. Do not install as Administrator unless admin privileges are required. If you encounter any issues during installation, temporarily disable your anti-virus software during install, then immediately re-enable it. If you have installed for all users, uninstall Anaconda and re-install it for your user only and try again.

**For MacOS:**

* Download the command-line installer from [here](https://www.continuum.io/downloads).
* In your terminal window type one of the below and follow the instructions:

Python 3.6 version
```
bash Anaconda3-4.3.1-MacOSX-x86_64.sh 
```


**For Linux:**

* Download the command-line installer from [here](https://www.continuum.io/downloads).
* In your terminal window type one of the below and follow the instructions:

Python 3.6 version
```
bash Anaconda3-4.3.1-Linux-x86_64.sh
```

**Run the notebook**:
```
jupyter notebook
```
More detailed [here](http://jupyter.readthedocs.io/en/latest/running.html#running).

NOTE: If you face the 'jupyter: command not found' error, you should activate your conda environment using the command below (For anaconda3).

```
export PATH=~/anaconda3/bin:$PATH
```
**Running both Python 2.7/3.6 on same machine**:

If you wish to use both Python 2.7 and 3.6 on your system for some reason, it is possible using Anaconda 4.1.0 or later. You may update your Anaconda using the command:

```
conda update conda
conda update anaconda
```
Then, use the following commands to create two Python environments.

```
conda create -n py27 python=2.7 ipykernel
conda create -n py36 python=3.6 ipykernel
```
Now, you may go to your Jupyter Notebook and select the Python version you wish to use.

