From: Dave Olien <dmo@osdl.org>
Subject: Re: Re: [dm-devel] dev kernels(bio change), evms_activate still produces oops
Date: Fri, 11 Feb 2005 13:14:33 -0800
Message-ID: <20050211131433.A24845@osdl.org>
References: <87sm48dnh2.87r7jsdnh2@87pszcdnh2.message.id> <20050209231044.GA959@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050209231044.GA959@osdl.org>; from dmo@osdl.org on Wed, Feb 09, 2005 at 03:10:44PM -0800
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



I've found two problems with bio_clone().  One a consequencey
of my patch to bio.c, and the other from Jen's patch to bio.c
Just the 2.6.11-rc3-bk4 will Oops, without my bio patch.

I'm working on two patches.  I'll have them in the mail
by the end of today.

On Wed, Feb 09, 2005 at 03:10:44PM -0800, Dave Olien wrote:
> 
> Sorry for being so slow.  Here's a patch that I believe will fix this oops.
> Please give this a try and let me know.  The problem is that when I
> coded up the new bio_clone() code, I made the bad assumption that the
> bio passed in would have been allocated from a bio_set.  In the case
> of raid5 and raid6, this isn't the case.  So, when raid5 passes one
> of its bio's into the dm code, and dm tries to bio_clone() it,
> bio_clone() dereferences a NULL pointer.
> 
> As a quick fix, this patch changes bio_clone() to just use the global
> bio_set to allocate the new bio.  Problem is, this potentially sets
> up another bio exhaustion case.  I'm thinking there should maybe
> be a bio_clone_bioset() that accepts a bio_set pointer as an argument.
> That way, dm could for example pass in it's own bio_set to allocate
> from.
> 
> But for now, here's the quick patch.  Please give it a try and give
> me the results.
> 
> 
> diff -ur linux-2.6.11-rc3-bk4-udm1/fs/bio.c linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c
> --- linux-2.6.11-rc3-bk4-udm1/fs/bio.c	2005-02-08 15:36:16.000000000 -0800
> +++ linux-2.6.11-rc3-bk4-udm1-patch/fs/bio.c	2005-02-09 14:56:39.000000000 -0800
> @@ -258,7 +258,7 @@
>   */
>  struct bio *bio_clone(struct bio *bio, int gfp_mask)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bio->bi_set);
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
>  
>  	if (b)
>  		__bio_clone(b, bio);
> 
> 
> 
> -------------------------------------------------------
> SF email is sponsored by - The IT Product Guide
> Read honest & candid reviews on hundreds of IT Products from real users.
> Discover which products truly live up to the hype. Start reading now.
> http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
> _______________________________________________
> Evms-devel mailing list
> Evms-devel@lists.sourceforge.net
> To subscribe/unsubscribe, please visit:
> https://lists.sourceforge.net/lists/listinfo/evms-devel


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
