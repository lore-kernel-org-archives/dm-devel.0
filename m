From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-log-writes: fix bug with too large bios
Date: Fri, 27 May 2016 10:51:48 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1605271047280.2109@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Josef Bacik <jbacik@fb.com>
Cc: dm-devel@redhat.com, James Johnston <johnstonj.public@codenest.com>, 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, linux-bcache@vger.kernel.org, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

bio_alloc can allocate a bio with at most BIO_MAX_PAGES (256) vector
entries. However, the incoming bio may have more vector entries if it was
allocated by other means. For example, bcache submits bios with more than
BIO_MAX_PAGES entries. This results in bio_alloc failure.

To avoid the failure, change the code so that it allocates bio with at
most BIO_MAX_PAGES entries. If the incoming bio has more entries,
bio_add_page will fail and a new bio will be allocated - the code that
handles bio_add_page failure already exists in the dm-log-writes target.

Also, move atomic_inc(&lc->io_blocks) before bio_alloc to fix a bug that
the target hangs if bio_alloc fails. The error path does put_io_block(lc),
so we must do atomic_inc(&lc->io_blocks) before invoking the error path to
avoid underflow of lc->io_blocks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.1+

Index: linux-4.6/drivers/md/dm-log-writes.c
===================================================================
--- linux-4.6.orig/drivers/md/dm-log-writes.c
+++ linux-4.6/drivers/md/dm-log-writes.c
@@ -258,12 +258,12 @@ static int log_one_block(struct log_writ
 		goto out;
 	sector++;
 
-	bio = bio_alloc(GFP_KERNEL, block->vec_cnt);
+	atomic_inc(&lc->io_blocks);
+	bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt, BIO_MAX_PAGES));
 	if (!bio) {
 		DMERR("Couldn't alloc log bio");
 		goto error;
 	}
-	atomic_inc(&lc->io_blocks);
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = lc->logdev->bdev;
@@ -280,7 +280,7 @@ static int log_one_block(struct log_writ
 		if (ret != block->vecs[i].bv_len) {
 			atomic_inc(&lc->io_blocks);
 			submit_bio(WRITE, bio);
-			bio = bio_alloc(GFP_KERNEL, block->vec_cnt - i);
+			bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt - i, BIO_MAX_PAGES));
 			if (!bio) {
 				DMERR("Couldn't alloc log bio");
 				goto error;
