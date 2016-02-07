From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 04/15] dm: set DM_TARGET_WILDCARD
	feature on "error" target
Date: Sun,  7 Feb 2016 10:53:26 -0500
Message-ID: <1454860417-3203-5-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

The DM_TARGET_WILDCARD feature indicates that the "error" target may
replace any target; even immutable targets.  This feature will be useful
to preserve the ability to replace the "multipath" target even once it
is formally converted over to having the DM_TARGET_IMMUTABLE feature.

Also, implicit in the DM_TARGET_WILDCARD feature flag being set is that
.map, .map_rq, .clone_and_map_rq and .release_clone_rq are all defined
in the target_type.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c         |  3 ++-
 drivers/md/dm-table.c         | 14 ++++++++++++++
 drivers/md/dm-target.c        |  3 ++-
 drivers/md/dm.h               |  1 +
 include/linux/device-mapper.h |  7 +++++++
 5 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 80a4395..4763c4a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1291,7 +1291,8 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 
 	immutable_target_type = dm_get_immutable_target_type(md);
 	if (immutable_target_type &&
-	    (immutable_target_type != dm_table_get_immutable_target_type(t))) {
+	    (immutable_target_type != dm_table_get_immutable_target_type(t)) &&
+	    !dm_table_get_wildcard_target(t)) {
 		DMWARN("can't replace immutable target type %s",
 		       immutable_target_type->name);
 		r = -EINVAL;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 061152a..a49e62b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -920,6 +920,20 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t)
 	return t->immutable_target_type;
 }
 
+struct dm_target *dm_table_get_wildcard_target(struct dm_table *t)
+{
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+		if (dm_target_is_wildcard(ti->type))
+			return ti;
+	}
+
+	return NULL;
+}
+
 bool dm_table_request_based(struct dm_table *t)
 {
 	return __table_type_request_based(dm_table_get_type(t));
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 925ec1b..a317dd8 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -150,7 +150,8 @@ static void io_err_release_clone_rq(struct request *clone)
 
 static struct target_type error_target = {
 	.name = "error",
-	.version = {1, 3, 0},
+	.version = {1, 4, 0},
+	.features = DM_TARGET_WILDCARD,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7edcf97..53df258 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -73,6 +73,7 @@ int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
+struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 bool dm_table_mq_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ec1c61c..87d50ec 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -190,6 +190,13 @@ struct target_type {
 #define dm_target_is_immutable(type)	((type)->features & DM_TARGET_IMMUTABLE)
 
 /*
+ * Indicates that a target may replace any target; even immutable targets.
+ * .map, .map_rq, .clone_and_map_rq and .release_clone_rq are all defined.
+ */
+#define DM_TARGET_WILDCARD		0x00000008
+#define dm_target_is_wildcard(type)	((type)->features & DM_TARGET_WILDCARD)
+
+/*
  * Some targets need to be sent the same WRITE bio severals times so
  * that they can send copies of it to different devices.  This function
  * examines any supplied bio and returns the number of copies of it the
-- 
2.5.4 (Apple Git-61)
