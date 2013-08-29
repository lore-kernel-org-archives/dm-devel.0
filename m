From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm ioctl: cleanup error handling in
	table_load
Date: Wed, 28 Aug 2013 23:21:03 -0400
Message-ID: <1377746464-2437-2-git-send-email-snitzer@redhat.com>
References: <1377746464-2437-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1377746464-2437-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Make use of common cleanup code.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ec69f23..301e0a5 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1267,21 +1267,16 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	/* Protect md->type and md->queue against concurrent table loads. */
 	dm_lock_md_type(md);
 	r = populate_table(t, param, param_size);
-	if (r) {
-		dm_table_destroy(t);
-		dm_unlock_md_type(md);
-		goto out;
-	}
+	if (r)
+		goto out_unlock_md_type;
 
 	immutable_target_type = dm_get_immutable_target_type(md);
 	if (immutable_target_type &&
 	    (immutable_target_type != dm_table_get_immutable_target_type(t))) {
 		DMWARN("can't replace immutable target type %s",
 		       immutable_target_type->name);
-		dm_table_destroy(t);
-		dm_unlock_md_type(md);
 		r = -EINVAL;
-		goto out;
+		goto out_unlock_md_type;
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NONE)
@@ -1289,19 +1284,15 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		dm_set_md_type(md, dm_table_get_type(t));
 	else if (dm_get_md_type(md) != dm_table_get_type(t)) {
 		DMWARN("can't change device type after initial table load.");
-		dm_table_destroy(t);
-		dm_unlock_md_type(md);
 		r = -EINVAL;
-		goto out;
+		goto out_unlock_md_type;
 	}
 
 	/* setup md->queue to reflect md's type (may block) */
 	r = dm_setup_md_queue(md);
 	if (r) {
 		DMWARN("unable to set up device queue for new table.");
-		dm_table_destroy(t);
-		dm_unlock_md_type(md);
-		goto out;
+		goto out_unlock_md_type;
 	}
 	dm_unlock_md_type(md);
 
@@ -1311,9 +1302,8 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
 		up_write(&_hash_lock);
-		dm_table_destroy(t);
 		r = -ENXIO;
-		goto out;
+		goto out_destroy_table;
 	}
 
 	if (hc->new_map)
@@ -1324,7 +1314,6 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	__dev_status(md, param);
 
-out:
 	if (old_map) {
 		dm_sync_table(md);
 		dm_table_destroy(old_map);
@@ -1332,6 +1321,15 @@ out:
 
 	dm_put(md);
 
+	return 0;
+
+out_unlock_md_type:
+	dm_unlock_md_type(md);
+out_destroy_table:
+	dm_table_destroy(t);
+out:
+	dm_put(md);
+
 	return r;
 }
 
-- 
1.8.1.4
