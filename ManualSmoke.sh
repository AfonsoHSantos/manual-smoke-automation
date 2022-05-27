# !/bin/bash

copyright="/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * The contents of this file are subject to the terms of the Liferay Enterprise
 * Subscription License ("\"License\""). You may not use this file except in
 * compliance with the License. You can obtain a copy of the License by
 * contacting Liferay, Inc. See the License for the specific language governing
 * permissions and limitations under the License, including but not limited to
 * distribution rights of the Software.
 *
 *
 *
 */"

readme="<h1>Liferay Digital Experience Platform 7.4</h1>

<p>Liferay Digital Experience Platform 7.4 lets you create and connect personalized digital experiences across web, mobile, and connected devices.</p>

<p>To get off to a great start using Liferay Digital Experience Platform (DXP), refer to the official
<a href="\"https://help.liferay.com/hc/en-us/articles/360060181991\""><em>Readme</em></a> file on the <a href="\"https://help.liferay.com/hc\"">Liferay Help Center</a>. It provides resources for launching and learning DXP, enterprise support information, descriptions of Liferay's deployment services, and whitepapers on enterprise and mission critical deployments.</p>

<p>Customers will be provided access to Help Center after purchase. To access Help Center, sign in to <a href="\"https://www.liferay.com\"">Liferay.com</a> and look for Help Center under your User icon in the top right drop down menu, or directly access from <a href="\"https://help.liferay.com/hc\"">here</a>. If you do not have access to Help Center, please email <a href="\"provisioning@liferay.com\"">provisioning@liferay.com</a>.</p>

<p>If you do not have a Liferay.com account, please create one from the <em>Create Account</em> link in the top right drop down menu at <a href="\"https://www.liferay.com\"">Liferay.com</a>.</p>

<h2>Licensing and Trademark</h2>

<ol>
<li><p>Liferay Digital Experience Platform (DXP) is licensed by Liferay and its affiliates. Your use of DXP is subject to the terms and conditions of an agreement between you, and/or your company, and Liferay or its affiliates.</p></li>
<li><p>Liferay, Liferay Digital Experience Platform and Liferay DXP are trademarks registered by Liferay in the United States, Europe and various other countries. Use of these trademarks is governed by the Trademark policy posted at: <a href="\"http://www.liferay.com/Trademark\"">Liferay.com/Trademark</a>. When using these trademarks in any form, this policy should be reviewed to understand if your use requires permission from Liferay. For further questions, please contact <a href="\"Legal@liferay.com\"">Legal@liferay.com</a>.</p></li>
</ol>"


# Get bundle name and githash
    echo "Enter bundle name"
    read bundleName
    echo "Enter githash"
    read githash

 # Validate the name of the compressed bundle			
    compressedBundleName=(${bundleName//-2/ })
    if [ "$(ls -A $bundleName)" ]
    then
        echo "1. The bundle name is correct - PASSED"
    else
        echo "1. The bundle name is wrong - FAILED"
        exit
    fi

# Format bundle name
    portal=(${bundleName//tomcat-/ })
    portal2=(${bundleName//-tomcat-/ })
    version=(${portal2[1]//-20/ })
    bundleNameDirectory="${portal}${version}"

    cd ${bundleName}/${bundleNameDirectory}

# Assert the .liferay-home file is present within the liferay home directory
    if [ -f ".liferay-home" ]
    then
        echo "2. The file .liferay-home is present - PASSED"
    else
        echo "2. The file .liferay-home isn't present -FAILED"
    fi

# Validate the contents within the readme.html in the liferay home directory
    if [ "$readme" == "$(cat readme.html)" ]
    then
        echo "3. The content of readme.html is correct - PASSED"
    else
        echo "3. The content of readme.html is wrong - FAILED"
    fi


# Assert the hash within the .githash file in the liferay home directory			
    if [ "$githash" == "$(cat .githash)" ]
    then
        echo "4. The git hash is correct - PASSED"
    else
        echo "4. The git hash is wrong - FAILED"
    fi

# Validate the contents within the copyright.txt file within the /license directory
    cd license		
    if [ "$copyright" == "$(cat copyright.txt)" ]
    then
        echo "5. The content of copyright.txt is correct - PASSED"
    else
        echo "5. The content of copyright.text is wrong - FAILED"
    fi

# Assert the /deploy directory is empty
    DIR="deploy"
    cd ..

    if [ "$(ls -A $DIR)" ]
    then
        echo "6. The deploy directory is populated - FAILED"
    else
        echo "6. The deploy directory isn't populated - PASSED"
    fi

# Copy license to deploy directory
    cp ~/Downloads/license.xml ~/Downloads/${bundleName}/${bundleNameDirectory}/deploy

# Assert the /logs directory is empty
    DIR="logs"

    if [ "$(ls -A $DIR)" ]
    then
        echo "7. The logs directory is populated - FAILED"
    else
        echo "7. The logs directory isn't populated - PASSED"
    fi

# Assert the osgi/state directory is present and is populated
    cd osgi/

    DIR="state"

    if [ "$(ls -A $DIR)" ]
    then
        echo "8. The osgi/state directory is populated - PASSED"
    else
        echo "8. The osgi/state directory isn't populated - FAILED"
    fi

# Assert the osgi/modules directory is empty
    DIR="modules"

    if [ "$(ls -A $DIR)" ]
    then
        echo "9.1. The osgi/modules directory is populated - FAILED"
    else
        echo "9.1. The osgi/modules directory isn't populated - PASSED"
    fi

# Assert osgi/portal folders directory is empty
    DIR="portal"

    if [ "$(ls -A $DIR)" ]
    then
        echo "9.2. The osgi/portal directory is populated - FAILED"
    else
        echo "9.2. The osgi/portal directory isn't populated - PASSED"
    fi

# Assert the osgi/marketplace folder is populated with app LPKGs
    DIR="marketplace"
    filesQuantity=0
    lpkgFiles=0

    # Count files in marketplace folder
    for file in "$DIR"/*.*
    do
        filesQuantity=$((filesQuantity + 1))
    done

    # Count .lpkg files

    for file in "$DIR"/*.*
    do
        if [[ -f $file && $file = *.lpkg ]]
        then
            lpkgFiles=$((lpkgFiles + 1))
        fi
    done

    # Comparison between total number of files and number of .lpkg files 
    if [ $lpkgFiles = $filesQuantity ]
    then
        echo "10. Marketplace have a total of $filesQuantity files and $lpkgFiles from this files are LPKGs apps - PASSED"
    else
        echo "10. Marketplace have $filesQuantity files and $lpkgFiles LPKGs apps - FAILED"
    fi

# Assert standalone and bundled app LPKGs are present in the /marketplace folder
    DIR="marketplace"
    filesQuantityAPI=0
    filesQuantityImpl=0

    # Count API files in marketplace folder
    for file in "$DIR"/*API.lpkg
    do
        filesQuantityAPI=$((filesQuantityAPI + 1))
    done

     # Count Impl files in marketplace folder
    for file in "$DIR"/*Impl.lpkg
    do
        filesQuantityImpl=$((filesQuantityImpl + 1))
    done

    filesTotal=$((filesQuantityAPI+filesQuantityImpl))


    # Comparison between total number of files and number of .lpkg files 
    if [ $filesTotal > 250 ]
    then
        echo "11. Marketplace have $filesTotal from $filesQuantity files named Impl and API - PASSED"
    else
        echo "11. Marketplace have $filesTotal from $filesQuantity files named Impl and API - FAILED"
    fi

# Assert the LPKG names are correct
    DIR="marketplace"
    filesQuantity=0
    lpkgNames=0

    # Count files in marketplace folder
    for file in "$DIR"/*.*
    do
        filesQuantity=$((filesQuantity + 1))
    done

    # Count lpkg files with right name (Liferay *(app name).lpkg)

    for file in "$DIR"/Liferay*.lpkg
    do
        if [[ -f $file && $file = *.lpkg ]]
        then
            lpkgNames=$((lpkgNames + 1))
        fi
    done

    # Comparison between total number of files and number of .lpkg files 
    if [ $lpkgNames = $filesQuantity ]
    then
        echo "12. Marketplace have a total of $filesQuantity files and $lpkgNames from this files are LPKGs apps with right name (Liferay *.lpkg) - PASSED"
    else
        echo "12. Marketplace have $filesQuantity files and $lpkgNames LPKGs apps with right name (Liferay *.lpkg) - FAILED"
    fi

# Run portal
    cd ..
    cd tomcat-9.0.56/bin
    echo "AFTER PORTAL START UP, YOU NEED TO RUN THE COMMAND: ant -f build-test.xml run-selenium-test -Dtest.class=ManualSmoke#ManualSmoke"
    # ./catalina.sh run | tee portalLogs.txt

# Assert the startup log Portal name, version, version name, release date, etc
    versionNumber=(${version//.u/ })
    updateNumber=(${version//$versionNumber.u/ })
    set -- "$versionNumber" 
    IFS="."; declare -a versionNumberSplit=($*) 
    formatedVersionNumber="${versionNumberSplit[0]}${versionNumberSplit[1]}${versionNumberSplit[2]}"
    currentDay=`date +%d`
    currentMonth=`date +%b`
    currentYear=`date +%Y`
    dateRangeDown=$((currentDay-5))
    dateRangeUp=$((currentDay+5))
    rightDay="${dateRangeDown}"

    while [ "$condition" != "true" ]
    do
        for (($currentDay; $rightDay <= $dateRangeUp; rightDay=$((rightDay+1))))
        do
            portalVersion="Starting Liferay Digital Experience Platform ${versionNumber} Update ${updateNumber} (Cavanaugh / Build ${formatedVersionNumber} / ${currentMonth} ${rightDay}, ${currentYear})"
            if grep -Fxq "$portalVersion" portalLogs.txt
            then
                echo "Found"
                echo "13. Portal version name is right - PASSED"
                condition="true"
                break
            else
                echo "Finding portal version..."
            fi
        done
        exit
    done

# Assert there are no startup errors  
    listErrors=("ERROR" "java.lang.NullPointer" "LIFERAY_ERROR")
    i="0"
    for item in "${listErrors[@]}"
    do
        if grep -wF -e "$item" portalLogs.txt
        then
            echo "14. An error from type ${item} was found"
            i=$((i+1))
        fi
    done
    if [ $i -eq 0 ]
        then
        echo "14. Error(s) not found - PASSED"
    fi