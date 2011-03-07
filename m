From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: mirrored device with thousand of mappingtableentries
Date: Mon, 7 Mar 2011 15:10:27 -0500
Message-ID: <20110307201027.GB31194@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

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

Hey Martin,

I just took the opportunity to review DM's blk_integrity code a bit more
closely -- with an eye towards stacking devices.  I found an issue that
I think we need to fix that has to do with a DM device's limits being
established during do_resume() and not during table_load().

Unfortunately, a DM device's blk_integrity gets preallocated during
table_load().  dm_table_prealloc_integrity()'s call to
blk_integrity_register() establishes the blk_integrity's block_size.

But a DM device's queue_limits aren't stacked until a DM device is
resumed -- via dm_calculate_queue_limits().

For some background please see the patch header of this commit:
http://git.kernel.org/linus/754c5fc7ebb417

The final blk_integrity for the DM device isn't fully established until
do_resume()'s eventual call to dm_table_set_integrity() -- by passing a
template to blk_integrity_register().  dm_table_set_integrity() does
validate the 'block_size' of each DM devices' blk_integrity to make sure
they all match.  So the code would catch the inconsistency should it
arise.

All I'm saying is: it's possible for a table_load() to not have the
awareness that a newly added device's queue_limits will cause the DM
device's final queue_limits to be increased (say a 4K device was
added to dm_device2, and dm_device2 is now being added to another
dm_device1).

So it seems we need to establish bi->sector_size during the final stage
of blk_integrity_register(), e.g. when a template is passed.  Not sure
if you'd agree with that change in general but it'll work for DM because
the queue_limits are established before dm_table_set_integrity() is set.

Maybe revalidate/change the 'block_size' during the final stage in case
it changed?

Thanks,
Mike
