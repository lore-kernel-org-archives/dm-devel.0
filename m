From: Daniel Phillips <phillips@phunq.net>
Subject: Re: introduce dm-snap-mv
Date: Thu, 7 Oct 2010 14:31:14 -0700
Message-ID: <201010071431.14937.phillips@phunq.net>
References: <20101006083150.GA15758@zhongling>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101006083150.GA15758@zhongling>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Cong Meng <mcpacino@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hi Meng,

The patch looks sensible, however the question is: why do you want to
do this?  Would it not be better to generalize your metadata format to
accomodate the device's native blocksize?

Regards,

Daniel

> a kernel patch
> --------------
> Now, dm-snap-mv highly depends on a kernel patch below, which make __getblk()
> can get a 4K buffer head while block size of the disk is NOT 4K.
> 
> Signed-off-by: Cong Meng <mcpacino@gmail.com>
> ---
>  fs/buffer.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 3e7dca2..f7f9d33 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>  	pgoff_t index;
>  	int sizebits;
>  
> -	sizebits = -1;
> -	do {
> -		sizebits++;
> -	} while ((size << sizebits) < PAGE_SIZE);
> +	sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
>  
>  	index = block >> sizebits;
>  
> @@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	 */
>  	bio = bio_alloc(GFP_NOIO, 1);
>  
> -	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> +	bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
>  	bio->bi_bdev = bh->b_bdev;
>  	bio->bi_io_vec[0].bv_page = bh->b_page;
>  	bio->bi_io_vec[0].bv_len = bh->b_size;
