From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: fix table output when pool target
	disables discard passdown internally
Date: Thu, 17 May 2012 23:00:59 -0400
Message-ID: <1337310059-8517-1-git-send-email-snitzer@redhat.com>
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

When the thin pool target clears the discard_passdown parameter
internally, it incorrectly reports this to userspace on the table line.
This patch corrects this by no longer changing the table line to reflect
that discard passdown was disabled.

We can still tell when discard passdown is overridden by looking for the
message "Discard unsupported by data device: Disabling discard passdown."

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2fd87b5..d05fefd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -497,6 +497,12 @@ struct pool_features {
 	unsigned zero_new_blocks:1;
 	unsigned discard_enabled:1;
 	unsigned discard_passdown:1;
+	/*
+	 * 'discard_passdown_original' preserves the value supplied to the
+	 * constructor that could be overridden internally if the data device
+	 * doesn't support discards.
+	 */
+	unsigned discard_passdown_original:1;
 };
 
 struct pool {
@@ -1650,6 +1656,7 @@ static void pool_features_init(struct pool_features *pf)
 	pf->zero_new_blocks = 1;
 	pf->discard_enabled = 1;
 	pf->discard_passdown = 1;
+	pf->discard_passdown_original = 1;
 }
 
 static void __pool_destroy(struct pool *pool)
@@ -1873,6 +1880,7 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 			continue;
 		} else if (!strcasecmp(arg_name, "no_discard_passdown")) {
 			pf->discard_passdown = 0;
+			pf->discard_passdown_original = 0;
 			continue;
 		}
 
@@ -2385,7 +2393,7 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		       (unsigned long long)pt->low_water_blocks);
 
 		count = !pool->pf.zero_new_blocks + !pool->pf.discard_enabled +
-			!pool->pf.discard_passdown;
+			!pool->pf.discard_passdown_original;
 		DMEMIT("%u ", count);
 
 		if (!pool->pf.zero_new_blocks)
@@ -2394,7 +2402,7 @@ static int pool_status(struct dm_target *ti, status_type_t type,
 		if (!pool->pf.discard_enabled)
 			DMEMIT("ignore_discard ");
 
-		if (!pool->pf.discard_passdown)
+		if (!pool->pf.discard_passdown_original)
 			DMEMIT("no_discard_passdown ");
 
 		break;
-- 
1.7.4.4
