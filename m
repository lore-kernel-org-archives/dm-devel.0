From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 5/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:55:15 +0900 (JST)
Message-ID: <20080422.225515.128486479.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


The raid1 module makes use of temporary bios to sync physical disks
under the same md device. Make the bios point the iocontext of one of
the kernel threads in the module.

Meanwhile, regular read/write I/O requests will be cloned and may be
handled by one of the kernel threads in the modules. In this case,
the iocontext will be inherited from the source bio.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/raid/raid1.h	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/include/linux/raid/raid1.h	2008-04-22 15:52:38.000000000 +0900
@@ -100,6 +100,7 @@ struct r1bio_s {
 
 	struct list_head	retry_list;
 	struct bitmap_update	*bitmap_update;
+	struct io_context	*io_context;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
--- linux-2.6.25.bio0/drivers/md/raid1.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/md/raid1.c	2008-04-22 17:18:08.000000000 +0900
@@ -200,6 +200,8 @@ static void put_buf(r1bio_t *r1_bio)
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
 	}
+	put_io_context(r1_bio->io_context);
+	r1_bio->io_context = NULL;
 
 	mempool_free(r1_bio, conf->r1buf_pool);
 
@@ -1731,6 +1733,7 @@ static sector_t sync_request(mddev_t *md
 	r1_bio->sector = sector_nr;
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
+	r1_bio->io_context = ioc_object_link(current->io_context);
 
 	for (i=0; i < conf->raid_disks; i++) {
 		mdk_rdev_t *rdev;
@@ -1747,6 +1750,7 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_size = 0;
 		bio->bi_end_io = NULL;
 		bio->bi_private = NULL;
+		bio->bi_io_context = r1_bio->io_context;
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
--- linux-2.6.25.bio0/drivers/md/md.c	2008-04-22 15:48:33.000000000 +0900
+++ linux-2.6.25/drivers/md/md.c	2008-04-22 15:52:38.000000000 +0900
@@ -5451,6 +5451,8 @@ void md_do_sync(mddev_t *mddev)
 	else
 		desc = "recovery";
 
+	current->io_context = alloc_io_context(GFP_KERNEL, -1); /*XXX*/
+
 	/* we overload curr_resync somewhat here.
 	 * 0 == not engaged in resync at all
 	 * 2 == checking that there is no conflict with another sync
