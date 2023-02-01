Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EB5C636CD
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675262393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HbWPVIps9pRG8Q+aLFXb5Hmjnf3cM/tE4G++l2/jhG0=;
	b=G48k2pyR2a2yMyEw4v5XSi79pBxlFAyygqHokJZrMkNsYqHt2FWl12PyKMFR3EXow832Ii
	MvbGB/OLSKfSE5J4ExwAlU6Z8En1yxgcm64ik2YPz5uh/HudLQKenF2GiG7PRZXkT7G8DY
	elI/qI2sSyUFUvq1OwfTVWBM4oyhbsI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-Dv2-f7ZqPUq3Objh0AKAEQ-1; Wed, 01 Feb 2023 09:39:52 -0500
X-MC-Unique: Dv2-f7ZqPUq3Objh0AKAEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 249C41C04193;
	Wed,  1 Feb 2023 14:39:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A095A40398A0;
	Wed,  1 Feb 2023 14:39:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 742EA19465A2;
	Wed,  1 Feb 2023 14:39:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3202C194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 14:39:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 120AF43FB8; Wed,  1 Feb 2023 14:39:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF78C53A0;
 Wed,  1 Feb 2023 14:39:46 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 311Edjej007670;
 Wed, 1 Feb 2023 08:39:45 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 311Edi6o007669;
 Wed, 1 Feb 2023 08:39:44 -0600
Date: Wed, 1 Feb 2023 08:39:44 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230201143944.GV17327@octiron.msp.redhat.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-5-git-send-email-bmarzins@redhat.com>
 <75e8e7c39785a85b068f65c49f9c334f95fcaf24.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <75e8e7c39785a85b068f65c49f9c334f95fcaf24.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/4] libmultipath: keep renames from stopping
 other multipath actions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2023 at 08:00:25AM +0000, Martin Wilck wrote:
> On Tue, 2023-01-31 at 13:34 -0600, Benjamin Marzinski wrote:
> > If select_action() is called and a multipath device needs to be
> > renamed,
> > the code currently checks if force_reload is set, and if so, does the
> > reload after the rename.=A0 But if force_reload isn't set, only the
> > rename
> > happens, regardless of what other actions are needed. This can happen
> > if
> > multipathd starts up and a device needs both a reload and a rename.
> >=20
> > Make multipath check for resize, reload, and switch pathgroup along
> > with
> > rename, and do both if necessary.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Looks good, but I have some questions below.
>=20
> > ---
> > =A0libmultipath/configure.c | 60 +++++++++++++++++---------------------
> > --
> > =A0libmultipath/configure.h |=A0 4 ++-
> > =A02 files changed, 29 insertions(+), 35 deletions(-)
> >=20
> > diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> > index e870e0f6..2228176d 100644
> > --- a/libmultipath/configure.c
> > +++ b/libmultipath/configure.c
> > @@ -670,7 +670,8 @@ static bool is_udev_ready(struct multipath *cmpp)
> > =A0static void
> > =A0select_reload_action(struct multipath *mpp, const char *reason)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RELOAD;
> > +=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->action =3D=3D ACT_RENAME ? A=
CT_RELOAD_RENAME :
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACT_RELOA=
D;
> > =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alia=
s, reason);
> > =A0}
> > =A0
> > @@ -681,6 +682,7 @@ void select_action (struct multipath *mpp, const
> > struct _vector *curmp,
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * cmpp_by_name;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * mpp_feat, * cmpp_feat;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_NOTHING;
> > =A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(curmp, mpp->wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0cmpp_by_name =3D find_mp_by_alias(curmp, mpp->a=
lias);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (mpp->need_reload || (cmpp && cmpp->need_rel=
oad))
> > @@ -705,14 +707,8 @@ void select_action (struct multipath *mpp, const
> > struct _vector *curmp,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(mpp->alias_old,=
 cmpp->alias, WWID_SIZE);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_REN=
AME;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->force_udev_reload =3D 1;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->action =3D ACT_FORCERENAME;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (cmpp !=3D cmpp_by_name) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* don't return here. Che=
ck for other needed actions
> > */
> > +=A0=A0=A0=A0=A0=A0=A0} else if (cmpp !=3D cmpp_by_name) {
>=20
> Why does your "check for other needed actions" logic not apply for this
> case? AFAICS, even if we can't rename the map, we might need to resize
> or reload.=20

Oops. Good catch. I'll fix that.

>=20
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: unable =
to rename %s to %s (%s is used
> > by %s)",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->wwid, cmpp->alias, mpp->alias,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->alias, cmpp_by_name->wwid);
> > @@ -725,7 +721,8 @@ void select_action (struct multipath *mpp, const
> > struct _vector *curmp,
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->size !=3D mpp->size) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RESIZ=
E;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->acti=
on =3D=3D ACT_RENAME ?
> > ACT_RESIZE_RENAME :
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ACT_RESIZE;
>=20
>=20
> This code makes we wonder if we should transform the ACT_... enum into
> a bitmap of required actions that would be ORed together.
> At least ACT_RENAME is now orthogonal to the rest of the actions.

I thought about that too, as well as breaking rename out from the other
actions, so it could be checked separately.  But since, AFAICS, there
are only these three special cases, it didn't seem like there'd be much
benefit, and it could give the false impression that something like
ACT_RELOAD | ACT_SWITCHPG makes sense. If you feel strongly about this,
I can do it, but I did consider it and I didn't see a reason to change
it.

-Ben

> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT=
_RESIZE (size change)",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > @@ -801,14 +798,14 @@ void select_action (struct multipath *mpp,
> > const struct _vector *curmp,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->nextpg !=3D mpp->bestpg) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_SWITC=
HPG;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->acti=
on =3D=3D ACT_RENAME ?
> > ACT_SWITCHPG_RENAME :
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 ACT_SWITCHPG;
>=20
> See above.
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT=
_SWITCHPG (next path group
> > change)",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_NOTHING;
> > -=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_NOTHING (map unchanged)",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> > +=A0=A0=A0=A0=A0=A0=A0if (mpp->action =3D=3D ACT_NOTHING)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_N=
OTHING (map unchanged)",
> > mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0}
> > =A0
> > @@ -909,6 +906,17 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (mpp->action =3D=3D ACT_RENAME || mpp->action =
=3D=3D
> > ACT_SWITCHPG_RENAME ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mpp->action =3D=3D ACT_RELOAD_RENAME ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mpp->action =3D=3D ACT_RESIZE_RENAME) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_co=
nfig();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_=
multipath_config, conf);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alia=
s_old, mpp->alias,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 conf->partition_delim, mpp-
> > >skip_kpartx);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D DOMAP_FAIL)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn r;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0switch (mpp->action) {
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_REJECT:
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_NOTHING:
> > @@ -916,6 +924,7 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return DOMAP_EXIST;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_SWITCHPG:
> > +=A0=A0=A0=A0=A0=A0=A0case ACT_SWITCHPG_RENAME:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_switchgroup(mpp->ali=
as, mpp->bestpg);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * we may have avoided =
reinstating paths because
> > there where in
> > @@ -942,6 +951,7 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RELOAD:
> > +=A0=A0=A0=A0=A0=A0=A0case ACT_RELOAD_RENAME:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_set_max_sectors_k=
b(mpp, 1);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->ghost_delay_ti=
ck > 0 && pathcount(mpp,
> > PATH_UP))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->ghost_delay_tick =3D 0;
> > @@ -949,6 +959,7 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RESIZE:
> > +=A0=A0=A0=A0=A0=A0=A0case ACT_RESIZE_RENAME:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_set_max_sectors_k=
b(mpp, 1);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->ghost_delay_ti=
ck > 0 && pathcount(mpp,
> > PATH_UP))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->ghost_delay_tick =3D 0;
> > @@ -956,29 +967,10 @@ int domap(struct multipath *mpp, char *params,
> > int is_daemon)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RENAME:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_co=
nfig();
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_=
multipath_config, conf);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alia=
s_old, mpp->alias,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 conf->partition_delim, mpp-
> > >skip_kpartx);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0case ACT_FORCERENAME:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_co=
nfig();
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_=
multipath_config, conf);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alia=
s_old, mpp->alias,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 conf->partition_delim, mpp-
> > >skip_kpartx);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (r) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
ysfs_set_max_sectors_kb(mpp, 1);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (mpp->ghost_delay_tick > 0 &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 pathcount(mpp, PATH_UP))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0mpp->ghost_delay_tick =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
 =3D dm_addmap_reload(mpp, params, 0);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0default:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D DOMAP_FAIL;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > diff --git a/libmultipath/configure.h b/libmultipath/configure.h
> > index 2bf73e65..9d935db3 100644
> > --- a/libmultipath/configure.h
> > +++ b/libmultipath/configure.h
> > @@ -18,9 +18,11 @@ enum actions {
> > =A0=A0=A0=A0=A0=A0=A0=A0ACT_RENAME,
> > =A0=A0=A0=A0=A0=A0=A0=A0ACT_CREATE,
> > =A0=A0=A0=A0=A0=A0=A0=A0ACT_RESIZE,
> > -=A0=A0=A0=A0=A0=A0=A0ACT_FORCERENAME,
> > +=A0=A0=A0=A0=A0=A0=A0ACT_RELOAD_RENAME,
> > =A0=A0=A0=A0=A0=A0=A0=A0ACT_DRY_RUN,
> > =A0=A0=A0=A0=A0=A0=A0=A0ACT_IMPOSSIBLE,
> > +=A0=A0=A0=A0=A0=A0=A0ACT_RESIZE_RENAME,
> > +=A0=A0=A0=A0=A0=A0=A0ACT_SWITCHPG_RENAME,
> > =A0};
> > =A0
> > =A0/*
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

