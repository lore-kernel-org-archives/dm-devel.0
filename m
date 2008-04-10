From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/3] dm-mpath: move is_active to pgpath from
	dm_path
Date: Thu, 10 Apr 2008 15:50:31 -0400 (EDT)
Message-ID: <20080410.155031.78704020.k-ueda@ct.jp.nec.com>
References: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch moves 'is_active' in struct dm_path to struct pgpath.
No functional change.

The is_active is multipath target dependent.
Other dm modules don't see it.
So moving it to struct pgpath.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c         |   13 +++++++------
 include/linux/device-mapper.h |    2 --
 2 files changed, 7 insertions(+), 8 deletions(-)

Index: 2.6.25-rc8/drivers/md/dm-mpath.c
===================================================================
--- 2.6.25-rc8.orig/drivers/md/dm-mpath.c
+++ 2.6.25-rc8/drivers/md/dm-mpath.c
@@ -30,6 +30,7 @@ struct pgpath {
 	struct list_head list;
 
 	struct priority_group *pg;	/* Owning PG */
+	unsigned is_active;		/* Path status */
 	unsigned fail_count;		/* Cumulative failure count */
 
 	struct dm_path path;
@@ -120,7 +121,7 @@ static struct pgpath *alloc_pgpath(void)
 	struct pgpath *pgpath = kzalloc(sizeof(*pgpath), GFP_KERNEL);
 
 	if (pgpath)
-		pgpath->path.is_active = 1;
+		pgpath->is_active = 1;
 
 	return pgpath;
 }
@@ -844,13 +845,13 @@ static int fail_path(struct pgpath *pgpa
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (!pgpath->path.is_active)
+	if (!pgpath->is_active)
 		goto out;
 
 	DMWARN("Failing path %s.", pgpath->path.dev->name);
 
 	pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
-	pgpath->path.is_active = 0;
+	pgpath->is_active = 0;
 	pgpath->fail_count++;
 
 	m->nr_valid_paths--;
@@ -880,7 +881,7 @@ static int reinstate_path(struct pgpath 
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (pgpath->path.is_active)
+	if (pgpath->is_active)
 		goto out;
 
 	if (!pgpath->pg->ps.type) {
@@ -894,7 +895,7 @@ static int reinstate_path(struct pgpath 
 	if (r)
 		goto out;
 
-	pgpath->path.is_active = 1;
+	pgpath->is_active = 1;
 
 	m->current_pgpath = NULL;
 	if (!m->nr_valid_paths++ && m->queue_size)
@@ -1256,7 +1257,7 @@ static int multipath_status(struct dm_ta
 
 			list_for_each_entry(p, &pg->pgpaths, list) {
 				DMEMIT("%s %s %u ", p->path.dev->name,
-				       p->path.is_active ? "A" : "F",
+				       p->is_active ? "A" : "F",
 				       p->fail_count);
 				if (pg->ps.type->status)
 					sz += pg->ps.type->status(&pg->ps,
Index: 2.6.25-rc8/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc8.orig/include/linux/device-mapper.h
+++ 2.6.25-rc8/include/linux/device-mapper.h
@@ -148,8 +148,6 @@ struct dm_target {
 
 struct dm_path {
 	struct dm_dev *dev;	/* Read-only */
-	unsigned is_active;	/* Read-only */
-
 	void *pscontext;	/* For path-selector use */
 	void *hwhcontext;	/* For hw-handler use */
 };
