From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Thu, 7 Jan 2010 13:55:05 -0500
Message-ID: <20100107185505.GA15181@redhat.com>
References: <20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
	<20100106132508.GA3589@redhat.com>
	<yq1hbqxsup7.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1hbqxsup7.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 07 2010 at 12:15pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> However, there are other subsystems that need to stack without an
> >> associated block_device.  So instead of changing blk_stack_limits I
> >> propose we use the wrapper below.
> 
> Mike> Yes, looks like osdblk.c's use of blk_queue_stack_limits()
> 
> DM also does a stacking pass without a bdev (dm_calculate_queue_limits),
> although I think you can avoid that by getting rid of ti_limits
> altogether and just stack limits.

Yeah, I'm keeping the stacking of all devices within a target
self-contained; I also do validation of the target's limits:

                /*
                 * Check each device area is consistent with the target's
                 * overall queue limits.
                 */
                if (ti->type->iterate_devices(ti, device_area_is_invalid,
                                              &ti_limits))
                        return -EINVAL;

The validation, with device_area_is_invalid, is confined to validating
only this target's devices' limits.  I couldn't do the same target-local
validation by stacking a single flat 'limits'.

I then stack that target's limits on the final DM device's 'limits' (and
will spew a warning accordingly).

> I couldn't figure out why the alignment_offset for a misaligned DM
> device was zero, despite being -1 after stacking had completed.  I
> finally spotted this in dm_table_set_restrictions():
> 
>         limits->alignment_offset = 0;
>         limits->misaligned = 0;
> 
> So after all the stacking function's hard work you set the alignment to
> 0 and clear the misaligned flag.  Why?

Good question, it made my head hurt trying to recall why :)

A very critical piece to this is the assumption that alignment_offset is
consumed by LVM2 (it adjusts by shifting a target device's 'start' to
include alignment_offset).  DM doesn't rely on the block layer to
validate alignment_offset at all.

The comment above the lines you referenced offers:

        /*
         * Each target device in the table has a data area that should normally
         * be aligned such that the DM device's alignment_offset is 0.
         * FIXME: Propagate alignment_offsets up the stack and warn of
         *        sub-optimal or inconsistent settings.
         */

Seems I took the time to add a comment whose FIXME doesn't ring many
bells now!  But ignoring that, the comment before the FIXME is making a
veiled reference to userspace having consumed alignment_offset.

To recap: Userspace consumes alignment_offset so it shouldn't be a
concern in DM.  Each target device is validated (like I covered above)
such that any misalignment (purely logicical vs physical misalignment)
within a target device is not tolerated.  So by the time the DM table's
limits get copied to the DM device's limits (in
dm_table_set_restrictions) any misalignment percieved by the block layer
is not trusted/published.

Mike

p.s. Any feedback on fatal flaws in all of this is much appreciated.  I
thought I cleared most of this with you as it was developed but seems
not (obviously I didn't clear resetting alignment_offset and
misaligned).

But I'm now thinking that if all the above works according to plan we
shouldn't ever have a DM device's alignment_offset or misaligned be
anything but 0 (unless one isn't using a trained LVM2; which I'd imagine
you aren't).  Anyway, long story short, those lines _should_ likely be
removed... but it needs further testing that I can't do right now.
