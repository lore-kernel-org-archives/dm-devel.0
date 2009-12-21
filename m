From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm-mpath: Remove 'suspended' flag from struct
	multipath
Date: Mon, 21 Dec 2009 20:02:44 +0900
Message-ID: <4B2F55D4.5010108@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
List-Id: dm-devel.ids

Hi Alasdair,

'suspended' flag in struct multipath was introduced to check whether
the multipath target is in suspended state, but the same check is
done through dm_suspended() now.
So remove the flag and the related codes.

This patch is for 2.6.33-rc1.
Please apply.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-mpath.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: 2.6.33-rc1/drivers/md/dm-mpath.c
===================================================================
--- 2.6.33-rc1.orig/drivers/md/dm-mpath.c
+++ 2.6.33-rc1/drivers/md/dm-mpath.c
@@ -95,8 +95,6 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
-
-	unsigned suspended;	/* Don't create new I/O internally when set. */
 };
 
 /*
@@ -1276,7 +1274,6 @@ static void multipath_postsuspend(struct
 	struct multipath *m = ti->private;
 
 	mutex_lock(&m->work_mutex);
-	m->suspended = 1;
 	flush_multipath_work();
 	mutex_unlock(&m->work_mutex);
 }
@@ -1289,10 +1286,6 @@ static void multipath_resume(struct dm_t
 	struct multipath *m = (struct multipath *) ti->private;
 	unsigned long flags;
 
-	mutex_lock(&m->work_mutex);
-	m->suspended = 0;
-	mutex_unlock(&m->work_mutex);
-
 	spin_lock_irqsave(&m->lock, flags);
 	m->queue_if_no_path = m->saved_queue_if_no_path;
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -1428,11 +1421,6 @@ static int multipath_message(struct dm_t
 
 	mutex_lock(&m->work_mutex);
 
-	if (m->suspended) {
-		r = -EBUSY;
-		goto out;
-	}
-
 	if (dm_suspended(ti)) {
 		r = -EBUSY;
 		goto out;
