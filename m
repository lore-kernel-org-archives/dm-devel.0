From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] bio: have bio_kmap_irq return the size of mapped data
 (fwd)
Date: Tue, 7 Nov 2017 16:45:17 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I need the function bio_kmap_irq in the driver that I am developing, but 
it doesn't return the size of the mapped data. I've made this patch to fix 
it.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The function bio_kmap_irq is not usable because it does not return the
size of the mapped data.

Fix bio_kmap_irq and __bio_kmap_irq so that they return the size of
mapped data.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/bio.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h
+++ linux-2.6/include/linux/bio.h
@@ -576,14 +576,16 @@ static inline void bvec_kunmap_irq(char
 #endif
 
 static inline char *__bio_kmap_irq(struct bio *bio, struct bvec_iter iter,
-				   unsigned long *flags)
+				   unsigned long *flags, unsigned *size)
 {
-	return bvec_kmap_irq(&bio_iter_iovec(bio, iter), flags);
+	struct bio_vec bv = bio_iter_iovec(bio, iter);
+	*size = bv.bv_len;
+	return bvec_kmap_irq(&bv, flags);
 }
 #define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
 
-#define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_iter, (flags))
+#define bio_kmap_irq(bio, flags, size) \
+	__bio_kmap_irq((bio), (bio)->bi_iter, (flags), (size))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
 /*
