From: Dave Olien <dmo@osdl.org>
Subject: Re: Re: [dm-devel] dev kernels(bio change), evms_activate still produces oops
Date: Wed, 16 Feb 2005 14:56:01 -0800
Message-ID: <20050216225601.GA5806@osdl.org>
References: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id> <20050209231044.GA959@osdl.org> <20050211131433.A24845@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <evms-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20050211131433.A24845@osdl.org>
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: syrius.ml@no-log.org
Cc: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


I apologize again for being slow about this. Below are the two
patches I developed. The first one is in 2.6.11-rc4.  The other
one should appear in the Andrew's mm tree for rc4.

They both apply to linux-2.6.11-rc3-udm2, with some offsets.

The problems both appear because of the way raid5 and raid6 created
its bio's that it then passed into bio_clone().

On Fri, Feb 11, 2005 at 01:14:33PM -0800, Dave Olien wrote:
> 
> 
> I've found two problems with bio_clone().  One a consequencey
> of my patch to bio.c, and the other from Jen's patch to bio.c
> Just the 2.6.11-rc3-bk4 will Oops, without my bio patch.
> 
> I'm working on two patches.  I'll have them in the mail
> by the end of today.
> 

------------------ patch 1 ----------------------------------------------------

diff -ur linux-2.6.11-rc3-mm2-orig/fs/bio.c linux-2.6.11-rc3-mm2-patch/fs/bio.c
--- linux-2.6.11-rc3-mm2-orig/fs/bio.c	2005-02-11 20:37:59.000000000 -0800
+++ linux-2.6.11-rc3-mm2-patch/fs/bio.c	2005-02-11 20:41:30.000000000 -0800
@@ -273,7 +273,7 @@
  */
 struct bio *bio_clone(struct bio *bio, int gfp_mask)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bio->bi_set);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
 
 	if (b)
 		__bio_clone(b, bio);


------------------ patch 2 ----------------------------------------------------

This patch applies to the current bk tree, and fixes the raid5 and raid6
prolems in that tree (at least, raid5 and raid6 successfully begin to sync
without an oops).


===== drivers/md/raid5.c 1.110 vs edited =====
--- 1.110/drivers/md/raid5.c	2005-02-08 02:35:58 -08:00
+++ edited/drivers/md/raid5.c	2005-02-11 20:23:56 -08:00
@@ -458,6 +458,7 @@ static void raid5_build_block (struct st
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
 	dev->req.bi_vcnt++;
+	dev->req.bi_max_vecs++;
 	dev->vec.bv_page = dev->page;
 	dev->vec.bv_len = STRIPE_SIZE;
 	dev->vec.bv_offset = 0;
@@ -1288,6 +1289,7 @@ static void handle_stripe(struct stripe_
 			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_vcnt = 1;	
+			bi->bi_max_vecs = 1;
 			bi->bi_idx = 0;
 			bi->bi_io_vec = &sh->dev[i].vec;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
===== drivers/md/raid6main.c 1.31 vs edited =====
--- 1.31/drivers/md/raid6main.c	2005-02-08 02:35:58 -08:00
+++ edited/drivers/md/raid6main.c	2005-02-11 20:23:56 -08:00
@@ -478,6 +478,7 @@ static void raid6_build_block (struct st
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
 	dev->req.bi_vcnt++;
+	dev->req.bi_max_vecs++;
 	dev->vec.bv_page = dev->page;
 	dev->vec.bv_len = STRIPE_SIZE;
 	dev->vec.bv_offset = 0;
@@ -1447,6 +1448,7 @@ static void handle_stripe(struct stripe_
 			bi->bi_sector = sh->sector + rdev->data_offset;
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_vcnt = 1;
+			bi->bi_max_vecs = 1;
 			bi->bi_idx = 0;
 			bi->bi_io_vec = &sh->dev[i].vec;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;



-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
