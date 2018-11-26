From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V12 05/20] block: remove bvec_iter_rewind()
Date: Mon, 26 Nov 2018 14:16:06 -0800
Message-ID: <20181126221606.GF30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-6-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

On Mon, Nov 26, 2018 at 10:17:05AM +0800, Ming Lei wrote:
> Commit 7759eb23fd980 ("block: remove bio_rewind_iter()") removes
> bio_rewind_iter(), then no one uses bvec_iter_rewind() any more,
> so remove it.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 24 ------------------------
>  1 file changed, 24 deletions(-)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 02c73c6aa805..ba0ae40e77c9 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -92,30 +92,6 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
>  	return true;
>  }
>  
> -static inline bool bvec_iter_rewind(const struct bio_vec *bv,
> -				     struct bvec_iter *iter,
> -				     unsigned int bytes)
> -{
> -	while (bytes) {
> -		unsigned len = min(bytes, iter->bi_bvec_done);
> -
> -		if (iter->bi_bvec_done == 0) {
> -			if (WARN_ONCE(iter->bi_idx == 0,
> -				      "Attempted to rewind iter beyond "
> -				      "bvec's boundaries\n")) {
> -				return false;
> -			}
> -			iter->bi_idx--;
> -			iter->bi_bvec_done = __bvec_iter_bvec(bv, *iter)->bv_len;
> -			continue;
> -		}
> -		bytes -= len;
> -		iter->bi_size += len;
> -		iter->bi_bvec_done -= len;
> -	}
> -	return true;
> -}
> -
>  #define for_each_bvec(bvl, bio_vec, iter, start)			\
>  	for (iter = (start);						\
>  	     (iter).bi_size &&						\
> -- 
> 2.9.5
> 
