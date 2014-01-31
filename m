From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm cache: do not add migration to completed
	list before unhooking bio
Date: Fri, 31 Jan 2014 17:34:30 -0500
Message-ID: <1391207670-28361-2-git-send-email-snitzer@redhat.com>
References: <1391207670-28361-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391207670-28361-1-git-send-email-snitzer@redhat.com>
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

When completing an overwrite bio ,in overwrite_endio(), the associated
migration should not be added to the 'completed_migrations' until the
bio's fields are restored with dm_unhook_bio().

Otherwise, do_worker() can race to process 'completed_migrations' before
dm_unhook_bio() -- so the bio's bi_end_io is incorrect.  This is
unlikely to cause any problems given the current code but should be
fixed on the basis of correctness.

Also, the cache's spinlock only needs to be held when manipulating the
'completed_migrations' list -- other changes don't need protection.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-cache-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index cd24a05..ed4cffe 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1002,13 +1002,15 @@ static void overwrite_endio(struct bio *bio, int err)
 	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 	unsigned long flags;
 
+	dm_unhook_bio(&pb->hook_info, bio);
+
 	if (err)
 		mg->err = true;
 
+	mg->requeue_holder = false;
+
 	spin_lock_irqsave(&cache->lock, flags);
 	list_add_tail(&mg->list, &cache->completed_migrations);
-	dm_unhook_bio(&pb->hook_info, bio);
-	mg->requeue_holder = false;
 	spin_unlock_irqrestore(&cache->lock, flags);
 
 	wake_worker(cache);
-- 
1.8.1.4
