From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/6] multipath: centralize validation code
Date: Mon, 18 May 2020 19:02:52 +0000
Message-ID: <d28941309f31ca447d8fc4f886acfd4e10c1d4da.camel@suse.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-4-git-send-email-bmarzins@redhat.com>
	<58562235f673975a254f3ee41e4548900158022b.camel@suse.com>
	<20200518185315.GW5907@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200518185315.GW5907@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <A7361413298E914289BC16F2A852A3F8@namprd18.prod.outlook.com>
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

On Mon, 2020-05-18 at 13:53 -0500, Benjamin Marzinski wrote:
> On Fri, May 15, 2020 at 08:37:16PM +0000, Martin Wilck wrote:
> > On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> > > This code pulls the multipath path validation code out of
> > > configure(),
> > > and puts it into its own function, check_path_valid(). This
> > > function
> > > calls a new libmultipath function, is_path_valid() to check just
> > > path
> > > requested. This seperation exists so that is_path_valid() can be
> > > reused
> > > by future code. This code will give almost the same answer as the
> > > existing code, with the exception that now, if a device is
> > > currently
> > > multipathed, it will always be a valid multipath path.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Great job getting the logic right! Readability massively improved.
> > Almost ack, a few comments and questions below.
> >=20
> > Regards,
> > Martin
> >=20
> >=20

> > > -=09=09=09conf->find_multipaths |=3D _FIND_MULTIPATHS_I;
> > > +=09=09=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_ON
> > > +=09=09=09    conf->find_multipaths =3D=3D
> > > FIND_MULTIPATHS_STRICT)
> > > +=09=09=09=09conf->find_multipaths =3D
> > > FIND_MULTIPATHS_SMART;
> > > +=09=09=09else if (conf->find_multipaths =3D=3D
> > > FIND_MULTIPATHS_OFF)
> > > +=09=09=09=09conf->find_multipaths =3D
> > > FIND_MULTIPATHS_GREEDY;
> >=20
> > Ok. Previously FIND_MULTIPATHS_SMART was not the same value as
> > FIND_MULTIPATHS_STRICT + _FIND_MULTIPATHS_I. Effectively, this
> > doesn't
> > change logic, but only because the check for ignore_new_devs_on()
> > in
> > should_multipath() is actually redundant. (IIRC in the past we'd
> > determined that "strict" + "ignore_wwids" makes no sense).
> >=20
>=20
> And I still feel like it doesn't make any sense, so this was
> intentional.  Are you arguing that we need that state, or are you
> just
> pointing this out?

Just pointing it out. That's why I wrote "Ok" in the first place. But I
stumbled on it at first sight, and took a while to realize that your
patch got it right. Which is worthwhile to note IMO, in order not to
stumble on it next time.

Sorry for not expressing that clearly enough.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
