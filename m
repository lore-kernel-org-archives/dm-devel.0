From: Greg Thelen <gthelen@google.com>
Subject: [PATCH] dm bufio: fully initialize shrinker
Date: Thu, 31 Jul 2014 09:07:19 -0700
Message-ID: <1406822839-2423-1-git-send-email-gthelen@google.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, Dave Chinner <dchinner@redhat.com>, linux-raid@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
List-Id: dm-devel.ids

1d3d4437eae1 ("vmscan: per-node deferred work") added a flags field to
struct shrinker assuming that all shrinkers were zero filled.  The dm
bufio shrinker is not zero filled, which leaves arbitrary kmalloc() data
in flags.  So far the only defined flags bit is SHRINKER_NUMA_AWARE.
But there are proposed patches which add other bits to shrinker.flags
(e.g. memcg awareness).

Rather than simply initializing the shrinker, this patch uses kzalloc()
when allocating the dm_bufio_client to ensure that the embedded shrinker
and any other similar structures are zeroed.

This fixes theoretical over aggressive shrinking of dm bufio objects.
If the uninitialized dm_bufio_client.shrinker.flags contains
SHRINKER_NUMA_AWARE then shrink_slab() would call the dm shrinker for
each numa node rather than just once.  This has been broken since 3.12.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/md/dm-bufio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 4e84095833db..d724459860d9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1541,7 +1541,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
 	       (block_size & (block_size - 1)));
 
-	c = kmalloc(sizeof(*c), GFP_KERNEL);
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
-- 
2.0.0.526.g5318336

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
