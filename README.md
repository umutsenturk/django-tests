# Django Tests

Python 3.7+ required for Pytest, 2.7+ required for django-admin test

## Installation

- Run setup.sh
- Copy `no_db_test_runner.py` to a django app in django project.

## Usage

#### Django Admin tests:

`tst -t d [-f <file_name>] [-n] [-r <runner_file_name> -rc <RunnerClassName>]`

#### Pytest:

`tst -t p [-f <file_name>] [-n] [-s <setting_file>] [-w <include_path_words>]`

## Parameters


|Parameter|Required|Test Type|Value Type|Default|Description|
|---------|:------:|:-------:|:--------:|:-----:|-----------|
|-t, --type|&#9745;|both|d\|django\|p\|pytest|empty|Type of test|
|-f, --file|&#9746;|both|string|*|Test file name. Script will find all `test_<file_name>.py` files|
|-n, --no-db|&#9746;|both|&#9746;|false|Disables test database and migrations|
|-w, --with|&#9746;|both|strings with space delimiter|empty|Script will find test files and filter their path with these keywords.|
|-p, --print|&#9746;|both|&#9746;|false|Print the test commands instead of running|
|-ff, --failfast|&#9746;|both|&#9746;|false|Stop the test run on the first error or failure|
|-k, --keepdb|&#9746;|both|&#9746;|false|Preserves the test database between runs|
|-s, --settings|&#9746;|both|string|settings|`settings` file name. If not provided, script will search an available `<settings_file>.py` file inside the directory.|
|-r, --runner|&#9746;|django|string|no_db_test_runner|Django Test Runner file name. Script will search an available `.py` file with that name|
|-rc, --r-class|if `-r`|django|string|NoDbTestRunnerFullPath|Django Test Runner Class name. Required to specify test runner.|



Examples are in `tst -h` command.