Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65573C7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686066862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WH49pyERfdsW5fK16jl3Qvt4Wga72O5z0CHdXEc9etw=;
	b=cNI7kqRHp1ARlaeHrKUslBKK27z8Vt1apP7IHsqBg/9snQXfx0xnRVrZIep9ckzqmRHL2V
	UkV3fOReNkLBe0Qe/Tw+hdT54Q4oAXUlNMlSew4Sxsx3dkvAXRUZKZFPsCU4Y1N/K904oG
	wEnfIvOjAOfofEbIR1Arsr2ZL2ixxmA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-YDqiNWkOOtCFC4TxhlaJlA-1; Tue, 06 Jun 2023 11:54:20 -0400
X-MC-Unique: YDqiNWkOOtCFC4TxhlaJlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DBFF85A5BD;
	Tue,  6 Jun 2023 15:54:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFC561121314;
	Tue,  6 Jun 2023 15:54:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9952A19465BC;
	Tue,  6 Jun 2023 15:54:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A0ED19465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 15:54:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07BE02026D6A; Tue,  6 Jun 2023 15:54:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDE2B2026D49;
 Tue,  6 Jun 2023 15:54:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356Fs3uU027505;
 Tue, 6 Jun 2023 10:54:03 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356Fs2Uv027504;
 Tue, 6 Jun 2023 10:54:02 -0500
Date: Tue, 6 Jun 2023 10:54:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230606155402.GY24096@octiron.msp.redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
 <20230605190807.GT24096@octiron.msp.redhat.com>
 <20230606044215.GV24096@octiron.msp.redhat.com>
 <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

On Tue, Jun 06, 2023 at 02:55:27PM +0000, Martin Wilck wrote:
> On Mon, 2023-06-05 at 23:42 -0500, Benjamin Marzinski wrote:
> > On Mon, Jun 05, 2023 at 02:08:07PM -0500, Benjamin Marzinski wrote:
> > > On Wed, May 31, 2023 at 04:27:30PM +0000, Martin Wilck wrote:
> > > > On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > > > > need_switch_pathgroup() only checks if the currently used
> > > > > pathgroup
> > > > > is
> > > > > not the highest priority pathgroup. If it isn't, all multipathd
> > > > > does
> > > > > is
> > > > > instruct the kernel to switch to the correct pathgroup.=A0
> > > > > However, the
> > > > > kernel treats the pathgroups as if they were ordered by
> > > > > priority.
> > > > > When
> > > > > the kernel runs out of paths to use in the currently selected
> > > > > pathgroup,
> > > > > it will start checking the pathgroups in order until it finds
> > > > > one
> > > > > with
> > > > > usable paths.
> > > > >=20
> > > > > need_switch_pathgroup() should also check if the pathgroups are
> > > > > out
> > > > > of
> > > > > order, and if so, multipathd should reload the map to reorder
> > > > > them
> > > > > correctly.
> > > > >=20
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > > ---
> > > > > =A0libmultipath/libmultipath.version |=A0 5 ++++
> > > > > =A0libmultipath/switchgroup.c=A0=A0=A0=A0=A0=A0=A0 | 27 +++++++++=
+++++++++++++
> > > > > =A0libmultipath/switchgroup.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > > > > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 38 +++++++++++++++++++++--
> > > > > ------
> > > > > --
> > > > > =A04 files changed, 59 insertions(+), 12 deletions(-)
> > > > >=20
> > > > > diff --git a/libmultipath/libmultipath.version
> > > > > b/libmultipath/libmultipath.version
> > > > > index 8f72c452..38074699 100644
> > > > > --- a/libmultipath/libmultipath.version
> > > > > +++ b/libmultipath/libmultipath.version
> > > > > @@ -237,3 +237,8 @@ global:
> > > > > =A0local:
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0*;
> > > > > =A0};
> > > > > +
> > > > > +LIBMULTIPATH_19.1.0 {
> > > > > +global:
> > > > > +=A0=A0=A0=A0=A0=A0=A0path_groups_in_order;
> > > > > +} LIBMULTIPATH_19.0.0;
> > > > > diff --git a/libmultipath/switchgroup.c
> > > > > b/libmultipath/switchgroup.c
> > > > > index b1e1f39b..b1180839 100644
> > > > > --- a/libmultipath/switchgroup.c
> > > > > +++ b/libmultipath/switchgroup.c
> > > > > @@ -7,6 +7,33 @@
> > > > > =A0#include "structs.h"
> > > > > =A0#include "switchgroup.h"
> > > > > =A0
> > > > > +bool path_groups_in_order(struct multipath *mpp)
> > > > > +{
> > > > > +=A0=A0=A0=A0=A0=A0=A0int i;
> > > > > +=A0=A0=A0=A0=A0=A0=A0struct pathgroup *pgp;
> > > > > +=A0=A0=A0=A0=A0=A0=A0bool seen_marginal_pg =3D false;
> > > > > +=A0=A0=A0=A0=A0=A0=A0int last_prio =3D INT_MAX;
> > > > > +
> > > > > +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(mpp->pg) < 2)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> > > > > +
> > > > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pg, pgp, i) {
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* skip pgs with PR=
IO_UNDEF, since this is
> > > > > likely
> > > > > temporary */
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pgp->paths || =
pgp->priority =3D=3D PRIO_UNDEF)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0continue;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal &=
& !seen_marginal_pg) {
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0last_prio =3D INT_MAX;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0continue;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (seen_marginal_p=
g && !pgp->marginal)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0return false;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->priority >=
 last_prio)
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0return false;
> > > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_prio =3D pgp->=
priority;
> > > > > +=A0=A0=A0=A0=A0=A0=A0}
> > > > > +=A0=A0=A0=A0=A0=A0=A0return true;
> > > > > +}
> > > > > +
> > > > > =A0void path_group_prio_update(struct pathgroup *pgp)
> > > > > =A0{
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > > > > diff --git a/libmultipath/switchgroup.h
> > > > > b/libmultipath/switchgroup.h
> > > > > index 9365e2e2..43dbb6c9 100644
> > > > > --- a/libmultipath/switchgroup.h
> > > > > +++ b/libmultipath/switchgroup.h
> > > > > @@ -1,2 +1,3 @@
> > > > > =A0void path_group_prio_update (struct pathgroup * pgp);
> > > > > =A0int select_path_group (struct multipath * mpp);
> > > > > +bool path_groups_in_order(struct multipath *mpp);
> > > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > > index e7c272ad..2ea7c76b 100644
> > > > > --- a/multipathd/main.c
> > > > > +++ b/multipathd/main.c
> > > > > @@ -396,7 +396,7 @@ void
> > > > > put_multipath_config(__attribute__((unused))
> > > > > void *arg)
> > > > > =A0}
> > > > > =A0
> > > > > =A0static int
> > > > > -need_switch_pathgroup (struct multipath * mpp, int refresh)
> > > > > +need_switch_pathgroup (struct multipath * mpp, int refresh,
> > > > > bool
> > > > > *need_reload)
> > > > > =A0{
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> > > > > @@ -404,6 +404,7 @@ need_switch_pathgroup (struct multipath *
> > > > > mpp,
> > > > > int refresh)
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> > > > > =A0
> > > > > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > > =A0
> > > > > @@ -430,10 +431,9 @@ need_switch_pathgroup (struct multipath *
> > > > > mpp,
> > > > > int refresh)
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > > > > =A0
> > > > > =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> > > > > -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> > > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > > > > +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp)=
;
> > > >=20
> > > > This will start another loop over the path groups. Can we just
> > > > integrate the path_groups_in_order() logic into the loop right
> > > > here?
> > > >=20
> > >=20
> > > Sure
> >=20
> > Actually, after looking into this more, pushing those two functions
> > together makes the logic more confusing. Plus select_path_group() is
> > used by multiple other functions that don't need to check if the path
> > groups are out of order.
>=20
> Hm. Can it happen at all that select_path_group() returns something
> other than=A01 but path_groups_in_order() returns true?=A0

Yes. It might even be the common case. Say a switch goes down and all
the paths in the high priority pathgroup fail. The kernel will switch
over to a lower priority pathgroup. As long as those paths work, it
won't automatically switch back to the high priority pathgroup when we
tell it that those failed paths have recovered. It's multipath's job to
tell it when to proactively switch pathgroups. Since multipath doesn't
update the priority of failed paths, the pathgroups should still look
the same (unless you use group_by_prio and the path fails between
checking the state and running the prioritizer, in which case you will
likely get a PRIO_UNDEF and reconfigure the pathgroups, but that's the
thing group_by_tpg is trying to resolve).=20
=20
> If we follow the mindset you layed out in your patch ("the kernel
> treats the pathgroups as if they were ordered by priority")
> consequently, just determining bestpg is not enough; we'd need to sort
> the PGs every time (except for a user-triggered switchgroup command).
> IMO whenever we reload the map anyway (e.g. in setup_map()) we should
> make sure that the PGs are properly sorted. Using "switch_group"
> instead of a full reload is just an optimization because the kernel
> operation is more light-weight than a full reload. But as soon as we
> have e.g. a marginal path group, reordering is probably a better idea
> most of the time.

We already do correctly order the paths in setup_map().
setup_map() -> group_paths() -> sort_pathgroup().  Actually, looking at
this, I don't see why we even bother to call select_path_group() in
setup_map(). The answer will always be 1, since we just sorted them.

-Ben
=20
> I agree that that would be another patch set, but I think that
> determining the best path group and checking whether the groups are
> correctly ordered are very closely related tasks.
>=20
> But it's not a religious matter to me, so proceed with what you
> consider best at this time.
>=20
> > There's no reason for path_groups_in_order to be in libmultipath,
> > since
> > it's only needed by multipathd. I'll fix that. But I would rather not
> > join it with select_path_group(). Since we just loop over the
> > pathgroups
> > and not the paths within them, we will likely go through the loop a
> > couple of times, and we don't actually perform any costly actions
> > during
> > the loops that would make combining them look more attractive. The
> > performance gains for need_switch_pathgroup() aren't worth making the
> > logic harder to follow (and the minor performance hits when we don't
> > need to check the order), IMHO.=20
> >=20
>=20
> Regards,
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

