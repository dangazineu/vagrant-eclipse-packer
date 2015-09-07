#!/bin/bash

echo "installing java from /tmp/provisioning$JDK_FILE_NAME"
#if [ -z "$JDK_FILE_NAME" ]; then
#	echo "JDK_FILE_NAME isn't set"
#	exit 1
#fi

#FIXME this is hardcoded, it may be better to have the actual java version set in the build.sh script and bring this info as an env var
JAVA_VERSION=jdk1.8.0_60
JAVA_BASE_PATH=/usr/lib
JAVA_HOME=$JAVA_BASE_PATH/java

tar -xzf /tmp/provisioning/$JDK_FILE_NAME -C $JAVA_BASE_PATH

ln -s $JAVA_BASE_PATH/$JAVA_VERSION $JAVA_HOME

cat <<EOF > /etc/profile.d/java-env.sh
#Setup JAVA_HOME path
export JAVA_HOME="$JAVA_HOME"
export PATH="\$JAVA_HOME/bin:\$PATH"
EOF

chmod 755 /etc/profile.d/java-env.sh

