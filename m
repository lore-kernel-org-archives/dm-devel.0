From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/7] dm: remove no needed spaces in
 clone_endio()/__map_bio()
Date: Tue, 10 Oct 2006 17:29:03 -0400 (EDT)
Message-ID: <20061010.172903.115902919.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

This patch removes no needed spaces of clone_endio() and __map_bio().
Should have no effect on the behavior.


Test results:
Done build test without errors.


The patch is for:
    2.6.18-mm2

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.18-mm3/drivers/md/dm.c 1-remove-space/drivers/md/dm.c
--- 2.6.18-mm3/drivers/md/dm.c	2006-10-05 10:23:59.000000000 -0400
+++ 1-remove-space/drivers/md/dm.c	2006-10-05 10:25:49.000000000 -0400
@@ -482,7 +482,6 @@ static int clone_endio(struct bio *bio, 
 		r = endio(tio->ti, bio, error, &tio->info);
 		if (r < 0)
 			error = r;
-
 		else if (r > 0)
 			/* the target wants another shot at the io */
 			return 1;
@@ -551,9 +550,7 @@ static void __map_bio(struct dm_target *
 				    clone->bi_sector);
 
 		generic_make_request(clone);
-	}
-
-	else if (r < 0) {
+	} else if (r < 0) {
 		/* error the io and bail out */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
