#!/system/bin/sh
#  This software is released under GPL version 3 or any later version.
#  See <http://www.gnu.org/licenses/>.
#
#   Please maintain this if you use this script or any part of it
#
#  Author : Pranav-Talmale
#

 local LOGF=/tmp/recovery.log;
 local PROP=$(getprop "wrappedkey.patched.fstab");
 
 if [ "$PROP" = "1" ]; then
    echo "fstab was changed, reverting to original one" >> $LOGF;
    rm -rf /system/etc/recovery.fstab ;
	mv /tmp/backup.fstab /system/etc/recovery.fstab;
 fi
 
 