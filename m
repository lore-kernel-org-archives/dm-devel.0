From: NeilBrown <neilb@suse.de>
Subject: [PATCH 20/24] md/bitmap: optimise scanning of empty bitmaps.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.48900.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

A bitmap is stored as one page per 2048 bits.
If none of the bits are set, the page is not allocated.

When bitmap_get_counter finds that a page isn't allocate,
it just reports that one bit work of space isn't flagged,
rather than reporting that 2048 bits worth of space are
unflagged.
This can cause searches for flagged bits (e.g. bitmap_close_sync)
to do more work than is really necessary.

So change bitmap_get_counter (when creating) to report a number of
blocks that more accurately reports the range of the device for which
no counter currently exists.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 3f04699..29a3c86 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1235,29 +1235,32 @@ __acquires(bitmap->lock)
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
 	sector_t csize;
+	int err;
+
+	err = bitmap_checkpage(bitmap, page, create);
 
-	if (bitmap_checkpage(bitmap, page, create) < 0) {
+	if (bitmap->bp[page].hijacked ||
+	    bitmap->bp[page].map == NULL)
+		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap) +
+					  PAGE_COUNTER_SHIFT - 1);
+	else
 		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap));
-		*blocks = csize - (offset & (csize - 1));
+	*blocks = csize - (offset & (csize - 1));
+
+	if (err < 0)
 		return NULL;
-	}
+
 	/* now locked ... */
 
 	if (bitmap->bp[page].hijacked) { /* hijacked pointer */
 		/* should we use the first or second counter field
 		 * of the hijacked pointer? */
 		int hi = (pageoff > PAGE_COUNTER_MASK);
-		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap) +
-					  PAGE_COUNTER_SHIFT - 1);
-		*blocks = csize - (offset & (csize - 1));
 		return  &((bitmap_counter_t *)
 			  &bitmap->bp[page].map)[hi];
-	} else { /* page is allocated */
-		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap));
-		*blocks = csize - (offset & (csize - 1));
+	} else /* page is allocated */
 		return (bitmap_counter_t *)
 			&(bitmap->bp[page].map[pageoff]);
-	}
 }
 
 int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)


