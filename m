From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath request merging concerns [was: Re: It's
 time to put together the schedule]
Date: Mon, 23 Feb 2015 14:50:57 -0500
Message-ID: <20150223195057.GA4693@redhat.com>
References: <1424395745.2603.27.camel@HansenPartnership.com>
	<54EAD453.6040907@suse.de> <20150223135057.GA3362@redhat.com>
	<54EB60EC.6080706@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54EB60EC.6080706@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: lsf@lists.linux-foundation.org, axboe@kernel.dk, Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 23 2015 at 12:18pm -0500,
Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 2/23/15, 7:50 AM, Mike Snitzer wrote:
> >On Mon, Feb 23 2015 at  2:18am -0500,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>On 02/20/2015 02:29 AM, James Bottomley wrote:
> >>>In the absence of any strong requests, the Programme Committee has taken
> >>>a first stab at an agenda here:
> >>>
> >>>https://docs.google.com/spreadsheet/pub?key=0ArurRVMVCSnkdEl4a0NrNTgtU2JrWDNtWGRDOWRhZnc
> >>>
> >>>If there's anything you think should be discussed (or shouldn't be
> >>>discussed) speak now ...
> >>>
> >>Recently we've found a rather worrysome queueing degradation with
> >>multipathing, which pointed to a deficiency in the scheduler itself:
> >>SAP found that a device with 4 paths had less I/O throughput than a
> >>system with 2 paths. When they've reduced the queue depth on the 4
> >>path system they managed to increase the throughput somewhat, but
> >>still less than they've had with two paths.
> >
> >The block layer doesn't have any understanding of how many paths are
> >behind the top-level dm-mpath request_queue that is supposed to be doing
> >the merging.
> >
> >So from a pure design level it is surprising that 2 vs 4 is impacting
> >the merging at all.  I think Jeff Moyer (cc'd) has dealt with SAP
> >performance recently too.
> >
> >>As it turns out, with 4 paths the system rarely did any I/O merging,
> >>but rather fired off the 4k requests as fast as possible.
> >>With two paths it was able to do some merging, leading to improved
> >>performance.
> >>
> >>I was under the impression that the merging algorithm in the block
> >>layer would only unplug the queue once the request had been fully
> >>formed, ie after merging has happened. But apparently that is not
> >>the case here.
> >
> >Just because you aren't seeing merging are you sure it has anything to
> >do with unpluging?  Would be nice to know more about the workload.
> >
> 
> I think I remember this problem. In the original request based
> design we hit this issue and Kiyoshi or Jun'ichi did some changes
> for it.
> 
> I think it was related to the busy/dm_lld_busy code in dm.c and
> dm-mpath.c. The problem was that we do the merging in the dm level
> queue. The underlying paths do not merge bios. They just take the
> request sent to them.

Digging in to this a little, seems pretty clear that DM-mpath doesn't
have enough integration with the block layer related to queue plugging.

DM is looking for back-pressure in terms of "busy" in 2 ways:

1) from blk_queue_lld_busy() callback:
dm_lld_busy -> dm_table_any_busy_target -> multipath_busy -> 
__pgpath_busy -> dm_underlying_device_busy -> blk_lld_busy

2) from q->request_fn:
dm_request_fn -> multipath_busy ->
__pgpath_busy -> dm_underlying_device_busy -> blk_lld_busy

(btw, I'm tempted to remove dm_underlying_device_busy since it just
calls blk_lld_busy... not seeing the point of the DM wrapper.  BUT to my
amazement, dm_underlying_device_busy is the only caller of
blk_lld_busy.  And the only other caller of blk_queue_lld_busy() is
scsi_alloc_queue().  Meaning this is a useless hook for non-SCSI devices
that might be used by multipath in the future, e.g. NVMe.  Also, we
don't support stacked request-based DM targets so I'm missing _why_ DM
is even bothering to call blk_queue_lld_busy -- I think it shouldn't) 

Anyway, as was noted earlier, mpath's underlying devices could be too
fast to show any signs of "busy" pressure.  And ontop of it, the check
for "busy" is racey given that there is no guarantee that the queue that
is checked will be the actual underlying queue the request will get
dispatched to.

Switching gears slightly, DM is blind to plugging and only relies on
"busy" -- this looks like a recipe for blindly dispatching requests to
the underlying queues.

questions:

- Should request-based DM wire up blk_check_plugged() to allow the block
  layer's plugging to more directly influence when blk_start_request()
  is called from dm_request_fn?

- Put differently: in addition to checking ->busy should dm_request_fn
  also maintain and check plugging state that is influenced by
  blk_check_plugged()?

(or is this moot given that the block layer will only call q->request_fn
when the queue isn't plugged anyway!?)

Basically the long and short of this is: the block layer isn't helping
us like we thought (elevator is effectively useless and/or being
circumvented).  And this apparently isn't new.

I'll take a more measured look at all of this while also trying to
make sense of switching request-based DM over to using blk-mq.
