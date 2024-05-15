#!/bin/bash

usage() {
    echo -e "\033[32mUsage:\033[0m tst -t <test_name> [-f <file_name>|*] [-n] ..."
    echo -e "  -h, --help                    Display this help message"
    echo -e "  -t, --test       <test_name>  Run a specific test"
    echo -e "                                Options: \033[31m[p]ytest, [d]jango\033[0m"
    echo -e "  -f, --file       <file_name>  Run a specific file, space is not allowed"
    echo -e "                                Script will check 'test_<file_name>.py' files."
    echo -e "                                So, \033[31menter 'serializers' to run"
    echo -e "                                'test_serializers.py' tests.\033[0m Use * to run all"
    echo -e "                                tests."
    echo -e "  -n, --no-db                   Do not run the database migrations"
    echo -e "                                To use that flag with django tests, \033[31myou need to"
    echo -e "                                copy no_db_test_runner.py file into an app"
    echo -e "                                like omnipro, shomnipro...\033[0m"
    echo -e ""
    echo -e ""
    echo -e " \033[32mDjango Specific Options:\033[0m"
    echo -e "  -r, --runner     <file_name>  Run tests with a specific testrunner for django"
    echo -e "                                No need to use this flag if you are using -n"
    echo -e "                                flag. If you are using both, -n will be ignored"
    echo -e "  -rc, --r-class   <string>     Run tests with a specific testrunner class"
    echo -e ""
    echo -e ""
    echo -e " \033[32mPytest Specific Options:\033[0m"
    echo -e "  -s, --settings   <string>     Run tests with a specific settings file"
    echo -e "                                If not provided, script will search for a file"
    echo -e "  -w, --with       <string(s)>  Run tests with a specific string in the path"
    echo -e "                                Example: [-w 'core' 'tests' 'src'] to run tests"
    echo -e "                                only in 'core', 'tests' and 'src' keywords in"
    echo -e "                                their path. If not provided, all tests which"
    echo -e "                                matches with <file_name> will be run in the"
    echo -e "                                project"
    echo -e ""
    echo -e ""
    echo -e " \033[32mPython 2.7+ Examples:\033[0m"
    echo -e " \033[32m$\033[0m tst -t d -f serializers      \033[32m=>\033[0m Run all tests in test_serializers.py"
    echo -e " \033[32m$\033[0m tst -t django --no-db        \033[32m=>\033[0m Run all tests without database"
    echo -e " \033[32m$\033[0m tst -t d -f serializers -n   \033[32m=>\033[0m Run all tests in test_serializers.py"
    echo -e "                                   files without database."
    echo -e " \033[32m$\033[0m tst -t d -f serializers -r my_runner -rc MyTestRunner"
    echo -e "                                \033[32m^^\033[0m Run all tests in test_serializers.py files"
    echo -e "                                   with path.to.my_runner.MyTestRunner class"
    echo -e ""
    echo -e ""
    echo -e " \033[32mPython 3.7+ Examples:\033[0m"
    echo -e " \033[32m$\033[0m tst -t p                     \033[32m=>\033[0m Run all tests"
    echo -e " \033[32m$\033[0m tst -t pytest -n             \033[32m=>\033[0m Run all tests without database"
    echo -e " \033[32m$\033[0m tst -t p -f serializers      \033[32m=>\033[0m Run all tests in test_serializer.py files"
    echo -e " \033[32m$\033[0m tst -t p -f serializers -w 'core' 'tests'"
    echo -e "                                \033[32m^^\033[0m Run all tests in test_serializer.py files"
    echo -e "                                   which contains 'core' and 'tests'"
    echo -e "                                   in their path like;"
    echo -e "                                   '\033[31mcore\033[0m/some_dir/\033[31mtests\033[0m/test_serializers.py'"
    echo -e "                                   'omni\033[31mcore\033[0m_project/\033[31mtests\033[0m/test_serializers.py'"
    echo -e " \033[32m$\033[0m tst -t p -f serializers -s settings_local"
    echo -e "                                \033[32m^^\033[0m Run all tests in test_serializer.py files"
    echo -e "                                   with settings_local.py file"
    
    exit 1
}

# TODO: Add print option instead of running the tests
# TODO: Add flake8
# TODO: Add keepdb and failfast flags

declare -a cmd_arr
declare -a single_arr

index_i=0

# Split the arguments into arrays
function append_arr {
    if [ ${#single_arr[@]} -gt 0 ]; then
        cmd_arr[$index_i]=${single_arr[@]}
        single_arr=()
        index_i=$((index_i+1))
    fi
}

for i in "$@"
do
    case $i in
        -*)
            append_arr
            single_arr+=($i)
        ;;
        *)
            single_arr+=($i)
        ;;
    esac
done

append_arr

no_db=false
test=''
file=''
with=''
settings=''
runner=''

# take each flag and assign the value to the variables
for i in "${cmd_arr[@]}"
do
    case ${i[0]} in
        -t\ *|--test\ *)
            test="${i#* }"
        ;;
        -t=*|--test=*)
            test="${i#*=}"
        ;;
        -f\ *|--file\ *)
            file="${i#* }"
        ;;
        -f=*|--file=*)
            file="${i#*=}"
        ;;
        -w\ *|--with\ *)
            with="${i#* }"
        ;;
        -w=*|--with=*)
            with="${i#*=}"
        ;;
        -s\ *|--settings\ *)
            settings="${i#* }"
        ;;
        -s=*|--settings=*)
            settings="${i#*=}"
        ;;
        -r\ *|--runner\ *)
            runner="${i#* }"
        ;;
        -r=*|--runner=*)
            runner="${i#*=}"
        ;;
        -rc\ *|--r-class\ *)
            r_class="${i#* }"
        ;;
        -rc=*|--r-class=*)
            r_class="${i#*=}"
        ;;
        -n|--no-db)
            no_db=true
        ;;
        -h|--help)
            usage
        ;;
        *)
            echo "ERROR: Invalid flag: ${i[0]}"
            usage
        ;;
    esac
done

if [[ -z $cmd_arr ]]; then
    usage
fi

if [[ -z $test ]]; then
    echo "ERROR: No test specified"
    usage
fi

if [[ -z $file ]]; then
    file="*"
fi

# find files with the given name
if [[ $test == "p" || $test == "pytest" ]]; then
    grep_cmd=""
    for i in ${with// / }
    do
        grep_cmd+="grep $i | "
    done
    grep_cmd+="grep ''"
    file=`find -name "test_${file}.py" | eval $grep_cmd`
    file=${file//.\//\/}
elif [[ $test == "d" || $test == "django" ]]; then
    file="*test_${file}.py"
fi


pytest="DJANGO_SETTINGS_MODULE=__settings__ pytest __migrations__ -W ignore::DeprecationWarning -W ignore::PendingDeprecationWarning --verbose __file__"

django="python manage.py test omnishop omnicore -p '__file__' __migrations__"

if [[ $test == "p" || $test == "pytest" ]]; then
    if [[ -z $settings ]]; then
        settings=`find -type f -name 'settings.py' | sed 's/\.\///g' | sed 's/\.py//' | sed 's/\//\./'`
    else
        settings=`find -type f -name "$settings.py" | sed 's/\.\///g' | sed 's/\.py//' | sed 's/\//\./'`
    fi
    pytest=${pytest//__settings__/$settings}
    if [[ $no_db == true ]]; then
        pytest=${pytest//__migrations__/"--no-migrations"}
    else
        pytest=${pytest//__migrations__/}
    fi
    
    for i in ${file// / }
    do
        item=${i/\//}
        eval "${pytest//__file__/$item}"
    done
elif [[ $test == "d" || $test == "django" ]]; then
    if [[ ! -z $runner ]]; then
        if [[ -z $r_class ]]; then
            echo "ERROR: No test runner class specified with -rc flag"
            usage
            exit 1
        fi
        testrunner=`find -name $runner | sed 's/\.\///g' | sed 's/\.py//' | sed 's/\//\./g'`
        django=${django//__migrations__/"--testrunner=$testrunner.$r_class"}
    elif [[ $no_db == true ]]; then
        testrunner=`find -name no_db_test_runner.py | sed 's/\.\///g' | sed 's/\.py//' | sed 's/\//\./g'`
        django=${django//__migrations__/"--testrunner=$testrunner.NoDbTestRunner"}
    else
        django=${django//__migrations__/}
    fi
    echo $django
    for i in ${file// / }
    do
        eval "${django//__file__/$i}"
    done
else
    echo "ERROR: Invalid test type"
    usage
    exit 1
fi