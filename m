From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm: introduce dm_ask_for_duplicate_bios
Date: Fri, 25 Apr 2014 14:50:56 -0400
Message-ID: <20140425185056.GA5388@redhat.com>
References: <alpine.LRH.2.02.1403141837520.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141840500.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141841290.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141842170.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141843120.31047@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403141843520.31047@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403141843520.31047@file01.intranet.prod.int.rdu2.redhat.com>
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

On Fri, Mar 14 2014 at  6:44pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This function can be used if the target needs to receive another duplicate
> of the current bio.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c               |   24 +++++++++++++++++++-----
>  include/linux/device-mapper.h |    2 ++
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> Index: linux-3.14-rc6/drivers/md/dm.c
> ===================================================================
> --- linux-3.14-rc6.orig/drivers/md/dm.c	2014-03-14 23:25:27.000000000 +0100
> +++ linux-3.14-rc6/drivers/md/dm.c	2014-03-14 23:33:09.000000000 +0100
> @@ -1129,9 +1129,9 @@ EXPORT_SYMBOL_GPL(dm_set_target_max_io_l
>   *	 to make it empty)
>   * The target requires that region 3 is to be sent in the next bio.
>   *
> - * If the target wants to receive multiple copies of the bio with num_write_bios
> - * or num_write_same_bios, the partially processed part (the sum of regions 1+2)
> - * must be the same for all copies of the bio.
> + * If the target wants to receive multiple copies of the bio with num_*_bios or
> + * dm_ask_for_duplicate_bio, the partially processed part (the sum of regions
> + * 1+2) must be the same for all copies of the bio.
>   */
>  void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
>  {
> @@ -1144,6 +1144,17 @@ void dm_accept_partial_bio(struct bio *b
>  }
>  EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
>  
> +/*
> + * The target driver can call this function only from the map routine. The
> + * target driver requests that the dm sends more duplicates of the current bio.
> + */
> +void dm_ask_for_duplicate_bios(struct bio *bio, unsigned n_duplicates)
> +{
> +	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
> +	(*tio->num_bios) += n_duplicates;
> +}
> +EXPORT_SYMBOL_GPL(dm_ask_for_duplicate_bios);
> +
>  static void __map_bio(struct dm_target_io *tio)
>  {
>  	int r;

Hey Mikulas,

I'm not immediately seeing how increasing tio->num_bios from within a
target's map method, using dm_ask_for_duplicate_bios, will cause DM core
to send duplicates.

Nothing in DM core actually consumes tio->num_bios -- please advise.

Thanks,
Mike
