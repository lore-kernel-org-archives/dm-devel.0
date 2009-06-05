From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: add topology support
Date: Fri, 5 Jun 2009 10:21:12 -0400
Message-ID: <20090605142111.GA21775@redhat.com>
References: <1244059149-14279-1-git-send-email-snitzer@redhat.com>
	<yq17hzrl2pu.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq17hzrl2pu.fsf@sermon.lab.mkp.net>
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
Cc: agk@redhat.com, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Fri, Jun 05 2009 at 12:33am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> +	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
> +		DMWARN("%s: target device %s is misaligned",
> +		       dm_device_name(ti->table->md), bdevname(bdev, b));
> 
> I did some testing tonight.  You're always passing offset 0 into the
> stacking function so things are not working right.  This argument should
> contain the offset to the first (data) sector.  So you want something
> like get_start_sect(bdev) << 9 for the stacking to do its magic.

I followed your lead :)
 http://mkp.net/code/topology/dm-topology.patch

But, yes I became concerned about this just last night myself when I
added yet another call to blk_stack_limits().

I need to continue looking at this problem; particularly as it relates
to the LVM2 userspace's role in seeding the DM layer appropriately.

My initial thinking was that if LVM2 understood how to consume the
alignment_offset when constructing an LV then the alignment_offset
information becomes unnecessary to propagate.  Thinking being that
alignment_offset was already accounted for in LVM2 by adjusting each
target devices' 'start' within the DM table (associated with the LV).

So I'm not yet seeing why alignment_offset _should_ matter as you stack
within DM (because of LVM2's role in accounting for it) but...

I'll work through this further; I welcome any ideas/feedback you might
have.

Thanks,
Mike
