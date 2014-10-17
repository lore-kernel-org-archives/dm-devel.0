From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 09/17] dm: improve documentation and
	code clarity in dm_merge_bvec
Date: Fri, 17 Oct 2014 14:37:11 -0400
Message-ID: <1413571039-31986-9-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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

These code changes do not introduce a functional change.

But bio_add_page() will never attempt to build up a bio larger than
queue_max_sectors().  Similarly, bio_get_nr_vecs() is also bound by
queue_max_sectors().  Therefore, there is no point in allowing
dm_merge_bvec() to answer "how many sectors can a bio have at this
offset?" with anything larger than queue_max_sectors().  Using
queue_max_sectors() rather than BIO_MAX_SECTORS serves to more
accurately convey the limits that are being imposed.

Also, use unlikely() to clarify the fact that the defensive code in
dm_merge_bvec() relative to max_size going negative shouldn't ever
happen -- if it does happen there is a bug in the block layer for
requesting larger than dm_merge_bvec()'s initial response for a given
offset.  Also, update a comment in dm_merge_bvec() relative to
max_hw_sectors_kb.  And fix empty newline whitespace.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 58f3927..0fee0e5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1607,9 +1607,9 @@ static int dm_merge_bvec(struct request_queue *q,
 	 * Find maximum amount of I/O that won't need splitting
 	 */
 	max_sectors = min(max_io_len(bvm->bi_sector, ti),
-			  (sector_t) BIO_MAX_SECTORS);
+			  (sector_t) queue_max_sectors(q));
 	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
-	if (max_size < 0)
+	if (unlikely(max_size < 0)) /* this shouldn't _ever_ happen */
 		max_size = 0;
 
 	/*
@@ -1621,10 +1621,10 @@ static int dm_merge_bvec(struct request_queue *q,
 		max_size = ti->type->merge(ti, bvm, biovec, max_size);
 	/*
 	 * If the target doesn't support merge method and some of the devices
-	 * provided their merge_bvec method (we know this by looking at
-	 * queue_max_hw_sectors), then we can't allow bios with multiple vector
-	 * entries.  So always set max_size to 0, and the code below allows
-	 * just one page.
+	 * provided their merge_bvec method (we know this by looking for the
+	 * max_hw_sectors that dm_set_device_limits may set), then we can't
+	 * allow bios with multiple vector entries.  So always set max_size
+	 * to 0, and the code below allows just one page.
 	 */
 	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
 		max_size = 0;
-- 
1.8.3.1
