From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: [PATCH] Add a set_era_counter config key to the dm-cache
 era policy shim
Date: Wed, 6 Nov 2013 20:59:38 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B21C028E44@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Add the ability to set the era counter maintained by the dm-cache era
policy shim to an arbitrary 32-bit value, to allow era rollback after
the underlying device is restored from a snapshot.

Signed-off-by: Morgan Mears <mmears@netapp.com>
---
 drivers/md/dm-cache-policy-era.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/dm-cache-policy-era.c b/drivers/md/dm-cache-policy-era.c index d4fc0b0..c4cf2ba 100644
--- a/drivers/md/dm-cache-policy-era.c
+++ b/drivers/md/dm-cache-policy-era.c
@@ -155,6 +155,26 @@ static int incr_era_counter(struct era_policy *era, const char *curr_era_str,
 	return r;
 }
 
+static int set_era_counter(struct era_policy *era, const char *new_era_str,
+			   era_match_fn_t dummy)
+{
+	era_t new_era_counter;
+
+	/*
+	 * Set the era counter to a user-provided value, as long as it is
+	 * in range.
+	 */
+
+	if (kstrtou32(new_era_str, 10, &new_era_counter))
+		return -EINVAL;
+	if (new_era_counter > ERA_MAX_ERA)
+		return -EOVERFLOW;
+	era->era_counter = new_era_counter;
+	smp_wmb();
+
+	return 0;
+}
+
 static void *era_cblock_to_hint(struct shim_walk_map_ctx *ctx,
 				dm_cblock_t cblock, dm_oblock_t oblock)
 {
@@ -404,6 +424,7 @@ static int era_set_config_value(struct dm_cache_policy *p, const char *key,
 	struct era_policy *era = to_era_policy(p);
 	struct config_value_handler *vh, value_handlers[] = {
 		{ "increment_era_counter",                  incr_era_counter,  NULL },
+		{ "set_era_counter",                        set_era_counter,   NULL },
 		{ "unmap_blocks_from_later_eras",           cond_unmap_by_era, era_is_gt_value },
 		{ "unmap_blocks_from_this_era_and_later",   cond_unmap_by_era, era_is_gte_value },
 		{ "unmap_blocks_from_this_era_and_earlier", cond_unmap_by_era, era_is_lte_value },
-- 
