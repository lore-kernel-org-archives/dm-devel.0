From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Tue, 26 Jan 2016 09:47:13 -0500
Message-ID: <20160126144713.GA24239@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com> <56A77C21.90605@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56A77C21.90605@suse.de>
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
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

[you're killing me.. you nuked all CCs again]

On Tue, Jan 26 2016 at  9:01am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/26/2016 02:29 PM, Mike Snitzer wrote:
> > On Mon, Jan 25 2016 at  6:37pm -0500,
> > Benjamin Marzinski <bmarzins@redhat.com> wrote:
> > 
> >> On Mon, Jan 25, 2016 at 04:40:16PM -0500, Mike Snitzer wrote:
> >>> On Tue, Jan 19 2016 at  5:45P -0500,
> >>> Mike Snitzer <snitzer@redhat.com> wrote:
> >>
> >> I don't think this is going to help __multipath_map() without some
> >> configuration changes.  Now that we're running on already merged
> >> requests instead of bios, the m->repeat_count is almost always set to 1,
> >> so we call the path_selector every time, which means that we'll always
> >> need the write lock. Bumping up the number of IOs we send before calling
> >> the path selector again will give this patch a change to do some good
> >> here.
> >>
> >> To do that you need to set:
> >>
> >> 	rr_min_io_rq <something_bigger_than_one>
> >>
> >> in the defaults section of /etc/multipath.conf and then reload the
> >> multipathd service.
> >>
> >> The patch should hopefully help in multipath_busy() regardless of the
> >> the rr_min_io_rq setting.
> > 
> > This patch, while generic, is meant to help the blk-mq case.  A blk-mq
> > request_queue doesn't have an elevator so the requests will not have
> > seen merging.
> > 
> > But yes, implied in the patch is the requirement to increase
> > m->repeat_count via multipathd's rr_min_io_rq (I'll backfill a proper
> > header once it is tested).
> > 
> But that would defeat load balancing, would it not?
> IE when you want to do load balancing you would constantly change
> paths, thereby always taking the write lock.
> Which would render the patch pointless.

Increasing m->repeat_count slightly for blk-mq could be beneficial
considering there isn't an elevator.  I do concede the need for finding
the sweet-spot (not too small, not too large so as to starve load
balancing) is less than ideal.  But it needs testing.

This initial m->lock conversion from spinlock_t to rwlock_t is just the
first step on addressing the locking bottlenecks we've not had a need to
look at until now.  Could be the rwlock_t also gets replaced with a more
complex locking model.

More work is possible to make path switching lockless.  Not yet clear
(to me) on how to approach it.  And yes, the work gets incrementally
more challenging (percpu, rcu, whatever... that code is "harder",
especially when refactoring existing code with legacy requirements).

> I was rather wondering if we could expose all active paths as
> hardware contexts and let blk-mq do the I/O mapping.
> That way we would only have to take the write lock if we have to
> choose a new pgpath/priority group ie in the case the active
> priority group goes down.

Training blk-mq to be multipath aware (priority groups, etc) is a
entirely new tangent that is one rabbit hole after another.

Yeah I know you want to throw away everything.  I'm not holding you back
from doing anything but I've told you I want incremental dm-multipath
improvements until it is clear there is no more room for improvement.
