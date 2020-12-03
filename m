Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BBEC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:52:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 68880221EC
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 20:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68880221EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607028758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sl6l2ZCv2O34bRMjN21GyIkr0/X0e1PLB12qJCzfOB4=;
	b=ToEyA/VagMibJWorDwL2JmhQqNBuBGKBoAqHfc8LMQ2vaFNylfsqsCRWxXdqBGhC0L3aNk
	y5E/vp+47CSX1JKVjJ4q5OicTsoPyjkAs0N+p3qOYTq2gQJz9lTKXm/tYL0S0PaQiE6Qv1
	k83Oqi2LgwsrQVUIXrmcHBrcmFu1hKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-uhRAgE7MNvSXpcOHxAbUhQ-1; Thu, 03 Dec 2020 15:52:18 -0500
X-MC-Unique: uhRAgE7MNvSXpcOHxAbUhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D86E858181;
	Thu,  3 Dec 2020 20:52:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0650C189B8;
	Thu,  3 Dec 2020 20:52:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AE61180954D;
	Thu,  3 Dec 2020 20:52:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3Kq9iK031550 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 15:52:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D8A45C1CF; Thu,  3 Dec 2020 20:52:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E995D5C1B4;
	Thu,  3 Dec 2020 20:52:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0B3Kq4Fh029431; 
	Thu, 3 Dec 2020 14:52:04 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0B3Kq4CG029430;
	Thu, 3 Dec 2020 14:52:04 -0600
Date: Thu, 3 Dec 2020 14:52:03 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20201203205203.GH3103@octiron.msp.redhat.com>
References: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
	<1582143705-20886-2-git-send-email-bmarzins@redhat.com>
	<6d9b937e46499c5d35921d2eb62943c987b46425.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <6d9b937e46499c5d35921d2eb62943c987b46425.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/5] multipath: fix issues found by
 compiling with gcc 10
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2020 at 01:54:57PM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> On Wed, 2020-02-19 at 14:21 -0600, Benjamin Marzinski wrote:
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  kpartx/dasd.c        |  6 +++---
> >  libmultipath/print.c | 16 ++++++++--------
> >  multipath/main.c     |  2 +-
> >  3 files changed, 12 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> > index 1486ccaa..14b9d3aa 100644
> > --- a/kpartx/dasd.c
> > +++ b/kpartx/dasd.c
> > @@ -186,7 +186,7 @@ read_dasd_pt(int fd, __attribute__((unused))
> > struct slice all,
> >  =09=09goto out;
> >  =09}
> > =20
> > -=09if ((!info.FBA_layout) && (!strcmp(info.type, "ECKD")))
> > +=09if ((!info.FBA_layout) && (!memcmp(info.type, "ECKD", 4)))
> >  =09=09memcpy (&vlabel, data, sizeof(vlabel));
> >  =09else {
> >  =09=09bzero(&vlabel,4);
>=20
> are you using different compiler / warning flags here than we usually do?

When building rhel and fedora packages, there are some flags that differ
from the upstream set.  Unfortunately, when I just tried rebuilding the
package with these fixes removed, I didn't hit any compiler errors.
Perhaps I just noticed these while working on something else, and they
got included in this commit on accident. Sadly I don't remember the
details anymore.

-Ben
>=20
> I just found that with the standard flags, gcc 10 does *not* complain abo=
ut
> the old (badly broken, noting that info.type is declared as char[4]) code=
.
> Nor has any other compiler so far, although we're using pretty verbose=20
> warning options.
>=20
> Regards
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

