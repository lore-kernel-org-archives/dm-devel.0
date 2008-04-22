From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 8/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:58:23 +0900 (JST)
Message-ID: <20080422.225823.95333470.taka@valinux.co.jp>
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


The crypt module will duplicate a given bio in its own way, so the newly
allocated bio should inherit the the io_context from the original one.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/drivers/md/dm-crypt.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/md/dm-crypt.c	2008-04-22 15:53:28.000000000 +0900
@@ -581,6 +581,7 @@ static void clone_init(struct dm_crypt_i
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_io_context = ioc_object_link(io->base_bio->bi_io_context);
 	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
