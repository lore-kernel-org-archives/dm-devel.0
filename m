From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: LSF: Multipathing and path checking question
Date: Tue, 21 Apr 2009 12:28:51 -0500
Message-ID: <20090421172851.GU15911@ether.msp.redhat.com>
References: <20090420160041.527A76198AB@hormel.redhat.com>
	<6416EE16C1AF1E4C86882867E4DD0FF60522BB1E@CORPUSMX40B.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6416EE16C1AF1E4C86882867E4DD0FF60522BB1E@CORPUSMX40B.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 20, 2009 at 12:25:23PM -0400, Levy_Jerome@emc.com wrote:
> Just a note or two:
> 
> > My proposal is to handle this in several stages:
> > 
> > - path fails
> > -> Send out netlink event
> > -> start dev_loss_tmo and fast_fail_io timer
> > -> fast_fail_io timer triggers: Abort all oustanding I/O with
> >   DID_TRANSPORT_DISRUPTED, return DID_TRANSPORT_FAILFAST for
> >   any future I/O, and send out netlink event.
> > -> dev_loss_tmo timer triggers: Remove sdev and cleanup rport.
> >   netlink event is sent implicitely by removing the sdev.
> >
> > Multipath would then interact with this sequence by:
> > 
> > - Upon receiving 'path failed' event: mark path as 'ghost' or
> 'blocked',
> >   ie no I/O is currently possible and will be queued (no path switch
> yet).
> > - Upon receiving 'fast_fail_io' event: switch paths and resubmit
> queued I/Os
> > - Upon receiving 'path removed' event: remove path from internal
> structures,
>   update multipath maps etc.
> 
> This makes perfect sense to me. Are we going to allow the end-user to
> modify
> those timers (not sure that's a good idea...)?

It seems to me that some customers really want their IO to failover
quickly when a path goes down, and some really want to avoid path
failovers for transient issues. As long as we set a sensible default,
there doesn't seem much harm in making it configurable. sysfs will
already keep people from setting it to something invalid.

> 
> > The time between 'path failed' and 'fast_fail_io triggers' would then
> be
> > able to capture any jitter / intermittent failures. Between 
> > 'fast_fail_io triggers' and 'path removed' the path would be held in
> some
> > sort of 'limbo' in case it comes back again, eg for maintenance/SP
> update
> > etc. And we can even increase this one to rather long timespans (eg
> hours)
> > to give the admin enough time for a manual intervention.
> 
> > I still like this proposal as it makes multipath interaction far
> cleaner.
> > And we can do away with path checkers completely here.
> 
> All true. Although I think the "long" timespans might be best measured
> in 
> minutes (say, default to 5 minutes) and should be configurable. It
> probably isn't 
> a good idea to leave that path dead for a very long time as a rule, even
> if 
> it's possible to do so. Maybe even some sort of userland override would
> be 
> worthwhile for scheduled maintenance?
> 

I disagree, once the device is dropped, if it ever comes back, there are
many more limitations on multipathd's ability to start monitoring it
again. If you lost a cable that killed your access to your multipathed root
filesystem, and the you didn't get the cable hooked back up before your
device disappeared, I don't see how multipathd would be able to to
restore access.  Am I missing something?

However, if we make dev_loss_tmo configurable too, then if people really
want their failed devices to go away quickly, they're free to change it.

-Ben

> 
> Regards, Jerry
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
