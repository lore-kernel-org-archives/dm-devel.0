From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 04/26] md: Convert md_trim_bio() to use
	bio_advance()
Date: Mon, 10 Sep 2012 17:22:15 -0700
Message-ID: <1347322957-25260-5-git-send-email-koverstreet@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1347322957-25260-1-git-send-email-koverstreet@google.com>
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
Cc: axboe@kernel.dk, tj@kernel.org, Kent Overstreet <koverstreet@google.com>
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7a2b079..51ce48c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	struct bio_vec *bvec;
 	int sofar = 0;
 
-	size <<= 9;
 	if (offset == 0 && size == bio->bi_size)
 		return;
 
-	bio->bi_sector += offset;
-	bio->bi_size = size;
-	offset <<= 9;
 	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
 
-	while (bio->bi_idx < bio->bi_vcnt &&
-	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
-		/* remove this whole bio_vec */
-		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
-		bio->bi_idx++;
-	}
-	if (bio->bi_idx < bio->bi_vcnt) {
-		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
-		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
-	}
+	bio_advance(bio, offset << 9);
+
+	size <<= 9;
+	bio->bi_size = size;
+
 	/* avoid any complications with bi_idx being non-zero*/
 	if (bio->bi_idx) {
 		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-- 
1.7.12
