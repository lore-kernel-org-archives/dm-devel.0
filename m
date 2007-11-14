From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Errors using RDAC
Date: Wed, 14 Nov 2007 13:25:11 +0100
Message-ID: <1195043111.8105.12.camel@sanderbal>
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
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

I get these errors in my log and I just had an interuption in our
production traffic:

Nov 11 16:01:09 storage kernel: iscsi_trgt: Abort Task (01) issued on
tid:1 lun:0 by sid:4503599664923136 (Unknown Task)
Nov 11 16:16:21 storage kernel: printk: 21 messages suppressed.
Nov 11 16:16:21 storage kernel: multipathd[2246]: segfault at
ffffffff005564d8 rip 00002b3302f58969 rsp 00007fffa8292f10 error 4
Nov 11 16:17:11 storage kernel: iSCSI Enterprise Target Software -
version 0.4.15
Nov 11 16:17:11 storage kernel: iscsi_trgt: Registered io type fileio
Nov 11 16:17:11 storage kernel: iscsi_trgt: Registered io type blockio
Nov 11 16:17:11 storage kernel: iscsi_trgt: Registered io type nullio
Nov 11 16:18:54 storage kernel: multipathd[6895]: segfault at
000000000000000a rip 00002b251f24394f rsp 00007fff8bfaa730 error 4
Nov 11 16:18:55 storage kernel: device-mapper: multipath rdac: using
RDAC command with timeout 6000
Nov 11 16:18:55 storage last message repeated 3 times
Nov 11 16:19:39 storage kernel: iSCSI Enterprise Target Software -
version 0.4.15
Nov 11 16:19:39 storage kernel: iscsi_trgt: Registered io type fileio
Nov 11 16:19:39 storage kernel: iscsi_trgt: Registered io type blockio
Nov 11 16:19:39 storage kernel: iscsi_trgt: Registered io type nullio

And:

Nov 14 00:21:24 storage kernel: mptbase: ioc0: LogInfo(0x31170000):
Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Nov 14 00:21:29 storage last message repeated 9 times
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
269463016
Nov 14 00:21:29 storage kernel: device-mapper: multipath: Failing path
8:16.
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] <4>device-mapper:
multipath: Failing path 8:64.
Nov 14 00:21:29 storage kernel: Result: hostbyte=DID_BUS_BUSY
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
283090968
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
172519528
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
78335920
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
337302112
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
351580640
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
303461376
Nov 14 00:21:29 storage kernel: sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 14 00:21:29 storage kernel: end_request: I/O error, dev sdb, sector
310074128
Nov 14 00:21:29 storage kernel: device-mapper: multipath rdac: queueing
MODE_SELECT command on 8:80
Nov 14 00:21:39 storage kernel: mptbase: ioc0: LogInfo(0x31170000):
Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Nov 14 00:21:39 storage kernel: device-mapper: multipath: Failing path
8:48.
Nov 14 00:21:52 storage kernel: mptbase: ioc0: LogInfo(0x31170000):
Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Nov 14 00:21:52 storage kernel: device-mapper: multipath: Failing path
8:32.
Nov 14 00:21:55 storage kernel: mptbase: ioc0: LogInfo(0x31170000):
Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Nov 14 00:21:59 storage last message repeated 2 times
Nov 14 00:22:02 storage kernel: iscsi_trgt: Abort Task (01) issued on
tid:1 lun:0 by sid:844425001239040 (Unknown Task)
Nov 14 00:22:10 storage kernel: mptbase: ioc0: LogInfo(0x31170000):
Originator={PL}, Code={IO Device Missing Delay Retry}, SubCode(0x0000)
Nov 14 00:22:29 storage last message repeated 3 times
Nov 14 00:23:33 storage kernel: device-mapper: multipath rdac: queueing
MODE_SELECT command on 8:16
Nov 14 00:23:33 storage kernel: device-mapper: multipath rdac:
MODE_SELECT failed on 8:16 with sense 0x63f0e
Nov 14 00:23:33 storage kernel: device-mapper: multipath: Failing path
8:16.
Nov 14 00:24:06 storage kernel: device-mapper: multipath rdac: queueing
MODE_SELECT command on 8:16
Nov 14 00:24:06 storage kernel: device-mapper: multipath rdac:
MODE_SELECT failed on 8:16 with sense 0x62904
Nov 14 00:24:06 storage kernel: device-mapper: multipath: Failing path
8:16.
Nov 14 00:24:38 storage kernel: device-mapper: multipath rdac: queueing
MODE_SELECT command on 8:16


Could anyone tell me what is wrong? I didn't had these errors when using
RDAC without the hardwarehandler en with kernel 2.6.22.2

Hope someone can help me with this and tell me how serious this is!

Sander
