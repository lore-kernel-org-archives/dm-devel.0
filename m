From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 18/26] pktcdvd: Use bio_reset() in disabled
	code to kill bi_idx usage
Date: Mon, 24 Sep 2012 15:34:58 -0700
Message-ID: <1348526106-17074-19-git-send-email-koverstreet@google.com>
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
Cc: axboe@kernel.dk, Jiri Kosina <jkosina@suse.cz>, Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com
List-Id: dm-devel.ids

In the short term this'll help with code auditing, and if this code ever
gets used now it's converted :)

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/pktcdvd.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 783c96c..1119042 100644
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
