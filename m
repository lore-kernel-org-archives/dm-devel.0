From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm crypt: wait for possible unfinished endio()
	call in destructor
Date: Thu, 12 Mar 2009 12:51:02 +0100
Message-ID: <49B8F726.8040200@redhat.com>
References: <49AFA565.6030902@ahsoftware.de>
	<49AFBE4A.1010605@redhat.com>	<49B0BFBD.7060208@ahsoftware.de>
	<49B0DDD6.2080608@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B0DDD6.2080608@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

dm crypt: Wait for possible unfinished endio() call in destructor

When user set dm-crypt over loop device and the loop thread processing
bios calls bio_endio later than the dm-crypt mapping is destroyed
(including mempool for dm io request), the endio can cause this OOPs:

(mempool_free from already destroyed mempool).

[   70.381058] EIP is at mempool_free+0x12/0x6b
...
[   70.381058] Process loop0 (pid: 4268, ti=cf3b2000 task=cf1cc1f0 task.ti=cf3b2000)
...
[   70.381058] Call Trace:
[   70.381058]  [<d0d76601>] ? crypt_dec_pending+0x5e/0x62 [dm_crypt]
[   70.381058]  [<d0d767b8>] ? crypt_endio+0xa2/0xaa [dm_crypt]
[   70.381058]  [<d0d76716>] ? crypt_endio+0x0/0xaa [dm_crypt]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<d0806530>] ? dec_pending+0x224/0x23b [dm_mod]
[   70.381058]  [<d08066e4>] ? clone_endio+0x79/0xa4 [dm_mod]
[   70.381058]  [<d080666b>] ? clone_endio+0x0/0xa4 [dm_mod]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<c02bad86>] ? loop_thread+0x380/0x3b7
[   70.381058]  [<c02ba8a1>] ? do_lo_send_aops+0x0/0x165
[   70.381058]  [<c013754f>] ? autoremove_wake_function+0x0/0x33
[   70.381058]  [<c02baa06>] ? loop_thread+0x0/0x3b7

Fix it by adding reference counter into crypt config and wait till
all endio operations finishes.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 35bda49..6cef632 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -18,6 +18,7 @@
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
+#include <linux/delay.h>
 #include <asm/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
@@ -95,6 +96,8 @@ struct crypt_config {
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
 
+	atomic_t pending;
+
 	/*
 	 * crypto related data
 	 */
@@ -566,6 +569,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	}
 
 	mempool_free(io, cc->io_pool);
+	atomic_dec(&cc->pending);
 }
 
 /*
@@ -1113,6 +1117,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_crypt_queue;
 	}
 
+	atomic_set(&cc->pending, 0);
+
 	ti->private = cc;
 	return 0;
 
@@ -1149,6 +1155,9 @@ static void crypt_dtr(struct dm_target *ti)
 	destroy_workqueue(cc->io_queue);
 	destroy_workqueue(cc->crypt_queue);
 
+	while (atomic_read(&cc->pending))
+		msleep(1);
+
 	if (cc->req)
 		mempool_free(cc->req, cc->req_pool);
 
@@ -1171,8 +1180,11 @@ static void crypt_dtr(struct dm_target *ti)
 static int crypt_map(struct dm_target *ti, struct bio *bio,
 		     union map_info *map_context)
 {
+	struct crypt_config *cc = ti->private;
 	struct dm_crypt_io *io;
 
+	atomic_inc(&cc->pending);
+
 	io = crypt_io_alloc(ti, bio, bio->bi_sector - ti->begin);
 
 	if (bio_data_dir(io->base_bio) == READ)
