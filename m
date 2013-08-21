From: Joe Jin <joe.jin@oracle.com>
Subject: [PATCH v2] dm ioctl: allow change device target type to error
Date: Wed, 21 Aug 2013 22:18:13 +0800
Message-ID: <5214CC25.1070307@oracle.com>
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

-v2: setup md->queue even target type is "error".

Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 drivers/md/dm-ioctl.c |  4 ++++
 drivers/md/dm-table.c | 12 ++++++++++++
 drivers/md/dm.h       |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f1b7586..2a9b63d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1280,6 +1280,9 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+	if (dm_is_error_target(t))
+		goto error_target;
+
 	/* Protect md->type and md->queue against concurrent table loads. */
 	dm_lock_md_type(md);
 	if (dm_get_md_type(md) == DM_TYPE_NONE)
@@ -1293,6 +1296,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+error_target:
 	/* setup md->queue to reflect md's type (may block) */
 	r = dm_setup_md_queue(md);
 	if (r) {
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
