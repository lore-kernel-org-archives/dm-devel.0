From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 15/17] libmultipath: make directio checker
 share io contexts
Date: Tue, 11 Feb 2020 09:38:39 +0100
Message-ID: <531a70cb9fe8a62a5ad5eed4ddfc437f8930c088.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-16-git-send-email-bmarzins@redhat.com>
	<5f6810410ac8deac3e335ad45ba02184eff155ac.camel@suse.com>
	<20200210231553.GE30153@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200210231553.GE30153@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: development <dm-devel@redhat.com>, device-mapper
List-Id: dm-devel.ids

On Mon, 2020-02-10 at 17:15 -0600, Benjamin Marzinski wrote:
> On Mon, Feb 10, 2020 at 06:08:14PM +0100, Martin Wilck wrote:
> > On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> > > On systems with a large number of cores (>500), io_destroy() can
> > > take
> > > tens to hundreds of milliseconds to complete, due to RCU
> > > synchronization. If there are a large number of paths using the
> > > directio
> > > checker on such a system, this can lead to multipath taking
> > > almost a
> > > minute to complete, with the vast majority of time taken up by
> > > io_destroy().
> > > 
> > > To solve this, the directio checker now allocates one aio context
> > > for
> > > every 1024 checkers. This reduces the io_destroy() delay to a
> > > thousandth
> > > of its previous level. However, this means that muliple checkers
> > > are
> > > sharing the same aio context, and must be able to handle getting
> > > results
> > > for other checkers.  Because only one checker is ever running at
> > > a
> > > time, this doesn't require any locking.  However, locking could
> > > be added
> > > in the future if necessary, to allow multiple checkers to run at
> > > the
> > > same time.
> > > 
> > > When checkers are freed, they usually no longer destroy the io
> > > context.
> > > Instead, they attempt to cancel any outstanding request. If that
> > > fails,
> > > they put the request on an orphan list, so that it can be freed
> > > by other
> > > checkers, once it has completed. IO contexts are only destroyed
> > > at three
> > > times, during reconfigure (to deal with the possibility that
> > > multipathd
> > > is holding more aio events than it needs to be, since there is a
> > > single
> > > limit for the whole system), when the checker class is unloaded,
> > > and
> > > in a corner case when checkers are freed. If an aio_group (which
> > > contains the aio context) is entirely full of orphaned requests,
> > > then
> > > no checker can use it. Since no checker is using it, there is no
> > > checker
> > > to clear out the orphaned requests. In this (likely rare) case,
> > > the
> > > last checker from that group to be freed and leave behind an
> > > orphaned
> > > request will call io_destroy() and remove the group.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  libmultipath/checkers/directio.c | 336
> > > +++++++++++++++++++++++++------
> > >  multipath/multipath.conf.5       |   7 +-
> > >  2 files changed, 281 insertions(+), 62 deletions(-)
> > 
> > Although I concur now that your design is sound, I still have some
> > issues, see below.
> > ...
> >  	}
> > >  	ct->running++;
> > 
> > This looks to me as if in the case (ct->running && ct->req->state
> > ==
> > PATH_PENDING), ct->running could become > 1, even though you don't
> > start a new IO. Is that intended? I don't think it matters because
> > you
> > never decrement, but it looks weird.
> 
> That's necessary for how the checker currently works. In async mode
> checker doesn't actually wait for a specific number of seconds (and
> didn't before my patch). It assumes 1 sec call times for pending
> paths,
> and times out after ct->running > timeout_secs. That's why the unit
> tests can get away with simply calling the checker repeatedly,
> without
> waiting, to make it timeout. But I suppose that
> wait_for_pending_paths()
> will also be making the checker time out quicker, so this should
> probably be changed. However, since check_path won't set a paths
> state
> to PATH_PENDING if it wasn't already, it's not really a very likely
> issue to occur.

Bah. I should have realized that, of course. Yet measuring the timeout
in *seconds*, and polling for it the way we currently do, is really 80s
design... I guess I was confused by the use of ns timeout calculation
for the get_events() call (suggesting high-res timing), and the use of
"ct->running" as both indicator of running IO and "abstract run time".

I hope you admit that the logic in check_path() is convoluted and hard
to understand :-/ . For example here:

> 	while(1) {
> 		r = get_events(ct->aio_grp, timep);
> 
> 		if (ct->req->state != PATH_PENDING) {
> 			ct->running = 0;
> 			return ct->req->state;
> 		} else if (r == 0 || !timep)
> 			break;
> 
> 		get_monotonic_time(&currtime);
> 		timespecsub(&endtime, &currtime, &timeout);
> 		if (timeout.tv_sec < 0)
> 			timep = NULL;

We're past the timeout already, having seen some events, just not for
the path we're currently looking at. Why do we go through another
iteration?

> 	}
> 	if (ct->running > timeout_secs || sync) {
>  
> > See comment for get_events() above. Why don't you simply do this?
> > 
> >     timeout.tv_sec = timeout.tv_nsec = 0;
> > 
> 
> Sure.
> 
> So, If I will post a seperate patch that resolves these issues, can
> this
> one have an ack?

Yes. I agree we should move forward.

Regards
Martin
