From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 20/31] 11-dm-mpath.rules: don't set
	READY->ACTIVATION
Date: Fri, 15 Sep 2017 15:33:59 -0500
Message-ID: <20170915203359.GR3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-21-mwilck@suse.com>
	<20170913211906.GM3145@octiron.msp.redhat.com>
	<1505393299.4493.14.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1505393299.4493.14.camel@suse.com>
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

On Thu, Sep 14, 2017 at 02:48:19PM +0200, Martin Wilck wrote:
> On Wed, 2017-09-13 at 16:19 -0500, Benjamin Marzinski wrote:
> > On Sun, Sep 03, 2017 at 12:38:49AM +0200, Martin Wilck wrote:
> > > The fact alone that a map changes from not ready to ready does
> > > not imply that it is activating.
> > =

> > NAK on this one and
> > [PATCH 21/31] 11-dm-mpath.rules: Remember DM_ACTIVATION
> > =

> > This breaks things. It's often the case that there are devices
> > stacked
> > on top of multipath.  When multipath loses all of its paths, if it
> > doesn't have queue_if_no_path set, it can fail IO up to these higher
> > devices, forcing them to react to the failure.
> =

> Thinking about this again, most of the stuff we do in the multipath-
> related udev rules is for the queueing case. Without
> "queue_if_no_path", all that checking whether or not the map will
> sustain IO is useless; it would be better to simply pass the device on
> to upper layers, which will try to probe it and fail, which is intended
> in the non-queueing setup. Perhaps we should check "queue_if_no_path"
> early on and skip most of the stuff we  do in the queueing case?

I don't really see the benefit in scanning when we're just going to get
back errors, and lose the stored info in the udev database. If IO
happens to the device, the upper layers will find out that it's broken.
If we can lose all our paths, and then have some come back without any
IO going down, why not hide this from the upper layers?

-Ben
 =

> If we did this, maybe even my patches 20/21 might be worth
> reconsideration for the "queue_if_no_path" case only?
> =

> Cheers,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
