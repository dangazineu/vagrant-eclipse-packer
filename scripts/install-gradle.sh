#!/bin/bash

echo "installing maven from /tmp/provisioning/$GRADLE_FILE_NAME"

#FIXME this is hardcoded, this could be derived from file name
GRADLE_FOLDER=gradle-2.6
GRADLE_BASE_PATH=/usr/local
GRADLE_HOME=$GRADLE_BASE_PATH/gradle

unzip /tmp/provisioning/$GRADLE_FILE_NAME -d $GRADLE_BASE_PATH

ln -s $GRADLE_BASE_PATH/$GRADLE_FOLDER $GRADLE_HOME

cat <<EOF > /etc/profile.d/gradle-env.sh
#Setup GRADLE_HOME path
export GRADLE_HOME="$GRADLE_HOME"
export PATH="\$GRADLE_HOME/bin:\$PATH"
EOF

chmod 755 /etc/profile.d/gradle-env.sh