#!/bin/bash

SWFQUICKSTART_HOME=$(cd $(dirname $0)  ;pwd)
WORKDIR=$SWFQUICKSTART_HOME/temp
VERSION_HISTORY=$SWFQUICKSTART_HOME/versions

# download latest sdk
if [ -e $WORKDIR ];
then
#  rm -rf $WORKDIR
 rm -rf $WORKDIR/aws-java-sdk-*
fi

mkdir -p $WORKDIR

pushd temp > /dev/null
#  wget http://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip  2>&1 > /dev/null
  unzip -q aws-java-sdk.zip
  CURRENT_VERSION=`tail -n 1  $VERSION_HISTORY`
  for d in `find $WORKDIR -type d -depth 1 -name "*aws-java-sdk-*"` ; 
  do
    # compare version local-newest and downloaded
    LATEST_VERSION=${d##*-}
    if [ "${CURRENT_VERSION}" != "${LATEST_VERSION}" ];
    then
      # if download > local-newest
      echo $LATEST_VERSION >> $VERSION_HISTORY
      echo "new Version detect!"
      pushd $d > /dev/null
        pushd lib > /dev/null
          mvn install:install-file -Dfile=${d}/lib/aws-java-sdk-${LATEST_VERSION}.jar -DgroupId=com.amazonaws -DartifactId=aws-java-sdk -Dversion=${LATEST_VERSION} -D packaging=jar -DgeneratePom=true -Dsource=${d}/lib/aws-java-sdk-${LATEST_VERSION}-sources.jar -Djavadoc=${d}/lib/aws-java-sdk-${LATEST_VERSION}-javadoc.jar 
          mvn install:install-file -Dfile=${d}/lib/aws-java-sdk-flow-build-tools--${LATEST_VERSION}.jar -DgroupId=com.amazonaws -DartifactId=aws-java-sdk-flow-build-tools -Dversion=${LATEST_VERSION} -D packaging=jar -DgeneratePom=true
          exit
        popd > /dev/null
        pushd third-party > /dev/null
          
          echo "<dependencies>" > dependency.xml

          for l in `find ./ `;
          do  
            echo << EOD >> dependency.xml
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.1.1</version>
        </dependency>
EOD         
          done         
            echo "</dependencies>" >> dependency.xml
        popd > /dev/null
      popd > /dev/null
    fi
    
    break
  done
  # mvn install-file 
 
  # dependency add

  # git push 

popd  > /dev/null

#rm -rf $WORKDIR
