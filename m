From: christophe varoqui <christophe.varoqui@free.fr>
Subject: kernel BUG
Date: Thu, 07 Apr 2005 23:26:08 +0200
Message-ID: <1112909168.8066.9.camel@zezette>
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

I consistently hit this one with the following scenario :

* multipathd runs
* map configured with multibus policy in the config file
* dmsetup remove the map
* multipath -p failover

here multipath load the failover map, then signals the daemon, which
promptly runs multipath whichs load a multibus map. and BUG.

Also I would like to know if it's expected behaviour the DM_WAIT ioctl
isn't given a chance to unblock upon DM_REMOVE, as it would ease the
thread maintenance in multipathd if it was.

Regards,
cvaroqui

Unable to handle kernel paging request at ffffc20000057080 RIP:
<ffffffff8804fb0c>{:dm_multipath:trigger_event+4}
PGD 4dac067 PUD 4dab067 PMD 4daa067 PTE 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: dm_round_robin iscsi_tcp iscsi_if af_packet ipv6
smbfs tsdev mousedev evdev i2c_amd756 i2c_core hw_random amd74xx
ohci_hcd tg3 ide_generic ide_cd ide_core cdrom ext3 jbd mbcache sd_mod
unix dm_multipath dm_mod mptscsih scsi_mod mptbase
Pid: 6, comm: events/0 Not tainted 2.6.12-rc1
RIP: 0010:[<ffffffff8804fb0c>]
<ffffffff8804fb0c>{:dm_multipath:trigger_event+4}
RSP: 0018:ffff810004f1be60  EFLAGS: 00010247
RAX: ffffc20000057080 RBX: ffff8100f3e75f00 RCX: ffff810004f1bed0
RDX: ffff810004ef9818 RSI: 0000000000000292 RDI: ffff8100f3e75e00
RBP: ffff8100f3e75f08 R08: ffff810004f1a000 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff8011b64f R12: ffff810004ef9800
R13: 0000000000000292 R14: ffff8100f3e75e00 R15: ffffffff8804fb08
FS:  00002aaaab0164a0(0000) GS:ffffffff803d6200(0000)
knlGS:000000005577c560
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffc20000057080 CR3: 00000000f2f35000 CR4: 00000000000006e0
Process events/0 (pid: 6, threadinfo ffff810004f1a000, task
ffff810004df2730)
Stack: ffffffff80142bcc ffff810004ef9840 ffff810004ef9818
ffff810004ef9828
       ffffffffffffffff 0000000000000001 0000000000000000
ffffffff8012d734
       0000000000010000 0000000000000000
Call Trace:<ffffffff80142bcc>{worker_thread+501}
<ffffffff8012d734>{default_wake_function+0}
       <ffffffff8012d782>{__wake_up_common+64}
<ffffffff8012d734>{default_wake_function+0}
       <ffffffff801429d7>{worker_thread+0} <ffffffff80146ce5>{kthread
+218}
       <ffffffff8010f443>{child_rip+8} <ffffffff80146c0b>{kthread+0}
       <ffffffff8010f43b>{child_rip+0}

Code: 48 8b 38 e9 ab 18 ff ff 48 83 ec 18 48 85 f6 48 89 f0 48 89
RIP <ffffffff8804fb0c>{:dm_multipath:trigger_event+4} RSP
<ffff810004f1be60>
CR2: ffffc20000057080

-- 
christophe varoqui <christophe.varoqui@free.fr>
