From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 2/4] swait: export the symbols
 __prepare_to_swait and __finish_swait
Date: Wed, 23 May 2018 11:10:14 -0400
Message-ID: <20180523151011.GA30696@redhat.com>
References: <20180519052503.325953342@debian.vm>
	<20180519052633.037700597@debian.vm>
	<20180522063425.GA7854@infradead.org>
	<20180522185037.GB25826@redhat.com>
	<20180523092101.GW12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180523092101.GW12217@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, wagi@monom.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de
List-Id: dm-devel.ids

On Wed, May 23 2018 at  5:21am -0400,
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 22, 2018 at 02:52:54PM -0400, Mike Snitzer wrote:
> > On Tue, May 22 2018 at  2:34am -0400,
> > Christoph Hellwig <hch@infradead.org> wrote:
> 
> > > Please CC the author and maintainers of the swait code.
> > > 
> > > My impression is that this is the wrong thing to do.  The swait code
> > > is supposed to be simple and self contained, and if you want to do
> > > anything else use normal waitqueues.
> > 
> > You said the same thing last time around.  I've since cc'd Peter and
> > Thomas and haven't heard back, see:
> > https://www.redhat.com/archives/dm-devel/2018-May/msg00048.html
> 
> Yeah, sorry, got lost :/

np

> > The entire point of exporting these symbols is to allow use of the
> > "simple waitqueue" code to optimize -- without resorting to using normal
> > waitqueues.
> 
> So I don't immediately object to exporting them; however I do share some
> of hch's concerns. The reason swait exists is to be deterministic (for
> RT) -- something that regular wait code cannot be.
> 
> And by (ab)using / exporting the wait internal lock you risk loosing
> that. So I don't think the proposed usage is bad, it is possible to
> create badness.

Understood.

> So if we're going to export them; someone needs to keep an eye on things
> and ensure the lock isn't abused.

I'll update the patch header and swait.h to reflect these requirements
and send out a new patch.

If you could then reply with your explicit Ack I can stage it for 4.18
via linux-dm.git to ease cross tree dependencies (given dm-writecache
depends on these exports) -- provided you're OK with me doing that.

Thanks,
Mike
