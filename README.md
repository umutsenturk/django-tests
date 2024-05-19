# Django Tests

## Requirements
- Bash 3+
- Python 3.7+ for Pytest
- Python 2.7+ django-admin test

## Installation

- Run setup.sh (linux) or copy tst into PATH. You can check path with `echo $PATH`
- Copy `no_db_test_runner.py` to a django app in django project.
- Close and open terminal again or `source $HOME/<rc_file>`, `.bashrc` `.zshrc` etc.

## Basic Usage

`tst [ -f <filename> ] [ -w <keyword> <keyword> <keyword> ] [ -k ] [ -ff ]`


## Parameters

|Parameter|Required|Test Type|Value Type|Default|Description|
|---------|:------:|:-------:|:--------:|:-----:|-----------|
|-h,<br> --help|&#9746;|both|||Display help message|
|-t,<br> --type|&#9746;|both|d\|django\|p\|pytest|empty|Type of test. Script will check automatically.|
|-f,<br> --file|&#9746;|both|string|*|Test file name. Script will find all `test_<file_name>.py` files|
|-n,<br> --no-db|&#9746;|both|&#9746;|false|Disables test database and migrations|
|-w,<br> --with|&#9746;|both|strings with space delimiter|empty|Script will find test files and filter their path with these keywords.|
|-p,<br> --print|&#9746;|both|&#9746;|false|Print the test commands instead of running|
|-ff,<br> --failfast|&#9746;|both|&#9746;|false|Stop the test run on the first error or failure|
|-k,<br> --keepdb|&#9746;|both|&#9746;|false|Preserves the test database between runs|
|-s,<br> --settings|&#9746;|both|string|settings|`settings` file name. If not provided, script will search an available `<settings_file>.py` file inside the directory.|
|-v,<br> --verbose|&#9746;|both|int|0|Verbose level|
|-r,<br> --runner|&#9746;|django|string|no_db_test_runner|Django Test Runner file name. Script will search an available `.py` file with that name|
|-rc,<br> --r-class|if `-r`|django|string|NoDbTestRunnerFullPath|Django Test Runner Class name. Required to specify test runner.|



Examples are in `tst -h` command.