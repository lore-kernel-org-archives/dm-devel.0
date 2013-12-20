From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 12/20] dm thin: log info when growing
	the data or metadata device
Date: Fri, 20 Dec 2013 18:37:25 -0500
Message-ID: <1387582653-13647-13-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ccd917f..3a80c00 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2220,6 +2220,10 @@ static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
 		return -EINVAL;
 
 	} else if (data_size > sb_data_size) {
+		if (sb_data_size)
+			DMINFO("%s: growing the data device from %llu to %llu blocks",
+			       dm_device_name(pool->pool_md),
+			       sb_data_size, (unsigned long long)data_size);
 		r = dm_pool_resize_data_dev(pool->pmd, data_size);
 		if (r) {
 			metadata_operation_failed(pool, "dm_pool_resize_data_dev", r);
@@ -2257,6 +2261,9 @@ static int maybe_resize_metadata_dev(struct dm_target *ti, bool *need_commit)
 		return -EINVAL;
 
 	} else if (metadata_dev_size > sb_metadata_dev_size) {
+		DMINFO("%s: growing the metadata device from %llu to %llu blocks",
+		       dm_device_name(pool->pool_md),
+		       sb_metadata_dev_size, metadata_dev_size);
 		r = dm_pool_resize_metadata_dev(pool->pmd, metadata_dev_size);
 		if (r) {
 			metadata_operation_failed(pool, "dm_pool_resize_metadata_dev", r);
-- 
1.8.1.4
