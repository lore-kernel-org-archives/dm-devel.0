From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] md: dm-stripe: Use struct_size() in kmalloc()
Date: Wed, 2 Oct 2019 14:03:41 -0500
Message-ID: <20191002190341.GA8900@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: dm-devel.ids

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct stripe_c {
        ...
        struct stripe stripe[0];
};

In this case alloc_context() and dm_array_too_big() are removed and
replaced by the direct use of the struct_size() helper in kmalloc().

Notice that open-coded form is prone to type mistakes.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/md/dm-stripe.c        | 15 +--------------
 include/linux/device-mapper.h |  3 ---
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 8547d7594338..63bbcc20f49a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -55,19 +55,6 @@ static void trigger_event(struct work_struct *work)
 	dm_table_event(sc->ti->table);
 }
 
-static inline struct stripe_c *alloc_context(unsigned int stripes)
-{
-	size_t len;
-
-	if (dm_array_too_big(sizeof(struct stripe_c), sizeof(struct stripe),
-			     stripes))
-		return NULL;
-
-	len = sizeof(struct stripe_c) + (sizeof(struct stripe) * stripes);
-
-	return kmalloc(len, GFP_KERNEL);
-}
-
 /*
  * Parse a single <dev> <sector> pair
  */
@@ -142,7 +129,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	sc = alloc_context(stripes);
+	sc = kmalloc(struct_size(sc, stripe, stripes), GFP_KERNEL);
 	if (!sc) {
 		ti->error = "Memory allocation for striped context "
 		    "failed";
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 399ad8632356..2e13826898b2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -594,9 +594,6 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size);
  */
 #define dm_round_up(n, sz) (dm_div_up((n), (sz)) * (sz))
 
-#define dm_array_too_big(fixed, obj, num) \
-	((num) > (UINT_MAX - (fixed)) / (obj))
-
 /*
  * Sector offset taken relative to the start of the target instead of
  * relative to the start of the device.
-- 
2.23.0
