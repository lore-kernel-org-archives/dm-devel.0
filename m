From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Wed, 6 Jan 2010 08:25:08 -0500
Message-ID: <20100106132508.GA3589@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
	<20100106051605.GB21438@redhat.com>
	<yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1pr5nsk3z.fsf@sermon.lab.mkp.net>
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

On Wed, Jan 06 2010 at  3:39am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> BTW, the other related concern Alasdair had was that DM shouldn't
> Mike> need to know to add the start of the partition to the 'offset' it
> Mike> passes to blk_stack_limits() -- sees it as a layering violation.
> 
> Mike> I went over the fact that the 'struct queue_limits' was added to
> Mike> abstract out the limit stacking in a way that DM could use too.
> Mike> Without passing asymmetric types for the 'top' and 'bottom' device
> Mike> to blk_stack_limits(), e.g.:
> 
> I don't particularly care about the symmetry.  The current set of
> arguments were first and foremost there to meet DM's needs.  I don't
> think you had access to the bdev at the right time when we originally
> came up with this.

I think we always had it for the bottom device but not the top..
 
> However, there are other subsystems that need to stack without an
> associated block_device.  So instead of changing blk_stack_limits I
> propose we use the wrapper below.

Yes, looks like osdblk.c's use of blk_queue_stack_limits()
 
> You'll notice that bdev_stack_limits takes a sector offset as argument.
> I have a patch that I intend to push at a later date that will convert
> the remaining stacking functions to take soft sector offsets instead of
> bytes.  I deal with the appropriate conversion in the alignment
> calculation.  That way we avoid the blk_off_t goo entirely and it makes
> the difference between absolute offsets and alignment offsets crystal
> clear.

Looks good.  But you're missing the EXPORT_SYMBOL(bdev_stack_limits)

> Alasdair, if you are OK with the approach below I propose you give an
> Acked-by: and then we can feed the patch through Jens instead of dealing
> with a clunky two-stage merge this late in the .33 game.

Good point, you can have mine while we're at it.


> block: bdev_stack_limits wrapper
> 
> DM does not want to know about partition offsets.  Add a partition-aware
> wrapper that DM can use when stacking block devices.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
