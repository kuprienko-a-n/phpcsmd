#run cmd against the chosen files
function phpcsmd_run {
    FILES=($1)
    ORIGINAL_CMD=$2
    PLACEHOLDER=$3

    for FILE in "${FILES[@]}"
    do
        #check if directory exists
        if [ ! -f "$FILE" ]; then
            echo -e "\n File $FILE does not exists\n"
            continue
        fi
        echo -e "*****File $FILE*****:"
        echo -e "______________________________________________________________\nOutput:"

        eval ${ORIGINAL_CMD/$PLACEHOLDER/$FILE}

        echo "______________________________________________________________"
    done
}

#project root
ROOT="."
#parse arguments
for i in "$@"
do
    case $i in
        -b1=*|--branch1=*)
        BRANCH1="${i#*=}"
        ;;
        -b2=*|--branch2=*)
        BRANCH2="${i#*=}"
        ;;
        -r=*|--root=*)
        ROOT="${i#*=}"
        ;;
    esac
done
#check if branches are set
if [[ -z $BRANCH1 || -z $BRANCH2 ]]; then
    echo -e "Error: branhces are not set."
    exit 1
fi
#check if project root exists
if [ ! -d "$ROOT" ]; then
    echo -e "Error: project root doesnot exists."
    exit 1
fi

cd $ROOT

#get changed files
CHANGED_FILES="$(git diff --name-only $BRANCH1 $BRANCH2 | sed -e 's/)$//')"
PLACEHOLDER="|FILE|"
PHPMD_CMD="vendor/bin/phpmd $PLACEHOLDER text dev/tests/static/testsuite/Magento/Test/Php/_files/phpmd/ruleset.xml"
PHPCS_CMD="vendor/bin/phpcs $PLACEHOLDER --standard=dev/tests/static/testsuite/Magento/Test/Php/_files/phpcs/ruleset.xml,psr2 --warning-severity=0"

echo -e "------------RUN PHPMD TESTS--------------:"
phpcsmd_run "$CHANGED_FILES" "$PHPMD_CMD" "$PLACEHOLDER"

echo -e "\n------------RUN PHPCS TESTS--------------:"
phpcsmd_run "$CHANGED_FILES" "$PHPCS_CMD" "$PLACEHOLDER"
