#!/bin/bash -x
CURR=$(pwd)

echo -n '' > result.txt
echo -n '' > time-info.txt
for bug in 105_bugs_with_src/*
do
        cd $CURR/$bug
	echo -n '' > arja_test.txt
	catena4j test > ori_test.txt
	depend=$(catena4j export -p cp.test)
        src_classes=$(catena4j export -p dir.src.classes)
        bin_classes=$(catena4j export -p dir.bin.classes)
        bin_test=$(catena4j export -p dir.bin.tests)
	rm -rf ./arja-e
	
	echo "$bug" >> $CURR/time-info.txt
	date "+ %Y-%m-%d %H:%M:%S" >> $CURR/time-info.txt	
	if [[ $bug =~ "Chart" ]];then
		if [[ -d "source" ]];then
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build -DbinTestDir $CURR/$bug/build-tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e >arja_test.txt	
		else
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build -DbinTestDir $CURR/$bug/build-tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		fi
	elif [[ $bug =~ "Math" ]];then
		if [[ -d "target" ]];then
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/target/classes -DbinTestDir $CURR/$bug/target/test-classes -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt	
		else
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build -DbinTestDir $CURR/$bug/build-tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		fi
	elif [[ $bug =~ "Time" ]];then
		if [[ -d "target" ]];then
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/target/classes -DbinTestDir $CURR/$bug/target/test-classes -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		elif [[ -d "build" ]];then
			if [[ -d "build-tests" ]];then
				timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build -DbinTestDir $CURR/$bug/build-tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
			else
				timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build/classes -DbinTestDir $CURR/$bug/build/tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt	
			fi
		fi
	elif [[ $bug =~ "Closure" ]];then
		if [[ -d "build/classes" ]];then
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build/classes -DbinTestDir $CURR/$bug/build/test -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		else
			timeout -s 9 18000 java -cp $depend:/arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/build -DbinTestDir $CURR/$bug/build-tests -Ddependences ./ -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		fi
	elif [[ $bug =~ "Lang" ]];then
		if [[ -d "target" && -d "target/tests" ]];then
			timeout -s 9 18000 java -cp /arja/lib_lang/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/target/classes -DbinTestDir $CURR/$bug/target/tests -Ddependences $depend -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		elif [[ -d "target" && -d "target/test-classes" ]];then
			timeout -s 9 18000 java -cp /arja/lib_lang/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/target/classes -DbinTestDir $CURR/$bug/target/test-classes -Ddependences $depend -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		fi
	elif [[ $bug =~ "Mockito" ]];then
		if [[ -d "target" && -d "target/test-classes" ]];then
			timeout -s 9 18000 java -cp /arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/$bin_classes -DbinTestDir $CURR/$bug/$bin_test -Ddependences $depend -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		elif [[ -d "build/classes/main" && -d "build/classes/test" ]];then
			timeout -s 9 18000 java -cp /arja/lib/*:/arja/bin us.msu.cse.repair.Main ArjaE -DsrcJavaDir $CURR/$bug/$src_classes -DbinJavaDir $CURR/$bug/$bin_classes -DbinTestDir $CURR/$bug/$bin_test -Ddependences $depend -DexternalProjRoot /arja/external/  -DpatchOutputRoot $CURR/$bug/arja-e > arja_test.txt
		fi
	fi

date "+ %Y-%m-%d %H:%M:%S" >> $CURR/time-info.txt 

#Get ori_failing test number
while read line
do
        if [[ $line =~ "Failing tests:" ]];then
		ori_test=${line##*"Failing tests: "}
        fi      
done<ori_test.txt

#Get arja-e failing test number
while read row
do
        if [[ $row =~ "Number of negative tests:" ]];then
	 	arja_e_test=${row##*"Number of negative tests: "}
        fi
done<arja_test.txt


if [[ $arja_e_test == $ori_test  ]];then
	echo "${bug}: pass" >> $CURR/result.txt
else
	echo "${bug}: fail" >> $CURR/result.txt
fi

done
