From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/6] dm: introduce dm_accept_partial_bio
Date: Mon, 17 Mar 2014 09:27:40 -0400
Message-ID: <20140317132740.GA7184@redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 14 2014 at  6:41pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> The function dm_accept_partial_bio allows the target to specify how many
> sectors does it want to process. If the target wants to accept only a part
> of the bio, it calls dm_accept_partial_bio and the dm core sends the rest
> of the data in next bio.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c               |   58 ++++++++++++++++++++++++++++++++++++------
>  include/linux/device-mapper.h |    2 +
>  2 files changed, 52 insertions(+), 8 deletions(-)
> 
> Index: linux-3.14-rc5/drivers/md/dm.c
> ===================================================================
> --- linux-3.14-rc5.orig/drivers/md/dm.c	2014-03-14 04:31:41.000000000 +0100
> +++ linux-3.14-rc5/drivers/md/dm.c	2014-03-14 04:32:08.000000000 +0100
> @@ -1105,6 +1105,45 @@ int dm_set_target_max_io_len(struct dm_t
>  }
>  EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
>  
> +/*
> + * A target may call dm_accept_partial_bio only from the map routine. It is
> + * allowed for all bio types except REQ_FLUSH.
> + *
> + * dm_accept_partial_bio informs the dm that the target only wants to process
> + * additional n_sectors sectors of the bio and the rest of the data should be
> + * sent in a next bio.
> + *
> + * A diagram that explains the arithmetics:
> + * +--------------------+---------------+-------+
> + * |         1          |       2       |   3   |
> + * +--------------------+---------------+-------+
> + *
> + * <-------------- *tio->len_ptr --------------->
> + *                      <------- bi_size ------->
> + *                      <-- n_sectors -->
> + *
> + * Region 1 was already iterated over with bio_advance or similar function.
> + *	(it may be empty if the target doesn't use bio_advance)
> + * Region 2 is the remaining bio size that the target wants to process.
> + *	(it may be empty if region 1 is non-empty, although there is no reason
> + *	 to make it empty)
> + * The target requires that region 3 is to be sent in the next bio.
> + *
> + * If the target wants to receive multiple copies of the bio with num_write_bios
> + * or num_write_same_bios, the partially processed part (the sum of regions 1+2)
> + * must be the same for all copies of the bio.
> + */
> +void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
> +{
> +	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
> +	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
> +	BUG_ON(bi_size > *tio->len_ptr);
> +	BUG_ON(n_sectors > bi_size);
> +	*tio->len_ptr -= bi_size - n_sectors;
> +	bio->bi_iter.bi_size = n_sectors << SECTOR_SHIFT;
> +}
> +EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
> +

The dm_accept_partial_bio interface should return an error (e.g. if bio
has REQ_FLUSH set, or the above BUG_ON conditions are met).  The method
should probably also be designated with __must_check.  And it should
_not_ BUG_ON.  BUG_ON is a crutch that I do not appreciate seeing in new
code.  If you'd like to keep them, and get stacktraces, I'd prefer
seeing them converted to WARN_ON that is followed with an error return.
