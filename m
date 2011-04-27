From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thinp: fix REQ_FLUSH semantics
Date: Wed, 27 Apr 2011 11:09:16 +0100
Message-ID: <1303898956.4679.58.camel@ubuntu>
References: <20110427100246.GA22521@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110427100246.GA22521@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, 2011-04-27 at 06:02 -0400, Christoph Hellwig wrote:
> REQ_FLUSH means the metadata needs to be flushed before the data payload
> (if there is one), not after it.  And yes, this means the typical
> REQ_FUA|REQ_FLUSH requests imply two flushes.

Not sure what you're getting at here.  The bio wasn't issued until after
the commit.

			if ((bio->bi_rw & (REQ_FUA | REQ_FLUSH))) {
				r = commit(tc);
				if (r < 0) {
					bio_io_error(bio);
					continue;
				}
			}

			remap_bio(tc, bio, pool_block);
			generic_make_request(bio);

- Joe


> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/md/dm-thin-prov.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-thin-prov.c	2011-04-27 11:45:50.957995412 +0200
> +++ linux-2.6/drivers/md/dm-thin-prov.c	2011-04-27 11:45:56.954629592 +0200
> @@ -229,6 +229,14 @@ static void do_bios(struct thinp_c *tc,
>  	block_t thinp_block, pool_block;
>  
>  	while ((bio = bio_list_pop(bios))) {
> +		if (bio->bi_rw & REQ_FLUSH) {
> +			r = commit(tc);
> +			if (r < 0) {
> +				bio_io_error(bio);
> +				continue;
> +			}
> +		}
> +
>  		thinp_block = _sector_to_block(tc, bio->bi_sector);
>  		r = thinp_metadata_lookup(tc->tpm, thinp_block, 1, &pool_block);
>  		if (r == -ENODATA) {
> @@ -258,7 +266,7 @@ static void do_bios(struct thinp_c *tc,
>  			 * whether the overhead of tracking pending blocks
>  			 * is worth it though.
>  			 */
> -			if ((bio->bi_rw & (REQ_FUA | REQ_FLUSH))) {
> +			if (bio->bi_rw & REQ_FUA) {
>  				r = commit(tc);
>  				if (r < 0) {
>  					bio_io_error(bio);
