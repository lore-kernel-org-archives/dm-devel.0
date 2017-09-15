From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 21/31] 11-dm-mpath.rules: Remember
	DM_ACTIVATION
Date: Fri, 15 Sep 2017 15:40:32 -0500
Message-ID: <20170915204032.GS3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-22-mwilck@suse.com>
	<20170913211942.GN3145@octiron.msp.redhat.com>
	<1505394403.4493.17.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1505394403.4493.17.camel@suse.com>
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

On Thu, Sep 14, 2017 at 03:06:43PM +0200, Martin Wilck wrote:
> Hi Ben,
> =

> On Wed, 2017-09-13 at 16:19 -0500, Benjamin Marzinski wrote:
> > On Sun, Sep 03, 2017 at 12:38:50AM +0200, Martin Wilck wrote:
> > > If DM_ACTIVATION is set by the general dm rules, we need to
> > > bring up this device. But if the mpath device is not ready,
> > > that would be dangerous; it could hang or produce lots of IO
> > > errors. So remember this state, and try to activate when the
> > > map becomes usable later.
> > =

> > NAK. See reasons in
> > =

> > [PATCH 20/31] 11-dm-mpath.rules: don't set READY->ACTIVATION
> =

> Sorry for being slow. Re-reading this, I don't understand any more why
> your valid argument against 20/31 invalidates this one as well. 21/31
> affects only the case MPATH_DEVICE_READY!=3D0, in which case it will add
> another case where DM_ACTIVATION is set.

If we are always setting DM_ACTIVATION when MPATH_DEVICE_READY changes
from zero to non-zero, we don't need to remember that we had to disable
DM_ACTIVATION when the device wasn't ready, and make sure to set it
now, because we are always setting it when we change to a device ready
state... right?

-Ben

> =

> Regards
> Martin
> =

> > =

> > -Ben
> > =

> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  multipath/11-dm-mpath.rules | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > =

> > > diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-
> > > mpath.rules
> > > index 3f47744f..9bfd75f8 100644
> > > --- a/multipath/11-dm-mpath.rules
> > > +++ b/multipath/11-dm-mpath.rules
> > > @@ -4,6 +4,7 @@ ENV{DM_UUID}!=3D"mpath-?*", GOTO=3D"mpath_end"
> > >  =

> > >  IMPORT{db}=3D"DM_DISABLE_OTHER_RULES_FLAG_OLD"
> > >  IMPORT{db}=3D"MPATH_DEVICE_READY"
> > > +IMPORT{db}=3D"MPATH_NEEDS_ACTIVATION"
> > >  =

> > >  # If this uevent didn't come from dm, don't try to update the
> > >  # device state
> > > @@ -55,6 +56,13 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=3D=3D"1",
> > > ENV{DM_ACTIVATION}=3D"0"
> > >  # We'd like to avoid this, especially within udev processing.
> > >  ENV{MPATH_DEVICE_READY}=3D=3D"0", ENV{DM_NOSCAN}=3D"1"
> > >  =

> > > +# If DM_ACTIVATION is set, but can't be satisfied, remember it
> > > +# in MPATH_NEEDS_ACTIVATION, and activate at the next opportunity.
> > > +ENV{MPATH_DEVICE_READY}=3D=3D"0", ENV{DM_ACTIVATION}=3D=3D"1", \
> > > +	ENV{MPATH_NEEDS_ACTIVATION}=3D"1", ENV{DM_ACTIVATION}=3D"0"
> > > +ENV{MPATH_DEVICE_READY}!=3D"0", ENV{MPATH_NEEDS_ACTIVATION}=3D=3D"1"=
, \
> > > +	ENV{DM_ACTIVATION}=3D"1", ENV{MPATH_NEEDS_ACTIVATION}=3D""
> > > +
> > >  # Also skip all foreign rules if no path is available.
> > >  # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
> > >  # and restore it back once we have at least one path available.
> > > -- =

> > > 2.14.0
> > =

> > =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
