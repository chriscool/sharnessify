# Sharnessify

Sharnessify contains scripts to easily add Sharness infrastructure to
a project.

## Purpose and Goal

[Sharness](https://github.com/mlafeldt/sharness/) is a great test
framework written in Shell. It is actively developed and comes from
Git itself.

Although you can embed Sharness files into your project, it is not so
easy to do it cleanly while making it possible to update these
Sharness files. Also some people don't want to mix the GPLv2 Sharness
files with their own files that are licensed differently.

That's why the goal of this project is to make it easy to cleanly
install Sharness support, so that Sharness files are separated from
other files and can easily be installed and updated.

## How it works

The `sharnessify.sh` script adds a Sharness install and update script
called `install-sharness.sh` and then runs it to install Sharness. A
`.gitignore` to ignore Sharness, a sample Sharness test script called
`t0000-sharness.sh` and a `Makefile` to run all the Sharness tests are
also added.

The `sharnessify.sh` script accepts an optional directory as
argument. Passing no argument is like passing `.`, that is the current
directory from which `sharnessify.sh` is run. This directory is where
the `sharness` directory will be created. And `sharnessify.sh` will
put everything it creates or fetches in this `sharness` directory.

This `sharness` directory will contain the following:

* `Makefile`: to run Sharness tests using simply `make`

* `t0000-sharness.sh`: a sample Sharness test, just to check that
  Sharness itself is working

* `lib` a directory that itself contains:

  - `install-sharness.sh`: a script to install and update Sharness

  - `sharness`: a directory where Sharness is cloned and updated

* `.gitignore`: a Git config file to tell Git to ignore
  `lib/sharness`, the directory where Sharness is cloned, and also the
  directories where Sharness runs the tests and stores their results

The above files that are not in the `sharness/lib/sharness` directory
are all MIT licensed, so it should not be a problem to add them to
your project. The `sharnessify.sh` script will perform a `git add` on
them, but will not `git commit` them. You should do that though to
finish the sharnessification.

## Updating Sharness

When the `install-sharness.sh` script is copied, the Sharness version
that this script should install is specified in the `version` variable
at the top of the `install-sharness.sh` script. This `version`
variable is set to the SHA1, also called object id, of the last Git
commit in the Sharness repository used to clone Sharness.

By default the Sharness repository used to clone Sharness is the
cannonical repository from GitHub
(https://github.com/mlafeldt/sharness.git). But you can use a local
repository instead by passing the `-l <local>`, or `--local <local>`,
option to `sharnessify.sh`. If you do that then this `<local>`
repository will also be used by `install-sharness.sh`, as it will be
specified in the `urlprefix` variable at the top of
`install-sharness.sh`.

So if you want to update Sharness, you only need to change the
`version`, and maybe also the `urlprefix` variables at the top of
`install-sharness.sh`. As the `Makefile` calls `install-sharness.sh`
before running the test scripts, Sharness will be updated the next
time the tests are run. Or you can update Sharness by directly running
`install-sharness.sh`.
