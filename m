From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/3] dm-mpath: interface change for dynamic load
	balancers
Date: Wed, 18 Mar 2009 17:38:16 +0900
Message-ID: <49C0B2F8.6080507@ct.jp.nec.com>
References: <49C0B222.9010600@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B222.9010600@ct.jp.nec.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, stefan.bader@canonical.com
List-Id: dm-devel.ids

This patch changes the dm path selector interface for dynamic
load balancers:
  o adding a new hook, start_io()
  o adding 'nr_bytes' parameter to select_path()/start_io()/end_io()
    to pass the size of the I/O

start_io() is called when a target driver actually submits I/O
to the selected path.
Path selectors can use it to start accounting of the I/O.
(e.g. counting the number of in-flight I/Os.)
The start_io hook is based on the patch posted by Stefan Bader:
https://www.redhat.com/archives/dm-devel/2005-October/msg00050.html

nr_bytes, the size of the I/O, is used by path selectors for
size-based decision.
dm-service-time uses it to estimate service time, for example.
(Added the nr_bytes member to dm_mpath_io instead of using existing
 details.bi_size, since request-based dm patch deletes it.)

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Vijayakumar Balasubramanian <vijayakumar@hp.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-mpath.c         |   28 ++++++++++++++++++----------
 drivers/md/dm-path-selector.h |    8 ++++++--
 drivers/md/dm-round-robin.c   |    2 +-
 3 files changed, 25 insertions(+), 13 deletions(-)

Index: 2.6.29-rc8/drivers/md/dm-mpath.c
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm-mpath.c
+++ 2.6.29-rc8/drivers/md/dm-mpath.c
@@ -103,6 +103,7 @@ struct multipath {
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	struct dm_bio_details details;
+	size_t nr_bytes;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -251,11 +252,12 @@ static void __switch_pg(struct multipath
 	m->pg_init_count = 0;
 }
 
-static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg)
+static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
+			       size_t nr_bytes)
 {
 	struct dm_path *path;
 
-	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count);
+	path = pg->ps.type->select_path(&pg->ps, &m->repeat_count, nr_bytes);
 	if (!path)
 		return -ENXIO;
 
@@ -267,7 +269,7 @@ static int __choose_path_in_pg(struct mu
 	return 0;
 }
 
-static void __choose_pgpath(struct multipath *m)
+static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 {
 	struct priority_group *pg;
 	unsigned bypassed = 1;
@@ -279,12 +281,12 @@ static void __choose_pgpath(struct multi
 	if (m->next_pg) {
 		pg = m->next_pg;
 		m->next_pg = NULL;
-		if (!__choose_path_in_pg(m, pg))
+		if (!__choose_path_in_pg(m, pg, nr_bytes))
 			return;
 	}
 
 	/* Don't change PG until it has no remaining paths */
-	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg))
+	if (m->current_pg && !__choose_path_in_pg(m, m->current_pg, nr_bytes))
 		return;
 
 	/*
@@ -296,7 +298,7 @@ static void __choose_pgpath(struct multi
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg))
+			if (!__choose_path_in_pg(m, pg, nr_bytes))
 				return;
 		}
 	} while (bypassed--);
@@ -327,6 +329,7 @@ static int map_io(struct multipath *m, s
 		  struct dm_mpath_io *mpio, unsigned was_queued)
 {
 	int r = DM_MAPIO_REMAPPED;
+	size_t nr_bytes = bio->bi_size;
 	unsigned long flags;
 	struct pgpath *pgpath;
 
@@ -335,7 +338,7 @@ static int map_io(struct multipath *m, s
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
 	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
-		__choose_pgpath(m);
+		__choose_pgpath(m, nr_bytes);
 
 	pgpath = m->current_pgpath;
 
@@ -360,6 +363,11 @@ static int map_io(struct multipath *m, s
 		r = -EIO;	/* Failed */
 
 	mpio->pgpath = pgpath;
+	mpio->nr_bytes = nr_bytes;
+
+	if (r == DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
+		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path,
+					      nr_bytes);
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -438,7 +446,7 @@ static void process_queued_ios(struct wo
 		goto out;
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m);
+		__choose_pgpath(m, 0);
 
 	pgpath = m->current_pgpath;
 
@@ -1196,7 +1204,7 @@ static int multipath_end_io(struct dm_ta
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 	if (r != DM_ENDIO_INCOMPLETE)
 		mempool_free(mpio, m->mpio_pool);
@@ -1412,7 +1420,7 @@ static int multipath_ioctl(struct dm_tar
 	spin_lock_irqsave(&m->lock, flags);
 
 	if (!m->current_pgpath)
-		__choose_pgpath(m);
+		__choose_pgpath(m, 0);
 
 	if (m->current_pgpath) {
 		bdev = m->current_pgpath->path.dev->bdev;
Index: 2.6.29-rc8/drivers/md/dm-path-selector.h
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm-path-selector.h
+++ 2.6.29-rc8/drivers/md/dm-path-selector.h
@@ -56,7 +56,8 @@ struct path_selector_type {
 	 * the path fails.
 	 */
 	struct dm_path *(*select_path) (struct path_selector *ps,
-				     unsigned *repeat_count);
+					unsigned *repeat_count,
+					size_t nr_bytes);
 
 	/*
 	 * Notify the selector that a path has failed.
@@ -75,7 +76,10 @@ struct path_selector_type {
 	int (*status) (struct path_selector *ps, struct dm_path *path,
 		       status_type_t type, char *result, unsigned int maxlen);
 
-	int (*end_io) (struct path_selector *ps, struct dm_path *path);
+	int (*start_io) (struct path_selector *ps, struct dm_path *path,
+			 size_t nr_bytes);
+	int (*end_io) (struct path_selector *ps, struct dm_path *path,
+		       size_t nr_bytes);
 };
 
 /* Register a path selector */
Index: 2.6.29-rc8/drivers/md/dm-round-robin.c
===================================================================
--- 2.6.29-rc8.orig/drivers/md/dm-round-robin.c
+++ 2.6.29-rc8/drivers/md/dm-round-robin.c
@@ -161,7 +161,7 @@ static int rr_reinstate_path(struct path
 }
 
 static struct dm_path *rr_select_path(struct path_selector *ps,
-				   unsigned *repeat_count)
+				      unsigned *repeat_count, size_t nr_bytes)
 {
 	struct selector *s = (struct selector *) ps->context;
 	struct path_info *pi = NULL;
