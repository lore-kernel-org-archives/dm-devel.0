From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/2] dm: table load must always try
	dm_setup_md_queue
Date: Fri, 4 Jun 2010 16:15:25 -0400
Message-ID: <20100604201524.GC4917@redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1274964469-22289-3-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

A DM device's first table_load will establish the immutable md->type.
But md->queue initialization, based on md->type, may fail at that time
(if blk_init_allocated_queue cannot allocate memory).

Therefore any subsequent table_load must (re)try dm_setup_md_queue
independent of establishing md->type.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   18 +++++++++---------
 drivers/md/dm.c       |    3 ++-
 2 files changed, 11 insertions(+), 10 deletions(-)

NOTE: coping with blk_init_allocated_queue failure was mistakenly
"optimized" away during review of the patch that introduced
dm_setup_md_queue:
https://www.redhat.com/archives/dm-devel/2010-May/msg00173.html

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1181,15 +1181,6 @@ static int table_load(struct dm_ioctl *p
 	if (dm_get_md_type(md) == DM_TYPE_NONE) {
 		/* initial table load, set md's type based on table's type */
 		dm_set_md_type(md, dm_table_get_type(t));
-
-		/* setup md->queue to reflect md's type (may block) */
-		r = dm_setup_md_queue(md);
-		if (r) {
-			DMWARN("unable to setup device queue for this table.");
-			dm_table_destroy(t);
-			dm_unlock_md_type(md);
-			goto out;
-		}
 	} else if (dm_get_md_type(md) != dm_table_get_type(t)) {
 		DMWARN("can't change device type after initial table load.");
 		dm_table_destroy(t);
@@ -1197,6 +1188,15 @@ static int table_load(struct dm_ioctl *p
 		r = -EINVAL;
 		goto out;
 	}
+
+	/* setup md->queue to reflect md's type (may block) */
+	r = dm_setup_md_queue(md);
+	if (r) {
+		DMWARN("unable to setup device queue for this table.");
+		dm_table_destroy(t);
+		dm_unlock_md_type(md);
+		goto out;
+	}
 	dm_unlock_md_type(md);
 
 	/* stage inactive table */
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -2164,7 +2164,8 @@ static int dm_init_request_based_queue(s
 {
 	struct request_queue *q = NULL;
 
-	BUG_ON(md->queue->elevator);
+	if (unlikely(md->queue->elevator))
+		return 1;
 
 	/* Fully initialize the queue */
 	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
