From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 13/26] raid1: use bio_reset()
Date: Mon, 24 Sep 2012 15:34:53 -0700
Message-ID: <1348526106-17074-14-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, vgoyal@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 28f506a..4614b9e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1851,7 +1851,7 @@ static int process_checks(struct r1bio *r1_bio)
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
 
-		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
+		if (sbio->bi_end_io != end_sync_read)
 			continue;
 
 		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
@@ -1876,16 +1876,15 @@ static int process_checks(struct r1bio *r1_bio)
 			continue;
 		}
 		/* fixup the bio for reuse */
+		bio_reset(sbio);
 		sbio->bi_vcnt = vcnt;
 		sbio->bi_size = r1_bio->sectors << 9;
-		sbio->bi_idx = 0;
-		sbio->bi_phys_segments = 0;
-		sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		sbio->bi_flags |= 1 << BIO_UPTODATE;
-		sbio->bi_next = NULL;
 		sbio->bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		sbio->bi_end_io = end_sync_read;
+		sbio->bi_private = r1_bio;
+
 		size = sbio->bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
@@ -2426,18 +2425,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
 		bio = r1_bio->bios[i];
-
-		/* take from bio_init */
-		bio->bi_next = NULL;
-		bio->bi_flags &= ~(BIO_POOL_MASK-1);
-		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_rw = READ;
-		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_size = 0;
-		bio->bi_end_io = NULL;
-		bio->bi_private = NULL;
+		bio_reset(bio);
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
-- 
1.7.12
