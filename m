From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 4/7] multipathd: add "del maps" multipathd
	command
Date: Fri, 19 Jun 2020 13:35:36 +0000
Message-ID: <1cfbed51fbef1958305638cb8a921ff8ec97792f.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-5-git-send-email-bmarzins@redhat.com>
	<e27f7ecbc221185773df1db7b36209db6d1bd61a.camel@suse.com>
	<20200618231206.GK5894@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200618231206.GK5894@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <2581A7AD2BB83F4C8413676528920755@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-06-18 at 18:12 -0500, Benjamin Marzinski wrote:
> On Thu, Jun 18, 2020 at 08:37:20PM +0000, Martin Wilck wrote:
> >=20
> > > -int dm_flush_maps (int retries)
> > > +int dm_flush_maps (int need_suspend, int retries)
> > >  {
> > >  =09int r =3D 1;
> > >  =09struct dm_task *dmt;
> > > @@ -1014,7 +1014,10 @@ int dm_flush_maps (int retries)
> > > =20
> > >  =09r =3D 0;
> > >  =09do {
> > > -=09=09r |=3D dm_suspend_and_flush_map(names->name, retries);
> > > +=09=09if (need_suspend)
> > > +=09=09=09r |=3D dm_suspend_and_flush_map(names->name,
> > > retries);
> > > +=09=09else
> > > +=09=09=09r |=3D dm_flush_map(names->name);
> >=20
> > This is fine, but considering the previous discussion, I'd prefer
> > to
> > get rid of need_suspend and dm_suspend_and_flush_map() entirely. It
> > would simplify the _dm_flush_map code path significantly.
> >=20
> > As we determined that we use the suspend/resume only in multipath
> > anyway, we could add it there in the "non-delegated" code path.
>=20
> I'm confused. dm_flush_maps() is also called in the non-delegated
> code
> path, where it uses the dm_suspend_and_flush_map(). Are you proposing
> an alternative version of dm_flush_maps() for multipath?

No, just a different error handling in multipath. Instead of calling
just calling dm_flush_maps() again from multipath with need_suspend=3D1,
we could suspend / resume directly in the error path, and then call
dm_flush_map again. Which would allow us to get rid of need_suspend, as
no callers would set it any more.

IOW, move the handling of this multipath-specific error situation out
of libmultipath, into the multipath-specific code.

Just an idea, I don't insist on it.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
