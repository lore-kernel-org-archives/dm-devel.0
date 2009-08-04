From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] Check on-disk chunk size.
Date: Mon, 3 Aug 2009 21:44:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908032144090.6002@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032138450.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032139440.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032143200.6002@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908032143200.6002@hs20-bc2-1.build.redhat.com>
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

Check on-disk chunk size.

The previous code blindly used the chunk size stored on disk. This is wrong
because it can lead to a crash if the disk storage is corrupted. See

https://bugzilla.redhat.com/show_bug.cgi?id=461506

This code passes on-disk size through similar checks as size specified
on the table argument line, thus it won't allow to use bogus values (such
as zero, in case of that bug).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.31-rc5-devel.orig/drivers/md/dm-snap-persistent.c	2009-08-04 03:20:11.000000000 +0200
+++ linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c	2009-08-04 03:24:16.000000000 +0200
@@ -283,6 +283,7 @@ static int read_header(struct pstore *ps
 	struct disk_header *dh;
 	chunk_t chunk_size;
 	int chunk_size_supplied = 1;
+	char *chunk_err;
 
 	/*
 	 * Use default chunk size (or hardsect_size, if larger) if none supplied
@@ -326,20 +327,23 @@ static int read_header(struct pstore *ps
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
 
-	if (!chunk_size_supplied || ps->store->chunk_size == chunk_size)
+	if (ps->store->chunk_size == chunk_size)
 		return 0;
 
-	DMWARN("chunk size %llu in device metadata overrides "
-	       "table chunk size of %llu.",
-	       (unsigned long long)chunk_size,
-	       (unsigned long long)ps->store->chunk_size);
+	if (chunk_size_supplied)
+		DMWARN("chunk size %llu in device metadata overrides "
+		       "table chunk size of %llu.",
+		       (unsigned long long)chunk_size,
+		       (unsigned long long)ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
 
-	ps->store->chunk_size = chunk_size;
-	ps->store->chunk_mask = chunk_size - 1;
-	ps->store->chunk_shift = ffs(chunk_size) - 1;
+	r = dm_exception_store_set_chunk_size(ps->store, chunk_size, &chunk_err);
+	if (r) {
+		DMERR("invalid on-disk chunk size %llu: %s.", (unsigned long long)chunk_size, chunk_err);
+		return r;
+	}
 
 	r = dm_io_client_resize(sectors_to_pages(ps->store->chunk_size),
 				ps->io_client);
