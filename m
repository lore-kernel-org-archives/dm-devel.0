From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: provide useful errors on thin-pool
	table load failures
Date: Wed, 13 Jun 2012 19:02:19 -0400
Message-ID: <1339628539-23580-1-git-send-email-snitzer@redhat.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Replace "Unknown error" with appropriate errors for thinp-test-suite's
test_two_pools_pointing_to_the_same_metadata_fails and
test_different_pool_cant_replace_pool.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b142428..54ae5c3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1825,15 +1825,19 @@ static struct pool *__pool_find(struct mapped_device *pool_md,
 	struct pool *pool = __pool_table_lookup_metadata_dev(metadata_dev);
 
 	if (pool) {
-		if (pool->pool_md != pool_md)
+		if (pool->pool_md != pool_md) {
+			*error = "metadata device already in use by a pool";
 			return ERR_PTR(-EBUSY);
+		}
 		__pool_inc(pool);
 
 	} else {
 		pool = __pool_table_lookup(pool_md);
 		if (pool) {
-			if (pool->md_dev != metadata_dev)
+			if (pool->md_dev != metadata_dev) {
+				*error = "different pool cannot replace a pool";
 				return ERR_PTR(-EINVAL);
+			}
 			__pool_inc(pool);
 
 		} else {
