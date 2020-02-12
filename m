From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: fix a crash when unloading
Date: Wed, 12 Feb 2020 10:20:45 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002121015310.19039@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>, Corey Marthaler <cmarthal@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch fixes a crash in writecache_writeback when replacing the
dm-writecache target:

 general protection fault: 0000 [#1] SMP PTI
 CPU: 28 PID: 6388 Comm: kworker/28:2 Kdump: loaded Tainted: G        W        --------- -t - 4.18.0-173.el8.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R830/0VVT0H, BIOS 1.8.0 05/28/2018
 Workqueue: writecache-writeback writecache_writeback [dm_writecache]
 RIP: 0010:writecache_writeback+0x10c/0x820 [dm_writecache]
 Code: d8 fe ff ff 0f 87 7e 02 00 00 48 83 44 24 28 01 48 8b 44 24 28 48
 83 f8 40 0f 87 47 02 00 00 48 8b 83 a0 fe ff ff 4c 8d 60 e8 <41> f6 44 24
 2a 01 0f 85 16 02 00 00 49 8b 44 24 38 48 39 43 d0 0f
 RSP: 0018:ffffb0e4e323fdd0 EFLAGS: 00010283
 RAX: dead000000000200 RBX: ffff8c410d89f188 RCX: ffff8c41387edf01
 RDX: 0000000000000000 RSI: ffff8c41387edf00 RDI: 0000000000000000
 RBP: ffffb0e4e323fe90 R08: ffff8c413f9aa238 R09: 0000000000000000
 R10: 0000000000000000 R11: 00011f203dfb3b00 R12: dead0000000001e8
 R13: 0000000000000000 R14: ffff8c408e9d2900 R15: ffff8c410d89f190
 FS:  0000000000000000(0000) GS:ffff8c413f980000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005608dcd82000 CR3: 0000001cba20a005 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  ? blk_finish_plug+0x21/0x2e
  ? do_work+0xc4/0xf0 [dm_mod]
  process_one_work+0x1a7/0x3b0
  worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  kthread+0x112/0x130
  ? kthread_flush_work_fn+0x10/0x10
  ret_from_fork+0x35/0x40

writecache_suspend calls flush_workqueue(wc->writeback_wq) - this function
flushes the current work. However, the workqueue may re-queue itself and
flush_workqueue doesn't wait for re-queued works to finish. Because of
this - the function writecache_writeback continues execution after the
device was suspended and then concurrently with writecache_dtr, causing
the crash.

We must use drain_workqueue - that waits until the work and all re-queued
works finish.

Also, the test "!dm_suspended(wc->ti)" in writecache_writeback is not
sufficient, because dm_suspended returns zero while writecache_suspend is
in progress. We add a variable wc->suspending and set it in
writecache_suspend. Without this variable, drain_workqueue would spit
warnings:
workqueue writecache-writeback: drain_workqueue() isn't complete after 10 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 100 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 200 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 300 tries
workqueue writecache-writeback: drain_workqueue() isn't complete after 400 tries

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 4.18+
Fixes: 48debafe4f2f ("dm: add writecache target")
Reported-by: Corey Marthaler <cmarthal@redhat.com>

---
 drivers/md/dm-writecache.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-12 15:10:02.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-12 15:35:11.000000000 +0100
@@ -160,6 +160,7 @@ struct dm_writecache {
 	bool autocommit_time_set:1;
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
+	bool suspending:1;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -834,6 +835,7 @@ static void writecache_suspend(struct dm
 	del_timer_sync(&wc->autocommit_timer);
 
 	wc_lock(wc);
+	wc->suspending = true;
 	writecache_flush(wc);
 	flush_on_suspend = wc->flush_on_suspend;
 	if (flush_on_suspend) {
@@ -843,7 +845,7 @@ static void writecache_suspend(struct dm
 	}
 	wc_unlock(wc);
 
-	flush_workqueue(wc->writeback_wq);
+	drain_workqueue(wc->writeback_wq);
 
 	wc_lock(wc);
 	if (flush_on_suspend)
@@ -855,6 +857,7 @@ static void writecache_suspend(struct dm
 
 	writecache_poison_lists(wc);
 
+	wc->suspending = false;
 	wc_unlock(wc);
 }
 
@@ -1616,7 +1619,7 @@ restart:
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
-		    likely(!wc->writeback_all) && likely(!dm_suspended(wc->ti))) {
+		    likely(!wc->writeback_all) && likely(!wc->suspending) && likely(!dm_suspended(wc->ti))) {
 			queue_work(wc->writeback_wq, &wc->writeback_work);
 			break;
 		}
