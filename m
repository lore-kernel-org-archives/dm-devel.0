From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm table: simplify discard support processing
Date: Thu, 14 Jul 2011 13:56:47 -0400
Message-ID: <20110714175647.GA31051@redhat.com>
References: <20110714143037.GA12049@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110714143037.GA12049@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Remove 'discards_supported' from the dm_table structure.  The same
information can be easily discovered from the table's target(s) in
dm_table_supports_discards().

Also DMWARN if a target sets 'discards_supported' override but forgets
to set 'num_discard_requests'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

v2: have dm_table_supports_discards() keep checking table's targets if
    !ti->num_discard_requests

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 367a2e0..b5bdeb3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -54,7 +54,6 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
-	unsigned discards_supported:1;
 	unsigned integrity_supported:1;
 
 	/*
@@ -207,7 +206,6 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 	INIT_LIST_HEAD(&t->devices);
 	INIT_LIST_HEAD(&t->target_callbacks);
 	atomic_set(&t->holders, 0);
-	t->discards_supported = 1;
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -788,8 +786,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
-	if (!tgt->num_discard_requests)
-		t->discards_supported = 0;
+	if (!tgt->num_discard_requests && tgt->discards_supported)
+		DMWARN("%s: %s: must set num_discard_requests if discards_supported, "
+		       "disabling discards", dm_device_name(t->md), type);
 
 	return 0;
 
@@ -1413,9 +1412,6 @@ bool dm_table_supports_discards(struct dm_table *t)
 	struct dm_target *ti;
 	unsigned i = 0;
 
-	if (!t->discards_supported)
-		return 0;
-
 	/*
 	 * Unless any target used by the table set discards_supported,
 	 * require at least one underlying device to support discards.
@@ -1426,6 +1422,9 @@ bool dm_table_supports_discards(struct dm_table *t)
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
+		if (!ti->num_discard_requests)
+			continue;
+		
 		if (ti->discards_supported)
 			return 1;
 
