From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 17/20] multipath.rules: find_multipaths
	"smart" logic
Date: Wed, 28 Mar 2018 12:12:59 -0500
Message-ID: <20180328171259.GB3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-18-mwilck@suse.com>
	<20180327210339.GX3103@octiron.msp.redhat.com>
	<1522186440.13140.47.camel@suse.com>
	<20180327230706.GY3103@octiron.msp.redhat.com>
	<1522248672.5251.25.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1522248672.5251.25.camel@suse.com>
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

On Wed, Mar 28, 2018 at 04:51:12PM +0200, Martin Wilck wrote:
> On Tue, 2018-03-27 at 18:07 -0500, Benjamin Marzinski wrote:
> > On Tue, Mar 27, 2018 at 11:34:00PM +0200, Martin Wilck wrote:
> > > =

> > > The following happens: multipath -u temporarily claims the device.
> > > When
> > > multipathd starts, it fails to set up the map, sets the "failed"
> > > marker, and retriggers udev. The second time, multipath -u unclaims
> > > the
> > > device because it recognizes it as failed.
> > =

> > But if that device is already in use because multipath didn't claim
> > it
> > in the initramfs, and you suddenly mark it as ENV{SYSTEMD_READY}=3D"0",
> > this can cause systemd to automatically unmount any filesystem on it.
> > This isn't just a problem with Red Hat's setup.  If it's not a
> > configured device type, there will only be a short timeout, but
> > that's
> > still enough to mess with devices that are already in use.  I'm
> > pretty
> > sure that the multipath temporary claiming is only safe the very
> > first
> > time a device appears. Otherwise, it's possible that something else
> > will
> > claim it first, and then multipath will claim it and mess with that
> > other user.
> > =

> =

> Arrgh. Thanks for pointing that out. It's even worse because even if we
> could figure out whether we're being called for the first or second
> time, it wouldn't be sufficient. multipath.rules may not even be
> present in the initrd, so the device may be present in the system, and
> used, without multipath.rules having ever been called.
> =

> The only way I see to avoid this is to try calling open(O_EXCL) on the
> path device in "multipath -u". So far we've avoided that because it's
> not completely race-free. But we're not talking about a race here, but
> a situation where some entity grabbed a device before pivot-root.
> So we could attempt open(O_EXCL) only in the "is maybe a valid path"
> case, and only return "maybe" if that open succeeds. Otherwise we'd
> return "no", as we already checked that the device isn't currently part
> of a multipath map.
> =


Something like that should work.  I think we need to be careful to only
ever do the exclusive open on an "add" event. In fact in probably
wouldn't hurt to add some checks to make sure that we never start
a temporary claim on a change event.  If we get a change event and
FIND_MULTIPATHS_WAIT_UNTIL is unset, we should just assume that we
missed the add event, and it should be set to "finished".

What would be really nice would be to be able to tell if we are doing a
cold-plug add after the pivot.  This is the only time where we actually
need to check if a device is in use. Otherwise nobody else will have had
a chance to use it yet.

-Ben

> Agreed?
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
