#modules to check, set folders to test separated by space
#modules=( "CatalogImportExport" "BundleImportExport" "ConfigurableImportExport" "GroupedImportExport" "ImportExport" "CatalogUrlRewrite" )

modules[0]="CatalogImportExport"
modules[1]="BundleImportExport"
modules[2]="ConfigurableImportExport"
modules[3]="GroupedImportExport"
modules[4]="ImportExport"
modules[5]="CatalogUrlRewrite"

#modules parent directories, no trailing slash
parent_dirs[0]="app/code/Magento"
parent_dirs[1]="dev/tests/integration/testsuite/Magento"
parent_dirs[2]="dev/tests/api-functional/testsuite/Magento"
parent_dirs[3]="dev/tests/static/testsuite/Magento"

echo -e "------------RUN PHPMD TESTS--------------:"
for module in "${modules[@]}"
do
	for parent_dir in "${parent_dirs[@]}"
	do
		module_path="$parent_dir/$module"

		#check if directory exists
		if [ ! -d "$module_path" ]; then
			echo -e "\n Module $module does not exists in $parent_dir\n"
			continue
		fi

		echo -e "*****Module $module: ($module_path)*****:"
		echo -e "______________________________________________________________\nOutput:"
		vendor/bin/phpmd $module_path text dev/tests/static/testsuite/Magento/Test/Php/_files/phpmd/ruleset.xml
		echo "______________________________________________________________"
	done
done

echo -e "\n------------RUN PHPCS TESTS--------------:"

for module in "${modules[@]}"
do
	for parent_dir in "${parent_dirs[@]}"
	do
		module_path="$parent_dir/$module/"
		#check if directory exists
        	if [ ! -d "$module_path" ]; then
                	echo -e "\n Module $module does not exists in $parent_dir\n"
                	continue
        	fi

		echo -e "*****Module $module: ($module_path)*****"
                echo -e "______________________________________________________________\nOutput:"
                vendor/bin/phpcs $module_path --standard=dev/tests/static/testsuite/Magento/Test/Php/_files/phpcs/ruleset.xml,psr2 --warning-severity=0
                echo "______________________________________________________________"
        done
done
