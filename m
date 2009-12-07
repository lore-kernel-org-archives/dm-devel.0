From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: stop merging using a completion
Date: Mon, 7 Dec 2009 09:01:45 -0500
Message-ID: <20091207140145.GA8917@redhat.com>
References: <1260037484-20905-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.0912052041330.2999@hs20-bc2-1.build.redhat.com>
	<20091206064338.GA15389@redhat.com>
	<Pine.LNX.4.64.0912070621500.15072@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912070621500.15072@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 07 2009 at  6:22am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Sun, 6 Dec 2009, Mike Snitzer wrote:
> 
> > On Sat, Dec 05 2009 at  9:01pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > On Sat, 5 Dec 2009, Mike Snitzer wrote:
> > > 
> > > > Switch stop_merge() from using a busy loop to a completion event.
> > > > 
> > > > stop_merge() now requests merging be shutdown using the
> > > > 'merge_completion' pointer (instead of the 'merge_shutdown' flag).  This
> > > > is accomplished by testing if 'merge_completion' is not NULL in
> > > > snapshot_merge_process().  stop_merge() allocates its completion on the
> > > > stack and assigns it to the 'merge_completion' pointer in the snapshot.
> > > > 'merge_completion' is protected by the snapshot's lock.
> > > > 
> > > > Also changed the 'merge_running' flag from int to atomic_t.
> > > 
> > > No, there's a bug:
> > > 
> > > >  static void stop_merge(struct dm_snapshot *s)
> > > >  {
> > > > -	while (s->merge_running) {
> > > > -		s->merge_shutdown = 1;
> > > > -		msleep(1);
> > > > +	DECLARE_COMPLETION_ONSTACK(merge_stopped);
> > > > +	if (atomic_read(&s->merge_running)) {
> > > 
> > > --- if the merge stops exactly at this point (because it gets finished or 
> > > because of an i/o error), we are waiting for a completion that will be 
> > > never signalled.
> > 
> > Yes, valid point.  But for this rare corner case we could just use
> > wait_for_completion_timeout() with a fairly large timeout; like 30 sec?
> > That actually isn't a great option (racey)...
> > 
> > How about if the 'shut:' code paths also checked for s->merge_completion
> > and complete() if it is not NULL?  Which means that check and related
> > complete() code would become a function.
> > 
> > > > +		down_write(&s->lock);
> > > > +		s->merge_completion = &merge_stopped;
> > > > +		up_write(&s->lock);
> > > > +		wait_for_completion(&merge_stopped);
> > > >  	}
> > > > -	s->merge_shutdown = 0;
> > > >  }
> > > >  
> > > >  /*
> > > 
> > > For Alasdair: do you get the problem? If I write it with msleep() 
> > > correctly, you keep on complaining how unclean it is --- if it is written 
> > > with completions and it is wrong (because they are just harder to use 
> > > correctly than simple variables and msleep), you tend to support it. Now 
> > > you see in practice how complex constructs tend to trigger bugs.
> > > 
> > > Mike: I thought that the completion would be in struct dm_snapshot. But 
> > > maybe, try it with wait_on_bit / wake_up_bit / test_bit / set_bit etc., it 
> > > may be easier than completions.
> > 
> > I can look at it; but I think using a completion can work.
> > 
> > Mike
> 
> Here it is with bits:

OK, looks good; especially in that we can reuse 'bits' for other things
as needed.

Acked-by: Mike Snitzer <snitzer@redhat.com>
