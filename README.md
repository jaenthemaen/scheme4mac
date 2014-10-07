Scheme 4 Mac
==========

A simple Scheme interpreter written in Objective-C for OS X > 10.6.
Created along the course *Design And Implementation Of Advanced Programming Languages*, held in summer 2014 by Claus Gittinger at Stuttgart Media University.

## Overview

![Scheme 4 Mac UI](/img/Scheme4MacUI.png?raw=true "Scheme 4 Mac UI")

Enter your Scheme code in the input field, press eval and see the result in the ouput field. There are two more buttons available. One empties the output view and the other one resets the global environment used in the evaluator. The global environment persists between consecutive evaluation runs until the reset environment button is pressed.

Furthermore, there are two keyboard shortcuts available:

- **⌘+Backspace:** Empties the input view.
- **⌘+Enter:** Evaluates the input view as is.
 
## Scheme Language Features

The following parts of the Scheme syntax are supported with this interpreter:

- **define** : Both simple defines as well as lambda shorthand syntax are supported.
- **begin** : Evaluates all expressions handed to it consecutively
- **lambda** : Takes an argument list and an expression body. The latter may not be nil.
- **cons** : Creates a new pair taking two objects.
- **car** : Takes a pair and returns its car.
- **cdr** : Takes a pair and returns its cdr.
- **set-car!** : Takes a pair and a value and sets the pairs car to the value.
- **set-cdr!** : Takes a pair and a value and sets the pairs cdr to the value.
- **list** : Takes multiple arguments and returns a linked list of these or nil, if arguments are absent.
- **vector** : Takes multiple arguments an returns a vector holding all arguments, or an empty vector if arguments are absent.
- **vector-copy** : Takes a vector and returns a copy of it.
- **vector-length** : Takes a vector and returns the count of its elements.
- **vector-ref** : Takes a vector and an index and returns, if the index is valid, the according element of the vector.
- **vector-set!** : Takes a vector, an index and a value and sets, if the index is valid, the value at the according index in the vector.
- **if** : Takes a condition, expressions for both the true and false case and evaluates either of which after evaluating the condition.
- **let** : Takes a list of argument bindings and multiple epressions as body. Creates new environment where it stores the evaluated bindings and on which it evaluates the body expressions.
- **let*** : Similar to normal **let** but with cascading environments for the variable bindings, meaning: The variable bindings are evaluated sequentially each in its own new environment, whose parent environment is the one of the previous binding, so that i.e. the second variable binding can access the first variable bound.
- **set!** : Takes a symbol and a value and sets the symbol to the value in the current environment, if it is bound already.
- **type checks** : returns true or false whether the handed object is of the requested type.
  - **vector?**
  - **pair?**
  - **boolean?**
  - **list?**
  - **string?**
  - **positive?**
  - **negative?**
- **eq?** : Takes two objects and checks if they are of the same type and have the same value. Also works recursively for vectors and lists.
- **display** Takes an expression and prints out the evaluated result in the ouput view.

There are also a couple of builtin functions available:

- **numeric operations:**
  - **+**
  - **-**
  - **/**
  - **\***
  - **%**
  - **>**
  - **>=**
  - **<**
  - **<=**
  - **=**
- **logic operations:**
  - **and**
  - **or**
  - **not**

## Internals And Future Work Planned

The reader, evaluator and printer are all working recursively as of now. Even though several attempts were made, a reliable implementation of continuations could not be achieved in time. If there is enough time in the near future the implementation of continuations will be revisited. 

Also there are many more syntax and builtin functions to be implemented.

