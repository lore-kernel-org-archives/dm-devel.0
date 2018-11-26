From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 17/20] block: always define BIO_MAX_PAGES as 256
Date: Mon, 26 Nov 2018 14:44:39 -0800
Message-ID: <20181126224439.GN30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-18-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-18-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Mon, Nov 26, 2018 at 10:17:17AM +0800, Ming Lei wrote:
> Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> increase BIO_MAX_PAGES for it.
> 
> CONFIG_THP_SWAP needs to split one THP into normal pages and adds
> them all to one bio. With multipage-bvec, it just takes one bvec to
> hold them all.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bio.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 5505f74aef8b..7be48c55b14a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -34,15 +34,7 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#ifdef CONFIG_THP_SWAP
> -#if HPAGE_PMD_NR > 256
> -#define BIO_MAX_PAGES		HPAGE_PMD_NR
> -#else
>  #define BIO_MAX_PAGES		256
> -#endif
> -#else
> -#define BIO_MAX_PAGES		256
> -#endif
>  
>  #define bio_prio(bio)			(bio)->bi_ioprio
>  #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
> -- 
> 2.9.5
> 
