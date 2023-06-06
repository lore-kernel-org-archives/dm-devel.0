Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F939C7EE29
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686065599;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zogLwrrgMUMVqNO/Bml8G4mL/v20+I1V8dMOoMv1mB4=;
	b=V2aS98eA9qSguQ2FBIwHSG9XMx+YK25mtO1ZnbC/huMxeH++39VTLXGUeQ2sbV+QYZ05se
	tPM3E7r2ybb4lHACDW/+boDcznsekkll3KSdcm4BExvoeyVojZtLHUO6OR65D1VK4wR9ER
	9byMjUHvinF50MkJtPyeGDl1RN2mwn0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-XqG_nr4INhaC5QPg00vn7g-1; Tue, 06 Jun 2023 11:33:16 -0400
X-MC-Unique: XqG_nr4INhaC5QPg00vn7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E93811761;
	Tue,  6 Jun 2023 15:33:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C9EA8400E400;
	Tue,  6 Jun 2023 15:33:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 976D219465BC;
	Tue,  6 Jun 2023 15:33:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B81C19465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 15:33:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F2472166B26; Tue,  6 Jun 2023 15:33:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34B012166B25;
 Tue,  6 Jun 2023 15:33:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356FX9vh027481;
 Tue, 6 Jun 2023 10:33:09 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356FX9Pu027480;
 Tue, 6 Jun 2023 10:33:09 -0500
Date: Tue, 6 Jun 2023 10:33:08 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230606153308.GX24096@octiron.msp.redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-4-git-send-email-bmarzins@redhat.com>
 <83a2e2ce4669e4c031a49ac9b9ebc064a25c42bd.camel@suse.com>
 <20230605182252.GS24096@octiron.msp.redhat.com>
 <2086808fcdafd070a65db00805c3b9beacb4fed8.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <2086808fcdafd070a65db00805c3b9beacb4fed8.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 06, 2023 at 02:08:04PM +0000, Martin Wilck wrote:
> On Mon, 2023-06-05 at 13:22 -0500, Benjamin Marzinski wrote:
> > On Wed, May 31, 2023 at 04:27:25PM +0000, Martin Wilck wrote:
> > > On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> > > > For multipath devices with path group policies other than
> > > > group_by_prio,
> > > > multipathd wasn't updating all the paths' priorities when calling
> > > > need_switch_pathgroup(), even in cases where it likely was
> > > > necessary.
> > > > When a path just becomes usable again, all paths' priorities get
> > > > updated
> > > > by update_prio().=A0 But if the priority changes on a path that is
> > > > already
> > > > up, the other paths' priorities only get updated if the multipath
> > > > device
> > > > uses the group_by_prio path_grouping_policy, otherwise
> > > > need_switch_pathgroup() is called with refresh set to 0. But if
> > > > the
> > > > priority of the checked path has changed, then likely so have the
> > > > priorities of other paths. Since the pathgroup's priority is the
> > > > average
> > > > of its paths' priorities, changing the priority of just one path
> > > > may
> > > > not
> > > > change the average enough to reorder the pathgroups.
> > > >=20
> > > > Instead, set refresh in need_switch_pathgroup() if the priorty
> > > > has
> > > > changed to something other than PRIO_UNDEF (which usually means
> > > > an
> > > > error
> > > > has occured) and the priorities of the other paths haven't
> > > > already
> > > > been
> > > > updated by update_prio().
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > > =A0multipathd/main.c | 35 +++++++++++++++++++++--------------
> > > > =A01 file changed, 21 insertions(+), 14 deletions(-)
> > > >=20
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index bdeffe76..e7c272ad 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -2575,20 +2575,27 @@ check_path (struct vectors * vecs, struct
> > > > path * pp, unsigned int ticks)
> > > > =A0
> > > > =A0=A0=A0=A0=A0=A0=A0=A0if (marginal_changed)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map=
(pp->mpp, vecs, 1);
> > > > -=A0=A0=A0=A0=A0=A0=A0else if (update_prio(pp, new_path_up) &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (pp->mpp->pgpolicyfn =3D=3D (pgpoli=
cyfn *)group_by_prio)
> > > > &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgfailback =3D=3D -FAIL=
BACK_IMMEDIATE) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path =
priorities changed.
> > > > reloading",
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->alias);
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(p=
p->mpp, vecs, !new_path_up);
> > > > -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, 0))=
 {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailba=
ck > 0 &&
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_u=
p || pp->mpp->failback_tick <=3D 0))
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0pp->mpp->failback_tick =3D
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgf=
ailback =3D=3D -
> > > > FAILBACK_IMMEDIATE
> > > > > >=20
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 (chkr_new_path_up &&
> > > > followover_should_failback(pp)))
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0switch_pathgroup(pp->mpp);
> > > > +=A0=A0=A0=A0=A0=A0=A0else {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D =
update_prio(pp, new_path_up);
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D=
 (!new_path_up && prio_changed
> > > > &&
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> > > > +
> > >=20
> > > I have always found it confusing that we recalculate the priorities
> > > in
> > > two functions (update_prio() and need_switch_pathgroup()), passing
> > > boolean flags back and forth. IMO we should move this logic to
> > > update_prio(), so that we don't need to refresh any priorities in
> > > need_switch_pathgroup() any more. after determining the prio of the
> > > "primary" path device, update_prio() has all the information
> > > it needs to figure out whether priorities of other paths must be
> > > refreshed.
> > >=20
> > > That would even make the code easier to understand, IMO.
> > >=20
> > > Regards
> > > Martin
> >=20
> > So the difference in this code between when we choose to update all
> > the
> > paths' prios for the group_by_prio case, and when we choose to update
> > all the paths' prios for the other pgpolicies comes down to how we
> > treat
> > PRIO_UNDEF. I didn't change the group_by_prio behavior.
>=20
> My comment may have caused confusion, sorry. I just wanted to point out
> that we could make the logic clearer by moving it into update_prio(),
> on top of what you did, as in "while we're at it".=20
>=20
> >  So right now,
> > for group_by_prio devices, we will update all the paths' priorities
> > if
> > the checked path switches priorities to PRIO_UNDEF. My question is,
> > "Is
> > this the right thing to do?"
> >=20
> > In the best case, if the prioritizer fails on one path, it will fail
> > on
> > all the other paths in the pathgroup as well, so that they stay
> > together. In the worst case it will fail on paths in other
> > pathgroups,
> > so that incorrect paths get grouped together. Granted, I'm not sure
> > how
> > much of a difference it makes in the worst case, since the other
> > priorities would get checked eventually, and would get placed in the
> > wrong group then.
>=20
> No matter what we do, it's always just the state at some point in time.
> If we update all priorities, we are as close to the "real" state of the
> hardware as possible, at this given instant. We don't know what's going
> to happen next. Paths could quickly recover and provide useful prio
> values, but they might as well not. Or their prio could change, and the
> value we just obtained would be obsolete. It makes no sense to reason
> about the "future".
>=20
> > Perhaps it would be better to treat PRIO_UNDEF like PATH_PENDING,
> > where
> > we will continue to use the old priority if we get a PRIO_UNDEF
> > result.
>=20
> Let's have a look where PRIO_UNDEF occurs. Unless I'm overlooking
> something, get_prio() returns PRIO_UNDEF if no prio algorithm is
> selected, or if the prio algo returns an error *and* the path state as
> returned by path_offline() is neither DOWN nor PENDING. From
> path_offline(), this means the state must be either PATH_REMOVED (no
> point in trying a assign a prio, UNDEF is ok) or PATH_UP, i.e.
> "running". The last case is strange. It can mean a very short-lived
> failure, in which case=A0we could consider retrying prio_getprio() from
> get_prio(), or a general problem with the prio algorithm for the path,
> in which case UNDEF would again be ok (but then, how did the same
> prioritizer assign a valid priority previously?).
>=20
> I think that none of these cases really justifies treating UNDEF like
> PENDING, except _maybe_ the "running" case. If that's agreed, we should
> probably just change the way this case is handled in get_prio().

I actually think that the only case where it might NOT make sense to
treat UNDEF like PENDING is the "running" case. If the device no longer
exists, I would argue that keeping the old priority is the best option.
Why do the extra work associated with a path changing priority, when in
reality the path is gone? In all the other cases, I don't see how a path
ever gets out of PRIO_UNDEF to start with. So keeping the old priority
is the same as just returning PRIO_UNDEF in those cases. The only case
were the PRIO_UNDEF is really interesting is the "running" case. If we
think that this is a short lived failure, then doing a bunch of work and
moving the paths around might just be wasted effort. When the failure
resolves, the path might still have the priority it previously had. If
the path wasn't previously in PRIO_UNDEF, then we can be pretty sure
that the existing priority is a temporary error, but we don't know how
long it error will last, and whether the priority after the error will
be the same or different than it was before.

I'm also not sure that retrying the priority immediately is the right
answer, since that might just waste more time and give us the same
result. Waiting till the next path check makes more sense to me. If this
is a very short lived error, and the path did change priority then we
may well not need to wait till the next path_check() for it to get
updated. Assuming this path changed its priority, then likely other
paths will be changing priorities too. When we check them, if the
failure has resolved, we will end up rechecking this path while
refreshing all the priorities.

I don't want to make it seem like I feel like this (option 4 below)
is the obviously right answer. But I do feel like it is just as valid an
option as 1) or 2).

=20
> > The choices are:
> > 1. make both the group_by_prio and the non-group_by_prio cases
> > recheck
> > =A0=A0 all paths on PRIO_UNDEF (this keeps the group_by_prio behavior t=
he
> > =A0=A0 same).
> > 2. make both cases NOT recheck all paths on PRIO_UNDEF.
> > 3. keep the destinction between the two (make update_prio() check the
> > =A0=A0 pgplicy, and act accordingly)
> > 4. Make paths keep their previous priority when they would have
> > returned
> > =A0=A0 PRIO_UNDEF, so we never switch to PRIO_UNDEF.
> >=20
> > All the choices except 3 seem reasonable. 1 keeps things how they are
> > for group_by_prio. 2 leans towards moving PRIO_UNDEF paths out of
> > their
> > current pathgroup.=A0 4 leans towards keeping PRIO_UNDEF paths in their
> > current pathgroup.
>=20
> I agree that 3) makes no sense. I argued above that I don't think 4)
> does, either. Wrt 1) vs. 2), we should realize that the checker loop
> will eventually run over all paths anyway.  With 1) we are as close as
> possible to the kernel state at any instant, but we may recalculate
> priorities (and possibly regroup) repeatedly during a single checker
> loop iteration, which is suboptimal [1]. With 2), we might never have
> the map in a correct state, not even after the checker loop has
> finished.
>=20
> I think we should go with 1), and consider a later change where we just
> set a marker in the checker loop, and do prio updates / path regrouping
> once per map after the checker loop has finished. This requires more
> changes for the checker loop though, and is out of scope for your
> current patch set.
>=20
> I wouldn't worry too much about group_by_prio. Regrouping is by design
> with this grouping policy, and it's expected that this results in
> incorrect grouping, at least temporarily. Where this is undesirable,=20
> your new group_by_tpg will come to the rescue.

I ended up going with 1) when in my next version, on the groups that
this keeps our behavior the same, and nobody has been complaining about
it.
=20
> > The other question is, what do we do for the delayed case. Right now,
> > once we finish waiting for our delay in deferred_failback_tick(), we
> > automatically refresh the priorities of all the devices in our
> > need_switch_pathgroup() call.=A0 We could add an update_prio() call
> > before
> > it to keep this behavior, but if we are already refreshing all the
> > paths' priorities when we need to, I'm not sure that it's necessary
> > to
> > do it again here.
>=20
> Well if we calculated priorities in update_prio() only as I suggested
> in my previous post, we'd call update_prio() in this code path and
> change the way need_switch_pathgroup() works. But I admit I haven't
> thought this through, and it can be done in a separate set, anyway.

I ended up not refreshing the priorities in deferred_failback_tick(). We
will have already done it in check_path() if necessary, either when we
started the deferred timer, or if we notice it's necessary while waiting
for the timeout.

-Ben

> Regards
> Martin
>=20
> [1] it seems dumb to reason about "performance" here, but we both know
> that execution time in the checker loop can become critical if there
> are lots of path devices.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

