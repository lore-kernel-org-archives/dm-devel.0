From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: fragmented i/o with 2.6.31?
Date: Thu, 17 Sep 2009 09:11:14 -0400
Message-ID: <20090917131113.GA8163@redhat.com>
References: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
	<448b15030909160922o84c2d6gc8ead8226dd8777a@mail.gmail.com>
	<4AB1ED1F.1010203@ct.jp.nec.com> <4AB1FDEE.5020500@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB1FDEE.5020500@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 17 2009 at  5:14am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike, Alasdair,
> 
> Kiyoshi Ueda wrote:
> > On 09/17/2009 01:22 AM +0900, David Strand wrote:
> >> On Wed, Sep 16, 2009 at 8:34 AM, David Strand <dpstrand@gmail.com> wrote:
> >>> I am issuing 512 Kbyte reads through the device mapper device node to
> >>> a fibre channel disk. With 2.6.30 one read command for the entire 512
> >>> Kbyte length is placed on the wire. With 2.6.31 this is being broken
> >>> up into 5 smaller read commands placed on the wire, decreasing
> >>> performance.
> >>>
> >>> This is especially penalizing on some disks where we have prefetch
> >>> turned off via the scsi mode page. Is there any easy way (through
> >>> configuration or sysfs) to restore the single read per i/o behavior
> >>> that I used to get?
> >>
> >> I should note that I am using dm-mpath, and the i/o is fragmented on
> >> the wire when using the device mapper device node but it is not
> >> fragmented when using one of the regular /dev/sd* device nodes for
> >> that device.
> > 
> > David,
> > Thank you for reporting this.
> > I found on my test machine that max_sectors is set to SAFE_MAX_SECTORS,
> > which limits the I/O size small.
> > The attached patch fixes it.  I guess the patch (and increasing
> > read-ahead size in /sys/block/dm-<n>/queue/read_ahead_kb) will solve
> > your fragmentation issue.  Please try it.
> > 
> > 
> > Mike, Alasdair,
> > I found that max_sectors and max_hw_sectors of dm device are set
> > in smaller values than those of underlying devices.  E.g:
> >     # cat /sys/block/sdj/queue/max_sectors_kb
> >     512
> >     # cat /sys/block/sdj/queue/max_hw_sectors_kb
> >     32767
> >     # echo "0 10 linear /dev/sdj 0" | dmsetup create test
> >     # cat /sys/block/dm-0/queue/max_sectors_kb
> >     127
> >     # cat /sys/block/dm-0/queue/max_hw_sectors_kb
> >     127
> > This prevents the I/O size of struct request from becoming enough big
> > size, and causes undesired request fragmentation in request-based dm.
> > 
> > This should be caused by the queue_limits stacking.
> > In dm_calculate_queue_limits(), the block-layer's small default size
> > is included in the merging process of target's queue_limits.
> > So underlying queue_limits is not propagated correctly.
> > 
> > I think initializing default values of all max_* in '0' is an easy fix.
> > Do you think my patch is acceptable?
> > Any other idea to fix this problem?
> 
> Well, sorry, we jumped the gun..
> The patch should work fine for dm-multipath but
> setting '0' by default will cause problems on targets like 'zero' and
> 'error', which take no underlying device and use the default value.
> 
> >  	blk_set_default_limits(limits);
> > +	limits->max_sectors = 0;
> > +	limits->max_hw_sectors = 0;
> 
> So this should either set something very big (e.g. UINT_MAX)
> or set 0 by default but change to a certain safe value, if the end
> result of merging the limits is still 0.
> 
> Attached is a revised patch with the latter approach.
> Please check this.
> If the approach is fine, I think we should bring this up to Jens
> whether to have these helpers in dm-table.c or move to block/blk-settings.c.
> 
> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation

This revised patch looks good.  Thanks for sorting this out.

Seems like we may want some common variant in block even though I'm not
aware of other block drivers that would benefit...

But I'll defer to Martin and/or Jens on whether these helpers are fine
to stay in dm-table.c or should be worked into blk-settings.c

Martin/Jens, what do you guys think?


> max_sectors and max_hw_sectors of dm device are set to smaller values
> than those of underlying devices.  E.g:
>     # cat /sys/block/sdj/queue/max_sectors_kb
>     512
>     # cat /sys/block/sdj/queue/max_hw_sectors_kb
>     32767
>     # echo "0 10 linear /dev/sdj 0" | dmsetup create test
>     # cat /sys/block/dm-0/queue/max_sectors_kb
>     127
>     # cat /sys/block/dm-0/queue/max_hw_sectors_kb
>     127
> This prevents the I/O size of struct request from becoming large,
> and causes undesired request fragmentation in request-based dm.
> 
> This is caused by the queue_limits stacking.
> In dm_calculate_queue_limits(), the block-layer's safe default value
> (SAFE_MAX_SECTORS, 255) is included in the merging process of target's
> queue_limits. So underlying queue_limits is not propagated correctly.
> 
> Initialize default values of all max_*sectors to '0'
> and change the limits to SAFE_MAX_SECTORS only if the value is still
> '0' after merging.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: David Strand <dpstrand@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>,
> Cc: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/dm-table.c |   30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.31/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/md/dm-table.c
> +++ linux-2.6.31/drivers/md/dm-table.c
> @@ -647,6 +647,28 @@ int dm_split_args(int *argc, char ***arg
>  }
>  
>  /*
> + * blk_stack_limits() chooses min_not_zero max_sectors value of underlying
> + * devices. So set the default to 0.
> + * Otherwise, the default SAFE_MAX_SECTORS dominates even if all underlying
> + * devices have max_sectors values larger than that.
> + */
> +static void _set_default_limits_for_stacking(struct queue_limits *limits)
> +{
> +	blk_set_default_limits(limits);
> +	limits->max_sectors = 0;
> +	limits->max_hw_sectors = 0;
> +}
> +
> +/* If there's no underlying device, use the default value in blockdev. */
> +static void _adjust_limits_for_stacking(struct queue_limits *limits)
> +{
> +	if (limits->max_sectors == 0)
> +		limits->max_sectors = SAFE_MAX_SECTORS;
> +	if (limits->max_hw_sectors == 0)
> +		limits->max_hw_sectors = SAFE_MAX_SECTORS;
> +}
> +
> +/*
>   * Impose necessary and sufficient conditions on a devices's table such
>   * that any incoming bio which respects its logical_block_size can be
>   * processed successfully.  If it falls across the boundary between
> @@ -684,7 +706,7 @@ static int validate_hardware_logical_blo
>  	while (i < dm_table_get_num_targets(table)) {
>  		ti = dm_table_get_target(table, i++);
>  
> -		blk_set_default_limits(&ti_limits);
> +		_set_default_limits_for_stacking(&ti_limits);
>  
>  		/* combine all target devices' limits */
>  		if (ti->type->iterate_devices)
> @@ -707,6 +729,8 @@ static int validate_hardware_logical_blo
>  		    device_logical_block_size_sects - next_target_start : 0;
>  	}
>  
> +	_adjust_limits_for_stacking(limits);
> +
>  	if (remaining) {
>  		DMWARN("%s: table line %u (start sect %llu len %llu) "
>  		       "not aligned to h/w logical block size %u",
> @@ -991,10 +1015,10 @@ int dm_calculate_queue_limits(struct dm_
>  	struct queue_limits ti_limits;
>  	unsigned i = 0;
>  
> -	blk_set_default_limits(limits);
> +	_set_default_limits_for_stacking(limits);
>  
>  	while (i < dm_table_get_num_targets(table)) {
> -		blk_set_default_limits(&ti_limits);
> +		_set_default_limits_for_stacking(&ti_limits);
>  
>  		ti = dm_table_get_target(table, i++);
>  
