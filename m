From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 23/26] raid1: use bio_alloc_pages()
Date: Mon, 15 Oct 2012 13:09:26 -0700
Message-ID: <1350331769-14856-53-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d30b4cb..18b743a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -92,7 +92,6 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
-	struct page *page;
 	struct r1bio *r1_bio;
 	struct bio *bio;
 	int i, j;
@@ -122,14 +121,10 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		j = 1;
 	while(j--) {
 		bio = r1_bio->bios[j];
-		for (i = 0; i < RESYNC_PAGES; i++) {
-			page = alloc_page(gfp_flags);
-			if (unlikely(!page))
-				goto out_free_pages;
+		bio->bi_vcnt = RESYNC_PAGES;
 
-			bio->bi_io_vec[i].bv_page = page;
-			bio->bi_vcnt = i+1;
-		}
+		if (bio_alloc_pages(bio, gfp_flags))
+			goto out_free_bio;
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
@@ -143,11 +138,6 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 
 	return r1_bio;
 
-out_free_pages:
-	for (j=0 ; j < pi->raid_disks; j++)
-		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
-			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
-	j = -1;
 out_free_bio:
 	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
-- 
1.7.12
