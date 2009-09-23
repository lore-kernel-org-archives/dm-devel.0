From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Snapshot: allow chunksize smaller than
	pagesize
Date: Wed, 23 Sep 2009 09:57:58 -0500
Message-ID: <200909231457.n8NEvwDn027102@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snapshot-allow-chunksize-smaller-than-pagesize.patch

Allow chunksize smaller than pagesize.

There is no such restriction that page_size <= chunk_size. Page size
varies between computers (and sometimes varies between different kernels
on the same computer), so it isn't sensible to make the storage format
dependent on the computer.

When reading on-disk structure, the kernel allows pagesize >= chunksize.
There used to be some bugs when creating a snapshot on x86 and moving it
to ppc64 with 64k page size caused crashes, but it was fixed long time
ago.  So there is no need to check the user-supplied chunk_size relative
to page_size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -138,16 +138,6 @@ int dm_exception_store_type_unregister(s
 }
 EXPORT_SYMBOL(dm_exception_store_type_unregister);
 
-/*
- * Round a number up to the nearest 'size' boundary.  size must
- * be a power of 2.
- */
-static ulong round_up(ulong n, ulong size)
-{
-	size--;
-	return (n + size) & ~size;
-}
-
 static int set_chunk_size(struct dm_exception_store *store,
 			  const char *chunk_size_arg, char **error)
 {
@@ -165,12 +155,6 @@ static int set_chunk_size(struct dm_exce
 		return 0;
 	}
 
-	/*
-	 * Chunk size must be multiple of page size.  Silently
-	 * round up if it's not.
-	 */
-	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
-
 	return dm_exception_store_set_chunk_size(store, chunk_size_ulong,
 						 error);
 }
