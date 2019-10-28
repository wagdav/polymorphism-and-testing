# Testing and polymorphism

To build and run the tests:

    $ stack build --test

To run the retry example with an exponential back-off:

    $ stack exec retry-test-exe

The project contains:

* the code in [src/Lib.hs](src/Lib.hs)
* the tests in [test/LibSpec.hs](test/LibSpec.hs)
* the test application in [app/Main.hs](app/Main.hs)
