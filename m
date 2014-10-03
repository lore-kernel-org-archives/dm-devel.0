From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] block: add bioset_nobvec_create()
Date: Fri, 3 Oct 2014 09:16:05 -0400
Message-ID: <20141003131605.GA11977@redhat.com>
References: <542E8CF9.6000609@ce.jp.nec.com> <542E8EAB.5010603@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542E8EAB.5010603@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

On Fri, Oct 03 2014 at  7:55am -0400,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Users of bio_clone_fast() do not need its own bvecs.
> Allocating bvec mempool for such users is waste of memory.
> 
> This variant allows them to create bioset without bvec mempool.
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  block/bio.c         | 61 ++++++++++++++++++++++++++++++++++++++---------------
>  include/linux/bio.h |  1 +
>  2 files changed, 45 insertions(+), 17 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 3e6331d..98c5100 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1900,20 +1903,9 @@ void bioset_free(struct bio_set *bs)
>  }
>  EXPORT_SYMBOL(bioset_free);
>  
> -/**
> - * bioset_create  - Create a bio_set
> - * @pool_size:	Number of bio and bio_vecs to cache in the mempool
> - * @front_pad:	Number of bytes to allocate in front of the returned bio
> - *
> - * Description:
> - *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
> - *    to ask for a number of bytes to be allocated in front of the bio.
> - *    Front pad allocation is useful for embedding the bio inside
> - *    another structure, to avoid allocating extra data to go with the bio.
> - *    Note that the bio must be embedded at the END of that structure always,
> - *    or things will break badly.
> - */
> -struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
> +static struct bio_set *__bioset_create(unsigned int pool_size,
> +				       unsigned int front_pad,
> +				       unsigned int create_bvec_pool)
>  {
>  	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
>  	struct bio_set *bs;

Any reason not to use bool for create_bvec_pool?

> @@ -1951,8 +1945,41 @@ bad:
>  	bioset_free(bs);
>  	return NULL;
>  }
> +
> +/**
> + * bioset_create  - Create a bio_set
> + * @pool_size:	Number of bio and bio_vecs to cache in the mempool
> + * @front_pad:	Number of bytes to allocate in front of the returned bio
> + *
> + * Description:
> + *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
> + *    to ask for a number of bytes to be allocated in front of the bio.
> + *    Front pad allocation is useful for embedding the bio inside
> + *    another structure, to avoid allocating extra data to go with the bio.
> + *    Note that the bio must be embedded at the END of that structure always,
> + *    or things will break badly.
> + */
> +struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
> +{
> +	return __bioset_create(pool_size, front_pad, 1);
> +}
>  EXPORT_SYMBOL(bioset_create);
>  
> +/**
> + * bioset_nobvec_create  - Create a bio_set without bio_vec mempool
> + * @pool_size:	Number of bio to cache in the mempool
> + * @front_pad:	Number of bytes to allocate in front of the returned bio
> + *
> + * Description:
> + *    Same functionality as bioset_create() except that mempool is not
> + *    created for bio_vecs. Saving some memory for bio_clone_fast() users.
> + */
> +struct bio_set *bioset_nobvec_create(unsigned int pool_size, unsigned int front_pad)
> +{
> +	return __bioset_create(pool_size, front_pad, 0);
> +}
> +EXPORT_SYMBOL(bioset_nobvec_create);
> +
>  #ifdef CONFIG_BLK_CGROUP
>  /**
>   * bio_associate_current - associate a bio with %current

And use true and false accordingly...

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index b39e500..7d7b2a7 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -342,6 +342,7 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
>  }
>  
>  extern struct bio_set *bioset_create(unsigned int, unsigned int);
> +extern struct bio_set *bioset_nobvec_create(unsigned int, unsigned int);
>  extern void bioset_free(struct bio_set *);
>  extern mempool_t *biovec_create_pool(int pool_entries);

Also, I prefer the function name: bioset_create_nobvec (to keep it in
the "bioset_create" family).

Otherwise, please feel free to add to v2:

Acked-by: Mike Snitzer <snitzer@redhat.com>
