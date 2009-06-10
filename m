From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: add topology support
Date: Wed, 10 Jun 2009 17:12:36 -0400
Message-ID: <20090610211235.GF25088@redhat.com>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1ocsw55t6.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Jun 10 2009 at  1:58pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> So the question: is _not_ using the blk_queue_*() setters
> Mike> perfectly fine?  Given that DM has always _not_ used them the
> Mike> quick answer is "seems fine".
> 
> Mike> But I need to dig a bit more to understand if the additional logic
> Mike> in the blk_queue_*() setters is something DM shouldn't be
> Mike> circumventing.
> 
> The original intent was that drivers like DM and MD would seed their
> limits using the blk_queue* calls before adding any component devices.
> blk_stack_limits() would then scale accordingly for every new device
> added.
> 
> Is there any reason in particular that this approach wouldn't work for
> DM?  I.e. set defaults ahead of time instead of doing it upon table
> completion using check_for_valid_limits()?

When a table is pushed to DM each target device in the table may have
different limits.  There is no one-size-fits-all default.

With DM, the underlying device that you're sending IO to is a function
of offset into the DM device.  Therefore, the associated IO limits
should really be a function of offset.

Understanding that that is a more complicated proposition we're working
with the topology infrastructure that you've put together as best we
can.

That means we use a device's alignment_offset in userland LVM2 to push
down a data area whose start+size is aligned.  This gives us the
guarantee that each device in a given DM table is aligned.  From there
DM will use blk_stack_limits() to combine all the other topology limits
(alignment_offset is no longer an issue; though we could get some
warnings.. may look to silence them in dm-table.c).

But blk_stack_limits() leads to a situation where the combined limits
(io_min, logical_block_size) are not ideal for all offsets into the
resulting DM device (e.g. issuing larger IOs to some target devices than
would otherwise be needed).

This is not new for DM (historically DM stacked hardsect_size and other
limits in the same fashion), but it doesn't mean that we aren't keeping
in mind that limits as a function of offset would be more appropriate.

Mike
