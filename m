From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 6/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:55:56 +0900 (JST)
Message-ID: <20080422.225556.64548415.taka@valinux.co.jp>
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


The raid10 module also makes use of temporary bios to sync physical disks
under the same md device. Make these bios point the iocontext of a kernel
thread in the module.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/raid/raid10.h	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/include/linux/raid/raid10.h	2008-04-22 15:52:58.000000000 +0900
@@ -94,6 +94,7 @@ struct r10bio_s {
 	int			read_slot;
 
 	struct list_head	retry_list;
+	struct io_context	*io_context;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used,
 	 * one for each copy.
--- linux-2.6.25.bio0/drivers/md/raid10.c	2008-04-22 15:48:33.000000000 +0900
+++ linux-2.6.25/drivers/md/raid10.c	2008-04-22 17:19:50.000000000 +0900
@@ -199,6 +199,9 @@ static void put_buf(r10bio_t *r10_bio)
 {
 	conf_t *conf = mddev_to_conf(r10_bio->mddev);
 
+	put_io_context(r10_bio->io_context);
+	r10_bio->io_context = NULL;
+
 	mempool_free(r10_bio, conf->r10buf_pool);
 
 	lower_barrier(conf);
@@ -1761,6 +1764,7 @@ static sector_t sync_request(mddev_t *md
 				r10_bio->mddev = mddev;
 				set_bit(R10BIO_IsRecover, &r10_bio->state);
 				r10_bio->sector = sect;
+				r10_bio->io_context = ioc_object_link(current->io_context);
 
 				raid10_find_phys(conf, r10_bio);
 				/* Need to check if this section will still be
@@ -1793,6 +1797,7 @@ static sector_t sync_request(mddev_t *md
 						bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 						atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 						atomic_inc(&r10_bio->remaining);
+						bio->bi_io_context = r10_bio->io_context;
 						/* and we write to 'i' */
 
 						for (k=0; k<conf->copies; k++)
@@ -1808,6 +1813,7 @@ static sector_t sync_request(mddev_t *md
 						bio->bi_sector = r10_bio->devs[k].addr +
 							conf->mirrors[i].rdev->data_offset;
 						bio->bi_bdev = conf->mirrors[i].rdev->bdev;
+						bio->bi_io_context = r10_bio->io_context;
 
 						r10_bio->devs[0].devnum = d;
 						r10_bio->devs[1].devnum = i;
@@ -1861,6 +1867,7 @@ static sector_t sync_request(mddev_t *md
 		set_bit(R10BIO_IsSync, &r10_bio->state);
 		raid10_find_phys(conf, r10_bio);
 		r10_bio->sectors = (sector_nr | conf->chunk_mask) - sector_nr +1;
+		r10_bio->io_context = ioc_object_link(current->io_context);
 
 		for (i=0; i<conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
@@ -1880,6 +1887,7 @@ static sector_t sync_request(mddev_t *md
 			bio->bi_sector = r10_bio->devs[i].addr +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
+			bio->bi_io_context = r10_bio->io_context;
 			count++;
 		}
 
