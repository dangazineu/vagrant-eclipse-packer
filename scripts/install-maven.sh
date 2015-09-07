#!/bin/bash

echo "installing maven from /tmp/provisioning/$MAVEN_FILE_NAME"

#FIXME this is hardcoded, this could be derived from file name
MAVEN_FOLDER=apache-maven-3.3.3
MAVEN_BASE_PATH=/usr/local
M2_HOME=$MAVEN_BASE_PATH/maven

tar -xzf /tmp/provisioning/$MAVEN_FILE_NAME -C $MAVEN_BASE_PATH

ln -s $MAVEN_BASE_PATH/$MAVEN_FOLDER $M2_HOME

cat <<EOF > /etc/profile.d/maven-env.sh
#Setup M2_HOME path
export M2_HOME="$M2_HOME"
export PATH="\$M2_HOME/bin:\$PATH"
EOF

chmod 755 /etc/profile.d/maven-env.sh