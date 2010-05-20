From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: also check for conflicting table type in
 dm_table_set_type
Date: Thu, 20 May 2010 18:26:26 -0400
Message-ID: <20100520222625.GA19250@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Factorize live table type compatibility check into
dm_table_type_matches_live_table().  Catching a conflicting table type
early, during table load, avoids failing during resume -- which always
leaves the DM device suspended.

So also check type during dm_table_set_type() -- which happens as part
of a table load.  But preserve the existing check during resume, in
dm_swap_table(), because a racing table load could stage an inactive
table that conflicts with the table type that dm_swap_table() is about
to make live:

table_load() for bio-based               do_resume() for rq-based
-----------------------------------------------------------------
dm_table_type_matches_live_table(t)
                                         down_write(_hash_lock)
                                         new_map = hc->new_map
                                         up_write(_hash_lock)
down_write(_hash_lock)
hc->new_map = t
up_write(_hash_lock)
                                         dm_swap_table(md, new_map)
                                         dm_table_type_matches_live_table(t)
                                         __bind(md, new_map)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   24 +++++++++++++++++++++++-
 drivers/md/dm.c       |    6 +-----
 drivers/md/dm.h       |    1 +
 3 files changed, 25 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -803,7 +803,7 @@ int dm_table_set_type(struct dm_table *t
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		return 0;
+		goto finish;
 	}
 
 	BUG_ON(!request_based); /* No targets in this table */
@@ -831,6 +831,10 @@ int dm_table_set_type(struct dm_table *t
 
 	t->type = DM_TYPE_REQUEST_BASED;
 
+finish:
+	if (!dm_table_type_matches_live_table(t))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -839,6 +843,24 @@ unsigned dm_table_get_type(struct dm_tab
 	return t->type;
 }
 
+int dm_table_type_matches_live_table(struct dm_table *t)
+{
+	int r = 1;
+	struct dm_table *live_table = NULL;
+
+	live_table = dm_get_live_table(t->md);
+	if (!live_table)
+		return 1; /* no live table, return success */
+
+	if (dm_table_get_type(live_table) != dm_table_get_type(t)) {
+		DMWARN("can't change the device type after a table is bound");
+		r = 0;
+	}
+	dm_table_put(live_table);
+
+	return r;
+}
+
 bool dm_table_request_based(struct dm_table *t)
 {
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -2403,12 +2403,8 @@ struct dm_table *dm_swap_table(struct ma
 		goto out;
 	}
 
-	/* cannot change the device type, once a table is bound */
-	if (md->map &&
-	    (dm_table_get_type(md->map) != dm_table_get_type(table))) {
-		DMWARN("can't change the device type after a table is bound");
+	if (!dm_table_type_matches_live_table(table))
 		goto out;
-	}
 
 	map = __bind(md, table, &limits);
 
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -61,6 +61,7 @@ int dm_table_any_congested(struct dm_tab
 int dm_table_any_busy_target(struct dm_table *t);
 int dm_table_set_type(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
+int dm_table_type_matches_live_table(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
