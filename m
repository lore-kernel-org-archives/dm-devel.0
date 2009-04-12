From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: multipath prio_callout broke from 5.2 to 5.3
Date: Sat, 11 Apr 2009 23:54:30 -0400
Message-ID: <1239508470.6391.61.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello, all.  We are facing a serious problem with dm-multipath after our
upgrade.  We use a bash script to set priorities for failover.  We
understand multipathd cannot use a bash script directly so it has been
carefully crafted to use only internal commands and is loaded as:

prio_callout            "/bin/bash /usr/local/sbin/mpath_prio_ssi %n"

This has been working perfectly fine.  We upgraded our test lab to
CentOS 5.3, device-mapper-multipath.x86_64 0.4.7-23.el5_3.2, kernel
2.6.29.1 (the 2.6.18 default causes a kernel panic with iSCSI).
Suddenly, it is breaking.  /var/log/messages is filled with:

Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/dasd_id : No such file or directory
Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/gnbd_import : No such file or directory
Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/dasd_id
Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/dasd_id in ramfs : No such file or directory
Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/gnbd_import
Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/gnbd_import in ramfs : No such file or directory
Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/local/sbin/mpath_prio_ssi sdc
Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/local/sbin/mpath_prio_ssi sdd
Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/local/sbin/mpath_prio_ssi sde
Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127

The first several messages are expected but not the latter ones.  If we
run the call from the command line, e.g.,
"/bin/bash /usr/local/sbin/mpath_prio_ssi sdc" it works perfectly fine.

What has changed and how do we fix it? I'll include a sample script
below.  The script is dynamically created just before launching
multipathd:

#!/bin/bash
# if not passed any device name, return a priority of 0
if [ -z "${1}" ];then
        echo 0
        exit
fi

DEVS="lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac-lun-0 -> ../../sdj
lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c-lun-0 -> ../../sdr
lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7-lun-0 -> ../../sdn"

LIST="172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->99
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->49
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->24"

FOUND=0
IFSORIG=${IFS}
IFS=$'\n'
for LINE in ${DEVS}
do
        ENTRY=${LINE%/${1}}
        if [ ${#ENTRY} -ne ${#LINE} ];then # We found the line
                FOUND=1
                break
        fi
done
if [ "$FOUND" = "0" ];then  # This is not an iSCSI device
        echo 0
        exit
fi
DEV="${ENTRY##* ip-}"
#DEV="${DEV%% ->*}" # the pattern changed in CentOS 5.3
#DEV="$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
DEV="${DEV%%-lun-[0-9]* ->*}"
PRIORITY=0
for LINE in ${LIST}
do
        DISK=${LINE%->*}
        if [ "${DEV}" = "${DISK}" ];then
                PRIORITY="${LINE##*->}"
                break
        fi
done
echo ${PRIORITY}

I did notice the semantics of /dev/disk/by-path changed and we adapted
to that.  We were planning to move this to production on Thursday so
this has thrown a huge spanner in the works.  Any help would be greatly
appreciated.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
