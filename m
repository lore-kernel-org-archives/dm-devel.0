From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] updated dm-snapshot-check-on-disk-chunksize.patch
Date: Thu, 27 Aug 2009 17:41:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908271739380.31653@hs20-bc2-1.build.redhat.com>
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

This is updated patch to check also for too big chunksize. Hopefully, no 
one will ever be casting it to something smaller than int.

See the change in dm-exception-store.c.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.c |    5 +++++
 drivers/md/dm-snap-persistent.c |   20 ++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6.31-rc7-fast/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.31-rc7-fast.orig/drivers/md/dm-snap-persistent.c	2009-08-23 20:52:04.000000000 +0200
+++ linux-2.6.31-rc7-fast/drivers/md/dm-snap-persistent.c	2009-08-23 20:52:06.000000000 +0200
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
Index: linux-2.6.31-rc7-fast/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.31-rc7-fast.orig/drivers/md/dm-exception-store.c	2009-08-27 23:33:55.000000000 +0200
+++ linux-2.6.31-rc7-fast/drivers/md/dm-exception-store.c	2009-08-27 23:37:39.000000000 +0200
@@ -190,6 +190,11 @@ int dm_exception_store_set_chunk_size(st
 		return -EINVAL;
 	}
 
+	if (chunk_size_ulong > INT_MAX >> SECTOR_SHIFT) {
+		*error = "Chunk size is too high";
+		return -EINVAL;
+	}
+
 	store->chunk_size = chunk_size_ulong;
 	store->chunk_mask = chunk_size_ulong - 1;
 	store->chunk_shift = ffs(chunk_size_ulong) - 1;
