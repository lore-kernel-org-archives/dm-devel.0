From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-cache: return -EINVAL, not -ENOMEM,
 if the user specifies unknown policy
Date: Tue, 1 Oct 2013 18:35:39 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1310011834190.25214@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

dm-cache: return -EINVAL, not -ENOMEM, if the user specifies unknown 
policy

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-cache-policy.c |    4 ++--
 drivers/md/dm-cache-target.c |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-3.10.13-fast/drivers/md/dm-cache-target.c
===================================================================
--- linux-3.10.13-fast.orig/drivers/md/dm-cache-target.c	2013-10-01 16:30:54.000000000 +0200
+++ linux-3.10.13-fast/drivers/md/dm-cache-target.c	2013-10-01 17:29:43.000000000 +0200
@@ -1865,15 +1865,17 @@ static int set_config_values(struct cach
 static int create_cache_policy(struct cache *cache, struct cache_args *ca,
 			       char **error)
 {
-	cache->policy =	dm_cache_policy_create(ca->policy_name,
+	struct dm_cache_policy *p = dm_cache_policy_create(ca->policy_name,
 					       cache->cache_size,
 					       cache->origin_sectors,
 					       cache->sectors_per_block);
-	if (!cache->policy) {
+	if (IS_ERR(p)) {
 		*error = "Error creating cache's policy";
-		return -ENOMEM;
+		return PTR_ERR(p);
 	}
 
+	cache->policy = p;
+
 	return 0;
 }
 
Index: linux-3.10.13-fast/drivers/md/dm-cache-policy.c
===================================================================
--- linux-3.10.13-fast.orig/drivers/md/dm-cache-policy.c	2013-10-01 17:29:50.000000000 +0200
+++ linux-3.10.13-fast/drivers/md/dm-cache-policy.c	2013-10-01 17:30:05.000000000 +0200
@@ -119,13 +119,13 @@ struct dm_cache_policy *dm_cache_policy_
 	type = get_policy(name);
 	if (!type) {
 		DMWARN("unknown policy type");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	p = type->create(cache_size, origin_size, cache_block_size);
 	if (!p) {
 		put_policy(type);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	p->private = type;
 
