From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 4/7] multipathd: add "del maps" multipathd
	command
Date: Thu, 18 Jun 2020 18:12:06 -0500
Message-ID: <20200618231206.GK5894@octiron.msp.redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-5-git-send-email-bmarzins@redhat.com>
	<e27f7ecbc221185773df1db7b36209db6d1bd61a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e27f7ecbc221185773df1db7b36209db6d1bd61a.camel@suse.com>
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

On Thu, Jun 18, 2020 at 08:37:20PM +0000, Martin Wilck wrote:
> On Wed, 2020-06-17 at 19:24 -0500, Benjamin Marzinski wrote:
> > This will flush all multipath devices.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c  |  7 +++++--
> >  libmultipath/devmapper.h  |  2 +-
> >  multipath/main.c          |  2 +-
> >  multipathd/cli.c          |  1 +
> >  multipathd/cli_handlers.c | 19 +++++++++++++++++++
> >  multipathd/cli_handlers.h |  1 +
> >  multipathd/main.c         |  3 ++-
> >  multipathd/main.h         |  1 +
> >  8 files changed, 31 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 682c0038..a5e0d298 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -991,7 +991,7 @@ dm_flush_map_nopaths(const char * mapname, int
> > deferred_remove)
> > =20
> >  #endif
> > =20
> > -int dm_flush_maps (int retries)
> > +int dm_flush_maps (int need_suspend, int retries)
> >  {
> >  =09int r =3D 1;
> >  =09struct dm_task *dmt;
> > @@ -1014,7 +1014,10 @@ int dm_flush_maps (int retries)
> > =20
> >  =09r =3D 0;
> >  =09do {
> > -=09=09r |=3D dm_suspend_and_flush_map(names->name, retries);
> > +=09=09if (need_suspend)
> > +=09=09=09r |=3D dm_suspend_and_flush_map(names->name,
> > retries);
> > +=09=09else
> > +=09=09=09r |=3D dm_flush_map(names->name);
>=20
> This is fine, but considering the previous discussion, I'd prefer to
> get rid of need_suspend and dm_suspend_and_flush_map() entirely. It
> would simplify the _dm_flush_map code path significantly.
>=20
> As we determined that we use the suspend/resume only in multipath
> anyway, we could add it there in the "non-delegated" code path.

I'm confused. dm_flush_maps() is also called in the non-delegated code
path, where it uses the dm_suspend_and_flush_map(). Are you proposing
an alternative version of dm_flush_maps() for multipath?

-Ben

> Thanks,
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
