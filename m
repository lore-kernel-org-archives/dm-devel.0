From: Anders Henke <anders.henke@1und1.de>
Subject: Re: [dm-devel] Re: device mapper not reporting no-barrier-support?
Date: Thu, 28 Feb 2008 13:05:38 +0100
Message-ID: <20080228120538.GG13026@1und1.de>
References: <20080225132615.GA21990@1und1.de> <20080225152050.94788622.akpm@linux-foundation.org> <20080226013656.GE1788@agk.fab.redhat.com> <20080226161741.GN6704@kernel.dk> <20080226193349.GQ13026@1und1.de> <20080226194122.GQ6704@kernel.dk> <20080226202030.GR13026@1und1.de> <20080226222556.GU6704@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GyRA7555PLgSTuth"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759675AbYB1MF6@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080226222556.GU6704@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Feb 26 2008, Jens Axboe wrote:
> > [  234.946192] drbd0: conn( WFSyncUUID -> SyncTarget ) 
> > [  234.956176] drbd0: Began resync as SyncTarget (will sync 19542404 KB
> > [4885601
> >  bits set]).
> > [  234.972567] drbd0: Writing meta data super block now.
> > [  235.018203] drbd0: local disk flush failed with status -95
> > 
> > DRBD sees the EOPNOTSUPP, logs this message only once and doesn't try
> > any further barrier requests (as intended).
> 
> OK good, that's what I expected :-)
> 
> I'll queue the patch for 2.6.25, the 2.6.24 should go to stable. Send me
> a properly formatted patch and I'll make sure it goes that way.
> 
> Thanks for testing!

'diff -up''d patch is attached.

Anders
-- 
1&1 Internet AG            System Design
Brauerstrasse 48           v://49.721.91374.50
D-76135 Karlsruhe          f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Markus Huhn, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren

--GyRA7555PLgSTuth
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ll_rw_blk-eopnotsup-2.6.24.2.patch"

--- linux-2.6.24.2-vanilla/block/ll_rw_blk.c	2008-02-11 06:51:11.000000000 +0100
+++ linux-2.6.24.2/block/ll_rw_blk.c	2008-02-28 10:38:22.392987649 +0100
@@ -2667,8 +2667,11 @@ EXPORT_SYMBOL(blk_execute_rq);
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
 {
-	if (err)
+	if (err) {
+		if (err == -EOPNOTSUPP)
+			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	}
 
 	complete(bio->bi_private);
 }
@@ -2717,7 +2720,9 @@ int blkdev_issue_flush(struct block_devi
 		*error_sector = bio->bi_sector;
 
 	ret = 0;
-	if (!bio_flagged(bio, BIO_UPTODATE))
+	if (bio_flagged(bio, BIO_EOPNOTSUPP))
+		ret = -EOPNOTSUPP;
+	else if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
 	bio_put(bio);

--GyRA7555PLgSTuth--
