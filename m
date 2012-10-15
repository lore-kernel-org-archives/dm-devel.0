From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 12/26] raid1: use bio_reset()
Date: Mon, 15 Oct 2012 13:09:15 -0700
Message-ID: <1350331769-14856-42-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
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
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>
List-Id: dm-devel.ids

I couldn't figure out what sbio->bi_end_io in process_checks() was
supposed to be, so I took the easy way out.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ee85154..bd3e3b9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1835,6 +1835,7 @@ static int process_checks(struct r1bio *r1_bio)
 	int primary;
 	int i;
 	int vcnt;
+	bio_end_io_t *bi_end_io;
 
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
@@ -1876,13 +1877,11 @@ static int process_checks(struct r1bio *r1_bio)
 			continue;
 		}
 		/* fixup the bio for reuse */
+		bi_end_io = sbio->bi_end_io;
+		bio_reset(sbio);
+
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
