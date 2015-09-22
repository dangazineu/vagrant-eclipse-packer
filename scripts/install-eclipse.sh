#!/bin/bash

echo "installing maven from /tmp/provisioning/$ECLIPSE_FILE_NAME"

#FIXME this is hardcoded, this could be derived from file name
ECLIPSE_BASE_PATH=/usr/local
ECLIPSE_HOME=$ECLIPSE_BASE_PATH/eclipse

tar -xzf /tmp/provisioning/$ECLIPSE_FILE_NAME -C $ECLIPSE_BASE_PATH

cat <<EOF > /etc/profile.d/eclipse-env.sh
#Setup ECLIPSE_HOME path
export ECLIPSE_HOME="$ECLIPSE_HOME"
export PATH="\$ECLIPSE_HOME:\$PATH"
EOF

chmod 755 /etc/profile.d/eclipse-env.sh

#creates an icon entry to add in the sidebar favorites
cat <<EOF > /usr/share/applications/eclipse.desktop
[Desktop Entry]
Type=Application
Name=Eclipse
Comment=Eclipse Integrated Development Environment
Icon=$ECLIPSE_HOME/icon.xpm
Exec=$ECLIPSE_HOME/eclipse -data workspace
Terminal=false
Categories=Development;IDE;Java;
StartupWMClass=Eclipse
EOF

chmod 755 /usr/share/applications/eclipse.desktop

#makes sure eclipse will always find java, even if path is messed up
ln -s /usr/lib/java $ECLIPSE_HOME/jre

#CDT includes some useful tools, like org.eclipse.cdt.managedbuilder.core.headlessbuild 
#FIXME while the other installs in this build use tarballs provided externally, this step still requires internet connection
$ECLIPSE_HOME/eclipse -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/tools/cdt/releases/8.7/ -installIU org.eclipse.cdt.feature.group

#setup the sidebar favorites in unity
#if you want to add other apps to favorites, just replace contents of this file
cat <<EOF > /usr/bin/gsettings-set-favorites
gsettings set com.canonical.Unity.Launcher favorites "['application://eclipse.desktop', 'application://debian-xterm.desktop', 'application://nautilus.desktop']"
EOF
chmod 755 /usr/bin/gsettings-set-favorites

#this ensures the launcher configurer will be automatically executed every time we start Unity
cat <<EOF > /etc/xdg/autostart/launcher-configurer.desktop
[Desktop Entry]
Type=Application
Name=Launcher Configurer
Comment=Configures the list of icons to be shown in the Launcher
Exec=gsettings-set-favorites
OnlyShowIn=Unity;
NoDisplay=true
X-GNOME-Autostart-Phase=Initialization
X-GNOME-Autostart-Notify=true
X-GNOME-AutoRestart=true
NoDisplay=true
EOF

chmod 755 /etc/xdg/autostart/launcher-configurer.desktop
