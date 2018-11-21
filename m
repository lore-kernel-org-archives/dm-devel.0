From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V11 15/19] block: enable multipage bvecs
Date: Wed, 21 Nov 2018 23:48:13 +0800
Message-ID: <20181121154812.GD19111@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
	<20181121032327.8434-16-ming.lei@redhat.com>
	<20181121145502.GA3241@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181121145502.GA3241@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org, dm-devel@redhat.com, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, "Darrick J . Wong" <darrick.wong@oracle.com>, cluster-devel@redhat.com, linux-ext4@vger.kernel.org, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Boaz Harrosh <ooo@electrozaur.com>, Gao Xiang <gaoxiang25@huawei.com>, Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 21, 2018 at 03:55:02PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 21, 2018 at 11:23:23AM +0800, Ming Lei wrote:
> >  	if (bio->bi_vcnt > 0) {
> > -		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> > +		struct bio_vec bv;
> > +		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
> >  
> > -		if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
> > -			bv->bv_len += len;
> > +		bvec_last_segment(seg, &bv);
> > +
> > +		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
> 
> I think this we can simplify the try to merge into bio case a bit,
> and also document it better with something like this:
> 
> diff --git a/block/bio.c b/block/bio.c
> index 854676edc438..cc913281a723 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -822,54 +822,40 @@ EXPORT_SYMBOL(bio_add_pc_page);
>   * @page: page to add
>   * @len: length of the data to add
>   * @off: offset of the data in @page
> + * @same_page: if %true only merge if the new data is in the same physical
> + *		page as the last segment of the bio.
>   *
> - * Try to add the data at @page + @off to the last page of @bio.  This is a
> + * Try to add the data at @page + @off to the last bvec of @bio.  This is a
>   * a useful optimisation for file systems with a block size smaller than the
>   * page size.
>   *
>   * Return %true on success or %false on failure.
>   */
>  bool __bio_try_merge_page(struct bio *bio, struct page *page,
> -		unsigned int len, unsigned int off)
> +		unsigned int len, unsigned int off, bool same_page)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return false;
>  
>  	if (bio->bi_vcnt > 0) {
> -		struct bio_vec bv;
> -		struct bio_vec *seg = &bio->bi_io_vec[bio->bi_vcnt - 1];
> -
> -		bvec_last_segment(seg, &bv);
> -
> -		if (page == bv.bv_page && off == bv.bv_offset + bv.bv_len) {
> -			seg->bv_len += len;
> -			bio->bi_iter.bi_size += len;
> -			return true;
> -		}
> +		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> +		phys_addr_t vec_addr = page_to_phys(bv->bv_page);
> +		phys_addr_t page_addr = page_to_phys(page);
> +
> +		if (vec_addr + bv->bv_offset + bv->bv_len != page_addr + off)
> +			return false;
> +		if (same_page &&
> +		    (vec_addr & PAGE_SIZE) != (page_addr & PAGE_SIZE))
> +			return false;

I guess the correct check should be:

		end_addr = vec_addr + bv->bv_offset + bv->bv_len;
		if (same_page &&
		    (end_addr & PAGE_MASK) != (page_addr & PAGE_MASK))
			return false;

And this approach is good, will take it in V12.

Thanks,
Ming
