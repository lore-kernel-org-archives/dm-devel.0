From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin-metadata: set the number of reserved
	buffers
Date: Mon, 15 Aug 2011 13:09:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108151308070.18170@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-thin-metadata: set the number of reserved buffers

Set the number of reserved buffers to 6.

Note: this value was found experimentally (I disabled new buffer 
allocation and tested that dm-thin deadlocks with 5 or less buffers). Joe, 
please so some code analysis and check the value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin-metadata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.0-fast/drivers/md/dm-thin-metadata.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/dm-thin-metadata.c	2011-08-15 16:45:09.000000000 +0200
+++ linux-3.0-fast/drivers/md/dm-thin-metadata.c	2011-08-15 17:04:13.000000000 +0200
@@ -561,7 +561,7 @@ struct dm_pool_metadata *dm_pool_metadat
 	int create;
 
 	bm = dm_block_manager_create(bdev, THIN_METADATA_BLOCK_SIZE,
-				     THIN_METADATA_CACHE_SIZE, 3);
+				     THIN_METADATA_CACHE_SIZE, 6);
 	if (!bm) {
 		DMERR("could not create block manager");
 		return ERR_PTR(-ENOMEM);
