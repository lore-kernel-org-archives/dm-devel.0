From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Problems with multipathd
Date: Wed, 31 Aug 2005 21:56:01 +0200
Message-ID: <1125518162.6375.52.camel@zezette>
References: <20050831152928.GA53290@sysconfig.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050831152928.GA53290@sysconfig.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: gistolero@gmx.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer, 2005-08-31 at 17:29 +0200, Simon wrote:

> 
> testhalde2 tmp # ls -lF /dev/mapper/
> total 0
> brw-------  1 root root 254,  0 Aug 31 12:20 150gb
> crw-rw----  1 root root  10, 63 Aug 31  2005 control
> 
No /dev/150gb node :) ?
/etc/udev/rules.d/20-multipath.rules should create it, see below.

> 
> testhalde2 ~ # fdisk -l /dev/mapper/150gb 
> Disk /dev/mapper/150gb: 161.0 GB, 161061273600 bytes
> 255 heads, 63 sectors/track, 19581 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk /dev/mapper/150gb doesn't contain a valid partition table
> 
> 
> ===> Is it possible to _use_ partitions on this device? I know that it is
>      possible to create them, but what is the device-name (/dev/...) from
>      partition 1?
> 
A little bit harder, but I guess so :
- remove the multipath map
- partition a path (/dev/sda for example)
- re-create the multipath map through '/sbin/multipath /dev/sda'

> testhalde2 rules.d # udevtest /sys/block/dm-0 block
> udevtest.c: looking at device '/block/dm-0' from subsystem 'block'
> udevtest.c: opened class_dev->name='dm-0'
> udev_rules.c: configured rule in '/etc/udev/rules.d/20-multipath.rules[3]' applie
> d, added symlink '%c'
> udev_rules.c: add symlink '150gb'
> udev_rules.c: configured rule in '/etc/udev/rules.d/20-multipath.rules[3]' applie
> d, 'dm-0' becomes '%k'
> udev_rules.c: configured rule in '/etc/udev/rules.d/50-udev.rules[63]' applied, '
> dm-0' is ignored
> 
Default udev.rules file has a directive to ignore dm-*
Something like :
KERNEL=="dm-[0-9]*", OPTIONS+="ignore_device"

/etc/udev/rules.d/20-multipath.rules is useless unless you you comment
out this rule.

> 
> testhalde2 tmp # ls -lF /dev/1*
> ls: /dev/1*: No such file or directory
> 
> 
> ===> udevtest shows that udev reads the 20-multipath.rules rule. Why doesn't
>      udev creates /dev/150gb?
> 
See above
> 
> testhalde2 tmp # multipath -l   
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 0:0:0:1 sda  8:0     [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 1:0:0:1 sdb  8:16    [ready ][active]
> 
> 
> testhalde2 tmp # dmsetup table
> 150gb: 0 314572800 multipath 0 0 2 1 round-robin 0 1 1 8:32 1000 round-robin 0 1 
> 1 8:16 1000 
> 
> 
> testhalde2 tmp # cat devd_multipath    # multipath.dev debugging output
> ...
> 142037 - ENV_DEVPATH: ram
> 142037 - ENV_DEVNAME: /dev/rd/9
> 142046 - ENV_ACTION:  add
> 142046 - ENV_DEVPATH: sda
> 142046 - ENV_DEVNAME: /dev/sda
> 122045 - ENV_ACTION:  add
> 122045 - ENV_DEVPATH: sdb
> 122045 - ENV_DEVNAME: /dev/sdb
> 
> 
> testhalde2 tmp # fgrep dm devd_multipath 
> testhalde2 tmp # 
> 
> 
> ===> My idea from the sysfs/device-mapper/udev/multipath cooperation is the
> following: After loading the hba module qla2300 the kernel creates
> /sys/block/sda and /sys/block/sdb und executes udevsend - udevd - udev. udev
> invokes /etc/dev.d/block/multipath.dev (ADD, sda/sdb). multipath.dev executes
> multipath that creates the device-mapper table and the device-mapper device
> /sys/block/dm-0. Ok, now we have a new device (dm-0). And again: udevsend -
> udevd - udev and multipath.dev (ADD, dm-0). multipath.dev should start kpartx,
> but the debug file /tmp/devd_multipath shows nothing! So, I think kpartx will
> never started. Is this behavior ok? It seems to work without kpartx, so I don't
> understand why I need this tool.
>      
> 
kpartx is triggered for dm-* "adds" only by multipath.dev hotplug
script. *and* the script expects the node to be in /dev/
(not /dev/mapper/). 
This problem is linked to the previous one.


> 
> testhalde2 ~ # ps ax | fgrep multipathd
> 10870 pts/0    SL     0:00 multipathd
> 10871 pts/0    SL     0:00 multipathd
> 10872 pts/0    SL     0:00 multipathd
> 10875 pts/0    S+     0:00 fgrep multipathd
> 
> testhalde2 ~ # ls /var/run/multipathd.pid
> ls: /var/run/multipathd.pid: No such file or directory
> 
> ===> Does the system really need _three_ multipathd daemons and why is
>      there no pid file?
> 
I don't know default ps/nptl Gentoo choice, but it might well be the
different threads you see there. Consecutive PID numbers are a sign.

> 
> testhalde2 ~ # echo 10870 > /var/run/multipathd.pid
> testhalde2 ~ # strace -f -p 10870 >/tmp/strace_multipatd 2>&1 &
> [1] 11192
> 
Don't debug this way.
Use 'multipathd -v4' and see the log or 'strace -f multipathd'
> 
> 
> 
> Now, I disable HBA-fabric-B port on the san-switch...
> 
> testhalde2 ~ # multipath -l
> [ sleeping 35 seconds ]
> open class /sys/block/sdc failed: No such file or directory
> error calling out /sbin/scsi_id -g -u -s /block/sdc
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 1:0:0:1 sdb  8:16    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:0:1 sdc  8:32    [ready ][active]
> 
> testhalde2 ~ # multipath -l       # again
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 1:0:0:1 sdb  8:16    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:0:0      8:32    [undef ][active]
> 
Lower the timeouts in your Qlogic driver.

> testhalde2 tmp # touch /mnt/test/test    # ok
> testhalde2 tmp # rm /mnt/test/test       # ok
> 
> testhalde2 tmp # ps ax | fgrep multipathd
> 10871 pts/0    SL     0:00 multipathd
> 10872 pts/0    SL     0:00 multipathd
> 10870 pts/0    SL     0:00 multipathd
> 11534 pts/0    S+     0:00 fgrep multipathd
> 
> testhalde2 tmp # cat strace_multipatd 
> Process 10870 attached - interrupt to quit
> testhalde2 tmp # 
> 
> ===> No output in the strace-debug file from multipathd. It seems that
>      multipathd don't recognize the changes.
>  
Do the log agree with that ?

> 
> Enabling HBA-fabric-B port on the san-switch...
> 
> testhalde2 tmp # multipath -l
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 1:0:0:1 sdb  8:16    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:0:1 sdc  8:32    [ready ][active]
> 
> testhalde2 tmp # touch /mnt/test/test    # ok
> testhalde2 tmp # rm /mnt/test/test       # ok
> 
> 
> 
> 
> Disabling HBA-fabric-A port on the other san-switch...
> 
> testhalde2 ~ # multipath -l
> [ sleeping 35 seconds ]
> 1:0:0:1: cannot open /tmp/scsi-maj8-min16-11665: No such device or address
> error calling out /sbin/scsi_id -g -u -s /block/sdb
> error calling out /sbin/pp_balance_units 8:32
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active][first]
>   \_ 1:0:0:1 sdb  8:16    [faulty][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:0:1 sdc  8:32    [ready ][active]
> 
> testhalde2 tmp # multipath -l             # again
> error calling out /sbin/pp_balance_units 8:32
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active][first]
>   \_ 0:0:0:0      8:16    [undef ][active]
> \_ round-robin 0 [enabled]
>   \_ 0:0:0:1 sdc  8:32    [ready ][active]
> 
> testhalde2 tmp # touch /mnt/test/test    # ok
> testhalde2 tmp # rm /mnt/test/test       # ok
> 
> 
> ===> Why do I get the "error calling out..." error only when I disable the
>      HBA-port from _fabric-A_?
> 
Your log shows this message when disabling B too.
These are scsi_id error messages.
> 
> Enabling HBA-fabric-A port...
> 
> testhalde2 tmp # multipath -l
> 150gb (3600508b40010079d0001900000460000)
> [size=150 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [enabled][first]
>   \_ 0:0:0:1 sdc  8:32    [ready ][active]
> \_ round-robin 0 [enabled]
>   \_ 1:0:0:1 sda  8:0     [ready ][active]
> 
> testhalde2 tmp # touch /mnt/test/test    # ok
> testhalde2 tmp # rm /mnt/test/test       # ok
> 
> 

> SUMMARY:
> ========
> 
> The failover mechanism seems to work, but it's very very slow (>= 35 sec).
> I am sure that the host will die when I have a lot of I/O's in this moment.
> The documentation says that multipathd "is in charge of checking the paths
> in case they come up or down" and multipathd seems to do nothing... I think
> that is the problem... What do you mean?
> 
Hope the previous comments clarifies a bit.
Also know the 0.4.5 snapshots are largely better suited to the task.
Consider upgrading.
And consider updating the wiki FAQ with the response you found to be
enlightening :/

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
