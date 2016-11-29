From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 11:25:39 -0600
Message-ID: <20161129172539.GA3099@octiron.msp.redhat.com>
References: <9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
	<fba771cb-222d-88a9-5e9f-35e57206aecd@suse.de>
	<1480406528.7926.7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1480406528.7926.7.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On Tue, Nov 29, 2016 at 09:02:08AM +0100, Martin Wilck wrote:
> On Tue, 2016-11-29 at 07:47 +0100, Hannes Reinecke wrote:
> > On 11/28/2016 07:46 PM, Benjamin Marzinski wrote:
> > > On Thu, Nov 24, 2016 at 10:21:10AM +0100, Martin Wilck wrote:
> > > > On Fri, 2016-11-18 at 16:26 -0600, Benjamin Marzinski wrote:
> > > > =

> > > > > At any rate, I'd rather get rid of the gazillion waiter threads
> > > > > first.
> > > > =

> > > > Hm, I thought the threads are good because this avoids one
> > > > unresponsive
> > > > device to stall everything?
> > > =

> > > There is work making dm events pollable, so that you can wait for
> > > any
> > > number of them with one thread. At the moment, once we get an
> > > event, we
> > > lock the vecs lock, which pretty much keeps everything else from
> > > running, so this doesn't really change that.
> > > =

> > =

> > Which again leads me to the question:
> > Why are we waiting for dm events?
> > The code handling them is pretty arcane, and from what I've seen
> > there
> > is nothing in there which we wouldn't be informed via other
> > mechanisms
> > (path checker, uevents).
> > So why do we still bother with them?

But multipath would still need to respond to the uevents just like it
currently responds to the dm events (by calling udpate_multipath), so
aside from the code setting up waiting on the dm events (which isn't
that bad, except that we currently have to set it up and tear it down
for every multipath device) things would still be the same. The locking
requirements of responding to an event would definitely stame the same,
regardless of whether we were responding to a dm_event or a uevent.
 =

> I was asking myself the same question. From my inspection of the kernel
> code, there are two code paths that trigger a dm event but no uevent
> (bypass_pg() and switch_pg_num(), both related to path group
> switching). If these are covered by the path checker, I see no point in
> waiting for DM events. But of course, I may be missing something.

One answer is that uevents are only "best effort". They are not
guaranteed to be delivered. And the time when they are least likely to
be delivered is when the system is under a lot of memory pressure, which
is exactly what can happen if you lose all paths to your devices, and
are backing up IO. However, from my discussion with Hannes about this,
neither of us came up with any situation where missing a uevent is
disasterous to multipathd. uevents don't bring paths back. The checker
loop does.  Uevents will tell multipathd when a path fails, but the
kernel is the one in charge of routing IO. If multipathd missed a event
for the last failing path, it would not correctly enter recovery mode,
but the checker loop should take care of that when it finds that the
path is down.  The way the checker code is right now, if the kernel
notices a path failure and marks a path down between checkerloop runs,
and multipathd missed the event notifying it of this, and the path came
back before the next checker pass, multipath wouldn't restore the path.
We can obviously solve this by just adding the syncing code from
update_multipath to the check_path code after we call
update_multipath_strings. So, multipathd will need to add some code to
protect it from missing uevents, and losing an event will cause
multipathd to do some things slower than otherwise, but switching to
a design that just uses uevents is workable.

On the other hand, when you think about it, uevents have a lot of
processing associated with them.  This entire thread is about how to cut
that down. dm events only need to be processed by the program waiting
for them, and programs only get the events that they care about. If we
can make dm event processing less cumbersome (and that is currently
being worked on, by making them pollable), I'm not even sure that we
need to send uevents for paths failing and being restored (except for
possibly when your last path goes down, or your first path goes up). The
whole point of multipath is to manage these paths so that nobody else
needs to care about this stuff.

The one big benefit to removing the dm event waiting code, is that we
can remove it completely, which we couldn't do with the uevent code.
Even if we cut down on the number of uevents that multipath generates
and has to respond to, multipathd will still need to respond to uevents,
because many of the important ones come from outside of device-mapper.

-Ben

> =

> Regards,
> Martin
> =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
