#!/bin/bash

cd_from_main () {
	echo "in $0 before cd: $(pwd)"

        cd /tmp || exit

	echo "in $0 after cd: $(pwd)"
}       

echo "In $0 about to call cd_from_main: $(pwd)"
cd_from_main
echo "In $0 after calling cd_from_main: $(pwd)"
