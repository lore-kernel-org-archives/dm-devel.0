From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Tue, 8 Mar 2011 12:13:42 -0500
Message-ID: <20110308171322.GB5692@redhat.com>
References: <20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com> <yq1y64reiu8.fsf@sermon.lab.mkp.net>
	<20110307160914.GA29697@redhat.com>
	<yq1ipvudrzo.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1ipvudrzo.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Jens Axboe <jaxboe@fusionio.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08 2011 at  1:51am -0500,
Martin K. Petersen <mkp@mkp.net> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Thanks for sorting this out.  Can you post a patch that has a
> Mike> proper header with your Signed-off-by?  Also including Zdenek's
> Mike> Tested-by, and my:
> 
> I contemplated a bit and decided I liked the following approach
> better. What do you think?
> 
> 
> block: Require subsystems to explicitly allocate bio_set integrity mempool
> 
> MD and DM create a new bio_set for every metadevice. Each bio_set has an
> integrity mempool attached regardless of whether the metadevice is
> capable of passing integrity metadata. This is a waste of memory.
> 
> Instead we defer the allocation decision to MD and DM since we know at
> metadevice creation time whether integrity passthrough is needed or not.
> 
> Automatic integrity mempool allocation can then be removed from
> bioset_create() and we make an explicit integrity allocation for the
> fs_bio_set.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>

In general this approach looks fine too.  Doesn't address the concern I
had yesterday about the blk_integrity block_size relative to DM (load vs
resume) but I'd imagine you'd like to sort that out in a separate patch.

But I found a few DM issues below.  Provided those are sorted out:
Acked-by: Mike Snitzer <snitzer@redhat.com>

(I'll defer to Jens and Neil for the block and MD bits)

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index eaa3af0..b55ef95 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2643,9 +2643,10 @@ int dm_noflush_suspending(struct dm_target *ti)
>  }
>  EXPORT_SYMBOL_GPL(dm_noflush_suspending);
>  
> -struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
> +struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned int integrity)
>  {

Any reason you didn't just use 'unsigned integrity' like you did below
in the dm.h prototype?

>  	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
> +	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ? 16 : MIN_IOS;
>  
>  	if (!pools)
>  		return NULL;
> @@ -2662,11 +2663,13 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
>  	if (!pools->tio_pool)
>  		goto free_io_pool_and_out;
>  
> -	pools->bs = (type == DM_TYPE_BIO_BASED) ?
> -		    bioset_create(16, 0) : bioset_create(MIN_IOS, 0);
> +	pools->bs = bioset_create(pool_size, 0);
>  	if (!pools->bs)
>  		goto free_tio_pool_and_out;
>  
> +	if (integrity && bioset_integrity_create(pools->bs, pool_size))
> +			goto free_tio_pool_and_out;
> +
>  	return pools;
>  
>  free_tio_pool_and_out:

Don't you need to bioset_free(pools->bs) if bioset_integrity_create()
fails?  So you'd need a new 'free_bioset_and_out' label.  Also seems
like maybe you had some extra whitespace on the goto?

> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 0c2dd5f..1aaf167 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -149,7 +149,7 @@ void dm_kcopyd_exit(void);
>  /*
>   * Mempool operations
>   */
> -struct dm_md_mempools *dm_alloc_md_mempools(unsigned type);
> +struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity);
>  void dm_free_md_mempools(struct dm_md_mempools *pools);
>  
>  #endif
