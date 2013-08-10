From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: [PATCH] bugfix: map_context->ptr must be nullify in
	no-cache path.
Date: Sat, 10 Aug 2013 23:39:35 +0900
Message-ID: <520650A7.4030408@gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: =?UTF-8?B?6LydIOaXqeW3nQ==?= <ruby.wktk@gmail.com>
List-Id: dm-devel.ids

Hi,

Please apply this patch after the previous patch.
This will fix bug.

First, sorry to forget adding signed-off to that patch.

When running prepare script,
the kernel sometimes halt was my annoying problem.
I may solve this with this patch.

lc_end_io is a callback of a splitted bio.
It atomic_dec some reference count
if map_context->ptr is not NULL.

dmsetup create first calls lc_ctr and
seems to submit few bios to the device just created.  
At this stage, the device is without cache and
it will later attach to cache.

Without cache,
said atomic_dec is not only needless
but also crash the kernel by NULL access.

Maybe,
map_context->ptr
where map_context is per_bio_data within bio
is NOT initialized zero-filled and
that makes the process
sometimes run through atomic_dec even though without cache.

Moving the line
assigning NULL to map_context->ptr in lc_map
to before "no-cache" path can solve this problem.

After this patch applied,
the kernel halt did not recur.

Akira


Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
---
 drivers/md/dm-lc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-lc.c b/drivers/md/dm-lc.c
index b70ab38..8f76383 100644
--- a/drivers/md/dm-lc.c
+++ b/drivers/md/dm-lc.c
@@ -1889,6 +1889,9 @@ static int lc_map(struct dm_target *ti, struct bio *bio)
 	struct lc_device *lc = ti->private;
 	struct dm_dev *orig = lc->device;
 
+	map_context = dm_per_bio_data(bio, ti->per_bio_data_size);
+	map_context->ptr = NULL;
+
 	if (!lc->cache) {
 		bio_remap(bio, orig, bio->bi_sector);
 		return DM_MAPIO_REMAPPED;
@@ -1918,9 +1921,6 @@ static int lc_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	map_context = dm_per_bio_data(bio, ti->per_bio_data_size);
-	map_context->ptr = NULL;
-
 	bio_count = bio->bi_size >> SECTOR_SHIFT;
 	bio_fullsize = (bio_count == (1 << 3));
 	bio_offset = bio->bi_sector % (1 << 3);
-- 
1.8.3.4
