From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath queues build invalid requests when all
	paths are lost
Date: Tue, 4 Sep 2012 12:10:16 -0400
Message-ID: <20120904161016.GA20209@redhat.com>
References: <20120831150428.GA31566@fury.redhat.com>
	<20120904145843.GA19388@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120904145843.GA19388@redhat.com>
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
Cc: dm-devel@redhat.com, David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 04 2012 at 10:58am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Aug 31 2012 at 11:04am -0400,
> David Jeffery <djeffery@redhat.com> wrote:
> 
> > 
> > The DM module recalculates queue limits based only on devices which currently
> > exist in the table.  This creates a problem in the event all devices are
> > temporarily removed such as all fibre channel paths being lost in multipath.
> > DM will reset the limits to the maximum permissible, which can then assemble
> > requests which exceed the limits of the paths when the paths are restored.  The
> > request will fail the blk_rq_check_limits() test when sent to a path with
> > lower limits, and will be retried without end by multipath.
> > 
> > This becomes a much bigger issue after fe86cdcef73ba19a2246a124f0ddbd19b14fb549.
> > Previously, most storage had max_sector limits which exceeded the default
> > value used.  This meant most setups wouldn't trigger this issue as the default
> > values used when there were no paths were still less than the limits of the
> > underlying devices.  Now that the default stacking values are no longer
> > constrained, any hardware setup can potentially hit this issue.
> > 
> > This proposed patch alters the DM limit behavior.  With the patch, DM queue
> > limits only go one way: more restrictive.  As paths are removed, the queue's
> > limits will maintain their current settings.  As paths are added, the queue's
> > limits may become more restrictive.
> 
> With your proposed patch you could still hit the problem if the
> initial multipath table load were to occur when no paths exist, e.g.:
> echo "0 1024 multipath 0 0 0 0" | dmsetup create mpath_nodevs 
> 
> (granted, this shouldn't ever happen.. as is evidenced by the fact
> that doing so will trigger an existing mpath bug; commit a490a07a67b
> "dm mpath: allow table load with no priority groups" clearly wasn't
> tested with the initial table load having no priority groups)

Hi Mikulas, 

It seems your new retry in multipath_ioctl (commit 3599165) is causing
problems for the above dmsetup create.

Here is the stack trace for a hang that resulted as a side-effect of
udev starting blkid for the newly created multipath device:

blkid           D 0000000000000002     0 23936      1 0x00000000
 ffff8802b89e5cd8 0000000000000082 ffff8802b89e5fd8 0000000000012440
 ffff8802b89e4010 0000000000012440 0000000000012440 0000000000012440
 ffff8802b89e5fd8 0000000000012440 ffff88030c2aab30 ffff880325794040
Call Trace:
 [<ffffffff814ce099>] schedule+0x29/0x70
 [<ffffffff814cc312>] schedule_timeout+0x182/0x2e0
 [<ffffffff8104dee0>] ? lock_timer_base+0x70/0x70
 [<ffffffff814cc48e>] schedule_timeout_uninterruptible+0x1e/0x20
 [<ffffffff8104f840>] msleep+0x20/0x30
 [<ffffffffa0000839>] multipath_ioctl+0x109/0x170 [dm_multipath]
 [<ffffffffa06bfb9c>] dm_blk_ioctl+0xbc/0xd0 [dm_mod]
 [<ffffffff8122a408>] __blkdev_driver_ioctl+0x28/0x30
 [<ffffffff8122a79e>] blkdev_ioctl+0xce/0x730
 [<ffffffff811970ac>] block_ioctl+0x3c/0x40
 [<ffffffff8117321c>] do_vfs_ioctl+0x8c/0x340
 [<ffffffff81166293>] ? sys_newfstat+0x33/0x40
 [<ffffffff81173571>] sys_ioctl+0xa1/0xb0
 [<ffffffff814d70a9>] system_call_fastpath+0x16/0x1b
