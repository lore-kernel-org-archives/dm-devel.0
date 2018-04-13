From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 19/20] libmultipath: enable
	find_multipaths "smart"
Date: Fri, 13 Apr 2018 10:59:36 -0500
Message-ID: <20180413155936.GD3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-20-mwilck@suse.com>
	<20180412184709.GU3103@octiron.msp.redhat.com>
	<1523572049.4346.114.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1523572049.4346.114.camel@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Fri, Apr 13, 2018 at 12:27:29AM +0200, Martin Wilck wrote:
> On Thu, 2018-04-12 at 13:47 -0500, Benjamin Marzinski wrote:
> > On Wed, Apr 04, 2018 at 06:16:26PM +0200, Martin Wilck wrote:
> > > This activates "smart" path detection. This is similar to
> > > "find_multipaths yes", but doesn't generally ignore single paths
> > > that are not listed in the WWIDs file. Rather, such paths are
> > > temporarily treated like multipath members. If no additional paths
> > > are detected after a certain time, the paths are re-added to the
> > > system as non-multipath. This needs support by the udev rules, to
> > > be added in a follow-up patch.
> > > =

> > > If a multipath map is successfully successfully created, and paths
> > > are
> > > in waiting state, trigger path uevents to update their status.
> > > =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/configure.c   | 15 ++++++++++++---
> > >  libmultipath/dict.c        |  1 +
> > >  multipath/multipath.conf.5 | 13 +++++++++++++
> > >  3 files changed, 26 insertions(+), 3 deletions(-)
> > > =

> > > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > > index 9aa3d21..17c2fa1 100644
> > > --- a/libmultipath/configure.c
> > > +++ b/libmultipath/configure.c
> > > @@ -12,6 +12,7 @@
> > >  #include <string.h>
> > >  #include <sys/file.h>
> > >  #include <errno.h>
> > > +#include <ctype.h>
> > >  #include <libdevmapper.h>
> > >  #include <libudev.h>
> > >  #include "mpath_cmd.h"
> > > @@ -476,9 +477,17 @@ trigger_paths_udev_change(struct multipath
> > > *mpp, bool is_mpath)
> > >  			env =3D udev_device_get_property_value(
> > >  				pp->udev,
> > > "DM_MULTIPATH_DEVICE_PATH");
> > >  =

> > > -			if (is_mpath && env !=3D NULL &&
> > > !strcmp(env, "1"))
> > > -				continue;
> > > -			else if (!is_mpath &&
> > =

> > If DM_MULTIPATH_DEVICE_PATH=3D1 then there has already been a uevent
> > where
> > udev recognized that the device should be claimed.  Wouldn't udev
> > have
> > stopped the timer then?  I don't see why this is necessary.
> =

> I set DM_MULTIPATH_DEVICE_PATH=3D1 in the "pretend_mpath" section
> in multipath.rules in the "maybe" case. The value
> DM_MULTIPATH_DEVICE_PATH=3D2 is never passed on to other udev rules,
> and never seen by multipathd.
> =

> The reason I did that was that rules may have checks like
> 'DM_MULTIPATH_DEVICE_PATH!=3D"1", ...' and I wanted to avoid these to be
> run in the "maybe" case, which, for all actors above multipath, =

> should be temporarily treated like "yes".
> =

> I hope this explains it.

Yeah, I probably should have looked back over the code I was confused
about after I read the udev rules patch.  I apparently figured that out
last time I reviewed the patch, and just forgot it.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
