Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39399C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 30 Mar 2022 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648650885;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8LFQLfUJz22EkbOwtzdfSz3VcxrfaBtuwXwg2RQGRE4=;
	b=WFIaSMfHiZC92rgt9wuGR8Bf2liIgiVwDmRvXGpJEbN291pqD8xhPrnlmKmeyF6iVjT6Np
	YGoxFhT0GhgaMqmOvqXpOnMSs68Ue+56m9JzbA4MC5vDQsyRdSvAi9W9aksP1CnuRs+9e0
	Uuhrv3jtlxwV3e3nrsUIvXkWyD3tf94=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-WFzW_as2Oa6tehOaKrszVQ-1; Wed, 30 Mar 2022 10:34:43 -0400
X-MC-Unique: WFzW_as2Oa6tehOaKrszVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BD7428078DF;
	Wed, 30 Mar 2022 14:34:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54D472166B4C;
	Wed, 30 Mar 2022 14:34:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AEB619451F3;
	Wed, 30 Mar 2022 14:34:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 250D719466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Mar 2022 14:34:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08FB7400E11D; Wed, 30 Mar 2022 14:34:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E6338400E43D;
 Wed, 30 Mar 2022 14:34:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22UEY5MB031921;
 Wed, 30 Mar 2022 09:34:05 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22UEY5pF031920;
 Wed, 30 Mar 2022 09:34:05 -0500
Date: Wed, 30 Mar 2022 09:34:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220330143405.GQ24684@octiron.msp.redhat.com>
References: <1648610530-28526-1-git-send-email-bmarzins@redhat.com>
 <f17860010d25b1fa5abee0e6e3b98df2f8319647.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <f17860010d25b1fa5abee0e6e3b98df2f8319647.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [RFC PATCH] multipathd: Don't keep starting TUR
 threads, if they always hang.
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30, 2022 at 09:44:39AM +0000, Martin Wilck wrote:
> On Tue, 2022-03-29 at 22:22 -0500, Benjamin Marzinski wrote:
> > If tur thead hangs, multipathd was simply creating a new thread, and
> > assuming that the old thread would get cleaned up eventually. I have
> > seen a case recently where there were 26000 multipathd threads on a
> > system, all stuck trying to send TUR commands to path devices. The
> > root
> > cause of the issue was a scsi kernel issue, but it shows that the way
> > multipathd currently deals with stuck threads could use some
> > refinement.
>=20
> Alright, let's start the discussion about dead TUR threads again ;-)
> For my own records, here are links to some previous ML threads:
>=20
> https://listman.redhat.com/archives/dm-devel/2018-September/036102.html
> https://listman.redhat.com/archives/dm-devel/2018-October/036156.html
> https://listman.redhat.com/archives/dm-devel/2018-October/036159.html
> https://listman.redhat.com/archives/dm-devel/2018-October/036240.html
> https://listman.redhat.com/archives/dm-devel/2018-October/036362.html
>=20
> Have you assessed why the SCSI issues were causing indefinite hangs?
> Was it just the TUR command hanging forever in the kernel, or some
> other issue?

Yeah, all the threads are stuck in the kernel, waiting for either a
response to their command, or to be timed out, which isn't happening for
some reason yet to be determined.
=20
> I have seen similar issues in the past; they were also related to SCSI
> problems, IIRC. I used to think that this is just a symptom: The "dead"
> threads are detached and consume a minimal amount of non-shared memory
> (they are a pain when analyzing a crash dump, though).
>=20
> But I agree, just continuing to start new threads forever isn't
> optimal.
>=20
> >=20
> > Now, when one tur thread hangs, multipathd will act as it did before.
> > If a second one in a row hangs, multipathd will instead wait for it
> > to
> > complete before starting another thread. Once the thread completes,
> > the
> > count is reset.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/checkers/tur.c | 23 +++++++++++++++++++++--
> > =A01 file changed, 21 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index c93e4625..1bcb7576 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -26,6 +26,7 @@
> > =A0
> > =A0#define TUR_CMD_LEN 6
> > =A0#define HEAVY_CHECK_COUNT=A0=A0=A0=A0=A0=A0 10
> > +#define MAX_NR_TIMEOUTS 1
>=20
> Why did you choose 1? Perhaps we should make a few more attempts?

Oops. I forgot to include the Notes when formatting my patch (I need to
make that the default). Here they are:

Notes:

    I'd be interested in knowing what people think of this solution. I'm
    open to making multipathd start more threads before it gives up. We
    also could make multipathd save the contexts from the stalled
    threads, so that when it stops creating new ones, instead of just
    waiting for the last thread to complete, it could start up again as
    soon as any of the outstanding threads completed.  We could also
    consider not stopping creating new threads entirely, but instead
    having a delay before we create a new checker thread, where we wait
    for the last thread to complete.  If the delay doubled after evey
    consecutive timeout, the number of threads created would stay at a
    more reasonable level until someone got around to looking into what
    was going wrong. Thoughts?

But to answer your question, there was no obvious number to choose, and
you can make the case that if it fails once, that's a fluke. If it fails
twice in a row, then it's likely to keep faiing. But I'm fine with
picking a bigger number, or any of the other possibilities I listed. I
just wanted to throw something out as a starting point.

-Ben


> Other than that, this looks ok to me (assuming you've tested with the
> code from bdf55d6, or something similar).

Yep. I tested it with the zombie tur checker tests, with different
sleep seconds and intervals.

> Martin
>=20
>=20
> > =A0
> > =A0enum {
> > =A0=A0=A0=A0=A0=A0=A0=A0MSG_TUR_RUNNING =3D CHECKER_FIRST_MSGID,
> > @@ -54,6 +55,7 @@ struct tur_checker_context {
> > =A0=A0=A0=A0=A0=A0=A0=A0int holders; /* uatomic access only */
> > =A0=A0=A0=A0=A0=A0=A0=A0int msgid;
> > =A0=A0=A0=A0=A0=A0=A0=A0struct checker_context ctx;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned int nr_timeouts;
> > =A0};
> > =A0
> > =A0int libcheck_init (struct checker * c)
> > @@ -358,8 +360,23 @@ int libcheck_check(struct checker * c)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (uatomic_read(&ct->h=
olders) > 1) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* The thread has been cancelled but hasn't
> > quit. */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ct->nr_timeouts =3D=3D MAX_NR_TIMEOUTS) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%d:%d : waiting for
> > stalled tur thread to finish",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0major(ct->devt), minor(ct-
> > >devt));
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ct->nr_timeouts++;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0/*
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* The thread has been cancelled but hasn't
> > quit.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* Don't start new threads until the last
> > once has
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* finished.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
*/
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ct->nr_timeouts > MAX_NR_TIMEOUTS) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0c->msgid =3D MSG_TUR_TIMEOUT;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return PATH_TIMEOUT;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
t->nr_timeouts++;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* Start a new thread while the old one is
> > stalled.
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * We have to prevent it from interfering
> > with the new
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * thread. We create a new context and leave
> > the old
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 * one with the stale thread, hoping it will
> > clean up
> > @@ -375,13 +392,15 @@ int libcheck_check(struct checker * c)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (libcheck_init(c) !=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_UNCHECKED;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
(struct tur_checker_context *)c->context)-
> > >nr_timeouts =3D ct->nr_timeouts;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!uatomic_sub_return(&ct->holders, 1))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* It did terminate, eventually */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0cleanup_context(ct);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0ct =3D c->context;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
t->nr_timeouts =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Start new TUR checke=
r */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&ct-=
>lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tur_status =3D ct->stat=
e =3D PATH_PENDING;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

