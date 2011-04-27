From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] dm-thinp: report correct optimal I/O size
Date: Wed, 27 Apr 2011 09:41:50 -0400
Message-ID: <20110427134150.GA15413@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: ejt@redhat.com
List-Id: dm-devel.ids

tc->block_shift is the shift to get from a sector to the block_size,
and it doesn't make any sense to apply that to the block size.
Without this I get overflows of the optimal I/O size queue limit
when using large block sizes in dm-thinp.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/dm-thin-prov.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin-prov.c	2011-04-27 15:30:22.798345522 +0200
+++ linux-2.6/drivers/md/dm-thin-prov.c	2011-04-27 15:30:49.084869781 +0200
@@ -641,7 +641,7 @@ thinp_io_hints(struct dm_target *ti, str
 	struct thinp_c *tc = ti->private;
 
 	blk_limits_io_min(limits, 0);
-	blk_limits_io_opt(limits, tc->block_size << tc->block_shift);
+	blk_limits_io_opt(limits, tc->block_size);
 }
 
 static int thinp_iterate_devices(struct dm_target *ti,
