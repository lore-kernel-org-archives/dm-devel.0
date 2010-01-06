From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Wed, 6 Jan 2010 00:16:06 -0500
Message-ID: <20100106051605.GB21438@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
	<20100106025731.GA16154@redhat.com>
	<yq11vi3ud84.fsf@sermon.lab.mkp.net>
	<20100106041050.GA21438@redhat.com>
	<yq1wrzvswaa.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1wrzvswaa.fsf@sermon.lab.mkp.net>
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

On Tue, Jan 05 2010 at 11:16pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> But even with your blk_off_t patch (and prior to it with sector_t)
> Mike> you're mixing int with blk_off_t in blk_stack_limits() by doing:
> 
> Mike>         alignment = queue_limit_alignment_offset(b, offset);
> 
> Mike> This helped motivate my "blind" conversion.
> 
> Yeah.  However, that particular wart is fixed by an unrelated patch in
> my queue wrt. discard alignment.  But I wanted something you guys could
> look at that applied on top of upstream.
> 
> I'm tinkering with a few things on this end to see if I can make
> the distinction between an offset and an alignment obvious.

Sounds good.  Ultimately we're looking to make sure the DM code is using
"obviously correct" types.  So a near-term minimalist type fix for
upstream (2.6.33) would be awesome.

BTW, the other related concern Alasdair had was that DM shouldn't need
to know to add the start of the partition to the 'offset' it passes to
blk_stack_limits() -- sees it as a layering violation.

I went over the fact that the 'struct queue_limits' was added to
abstract out the limit stacking in a way that DM could use too.  Without
passing asymmetric types for the 'top' and 'bottom' device to
blk_stack_limits(), e.g.:

int blk_stack_limits(struct queue_limits *t, struct block_device *bdev,
                     blk_off_t offset)

we're left with blk_stack_limits() callers needing to pass an offset
relative to the start of the disk.  Alasdair would rather that not be
the case but I'll defer to him on whether he'd still like to see
get_start_sect() be pushed out of DM into blk_stack_limits().

Mike
