From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/7] libmultipath: change do_get_info returns
Date: Thu, 18 Jun 2020 18:17:33 -0500
Message-ID: <20200618231733.GN5894@octiron.msp.redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-2-git-send-email-bmarzins@redhat.com>
	<a0ac8df28c485019977a5baa3d1c4620604952db.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a0ac8df28c485019977a5baa3d1c4620604952db.camel@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 18, 2020 at 03:27:22PM +0000, Martin Wilck wrote:
> On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> > Make do_get_info() differentiate between dm failures and missing
> > devices, and update callers to retain their current behavior. Also,
> > rename it and make it external. These changes will be used by future
> > commits.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c | 29 ++++++++++++++++-------------
> >  libmultipath/devmapper.h |  1 +
> >  2 files changed, 17 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 27d52398..b44f7545 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -496,8 +496,14 @@ int dm_addmap_reload(struct multipath *mpp, char
> > *params, int flush)
> >  =09return 0;
> >  }
> > =20
> > -static int
> > -do_get_info(const char *name, struct dm_info *info)
> > +/*
> > + * Returns:
> > + * -1: Error
> > + *  0: device does not exist
> > + *  1: device exists
> > + */
>=20
> Can we use symbolic values here please? In particular as you have
> changed the "success" return value from 0 to 1...
>=20
> One day we should come up with a proper return value scheme
> for libmultipath, defining specific enums for every function
> doesn't scale. But do it here for now nonetheless, please.

Sure

-Ben

>=20
> Apart from that, ok.
>=20
> Regards
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
