# com.epistimis.uddl.parent
Universal Data Definition Language

UDDL was developed as part of the Future Airborne Capability Environment (FACE) work originally commissioned by the US Navy and eventually supported by the USAF and USArmy.  Interest in UDDL generally resulted in a decision to split it out of FACE for general use.

The [current specification is available](https://publications.opengroup.org/standards/face/c198) for free after to you create an [OpenGroup](https://www.opengroup.org) account.

This code is based on that spec but is 'unofficial'. It does not use the namespace/packaging from the original spec which results in some minor modifications to OCL. It does not use the official .ecore model though the generated model should be compatible with it. Other than that, it should be functionally equivalent.

Note also that the syntax used in the project is mine alone - it is not part of the 'official' UDDL spec (the UDDL Query grammar is the same as the spec - but that's in a separate companion project to this one). The syntax choices here were based on following philosophy:

1. Use familiar paradigms where possible - but only if used in the same way. E.g., '{' and '}' are used for scoping just as they are in languages like C++
and Java.

2. Be succinct - every keystroke counts. Most of the keywords chosen are abbreviations of their names in the UDDL spec.

# Getting started

See the [Getting Started Guide](GETTING_STARTED.md) for info on setting up an Eclipse development environment. It will take you all the way to a working demo.

# Security and Bug Reports
For most bugs, create a GitHub issue. If you believe you have found a security issue, see [Security[(SECURITY.md) for reporting instructions.

# User Doc
We need user Doc! A draft will be provided soon in Markdown and linked here. Stay tuned!