From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-space-map-disk: improve bit testing
Date: Tue, 16 Aug 2011 11:08:55 +0100
Message-ID: <20110816100855.GD4284@ubuntu>
References: <Pine.LNX.4.64.1108151450370.18170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108151450370.18170@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 15, 2011 at 02:52:14PM -0400, Mikulas Patocka wrote:
> dm-space-map-disk: improve bit testing

Very nice, thanks.  btw, you can get rid of WORD_MASK_LOW too:

diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
index 8d2c4c2..fbfa6f3 100644
--- a/drivers/md/persistent-data/dm-space-map-disk.c
+++ b/drivers/md/persistent-data/dm-space-map-disk.c
@@ -69,7 +69,6 @@ void *dm_bitmap_data(struct dm_block *b)
 	return dm_block_data(b) + sizeof(struct disk_bitmap_header);
 }
 
-#define WORD_MASK_LOW 0x5555555555555555ULL
 #define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
 
 static unsigned bitmap_word_used(void *addr, unsigned b)
@@ -78,7 +77,7 @@ static unsigned bitmap_word_used(void *addr, unsigned b)
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
 
 	uint64_t bits = le64_to_cpu(*w_le);
-	uint64_t mask = (bits - WORD_MASK_LOW) & WORD_MASK_HIGH;
+	uint64_t mask = (bits + WORD_MASK_HIGH + 1) & WORD_MASK_HIGH;
 
 	return !(~bits & mask);
 }
