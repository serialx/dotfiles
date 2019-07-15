#!/bin/bash

keybase pgp export | gpg --import
gpg --edit-key F1870D7690DF681A
