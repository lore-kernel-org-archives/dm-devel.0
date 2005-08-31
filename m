From: Simon <gistolero@gmx.de>
Subject: Problems with multipathd
Date: Wed, 31 Aug 2005 17:29:06 +0200
Message-ID: <20050831152928.GA53290@sysconfig.de>
Reply-To: gistolero@gmx.de,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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


Hi,

I am trying to use multipath to provide a single block device for a
multipathed LUN for failover reasons. After some days of installation,
documentation reading and debugging I have solved a lot of problems but not
all and I need some help. I know it's a lot of text (sorry!!!), but I think
it's necessary to describe my problems.

I have marked my questions/comments with "===>". Please answer to this notes.
Thank you.



1.) *** System Description ***



Storage:

- Storage EVA-3000
- Controller-B connected to fabric-A and fabric-B
- one VDisk presented to host testhalde2 via controller-B to fabric-A and -B


Server (testhalde2):

- 1x HBA Qlogic 2340 connected to fabric-A
- 1x HBA Qlogic 2340 connected to fabric-B
- Kernel 2.6.12.5 (vanilla, gentoo)
- device-mapper-1.01.03, udev-058, multipath-tools-0.4.4


testhalde2 tmp # dmesg | fgrep device-mapper
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
device-mapper: dm-multipath version 1.0.4 loaded
device-mapper: dm-round-robin version 1.0.0 loaded



testhalde2 tmp # lsmod
Module                  Size  Used by
qla2300               123904  0 
qla2xxx                88208  4 qla2300
scsi_transport_fc      26880  1 qla2xxx


testhalde2 etc # cat multipath.conf
defaults {
        multipath_tool                  "/sbin/multipath -v 0 -S"
        udev_dir                        /dev
        polling_interval                10
        default_selector                "round-robin 0"
        default_path_grouping_policy    failover
        default_getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        default_prio_callout            "/bin/false"
        r_min_io                        100
}
blacklist {
        wwid 26353900f02796769
        devnode "(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "hd[a-z][[0-9]*]"
        devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
multipaths {
        multipath {
                wwid                    3600508b40010079d0001900000460000
                alias                   150gb
                path_grouping_policy    failover
                path_selector           "round-robin 0"
        }
}
devices {
        device {
                vendor                  "HP      "
                product                 "HSV100          "
                path_grouping_policy    multibus
                path_checker            tur
                prio_callout            "/sbin/pp_balance_units %d"
        }
}


testhalde2 etc # cat /etc/udev/rules.d/20-multipath.rules 
KERNEL="dm-[0-9]*", PROGRAM="/sbin/devmap_name %M %m", NAME="%k", SYMLINK="%c"


testhalde2 ~ # cat /etc/dev.d/block/multipath.dev
#!/bin/sh -e
print()
{
  echo "`date +%H%M%S` - $1" >> /tmp/devd_multipath
}
print "ENV_ACTION:  $ACTION" # debugging
if [ ! "${ACTION}" = add ] ; then
        exit
fi
if [ "${DEVPATH:7:3}" = "dm-" ] ; then
        dev=$(</sys${DEVPATH}/dev)
        map=$(/sbin/devmap_name $dev)
        print "KPARTX $map" # debugging
        /sbin/kpartx -v -a /dev/$map >> /tmp/devd_multipath
else
        print "ENV_DEVNAME: ${DEVNAME}" # debugging
        /sbin/multipath ${DEVNAME}
fi



2.) *** Multipath in action ***



After rebooting testhalde2, I see the following:


testhalde2 tmp # ls /sys/block/
dm-0  loop0  loop3  loop6  ram1   ram12  ram15  ram4  ram7  sda
fd0   loop1  loop4  loop7  ram10  ram13  ram2   ram5  ram8  sdb
hda   loop2  loop5  ram0   ram11  ram14  ram3   ram6  ram9


testhalde2 tmp # ls -lF /dev/mapper/
total 0
brw-------  1 root root 254,  0 Aug 31 12:20 150gb
crw-rw----  1 root root  10, 63 Aug 31  2005 control


testhalde2 ~ # fdisk -l /dev/mapper/150gb 
Disk /dev/mapper/150gb: 161.0 GB, 161061273600 bytes
255 heads, 63 sectors/track, 19581 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk /dev/mapper/150gb doesn't contain a valid partition table


===> Is it possible to _use_ partitions on this device? I know that it is
     possible to create them, but what is the device-name (/dev/...) from
     partition 1?


testhalde2 ~ # mkreiserfs /dev/mapper/150gb      
mkreiserfs 3.6.19 (2003 www.namesys.com)
...
ReiserFS is successfully created on /dev/mapper/150gb.
testhalde2 ~ # 


testhalde2 ~ # mount /dev/mapper/150gb /mnt/test/
testhalde2 ~ # touch /mnt/test/file  # ok
testhalde2 ~ # rm /mnt/test/file     # ok


testhalde2 rules.d # udevtest /sys/block/dm-0 block
udevtest.c: looking at device '/block/dm-0' from subsystem 'block'
udevtest.c: opened class_dev->name='dm-0'
udev_rules.c: configured rule in '/etc/udev/rules.d/20-multipath.rules[3]' applie
d, added symlink '%c'
udev_rules.c: add symlink '150gb'
udev_rules.c: configured rule in '/etc/udev/rules.d/20-multipath.rules[3]' applie
d, 'dm-0' becomes '%k'
udev_rules.c: configured rule in '/etc/udev/rules.d/50-udev.rules[63]' applied, '
dm-0' is ignored


testhalde2 tmp # ls -lF /dev/1*
ls: /dev/1*: No such file or directory


===> udevtest shows that udev reads the 20-multipath.rules rule. Why doesn't
     udev creates /dev/150gb?


testhalde2 tmp # multipath -l   
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 0:0:0:1 sda  8:0     [ready ][active]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sdb  8:16    [ready ][active]


testhalde2 tmp # dmsetup table
150gb: 0 314572800 multipath 0 0 2 1 round-robin 0 1 1 8:32 1000 round-robin 0 1 
1 8:16 1000 


testhalde2 tmp # cat devd_multipath    # multipath.dev debugging output
...
142037 - ENV_DEVPATH: ram
142037 - ENV_DEVNAME: /dev/rd/9
142046 - ENV_ACTION:  add
142046 - ENV_DEVPATH: sda
142046 - ENV_DEVNAME: /dev/sda
122045 - ENV_ACTION:  add
122045 - ENV_DEVPATH: sdb
122045 - ENV_DEVNAME: /dev/sdb


testhalde2 tmp # fgrep dm devd_multipath 
testhalde2 tmp # 


===> My idea from the sysfs/device-mapper/udev/multipath cooperation is the
following: After loading the hba module qla2300 the kernel creates
/sys/block/sda and /sys/block/sdb und executes udevsend - udevd - udev. udev
invokes /etc/dev.d/block/multipath.dev (ADD, sda/sdb). multipath.dev executes
multipath that creates the device-mapper table and the device-mapper device
/sys/block/dm-0. Ok, now we have a new device (dm-0). And again: udevsend -
udevd - udev and multipath.dev (ADD, dm-0). multipath.dev should start kpartx,
but the debug file /tmp/devd_multipath shows nothing! So, I think kpartx will
never started. Is this behavior ok? It seems to work without kpartx, so I don't
understand why I need this tool.
     


testhalde2 ~ # multipath -v3
fd0 blacklisted
ram0 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
loop0 blacklisted
loop1 blacklisted
loop2 blacklisted
loop3 blacklisted
loop4 blacklisted
loop5 blacklisted
loop6 blacklisted
loop7 blacklisted
hda blacklisted
path sda not found in pathvec

===== path sda =====
vendor = HP      
:
product = HSV100          
rev = 3025
dev_t = 8:0
size = 314572800
h:b:t:l = 0:0:0:1
tgt_node_name = 0x50001fe150051d20
serial = P66C5E2AAQI010
path checker = tur (controler setting)
state = 2
getprio = /sbin/pp_balance_units %d (controler setting)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 3600508b40010079d0001900000460000 (callout)
path sdb not found in pathvec

===== path sdb =====
vendor = HP      
product = HSV100          
rev = 3025
dev_t = 8:16
size = 314572800
h:b:t:l = 1:0:0:1
tgt_node_name = 0x50001fe150051d20
serial = P66C5E2AAQI010
path checker = tur (controler setting)
state = 2
getprio = /sbin/pp_balance_units %d (controler setting)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
uid = 3600508b40010079d0001900000460000 (callout)
dm-0 blacklisted
#
# all paths :
#
3600508b40010079d0001900000460000 0:0:0:1 sda  8:0     [ready ][HSV100          ]
3600508b40010079d0001900000460000 1:0:0:1 sdb  8:16    [ready ][HSV100          ]
params = 0 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1000 
status = 1 0 0 2 1 A 0 1 0 8:0 A 0 E 0 1 0 8:16 A 0 
pgpolicy = failover (LUN setting)
selector = round-robin 0 (LUN setting)
features = 0 (internal default)
hwhandler = 0 (internal default)
0 314572800 multipath 0 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1
000
action preset to 0
action set to 1
cannot signal daemon, pidfile not found
testhalde2 ~ # 


testhalde2 ~ # ps ax | fgrep multipathd
10870 pts/0    SL     0:00 multipathd
10871 pts/0    SL     0:00 multipathd
10872 pts/0    SL     0:00 multipathd
10875 pts/0    S+     0:00 fgrep multipathd

testhalde2 ~ # ls /var/run/multipathd.pid
ls: /var/run/multipathd.pid: No such file or directory

===> Does the system really need _three_ multipathd daemons and why is
     there no pid file?


testhalde2 ~ # echo 10870 > /var/run/multipathd.pid
testhalde2 ~ # strace -f -p 10870 >/tmp/strace_multipatd 2>&1 &
[1] 11192




Now, I disable HBA-fabric-B port on the san-switch...

testhalde2 ~ # multipath -l
[ sleeping 35 seconds ]
open class /sys/block/sdc failed: No such file or directory
error calling out /sbin/scsi_id -g -u -s /block/sdc
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 1:0:0:1 sdb  8:16    [ready ][active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sdc  8:32    [ready ][active]

testhalde2 ~ # multipath -l       # again
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 1:0:0:1 sdb  8:16    [ready ][active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:0      8:32    [undef ][active]

testhalde2 tmp # touch /mnt/test/test    # ok
testhalde2 tmp # rm /mnt/test/test       # ok

testhalde2 tmp # ps ax | fgrep multipathd
10871 pts/0    SL     0:00 multipathd
10872 pts/0    SL     0:00 multipathd
10870 pts/0    SL     0:00 multipathd
11534 pts/0    S+     0:00 fgrep multipathd

testhalde2 tmp # cat strace_multipatd 
Process 10870 attached - interrupt to quit
testhalde2 tmp # 

===> No output in the strace-debug file from multipathd. It seems that
     multipathd don't recognize the changes.
 


Enabling HBA-fabric-B port on the san-switch...

testhalde2 tmp # multipath -l
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 1:0:0:1 sdb  8:16    [ready ][active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sdc  8:32    [ready ][active]

testhalde2 tmp # touch /mnt/test/test    # ok
testhalde2 tmp # rm /mnt/test/test       # ok




Disabling HBA-fabric-A port on the other san-switch...

testhalde2 ~ # multipath -l
[ sleeping 35 seconds ]
1:0:0:1: cannot open /tmp/scsi-maj8-min16-11665: No such device or address
error calling out /sbin/scsi_id -g -u -s /block/sdb
error calling out /sbin/pp_balance_units 8:32
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 1:0:0:1 sdb  8:16    [faulty][active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sdc  8:32    [ready ][active]

testhalde2 tmp # multipath -l             # again
error calling out /sbin/pp_balance_units 8:32
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active][first]
  \_ 0:0:0:0      8:16    [undef ][active]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sdc  8:32    [ready ][active]

testhalde2 tmp # touch /mnt/test/test    # ok
testhalde2 tmp # rm /mnt/test/test       # ok


===> Why do I get the "error calling out..." error only when I disable the
     HBA-port from _fabric-A_?


Enabling HBA-fabric-A port...

testhalde2 tmp # multipath -l
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled][first]
  \_ 0:0:0:1 sdc  8:32    [ready ][active]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sda  8:0     [ready ][active]

testhalde2 tmp # touch /mnt/test/test    # ok
testhalde2 tmp # rm /mnt/test/test       # ok


testhalde2 tmp # ps ax | fgrep multipathd
10871 pts/0    SL     0:00 multipathd
10872 pts/0    SL     0:00 multipathd
10870 pts/0    SL     0:00 multipathd
11534 pts/0    S+     0:00 fgrep multipathd

testhalde2 tmp # cat strace_multipatd 
Process 10870 attached - interrupt to quit
testhalde2 tmp # 

===> Again: No output in the strace-debug file from multipathd.



SUMMARY:
========

The failover mechanism seems to work, but it's very very slow (>= 35 sec).
I am sure that the host will die when I have a lot of I/O's in this moment.
The documentation says that multipathd "is in charge of checking the paths
in case they come up or down" and multipathd seems to do nothing... I think
that is the problem... What do you mean?


Thanks a lot for your help
Simon


-- 

Simon
gistolero@gmx.de
