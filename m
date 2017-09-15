From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 15/31] multipath: implement "check usable
	paths" (-C/-U)
Date: Fri, 15 Sep 2017 16:06:48 -0500
Message-ID: <20170915210648.GT3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-16-mwilck@suse.com>
	<20170913205334.GL3145@octiron.msp.redhat.com>
	<1505389651.4493.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1505389651.4493.1.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 14, 2017 at 01:47:31PM +0200, Martin Wilck wrote:
> On Wed, 2017-09-13 at 15:53 -0500, Benjamin Marzinski wrote:
> > On Sun, Sep 03, 2017 at 12:38:44AM +0200, Martin Wilck wrote:
> > > When we process udev rules, it's crucial to know whether I/O on a
> > > given
> > > device will succeed. Unfortunately DM_NR_VALID_PATHS is not
> > > reliable,
> > > because the kernel path events aren't necessarily received in
> > > order, and
> > > even if they are, the number of usable paths may have changed
> > > during
> > > udev processing, in particular when there's a lot of load on udev
> > > because many paths are failing or reinstating at the same time.
> > > The latter problem can't be completely avoided, but the closer the
> > > test before the actual "blkid" call, the better.
> > > =

> > > This patch adds the -C/-U options to multipath to check if a given
> > > map has usable paths. Obviously this command must avoid doing any
> > > I/O
> > > on the multipath map itself, thus no checkers are called; only
> > > status
> > > from sysfs and dm is collected.
> > =

> > I'm a little worried about the overhead of adding yet more multipath
> > commands to udev.  The multipath command takes a while to exec, and
> > already udev hits issues where in event storms, udev can time out
> > because it's trying to do too much with too short a timeout.
> =

> I was aware of that and tried to make this as lean as possible. On my
> system here it takes about 8ms or 500 sytsem calls, which is roughly
> the same number as "multipath -c" or "kpartx_id", at least in the case
> where there are paths available. AFAICS, most of the time is spent in
> libudev collecting device properties. I haven't studied that in depth
> though. "blkid" calls are much more expensive AFAICT.
> =

> > Do out-of-order uevents really happen? =

> =

> For dm-mpath "path events", yes, I'm positive about that. =

> See an example at http://paste.opensuse.org/28641254. =

> It was taken with an openSUSE Tumbleweed 4.11.8 kernel. It was tkane
> from udev monitor data. =

> See http://paste.opensuse.org/63686952 for the full log.

Ick. That's kind of scary. I haven't been thinking about that
possibility when I've been writing or reviewing things... =

 =

> You can see that the time stamps and seqnums increase, but
> DM_NR_VALID_PATHS does not decrease monitonically as you'd expect (my
> script removes all paths of map in order, re-adds them again).
> So far I haven't had the time to analyze this on the kernel side. But
> even if it could be fixed in the kernel, multipathd and the udev rules
> should be able to deal with it.
> =

> So, reinforcing my argument from the log message, I truly believe that
> DM_NR_VALID_PATHS is not something that we should rely upon too much.
> =

> > Delayed ones certainly do, but if
> > we really can see out-of-order events, then all that event coalescing
> > code that got in should get another pass over it, because I'm pretty
> > sure it relied on events not being reordered.
> =

> That would need further examination. I thought that the coalescing
> logic worked mostly on uevents for path devices, not the
> PATH_FAILED/PATH_REINSTATED events for the map devices at which the
> udev rules are looking.

Yeah, it does. I guess the real question is whether the reordering is
happening in udev or in the kernel. If it's in the kernel, it may just
be localized to those uevents.

> > If all we're are worried about is delayed events, then it might be
> > o.k.
> > to just always disable scanning on PATH_FAILED events, because we
> > don't
> > know if there are any more of them. When we reload a device, we
> > already
> > pass the DM_SUBSYSTEM_UDEV_FLAG2 to deal with not having
> > DM_NR_VALID_PATHS on reloads. However, I do realize that a path could
> > fail immediately after the reload, and your patch does a better job
> > keeping that window smaller.
> > =

> > Also, when you have reinstates and failures at the same time, you
> > won't
> > run into problems unless the path you just reinstated immediately
> > fails
> > (otherwise there will be at least one available path, the one you
> > just
> > reinstated).  This certainly can happen. =

> =

> Maybe we could skip calling "multipath -U" for PATH_REINSTATED events.
> You're right, the scenario you just describe is really not that likely.
> =

> > > Unfortunately, in my
> > experience, it usually happens because sysfs says that the path is
> > o.k.
> > but when the kernel tries to do IO to it, it's flaky. The -C/-U
> > callout
> > isn't going to catch those cases, because it doesn't do IO.
> =

> True, but the whole purpose of this patch is to avoid doing IO in the
> first place. We can't do anything about this; both the kernel's and
> multipathd's internal representation can only be approximations of the
> real device state.
> =

> > Now, I agree that you are making the window where things can go wrong
> > smaller, but there is a cost that is being incurred on processing a
> > large number of uevents to make that window smaller, and I don't know
> > exactly how that trade-off works. I've been thinking about making a
> > library interface that multipath would use to do the commands which
> > are
> > also called from udev. That would let udev directly call these
> > commands
> > if they wanted, which would save on the exec time, and cut out any
> > unnecessary cruft that doesn't need to be done for udev to get its
> > information.  That might be a solution, in case we do start seeing
> > more
> > timed-out uevents because of this.
> =

> Sure. I've had a similar thought. My tests with "multipath -U" makes me
> think that most of the time is spent in collecting properties from
> sysfs in libudev. If the code was run in the context of the udev worker
> which might have these properties already cached, performance could be
> much better. I'm not sure what exactly is cached in the udev workers
> though.
> =

> Anyway, back to your NAK on this patch, please consider again. =

> IMO we're a lot safer with this additional check, in particular in view
> of possible out-of-order events.
> =

> I introduced this as a replacement for the original "DM_DEPS" check we
> had at SUSE. We'd found that to be helpful in avoiding problems during
> udev processing in the past. It's always hard to tell if such past
> fixes are still required, but at least for SLES we'd risk to cause
> customer regressions if we simply dropped it, so we prefer to play safe
> here. We can keep this as a SUSE-only patch, if you or others insist
> that "multipath -U" is a bad thing.
> =

> DM_DEPS just checks if there are any paths (valid or not), and comes
> down to a "dmsetup deps" invocation, which takes about 4ms. "multipath
> -U" is slower because it needs to look at the paths, but those
> additional cycles may pay off if we can avoid a blkid call on a device
> with no paths. My first approach to the question "is this map really
> ready for IO?" was indeed just a tiny "dmsetup deps" wrapper. But then
> I realized the ordering problems for uevents shown above, and I
> concluded that a more robust test would be desirable.

I'm not NAKing this patch. I agree that this patch is closing a real
window for errors. I just wanted to preemptively bring up some worries I
have about udev timeouts, and I'm glad to know that you thought about
them as well. If multipath still isn't a major time-sink, then my
worries may well be unfounded, and I'm certainly haven't done any
testing which proves that this patch causes any problems. My goal is
just to make sure that the multipath udev rules are as quick as they can
be, since they already are slower than most of the rules.

If we do start seeing an increase in udev timeouts with this callout,
then we need to consider what to do (possibly by making in a library
function or scrapping in and accepting the increased window for IO to
non-ready devices). But, since you have looked into this, and it doesn't
appear to be an issue, ACK.

-Ben

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
