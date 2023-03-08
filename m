Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CE85C64EC4
	for <dm-devel@archiver.kernel.org>; Wed,  8 Mar 2023 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678307882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lSr/8vRP9RPz2NqPZnj6if1T+ihqais4BuUHEFfbtHY=;
	b=Wo9KrRrFO0fY46WieynTaBhWYBS2b7RYa/rH0JKus1mcqgunM1U5dxEcaNx9/wLeunMJti
	UsHukIBENwOSLFZYbOTYu6bbJ98R8MF6KL7h+2lcR12E8iEGRs73O/TdlLNhk/iWEsiw2J
	GTXmq7VF7UdtVojKkvZeCM4WBnj2KFU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-b8tA4nYrMnOP4hPn_9PhHg-1; Wed, 08 Mar 2023 15:38:01 -0500
X-MC-Unique: b8tA4nYrMnOP4hPn_9PhHg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 163FD80D0E3;
	Wed,  8 Mar 2023 20:38:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C2A9E14171B6;
	Wed,  8 Mar 2023 20:37:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C3F919465BD;
	Wed,  8 Mar 2023 20:37:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C0A019465B5
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Mar 2023 20:37:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3208C15BAD; Wed,  8 Mar 2023 20:37:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1442C15BA0;
 Wed,  8 Mar 2023 20:37:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 328KbuHC026672;
 Wed, 8 Mar 2023 14:37:56 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 328KbtW3026671;
 Wed, 8 Mar 2023 14:37:55 -0600
Date: Wed, 8 Mar 2023 14:37:55 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230308203755.GA19878@octiron.msp.redhat.com>
References: <1678229374-18788-1-git-send-email-bmarzins@redhat.com>
 <1678229374-18788-4-git-send-email-bmarzins@redhat.com>
 <9c92591f721abdb9451280b865930b4a16693ed7.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <9c92591f721abdb9451280b865930b4a16693ed7.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 3/3] libmultipath: reset nr_timeouts if we
 freed the context
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
 "brian@purestorage.com" <brian@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 06:17:05PM +0000, Martin Wilck wrote:
> On Tue, 2023-03-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > If a the tur checker creates a new context because an old thread is
> > still running, but the old thread finishes before the checker drops
> > the old context, the checker should reset nr_timeouts to 0, since
> > the old thread did complete in time.
>=20
> This looks strange to me. First of all, the old thread _did_ timeout,
> otherwise we wouldn't be in this code path at all. And even if you say
> this timeout shouldn't count, as the thread isn't in stalled state any
> more, shouldn't you just decrease nr_timeouts by 1? The fact that
> _this_ thread terminated doesn't tell us anything about other hanging
> threads.

We can't track the old threads once we drop the old context.  So
instead, we just assume that if the last thread we created did complete
we're back to a normal state, and reset nr_timeouts to 0. This change is
just extending that same logic to the case where the old thread didn't
complete until the last possible moment where we could find that out.

The MAX_NR_TIMEOUTS code was added because a user ran into a situation
where a scsi kernel issue made TUR commands block uninterruptibly
forever, and multipathd kept making more threads, tens of thousnds of
them. The goal was to stop creating threads if two in a row haven't
completed, and wait for the last thread to complete. It's not the most
robust solution possible, but I think it's good enough. We could revist
the whole solution, but the way things are, nr_timeouts =3D 1 was supposed
to mean that, as far as we know, the last thread was cancelled but
didn't complete, and we are going to try one more thread before stopping
and waiting. I'm just fixing to code to take care of the corner case
where we find out that the last thread did complete when we drop the old
context.=20

-Ben
=20
> Martin
>=20
>=20
>=20
>=20
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/checkers/tur.c | 4 +++-
> > =A01 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index a19becf5..fe6a2f14 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -406,9 +406,11 @@ int libcheck_check(struct checker * c)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0((struct tur_checker_context *)c->context)-
> > >nr_timeouts =3D ct->nr_timeouts;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!uatomic_sub_return(&ct->holders, 1))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!uatomic_sub_return(&ct->holders, 1)) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* It did terminate, eventually */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0cleanup_context(ct);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0((struct tur_checker_context *)c-
> > >context)->nr_timeouts =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0ct =3D c->context;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

