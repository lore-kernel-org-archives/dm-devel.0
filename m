From: Joe Jin <joe.jin@oracle.com>
Subject: [PATCH] dm ioctl: allow change device target type to error
Date: Wed, 21 Aug 2013 16:07:41 +0800
Message-ID: <5214754D.7050203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Joe Jin <joe.jin@oracle.com>
List-Id: dm-devel.ids

commit a5664da "dm ioctl: make bio or request based device type immutable"
prevented "dmsetup wape_table" change the target type to "error".

Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 drivers/md/dm-ioctl.c |  6 +++++-
 drivers/md/dm-table.c | 12 ++++++++++++
 drivers/md/dm.h       |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f1b7586..1ee9e41 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1250,7 +1250,7 @@ static int populate_table(struct dm_table *table,
 
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
-	int r;
+	int r = 0;
 	struct hash_cell *hc;
 	struct dm_table *t, *old_map = NULL;
 	struct mapped_device *md;
@@ -1280,6 +1280,9 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+	if (dm_is_error_target(t))
+		goto error_target;
+
 	/* Protect md->type and md->queue against concurrent table loads. */
 	dm_lock_md_type(md);
 	if (dm_get_md_type(md) == DM_TYPE_NONE)
@@ -1303,6 +1306,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	}
 	dm_unlock_md_type(md);
 
+error_target:
 	/* stage inactive table */
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f221812..27be46a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -184,6 +184,18 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 	return 0;
 }
 
+bool dm_is_error_target(struct dm_table *t)
+{
+	unsigned i;
+
+	for (i = 0; i < t->num_targets; i++) {
+		struct dm_target *tgt = t->targets + i;
+		if (strcmp(tgt->type->name, "error") == 0)
+			return true;
+	}
+	return false;
+}
+
 int dm_table_create(struct dm_table **result, fmode_t mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 45b97da..c7bceeb 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -69,6 +69,7 @@ unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 bool dm_table_supports_discards(struct dm_table *t);
+bool dm_is_error_target(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
-- 
1.8.3.1
