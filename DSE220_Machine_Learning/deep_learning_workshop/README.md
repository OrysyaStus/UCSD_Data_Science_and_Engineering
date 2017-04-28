# Deep Learning
Supplemental files for the Deep Learning workshop, presented by the IDEA Student Center of UC San Diego.

## Requirements
We will be using the Keras package to write our Deep Learning models, with TensorFlow as the backend:
- python 3.5
- numpy
- matplotlib
- keras >= 2.0.0
- tensorflow >= 1.0.0
- jupyter

**NOTE:** Python 2.7 should work on macOS and Linux, but only Python 3.5 is supported for TensorFlow on Windows.


## Installation
If you previously installed Python using Anaconda (https://www.continuum.io/downloads), you can install the required packages using the following commands:

### macOS
1. open Terminal.app
2. run the following commands in the terminal (type each line and hit enter):
    1. create a new Anaconda environment: ``conda create -n deeplearning python=3.5 numpy scipy matplotlib jupyter pip``
    2. activate the environment: ``source activate deeplearning``
    3. install TensorFlow and Keras: ``pip install --upgrade tensorflow keras``

### Windows
1. open the Anaconda Command Prompt
2. run the following commands in the terminal (type each line and hit enter):
    1. create a new Anaconda environment: ``conda create -n deeplearning python=3.5 numpy scipy matplotlib jupyter pip``
    2. activate the environment: ``activate deeplearning``
    3. install TensorFlow: ``pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/windows/cpu/tensorflow-1.0.1-cp35-cp35m-win_amd64.whl``
    4. install Keras: ``pip install --upgrade keras``


### Linux
1. open a terminal program
2. run the following commands in the terminal (type each line and hit enter):
    1. create a new Anaconda environment: ``conda create -n deeplearning python=3.5 numpy scipy matplotlib jupyter pip``
    2. activate the environment: ``source activate deeplearning``
    3. install TensorFlow and Keras: ``pip install --upgrade tensorflow keras``


### Testing the installation
To test the installation (for macOS, Windows or Linux), run the following commands in the same terminal from above:
- start python and load TensorFlow: ``python -c "import tensorflow; print(tensorflow.__version__)"``
- start python and load Keras: ``python -c "import keras; print(keras.__version__)"``

You should see output similar to the following:
```bash
> python -c "import tensorflow; print(tensorflow.__version__)"
1.0.1
```

**NOTE:** Make sure you have the Anaconda environment activated before running the above test command. If you don't, the command will fail as it will not "know" where to look for the TensorFlow install.

### Common issues
- If TensorFlow fails to install, still try to install Keras (Keras defaults to TensorFlow for the backend, but can switch to Theano instead).
- On Windows, TensorFlow is only compatible with Python 3.5+.
- If you don't already have Python installed, we recommend installing it using the Anaconda distribution (https://www.continuum.io/downloads).
- If you are already familiar with Python and installing packages with pip, you can skip installing Python using Anaconda and instead install the requirements using pip (e.g. ``pip install numpy matplotlib jupyter tensorflow keras``).


### Non-Anaconda installation
If you did not previously install Python using Anaconda, then you can follow the installation instructions listed in the official documentation for:
- TensorFlow: https://www.tensorflow.org/install/
- Keras: https://keras.io/#installation


## Demos
Online demos:
- ConvNetJS: https://cs.stanford.edu/people/karpathy/convnetjs/
- Caffe: http://demo.caffe.berkeleyvision.org/
- Deep playground: http://playground.tensorflow.org/

Articles:
- https://cloud.google.com/blog/big-data/2016/07/understanding-neural-networks-with-tensorflow-playground

## Other TensorFlow and Keras tutorials
- https://github.com/aymericdamien/TensorFlow-Examples
- https://github.com/Hvass-Labs/TensorFlow-Tutorials
- https://www.oreilly.com/learning/not-another-mnist-tutorial-with-tensorflow
- Stanford course: https://web.stanford.edu/class/cs20si/syllabus.html
