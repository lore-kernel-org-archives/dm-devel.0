From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 04/20] block: don't use bio->bi_vcnt to figure out
 segment number
Date: Mon, 26 Nov 2018 14:14:47 -0800
Message-ID: <20181126221447.GE30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-5-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Mon, Nov 26, 2018 at 10:17:04AM +0800, Ming Lei wrote:
> It is wrong to use bio->bi_vcnt to figure out how many segments
> there are in the bio even though CLONED flag isn't set on this bio,
> because this bio may be splitted or advanced.
> 
> So always use bio_segments() in blk_recount_segments(), and it shouldn't
> cause any performance loss now because the physical segment number is figured
> out in blk_queue_split() and BIO_SEG_VALID is set meantime since
> bdced438acd83ad83a6c ("block: setup bi_phys_segments after splitting").
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Fixes: 76d8137a3113 ("blk-merge: recaculate segment if it isn't less than max segments")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index e69d8f8ba819..51ec6ca56a0a 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -367,13 +367,7 @@ void blk_recalc_rq_segments(struct request *rq)
>  
>  void blk_recount_segments(struct request_queue *q, struct bio *bio)
>  {
> -	unsigned short seg_cnt;
> -
> -	/* estimate segment number by bi_vcnt for non-cloned bio */
> -	if (bio_flagged(bio, BIO_CLONED))
> -		seg_cnt = bio_segments(bio);
> -	else
> -		seg_cnt = bio->bi_vcnt;
> +	unsigned short seg_cnt = bio_segments(bio);
>  
>  	if (test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags) &&
>  			(seg_cnt < queue_max_segments(q)))
> -- 
> 2.9.5
> 
