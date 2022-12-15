Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 713C7C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 15 Dec 2022 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671117665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BWQ1rZf1SeZJYcF9RMIyB7uC7U2mfNds5GmTWMdnVV8=;
	b=HR4iZo1UojUYXC9JBAme9vbLfQcP54SG/850e7TnemQmgclynocL8bUq2Jjfx8o6MakedC
	Q9TsN/IoqXRNGIxh3EJYyyrNtoUptwcflA/C/Y69OSXcghxip+vJB25WnEnaSxHo1nh4fw
	ldO84MMvJDQfYtkSb0/EKp622fTBLZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-466HLb4bMbmKCDXD-yUYVA-1; Thu, 15 Dec 2022 10:21:02 -0500
X-MC-Unique: 466HLb4bMbmKCDXD-yUYVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F16985CBEA;
	Thu, 15 Dec 2022 15:20:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AECEB1121319;
	Thu, 15 Dec 2022 15:20:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D5A719466DF;
	Thu, 15 Dec 2022 15:20:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8710819465B2
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Dec 2022 15:20:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 97D092166B2C; Thu, 15 Dec 2022 15:20:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF542166B29;
 Thu, 15 Dec 2022 15:20:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BFFKUIV020693;
 Thu, 15 Dec 2022 09:20:30 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BFFKT0T020692;
 Thu, 15 Dec 2022 09:20:29 -0600
Date: Thu, 15 Dec 2022 09:20:29 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221215152029.GE6245@octiron.msp.redhat.com>
References: <1671053900-14923-1-git-send-email-bmarzins@redhat.com>
 <204a11c0a4cabffea117638b597ba0f99b0dacad.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <204a11c0a4cabffea117638b597ba0f99b0dacad.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH V2 0/3] multipath config fixes
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

On Thu, Dec 15, 2022 at 11:34:20AM +0000, Martin Wilck wrote:
> On Wed, 2022-12-14 at 15:38 -0600, Benjamin Marzinski wrote:
> > The first two patches are a cleanup and a fix for a memory leak in
> > the
> > config code. The third patch improves multipath's validation of the
> > strings it passes directly into the table, features, path_selector,
> > and
> > hardware_handler.=A0 These three strings all have argument counts, and
> > getting them wrong causes the kernel to parse the table incorrectly.
> > When this happens the table load fails, but the error messages from
> > the
> > kernel are often completely unhelpful.=A0 A bad argument count will
> > cause
> > the rest of the table to be parsed incorrectly, and the kernel might
> > not
> > hit an unworkable token till later in the parsing.=A0 Multipath now
> > makes
> > sure that the count matches the actual number of arguments that it is
> > passing.
> >=20
> > V2 Changes (based on suggestions from Martin Wilck):
> > 1/3: unrolled loop in validate_config_strvec() to explicitly check
> > the
> > =A0=A0=A0=A0=A0 possible quote strings
> > 3/3: spaces is now a "const char * const" and doesn't include '\n'
>=20
> Hm, my suggestion was wrong. It shouldn't be a pointer at all but an
> array:
>=20
> =09static const char spaces[] =3D " \f\r\t\v";
>=20
> "static" makes sure it's only initialized once, and ends
> up in the .rodata section.=20

Dumb question. If you explicitly make it an array, does that mean the
compiler will always allocate separate memory for it, even if there is
another identical const array? With multiple pointers to the same const
string, the compiler will often just have one string in memory, which all
the pointers refer to. Not sure if the same thing happens when they're
defined as arrays.

-Ben

>=20
> In practice, there's no significant difference between either version.=A0
> So, for the set:
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

