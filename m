From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] bio_has_data-redefine.patch
Date: Wed, 29 Apr 2009 02:36:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904290228460.10041@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I forgot to send this one.

For Jens: Device mapper dm-io stores some additional information in the 
bio vector past the vector end, so the test for zero-data barrier 
bio->bi_io_vec != NULL cannot be used. It would mistakenly treat zero 
barriers as data-barrier if they have zero data and non-NULL vector.

For Alasdair: this must be applied before all the raid1-barrier patches. 
If you apply raid1 patches without this, it will compile, but it will 
behave strangely. Any other target-barrier patches can be applied without 
this.

Mikulas

---

Change definition of bio_has_data (and bio_empty_barrier that uses it).

With the following dm-io patch, it may happen that we create a null 
barrier bio that has non-zero bi_io_vec but zero bi_size and bi_vcnt. 
(dm-io uses data past the vector end to store its own bookkeeping 
information, so the vector must be non-null).

This patch changes the logic so that bio with zero length and non-zero 
vector pointer is recognized as an empty-barrier bio. Without this patch, 
such bio would be mistreated at a number of locations in the bio stack as 
well as in device mapper.

I grepped for all users of bio_has_data and didn't find problem with any 
of them. I also grepped for other code locations that may mistakenly use 
bio->bi_io_vec != NULL to test for an empty barrier and there were not any 
other.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/bio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc2-devel/include/linux/bio.h
===================================================================
--- linux-2.6.30-rc2-devel.orig/include/linux/bio.h	2009-04-24 05:28:39.000000000 +0200
+++ linux-2.6.30-rc2-devel/include/linux/bio.h	2009-04-24 05:29:15.000000000 +0200
@@ -504,7 +504,7 @@ static inline char *__bio_kmap_irq(struc
  */
 static inline int bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	return bio && bio->bi_size != 0;
 }
 
 /*
