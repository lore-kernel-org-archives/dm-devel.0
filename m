From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] bio: have bio_kmap_irq return the size of
	mapped data
Date: Wed, 27 Sep 2017 11:44:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709271144280.9676@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1709271122410.9676@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709271122410.9676@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

From 7665b026ad2b56350267dc2a03150618598372dc Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Thu, 14 Jan 2016 14:48:25 -0500
Subject: bio: have bio_kmap_irq return the size of mapped data

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
@@ -549,14 +549,16 @@ static inline void bvec_kunmap_irq(char
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
