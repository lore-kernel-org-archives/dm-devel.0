From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: dm-cache: resize_cache_dev resizing to wrong size ?
Date: Sat, 30 Nov 2013 12:58:42 +0100
Message-ID: <20131130125842.098ad167@x2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/2==QIPsapEESRYcb+xy257d"
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

--MP_/2==QIPsapEESRYcb+xy257d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi.

CC'ing f494a9c6b1b6dd9a9f21bbb75d9210d478eeb498 author.
Please keep me CC'ed in replies, I'm not subscribed.

Wandering aimlessly in dm-cache source as of current linus master
(3.13-rc2, dc1ccc48159d63eca5089e507c82c7d22ef60839), I noticed this:

dm-cache-metadata.c:
  int dm_cache_resize(struct dm_cache_metadata *cmd, dm_cblock_t new_cache_size)

Note second argument is new_cache_size. But caller is doing:

dm-cache-target.c:
  static int resize_cache_dev(struct cache *cache, dm_cblock_t new_size)
  [...]
    r = dm_cache_resize(cache->cmd, cache->cache_size);
  [...]
    cache->cache_size = new_size;

dm_cache_resize is called with cache->cache_size before it gets updated
to new_size, so it looks like a no-op.

Can someone confirm my reading ?

If confirmed, the effect is that a shrink (only ? I'm not familiar with
cache metadata) operation can result in metadata inconsistent with
cache device size.

See attachment for proposed (untested) fix.
It applies cleanly as of current device-mapper for-next branch.

Regards,
-- 
Vincent Pelletier

--MP_/2==QIPsapEESRYcb+xy257d
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=0001-dm-cache-actually-shrink-cache-to-new-size.patch

From 99fe12976eae6abd67be0c39798c61ca9acd683d Mon Sep 17 00:00:00 2001
Message-Id: <99fe12976eae6abd67be0c39798c61ca9acd683d.1385805937.git.plr.vincent@gmail.com>
From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sat, 30 Nov 2013 11:05:12 +0100
Subject: dm cache: actually shrink cache to new size

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
---
 drivers/md/dm-cache-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9efcf10..1b1469e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2755,7 +2755,7 @@ static int resize_cache_dev(struct cache *cache, dm_cblock_t new_size)
 {
 	int r;
 
-	r = dm_cache_resize(cache->cmd, cache->cache_size);
+	r = dm_cache_resize(cache->cmd, new_size);
 	if (r) {
 		DMERR("could not resize cache metadata");
 		return r;
-- 
1.8.4.4


--MP_/2==QIPsapEESRYcb+xy257d
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--MP_/2==QIPsapEESRYcb+xy257d--
