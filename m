From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 6/9] dm: add nowait support
Date: Wed, 26 Jul 2017 18:58:03 -0500
Message-ID: <20170726235806.12148-7-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Add support for bio based dm devices, which exclusively
sets a make_request_fn(). Request based devices are supported
by default.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2edbcc2d7d3f..aa9c1a5f2966 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1550,6 +1550,8 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 
 		if (!(bio->bi_opf & REQ_RAHEAD))
 			queue_io(md, bio);
+		else if (bio->bi_opf & REQ_NOWAIT)
+			bio_wouldblock_error(bio);
 		else
 			bio_io_error(bio);
 		return BLK_QC_T_NONE;
@@ -2066,6 +2068,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
+		queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, md->queue);
 		/*
 		 * DM handles splitting bios as needed.  Free the bio_split bioset
 		 * since it won't be used (saves 1 process per bio-based DM device).
-- 
2.12.3

