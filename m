Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3792CC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:33:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C7AB9603E9
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C7AB9603E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636133607;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QohIcXCjJrLtpbYonqh4oHt3XN4Y/tl2KWstBKlXN9I=;
	b=ZRrNgy7487v8FiirlT8WcTx4IYd2y6Wpl5fEimbrbMCWG3BcAoWK+RQQZVtGpHbxTAveNI
	I96CDLSHJ9XVhl4iXL+ZZuneGOIFBfqs37Gxat+5kQ44p6XF5YUTcm3qDte1kuTFldaQk1
	SarVBD6kRMZaFsF0qTL0rR1whxsH9Bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-_NAVUfYwMVaoSI70CrsjlQ-1; Fri, 05 Nov 2021 13:33:26 -0400
X-MC-Unique: _NAVUfYwMVaoSI70CrsjlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AB3C1966320;
	Fri,  5 Nov 2021 17:33:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC955D740;
	Fri,  5 Nov 2021 17:33:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E575E4A703;
	Fri,  5 Nov 2021 17:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5HXE3B006620 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 13:33:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E72B2100164A; Fri,  5 Nov 2021 17:33:14 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52BAA100EA05;
	Fri,  5 Nov 2021 17:33:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5HX3ps011756; 
	Fri, 5 Nov 2021 12:33:03 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5HX2Vb011755;
	Fri, 5 Nov 2021 12:33:02 -0500
Date: Fri, 5 Nov 2021 12:33:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105173301.GG19591@octiron.msp.redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-5-git-send-email-bmarzins@redhat.com>
	<e03bf2dd8395f3d809f3edecfb108c79b85f64a9.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e03bf2dd8395f3d809f3edecfb108c79b85f64a9.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] libmultipath: pass file and line number
 to keyword handlers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 08:55:02PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > This will make it possible for the keyword handlers to print more
> > useful
> > warning messages. It will be used by future patches.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Nit: There's one very long line (349).
>=20
> Apart from that, ack.

It gets removed by "libmultipath: cleanup invalid config handling", but
I can fix it in this patch, if you'd like.

-Ben

>=20
>=20
>=20
> > ---
> > =A0libmultipath/dict.c=A0=A0 | 143 +++++++++++++++++++++++++-----------=
------
> > =A0libmultipath/parser.c |=A0=A0 3 +-
> > =A0libmultipath/parser.h |=A0=A0 2 +-
> > =A03 files changed, 90 insertions(+), 58 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 7a727389..eb2c44c0 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -29,7 +29,7 @@
> > =A0#include "strbuf.h"
> > =A0
> > =A0static int
> > -set_int(vector strvec, void *ptr)
> > +set_int(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr;
> > @@ -58,7 +58,7 @@ set_int(vector strvec, void *ptr)
> > =A0}
> > =A0
> > =A0static int
> > -set_uint(vector strvec, void *ptr)
> > +set_uint(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int *uint_ptr =3D (unsigned int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr, *p;
> > @@ -90,7 +90,7 @@ set_uint(vector strvec, void *ptr)
> > =A0}
> > =A0
> > =A0static int
> > -set_str(vector strvec, void *ptr)
> > +set_str(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > =A0
> > @@ -105,7 +105,7 @@ set_str(vector strvec, void *ptr)
> > =A0}
> > =A0
> > =A0static int
> > -set_yes_no(vector strvec, void *ptr)
> > +set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > @@ -124,7 +124,7 @@ set_yes_no(vector strvec, void *ptr)
> > =A0}
> > =A0
> > =A0static int
> > -set_yes_no_undef(vector strvec, void *ptr)
> > +set_yes_no_undef(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > @@ -187,9 +187,10 @@ static int print_yes_no_undef(struct strbuf *buff,
> > long v)
> > =A0
> > =A0#define declare_def_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -def_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +def_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0#define declare_def_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > @@ -224,12 +225,13 @@ snprint_def_ ## option (struct config *conf,
> > struct strbuf *buff,=A0\
> > =A0
> > =A0#define declare_hw_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -hw_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +hw_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf-
> > >hwtable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0if
> > (!hwe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &hwe-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &hwe->option, file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0#define declare_hw_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > @@ -243,11 +245,12 @@ snprint_hw_ ## option (struct config *conf,
> > struct strbuf *buff,=A0=A0\
> > =A0
> > =A0#define declare_ovr_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -ovr_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +ovr_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf-
> > >overrides)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->overrides-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->overrides->option=
, file,
> > line_nr); \
> > =A0}
> > =A0
> > =A0#define declare_ovr_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > @@ -260,12 +263,13 @@ snprint_ovr_ ## option (struct config *conf,
> > struct strbuf *buff,=A0\
> > =A0
> > =A0#define declare_mp_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -mp_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +mp_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> > >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0if
> > (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0#define declare_mp_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > @@ -277,9 +281,10 @@ snprint_mp_ ## option (struct config *conf, struct
> > strbuf *buff,=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0return function(buff, mpe-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > -static int checkint_handler(struct config *conf, vector strvec)
> > +static int checkint_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_uint(strvec, &conf->checkint);
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_uint(strvec, &conf->checkint, file=
, line_nr);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > @@ -302,9 +307,10 @@ declare_def_snprint(reassign_maps, print_yes_no)
> > =A0declare_def_handler(multipath_dir, set_str)
> > =A0declare_def_snprint(multipath_dir, print_str)
> > =A0
> > -static int def_partition_delim_handler(struct config *conf, vector
> > strvec)
> > +static int def_partition_delim_handler(struct config *conf, vector
> > strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim=
);
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim=
, file,
> > line_nr);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > @@ -334,13 +340,13 @@ static const char * const
> > find_multipaths_optvals[] =3D {
> > =A0};
> > =A0
> > =A0static int
> > -def_find_multipaths_handler(struct config *conf, vector strvec)
> > +def_find_multipaths_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipat=
hs) =3D=3D 0 &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 conf->find_multipaths !=3D FIND_MULTIPA=
THS_UNDEF)
> > +=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipat=
hs, file,
> > line_nr) =3D=3D 0 && conf->find_multipaths !=3D FIND_MULTIPATHS_UNDEF)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > @@ -396,7 +402,8 @@ static int snprint_uid_attrs(struct config *conf,
> > struct strbuf *buff,
> > =A0=A0=A0=A0=A0=A0=A0=A0return total;
> > =A0}
> > =A0
> > -static int uid_attrs_handler(struct config *conf, vector strvec)
> > +static int uid_attrs_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char *val;
> > =A0
> > @@ -597,7 +604,8 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
> > =A0declare_hw_snprint(skip_kpartx, print_yes_no_undef)
> > =A0declare_mp_handler(skip_kpartx, set_yes_no_undef)
> > =A0declare_mp_snprint(skip_kpartx, print_yes_no_undef)
> > -static int def_disable_changed_wwids_handler(struct config *conf,
> > vector strvec)
> > +static int def_disable_changed_wwids_handler(struct config *conf,
> > vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *fi=
le, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > @@ -629,20 +637,23 @@ declare_def_snprint_defstr(enable_foreign,
> > print_str,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 DEFAULT_ENABLE_FOREIGN)
> > =A0
> > =A0static int
> > -def_config_dir_handler(struct config *conf, vector strvec)
> > +def_config_dir_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int li=
ne_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file *=
/
> > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir);
> > +=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir, file, l=
ine_nr);
> > =A0}
> > =A0declare_def_snprint(config_dir, print_str)
> > =A0
> > =A0#define declare_def_attr_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -def_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +def_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, &conf-
> > >attribute_flags);\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, &conf->at=
tribute_flags,
> > \
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0#define declare_def_attr_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
> > @@ -655,12 +666,14 @@ snprint_def_ ## option (struct config *conf,
> > struct strbuf *buff,=A0\
> > =A0
> > =A0#define declare_mp_attr_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -mp_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +mp_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> > >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0if
> > (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, &mpe-
> > >attribute_flags);=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &mpe->option, &mpe-
> > >attribute_flags,=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0#define declare_mp_attr_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0\
> > @@ -673,7 +686,7 @@ snprint_mp_ ## option (struct config *conf, struct
> > strbuf *buff,=A0=A0=A0=A0\
> > =A0}
> > =A0
> > =A0static int
> > -set_mode(vector strvec, void *ptr, int *flags)
> > +set_mode(vector strvec, void *ptr, int *flags, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0mode_t mode;
> > =A0=A0=A0=A0=A0=A0=A0=A0mode_t *mode_ptr =3D (mode_t *)ptr;
> > @@ -694,7 +707,7 @@ set_mode(vector strvec, void *ptr, int *flags)
> > =A0}
> > =A0
> > =A0static int
> > -set_uid(vector strvec, void *ptr, int *flags)
> > +set_uid(vector strvec, void *ptr, int *flags, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0uid_t uid;
> > =A0=A0=A0=A0=A0=A0=A0=A0uid_t *uid_ptr =3D (uid_t *)ptr;
> > @@ -719,7 +732,7 @@ set_uid(vector strvec, void *ptr, int *flags)
> > =A0}
> > =A0
> > =A0static int
> > -set_gid(vector strvec, void *ptr, int *flags)
> > +set_gid(vector strvec, void *ptr, int *flags, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0gid_t gid;
> > =A0=A0=A0=A0=A0=A0=A0=A0gid_t *gid_ptr =3D (gid_t *)ptr;
> > @@ -786,7 +799,7 @@ declare_mp_attr_handler(gid, set_gid)
> > =A0declare_mp_attr_snprint(gid, print_gid)
> > =A0
> > =A0static int
> > -set_undef_off_zero(vector strvec, void *ptr)
> > +set_undef_off_zero(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > @@ -827,7 +840,7 @@ declare_hw_handler(fast_io_fail,
> > set_undef_off_zero)
> > =A0declare_hw_snprint(fast_io_fail, print_undef_off_zero)
> > =A0
> > =A0static int
> > -set_dev_loss(vector strvec, void *ptr)
> > +set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int *uint_ptr =3D (unsigned int *)ptr;
> > @@ -870,7 +883,7 @@ declare_hw_handler(eh_deadline, set_undef_off_zero)
> > =A0declare_hw_snprint(eh_deadline, print_undef_off_zero)
> > =A0
> > =A0static int
> > -set_pgpolicy(vector strvec, void *ptr)
> > +set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > @@ -936,7 +949,8 @@ get_sys_max_fds(int *max_fds)
> > =A0
> > =A0
> > =A0static int
> > -max_fds_handler(struct config *conf, vector strvec)
> > +max_fds_handler(struct config *conf, vector strvec, const char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int r =3D 0, max_fds;
> > @@ -981,7 +995,7 @@ snprint_max_fds (struct config *conf, struct strbuf
> > *buff, const void *data)
> > =A0}
> > =A0
> > =A0static int
> > -set_rr_weight(vector strvec, void *ptr)
> > +set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > @@ -1025,7 +1039,7 @@ declare_mp_handler(rr_weight, set_rr_weight)
> > =A0declare_mp_snprint(rr_weight, print_rr_weight)
> > =A0
> > =A0static int
> > -set_pgfailback(vector strvec, void *ptr)
> > +set_pgfailback(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > @@ -1075,7 +1089,7 @@ declare_mp_handler(pgfailback, set_pgfailback)
> > =A0declare_mp_snprint(pgfailback, print_pgfailback)
> > =A0
> > =A0static int
> > -no_path_retry_helper(vector strvec, void *ptr)
> > +no_path_retry_helper(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > @@ -1120,7 +1134,8 @@ declare_mp_handler(no_path_retry,
> > no_path_retry_helper)
> > =A0declare_mp_snprint(no_path_retry, print_no_path_retry)
> > =A0
> > =A0static int
> > -def_log_checker_err_handler(struct config *conf, vector strvec)
> > +def_log_checker_err_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0
> > @@ -1193,7 +1208,8 @@ print_reservation_key(struct strbuf *buff,
> > =A0}
> > =A0
> > =A0static int
> > -def_reservation_key_handler(struct config *conf, vector strvec)
> > +def_reservation_key_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0return set_reservation_key(strvec, &conf->reser=
vation_key,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &conf->sa_flags,
> > @@ -1209,7 +1225,8 @@ snprint_def_reservation_key (struct config *conf,
> > struct strbuf *buff,
> > =A0}
> > =A0
> > =A0static int
> > -mp_reservation_key_handler(struct config *conf, vector strvec)
> > +mp_reservation_key_handler(struct config *conf, vector strvec, const
> > char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-=
>mptable);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!mpe)
> > @@ -1229,7 +1246,7 @@ snprint_mp_reservation_key (struct config *conf,
> > struct strbuf *buff,
> > =A0}
> > =A0
> > =A0static int
> > -set_off_int_undef(vector strvec, void *ptr)
> > +set_off_int_undef(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > @@ -1370,7 +1387,8 @@ declare_hw_snprint(recheck_wwid,
> > print_yes_no_undef)
> > =A0
> > =A0
> > =A0static int
> > -def_uxsock_timeout_handler(struct config *conf, vector strvec)
> > +def_uxsock_timeout_handler(struct config *conf, vector strvec, const
> > char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0unsigned int uxsock_timeout;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> > @@ -1390,7 +1408,8 @@ def_uxsock_timeout_handler(struct config *conf,
> > vector strvec)
> > =A0}
> > =A0
> > =A0static int
> > -hw_vpd_vendor_handler(struct config *conf, vector strvec)
> > +hw_vpd_vendor_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_=
nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> > @@ -1430,7 +1449,8 @@ snprint_hw_vpd_vendor(struct config *conf, struct
> > strbuf *buff,
> > =A0 * blacklist block handlers
> > =A0 */
> > =A0static int
> > -blacklist_handler(struct config *conf, vector strvec)
> > +blacklist_handler(struct config *conf, vector strvec, const char*file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->blist_devnode)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->blist_devnode =3D=
 vector_alloc();
> > @@ -1452,7 +1472,8 @@ blacklist_handler(struct config *conf, vector
> > strvec)
> > =A0}
> > =A0
> > =A0static int
> > -blacklist_exceptions_handler(struct config *conf, vector strvec)
> > +blacklist_exceptions_handler(struct config *conf, vector strvec,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 const char *file, int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->elist_devnode)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->elist_devnode =3D=
 vector_alloc();
> > @@ -1475,7 +1496,8 @@ blacklist_exceptions_handler(struct config *conf,
> > vector strvec)
> > =A0
> > =A0#define
> > declare_ble_handler(option)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -ble_ ## option ## _handler (struct config *conf, vector
> > strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +ble_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0char
> > *buff;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0int
> > rc;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > @@ -1494,7 +1516,8 @@ ble_ ## option ## _handler (struct config *conf,
> > vector strvec)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0
> > =A0#define declare_ble_device_handler(name, option, vend,
> > prod)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > -ble_ ## option ## _ ## name ## _handler (struct config *conf, vector
> > strvec) \
> > +ble_ ## option ## _ ## name ## _handler (struct config *conf, vector
> > strvec, \
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int
> > line_nr)=A0\
> > =A0{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0char *
> > buff;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0int
> > rc;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > @@ -1536,13 +1559,15 @@ snprint_ble_simple (struct config *conf, struct
> > strbuf *buff, const void *data)
> > =A0}
> > =A0
> > =A0static int
> > -ble_device_handler(struct config *conf, vector strvec)
> > +ble_device_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0return alloc_ble_device(conf->blist_device);
> > =A0}
> > =A0
> > =A0static int
> > -ble_except_device_handler(struct config *conf, vector strvec)
> > +ble_except_device_handler(struct config *conf, vector strvec, const
> > char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0return alloc_ble_device(conf->elist_device);
> > =A0}
> > @@ -1574,7 +1599,8 @@ static int snprint_bled_product(struct config
> > *conf, struct strbuf *buff,
> > =A0 * devices block handlers
> > =A0 */
> > =A0static int
> > -devices_handler(struct config *conf, vector strvec)
> > +devices_handler(struct config *conf, vector strvec, const char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->hwtable)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->hwtable =3D vecto=
r_alloc();
> > @@ -1586,7 +1612,8 @@ devices_handler(struct config *conf, vector
> > strvec)
> > =A0}
> > =A0
> > =A0static int
> > -device_handler(struct config *conf, vector strvec)
> > +device_handler(struct config *conf, vector strvec, const char *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe;
> > =A0
> > @@ -1623,7 +1650,8 @@ declare_hw_snprint(hwhandler, print_str)
> > =A0 * overrides handlers
> > =A0 */
> > =A0static int
> > -overrides_handler(struct config *conf, vector strvec)
> > +overrides_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->overrides)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->overrides =3D all=
oc_hwe();
> > @@ -1640,7 +1668,8 @@ overrides_handler(struct config *conf, vector
> > strvec)
> > =A0 * multipaths block handlers
> > =A0 */
> > =A0static int
> > -multipaths_handler(struct config *conf, vector strvec)
> > +multipaths_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!conf->mptable)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->mptable =3D vecto=
r_alloc();
> > @@ -1652,7 +1681,8 @@ multipaths_handler(struct config *conf, vector
> > strvec)
> > =A0}
> > =A0
> > =A0static int
> > -multipath_handler(struct config *conf, vector strvec)
> > +multipath_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe;
> > =A0
> > @@ -1681,7 +1711,8 @@ declare_mp_snprint(alias, print_str)
> > =A0 */
> > =A0
> > =A0static int
> > -deprecated_handler(struct config *conf, vector strvec)
> > +deprecated_handler(struct config *conf, vector strvec, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0
> > diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> > index d5595fb0..68262d0e 100644
> > --- a/libmultipath/parser.c
> > +++ b/libmultipath/parser.c
> > @@ -558,7 +558,8 @@ process_stream(struct config *conf, FILE *stream,
> > vector keywords,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if (keyword->handler) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D keyword->handler(conf, strvec);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D keyword->handler(conf, strvec,
> > file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 line_nr);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r +=3D t;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (t)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
condlog(1, "%s line %d,
> > parsing failed: %s",
> > diff --git a/libmultipath/parser.h b/libmultipath/parser.h
> > index 3452bde1..11ea2278 100644
> > --- a/libmultipath/parser.h
> > +++ b/libmultipath/parser.h
> > @@ -43,7 +43,7 @@ struct strbuf;
> > =A0
> > =A0/* keyword definition */
> > =A0typedef int print_fn(struct config *, struct strbuf *, const void *)=
;
> > -typedef int handler_fn(struct config *, vector);
> > +typedef int handler_fn(struct config *, vector, const char *file, int
> > line_nr);
> > =A0
> > =A0struct keyword {
> > =A0=A0=A0=A0=A0=A0=A0=A0char *string;
>=20
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

