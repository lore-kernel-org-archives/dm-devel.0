From: Pavel Stano <stanojr@blackhole.sk>
Subject: multipath problem
Date: Thu, 18 Oct 2007 21:37:43 +0200
Message-ID: <4717B607.10706@blackhole.sk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

hello

i have strange problem with multipath
my configuration is: sunfire x4100 with 2 lsi sas 3442-e cards connected
to promise vtrak e310s (mptsas driver)

after i boot and multipath-tools is not installed, it look like this
redneck:~# lsscsi
[0:0:0:0]    cd/dvd  AMI      Virtual CDROM    1.00  /dev/scd0
[1:0:0:0]    disk    AMI      Virtual Floppy   1.00  /dev/sdb
[2:0:0:0]    disk    Promise  VTrak E310s      0322  /dev/sda
[3:0:0:0]    disk    Promise  VTrak E310s      0322  /dev/sdc
[4:0:0:0]    disk    SEAGATE  ST973402SSUN72G  0400  -
[4:0:1:0]    disk    SEAGATE  ST973402SSUN72G  0400  -
[4:1:0:0]    disk    LSILOGIC Logical Volume   3000  /dev/sdd

redneck:~# pvs
  Found duplicate PV tS0KIb4H0CVGAspUqdWIkZSUVSwMlwib: using /dev/sdc
not /dev/sda
  PV         VG   Fmt  Attr PSize PFree
  /dev/sdc   vg0  lvm2 a-   2.32T 3.00G

and i want create multipath failover device with sda and sdc (and on top
of that device i want use LVM)

when i install multipath-tools (debian 4.0)
apt-get install multipath-tools
it automatically start multipathd, but it is in D state, it freeze somewhere
multipathd -k dont work
sda/sdc is not accessible, every proces accessing sda/sdc go to D state
and after some minutes there are some mesasges from kernel:

Oct 18 21:00:15 redneck kernel: mptscsih: ioc1: attempting task abort!
(sc=ffff8102157fc080)
Oct 18 21:00:15 redneck kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00
00 00 00 00 00 00 01 00
Oct 18 21:00:19 redneck kernel: mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 18 21:00:19 redneck kernel: mptscsih: ioc0: task abort: SUCCESS
(sc=ffff8102157fc080)
Oct 18 21:00:29 redneck kernel: mptscsih: ioc0: attempting task abort!
(sc=ffff8102157fc080)
Oct 18 21:00:29 redneck kernel: sd 0:0:0:0: [sda] CDB: Test Unit Ready:
00 00 00 00 00 00
Oct 18 21:00:34 redneck kernel: mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 18 21:00:34 redneck kernel: mptscsih: ioc0: task abort: SUCCESS
(sc=ffff8102157fc080)
Oct 18 21:00:34 redneck kernel: mptscsih: ioc0: attempting task abort!
(sc=ffff8104163c30c0)
Oct 18 21:00:34 redneck kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00
00 00 00 00 00 00 01 00
Oct 18 21:00:39 redneck kernel: mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 19 21:00:39 redneck kernel: mptscsih: ioc0: task abort: SUCCESS
(sc=ffff8104163c30c0)
Oct 18 21:00:49 redneck kernel: mptscsih: ioc0: attempting task abort!
(sc=ffff8104163c30c0)
Oct 18 21:00:49 redneck kernel: sd 0:0:0:0: [sda] CDB: Test Unit Ready:
00 00 00 00 00 00
Oct 18 21:00:50 redneck kernel: mptbase: ioc0: LogInfo(0x31140000):
Originator={PL}, Code={IO Executed}, SubCode(0x0000)
Oct 18 21:00:50 redneck kernel: mptscsih: ioc0: Response
Code(0x00000005): F/W: The requested task failed.
Oct 18 21:00:50 redneck kernel: mptscsih: ioc0: task abort: SUCCESS
(sc=ffff8104163c30c0)
Oct 18 21:00:50 redneck kernel: mptscsih: ioc0: attempting target reset!
(sc=ffff8102157fc080)
Oct 18 21:00:50 redneck kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00
00 00 00 00 00 00 01 00
Oct 18 21:00:52 redneck kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Oct 18 21:00:52 redneck kernel: mptscsih: ioc0: target reset: FAILED
(sc=ffff8102157fc080)
Oct 18 21:00:52 redneck kernel: mptscsih: ioc0: attempting bus reset!
(sc=ffff8102157fc080)
Oct 18 21:00:52 redneck kernel: sd 0:0:0:0: [sda] CDB: Read(10): 28 00
00 00 00 00 00 00 01 00
Oct 18 21:01:07 redneck kernel: mptbase: Initiating ioc0 recovery
Oct 18 21:01:07 redneck kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Oct 18 21:01:07 redneck kernel: mptscsih: ioc0: bus reset: FAILED
(sc=ffff8102157fc080)
Oct 18 21:01:07 redneck kernel: mptscsih: ioc0: attempting host reset!
(sc=ffff8102157fc080)
Oct 18 21:01:07 redneck kernel: mptbase: Initiating ioc0 recovery
Oct 18 21:01:21 redneck kernel: mptscsih: ioc0: host reset: SUCCESS
(sc=ffff8102157fc080)
Oct 18 21:01:21 redneck kernel: sd 0:0:0:0: scsi: Device offlined - not
ready after error recovery
Oct 18 21:01:21 redneck kernel: sd 0:0:0:0: scsi: Device offlined - not
ready after error recovery
Oct 18 21:01:21 redneck kernel: sd 0:0:0:0: rejecting I/O to offline device

where can be the problem ? in mptsas/mptscsih/mptbase driver or
dm-multipath ?

thanks
-- 
Pavel Stano
