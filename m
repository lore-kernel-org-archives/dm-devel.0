From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 3/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:53:55 +0900 (JST)
Message-ID: <20080422.225355.07850141.taka@valinux.co.jp>
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


Make every bio points the iocontext of the process which originally
generated an I/O request. (part 2)

 - Assign the iocontext which the source bio has to a bio when it is
   allocated as a bounce buffer.
 - Assign the iocontext which the source bio has to bios when the source
   bio is split into several ones, which some device mapper modules require.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/mm/bounce.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/mm/bounce.c	2008-04-22 15:51:33.000000000 +0900
@@ -195,8 +195,11 @@ static void __blk_queue_bounce(struct re
 		/*
 		 * irk, bounce it
 		 */
-		if (!bio)
+		if (!bio) {
 			bio = bio_alloc(GFP_NOIO, (*bio_orig)->bi_vcnt);
+			put_io_context(bio->bi_io_context);
+			bio->bi_io_context = ioc_object_link((*bio_orig)->bi_io_context);
+		}
 
 		to = bio->bi_io_vec + i;
 
--- linux-2.6.25.bio0/drivers/md/dm.c	2008-04-22 15:48:33.000000000 +0900
+++ linux-2.6.25/drivers/md/dm.c	2008-04-22 17:16:49.000000000 +0900
@@ -665,6 +665,7 @@ static struct bio *split_bvec(struct bio
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_io_context = ioc_object_link(bio->bi_io_context);
 
 	return clone;
 }
