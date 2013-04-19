From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] dm cache: fix error return code in cache_create()
Date: Fri, 19 Apr 2013 13:11:30 +0800
Message-ID: <CAPgLHd8twedhKj8MNkCyHKTEtV421_251Ot-zm-=boCJZ5nc9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the memory alloc error handing
cases instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-cache-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index c5ce8a3b..c44f5e5 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1972,6 +1972,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	atomic_set(&cache->nr_migrations, 0);
 	init_waitqueue_head(&cache->migration_wait);
 
+	r = -ENOMEM;
 	cache->nr_dirty = 0;
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {

