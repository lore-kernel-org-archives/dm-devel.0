From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm: zoned block device fixes
Date: Wed, 31 May 2017 10:39:11 -0400
Message-ID: <20170531143910.GA16671@redhat.com>
References: <20170529102307.19814-1-damien.lemoal@wdc.com>
	<20170530202031.GA52190@redhat.com>
	<46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46ec84af-0700-70f9-f990-d87a63cc18b0@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 31 2017 at 12:29am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> Mike,
> 
> On 5/31/17 05:20, Mike Snitzer wrote:
> > On Mon, May 29 2017 at  6:23P -0400,
> > Damien Le Moal <damien.lemoal@wdc.com> wrote:
> > 
> >> Mike,
> >>
> >> The first 3 patches of this series are incremental fixes for the zoned block
> >> device support patches that you committed to the for-4.13/dm branch.
> >>
> >> The first patch correct the zone alignement checks so that the check is
> >> performed for any device, regardless of the device LBA size (it is skipped for
> >> 512B LBA devices otherwise).
> > 
> > I folded this first patch into the original commit (baf844bf4ae3).
> 
> Great. Thanks.
> 
> >> The second patch is a fix for commit baf844bf4ae3 "dm table: add zoned block
> >> devices validation". In that commit, the stacked limits zoned model was not
> >> set to the zoned model of the table target devices, leading to the exposed
> >> device always being exposed as a regular block device. With this fix, dm-flaky
> >> and dm-linear work fine on top of host-managed zoned block devices.
> >>
> >> The third patch fixes zoned model validation again to allow for target types
> >> emulating a different zoned model than the model of the table target devices,
> >> e.g. dm-zoned.
> > 
> > The 2nd and 3rd seem over-done to me.  After spending more time than
> > ideal, the following patch would seem to be the equivalent to what
> > you've done in patches 2 and 3 (sans the "cleanup" of passing limits to
> > validate_hardware_zoned_model):
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 6545150..a39bcd9 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1523,19 +1524,39 @@ int dm_calculate_queue_limits(struct dm_table *table,
> >  			       dm_device_name(table->md),
> >  			       (unsigned long long) ti->begin,
> >  			       (unsigned long long) ti->len);
> > +
> > +		/*
> > +		 * FIXME: this should likely be moved to blk_stack_limits(), would
> > +		 * also eliminate limits->zoned stacking hack in dm_set_device_limits()
> > +		 */
> > +		if (limits->zoned == BLK_ZONED_NONE && ti_limits.zoned != BLK_ZONED_NONE) {
> > +			/*
> > +			 * By default, the stacked limits zoned model is set to
> > +			 * BLK_ZONED_NONE in blk_set_stacking_limits(). Update
> > +			 * this model using the first target model reported
> > +			 * that is not BLK_ZONED_NONE. This will be either the
> > +			 * first target device zoned model or the model reported
> > +			 * by the target .io_hints.
> > +			 */
> > +			limits->zoned = ti_limits.zoned;
> > +		}
> >  	}
> >  
> >  	/*
> >  	 * Verify that the zoned model and zone sectors, as determined before
> >  	 * any .io_hints override, are the same across all devices in the table.
> > -	 * - but if limits->zoned is not BLK_ZONED_NONE validate match for it
> > -	 * - simillarly, check all devices conform to limits->chunk_sectors if
> > -	 *   .io_hints altered them
> > +	 * - this is especially relevant if .io_hints is emulating a disk-managed
> > +	 *   zoned model (aka BLK_ZONED_NONE) on host-managed zoned block devices.
> > +	 * BUT...
> >  	 */
> > -	if (limits->zoned != BLK_ZONED_NONE)
> > +	if (limits->zoned != BLK_ZONED_NONE) {
> > +		/*
> > +		 * ...IF the above limits stacking determined a zoned model
> > +		 * validate that all of the table's devices conform to it.
> > +		 */
> >  		zoned_model = limits->zoned;
> > -	if (limits->chunk_sectors != zone_sectors)
> >  		zone_sectors = limits->chunk_sectors;
> > +	}
> >  	if (validate_hardware_zoned_model(table, zoned_model, zone_sectors))
> >  		return -EINVAL;
> >  
> > Anyway, I've folded this into the original commit too.  If you could
> > verify it works with your scenarios I'd appreciate it.
> 
> I tested with dm-linear, dm-flakey and dm-zoned. No problems detected,
> the end device zone model and zone size was always correct. I also tried
> all invalid setup I could generate and all were properly caught.
> 
> There is however one case that will not work: an HM (or HA) emulating
> target on top of a regular (NONE) block device. In that case, we will
> end up checking that the underlying devices are compatible HM/HA, whih
> will fail. But since none of the existing targets currently do this, I
> guess the code is OK as is. What do you think ?

Yeah, I think it best to fix that if/when there is a need.

> > FYI, any additional cosmetic cleanup can wait (I happen to think this
> > code is clearer than how you relied on the matches functions to
> > initialize a temporary value).
> 
> OK. No problem.
> 
> > I also folded in an validate_hardware_zoned_model() optimization to
> > return early if zoned_model == BLK_ZONED_NONE, please see/test the
> > rolled-up end result here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-4.13/dm&id=9a6b54360f147c2d25fba7debc31a3251b804cc2
> > 
> > Also, please note that I've forcibly rebased linux-dm.git's
> > 'for-4.13/dm' and staged it in 'for-next'.
> 
> I tested this tree unmodified. No problem detected.
> Thank you.

Good news, thanks for the review/testing.

FYI: my review of dm-zoned will be focused on DM target correctness
(suspend/resume quirks, no allocations in the IO path that aren't backed
by a mempool, coding style nits, etc).  I don't know enough about zoned
block devices to weigh-in on those details.  Ultimately I'll be
deferring to you, others on your team, and others in the community that
are more invested in zoned block devices to steer and stabilize this
target.

Anyway, hopefully my review will be fairly quick and I can get dm-zoned
staged for 4.13 by end of day tomorrow.

Mike
