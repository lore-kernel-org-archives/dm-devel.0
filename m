From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/27] dm: dm-bufio.c: use bio_set_vec_table()
Date: Tue, 5 Apr 2016 06:04:02 -0700
Message-ID: <20160405130402.GD32576@infradead.org>
References: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
 <1459858062-21075-6-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459858062-21075-6-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Apr 05, 2016 at 08:07:35PM +0800, Ming Lei wrote:
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/dm-bufio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index cd77216..0e48ad7 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -624,8 +624,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
>  	int len;
>  
>  	bio_init(&b->bio);
> -	b->bio.bi_io_vec = b->bio_vec;
> -	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
> +	bio_set_vec_table(&b->bio, b->bio_vec, DM_BUFIO_INLINE_VECS);
>  	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
>  	b->bio.bi_bdev = b->c->bdev;
>  	b->bio.bi_end_io = inline_endio;

Should be switched to use bio_alloc instead.
