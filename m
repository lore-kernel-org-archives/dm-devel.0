From: Dave Olien <dmo@osdl.org>
Subject: Re: dev kernels(bio change),
	evms_activate still produces oops
Date: Wed, 9 Feb 2005 15:10:44 -0800
Message-ID: <20050209231044.GA959@osdl.org>
References: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: syrius.ml@no-log.org
Cc: evms-devel@lists.sourceforge.net, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


Sorry for being so slow.  Here's a patch that I believe will fix this oops.
Please give this a try and let me know.  The problem is that when I
coded up the new bio_clone() code, I made the bad assumption that the
bio passed in would have been allocated from a bio_set.  In the case
of raid5 and raid6, this isn't the case.  So, when raid5 passes one
of its bio's into the dm code, and dm tries to bio_clone() it,
bio_clone() dereferences a NULL pointer.

As a quick fix, this patch changes bio_clone() to just use the global
bio_set to allocate the new bio.  Problem is, this potentially sets
up another bio exhaustion case.  I'm thinking there should maybe
be a bio_clone_bioset() that accepts a bio_set pointer as an argument.
That way, dm could for example pass in it's own bio_set to allocate
from.

But for now, here's the quick patch.  Please give it a try and give
me the results.


diff -ur linux-2.6.11-rc3-bk4-udm1/fs/bio.c linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c
--- linux-2.6.11-rc3-bk4-udm1/fs/bio.c	2005-02-08 15:36:16.000000000 -0800
+++ linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c	2005-02-09 14:56:39.000000000 -0800
@@ -258,7 +258,7 @@
  */
 struct bio *bio_clone(struct bio *bio, int gfp_mask)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bio->bi_set);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
 
 	if (b)
 		__bio_clone(b, bio);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
