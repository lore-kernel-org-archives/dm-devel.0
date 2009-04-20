From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 15/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:02:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200402400.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200402010.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200402010.6097@hs20-bc2-1.build.redhat.com>
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

dm-dmio-eopnotsupp-bits.patch

Add another field, eopnotsupp_bits. It is subset of error_bits, it represents
regions that returned -EOPNOTSUPP error (in this case, the bit is set in both
error_bits and eopnotsupp_bits).

This value will be used in further patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.29-rc1-devel/drivers/md/dm-io.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/drivers/md/dm-io.c	2009-01-22 04:14:13.000000000 +0100
+++ linux-2.6.29-rc1-devel/drivers/md/dm-io.c	2009-01-23 19:04:42.000000000 +0100
@@ -22,6 +22,7 @@ struct dm_io_client {
 /* FIXME: can we shrink this ? */
 struct io {
 	unsigned long error_bits;
+	unsigned long eopnotsupp_bits;
 	atomic_t count;
 	struct task_struct *sleeper;
 	struct dm_io_client *client;
@@ -107,8 +108,11 @@ static inline unsigned bio_get_region(st
  *---------------------------------------------------------------*/
 static void dec_count(struct io *io, unsigned int region, int error)
 {
-	if (error)
+	if (error) {
 		set_bit(region, &io->error_bits);
+		if (error == -EOPNOTSUPP)
+			set_bit(region, &io->eopnotsupp_bits);
+	}
 
 	if (atomic_dec_and_test(&io->count)) {
 		if (io->sleeper)
@@ -361,6 +365,7 @@ static int sync_io(struct dm_io_client *
 	}
 
 	io.error_bits = 0;
+	io.eopnotsupp_bits = 0;
 	atomic_set(&io.count, 1); /* see dispatch_io() */
 	io.sleeper = current;
 	io.client = client;
@@ -397,6 +402,7 @@ static int async_io(struct dm_io_client 
 
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
+	io->eopnotsupp_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
 	io->sleeper = NULL;
 	io->client = client;
