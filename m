From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 5/5] libmultipath: fix ALUA autodetection
 when paths are down
Date: Wed, 20 Nov 2019 11:01:23 -0600
Message-ID: <20191120170122.GQ30153@octiron.msp.redhat.com>
References: <20191115143403.31692-1-martin.wilck@suse.com>
	<20191115143403.31692-6-martin.wilck@suse.com>
	<20191119222954.GM30153@octiron.msp.redhat.com>
	<9dbb15bcf8c527c950876505aaf52e0ea606cb5e.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9dbb15bcf8c527c950876505aaf52e0ea606cb5e.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Wed, Nov 20, 2019 at 12:33:15PM +0000, Martin Wilck wrote:
> On Tue, 2019-11-19 at 16:29 -0600, Benjamin Marzinski wrote:
> > On Fri, Nov 15, 2019 at 02:41:54PM +0000, Martin Wilck wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > If a single path was offline when detect_alua() was called,
> > > multipathd would assume ALUA was generally unsupported.
> > >=20
> > > Fix that by assuming that if at least one path has ALUA support and
> > > no path explicitly does not have it, ALUA is supported.
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/discovery.c | 22 +++++++++++++++++++++-
> > >  libmultipath/propsel.c   | 20 +++++++++++++++++---
> > >  2 files changed, 38 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > > index 4288c9fd..5f41dcb7 100644
> > > --- a/libmultipath/discovery.c
> > > +++ b/libmultipath/discovery.c
> > > @@ -871,6 +871,10 @@ get_serial (char * str, int maxlen, int fd)
> > >  =09return 1;
> > >  }
> > > =20
> > > /*
> > > + * Side effect: sets pp->tpgs if it could be determined.
> > > + * If ALUA calls fail because paths are unreachable, pp->tpgs
> > > remains unchanged.
> > > + */
> > >  static void
> > >  detect_alua(struct path * pp)
> > >  {
> > > @@ -881,12 +885,28 @@ detect_alua(struct path * pp)
> > >  =09if (sysfs_get_timeout(pp, &timeout) <=3D 0)
> > >  =09=09timeout =3D DEF_TIMEOUT;
> > > =20
> > > -=09if ((tpgs =3D get_target_port_group_support(pp, timeout)) <=3D 0)=
 {
> > > +=09tpgs =3D get_target_port_group_support(pp, timeout);
> > > +=09if (tpgs =3D=3D -RTPG_INQUIRY_FAILED)
> > > +=09=09return;
> > > +=09else if (tpgs <=3D 0) {
> > >  =09=09pp->tpgs =3D TPGS_NONE;
> > >  =09=09return;
> > >  =09}
> > > +
> > > +=09if (pp->fd =3D=3D -1 || pp->offline)
> > > +=09=09return;
> > > +
> > =20
> > This is just a nitpick, but won't tpgs already be
> > -RTPG_INQUIRY_FAILED
> > if pp->fd =3D=3D -1. This check makes more sense before
> > get_target_port_group_support().
>=20
> Not really, because get_target_port_group_support() normally obtains
> INQUIRY data from sysfs, which can return something reasonable even
> if fd =3D=3D -1 (e.g. if the path is temporarily offline). In particular,
> it could indicate that the device has no TPGS support. That's why I
> call it first.

Oops. My bad.

Reviewed-by: Benjamin Marzinsk <bmarzins@redhat.com>

-Ben

>=20
> Regards,
> Martin
>=20
