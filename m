From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Wed, 23 Dec 2009 12:13:51 -0500
Message-ID: <20091223171351.GA17896@redhat.com>
References: <20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
	<yq1my1a52k4.fsf@sermon.lab.mkp.net>
	<20091222214250.GA28497@redhat.com>
	<yq17hse443y.fsf@sermon.lab.mkp.net>
	<20091223142649.GA4462@redhat.com>
	<yq1y6kt3b1n.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1y6kt3b1n.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Dec 23 2009 at 11:33am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> One thing I noticed along the way is that: when stacking one or
> Mike> more misaligned devices there is the potential for misleading
> Mike> error messages, e.g.:
> 
> [...]
> 
> Mike> So sdb2 is taken to be aligned (even though it isn't, relative to
> Mike> the queue's alignment_offset of 3584) and then when sdb1 is
> Mike> stacked it is flagged as misaligned.  Doesn't seem right.
> 
> I know.  It's an unfortunate side-effect of having an iterative stacking
> process.  I don't know the whole picture so I don't know which device
> the real offender is.  At the time you add device #2 I have no
> recollection of device #1.
> 
> When you create a new top-level (DM/MD) device and add the first disk to
> it I have no option but to inherit that component's queue limits.  So
> that's what initially defines the top-level.
> 
> In your case adding a misaligned device will cause the stacking to
> report that alignment can be obtained by padding the top level device
> with an offset. Then you add a device which happens to be naturally
> aligned. And that means the stacking logic breaks down because the
> 0-alignment is incompatible with the top's nonzero alignment_offset.

Understood.  Thanks for clarifying.

> Originally (before the Great Naming Debate) the `misaligned' flag was
> called `inconsistent' (actually, it was called `consistent' and the
> logic was reversed).  I think that's a better term for it.  Compatible
> would also work, I guess.
> 
> So when blk_stack_limits() returns an error it is because no consistent
> alignment could be calculated.  blk_stack_limits() returning 0 does not
> imply "alignment" (i.e. an alignment_offset of 0).  A return value of 0
> means that we have successfully added the bottom device and the
> resulting top device queue_limits now apply.

I think it would be great if you added something along those lines as a
comment block above blk_stack_limits() (rather than "Returns 0 if
alignment didn't change.")

Also, your most recent patch eliminates many of the inline comments you
had in blk_stack_limits().  I think that is unfortunate considering
those comments helped give context for code that wasn't always
immediately clear on its own.

That observation aside, please feel free to add 'Tested-by: Mike Snitzer
<snitzer@redhat.com>' to your most recent blk_stack_limits() patch
header.

> Maybe you should print something along the lines of "adding device sdX
> caused an alignment consistency error on DM device foo".  That's a bit
> vague but doesn't single out sdX as much.

Good suggestion.  I'll work that in to the DM patch you originally
posted (the start of this thread) and repost it to dm-devel.

Thanks,
Mike
