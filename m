From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 12/26] raid1: use bio_reset()
Date: Mon, 10 Sep 2012 17:22:23 -0700
Message-ID: <1347322957-25260-13-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347322957-25260-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

I couldn't figure out what sbio->bi_end_io in process_checks() was
supposed to be, so I took the easy way out.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
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
