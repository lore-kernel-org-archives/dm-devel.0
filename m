From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/5] bitmap: Drop unnecessary 0 check for u32 array operations
Date: Mon, 18 Jun 2018 16:10:00 +0300
Message-ID: <20180618131003.88110-3-andriy.shevchenko@linux.intel.com>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: dm-devel.ids

The nbits == 0 is safe to be supplied to the function body, so,
remove unnecessary checks in bitmap_to_arr32() and bitmap_from_arr32().

Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/bitmap.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 58f9750e49c6..33e95cd359a2 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1132,14 +1132,10 @@ EXPORT_SYMBOL(bitmap_copy_le);
  *	@buf: array of u32 (in host byte order), the source bitmap
  *	@nbits: number of bits in @bitmap
  */
-void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
-						unsigned int nbits)
+void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits)
 {
 	unsigned int i, halfwords;
 
-	if (!nbits)
-		return;
-
 	halfwords = DIV_ROUND_UP(nbits, 32);
 	for (i = 0; i < halfwords; i++) {
 		bitmap[i/2] = (unsigned long) buf[i];
@@ -1163,9 +1159,6 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 {
 	unsigned int i, halfwords;
 
-	if (!nbits)
-		return;
-
 	halfwords = DIV_ROUND_UP(nbits, 32);
 	for (i = 0; i < halfwords; i++) {
 		buf[i] = (u32) (bitmap[i/2] & UINT_MAX);
-- 
2.17.1
