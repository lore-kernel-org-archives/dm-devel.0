Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34316C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:24:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B15FA20784
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B15FA20784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609788259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XC411rUNsincmSTFY6o1VbNqlivzU3hQdhU6ix6wcnQ=;
	b=eGh93NxRNhzABESyNcw3IYW+5uQgtLWmecYHwTkJx4lJbllEBCQx5RDvxar/CHw5NNl3AC
	kojxu+yGfytQy+uR46EFSh4D0WuYkxOkhRqhkFthei8V0EP2VcBNi1JlsTjhjxUUblUmRv
	F5BTVjAzUB3gjxk9mb0irjD0FlrLDDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-SEVNU4lANA6JK3shD-uZWQ-1; Mon, 04 Jan 2021 14:24:17 -0500
X-MC-Unique: SEVNU4lANA6JK3shD-uZWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B80D61842145;
	Mon,  4 Jan 2021 19:24:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ECEA71C8D;
	Mon,  4 Jan 2021 19:24:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 073FF180954D;
	Mon,  4 Jan 2021 19:24:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104JOAIV025352 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 14:24:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CA5755D9D5; Mon,  4 Jan 2021 19:24:10 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F27B5D9C6;
	Mon,  4 Jan 2021 19:24:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 104JO5Va016160; 
	Mon, 4 Jan 2021 13:24:06 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 104JO5mi016159;
	Mon, 4 Jan 2021 13:24:05 -0600
Date: Mon, 4 Jan 2021 13:24:05 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20210104192405.GS3103@octiron.msp.redhat.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-5-git-send-email-bmarzins@redhat.com>
	<f85cd35716780e8e2dfe096bc7789762376efc18.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <f85cd35716780e8e2dfe096bc7789762376efc18.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/6] libmultipath: ignore multipaths sections
 without wwid option
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18, 2020 at 11:30:41PM +0000, Martin Wilck wrote:
> On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> > "multipathd show config local" was crashing in find_mp_by_wwid() if
> > the multipath configuration included a multipaths section that did
> > not set a wwid option. There is no reason to keep a mpentry that
> > didn't set its wwid. Remove it in merge_mptable().
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/config.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index 9f3cb38d..a643703e 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -509,6 +509,13 @@ void merge_mptable(vector mptable)
> >  =09int i, j;
> > =20
> >  =09vector_foreach_slot(mptable, mp1, i) {
> > +=09=09/* drop invalid multipath configs */
> > +=09=09if (!mp1->wwid) {
> > +=09=09=09condlog(0, "multipaths config section missing
> > wwid");
> > +=09=09=09vector_del_slot(mptable, i--);
> > +=09=09=09free_mpe(mp1);
> > +=09=09=09continue;
> > +=09=09}
> >  =09=09j =3D i + 1;
> >  =09=09vector_foreach_slot_after(mptable, mp2, j) {
> >  =09=09=09if (strcmp(mp1->wwid, mp2->wwid))
>=20
> Wouldn't you need to check mp2->wwid, too?

Oops. Yeah, strcmp() is undefined with NULL, so that needs a check.
BTW, I noticed that added this one to you upstream-queue branch, even
though you didn't ack it, while not adding patch 5/6 (multipathd: Fix
multipathd stopping on shutdown), even though you did ack it. Was this
intentional?

At any rate, since this is already in upstream-queue, I'll just post a
follow-up that checks mp2->wwid, before calling strcmp()

-Ben
=20
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

