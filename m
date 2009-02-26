From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: multipathd segfault and error calling out
Date: Wed, 25 Feb 2009 21:07:44 -0500
Message-ID: <1235614064.6568.65.camel@jaspav.missionsit.net.missionsit.net>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, all.  I am running on kernel 2.6.27 on CentOS 5.2 with VServer
and device-mapper-multipath-0.4.7-17.el5.  I have a custom
mpath_prio_ssi script which takes the device name (e.g., sdaa), pulls
out the path from /etc/disk/by-path and then echos a priority based upon
a lookup table.  It works perfectly fine from the command line.
multipath -ll shows the priorities assigned perfectly and exactly the
right paths are active.

However, when I start multipathd, it all goes down the tubes.  The paths
disappear and /var/log/messages is filled with:
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdh
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdi
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdj
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdc
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdd
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sde
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdf
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdg
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdh
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdi
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdj
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdc
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdd
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sde
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdf
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdg
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdh
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdi
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdj
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdk
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdl
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdm
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdn
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdo
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdp
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdq
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdr
Feb 25 20:50:18 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdk
Feb 25 20:50:18 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdl
Feb 25 20:50:18 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sdm

The callout does exist, is executable, and works with multipath.  Based
upon some email threads, I tried moving it to / and /sbin.  No change.

When multipathd starts I get:
Feb 25 20:50:17 vd01 multipathd: cannot open /sbin/dasd_id : No such file or directory
Feb 25 20:50:17 vd01 multipathd: [copy.c] cannot open /sbin/dasd_id
Feb 25 20:50:17 vd01 multipathd: cannot copy /sbin/dasd_id in ramfs : No such file or directory
Feb 25 20:50:17 vd01 multipathd: error calling out /usr/local/sbin/mpath_prio_ssi sda

and when it shuts stops I get:
Feb 25 20:43:17 vd01 multipathd: error calling out /usr/local/bin/mpath_prio_ssi sdj
Feb 25 20:43:17 vd01 multipathd: isdb: stop event checker thread
Feb 25 20:43:17 vd01 multipathd: isdc: stop event checker thread
Feb 25 20:43:17 vd01 multipathd: isda: stop event checker thread
Feb 25 20:43:17 vd01 multipathd: isdd: stop event checker thread
Feb 25 20:43:17 vd01 kernel: multipathd[28942]: segfault at a ip 0000003e8a26fa3d sp 00007fff47e946d0 error 4 in libc-2.5.so[3e8a200000+14a000]

Here are the uncommented portions of my /etc/multipath.conf:
blacklist {
#        devnode "*"
        # sdb
        wwid SATA_ST3250310NS_9SF0L234
        #sda
        wwid SATA_ST3250310NS_9SF0LVSR
}
defaults {
        failback                5
        path_grouping_policy    failover
        path_checker            tur
        prio_callout            "/usr/local/sbin/mpath_prio_ssi %n"
}
multipaths {
        multipath {
                wwid                    3600144f049a4acec00003048c6912c00
                alias                   isda
        }
        multipath {
                wwid                    3600144f049a4acf500003048c6912c00
                alias                   isdb
        }
        multipath {
                wwid                    3600144f049a4ace600003048c6912c00
                alias                   isdc
        }
        multipath {
                wwid                    3600144f049a448a700003048c6912c00
                alias                   isdd
        }
}


devices {
       device {
               vendor                  "SUN"
               product                 "SOLARIS"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               features                "0"
               hardware_handler        "0"
               path_grouping_policy    failover
               rr_weight               uniform
               rr_min_io               1000
               path_checker            readsector0
       }
}

Here is the callout script:
#!/bin/bash
# if not passed any device name, return a priority of 0
if [ -z "${1}" ];then
        echo 0
        exit
fi

ENTRY="$(ls -l1 /dev/disk/by-path | grep /${1}'$')"
DEV="${ENTRY##* ip-}"
if [ "$DEV" = "${ENTRY}" ];then #This is not an iSCSI device
        echo 0
        exit
fi
DEV="${DEV%% ->*}"
echo $(grep ${DEV} /usr/local/etc/iscsi.list | cut -f2)

and here is iscsi.list:
172.x.x.158:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020    5
172.x.x.158:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9    99
172.x.x.158:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782    5
172.30.13.158:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639    24
172.x.x.174:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020    1
172.x.x.174:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9    2
172.x.x.174:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782    1
172.x.x.174:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639    49
172.x.x.190:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020    0
172.x.x.190:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9    49
172.x.x.190:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782    0
172.x.x.190:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639    2
172.x.x.206:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020    11
172.x.x.206:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9    24
172.x.x.206:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782    11
172.x.x.206:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639    99
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020     24
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9     11
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782     99
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639     5
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020     49
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9     0
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782     2
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639     1
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020     2
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9     1
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782     49
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639     0
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:04e2454b-e60c-cfaf-d8b9-923b9fed0020     99
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:8af2554f-13f6-c0e1-8343-c457e4802cb9     5
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:b8a8e5cd-4501-c8f7-be51-ad7fcb31f782     24
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:c3420146-eecc-c364-dc6e-a3914db5a639     11

What have I misconfigured? How do I make this work properly? Thanks -
John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
