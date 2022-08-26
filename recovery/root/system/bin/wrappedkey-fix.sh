#!/system/bin/sh
#
#  This file is part of the OrangeFox Recovery Project
#   Copyright (C) 2022 The OrangeFox Recovery Project
#
#  OrangeFox is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  any later version.
#
#  OrangeFox is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#   This software is released under GPL version 3 or any later version.
#  See <http://www.gnu.org/licenses/>.
#
#   Please maintain this if you use this script or any part of it
#
# Author : DarthJabba9
# Edited and adapted for violet by : Pranav-Talmale
#

# file_getprop <file> <property>
file_getprop() {
  local F=$(grep -m1 "^$2=" "$1" | cut -d= -f2);
  echo $F | sed 's/ *$//g';
}

fix_unwrap_decryption() {
local D=/tmp/system_prop;
local S=/dev/block/bootdevice/by-name/system;
local F=/tmp/build.prop;
local LOGF=/tmp/recovery.log;
    cd /tmp;
    mkdir -p $D;
    mount $S $D;
    cp $D/system/build.prop $F;
    umount $D;
    [ ! -e $F ] && { 
    	echo "$F does not exist. Quitting." >> $LOGF;
    	return;
    }

    # Check ROM's SDK version
    local SDK=$(file_getprop "$F" "ro.build.version.sdk");
    [ -z "$SDK" ] && SDK=$(file_getprop "$F" "ro.system.build.version.sdk");
    [ -z "$SDK" ] && SDK=$(file_getprop "$F" "ro.vendor.build.version.sdk");
	
	# if (SDK = 33) - then switch to no-wrappedkey fstab
    if [ "$SDK" = "33" ]; then
    	echo "ROM SDK=33. Changing to wrappedkey-patched fstab." >> $LOGF;
	found=1;
    else
	echo "ROM SDK=32. Continue without changing fstab." >> $LOGF;
    fi

    if [ "$found" = "1" ]; then
       echo "This is a no-wrappedkey ROM. Replacing the default fstab." >> $LOGF;
       mv /system/etc/recovery.fstab /tmp/backup.fstab;
       echo "Original fstab renamed to backup.fstab" >> $LOGF;
	   mv /system/etc/wrappedkey.fstab /system/etc/recovery.fstab;
	   setprop "wrappedkey.patched.fstab" "1";
    else
       echo "This is not a no-wrappedkey ROM. Continuing with the default fstab" >> $LOGF;
    fi
}

fix_unwrap_decryption;
exit 0;