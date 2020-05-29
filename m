From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/1] libdmmp: Add support for upcoming json-c
	0.14.0.
Date: Fri, 29 May 2020 11:19:59 -0500
Message-ID: <20200529161959.GF5907@octiron.msp.redhat.com>
References: <1590725443-3519-1-git-send-email-bmarzins@redhat.com>
	<1590725443-3519-2-git-send-email-bmarzins@redhat.com>
	<d092428a245e0b5d88b70f03a473d7df7b95cd27.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d092428a245e0b5d88b70f03a473d7df7b95cd27.camel@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "besser82@fedoraproject.org" <besser82@fedoraproject.org>, "mail@eworm.de" <mail@eworm.de>
List-Id: dm-devel.ids

On Fri, May 29, 2020 at 09:12:30AM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> On Thu, 2020-05-28 at 23:10 -0500, Benjamin Marzinski wrote:
> > From: Bj=F6rn Esser <besser82@fedoraproject.org>
> >=20
> > TRUE/FALSE are not defined anymore.  1 and 0 are used instead.
> > This is backwards compatible, as earlier versions of json-c are
> > using the same integer values in their present definitions.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libdmmp/libdmmp_private.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
> > index ac85b63f..4378962b 100644
> > --- a/libdmmp/libdmmp_private.h
> > +++ b/libdmmp/libdmmp_private.h
> > @@ -82,7 +82,7 @@ static out_type func_name(struct dmmp_context *ctx,
> > const char *var_name) { \
> >  do { \
> >  =09json_type j_type =3D json_type_null; \
> >  =09json_object *j_obj_tmp =3D NULL; \
> > -=09if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) !=3D TRUE)
> > { \
> > +=09if (json_object_object_get_ex(j_obj, key, &j_obj_tmp) !=3D 1) { \
> >  =09=09_error(ctx, "Invalid JSON output from multipathd IPC: "
> > \
> >  =09=09       "key '%s' not found", key); \
> >  =09=09rc =3D DMMP_ERR_IPC_ERROR; \
>=20
> Did you see=20
> https://www.redhat.com/archives/dm-devel/2020-May/msg00261.html ?

Nope. Overlooked it. My bad. I'm fine with any version that compiles.
Either stdbool or int is fine.

-Ben

>=20
> This has first been reported to the list by Christian (
> https://www.redhat.com/archives/dm-devel/2020-April/msg00261.html), and
> brought to my attention later by Xose. I personally thought the change
> from boolean to int is a step in the wrong direction, therefore I
> submitted my modified version using stdboolh. If everyone else is fine
> with the int, it's not worth arguing about it.
>=20
> Regards,
> Martin
>=20
> PS: Can anyone explain why json-c did this? Looks like a "cause hassle
> for downstream devs and users for no good reason" kind of thing to
> me...
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
