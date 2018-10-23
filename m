From: =?UTF-8?B?w5Z6a2FuIEfDtmtzdQ==?= <ozkan.goksu@usishi.com>
Subject: Multipathd failed when I remove faulted disk. "segfault
 at 648 error 4 in libmultipath.so.0"
Date: Tue, 23 Oct 2018 14:46:59 +0300
Message-ID: <CAPu=dv1ZUoapd2ACHKNSMUq5OUE304dobP6+EDeqGpJksmp4dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello.

I was have a faulted disk in my 148 disk ZFS pool and I replaced the
disk with a new one but when I remove the disk from Jbod, Multipathd
service failed somehow.
The jbod attached via SAS LSI-3008

What is the problem with the daemon?
How do I prevent this problem happen again?


Faulted disk removed at: Mon Oct 22 11:30:32 2018
New disk inserted at: Mon Oct 22 11:30:40 2018

dmesg:

[Mon Oct 22 11:30:32 2018] sd 10:0:58:0: [sdbg] Synchronizing SCSI cache
[Mon Oct 22 11:30:32 2018] sd 10:0:58:0: [sdbg] Synchronize Cache(10)
failed: Result: hostbyte=0x01 driverbyte=0x00
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing handle(0x0098),
sas_addr(0x5000c5009537e0ad)
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing : enclosure logical
id(0x50030480092b8abf), slot(21)
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing enclosure
level(0x0001), connector name(     )
[Mon Oct 22 11:30:32 2018] sd 10:0:135:0: [sdec] Synchronizing SCSI cache
[Mon Oct 22 11:30:32 2018] sd 10:0:135:0: [sdec] Synchronize Cache(10)
failed: Result: hostbyte=0x01 driverbyte=0x00
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing handle(0x0047),
sas_addr(0x5000c5009537e0ae)
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing : enclosure logical
id(0x50030480092b8abf), slot(21)
[Mon Oct 22 11:30:32 2018] mpt3sas_cm0: removing enclosure
level(0x0001), connector name(     )
[Mon Oct 22 11:30:33 2018] device-mapper: multipath: Failing path 128:64.
[Mon Oct 22 11:30:33 2018] multipathd[5626]: segfault at 648 ip
00007f452e2dc9b9 sp 00007f452e69d960 error 4 in
libmultipath.so.0[7f452e2a2000+4c000]

Multipathd daemon log:

-- Logs begin at Mon 2018-04-16 14:30:14 +03. --
Oct 22 11:30:33 YL-CTRL1 multipathd[5612]: sdbg: remove path (uevent)
Oct 22 11:30:33 YL-CTRL1 multipathd[5612]: sdec: No SAS end device for
'end_device-10:5'
Oct 22 11:30:33 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: load
table [0 15628053168 multipath 0 0 1 1 service-time 0 1 1 128:64 1
Oct 22 11:30:33 YL-CTRL1 multipathd[5612]: ]
Oct 22 11:30:33 YL-CTRL1 multipathd[5612]: sdbg [67:160]: path removed
from map 35000c5009537e0af
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 128:64: cannot find block device
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: checker failed path 128:64
in map 35000c5009537e0af
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af:
remaining active paths: 0
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 128:64: cannot find block device
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: sdec: remove path (uevent)
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: map flushed
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: stop
event checker thread (139935041709824)
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: removed
map after removing all paths
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: adding map
Oct 22 11:30:34 YL-CTRL1 multipathd[5612]: 35000c5009537e0af: devmap dm-44 added
Oct 22 11:30:36 YL-CTRL1 systemd[1]: multipathd.service: Main process
exited, code=killed, status=11/SEGV
Oct 22 11:30:36 YL-CTRL1 systemd[1]: multipathd.service: Failed with
result 'signal'.

Full Dmesg: https://paste.ubuntu.com/p/DDbxBdVnKs/


Multipath Conf:
defaults {
user_friendly_names no
  path_grouping_policy failover
}
blacklist_exceptions {
        property "(ID_WWN|SCSI_IDENT_.*|ID_SERIAL)"
}

Versions:
device-mapper 2.02.177-5
multipath-tools 0.7.6-1
 kernel: 4.14.30-1-lts
