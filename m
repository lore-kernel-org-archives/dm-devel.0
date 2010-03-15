From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] Test chunk size against both origin and
 snapshot sector size
Date: Mon, 15 Mar 2010 02:04:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003150201270.12526@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Test chunk size against both origin and snapshot sector size

Don't allow chunk size smaller than either origin or snapshot logical
sector size. Reading or writing data unaligned to sector size is not allowed
and causes immediate errors.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.34-rc1-devel.orig/drivers/md/dm-exception-store.c	2010-03-12 14:38:31.000000000 +0100
+++ linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.c	2010-03-12 14:39:56.000000000 +0100
@@ -173,7 +173,9 @@ int dm_exception_store_set_chunk_size(st
 
 	/* Validate the chunk size against the device block size */
 	if (chunk_size %
-	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9)) {
+	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9) ||
+	    chunk_size %
+	    (bdev_logical_block_size(dm_snap_origin(store->snap)->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
