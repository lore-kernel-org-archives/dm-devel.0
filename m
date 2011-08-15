From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-space-map-disk: improve bit testing
Date: Mon, 15 Aug 2011 14:52:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108151450370.18170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-space-map-disk: improve bit testing

This patch improves bit testing in bitmap_word_used:
* replace three tests with just one condition.
* make the test accurate --- the function returns 0 only if there exists
  a pair of two zeroed bits. Previously, the function returned 0 in some other
  cases too.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/persistent-data/dm-space-map-disk.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-3.0-fast/drivers/md/persistent-data/dm-space-map-disk.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/persistent-data/dm-space-map-disk.c	2011-08-15 20:39:38.000000000 +0200
+++ linux-3.0-fast/drivers/md/persistent-data/dm-space-map-disk.c	2011-08-15 20:44:34.000000000 +0200
@@ -70,7 +70,6 @@ void *dm_bitmap_data(struct dm_block *b)
 
 #define WORD_MASK_LOW 0x5555555555555555ULL
 #define WORD_MASK_HIGH 0xAAAAAAAAAAAAAAAAULL
-#define WORD_MASK_ALL 0xFFFFFFFFFFFFFFFFULL
 
 static unsigned bitmap_word_used(void *addr, unsigned b)
 {
@@ -78,10 +77,9 @@ static unsigned bitmap_word_used(void *a
 	__le64 *w_le = words_le + (b >> ENTRIES_SHIFT);
 
 	uint64_t bits = le64_to_cpu(*w_le);
+	uint64_t mask = (bits - WORD_MASK_LOW) & WORD_MASK_HIGH;
 
-	return ((bits & WORD_MASK_LOW) == WORD_MASK_LOW ||
-		(bits & WORD_MASK_HIGH) == WORD_MASK_HIGH ||
-		(bits & WORD_MASK_ALL) == WORD_MASK_ALL);
+	return !(~bits & mask);
 }
 
 unsigned sm_lookup_bitmap(void *addr, unsigned b)
