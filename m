From: Dmitry Monakhov <dmonakhov@sw.ru>
Subject: Re: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to
	kzalloc
Date: Tue, 24 Jul 2007 14:10:36 +0400
Message-ID: <20070724101036.GI16507@dnb.sw.ru>
References: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934614AbXGXKKe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05:11 =D0=92=D1=82=D1=80 24 =D0=98=D1=8E=D0=BB     , Robert P. J. Da=
y wrote:
>=20
>=20
> -----Original Message-----
> >From: Dmitry Monakhov <dmonakhov@openvz.org>
> >Sent: Jul 24, 2007 4:59 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: device-mapper development <dm-devel@redhat.com>
> >Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to k=
zalloc
> >
> >Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> >---
> > drivers/md/dm-target.c |    6 ++----
> > 1 files changed, 2 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> >index 477a041..835cf95 100644
> >--- a/drivers/md/dm-target.c
> >+++ b/drivers/md/dm-target.c
> >@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
> >=20
> > static struct tt_internal *alloc_target(struct target_type *t)
> > {
> >-	struct tt_internal *ti =3D kmalloc(sizeof(*ti), GFP_KERNEL);
> >+	struct tt_internal *ti =3D kzalloc(sizeof(*ti), GFP_KERNEL);
> >=20
> >-	if (ti) {
> >-		memset(ti, 0, sizeof(*ti));
> >+	if (ti)
> > 		ti->tt =3D *t;
> >-	}
> >=20
> > 	return ti;
> > }
> >--=20
> >1.5.2.2
> >
> >
>=20
> would it not have made more sense to have submitted all those related=
,
> single-change patches as one patch?
Yes i think so (i've already wrote bout this in fist msg), but
dm maintainers may have different oppinion.
BTW: It is allways easier fold many patches to one, than split one=20
patch to many.
>=20
> rday
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
