Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F226FC77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686073120;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5B7tM9kLPo1UglSw+wdpZXokC3nqv69Yn/IW0nZYQrs=;
	b=TEpZORYHJo1qIeYWNhnz/mZLtuBfi+l2Y9x3O+r9nj8IVM3Jtm8nmPvChan7m33TS54wkk
	+XhYYGXfCrC7UNXhYTf0Q0Z+7DheiM4lqefttLNWA2JR9d0PhQKHssVUFvybcZty4JfkZT
	DeK/y6Nif4sOltL+5H2Q8WVmTUMEnYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-CxKU2omBOwOBGpKsix9_6A-1; Tue, 06 Jun 2023 13:38:39 -0400
X-MC-Unique: CxKU2omBOwOBGpKsix9_6A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2234101A53B;
	Tue,  6 Jun 2023 17:38:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F332A1121315;
	Tue,  6 Jun 2023 17:38:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4AD519465BC;
	Tue,  6 Jun 2023 17:38:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B62119465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 17:38:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88A614021AA; Tue,  6 Jun 2023 17:38:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B7F492B00;
 Tue,  6 Jun 2023 17:38:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 356Hc8Vd028019;
 Tue, 6 Jun 2023 12:38:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 356Hc7PX028018;
 Tue, 6 Jun 2023 12:38:07 -0500
Date: Tue, 6 Jun 2023 12:38:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230606173807.GB24096@octiron.msp.redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
 <20230605190807.GT24096@octiron.msp.redhat.com>
 <20230606044215.GV24096@octiron.msp.redhat.com>
 <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
 <20230606155402.GY24096@octiron.msp.redhat.com>
 <ee1290d1c2b5adf734a6df243707b3546d261f0e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <ee1290d1c2b5adf734a6df243707b3546d261f0e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

On Tue, Jun 06, 2023 at 04:32:13PM +0000, Martin Wilck wrote:
> On Tue, 2023-06-06 at 10:54 -0500, Benjamin Marzinski wrote:
> > On Tue, Jun 06, 2023 at 02:55:27PM +0000, Martin Wilck wrote:
> > > On Mon, 2023-06-05 at 23:42 -0500, Benjamin Marzinski wrote:
> > > > On Mon, Jun 05, 2023 at 02:08:07PM -0500, Benjamin Marzinski
>=20
> > > > =20
> > > > Actually, after looking into this more, pushing those two
> > > > functions
> > > > together makes the logic more confusing. Plus select_path_group()
> > > > is
> > > > used by multiple other functions that don't need to check if the
> > > > path
> > > > groups are out of order.
> > >=20
> > > Hm. Can it happen at all that select_path_group() returns something
> > > other than=A01 but path_groups_in_order() returns true?=A0
> >=20
> > Yes. It might even be the common case. Say a switch goes down and all
> > the paths in the high priority pathgroup fail. The kernel will switch
> > over to a lower priority pathgroup. As long as those paths work, it
> > won't automatically switch back to the high priority pathgroup when
> > we
> > tell it that those failed paths have recovered. It's multipath's job
> > to
> > tell it when to proactively switch pathgroups. Since multipath
> > doesn't
> > update the priority of failed paths, the pathgroups should still look
> > the same (unless you use group_by_prio and the path fails between
> > checking the state and running the prioritizer, in which case you
> > will
> > likely get a PRIO_UNDEF and reconfigure the pathgroups, but that's
> > the
> > thing group_by_tpg is trying to resolve).=20
>=20
> Ok, this is subtle; it's caused by the fact that path_groups_in_order()
> ignores the ordering of PGs with pgp->prio =3D PRIO_UNDEF (which will be
> the prio of a PG with only failed paths), whereas select_path_group()
> will ignore such PGs it in a different way - by never selecting them.
> I hope I understand correctly now.
>=20
> I have to say this is confusing. We have different concepts of how path
> priority and path state together affect the PG priority, and we apply
> these different concepts in different parts of the code. I'm not saying
> it's wrong, but at the moment I'm too confused to tell if it's right.

It might make sense to have these be even more different.  Perhaps
select_path_group should stay the same but sort_pathgroups() and
path_groups_in_order() should just look at the priorities of the paths
that have a non-PRIO_UNDEF priority and use the total number of paths
for tie-breakers. This would mean that they would order the pathgroups
how they should be when everything is working correctly. That way if
something forces the kernel to pick a new pathgroup (which is likely the
failure of all the paths in the current pathgroup), it will switch to
the pathgroup that, all things being equal, should be the best.
Obviously, if there is another pathgroup of equal prioity with more
usable paths, multipath can tell it to switch to that one, but I assume
that even without group_by_prio, multiple pathgroups with the same
priority will be uncommon.=20

In this situation, it would make sense to call select_path_group() after
calling group_paths(), since the first pathgroup might not currently be
the best pathgroup, if its paths are down. At any rate, it's not
something to worry about in this patchset.

-Ben

> > =A0
> > > If we follow the mindset you layed out in your patch ("the kernel
> > > treats the pathgroups as if they were ordered by priority")
> > > consequently, just determining bestpg is not enough; we'd need to
> > > sort
> > > the PGs every time (except for a user-triggered switchgroup
> > > command).
> > > IMO whenever we reload the map anyway (e.g. in setup_map()) we
> > > should
> > > make sure that the PGs are properly sorted. Using "switch_group"
> > > instead of a full reload is just an optimization because the kernel
> > > operation is more light-weight than a full reload. But as soon as
> > > we
> > > have e.g. a marginal path group, reordering is probably a better
> > > idea
> > > most of the time.
> >=20
> > We already do correctly order the paths in setup_map().
> > setup_map() -> group_paths() -> sort_pathgroup().=A0 Actually, looking
> > at
> > this, I don't see why we even bother to call select_path_group() in
> > setup_map(). The answer will always be 1, since we just sorted them.
> >=20
>=20
> Right. I suppose the call to select_path_groups() predates the one to
> sort_pathgroups().
>=20
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

