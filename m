From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Thu, 4 Feb 2016 08:54:20 -0500
Message-ID: <20160204135420.GA18227@redhat.com>
References: <56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com>
	<20160203182423.GA12913@redhat.com> <56B2F5BC.1010700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56B2F5BC.1010700@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Thu, Feb 04 2016 at  1:54am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 02/03/2016 07:24 PM, Mike Snitzer wrote:
> > On Wed, Feb 03 2016 at  1:04pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> >  
> >> I'm still not clear on where the considerable performance loss is coming
> >> from (on null_blk device I see ~1900K read IOPs but I'm still only
> >> seeing ~1000K read IOPs when blk-mq DM-multipath is layered ontop).
> >> What is very much apparent is: layering dm-mq multipath ontop of null_blk
> >> results in a HUGE amount of additional context switches.  I can only
> >> infer that the request completion for this stacked device (blk-mq queue
> >> ontop of blk-mq queue, with 2 completions: 1 for clone completing on
> >> underlying device and 1 for original request completing) is the reason
> >> for all the extra context switches.
> > 
> > Starts to explain, certainly not the "reason"; that is still very much
> > TBD...
> > 
> >> Here are pictures of 'perf report' for perf datat collected using
> >> 'perf record -ag -e cs'.
> >>
> >> Against null_blk:
> >> http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png
> > 
> > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
> >   cpu          : usr=25.53%, sys=74.40%, ctx=1970, majf=0, minf=474
> > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
> >   cpu          : usr=26.79%, sys=73.15%, ctx=2067, majf=0, minf=479
> > 
> >> Against dm-mpath ontop of the same null_blk:
> >> http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png
> > 
> > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=1
> >   cpu          : usr=11.07%, sys=33.90%, ctx=667784, majf=0, minf=466
> > if dm-mq nr_hw_queues=1 and null_blk nr_hw_queues=4
> >   cpu          : usr=15.22%, sys=48.44%, ctx=2314901, majf=0, minf=466
> > 
> > So yeah, the percentages reflected in these respective images didn't do
> > the huge increase in context switches justice... we _must_ figure out
> > why we're seeing so many context switches with dm-mq.
> > 
> Well, the most obvious one being that you're using 1 dm-mq queue vs
> 4 null_blk queues.
> So you will have have to do an additional context switch for 75% of
> the total I/Os submitted.

Right, that case is certainly prone to more context switches.  But I'm
initially most concerned about the case where both only have 1 queue.

> Have you tested with 4 dm-mq hw queues?

Yes, it makes performance worse.  This is likely rooted in dm-mpath IO
path not being lockless.  But I also have concern about whether the
clone, sent to the underlying path, is completing on a different cpu
than dm-mq's original request.

I'll be using ftrace to try to dig into the various aspects of this
(perf, as I know how to use it, isn't giving me enough precision in its
reporting).

> To avoid context switches we would have to align the dm-mq queues to
> the underlying blk-mq layout for the paths.

Right, we need to take more care (how remains TBD).  But for now I'm
just going to focus on the case where both dm-mq and null_blk have 1 for
nr_hw_queues.  As you can see even in that config the number of context
switches goes from 1970 to 667784 (and there is a huge loss of system
cpu utilization) once dm-mq w/ 1 hw_queue is stacked ontop on the
null_blk device.

Once we understand the source of all the additional context switching
for this more simplistic stacked configuration we can look closer at
scaling as we add more underlying paths.

> And we need to look at making the main submission path lockless;
> I was wondering if we really need to take the lock if we don't
> switch priority groups; maybe we can establish a similar algorithm
> blk-mq does; if we were to have a queue per valid path in any given
> priority group we should be able to run lockless and only take the
> lock if we need to switch priority groups.

I'd like to explore this further with you once I come back up from this
frustrating deep dive on "what is causing all these context switches!?"
 
> But anyway, I'll be looking at your patches.

Thanks, sadly none of the patches are going to fix the performance
problems but I do think they are a step forward.
