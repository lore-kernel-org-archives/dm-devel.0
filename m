From: tang.junhui@zte.com.cn
Subject: [PATCH] md/dm-table: tgt->type should be putted in dm_table_add_target()
Date: Fri, 21 Oct 2016 09:35:32 +0800
Message-ID: <1477013732-4800-1-git-send-email-tang.junhui@zte.com.cn>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, bmarzins@redhat.com, zhang.kai16@zte.com.cn, "tang.junhui" <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

tgt->type should be putted in dm_table_add_target()
when the target do not statisfy the needs of target type,
otherwise it would cause the module reference count
of this target type leakage.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-table.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6554d91..4f56c38 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -698,30 +698,30 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 
 	if (dm_target_needs_singleton(tgt->type)) {
 		if (t->num_targets) {
-			DMERR("%s: target type %s must appear alone in table",
-			      dm_device_name(t->md), type);
-			return -EINVAL;
+			tgt->error = "target type must appear alone in table";
+			r = -EINVAL;
+			goto bad;
 		}
 		t->singleton = 1;
 	}
 
 	if (dm_target_always_writeable(tgt->type) && !(t->mode & FMODE_WRITE)) {
-		DMERR("%s: target type %s may not be included in read-only tables",
-		      dm_device_name(t->md), type);
-		return -EINVAL;
+		tgt->error = "target type may not be included in read-only tables";
+		r = -EINVAL;
+		goto bad;
 	}
 
 	if (t->immutable_target_type) {
 		if (t->immutable_target_type != tgt->type) {
-			DMERR("%s: immutable target type %s cannot be mixed with other target types",
-			      dm_device_name(t->md), t->immutable_target_type->name);
-			return -EINVAL;
+			tgt->error = "immutable target type cannot be mixed with other target types";
+			r = -EINVAL;
+			goto bad;
 		}
 	} else if (dm_target_is_immutable(tgt->type)) {
 		if (t->num_targets) {
-			DMERR("%s: immutable target type %s cannot be mixed with other target types",
-			      dm_device_name(t->md), tgt->type->name);
-			return -EINVAL;
+			tgt->error = "immutable target type cannot be mixed with other target types";
+			r = -EINVAL;
+			goto bad;
 		}
 		t->immutable_target_type = tgt->type;
 	}
-- 
2.8.1.windows.1
