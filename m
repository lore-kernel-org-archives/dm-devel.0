From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Boot hangs 3 minutes with device mapper
	on s390
Date: Tue, 5 Mar 2019 08:29:14 -0500
Message-ID: <20190305132914.GA24388@redhat.com>
References: <20190301183350.5ff697d4@TP-holzheu>
	<20190301183050.GA29752@redhat.com>
	<20190304110334.6f71962a@TP-holzheu>
	<20190305040321.GA21739@redhat.com>
	<alpine.LRH.2.02.1903050440470.24841@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1903050440470.24841@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexander Duyck <alexander.duyck@gmail.com>, dm-devel@redhat.com, linux-next@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>, Michael Holzheu <holzheu@linux.ibm.com>
List-Id: dm-devel.ids

On Tue, Mar 05 2019 at  4:46am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 4 Mar 2019, Mike Snitzer wrote:
> 
> > Hi,
> > 
> > Alexander reported this same boot hang in another thread.  I was able to
> > reproduce using an x86_64 .config that Alexander provided.
> > 
> > I've pushed this fix out to linux-next:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.1&id=be2c5301817833f692aadb2e5fa209582db01d3b
> > 
> > If you could verify this fix works for you I'd appreciate it.
> > 
> > Thanks,
> > Mike
> 
> So, remove this no-clone optimization and stage it for the next merge 
> window. There's something we don't understand, so don't merge it. This 
> patch is just papering over the problem.

I layered changes that extended your initial noclone support and that
seems to have upset you.  Yes the evolution could've been cleaner but
to say this is papering over anything is purely wrong.

Clearly we're reentering dm_noclone_process_bio() and the relaxed
negative check that only concerned itself with whether we were in
make_request_fn lost sight of the potential for losing an 'struct
dm_noclone' that was already attached to the bio.  _THAT_ is cause for
the hang.  Full stop.

I didn't have time to sort out why we rentered dm_noclone_process_bio()
yesterday.  But I can easily do so today.  Just to fully appreciate
_why_ it happened.

To categorize any of this as papering over is just _wrong_ and I don't
understand why you think it OK to accuse me with that.  Rather than dig
in to help you've sat back and attacked me.

> "Stacking noclone targets creates more complexity than is tolerable" just 
> means that no one knows what is hapenning there.

Not constructive.  What it means is: I wrote the code that enables
splitting + stacking no_clone + dm_work_fn rentry in dm_process_bio.
The duality of use in the shared code paths and flag day to support all
of it made this noclone optimization brittle.  I'll grant you that.

Given the mental gymnastics I had to do to reason through what _could_ be
going on in different stacking scenarios just made me uneasy to support
such noclone complexity from the start.  Could revisit allowing stacking
at a later date though.
 
> Meanwile, we could get access to the system that reports hangs and test it 
> there.

What part of "I was able to reproduce using an x86_64 .config that
Alexander provided" don't you understand?

It wasn't even that the code was just superficially broken.  It required
Alexander's .config to tease out the problem.  It took quite a while to
get my kvm guest testbed sorted out and zero in on reproducing.  I did
that work.  I then asked those who reported the problem to confirm it
fixes the issue for them.
