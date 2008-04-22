From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 9/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:59:07 +0900 (JST)
Message-ID: <20080422.225907.116124009.taka@valinux.co.jp>
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


The packet writing module creates a bio in its own way, so its iocontext
should be set here.

This code hasn't been tested yet.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/drivers/block/pktcdvd.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/block/pktcdvd.c	2008-04-22 15:53:41.000000000 +0900
@@ -514,6 +514,7 @@ static void pkt_bio_finished(struct pktc
 
 static void pkt_bio_destructor(struct bio *bio)
 {
+	put_io_context(bio->bi_io_context);
 	kfree(bio->bi_io_vec);
 	kfree(bio);
 }
@@ -522,6 +523,11 @@ static struct bio *pkt_bio_alloc(int nr_
 {
 	struct bio_vec *bvl = NULL;
 	struct bio *bio;
+	struct io_context *ioc;
+
+	ioc = get_io_context(GFP_KERNEL, -1);
+	if (!ioc)
+		goto no_ioc;
 
 	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
 	if (!bio)
@@ -535,12 +541,15 @@ static struct bio *pkt_bio_alloc(int nr_
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bvl;
 	bio->bi_destructor = pkt_bio_destructor;
+	bio->bi_io_context = ioc;
 
 	return bio;
 
  no_bvl:
 	kfree(bio);
  no_bio:
+	put_io_context(ioc);
+ no_ioc:
 	return NULL;
 }
 
