Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8257FC7EE24
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685989386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uGeAMfhW+l8oPJOUwPekyQ0slucX/Moq8kSyE3FoaxY=;
	b=AJwp7mqCI3CB77Tu3MXcfgHUN9xwa7Wx0t6CYxsbEKGW6fWJPwE7uvUJE3/lqY86GUxTFo
	YUCt6jKhAh7YXHwOpgTclUsofL7n1zDGyBhllwoTpqWAmx4wRwCg/8KDQlwHKdzZyaWeL5
	rV+ZyVgwLHkvqb4x2dn9ipUbJc6hXJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-v6bwifntO1i_hvOicz50Gg-1; Mon, 05 Jun 2023 14:23:03 -0400
X-MC-Unique: v6bwifntO1i_hvOicz50Gg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E83F802E58;
	Mon,  5 Jun 2023 18:23:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BAFDDC1603B;
	Mon,  5 Jun 2023 18:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77B1619465A3;
	Mon,  5 Jun 2023 18:22:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E6EF01946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 18:22:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE17A40CFD47; Mon,  5 Jun 2023 18:22:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9987040CFD46;
 Mon,  5 Jun 2023 18:22:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 355IMsoB020637;
 Mon, 5 Jun 2023 13:22:54 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 355IMrld020636;
 Mon, 5 Jun 2023 13:22:53 -0500
Date: Mon, 5 Jun 2023 13:22:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230605182252.GS24096@octiron.msp.redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
 <83a2e2ce4669e4c031a49ac9b9ebc064a25c42bd.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <83a2e2ce4669e4c031a49ac9b9ebc064a25c42bd.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: refresh all priorities if
 one has changed
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

On Wed, May 31, 2023 at 04:27:25PM +0000, Martin Wilck wrote:
> On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > For multipath devices with path group policies other than
> > group_by_prio,
> > multipathd wasn't updating all the paths' priorities when calling
> > need_switch_pathgroup(), even in cases where it likely was necessary.
> > When a path just becomes usable again, all paths' priorities get
> > updated
> > by update_prio().=A0 But if the priority changes on a path that is
> > already
> > up, the other paths' priorities only get updated if the multipath
> > device
> > uses the group_by_prio path_grouping_policy, otherwise
> > need_switch_pathgroup() is called with refresh set to 0. But if the
> > priority of the checked path has changed, then likely so have the
> > priorities of other paths. Since the pathgroup's priority is the
> > average
> > of its paths' priorities, changing the priority of just one path may
> > not
> > change the average enough to reorder the pathgroups.
> >=20
> > Instead, set refresh in need_switch_pathgroup() if the priorty has
> > changed to something other than PRIO_UNDEF (which usually means an
> > error
> > has occured) and the priorities of the other paths haven't already
> > been
> > updated by update_prio().
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0multipathd/main.c | 35 +++++++++++++++++++++--------------
> > =A01 file changed, 21 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index bdeffe76..e7c272ad 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2575,20 +2575,27 @@ check_path (struct vectors * vecs, struct
> > path * pp, unsigned int ticks)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (marginal_changed)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp-=
>mpp, vecs, 1);
> > -=A0=A0=A0=A0=A0=A0=A0else if (update_prio(pp, new_path_up) &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (pp->mpp->pgpolicyfn =3D=3D (pgpolicyfn=
 *)group_by_prio) &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfailback =3D=3D -FAILBACK=
_IMMEDIATE) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path prio=
rities changed. reloading",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->mpp->alias);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->m=
pp, vecs, !new_path_up);
> > -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, 0)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailback >=
 0 &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_up ||=
 pp->mpp->failback_tick <=3D 0))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->mpp->failback_tick =3D
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgfailb=
ack =3D=3D -FAILBACK_IMMEDIATE
> > ||
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
(chkr_new_path_up &&
> > followover_should_failback(pp)))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
witch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D upda=
te_prio(pp, new_path_up);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D (!n=
ew_path_up && prio_changed &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> > +
>=20
> I have always found it confusing that we recalculate the priorities in
> two functions (update_prio() and need_switch_pathgroup()), passing
> boolean flags back and forth. IMO we should move this logic to
> update_prio(), so that we don't need to refresh any priorities in
> need_switch_pathgroup() any more. after determining the prio of the
> "primary" path device, update_prio() has all the information
> it needs to figure out whether priorities of other paths must be
> refreshed.
>=20
> That would even make the code easier to understand, IMO.
>=20
> Regards
> Martin

So the difference in this code between when we choose to update all the
paths' prios for the group_by_prio case, and when we choose to update
all the paths' prios for the other pgpolicies comes down to how we treat
PRIO_UNDEF. I didn't change the group_by_prio behavior. So right now,
for group_by_prio devices, we will update all the paths' priorities if
the checked path switches priorities to PRIO_UNDEF. My question is, "Is
this the right thing to do?"

In the best case, if the prioritizer fails on one path, it will fail on
all the other paths in the pathgroup as well, so that they stay
together. In the worst case it will fail on paths in other pathgroups,
so that incorrect paths get grouped together. Granted, I'm not sure how
much of a difference it makes in the worst case, since the other
priorities would get checked eventually, and would get placed in the
wrong group then.

Perhaps it would be better to treat PRIO_UNDEF like PATH_PENDING, where
we will continue to use the old priority if we get a PRIO_UNDEF result.

The choices are:
1. make both the group_by_prio and the non-group_by_prio cases recheck
   all paths on PRIO_UNDEF (this keeps the group_by_prio behavior the
   same).
2. make both cases NOT recheck all paths on PRIO_UNDEF.
3. keep the destinction between the two (make update_prio() check the
   pgplicy, and act accordingly)
4. Make paths keep their previous priority when they would have returned
   PRIO_UNDEF, so we never switch to PRIO_UNDEF.

All the choices except 3 seem reasonable. 1 keeps things how they are
for group_by_prio. 2 leans towards moving PRIO_UNDEF paths out of their
current pathgroup.  4 leans towards keeping PRIO_UNDEF paths in their
current pathgroup.

The other question is, what do we do for the delayed case. Right now,
once we finish waiting for our delay in deferred_failback_tick(), we
automatically refresh the priorities of all the devices in our
need_switch_pathgroup() call.  We could add an update_prio() call before
it to keep this behavior, but if we are already refreshing all the
paths' priorities when we need to, I'm not sure that it's necessary to
do it again here.

Thoughts?
-Ben

>=20
>=20
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (prio_changed &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgpoli=
cyfn =3D=3D (pgpolicyfn
> > *)group_by_prio &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfail=
back =3D=3D -FAILBACK_IMMEDIATE) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s: path priorities changed.
> > reloading",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->alias);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eload_and_sync_map(pp->mpp, vecs,
> > !new_path_up);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pa=
thgroup(pp->mpp,
> > need_refresh)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (pp->mpp->pgfailback > 0 &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 (new_path_up || pp->mpp->failback_tick <=3D
> > 0))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->failback_tick =3D
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse if (pp->mpp->pgfailback =3D=3D -
> > FAILBACK_IMMEDIATE ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 (chkr_new_path_up &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp)))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0}
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

