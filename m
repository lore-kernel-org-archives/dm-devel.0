From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/7] dm-writecache: fix a crash when unloading
Date: Mon, 24 Feb 2020 10:20:29 +0100
Message-ID: <20200224092048.192812200@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-writecache-drain-workqueue.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: Corey Marthaler <cmarthal@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
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

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 4.18+
Fixes: 48debafe4f2f ("dm: add writecache target")
Reported-by: Corey Marthaler <cmarthal@redhat.com>
Depends-on: ("dm: report suspended device during destroy")

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-21 13:14:25.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-21 13:17:49.000000000 +0100
@@ -842,7 +842,7 @@ static void writecache_suspend(struct dm
 	}
 	wc_unlock(wc);
 
-	flush_workqueue(wc->writeback_wq);
+	drain_workqueue(wc->writeback_wq);
 
 	wc_lock(wc);
 	if (flush_on_suspend)
