From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] md: fix bug due to nested suspend
Date: Wed, 25 Nov 2015 12:20:54 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511251216100.17579@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>, NeilBrown <neilb@suse.com>, Marian Csontos <mcsontos@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The patch c7bfced9a6716ff66c9d61f934bb60af08d4688c committed to 4.4-rc 
causes crash in LVM test shell/lvchange-raid.sh. The kernel crashes with 
this BUG, the reason is that we attempt to suspend a device that is 
already suspended. See also 
https://bugzilla.redhat.com/show_bug.cgi?id=1283491

This patch fixes the bug by introducing functions mddev_nested_suspend and
mddev_nested_resume that can be called when the device is already
suspended. The number of calls to mddev_nested_suspend is kept in the
variable mddev->suspended.

kernel BUG at drivers/md/md.c:317!
CPU: 3 PID: 32754 Comm: lvm Not tainted 4.4.0-rc2 #1
task: 0000000047076040 ti: 0000000047014000 task.ti: 0000000047014000

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001000000000000001111 Not tainted
r00-03  000000000804000f 00000000102c5280 0000000010c7522c 000000007e3d1810
r04-07  0000000010c6f000 000000004ef37f20 000000007e3d1dd0 000000007e3d1810
r08-11  000000007c9f1600 0000000000000000 0000000000000001 ffffffffffffffff
r12-15  0000000010c1d000 0000000000000041 00000000f98d63c8 00000000f98e49e4
r16-19  00000000f98e49e4 00000000c138fd06 00000000f98d63c8 0000000000000001
r20-23  0000000000000002 000000004ef37f00 00000000000000b0 00000000000001d1
r24-27  00000000424783a0 000000007e3d1dd0 000000007e3d1810 00000000102b2000
r28-31  0000000000000001 0000000047014840 0000000047014930 0000000000000001
sr00-03  0000000007040800 0000000000000000 0000000000000000 0000000007040800
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000102c538c 00000000102c5390
 IIR: 03ffe01f    ISR: 0000000000000000  IOR: 00000000102b2748
 CPU:        3   CR30: 0000000047014000 CR31: 0000000000000000
 ORIG_R28: 00000000000000b0
 IAOQ[0]: mddev_suspend+0x10c/0x160 [md_mod]
 IAOQ[1]: mddev_suspend+0x110/0x160 [md_mod]
 RP(r2): raid1_add_disk+0xd4/0x2c0 [raid1]
Backtrace:
 [<0000000010c7522c>] raid1_add_disk+0xd4/0x2c0 [raid1]
 [<0000000010c20078>] raid_resume+0x390/0x418 [dm_raid]
 [<00000000105833e8>] dm_table_resume_targets+0xc0/0x188 [dm_mod]
 [<000000001057f784>] dm_resume+0x144/0x1e0 [dm_mod]
 [<0000000010587dd4>] dev_suspend+0x1e4/0x568 [dm_mod]
 [<0000000010589278>] ctl_ioctl+0x1e8/0x428 [dm_mod]
 [<0000000010589518>] dm_compat_ctl_ioctl+0x18/0x68 [dm_mod]
 [<0000000040377b88>] compat_SyS_ioctl+0xd0/0x1558

Fixes: c7bfced9a671 ("md: suspend i/o during runtime blk_integrity_unregister")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/md.c        |   19 +++++++++++++++++++
 drivers/md/md.h        |    2 ++
 drivers/md/multipath.c |    4 ++--
 drivers/md/raid1.c     |    4 ++--
 drivers/md/raid10.c    |    4 ++--
 5 files changed, 27 insertions(+), 6 deletions(-)

Index: linux-4.4-rc2/drivers/md/md.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/md.c	2015-11-25 18:05:11.000000000 +0100
+++ linux-4.4-rc2/drivers/md/md.c	2015-11-25 18:05:31.000000000 +0100
@@ -336,6 +336,25 @@ void mddev_resume(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_resume);
 
+void mddev_nested_suspend(struct mddev *mddev)
+{
+	if (mddev->suspended)
+		mddev->suspended++;
+	else
+		mddev_suspend(mddev);
+}
+EXPORT_SYMBOL_GPL(mddev_nested_suspend);
+
+void mddev_nested_resume(struct mddev *mddev)
+{
+	BUG_ON(!mddev->suspended);
+	if (mddev->suspended > 1)
+		mddev->suspended--;
+	else
+		mddev_resume(mddev);
+}
+EXPORT_SYMBOL_GPL(mddev_nested_resume);
+
 int mddev_congested(struct mddev *mddev, int bits)
 {
 	struct md_personality *pers = mddev->pers;
Index: linux-4.4-rc2/drivers/md/md.h
===================================================================
--- linux-4.4-rc2.orig/drivers/md/md.h	2015-11-25 18:04:08.000000000 +0100
+++ linux-4.4-rc2/drivers/md/md.h	2015-11-25 18:05:21.000000000 +0100
@@ -665,6 +665,8 @@ extern void md_rdev_clear(struct md_rdev
 
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
+extern void mddev_nested_suspend(struct mddev *mddev);
+extern void mddev_nested_resume(struct mddev *mddev);
 extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
 				   struct mddev *mddev);
 extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
Index: linux-4.4-rc2/drivers/md/multipath.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/multipath.c	2015-11-25 18:05:11.000000000 +0100
+++ linux-4.4-rc2/drivers/md/multipath.c	2015-11-25 18:05:21.000000000 +0100
@@ -264,9 +264,9 @@ static int multipath_add_disk(struct mdd
 			spin_unlock_irq(&conf->device_lock);
 			rcu_assign_pointer(p->rdev, rdev);
 			err = 0;
-			mddev_suspend(mddev);
+			mddev_nested_suspend(mddev);
 			md_integrity_add_rdev(rdev, mddev);
-			mddev_resume(mddev);
+			mddev_nested_resume(mddev);
 			break;
 		}
 
Index: linux-4.4-rc2/drivers/md/raid1.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/raid1.c	2015-11-25 18:05:11.000000000 +0100
+++ linux-4.4-rc2/drivers/md/raid1.c	2015-11-25 18:05:21.000000000 +0100
@@ -1632,9 +1632,9 @@ static int raid1_add_disk(struct mddev *
 			break;
 		}
 	}
-	mddev_suspend(mddev);
+	mddev_nested_suspend(mddev);
 	md_integrity_add_rdev(rdev, mddev);
-	mddev_resume(mddev);
+	mddev_nested_resume(mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	print_conf(conf);
Index: linux-4.4-rc2/drivers/md/raid10.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/raid10.c	2015-11-25 18:05:11.000000000 +0100
+++ linux-4.4-rc2/drivers/md/raid10.c	2015-11-25 18:05:21.000000000 +0100
@@ -1739,9 +1739,9 @@ static int raid10_add_disk(struct mddev 
 		rcu_assign_pointer(p->rdev, rdev);
 		break;
 	}
-	mddev_suspend(mddev);
+	mddev_nested_suspend(mddev);
 	md_integrity_add_rdev(rdev, mddev);
-	mddev_resume(mddev);
+	mddev_nested_resume(mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 
