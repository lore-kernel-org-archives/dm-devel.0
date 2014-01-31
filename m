From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm cache: move hook_info into common portion
	of per_bio_data structure
Date: Fri, 31 Jan 2014 17:34:29 -0500
Message-ID: <1391207670-28361-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Commit c9d28d5d ("dm cache: promotion optimisation for writes")
incorrectly placed the 'hook_info' member in the writethrough-only
portion of the per_bio_data structure.

Given that the overwrite optimization may be used for writeback the
'hook_info' member but be placed above the 'cache' member of the
per_bio_data structure.  Any members above 'cache' are available from
both writeback and writethrough modes' per_bio_data structure.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Cc: stable@vger.kernel.org # 3.13+
---
 drivers/md/dm-cache-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 09334c2..cd24a05 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -283,6 +283,7 @@ struct per_bio_data {
 	bool tick:1;
 	unsigned req_nr:2;
 	struct dm_deferred_entry *all_io_entry;
+	struct dm_hook_info hook_info;
 
 	/*
 	 * writethrough fields.  These MUST remain at the end of this
@@ -291,7 +292,6 @@ struct per_bio_data {
 	 */
 	struct cache *cache;
 	dm_cblock_t cblock;
-	struct dm_hook_info hook_info;
 	struct dm_bio_details bio_details;
 };
 
-- 
1.8.1.4
