From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 7 Mar 2011 11:09:14 -0500
Message-ID: <20110307160914.GA29697@redhat.com>
References: <20110228114801.GZ3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639CE@kit001.kaminario.local>
	<20110228121149.GA3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD3018639D7@kit001.kaminario.local>
	<20110228131028.GB3626@agk-dp.fab.redhat.com>
	<E04C10E329E0CD40816C9C17AE53BBD301863A00@kit001.kaminario.local>
	<4D6BA566.1050305@redhat.com> <yq1oc5wp5i3.fsf@sermon.lab.mkp.net>
	<4D73F104.2050807@redhat.com> <yq1y64reiu8.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1y64reiu8.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi Martin,

On Sun, Mar 06 2011 at  9:59pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Zdenek" == Zdenek Kabelac <zkabelac@redhat.com> writes:
> 
> Zdenek> My finding seems to show that BIP-256 slabtop segment grow by
> Zdenek> ~73KB per each device (while dm-io is ab out ~26KB)
> 
> Ok, I see it now that I tried with a bunch of DM devices.
> 
> DM allocates a bioset per volume. And since each bioset has an integrity
> mempool you'll end up with a bunch of memory locked down. It seems like
> a lot but it's actually the same amount as we reserve for the data path
> (bio-0 + biovec-256).
> 
> Since a bioset is not necessarily tied to a single block device we can't
> automatically decide whether to allocate the integrity pool or not. In
> the DM case, however, we just set up the integrity profile so the
> information is available.
> 
> Can you please try the following patch? This will change things so we
> only attach an integrity pool to the bioset if the logical volume is
> integrity-capable.

Thanks for sorting this out.  Can you post a patch that has a proper
header with your Signed-off-by?  Also including Zdenek's Tested-by, and
my:

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks,
Mike

p.s. one small nit:

> diff --git a/fs/bio.c b/fs/bio.c
> index 4bd454f..6e4a381 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1603,9 +1603,10 @@ void bioset_free(struct bio_set *bs)
>  EXPORT_SYMBOL(bioset_free);
>  
>  /**
> - * bioset_create  - Create a bio_set
> + * bioset_create_flags  - Create a bio_set
>   * @pool_size:	Number of bio and bio_vecs to cache in the mempool
>   * @front_pad:	Number of bytes to allocate in front of the returned bio
> + * @flags:	Flags that affect memory allocation
>   *
>   * Description:
>   *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
> @@ -1615,7 +1616,8 @@ EXPORT_SYMBOL(bioset_free);
>   *    Note that the bio must be embedded at the END of that structure always,
>   *    or things will break badly.
>   */
> -struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
> +struct bio_set *bioset_create_flags(unsigned int pool_size,
> +				    unsigned int front_pad, unsigned int flags)
>  {
>  	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
>  	struct bio_set *bs;
> @@ -1636,7 +1638,8 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
>  	if (!bs->bio_pool)
>  		goto bad;
>  
> -	if (bioset_integrity_create(bs, pool_size))
> +	if ((flags & BIOSET_NO_INTEGRITY) == 0 &&
> +	    bioset_integrity_create(bs, pool_size))
>  		goto bad;
>  
>  	if (!biovec_create_pools(bs, pool_size))

We'd generally see: if (!(flags & BIOSET_NO_INTEGRITY) && ...)

but then the double negative is maybe a bit more challenging to deal
with (for a human).  In the end, not a big deal either way ;)
