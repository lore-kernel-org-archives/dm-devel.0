From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 7/8] multipathd: unset mpp->hwe when
	removing map
Date: Wed, 12 Aug 2020 11:07:42 -0500
Message-ID: <20200812160742.GT19233@octiron.msp.redhat.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
	<1597183123-15797-8-git-send-email-bmarzins@redhat.com>
	<6b8bb17983936f267f0b8ef05079dbac78e9e4fa.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6b8bb17983936f267f0b8ef05079dbac78e9e4fa.camel@suse.com>
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

On Wed, Aug 12, 2020 at 09:28:14AM +0000, Martin Wilck wrote:
> On Tue, 2020-08-11 at 16:58 -0500, Benjamin Marzinski wrote:
> > If the map doesn't unset its hwe pointer before orphaning all the
> > paths,
> > multipathd will print a warning message in orphan_path() because of
> > commit "libmultipath: warn if freeing path that holds mpp->hwe".
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Do you have a specific reason to put "mpp->hwe =3D NULL" in the *callers*
> of orphan_paths()?

Nope.

> I observed the same problem, and fixed it
> directly in orphan_paths() (the patch is part of in my upcoming v2
> series).

we can go with yours then.

-Ben

> Regards,
> Martin
>=20
>=20
> > ---
> >  libmultipath/structs_vec.c | 1 +
> >  multipathd/main.c          | 1 +
> >  2 files changed, 2 insertions(+)
> >=20
> > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > index ede14297..103ea11e 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -129,6 +129,7 @@ remove_map(struct multipath * mpp, struct vectors
> > * vecs, int purge_vec)
> >  =09/*
> >  =09 * clear references to this map
> >  =09 */
> > +=09mpp->hwe =3D NULL;
> >  =09orphan_paths(vecs->pathvec, mpp, "map removed internally");
> > =20
> >  =09if (purge_vec &&
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f014d2a1..2b0e2734 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -666,6 +666,7 @@ flush_map(struct multipath * mpp, struct vectors
> > * vecs, int nopaths)
> >  =09=09condlog(2, "%s: map flushed", mpp->alias);
> >  =09}
> > =20
> > +=09mpp->hwe =3D NULL;
> >  =09orphan_paths(vecs->pathvec, mpp, "map flushed");
> >  =09remove_map_and_stop_waiter(mpp, vecs);
> > =20
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
