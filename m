From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH v2 3/3] libmultipath: change log level
 for null uid_attribute
Date: Thu, 24 Sep 2020 11:20:55 -0500
Message-ID: <20200924162055.GF11108@octiron.msp.redhat.com>
References: <1600923569-17412-1-git-send-email-bmarzins@redhat.com>
	<1600923569-17412-4-git-send-email-bmarzins@redhat.com>
	<62ced86c81b139e6461fe0dc14207606548a652a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62ced86c81b139e6461fe0dc14207606548a652a.camel@suse.com>
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
To: Martin Wilck <martin.wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 08:06:41AM +0000, Martin Wilck wrote:
> On Wed, 2020-09-23 at 23:59 -0500, Benjamin Marzinski wrote:
> > If uid_attribute is explicitly set to an empty string, multipath
> > should
> > log the uid at the default log level, since using the fallback code
> > is
> > the expected behavior.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/discovery.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> > index f650534f..435f2639 100644
> > --- a/libmultipath/discovery.c
> > +++ b/libmultipath/discovery.c
> > @@ -2091,7 +2091,8 @@ get_uid (struct path * pp, int path_state,
> > struct udev_device *udev,
> >  =09=09}
> >  =09=09if ((!udev_available || (len <=3D 0 && allow_fallback))
> >  =09=09    && has_uid_fallback(pp)) {
> > -=09=09=09used_fallback =3D 1;
> > +=09=09=09if (udev_available || !(udev && pp-
> > >uid_attribute))
> > +=09=09=09=09used_fallback =3D 1;
> >  =09=09=09len =3D uid_fallback(pp, path_state, &origin);
> >  =09=09}
> >  =09}
>=20
> Uff, this logic was convoluted anyway, now it's even harder to grasp.
> IIUC, if !udev, used_fallback will be set to 1, even if=20
> pp->uid_attribute is the empty string. Is that intended?
> To make this easier to read, I'd suggest something like this:

My though was that not having a udev device is an unexpected situation,
and so we should continue to log the message at an increased logging
level.  If you're against that, it's not that important. I can certainly
go with your code logic, or "if (!udev || !empty_uid_attr)" if you think
it's reasonable to log at an increased level whenever the udev_device is
NULL, even if the device was configured to ignore the udev database.

-Ben

>=20
> =09=09bool valid_uid_attr =3D pp->uid_attribute
> =09=09=09&& *pp->uid_attribute;
> =09=09bool empty_uid_attr =3D pp->uid_attribute
> =09=09=09&& !*pp->uid_attribute;
> =09=09bool udev_available =3D udev && valid_uid_attr;
>       ...
> =09=09if ((!udev_available || (len <=3D 0 && allow_fallback))
> =09=09    && has_uid_fallback(pp)) {
> =09=09=09if (!empty_uid_attr)
> =09=09=09=09used_fallback =3D 1;
> =09=09=09len =3D uid_fallback(pp, path_state, &origin);
>=20
> Regards,
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
