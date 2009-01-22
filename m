From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-io: don't allocate vector larger than
	BIO_MAX_PAGES
Date: Wed, 21 Jan 2009 22:32:20 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901212227100.3027@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-io calls bio_get_nr_vecs to get the maximum number of pages for a given
device, then adds 1 to it and allocates bio with this size.

The last vector is not used for i/o, it is used to hold information about
the region this i/o belongs to.

If bio_get_nr_vecs returned the maximum biovec size, dm-io attempts to allocate
bio with one more vector and fails.

Very likely this was the reason for bug
https://bugzilla.redhat.com/show_bug.cgi?id=173153

(the bug was fixed with an userspace workaround preventing lvm from creating
snapshots with chunksize >512k; after this patch is applied, that limit can
be dropped)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.29-rc1-devel/drivers/md/dm-io.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/drivers/md/dm-io.c	2009-01-22 04:13:45.000000000 +0100
+++ linux-2.6.29-rc1-devel/drivers/md/dm-io.c	2009-01-22 04:14:13.000000000 +0100
@@ -292,6 +292,8 @@ static void do_region(int rw, unsigned r
 					     (PAGE_SIZE >> SECTOR_SHIFT));
 		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
 				      num_bvecs);
+		if (unlikely(num_bvecs > BIO_MAX_PAGES))
+			num_bvecs = BIO_MAX_PAGES;
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
