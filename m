Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4350C77B73
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685992115;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J/fuJcyLZ5Lu1B5zRlwPcMLN3yhUx/7aiy7jy3+vKGI=;
	b=fpEIs7415NgdjMPAmGD/Mj1vZPF/GNsYDddLptcCRNIsXxd8lM8E658PgJMTqxZ1oVsjZV
	By/5gYN+UXs2WYdXV+CssMSP1K+/ukv6wpONRcUFgh96N8LgUH9GPck41IcF6NFpSs7hhD
	la13XyhqjFNdHqAO7Dx87uRJLqxYe4k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-6N4zM70ZPySagKK8feZHbw-1; Mon, 05 Jun 2023 15:08:32 -0400
X-MC-Unique: 6N4zM70ZPySagKK8feZHbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D3EC85A5AA;
	Mon,  5 Jun 2023 19:08:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24F8C1121315;
	Mon,  5 Jun 2023 19:08:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0290A19465A3;
	Mon,  5 Jun 2023 19:08:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 039E31946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 19:08:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01C309E8F; Mon,  5 Jun 2023 19:08:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D35419E8E;
 Mon,  5 Jun 2023 19:08:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 355J88Ee020860;
 Mon, 5 Jun 2023 14:08:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 355J87Es020859;
 Mon, 5 Jun 2023 14:08:07 -0500
Date: Mon, 5 Jun 2023 14:08:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230605190807.GT24096@octiron.msp.redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 04:27:30PM +0000, Martin Wilck wrote:
> On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > need_switch_pathgroup() only checks if the currently used pathgroup
> > is
> > not the highest priority pathgroup. If it isn't, all multipathd does
> > is
> > instruct the kernel to switch to the correct pathgroup.=A0 However, the
> > kernel treats the pathgroups as if they were ordered by priority.
> > When
> > the kernel runs out of paths to use in the currently selected
> > pathgroup,
> > it will start checking the pathgroups in order until it finds one
> > with
> > usable paths.
> >=20
> > need_switch_pathgroup() should also check if the pathgroups are out
> > of
> > order, and if so, multipathd should reload the map to reorder them
> > correctly.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/libmultipath.version |=A0 5 ++++
> > =A0libmultipath/switchgroup.c=A0=A0=A0=A0=A0=A0=A0 | 27 +++++++++++++++=
+++++++
> > =A0libmultipath/switchgroup.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | =
38 +++++++++++++++++++++--------
> > --
> > =A04 files changed, 59 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 8f72c452..38074699 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -237,3 +237,8 @@ global:
> > =A0local:
> > =A0=A0=A0=A0=A0=A0=A0=A0*;
> > =A0};
> > +
> > +LIBMULTIPATH_19.1.0 {
> > +global:
> > +=A0=A0=A0=A0=A0=A0=A0path_groups_in_order;
> > +} LIBMULTIPATH_19.0.0;
> > diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
> > index b1e1f39b..b1180839 100644
> > --- a/libmultipath/switchgroup.c
> > +++ b/libmultipath/switchgroup.c
> > @@ -7,6 +7,33 @@
> > =A0#include "structs.h"
> > =A0#include "switchgroup.h"
> > =A0
> > +bool path_groups_in_order(struct multipath *mpp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup *pgp;
> > +=A0=A0=A0=A0=A0=A0=A0bool seen_marginal_pg =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0int last_prio =3D INT_MAX;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(mpp->pg) < 2)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pg, pgp, i) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* skip pgs with PRIO_UND=
EF, since this is likely
> > temporary */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pgp->paths || pgp->p=
riority =3D=3D PRIO_UNDEF)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal && !see=
n_marginal_pg) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ast_prio =3D INT_MAX;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (seen_marginal_pg && !=
pgp->marginal)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->priority > last_=
prio)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_prio =3D pgp->priori=
ty;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return true;
> > +}
> > +
> > =A0void path_group_prio_update(struct pathgroup *pgp)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > diff --git a/libmultipath/switchgroup.h b/libmultipath/switchgroup.h
> > index 9365e2e2..43dbb6c9 100644
> > --- a/libmultipath/switchgroup.h
> > +++ b/libmultipath/switchgroup.h
> > @@ -1,2 +1,3 @@
> > =A0void path_group_prio_update (struct pathgroup * pgp);
> > =A0int select_path_group (struct multipath * mpp);
> > +bool path_groups_in_order(struct multipath *mpp);
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index e7c272ad..2ea7c76b 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -396,7 +396,7 @@ void put_multipath_config(__attribute__((unused))
> > void *arg)
> > =A0}
> > =A0
> > =A0static int
> > -need_switch_pathgroup (struct multipath * mpp, int refresh)
> > +need_switch_pathgroup (struct multipath * mpp, int refresh, bool
> > *need_reload)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > @@ -404,6 +404,7 @@ need_switch_pathgroup (struct multipath * mpp,
> > int refresh)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > @@ -430,10 +431,9 @@ need_switch_pathgroup (struct multipath * mpp,
> > int refresh)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> > -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp);
>=20
> This will start another loop over the path groups. Can we just
> integrate the path_groups_in_order() logic into the loop right here?
>=20

Sure
-Ben

>=20
>=20
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0return (*need_reload || mpp->bestpg !=3D mpp->nex=
tpg);
> > =A0}
> > =A0
> > =A0static void
> > @@ -1982,20 +1982,26 @@ ghost_delay_tick(struct vectors *vecs)
> > =A0}
> > =A0
> > =A0static void
> > -deferred_failback_tick (vector mpvec)
> > +deferred_failback_tick (struct vectors *vecs)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int i;
> > +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpvec, mpp, i) {
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (vecs->mpvec, mpp, i) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * deferred failback ge=
tting sooner
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->pgfailback > 0=
 && mpp->failback_tick > 0) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mpp->failback_tick--;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!mpp->failback_tick &&
> > need_switch_pathgroup(mpp, 1))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!mpp->failback_tick &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 need_switch_pathgroup(mpp, 1,
> > &need_reload)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(mpp,
> > vecs, 0);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0}
> > @@ -2579,6 +2585,7 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D up=
date_prio(pp, new_path_up);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D (=
!new_path_up && prio_changed &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (prio_changed &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgpo=
licyfn =3D=3D (pgpolicyfn
> > *)group_by_prio &&
> > @@ -2586,15 +2593,22 @@ check_path (struct vectors * vecs, struct
> > path * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(2, "%s: path priorities changed.
> > reloading",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0reload_and_sync_map(pp->mpp, vecs,
> > !new_path_up);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pa=
thgroup(pp->mpp,
> > need_refresh)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pa=
thgroup(pp->mpp,
> > need_refresh,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &n=
eed_reload)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (pp->mpp->pgfailback > 0 &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 (new_path_up || pp->mpp->failback_tick <=3D
> > 0))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->failback_tick =3D
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0else if (pp->mpp->pgfailback =3D=3D -
> > FAILBACK_IMMEDIATE ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 (chkr_new_path_up &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp)))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->mpp=
,
> > vecs,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > !need_refresh &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > !new_path_up);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > @@ -2720,7 +2734,7 @@ unlock:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cl=
eanup_lock, &vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(ve=
cs->mpvec);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(ve=
cs);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retry_count_tick(vecs->=
mpvec);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0missing_uev_wait_tick(v=
ecs);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ghost_delay_tick(vecs);
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

