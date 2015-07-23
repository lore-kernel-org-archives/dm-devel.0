From: Colin King <colin.king@canonical.com>
Subject: [PATCH] dm cache: fix alloc_bitset check that always evaluates as false
Date: Thu, 23 Jul 2015 16:47:59 +0100
Message-ID: <1437666479-24633-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Colin Ian King <colin.king@canonical.com>

static analysis by cppcheck has found a check on alloc_bitset that
always evaluates as false and hence never finds an allocation failure:

[drivers/md/dm-cache-policy-smq.c:1689]: (warning) Logical conjunction
  always evaluates to false: !EXPR && EXPR.

Fix this by removing the incorrect mq->cache_hit_bits check

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-cache-policy-smq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index b6f2265..48a4a82 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1686,7 +1686,7 @@ static struct dm_cache_policy *smq_create(dm_cblock_t cache_size,
 
 	if (from_cblock(cache_size)) {
 		mq->cache_hit_bits = alloc_bitset(from_cblock(cache_size));
-		if (!mq->cache_hit_bits && mq->cache_hit_bits) {
+		if (!mq->cache_hit_bits) {
 			DMERR("couldn't allocate cache hit bitset");
 			goto bad_cache_hit_bits;
 		}
-- 
2.1.4

