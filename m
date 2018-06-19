From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH 3/6] exofs: use bio_clone_fast in
	_write_mirror
Date: Tue, 19 Jun 2018 10:54:27 +0300
Message-ID: <8ddd6c9c-0e80-d02c-0539-95566e228841@electrozaur.com>
References: <20180619045216.21130-1-hch@lst.de>
	<20180619045216.21130-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180619045216.21130-4-hch@lst.de>
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
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On 19/06/18 07:52, Christoph Hellwig wrote:
> The mirroring code never changes the bio data or biovecs.  This means
> we can reuse the biovec allocation easily instead of duplicating it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thank you yes that's much better
ACK-by Boaz Harrosh <ooo@electrozaur.com>

> ---
>  fs/exofs/ore.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
> index 1b8b44637e70..5331a15a61f1 100644
> --- a/fs/exofs/ore.c
> +++ b/fs/exofs/ore.c
> @@ -873,8 +873,8 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
>  			struct bio *bio;
>  
>  			if (per_dev != master_dev) {
> -				bio = bio_clone_kmalloc(master_dev->bio,
> -							GFP_KERNEL);
> +				bio = bio_clone_fast(master_dev->bio,
> +						     GFP_KERNEL, NULL);
>  				if (unlikely(!bio)) {
>  					ORE_DBGMSG(
>  					      "Failed to allocate BIO size=%u\n",
> 
