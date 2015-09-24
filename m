From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: v4.3-rc2 dm-mq bug
Date: Thu, 24 Sep 2015 12:09:34 -0700
Message-ID: <56044A6E.90900@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Mike,

The below was reported while testing the SRP initiator in kernel
v4.3-rc2 with scsi-mq and dm-mq enabled. Can you have a look at this ?

Thanks,

Bart.

------------[ cut here ]------------
kernel BUG at drivers/md/dm.c:2811!
invalid opcode: 0000 [#1] SMP 
Modules linked in: dm_queue_length ib_srp(O) scsi_transport_srp(O) netconsole configfs af_packet msr sg coretemp x86_pkg_temp_thermal crct10dif_pclmul crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ipmi_devintf ablk_helper cryptd tg3 lpc_ich microcode pcspkr libphy mfd_core ipmi_si ipmi_msghandler ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad dm_multipath dm_mod rdma_cm ib_cm acpi_power_meter hwmon iw_cm processor button wmi ext4 crc16 mbcache jbd2 mlx4_ib mlx4_en ib_sa ptp pps_core ib_mad ib_core ib_addr sd_mod sr_mod cdrom hid_generic usbhid hid ahci libahci libata ehci_pci ehci_hcd mlx4_core usbcore usb_common scsi_mod autofs4 [last unloaded: brd]
CPU: 0 PID: 334 Comm: kworker/0:1H Tainted: G        W  O    4.3.0-rc2-debug+ #1
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
Workqueue: kblockd blk_mq_run_work_fn
task: ffff880450604380 ti: ffff880465864000 task.ti: ffff880465864000
RIP: 0010:[<ffffffffa03db95d>]  [<ffffffffa03db95d>] dm_get+0x1d/0x20 [dm_mod]
RSP: 0018:ffff880465867c90  EFLAGS: 00010202
RAX: 0000000000000018 RBX: ffff88006cc5a520 RCX: 000000010000affd
RDX: 0000000000000000 RSI: ffffffff81a47140 RDI: ffff88006cc5a520
RBP: ffff880465867c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8804036c0600
R13: ffffc90000ca0040 R14: ffff88040429f620 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88047fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560a1f749178 CR3: 000000044d3f8000 CR4: 00000000001406f0
Stack:
 ffff880465867cb8 ffffffffa03dba40 ffff88006cc5a520 ffff8804036c0600
 ffff88006cc5a520 ffff880465867cf8 ffffffffa03dbd95 0000000100000001
 ffff8804034ba4f8 ffff880465867d20 0000000000000000 ffff8804036c0600
Call Trace:
 [<ffffffffa03dba40>] dm_start_request+0x60/0x100 [dm_mod]
 [<ffffffffa03dbd95>] dm_mq_queue_rq+0xa5/0x240 [dm_mod]
 [<ffffffff81273275>] __blk_mq_run_hw_queue+0x1c5/0x360
 [<ffffffff812739d5>] blk_mq_run_work_fn+0x15/0x20
 [<ffffffff8108d9b8>] process_one_work+0x1d8/0x610
 [<ffffffff8108d92b>] ? process_one_work+0x14b/0x610
 [<ffffffff8108df04>] worker_thread+0x114/0x460
 [<ffffffff8108ddf0>] ? process_one_work+0x610/0x610
 [<ffffffff810941f8>] kthread+0xf8/0x110
 [<ffffffff81094100>] ? kthread_create_on_node+0x200/0x200
 [<ffffffff814f5eaf>] ret_from_fork+0x3f/0x70
 [<ffffffff81094100>] ? kthread_create_on_node+0x200/0x200
Code: 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 f0 ff 87 d0 01 00 00 48 8b 87 70 02 00 00 a8 08 75 02 5d c3 <0f> 0b 90 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 c7 c7 a0 b0 
RIP  [<ffffffffa03db95d>] dm_get+0x1d/0x20 [dm_mod]
 RSP <ffff880465867c90>
---[ end trace e0f10c6e2c55ad9a ]---
