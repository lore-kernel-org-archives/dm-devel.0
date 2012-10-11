From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: linux-next oops
Date: Thu, 11 Oct 2012 09:52:24 -0400
Message-ID: <20121011135224.8E34380225@viridian.itc.virginia.edu>
References: <Pine.LNX.4.64.1210102108250.13693@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210102108250.13693@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas Patocka writes:
>
> Try this. In my original patch that I sent, I removed bio_alloc_bioset and 
> left __bio_clone. But meanwhile, Kent Overstreet sent another patch that 
> replaces both bio_alloc_bioset and __bio_clone with bio_clone_bioset. The 
> reason for this crash is incorrect resolution of this conflict - 
> bio_clone_bioset was removed (although my patch removed only 
> bio_alloc_bioset) and __bio_clone was not added back.
> 
> Mikulas
> 
> ---
>  drivers/md/dm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-next-copy/drivers/md/dm.c
> ===================================================================
> --- linux-next-copy.orig/drivers/md/dm.c	2012-10-11 02:55:34.000000000 +0200
> +++ linux-next-copy/drivers/md/dm.c	2012-10-11 02:55:58.000000000 +0200
> @@ -1160,7 +1160,7 @@ static void __issue_target_request(struc
>  	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
>  	 * and discard, so no need for concern about wasted bvec allocations.
>  	 */
> -
> +	__bio_clone(clone, ci->bio);
>  	if (len) {
>  		clone->bi_sector = ci->sector;
>  		clone->bi_size = to_bytes(len);
> 


Yes, this fixes the crashes for me.

-- 
Bill
