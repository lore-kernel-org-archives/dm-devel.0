From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 2/6] bcache: don't clone bio in
	bch_data_verify
Date: Tue, 19 Jun 2018 15:41:43 +0800
Message-ID: <16f9edb8-1884-ef00-b913-f88db1b80695@suse.de>
References: <20180619045216.21130-1-hch@lst.de>
	<20180619045216.21130-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180619045216.21130-3-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 2018/6/19 12:52 PM, Christoph Hellwig wrote:
> We immediately overwrite the biovec array, so instead just allocate
> a new bio and copy over the disk, setor and size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks good to me.  Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/debug.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index d030ce3025a6..04d146711950 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -110,11 +110,15 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>  	struct bio_vec bv, cbv;
>  	struct bvec_iter iter, citer = { 0 };
>  
> -	check = bio_clone_kmalloc(bio, GFP_NOIO);
> +	check = bio_kmalloc(GFP_NOIO, bio_segments(bio));
>  	if (!check)
>  		return;
> +	check->bi_disk = bio->bi_disk;
>  	check->bi_opf = REQ_OP_READ;
> +	check->bi_iter.bi_sector = bio->bi_iter.bi_sector;
> +	check->bi_iter.bi_size = bio->bi_iter.bi_size;
>  
> +	bch_bio_map(check, NULL);
>  	if (bch_bio_alloc_pages(check, GFP_NOIO))
>  		goto out_put;
>  
> 
