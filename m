From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm ioctl: increase granularity of type_lock
	when loading table
Date: Wed, 28 Aug 2013 23:21:02 -0400
Message-ID: <1377746464-2437-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hold the mapped device's type_lock before calling populate_table() since
it is where the table's type is determined based on the specified
targets.  There is no need to allow concurrent table loads to race to
establish the table's targets or type.

This eliminates the need to grab the lock in dm_table_set_type().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c | 6 ++++--
 drivers/md/dm-table.c | 2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 40e6dce..ec69f23 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1264,9 +1264,12 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	if (r)
 		goto out;
 
+	/* Protect md->type and md->queue against concurrent table loads. */
+	dm_lock_md_type(md);
 	r = populate_table(t, param, param_size);
 	if (r) {
 		dm_table_destroy(t);
+		dm_unlock_md_type(md);
 		goto out;
 	}
 
@@ -1276,12 +1279,11 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		DMWARN("can't replace immutable target type %s",
 		       immutable_target_type->name);
 		dm_table_destroy(t);
+		dm_unlock_md_type(md);
 		r = -EINVAL;
 		goto out;
 	}
 
-	/* Protect md->type and md->queue against concurrent table loads. */
-	dm_lock_md_type(md);
 	if (dm_get_md_type(md) == DM_TYPE_NONE)
 		/* Initial table load: acquire type of table. */
 		dm_set_md_type(md, dm_table_get_type(t));
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f309477..8f87835 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -888,9 +888,7 @@ static int dm_table_set_type(struct dm_table *t)
 		 * Determine the type from the live device.
 		 * Default to bio-based if device is new.
 		 */
-		dm_lock_md_type(t->md);
 		live_md_type = dm_get_md_type(t->md);
-		dm_unlock_md_type(t->md);
 		if (live_md_type == DM_TYPE_REQUEST_BASED)
 			request_based = 1;
 		else
-- 
1.8.1.4
