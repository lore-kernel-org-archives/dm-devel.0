From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt performance
Date: Tue, 26 Mar 2013 16:28:38 -0400
Message-ID: <20130326202837.GA5599@redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5151FF82.6090405@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, tj@kernel.org
List-Id: dm-devel.ids

On Tue, Mar 26 2013 at  4:05pm -0400,
Milan Broz <gmazyland@gmail.com> wrote:

> >On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
> >
> >>For best performance we could use the unbound workqueue implementation
> >>with request sorting, if people don't object to the request sorting being
> >>done in dm-crypt.
> 
> So again:
> 
> - why IO scheduler is not working properly here? Do it need some extensions?
> If fixed, it can help even is some other non-dmcrypt IO patterns.
> (I mean dmcrypt can set some special parameter for underlying device queue
> automagically to fine-tune sorting parameters.)

Not sure, but IO scheduler changes are fairly slow to materialize given
the potential for adverse side-effects.  Are you so surprised that a
shotgun blast of IOs might make the IO schduler less optimal than if
some basic sorting were done at the layer above?

> - can we have some cpu-bound workqueue which automatically switch to unbound
> (relocates work to another cpu) if it detects some saturation watermark etc?
> (Again, this can be used in other code.
> http://www.redhat.com/archives/dm-devel/2012-August/msg00288.html
> (Yes, I see skepticism there :-)

Question for Tejun? (now cc'd).

> >On Tue, Mar 26, 2013 at 02:52:29AM -0400, Christoph Hellwig wrote:
> >>FYI, XFS also does it's own request ordering for the metadata buffers,
> >>because it knows the needed ordering and has a bigger view than than
> >>than especially CFQ.  You at least have precedence in a widely used
> >>subsystem for this code.
> 
> Nice. But XFS is much more complex system.
> Isn't it enough that multipath uses own IO queue (so we have one IO scheduler
> on top of another, and now we have metadata io sorting in XFS on top of it
> and planning one more in dmcrypt? Is it really good approach?)

Multipath's request_queue is the only one with an active IO scheduler;
the requests are dispatched directly to the underlying devices' queues
without any IO scheduling.

As for dm-crypt; as you know it is bio-based so it is already dealing
with out of order IOs (no benefit of upper level IO scheduler).  Seems
relatively clear, from Mikulas' results, that maybe you're hoping for a
bit too much magic from the IO scheduler gnomes that lurk on LKML.  BTW,
pretty sure btrfs takes care to maintain some IO dispatch ordering too.

Mike
