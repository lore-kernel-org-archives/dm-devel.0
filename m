From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] rq-based dm: fix an oops on no-path with
	fail_if_no_path
Date: Wed, 29 Jul 2009 15:16:35 +0900
Message-ID: <4A6FE943.2020204@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

I hit the following oops in request-based dm when I do I/O to
a multipath device which doesn't have any active path nor
queue_if_no_path setting.

------------[ cut here ]------------
kernel BUG at /root/2.6.31-rc4.rqdm/drivers/md/dm.c:828!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 1 
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq dm_mirror dm_region_hash dm_log dm_service_time dm_multipath scsi_dh dm_mod video output sbs sbshc battery ac sg sr_mod e1000e button cdrom serio_raw rtc_cmos rtc_core rtc_lib piix lpfc scsi_transport_fc ata_piix libata megaraid_sas sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 7, comm: ksoftirqd/1 Not tainted 2.6.31-rc4.rqdm #1 Express5800/120Lj [N8100-1417]
RIP: 0010:[<ffffffffa023629d>]  [<ffffffffa023629d>] dm_softirq_done+0xbd/0x100 [dm_mod]
RSP: 0018:ffff8800280a1f08  EFLAGS: 00010282
RAX: ffffffffa02544e0 RBX: ffff8802aa1111d0 RCX: ffff8802aa1111e0
RDX: ffff8802ab913e70 RSI: 0000000000000000 RDI: ffff8802ab913e70
RBP: ffff8800280a1f28 R08: ffffc90005457040 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 00000000fffffffb
R13: ffff8802ab913e88 R14: ffff8802ab9c1438 R15: 0000000000000100
FS:  0000000000000000(0000) GS:ffff88002809e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000003d54a98640 CR3: 000000029f0a1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ksoftirqd/1 (pid: 7, threadinfo ffff8802ae50e000, task ffff8802ae4f8040)
Stack:
 ffff8800280a1f38 0000000000000020 ffffffff814f30a0 0000000000000004
<0> ffff8800280a1f58 ffffffff8116b245 ffff8800280a1f38 ffff8800280a1f38
<0> ffff8800280a1f58 0000000000000001 ffff8800280a1fa8 ffffffff810477bc
Call Trace:
 <IRQ> 
 [<ffffffff8116b245>] blk_done_softirq+0x75/0x90
 [<ffffffff810477bc>] __do_softirq+0xcc/0x210
 [<ffffffff81047170>] ? ksoftirqd+0x0/0x110
 [<ffffffff8100ce7c>] call_softirq+0x1c/0x50
 <EOI> 
 [<ffffffff8100e785>] do_softirq+0x65/0xa0
 [<ffffffff81047170>] ? ksoftirqd+0x0/0x110
 [<ffffffff810471e0>] ksoftirqd+0x70/0x110
 [<ffffffff81059559>] kthread+0x99/0xb0
 [<ffffffff8100cd7a>] child_rip+0xa/0x20
 [<ffffffff8100c73c>] ? restore_args+0x0/0x30
 [<ffffffff810594c0>] ? kthread+0x0/0xb0
 [<ffffffff8100cd70>] ? child_rip+0x0/0x20
Code: 44 89 e6 48 89 df e8 23 fb f2 e0 be 01 00 00 00 4c 89 f7 e8 f6 fd ff ff 5b 41 5c 41 5d 41 5e c9 c3 4c 89 ef e8 85 fe ff ff eb ed <0f> 0b eb fe 41 8b 85 dc 00 00 00 48 83 bb 10 01 00 00 00 89 83 
RIP  [<ffffffffa023629d>] dm_softirq_done+0xbd/0x100 [dm_mod]
 RSP <ffff8800280a1f08>
---[ end trace 16af0a1d8542da55 ]---


This is a regression introduced by this patch:
    http://marc.info/?l=dm-devel&m=124539787228784&w=2

The description of the patch ("clone has no bio in dm_end_request")
is true in request-completion-path from underlying device drivers.
But it is not true in request-completion-path from dm itself
like dm_kill_unmapped_request() which completes a clone without
dispatching.
I apologize for having pushed the immature code.

The patch (for 2.6.31-rc4) below fixes this bug by freeing bio in
dm_end_request() if the clone has bio.
I've redone my tests to cover all I/O paths and confirmed
there's no other regression.

Please review and apply.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: 2.6.31-rc4/drivers/md/dm.c
===================================================================
--- 2.6.31-rc4.orig/drivers/md/dm.c
+++ 2.6.31-rc4/drivers/md/dm.c
@@ -738,16 +738,22 @@ static void rq_completed(struct mapped_d
 	dm_put(md);
 }
 
+static void free_rq_clone(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	blk_rq_unprep_clone(clone);
+	free_rq_tio(tio);
+}
+
 static void dm_unprep_request(struct request *rq)
 {
 	struct request *clone = rq->special;
-	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
-	blk_rq_unprep_clone(clone);
-	free_rq_tio(tio);
+	free_rq_clone(clone);
 }
 
 /*
@@ -825,8 +831,7 @@ static void dm_end_request(struct reques
 			rq->sense_len = clone->sense_len;
 	}
 
-	BUG_ON(clone->bio);
-	free_rq_tio(tio);
+	free_rq_clone(clone);
 
 	blk_end_request_all(rq, error);
 
