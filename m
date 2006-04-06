From: "Dominik Schmid" <dominik_schmid@gmx.ch>
Subject: device-mapper initrd
Date: Thu, 6 Apr 2006 15:02:09 +0200 (MEST)
Message-ID: <17376.1144328529@www006.gmx.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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

Hi

I have problem bringing up the multipath-raid devices at bootup.

INFO:
----------

I have a system with two fibre channel devices and
device-mapper-multipathing with the following config:

defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            readsector0
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}
multipaths {
        multipath {
                wwid                    xxxxxxxxx (censured)
                alias                   yellow
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
        multipath {
                wwid                    xxxxxxxxx
                alias                   green
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
        multipath {
                wwid                    xxxxxxxxx
                alias                   blue
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
        multipath {
                wwid                    xxxxxxxxx
                alias                   red
                path_grouping_policy    multibus
                path_checker            readsector0
                path_selector           "round-robin 0"
                failback                manual
                rr_weight               priorities
                no_path_retry           5
        }
}

Now i have four logical device maps:

multipath -l
yellow (xxxxxxxxx)
[size=10 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:0:0 sda 8:0   [active][ready]
 \_ 0:0:1:0 sdb 8:16  [active][ready]
 \_ 1:0:0:0 sdi 8:128 [active][ready]
 \_ 1:0:1:0 sdj 8:144 [active][ready]
 
green (xxxxxxxxx)
[size=10 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:4:0 sde 8:64  [active][ready]
 \_ 0:0:5:0 sdf 8:80  [active][ready]
 \_ 1:0:4:0 sdm 8:192 [active][ready]
 \_ 1:0:5:0 sdn 8:208 [active][ready]
 
blue (xxxxxxxxx)
[size=4 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:2:0 sdc 8:32  [active][ready]
 \_ 0:0:3:0 sdd 8:48  [active][ready]
 \_ 1:0:2:0 sdk 8:160 [active][ready]
 \_ 1:0:3:0 sdl 8:176 [active][ready]
 
red (xxxxxxxxx)
[size=4 GB][features="1 queue_if_no_path"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 0:0:6:0 sdg 8:96  [active][ready]
 \_ 0:0:7:0 sdh 8:112 [active][ready]
 \_ 1:0:6:0 sdo 8:224 [active][ready]
 \_ 1:0:7:0 sdp 8:240 [active][ready]

----------

Now to my problem:

I made a file /etc/volume_disk1:
# Ofs Size   Raid   Log  Number Region Should Number Source  Start Taget 
Start
# in  of the type   type of log size   sync?  of     Device  in    Device in
# vol volume                 params                     mirrors            
Device          Device
0    20971520 mirror core 2        2048 sync 2           /dev/mapper/yellow
0  
/dev/mapper/green 0

Then i made dmsetup create disk1 /etc/volume_disk1.
So i have the following:

dmsetup info
Name:              yellow
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      253, 0
Number of targets: 1
UUID: mpath-xxxxxxxxx

Name:              green
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      253, 2
Number of targets: 1
UUID: mpath-xxxxxxxxx
 
Name:              blue
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      253, 1
Number of targets: 1
UUID: mpath-xxxxxxxxx
 
Name:              red
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      253, 3
Number of targets: 1
UUID: mpath-xxxxxxxxx

Name:              disk1
State:             ACTIVE
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      253, 8
Number of targets: 1

Questions:
--> How make i to do the disk1 come up on boot, so that i can use it in the
fstab file?
Is this the right way to do a mirror on a multipath device?

I have made a new initrd with mkinitrd but the device-mapper didn't find my
mirrors...

Thanks!
Dominik

-- 
E-Mails und Internet immer und überall!
1&1 PocketWeb, perfekt mit GMX: http://www.gmx.net/de/go/pocketweb
