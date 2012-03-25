From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Query about dm device max_discard_sectors
Date: Sun, 25 Mar 2012 19:54:22 -0400
Message-ID: <20120325235421.GA31320@redhat.com>
References: <CAL08bwfwD0wtOvum-oeA=skLfQQ_BKSmwJ-ZQbZ+RBwduEJm_A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAL08bwfwD0wtOvum-oeA=skLfQQ_BKSmwJ-ZQbZ+RBwduEJm_A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Amar Mudrankit <amar.mudrankit@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Mar 25 2012 at  6:46pm -0400,
Amar Mudrankit <amar.mudrankit@gmail.com> wrote:

> Hi all,
> 
> I am building an experimental device mapper target which is supposed to
> receive
> all TRIM requests (REQ_DISCARD).  Irrespective of whether underlying actual
> physical block device supports discards or not, my device mapper target
> should
> receive REQ_DISCARD bios.

I'm just curious but: what will your target do in general?
 
> In my target, I set:
> 
> ti->num_discard_requests = 1;
> ti->discards_supported = 1;

You'll also want to set ti->discards_supported

see: http://git.kernel.org/linus/4c259327

> It looks like setting above 2 parameters did not get me any REQ_DISCARD
> requests when "fstrim" utility is used.  The operations fails with
> "Operation not
> supported" from kernel funcion:
> 
> blkdev_issue_discard
> 
> because max_discard_sectors for device queue is set to 0.
> 
> max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> if (unlikely(!max_discard_sectors))
>        return -EOPNOTSUPP;
> 
> When I further digged into the device mapper code, I found that
> dm_calculate_queue_limits function sets the queue limits to default values
> of 0 for both limits as well as ti_limits and thus blk_stack_limits
> eventually
> sets max_discard_sectors to 0 for the device mapper target.
> 
> So, if my device mapper target does not implement iterate_devices function
> (used to set max_discard_sectors based on underlying physical device's
> discard
> support) or underlying physical device does not support discards, then there
> is no way for device mapper target to set max_discard_sectors more than 0
> to receive REQ_DISCARD commands.
> 
> Is this analysis correct? Or I am missing something?

All DM targets should implement .iterate_devices -- intent is to iterate
over all data devices.

You'll also want to implement .io_hints to set limits->max_discard_sectors 
(like drivers/md/dm-thin.c does).

Mike
