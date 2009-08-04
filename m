From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] Refactor set_chunk_size.
Date: Mon, 3 Aug 2009 21:44:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908032143200.6002@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032138450.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032139440.6002@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908032139440.6002@hs20-bc2-1.build.redhat.com>
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

Break the function set_chunk_size to two functions.

It doesn't change functionality, just makes the following patch simpler
and avoids code duplication.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.c |    7 +++++++
 drivers/md/dm-exception-store.h |    4 ++++
 2 files changed, 11 insertions(+)

Index: linux-2.6.31-rc5-devel/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.31-rc5-devel.orig/drivers/md/dm-exception-store.c	2009-08-04 03:00:55.000000000 +0200
+++ linux-2.6.31-rc5-devel/drivers/md/dm-exception-store.c	2009-08-04 03:01:32.000000000 +0200
@@ -171,6 +171,13 @@ static int set_chunk_size(struct dm_exce
 	 */
 	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
 
+	return dm_exception_store_set_chunk_size(store, chunk_size_ulong, error);
+}
+
+int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
+				      unsigned long chunk_size_ulong,
+				      char **error)
+{
 	/* Check chunk_size is a power of 2 */
 	if (!is_power_of_2(chunk_size_ulong)) {
 		*error = "Chunk size is not a power of 2";
Index: linux-2.6.31-rc5-devel/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.31-rc5-devel.orig/drivers/md/dm-exception-store.h	2009-08-04 03:00:55.000000000 +0200
+++ linux-2.6.31-rc5-devel/drivers/md/dm-exception-store.h	2009-08-04 03:01:32.000000000 +0200
@@ -168,6 +168,10 @@ static inline chunk_t sector_to_chunk(st
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
+int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
+				      unsigned long chunk_size_ulong,
+				      char **error);
+
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 			      unsigned *args_used,
 			      struct dm_exception_store **store);
