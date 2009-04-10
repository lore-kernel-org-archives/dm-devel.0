From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/11] bottom-layer barrier support
Date: Fri, 10 Apr 2009 01:15:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904100114490.1117@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904100107160.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110010.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100110370.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100111110.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112060.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100112330.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100113050.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100113280.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100113550.1117@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904100114170.1117@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904100114170.1117@hs20-bc2-1.build.redhat.com>
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

Flush support for dm-crypt target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-crypt.c	2009-04-10 06:28:45.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-crypt.c	2009-04-10 06:33:42.000000000 +0200
@@ -1168,6 +1168,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad_crypt_queue;
 	}
 
+	ti->num_flush_requests = 1;
 	ti->private = cc;
 	return 0;
 
@@ -1226,6 +1227,12 @@ static int crypt_map(struct dm_target *t
 {
 	struct dm_crypt_io *io;
 
+	if (unlikely(bio_empty_barrier(bio))) {
+		struct crypt_config *cc = ti->private;
+		bio->bi_bdev = cc->dev->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
 	io = crypt_io_alloc(ti, bio, bio->bi_sector - ti->begin);
 
 	if (bio_data_dir(io->base_bio) == READ)
