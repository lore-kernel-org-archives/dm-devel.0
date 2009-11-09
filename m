From: Mikulas Patocka <mpatocka@redhat.com>
Subject: PATCH for dm-raid1 barriers
Date: Mon, 9 Nov 2009 14:22:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911091420590.18408@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is that patch for bio code that is needed for dm-raid1 barriers.

Mikulas

---

Change definition of bio_has_data (and bio_empty_barrier that uses it).

With the following dm-io patch, it may happen that we create a null barrier bio
that has non-zero bi_io_vec but zero bi_size and bi_vcnt. (dm-io uses data past the vector end to store its own bookkeeping information, so the vector must
be non-null).

This patch changes the logic so that bio with zero length and non-zero vector
pointer is recognized as an empty-barrier bio. Without this patch, such bio
would be mistreated at a number of locations in the bio stack as well as in
device mapper.

I grepped for all users of bio_has_data and didn't find problem with any of
them. I also grepped for other code locations that may mistakenly use
bio->bi_io_vec != NULL to test for an empty barrier and there were not any
other.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/bio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.30-rc4-devel/include/linux/bio.h
===================================================================
--- linux-2.6.30-rc4-devel.orig/include/linux/bio.h	2009-05-04 17:00:52.000000000 +0200
+++ linux-2.6.30-rc4-devel/include/linux/bio.h	2009-05-04 17:03:55.000000000 +0200
@@ -505,7 +505,7 @@ static inline char *__bio_kmap_irq(struc
  */
 static inline int bio_has_data(struct bio *bio)
 {
-	return bio && bio->bi_io_vec != NULL;
+	return bio && bio->bi_size != 0;
 }
 
 /*
