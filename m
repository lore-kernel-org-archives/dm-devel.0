From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: linux-next oops
Date: Wed, 10 Oct 2012 21:12:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210102108250.13693@file.rdu.redhat.com>
References: <20121010032726.35920801A1@viridian.itc.virginia.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121010032726.35920801A1@viridian.itc.virginia.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 9 Oct 2012, Bill Pemberton wrote:

> > I pulled linux-next, set up multipath and executed fsync() on it, and 
> > there was no crash for me.
> > 
> 
> Ok, I've got two machines that won't boot with it.... it doesn't get
> far enough to run anything.
> 
> -- 
> Bill

Try this. In my original patch that I sent, I removed bio_alloc_bioset and 
left __bio_clone. But meanwhile, Kent Overstreet sent another patch that 
replaces both bio_alloc_bioset and __bio_clone with bio_clone_bioset. The 
reason for this crash is incorrect resolution of this conflict - 
bio_clone_bioset was removed (although my patch removed only 
bio_alloc_bioset) and __bio_clone was not added back.

Mikulas

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next-copy/drivers/md/dm.c
===================================================================
--- linux-next-copy.orig/drivers/md/dm.c	2012-10-11 02:55:34.000000000 +0200
+++ linux-next-copy/drivers/md/dm.c	2012-10-11 02:55:58.000000000 +0200
@@ -1160,7 +1160,7 @@ static void __issue_target_request(struc
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-
+	__bio_clone(clone, ci->bio);
 	if (len) {
 		clone->bi_sector = ci->sector;
 		clone->bi_size = to_bytes(len);
