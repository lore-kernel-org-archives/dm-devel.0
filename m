From: Dave Olien <dmo@osdl.org>
Subject: Re: [PATCH] Fix panic in 2.6 with bounced bio and dm
Date: Mon, 28 Feb 2005 09:35:42 -0800
Message-ID: <20050228173542.GA16815@osdl.org>
References: <1109351021.5014.10.camel@markh1.pdx.osdl.net>
	<20050225161947.5fd6d343.akpm@osdl.org>
	<Pine.LNX.4.58.0502251640050.9237@ppc970.osdl.org>
	<20050226123934.GA1254@suse.de>
	<1109604737.30227.3.camel@markh1.pdx.osdl.net>
	<20050228155127.GI8868@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050228155127.GI8868@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids


Just trivial, I think you're missing the final "0" argument
in the __bio_for_each_segment().

On Mon, Feb 28, 2005 at 04:51:28PM +0100, Jens Axboe wrote:
> This should fix it.
> 
> Signed-off-by: Jens Axboe <axboe@suse.de>
> 
> 
> ===== mm/highmem.c 1.55 vs edited =====
> --- 1.55/mm/highmem.c	2005-01-08 06:44:13 +01:00
> +++ edited/mm/highmem.c	2005-02-28 16:50:59 +01:00
> @@ -425,7 +425,7 @@
>  	 * at least one page was bounced, fill in possible non-highmem
>  	 * pages
>  	 */
> -	bio_for_each_segment(from, *bio_orig, i) {
> +	__bio_for_each_segment(from, *bio_orig, i) {
>  		to = bio_iovec_idx(bio, i);
>  		if (!to->bv_page) {
>  			to->bv_page = from->bv_page;
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
