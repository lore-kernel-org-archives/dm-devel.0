From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: Problems with multipathd
Date: Tue, 06 Sep 2005 22:47:27 +0200
Message-ID: <1126039647.9859.89.camel@zezette>
References: <20050831152928.GA53290@sysconfig.de>
	<1125518162.6375.52.camel@zezette>  <431DC7D6.1010900@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <431DC7D6.1010900@gmx.de>
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

On mar, 2005-09-06 at 18:46 +0200, gistolero@gmx.de wrote:
> Hi,

>  > Lower the timeouts in your Qlogic driver.
> 
> ===> I found some settings in /sys/module/qla2xxx/parameters/...,
> but most of them are read-only values. I have changed ql2xretrycount
> and ql2xsuspendcount but without success. Any suggestions for
> this driver?
> 
Here are the interesting one I guess.

[root@s64p17bibro ~]# find /sys/class/ -name "*tmo*"
/sys/class/fc_remote_ports/rport-1:0-3/dev_loss_tmo
/sys/class/fc_remote_ports/rport-1:0-2/dev_loss_tmo
/sys/class/fc_remote_ports/rport-1:0-1/dev_loss_tmo
/sys/class/fc_remote_ports/rport-1:0-0/dev_loss_tmo
/sys/class/scsi_host/host1/lpfc_nodev_tmo

> 
> I.) --- udev and udevstart ---
> 
> 
>  > Default udev.rules file has a directive to ignore dm-*
>  > Something like :
>  > KERNEL=="dm-[0-9]*", OPTIONS+="ignore_device"
>  >
>  > /etc/udev/rules.d/20-multipath.rules is useless unless you you comment
>  > out this rule.
> 
> I have commented this line, but udev still has difficulties to create this
> links. Therefore I have changed /etc/dev.d/block/multipath.dev (the script
> is attached at the end of this post) and added debug messages. The most
> important modification is that kpartx uses the block-device-files in
> /dev/mapper/... instead of /dev/...
> ===> Why isn't that the default? Are there any disadvantages?
> 
Not really. All distributors seem to have their own ideas about naming
policies. You should ask about, and follow the Gentoo philosophy I
guess.

> 
> ===> Without "udevstart" udev doesn't create the /dev/150gb*
> links! Is this a udev bug?
> 
You can still identify the udev problems keeping the node creation
in /dev/. Maybe all path setupis done in the initrd/initramfs without
multipath being able to react.


> Yeah! Version 0.4.5 creates a pid and a socket file :-)
> It's important that I start "multipath /dev/sda" _before_
> multipathd! If I change this order, multipathd does nothing.
> /var/log/messages shows "tick", "map garbage collection"
> etc. and nothing about /dev/sda or /dev/sdb. It seems that
> multipathd doesn't read the device-mapper table at startup.
> ===> Is this behavior ok?
> 
No, and I don't reproduce this behaviour here.

<no map loaded>

[root@s64p17bibro multipath-tools-0.4.5]# multipathd -d
path checkers start up

<run /sbin/multipath>

device-mapper ioctl cmd 12 failed: No such device or address
ema4_lun1: event checker started
8:16: hp_sw checker reports path is up
8:16: reinstated
8:48: hp_sw checker reports path is ghost
8:48: reinstated

> ...
> 
> 
> ===> First multipathd says "8:0: tur checker reports
> path is down" and multipath prints sda "failed" (ok).
> After a few seconds sda is "ready" and multipathd says
> "8:0: tur checker reports path is up"?! I have changed
> nothing during this time.
> 
Maybe the checker is confused by the long timeouts.
Worth another try after the lowering.


> *** Enabling san-switch port from HBA-1 ***
> 
> 
> testhalde2 ~ # multipath -ll
> testhalde2 ~ # dmsetup table
> 150gb1: 0 64197 linear 254:0 63
> 150gb2: 0 314504505 linear 254:0 64260
> 
> 
> testhalde2 ~ # less /var/log/messages
> ...
> multipathd: tick
> kernel: qla2300 0000:03:01.0: LIP reset occured (f7f7).
> kernel: qla2300 0000:03:01.0: LOOP UP detected (2 Gbps).
> ...
> kernel: SCSI device sdc: drive cache: write through
> kernel:  sdc: sdc1 sdc2
> kernel: Attached scsi disk sdc at scsi0, channel 0, id 0, lun 1
> kernel: Attached scsi generic sg1 at scsi0, channel 0, id 0, lun 1,  type 0
> scsi.agent[11856]: disk at /devices/pci0000:03/0000:03:01.0/host0/rport-0:0-3/target0:0:0/0:0:0:1
> /etc/dev.d/multipath.dev (11909): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc, $ACTION=add, $@=block
> /etc/dev.d/multipath.dev (11909): Logging to local file is enabled: log file is /root/multipath.dev.log
> /etc/dev.d/multipath.dev (11909): Logging to syslog ist enabled: facility.priority is daemon.info
> /etc/dev.d/multipath.dev (11909): Checking/Creating multipath device-mapper table with multipath-tool
> /etc/dev.d/multipath.dev (11909): multipath -v0 /dev/sdc
> multipathd: Got request [dump pathvec]
> multipathd: *word = dump, len = 4
> multipathd: *word = pathvec, len = 7
> multipathd: tick
> multipathd: tick
> multipathd: Got request [dump pathvec]
> multipathd: *word = dump, len = 4
> multipathd: *word = pathvec, len = 7
> multipathd: tick
> last message repeated 2 times
> multipathd: map garbage collection
> kernel: device-mapper: dm-multipath: error getting device
> kernel: device-mapper: error adding target to table
> /etc/dev.d/multipath.dev (11944): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc2, $ACTION=add, $@=block
> /etc/dev.d/multipath.dev (11944): Logging to local file is enabled: log file is /root/multipath.dev.log
> /etc/dev.d/multipath.dev (11944): Logging to syslog ist enabled: facility.priority is daemon.info
> /etc/dev.d/multipath.dev (11959): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc1, $ACTION=add, $@=block
> /etc/dev.d/multipath.dev (11959): Logging to local file is enabled: log file is /root/multipath.dev.log
> /etc/dev.d/multipath.dev (11959): Logging to syslog ist enabled: facility.priority is daemon.info
> /etc/dev.d/multipath.dev (11959): Checking/Creating multipath device-mapper table with multipath-tool
> /etc/dev.d/multipath.dev (11959): multipath -v0 /dev/sdc1
> multipathd: Got request [dump pathvec]
> multipathd: *word = dump, len = 4
> multipathd: *word = pathvec, len = 7
> logger: /etc/dev.d/multipath.dev (11944): Checking/Creating multipath device-mapper table with multipath-tool
> logger: /etc/dev.d/multipath.dev (11944): multipath -v0 /dev/sdc2
> multipathd: Got request [dump pathvec]
> multipathd: *word = dump, len = 4
> multipathd: *word = pathvec, len = 7
> multipathd: tick
> last message repeated 2 times
> multipathd: Got request [dump pathvec]
> multipathd: *word = dump, len = 4
> multipathd: *word = pathvec, len = 7
> multipathd: tick
> multipathd: tick
> kernel: device-mapper: dm-multipath: error getting device
> kernel: device-mapper: error adding target to table
> kernel: device-mapper: device doesn't appear to be in the dev hash table.
> multipathd: tick
> multipathd: map garbage collection
> multipathd: 150gb: remove dead map
> multipathd: 150gb: reap event checker
> multipathd: 8:0 is orphaned
> multipathd: 8:16 is orphaned
> multipathd: SIGHUP received
> multipathd: tick
> multipathd: tick
> /etc/dev.d/multipath.dev (12002): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-3, $ACTION=remove, $@=block
> /etc/dev.d/multipath.dev (12002): Logging to local file is enabled: log file is /root/multipath.dev.log
> /etc/dev.d/multipath.dev (12002): Logging to syslog ist enabled: facility.priority is daemon.info
> /etc/dev.d/multipath.dev (12002): Exiting: $ACTION != "add"
> /etc/dev.d/multipath.dev (12018): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-4, $ACTION=remove, $@=block
> /etc/dev.d/multipath.dev (12018): Logging to local file is enabled: log file is /root/multipath.dev.log
> /etc/dev.d/multipath.dev (12018): Logging to syslog ist enabled: facility.priority is daemon.info
> /etc/dev.d/multipath.dev (12018): Exiting: $ACTION != "add"
> multipathd: tick
> ...
> 
> 
> ===> An error occurs while device-mapper tries to update
> the dm-table and deletes the "150gb" entry.
> 
Seems to point to a kernel issue.
FYI, /bin/multipath alone tries to update the map.

> 
> 
> III.) --- Using multipath-tools without multipath ---
> 
> Now, I try the same _without_ starting multipathd...
> 
> ===> Multipathing seems to work without but not with multipathd.
> It's very slow, but Christophe Varoqui wrote that I have to lower
> the HBA timeouts (unfortunately, I don't know how to do this,
> see above). Does I really need multipathd? I suppose so :-)
> 
multipathd is needed to reinstate paths.
In your case the rport disappears and reappears so the mecanism is all
hotplug-driven and thus may work without the daemon ... if memory
ressources permits hotplug and multipath(8) execution, that is.
> 

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
