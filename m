Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543B7C7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686167018;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+Rcy+Xqy2Yj4ENzWeTEwSDmwSF4Pk7w9S+dn2ABz6Dc=;
	b=LyZjrM1TTz67jhew2A9R9V2Wy9oV70gx4eeMKGn10b2btUxm+MwghDzCxKmocDqxWqcrUd
	LFhw4tVK9zDS3aMsDpUxxukCWeNJ1kmGonKt9e8n+ZvPzVSyfug149B2FoQh8PzF4EGNNd
	rrxA7Qm0c5vw00Rg2mLdk3dj8/OEueM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-j2H9-DIxObanU_msltVOAA-1; Wed, 07 Jun 2023 15:43:35 -0400
X-MC-Unique: j2H9-DIxObanU_msltVOAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70D75811E7F;
	Wed,  7 Jun 2023 19:43:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2ECC1603B;
	Wed,  7 Jun 2023 19:43:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2456119452C3;
	Wed,  7 Jun 2023 19:43:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E30919465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 19:43:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0096340CFD47; Wed,  7 Jun 2023 19:43:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D369240CFD46;
 Wed,  7 Jun 2023 19:43:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 357JhQX9005459;
 Wed, 7 Jun 2023 14:43:26 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 357JhPHf005458;
 Wed, 7 Jun 2023 14:43:25 -0500
Date: Wed, 7 Jun 2023 14:43:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230607194325.GF32239@octiron.msp.redhat.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-11-git-send-email-bmarzins@redhat.com>
 <3c00f23075b5a15a0a514b176231ec9c388bf3c7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3c00f23075b5a15a0a514b176231ec9c388bf3c7.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH V2 10/11] multipathd: reload map if the path
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 07, 2023 at 06:59:21PM +0000, Martin Wilck wrote:
> On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
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
> > =A0multipathd/main.c | 69 ++++++++++++++++++++++++++++++++++++++-------
> > --
> > =A01 file changed, 57 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index f603d143..05c74e9e 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -395,11 +395,46 @@ void
> > put_multipath_config(__attribute__((unused)) void *arg)
> > =A0=A0=A0=A0=A0=A0=A0=A0rcu_read_unlock();
> > =A0}
> > =A0
> > +/*
> > + * The path group orderings that this function finds acceptible are
> > different
> > + * from now select_path_group determines the best pathgroup. The
> > idea here is
> > + * to only trigger a kernel reload when it is obvious that the
> > pathgroups would
> > + * be out of order, even if all the paths were usable. Thus
> > pathgroups with
> > + * PRIO_UNDEF are skipped, and the number of enabled paths doesn't
> > matter here.
> > + */
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
>=20
> I still don't get the logic here. What's the point of using
> seen_marginal_pg if it is always false? See my previous reply to v1 of
> this patch.

That's because the logic's all messed up. It should be:

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal && !seen_mar=
ginal_pg) {
                       seen_marginal_pg =3D true;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_p=
rio =3D pgp->priority;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0contin=
ue;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}

You reset the priority to make sure that the marginal pgs are in
priority order as well, but you need to reset it to the first marginal
pg's priority. And yes, once you see a marginal pg, you should set
seen_marginal_pg.

Also the (seen_marginal_pg && !pgp->marginal) check should happen first
in the loop. Even if the path group doesn't currently have any usable
paths, non-marginal pgs should always be before marginal pgs.

I'll post a V3 patchset.

-Ben

>=20
> Regards
> Martin
>=20
>=20
>=20
> > +
> > =A0static int
> > -need_switch_pathgroup (struct multipath * mpp)
> > +need_switch_pathgroup (struct multipath * mpp, bool *need_reload)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > @@ -411,10 +446,9 @@ need_switch_pathgroup (struct multipath * mpp)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> > -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0return (*need_reload || mpp->bestpg !=3D mpp->nex=
tpg);
> > =A0}
> > =A0
> > =A0static void
> > @@ -1963,20 +1997,26 @@ ghost_delay_tick(struct vectors *vecs)
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
> > need_switch_pathgroup(mpp))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!mpp->failback_tick &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 need_switch_pathgroup(mpp, &need_reload))
> > {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(mpp,
> > vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0}
> > @@ -2219,6 +2259,7 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups, marginal_changed =3D 0=
;
> > =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> > +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK || pp->ini=
tialized =3D=3D
> > INIT_PARTIAL ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized =3D=3D INIT_REQ=
UESTED_UDEV) && !pp->mpp) ||
> > @@ -2548,13 +2589,17 @@ check_path (struct vectors * vecs, struct
> > path * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path pr=
iorities changed. reloading",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->alias);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp-=
>mpp, vecs);
> > -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp)) {
> > +=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, &need_r=
eload)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailback=
 > 0 &&
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_up =
|| pp->mpp->failback_tick <=3D 0))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->failback_tick =3D pp->mpp->pgfailback
> > + 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgfai=
lback =3D=3D -FAILBACK_IMMEDIATE
> > ||
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
(chkr_new_path_up &&
> > followover_should_failback(pp)))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
witch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
(chkr_new_path_up &&
> > followover_should_failback(pp))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (need_reload)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->mpp, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0}
> > @@ -2680,7 +2725,7 @@ unlock:
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

