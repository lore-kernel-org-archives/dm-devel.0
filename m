Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19D9C28D13
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661190400;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E84LtxTErwZIFuUaU8yRNUOAqoMdQG2QEjbGTu1KGmI=;
	b=eorfqLL1SUpm+bt8S5FE5ua+jgIixaa5NeHFBPagY8T0GIzCh2Kiu/JhlwSYWuZF/ePFzi
	G60JxlOa/aF2qAJhEwEkxUwUC2oVJ1dKwEK7/Bbl5/niRXDKPFRgv7M9K/9RYz7izFkp8p
	c9yayIazH9xxqMW1f7LrSb5Hsiau/cw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-r8pCkO3ONYu1RkGrywVzNw-1; Mon, 22 Aug 2022 13:46:39 -0400
X-MC-Unique: r8pCkO3ONYu1RkGrywVzNw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA28E85A585;
	Mon, 22 Aug 2022 17:46:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E506492C3B;
	Mon, 22 Aug 2022 17:46:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 467D61946A47;
	Mon, 22 Aug 2022 17:46:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 352471946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 17:46:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E82D51121319; Mon, 22 Aug 2022 17:46:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA1471121315;
 Mon, 22 Aug 2022 17:46:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 27MHkXND006611;
 Mon, 22 Aug 2022 12:46:33 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 27MHkWhR006610;
 Mon, 22 Aug 2022 12:46:32 -0500
Date: Mon, 22 Aug 2022 12:46:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220822174632.GT10602@octiron.msp.redhat.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <1660769316-5302-4-git-send-email-bmarzins@redhat.com>
 <e0f0516a08bf8fe5dddf058e5b9c9fad494340ba.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e0f0516a08bf8fe5dddf058e5b9c9fad494340ba.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH V2 3/6] multipathd: Occasionally allow
 waiters to interrupt checking paths
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "wuguanghao3@huawei.com" <wuguanghao3@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 22, 2022 at 04:15:01PM +0000, Martin Wilck wrote:
> On Wed, 2022-08-17 at 15:48 -0500, Benjamin Marzinski wrote:
> > If there are a very large number of paths that all get checked at the
> > same time, it is possible for the path checkers to starve out other
> > vecs->lock users, like uevent processing. To avoid this, if the path
> > checkers are taking a long time, checkerloop now occasionally unlocks
> > and allows other vecs->lock waiters to run.
> >=20
> > In order to make sure that path checking is always making real
> > progress,
> > checkerloop() only checks if it should unlock every 128 path checks.
> > To
> > check, it sees if there are waiters and more than a second has passed
> > since it acquired the vecs->lock. If both of these are true, it drops
> > the lock and calls nanosleep() to schedule.
> >=20
> > When checkerloop() reacquires the lock, it may no longer be at the
> > correct place in the vector. While paths can be deleted from any
> > point
> > of the pathvec, they can only be added at the end. This means that
> > the
> > next path to check must be between its previous location and the
> > start
> > of the vector. To help determine the correct starting place,
> > checkerloop() marks each path as not checked at the start of each
> > checker loop. New paths start in the unchecked state. As paths are
> > checked, they are marked as such. If the checker loop is interrupted,
> > when it reacquires the lock, it will iterate backwards from the last
> > location in checked to the start of the vector. The first path it
> > finds
> > that is marked as checked must be the last path it checked.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/structs.h |=A0 1 +
> > =A0multipathd/main.c=A0=A0=A0=A0=A0 | 82 ++++++++++++++++++++++++++++++=
+++-------
> > --
> > =A02 files changed, 67 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index a6a09441..9d4fb9c8 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -351,6 +351,7 @@ struct path {
> > =A0=A0=A0=A0=A0=A0=A0=A0int fast_io_fail;
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int dev_loss;
> > =A0=A0=A0=A0=A0=A0=A0=A0int eh_deadline;
> > +=A0=A0=A0=A0=A0=A0=A0bool is_checked;
> > =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> > =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 71079113..37c04018 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2548,6 +2548,11 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks)
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0}
> > +enum checker_state {
> > +=A0=A0=A0=A0=A0=A0=A0CHECKER_STARTING,
> > +=A0=A0=A0=A0=A0=A0=A0CHECKER_RUNNING,
> > +=A0=A0=A0=A0=A0=A0=A0CHECKER_FINISHED,
> > +};
> > =A0
> > =A0static void *
> > =A0checkerloop (void *ap)
> > @@ -2555,7 +2560,6 @@ checkerloop (void *ap)
> > =A0=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > =A0=A0=A0=A0=A0=A0=A0=A0int count =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0unsigned int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct timespec last_time;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > =A0=A0=A0=A0=A0=A0=A0=A0int foreign_tick =3D 0;
> > @@ -2581,8 +2585,9 @@ checkerloop (void *ap)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0while (1) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct timespec diff_ti=
me, start_time, end_time;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int num_paths =3D 0, stri=
ct_timing, rc =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int num_paths =3D 0, stri=
ct_timing, rc =3D 0, i =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned int ticks =3D =
0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0enum checker_state checke=
r_state =3D CHECKER_STARTING;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (set_config_state(DA=
EMON_RUNNING) !=3D
> > DAEMON_RUNNING)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/* daemon shutdown */
> > @@ -2603,22 +2608,67 @@ checkerloop (void *ap)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (use_watchdog)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0sd_notify(0, "WATCHDOG=3D1");
> > =A0#endif
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (checker_state !=3D=
 CHECKER_FINISHED) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u=
nsigned int paths_checked =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
truct timespec chk_start_time;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_lock, &vecs->lock);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (vecs=
->pathvec, pp, i) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
c =3D check_path(vecs, pp, ticks);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (rc < 0) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: check_path() failed,
> > removing",
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0vector_del_slot(vecs->pathvec, i);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0free_path(pp);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0i--;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0num_paths +=3D rc;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_cleanup_push(cleanup_lock, &vecs-
> > >lock);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ock(&vecs->lock);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_testcancel();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
et_monotonic_time(&chk_start_time);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (checker_state =3D=3D CHECKER_STARTING) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec,
> > pp, i)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->is_checked =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0i =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0checker_state =3D CHECKER_RUNNING;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * Paths could have been removed
> > since we
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * dropped the lock. Find the path to
> > continue
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * checking at. Since paths can be
> > removed from
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * anywhere in the vector, but can
> > only be added
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * at the end, the last checked path
> > must be
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * between its old location, and the
> > start or
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * the vector.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (i >=3D VECTOR_SIZE(vecs->pathvec))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i =3D VECTOR_SIZE(vecs-
> > >pathvec) - 1;
>=20
> What if VECTOR_SIZE(vecs->pathvec) =3D=3D 0? Maybe you should catch that =
in
> the while () condition above?

I could for clarity if you want, but the code is correct as is. If
VECTOR_SIZE() is 0, then i will start at -1. This will cause the while()
loop to immediately exit, since VECTOR_SLOT() checks for i < 0. Right
after the while loop, i gets bumped up to start checking at the first
device (which of course isn't there).  It's the same logic as what
happens if the while() loop searches through the entire pathvec, and
doesn't find any checked paths.  Obviously, the empty vector case does a
bit of unnecessary work after finding out that the vector is empty, and
I could add something like

if (VECTOR_SIZE(vecs->pathvec) =3D=3D 0) {
=09checker_state =3D CHECKER_FINISHED;
=09goto unlock;
}

If you'd prefer.

-Ben

>=20
> Martin
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

