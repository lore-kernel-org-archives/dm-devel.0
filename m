From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 17/26] pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
Date: Mon, 10 Sep 2012 17:22:28 -0700
Message-ID: <1347322957-25260-18-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, tj@kernel.org, neilb@suse.de, Jiri Kosina <jkosina@suse.cz>
List-Id: dm-devel.ids

In the short term this'll help with code auditing, and if this code ever
gets used now it's converted :)

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/pktcdvd.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1079a77..5318ad39 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1156,16 +1156,15 @@ static int pkt_start_recovery(struct packet_data *pkt)
 	new_sector = new_block * (CD_FRAMESIZE >> 9);
 	pkt->sector = new_sector;
 
+	bio_reset(pkt->bio);
+	pkt->bio->bi_bdev = pd->bdev;
+	pkt->bio->bi_rw = REQ_WRITE;
 	pkt->bio->bi_sector = new_sector;
-	pkt->bio->bi_next = NULL;
-	pkt->bio->bi_flags = 1 << BIO_UPTODATE;
-	pkt->bio->bi_idx = 0;
-
-	BUG_ON(pkt->bio->bi_rw != REQ_WRITE);
-	BUG_ON(pkt->bio->bi_vcnt != pkt->frames);
-	BUG_ON(pkt->bio->bi_size != pkt->frames * CD_FRAMESIZE);
-	BUG_ON(pkt->bio->bi_end_io != pkt_end_io_packet_write);
-	BUG_ON(pkt->bio->bi_private != pkt);
+	pkt->bio->bi_size = pkt->frames * CD_FRAMESIZE;
+	pkt->bio->bi_vcnt = pkt->frames;
+
+	pkt->bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->bio->bi_private = pkt;
 
 	drop_super(sb);
 	return 1;
-- 
1.7.12
