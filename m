From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: fix a crash due to incorrect cleanup sequence
Date: Fri, 10 Jul 2015 17:21:43 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507101533560.31268@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

The patch 0f20972f7bf6 moves a common cleanup code to a separate function.
Unfortunatelly, the patch changes the order of cleanup, so that it
destroys the srcu structure io_barrier before destroying the workqueue.

The function that is executed on the workqueue (dm_wq_work) uses the srcu
structure, thus it may use it after being freed. That results in a crash
in the LVM test mirror-vgreduce-removemissing.sh.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 0f20972f7bf6 ("dm: factor out a common cleanup_mapped_device()")

---
 drivers/md/dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-4.2-rc1/drivers/md/dm.c
===================================================================
--- linux-4.2-rc1.orig/drivers/md/dm.c	2015-07-09 22:08:12.000000000 +0200
+++ linux-4.2-rc1/drivers/md/dm.c	2015-07-10 21:20:50.000000000 +0200
@@ -2367,8 +2367,6 @@ static void dm_init_old_md_queue(struct 
 
 static void cleanup_mapped_device(struct mapped_device *md)
 {
-	cleanup_srcu_struct(&md->io_barrier);
-
 	if (md->wq)
 		destroy_workqueue(md->wq);
 	if (md->kworker_task)
@@ -2380,6 +2378,8 @@ static void cleanup_mapped_device(struct
 	if (md->bs)
 		bioset_free(md->bs);
 
+	cleanup_srcu_struct(&md->io_barrier);
+
 	if (md->disk) {
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
