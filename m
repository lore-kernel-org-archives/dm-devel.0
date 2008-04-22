From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 10/10] I/O context inheritance
Date: Tue, 22 Apr 2008 23:00:17 +0900 (JST)
Message-ID: <20080422.230017.69986283.taka@valinux.co.jp>
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


The floppy driver will allocate a bio on its stack, so its iocontext
should be set here.

This code hasn't been tested yet.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/drivers/block/floppy.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/block/floppy.c	2008-04-22 21:33:40.000000000 +0900
@@ -3845,12 +3845,14 @@ static int __floppy_read_block_0(struct 
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;
+	bio.bi_io_context = get_io_context(GFP_NOIO, -1);
 
 	submit_bio(READ, &bio);
 	generic_unplug_device(bdev_get_queue(bdev));
 	process_fd_request();
 	wait_for_completion(&complete);
 
+	put_io_context(bio.bi_io_context);
 	__free_page(page);
 
 	return 0;
