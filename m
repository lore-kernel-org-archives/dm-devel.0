From: heinzm@redhat.com
Subject: [PATCH 1/1] dm cache: fix accesses past end of origin
	device
Date: Wed, 12 Mar 2014 16:13:44 +0100
Message-ID: <1394637224-12324-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

In order to avoid wasting cache space, we do not want to cache any partial
block at the end of the origin device.

This patch fixes accesses past the end of the origin device whilst trying
to promote an undetected partial block with respect to:

- recognizing access to the partial block
- avoiding out of bounds access to the discard bitset
- initializing the per bio data struct to allow cache_end_io to work properly

An example of the flaw in the kernel log:

[1460175.271246] dm-5: rw=0, want=20971520, limit=20971456
[1460175.271969] device-mapper: cache: promotion failed; couldn't copy block


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-cache-target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git 3.14.0-rc6.orig/drivers/md/dm-cache-target.c 3.14.0-rc6/drivers/md/dm-cache-target.c
index 354bbc1..074b9c8 100644
--- 3.14.0-rc6.orig/drivers/md/dm-cache-target.c
+++ 3.14.0-rc6/drivers/md/dm-cache-target.c
@@ -2465,20 +2465,18 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 	bool discarded_block;
 	struct dm_bio_prison_cell *cell;
 	struct policy_result lookup_result;
-	struct per_bio_data *pb;
+	struct per_bio_data *pb = init_per_bio_data(bio, pb_data_size);
 
-	if (from_oblock(block) > from_oblock(cache->origin_blocks)) {
+	if (unlikely(from_oblock(block) >= from_oblock(cache->origin_blocks))) {
 		/*
 		 * This can only occur if the io goes to a partial block at
 		 * the end of the origin device.  We don't cache these.
 		 * Just remap to the origin and carry on.
 		 */
-		remap_to_origin_clear_discard(cache, bio, block);
+		remap_to_origin(cache, bio);
 		return DM_MAPIO_REMAPPED;
 	}
 
-	pb = init_per_bio_data(bio, pb_data_size);
-
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		defer_bio(cache, bio);
 		return DM_MAPIO_SUBMITTED;
-- 
1.8.5.3
