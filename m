From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Wed, 23 Nov 2011 18:22:27 +0100
Message-ID: <CAG2kNCw9ZdWrk1Ai6xQ=gDeMeV22verUQWw8+18yWNMjscuPMg@mail.gmail.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
	<1321389505.23295.4.camel@lapoo.opensvc.com>
	<CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
	<201111161424.50911.hirtejs@idmt.fraunhofer.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201111161424.50911.hirtejs@idmt.fraunhofer.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Wed, Nov 16, 2011 at 2:24 PM, Johannes Hirte  wrote:
[snip]
> Yes, this is because the rdac module detected the LUN in AVT mode and refused
> to work with it. This will happen every time you access a ghost path without
> rdac.

>
>> - On the presented LUN I configured a PV, VG, LV and ext4 fs (not system fs)
>> At reboot at host side I see messages related to duplicated PV IDs for
>> the paths (sdb, sdc, sdd, sde): they comes before vg activation and
>> before multipathd start...
>> Is this normal, because at the first vgscan run during boot, multipath
>> configuration has not been instantiated yet..?
>> I have to check, but I don't remember similar messages with eh el 5.7
>> in other SAN configurations, where the VG is not a system VG....
>
> You should avoid to access the sdX directly. If you need to run lvm before
> multipath is up, you can blacklist the sdX in the lvm.conf.


So I configured:
- LUN on DS4700 as LNXCLVMWARE that I found should disable AVT
- multipath as standard without any particular setting (I only
blacklisted the internal disk)

At the start time of the system I get (both in console and then I
found it in /var/log/messages too):

Nov 23 17:32:56 testserver kernel:  sdc:end_request: I/O error, dev
sdb, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdb,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdc, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdc,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdb,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdc, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdc,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdb,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdc, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdc,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdb,
logical block 0
Nov 23 17:32:56 testserver kernel: end_request: I/O error, dev sdc, sector 0
Nov 23 17:32:56 testserver kernel: Buffer I/O error on device sdc,
logical block 0

This happens for sdb ad sdc only (probably passive controller disk paths?)

And this other ones:
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb,
sector 7320493952
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb,
sector 7320494064
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb, sector 8
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdb, sector 0
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdc, sector 0
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdc,
sector 7320493952
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdc,
sector 7320494064
Nov 23 17:32:58 testserver kernel: end_request: I/O error, dev sdc, sector 0
...
then
Nov 23 17:33:00 testserver kernel: device-mapper: multipath: version
1.0.6 loaded
Nov 23 17:33:00 testserver kernel: sd 3:0:0:1: rdac: LUN 1 (unowned)
Nov 23 17:33:00 testserver kernel: sd 3:0:1:1: rdac: LUN 1 (owned)
Nov 23 17:33:00 testserver kernel: sd 4:0:0:1: rdac: LUN 1 (unowned)
Nov 23 17:33:00 testserver kernel: sd 4:0:1:1: rdac: LUN 1 (owned)
Nov 23 17:33:01 testserver kernel: rdac: device handler registered
Nov 23 17:33:01 testserver kernel: device-mapper: multipath: Using
scsi_dh module scsi_dh_rdac for failover/failback and device
management.
Nov 23 17:33:01 testserver kernel: device-mapper: multipath
round-robin: version 1.0.0 loaded
Nov 23 17:33:01 testserver kernel: sd 3:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, queueing MODE_SELECT command
Nov 23 17:33:01 testserver kernel: sd 3:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, MODE_SELECT completed
Nov 23 17:33:01 testserver kernel: sd 4:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, queueing MODE_SELECT command
Nov 23 17:33:01 testserver kernel: sd 4:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, MODE_SELECT completed
Nov 23 17:33:01 testserver kernel: end_request: I/O error, dev sdd,
sector 7320494072
Nov 23 17:33:01 testserver kernel: printk: 4 messages suppressed.
Nov 23 17:33:01 testserver kernel: Buffer I/O error on device sdd,
logical block 915061759
Nov 23 17:33:01 testserver kernel: end_request: I/O error, dev sde,
sector 7320494072
Nov 23 17:33:02 testserver kernel: printk: 49 messages suppressed.
Nov 23 17:33:02 testserver kernel: Buffer I/O error on device sde,
logical block 0
Nov 23 17:33:02 testserver kernel: Buffer I/O error on device sde,
logical block 2
Nov 23 17:33:02 testserver kernel: Buffer I/O error on device sde,
logical block 3

And then no other I/O error messages. Donna if this is avoidable or not....

So after complete startup the situation is:
[root@testserver ~]# multipath -l
mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:0:1 sdb 8:16  [active][undef]
 \_ 4:0:0:1 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:1:1 sdd 8:48  [active][undef]
 \_ 4:0:1:1 sde 8:64  [active][undef]

When I activate the LVM on mpath1 PV and mount the file system:
Nov 23 17:34:31 testserver kernel: EXT4-fs (dm-7): mounted filesystem
with ordered data mode
Nov 23 17:34:47 testserver kernel: JBD: barrier-based sync failed on
dm-7-8 - disabling barriers
--> donna if it is to be intended as a problem

I instantiate I/O without problems.

Then I test to change active controller for the lun at DS4700 side
during a running I/O session (dd seq read of 10Gb) , and I get
Nov 23 17:43:02 testserver kernel: end_request: I/O error, dev sdb,
sector 2110328
Nov 23 17:43:02 testserver kernel: device-mapper: multipath: Failing path 8:16.
Nov 23 17:43:02 testserver multipathd: 8:16: mark as failed
Nov 23 17:43:02 testserver multipathd: mpath1: remaining active paths: 3
Nov 23 17:43:02 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:02 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:03 testserver kernel: end_request: I/O error, dev sdc,
sector 2110328
Nov 23 17:43:03 testserver kernel: device-mapper: multipath: Failing path 8:32.
Nov 23 17:43:03 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:03 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:03 testserver multipathd: 8:32: mark as failed
Nov 23 17:43:03 testserver multipathd: mpath1: remaining active paths: 2
Nov 23 17:43:06 testserver multipathd: sdb: rdac checker reports path is ghost
Nov 23 17:43:06 testserver multipathd: 8:16: reinstated
Nov 23 17:43:06 testserver multipathd: mpath1: remaining active paths: 3
Nov 23 17:43:06 testserver kernel: device-mapper: multipath: Using
scsi_dh module scsi_dh_rdac for failover/failback and device
management.
Nov 23 17:43:06 testserver multipathd: mpath1: load table [0
7320494080 multipath 0 1 rdac 2 1 round-robin 0 3 1 8:32 1000 8:48
1000 8:64 1000 round-robin 0 1 1 8:16
Nov 23 17:43:06 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:06 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:06 testserver kernel: device-mapper: multipath: Failing path 8:32.
Nov 23 17:43:06 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:06 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:06 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:06 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:07 testserver multipathd: sdc: rdac checker reports path is ghost
Nov 23 17:43:07 testserver multipathd: 8:32: reinstated
Nov 23 17:43:07 testserver kernel: sd 4:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, queueing MODE_SELECT command
Nov 23 17:43:07 testserver multipathd: mpath1: remaining active paths: 4
Nov 23 17:43:07 testserver kernel: device-mapper: multipath: Using
scsi_dh module scsi_dh_rdac for failover/failback and device
management.
Nov 23 17:43:08 testserver kernel: sd 4:0:0:1: rdac: array
Z1_BEIC_DS4700, ctlr 0, MODE_SELECT completed
Nov 23 17:43:08 testserver multipathd: mpath1: load table [0
7320494080 multipath 0 1 rdac 2 1 round-robin 0 2 1 8:48 1000 8:64
1000 round-robin 0 2 1 8:32 1000 8:16
Nov 23 17:43:08 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:08 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:08 testserver multipathd: dm-6: add map (uevent)
Nov 23 17:43:08 testserver multipathd: dm-6: devmap already registered
Nov 23 17:43:08 testserver kernel: sd 3:0:1:1: rdac: array
Z1_BEIC_DS4700, ctlr 1, queueing MODE_SELECT command
Nov 23 17:43:10 testserver kernel: sd 3:0:1:1: rdac: array
Z1_BEIC_DS4700, ctlr 1, MODE_SELECT completed
Nov 23 17:43:10 testserver kernel: sd 4:0:1:1: rdac: array
Z1_BEIC_DS4700, ctlr 1, queueing MODE_SELECT command
Nov 23 17:43:11 testserver kernel: sd 4:0:1:1: rdac: array
Z1_BEIC_DS4700, ctlr 1, MODE_SELECT completed
Nov 23 17:43:12 testserver multipathd: sdd: rdac checker reports path is up
Nov 23 17:43:12 testserver multipathd: 8:48: reinstated
Nov 23 17:43:12 testserver multipathd: sde: rdac checker reports path is up
Nov 23 17:43:12 testserver multipathd: 8:64: reinstated

The overall increased time is 3-4 seconds for a 1 minute I/O period
Without failover:
[root@testserver ~]# time dd if=/testfs/testfile bs=1024k count=10000
of=/dev/null
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 61.9951 seconds, 169 MB/s

real	1m1.996s
user	0m0.002s
sys	0m7.088s

With change of active controller in the mid:
[root@testserver ~]# time dd if=/testfs/testfile1 bs=1024k count=10000
of=/dev/null
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 65.6529 seconds, 160 MB/s

real	1m5.654s
user	0m0.007s
sys	0m7.175s

So, quite good, and without error at user side.

at the end the multipath config is this:
[root@testserver ~]# multipath -l
mpath1 (3600a0b80005012440000093e4a55cf33) dm-6 IBM,1814      FAStT
[size=3.4T][features=1 queue_if_no_path][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:1:1 sdd 8:48  [active][undef]
 \_ 4:0:1:1 sde 8:64  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 4:0:0:1 sdc 8:32  [active][undef]
 \_ 3:0:0:1 sdb 8:16  [active][undef]

Questions:

1) Can I conclude it is ok as a configuration? Or any other tests to carry on?
I confirm I didn't get any snmp trap from the ds4700 as happened before...

2) At the moment I put this in lvm.conf to whitelist the root volume
groups and blacklist the san individual paths and then delete the
.cache file and reboot
filter = [ "a/dev/mapper/.*/", "a/dev/sda/", "a/dev/sda2/", "r/dev/sd.*/" ]
Is this ok?
If root PV is on sda2, do I need to whitelist both sda and sda2 or only sda2?

3) Based on messages during failover, is it true that I can avoid
explicitly put scsi_dh in initrd?
If I create initrd this way:
mkinitrd /boot/initrd-$(uname -r)-scsi_dh.img $(uname -r) --preload=scsi_dh_rdac
I get this difference:
[root@testserver ~]# diff /tmp/new/init /tmp/current/init
44,51d43
< echo "Loading scsi_mod.ko module"
< insmod /lib/scsi_mod.ko
< echo "Loading sd_mod.ko module"
< insmod /lib/sd_mod.ko
< echo "Loading scsi_dh.ko module"
< insmod /lib/scsi_dh.ko
< echo "Loading scsi_dh_rdac.ko module"
< insmod /lib/scsi_dh_rdac.ko
62a55,58
> echo "Loading scsi_mod.ko module"
> insmod /lib/scsi_mod.ko
> echo "Loading sd_mod.ko module"
> insmod /lib/sd_mod.ko

or will it help in any way?
BTW: The I/O tests above were done with standard initrd (so the > side
of the diff without the scsi_dh_rdac)
I only run the mkinitrd to sort out how would have been create the init file...

4) the san lun is 3.4Tb and I'm going to add another one of about 5Tb
In messages I see this
Nov 23 17:32:58 testserver kernel: sde : very big device. try to use
READ CAPACITY(16).

I found in an old kernel ml post that actually it should mean "trying
to use" ... so only informational message.
Can anyone confirm this?

Thanks again in advance for your help,
Gianluca
