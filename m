From: Shenghui Wang <shhuiw@foxmail.com>
Subject: [PATCH] dm-cache: destroy migration_cache if cache
	target registration failed
Date: Sun,  7 Oct 2018 14:45:41 +0800
Message-ID: <20181007064541.1723-1-shhuiw@foxmail.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Destroy migration_cache if cache target registration failed in
dm_cache_init.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/dm-cache-target.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index e13d991e9fb5..c248667f549d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3481,17 +3481,16 @@ static struct target_type cache_target = {
 
 static int __init dm_cache_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	migration_cache = KMEM_CACHE(dm_cache_migration, 0);
-	if (!migration_cache) {
-		dm_unregister_target(&cache_target);
-		return -ENOMEM;
-	}
+	if (!migration_cache)
+		return r;
 
 	r = dm_register_target(&cache_target);
 	if (r) {
 		DMERR("cache target registration failed: %d", r);
+		kmem_cache_destroy(migration_cache);
 		return r;
 	}
 
-- 
2.18.0
