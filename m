From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 9/9] dm-mpath: Add nowait support
Date: Wed, 26 Jul 2017 18:58:06 -0500
Message-ID: <20170726235806.12148-10-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If there are no queues, bail if REQ_NOWAIT is set instead
of queueing up I/O.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/dm-mpath.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0e8ab5bb3575..c6572a9967dc 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -543,6 +543,11 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio, struct dm_m
 
 	if ((pgpath && queue_io) ||
 	    (!pgpath && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))) {
+		/* Bail if nowait is set */
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return DM_MAPIO_SUBMITTED;
+		}
 		/* Queue for the daemon to resubmit */
 		spin_lock_irqsave(&m->lock, flags);
 		bio_list_add(&m->queued_bios, bio);
-- 
2.12.3

