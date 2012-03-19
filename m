From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-table: delayed cleanup for dm_table_destroy()
Date: Mon, 19 Mar 2012 16:53:48 +0100
Message-ID: <1332172428-35948-4-git-send-email-hare@suse.de>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
	<1332172428-35948-3-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1332172428-35948-3-git-send-email-hare@suse.de>
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
Cc: Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

We should be using a kref instead of the existing holders flag.
This enables us to use delayed cleanup and we'll get rid of the
msleep in dm_table_destroy().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-table.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a3d1e18..97c01f7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -41,7 +41,7 @@
 
 struct dm_table {
 	struct mapped_device *md;
-	atomic_t holders;
+	struct kref kref;
 	unsigned type;
 
 	/* btree table */
@@ -208,7 +208,7 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 
 	INIT_LIST_HEAD(&t->devices);
 	INIT_LIST_HEAD(&t->target_callbacks);
-	atomic_set(&t->holders, 0);
+	kref_init(&t->kref);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -240,17 +240,11 @@ static void free_devices(struct list_head *devices)
 	}
 }
 
-void dm_table_destroy(struct dm_table *t)
+void __table_destroy(struct kref *kref)
 {
+	struct dm_table *t = container_of(kref, struct dm_table, kref);
 	unsigned int i;
 
-	if (!t)
-		return;
-
-	while (atomic_read(&t->holders))
-		msleep(1);
-	smp_mb();
-
 	/* free the indexes */
 	if (t->depth >= 2)
 		vfree(t->index[t->depth - 2]);
@@ -277,7 +271,8 @@ void dm_table_destroy(struct dm_table *t)
 
 void dm_table_get(struct dm_table *t)
 {
-	atomic_inc(&t->holders);
+	if (t)
+		kref_get(&t->kref);
 }
 EXPORT_SYMBOL(dm_table_get);
 
@@ -286,11 +281,16 @@ void dm_table_put(struct dm_table *t)
 	if (!t)
 		return;
 
-	smp_mb__before_atomic_dec();
-	atomic_dec(&t->holders);
+	kref_put(&t->kref, __table_destroy);
 }
 EXPORT_SYMBOL(dm_table_put);
 
+void dm_table_destroy(struct dm_table *t)
+{
+	smp_mb__before_atomic_dec();
+	dm_table_put(t);
+}
+
 /*
  * Checks to see if we need to extend highs or targets.
  */
-- 
1.6.0.2
