From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 7/9] dm: Add nowait support to raid1
Date: Wed, 26 Jul 2017 18:58:04 -0500
Message-ID: <20170726235806.12148-8-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If the I/O would block because the devices are syncing, bail.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/dm-raid1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index a4fbd911d566..446ac581627f 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1219,6 +1219,11 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 		if (bio->bi_opf & REQ_RAHEAD)
 			return DM_MAPIO_KILL;
 
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return DM_MAPIO_SUBMITTED;
+		}
+
 		queue_bio(ms, bio, rw);
 		return DM_MAPIO_SUBMITTED;
 	}
-- 
2.12.3

