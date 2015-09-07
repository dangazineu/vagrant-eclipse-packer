#!/bin/bash

if [ -z "$VAGRANT_HOME" ]; then
    export VAGRANT_HOME=~/.vagrant.d 
fi

export ORIGINAL_USER=$1
export ORIGINAL_BOX=$2
export ORIGINAL_VERSION=$3

export ATLAS_USERNAME=$4
export ATLAS_BOX_NAME=$5
export ATLAS_BOX_VERSION=$6

#this script builds a box on top of an existing virtualbox image
#here is where we guarantee the original machine is available
vagrant box add $ORIGINAL_USER/$ORIGINAL_BOX --box-version $ORIGINAL_VERSION --provider virtualbox

#now will make sure all dependencies for this box are resolved before we run packer
#TODO packer supports running scripts in the host machine, 
#it may be a good idea to move this logic to a provisioning script that runs before the file provisioner
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PROVISIONING_DIR=$DIR/provisioning
if [ ! -d "$PROVISIONING_DIR" ]; then
  mkdir $PROVISIONING_DIR
fi

export JDK_FILE_NAME="jdk-8u60-linux-x64.tar.gz"
JDK_HEADER="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u60-b27/$JDK_FILE_NAME"
$DIR/scripts/download-if-not-exists.sh $JDK_FILE_NAME $PROVISIONING_DIR $JDK_URL "$JDK_HEADER"

export MAVEN_FILE_NAME="apache-maven-3.3.3-bin.tar.gz"
MAVEN_URL="ftp://mirror.reverse.net/pub/apache/maven/maven-3/3.3.3/binaries/$MAVEN_FILE_NAME"
$DIR/scripts/download-if-not-exists.sh $MAVEN_FILE_NAME $PROVISIONING_DIR $MAVEN_URL 

export GRADLE_FILE_NAME="gradle-2.6-bin.zip"
GRADLE_URL="https://services.gradle.org/distributions/$GRADLE_FILE_NAME"
$DIR/scripts/download-if-not-exists.sh $GRADLE_FILE_NAME $PROVISIONING_DIR $GRADLE_URL 

#if you're one of the "Friends of Eclipse", you probably want to manually download this from the website and place it under provisioning folder
export ECLIPSE_FILE_NAME="eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz"
ECLIPSE_URL="http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/R/$ECLIPSE_FILE_NAME&mirror_id=1"
$DIR/scripts/download-if-not-exists.sh $ECLIPSE_FILE_NAME $PROVISIONING_DIR $ECLIPSE_URL 

#now that we have all files ready, lets pack it all together
packer build build.json