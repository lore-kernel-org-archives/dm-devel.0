Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90ED2C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 18:12:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2FDF26113B
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 18:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FDF26113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636135933;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iuYB5H0FwEsemdiQJyBXzo93wAjmHE5WK2R53snLet4=;
	b=TVgBP24JkOLz21lD4RlBECnXrGuyUsbBRT1oZJJm31NTkiypoMfqbJMCJd1vDVOkGPKSko
	aF2eVi6dYtk/KI6cXJoHMh4CZQTs6kmQMgblYGpBHkzN00E/QhAyB/f8G8KqYGnk18VRxo
	YlPNPDa4VIjV9zXQEzLmiJqMP7irc3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-two55JMMPaiH93w8zH7hdg-1; Fri, 05 Nov 2021 14:12:09 -0400
X-MC-Unique: two55JMMPaiH93w8zH7hdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC4D87123E;
	Fri,  5 Nov 2021 18:12:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0DE619C79;
	Fri,  5 Nov 2021 18:12:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F95A4EA2A;
	Fri,  5 Nov 2021 18:12:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5I8Jif011041 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 14:08:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D9EE05C25D; Fri,  5 Nov 2021 18:08:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7BDD1803D;
	Fri,  5 Nov 2021 18:08:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5I8EUv011995; 
	Fri, 5 Nov 2021 13:08:14 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5I8DnV011994;
	Fri, 5 Nov 2021 13:08:13 -0500
Date: Fri, 5 Nov 2021 13:08:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105180813.GK19591@octiron.msp.redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-8-git-send-email-bmarzins@redhat.com>
	<da5d538c2d1493e31d8604c9af183a1b5a531a45.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <da5d538c2d1493e31d8604c9af183a1b5a531a45.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/8] libmultipath: split set_int to enable
	reuse
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 08:54:11PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > Split the code that does the actual value parsing out of set_int(),
> > into
> > a helper function, do_set_int(), so that it can be used by other
> > handlers. These functions no longer set the config value at all, when
> > they have invalid input.
>=20
> Not sure about that, do_set_int() sets the value to the cap (see below)

Sorry for the confustion. That's not what I meant.  I meant that if
do_set_int() returns failure, we won't override the existing value in
the config.

>=20
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/dict.c | 82 +++++++++++++++++++++++++------------------
> > --
> > =A01 file changed, 46 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 91333068..e79fcdd7 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -31,17 +31,12 @@
> > =A0#include "strbuf.h"
> > =A0
> > =A0static int
> > -set_int(vector strvec, void *ptr, int min, int max, const char
> > *file,
> > -=A0=A0=A0=A0=A0=A0=A0int line_nr)
> > +do_set_int(vector strvec, void *ptr, int min, int max, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0int line_nr, char *buff)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > -=A0=A0=A0=A0=A0=A0=A0char *buff, *eptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *eptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0long res;
> > -=A0=A0=A0=A0=A0=A0=A0int rc;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > -=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0res =3D strtol(buff, &eptr, 10);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (eptr > buff)
> > @@ -50,17 +45,30 @@ set_int(vector strvec, void *ptr, int min, int
> > max, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0if (*buff =3D=3D '\0' || *eptr !=3D '\0') {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d,=
 invalid value for %s:
> > \"%s\"",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0file, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> > buff);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 1;
> > -=A0=A0=A0=A0=A0=A0=A0} else {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (res > max || res < mi=
n) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
es =3D (res > max) ? max : min;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(1, "%s line %d, value for %s too %s,
> > capping at %ld",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (res > max || res < min) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0res =3D (res > max) ? max=
 : min;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, v=
alue for %s too %s, capping
> > at %ld",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0file, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
res =3D=3D max)? "large" : "small", res);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 0;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D res;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(res =3D=3D max)? "large"=
 : "small", res);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D res;
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > +static int
> > +set_int(vector strvec, void *ptr, int min, int max, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char *buff;
> > +=A0=A0=A0=A0=A0=A0=A0int rc;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec, ptr, min, max, file, li=
ne_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > @@ -918,6 +926,7 @@ declare_mp_attr_snprint(gid, print_gid)
> > =A0static int
> > =A0set_undef_off_zero(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0
> > @@ -927,10 +936,10 @@ set_undef_off_zero(vector strvec, void *ptr,
> > const char *file, int line_nr)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "off") =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_OFF;
> > -=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%d", int_ptr) !=3D 1 ||
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *int_ptr < UOZ_ZERO)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_UNDEF;
> > -=A0=A0=A0=A0=A0=A0=A0else if (*int_ptr =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec,=
 int_ptr, 0, INT_MAX, file,
> > line_nr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0buff);
> > +=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D 0 && *int_ptr =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D UOZ_ZERO;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > @@ -1082,14 +1091,12 @@ max_fds_handler(struct config *conf, vector
> > strvec, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Assume safe limit */
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0max_fds =3D 4096;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0if (strlen(buff) =3D=3D 3 &&
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !strcmp(buff, "max"))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D max_fds=
;
> > -=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D atoi(bu=
ff);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (conf->max_fds > max_fds)
> > +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "max")) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->max_fds =3D max_f=
ds;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D do_set_int(strvec, =
&conf->max_fds, 0, max_fds,
> > file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 line_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0
> > @@ -1158,6 +1165,7 @@ declare_mp_snprint(rr_weight, print_rr_weight)
> > =A0static int
> > =A0set_pgfailback(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0
> > @@ -1172,11 +1180,11 @@ set_pgfailback(vector strvec, void *ptr,
> > const char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (strlen(buff) =3D=3D 10 && !strcmp(buff=
, "followover"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D -FAILBACK_=
FOLLOWOVER;
> > =A0=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D atoi(buff);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec,=
 ptr, 0, INT_MAX, file,
> > line_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0return rc;
> > =A0}
> > =A0
> > =A0int
> > @@ -1208,6 +1216,7 @@ declare_mp_snprint(pgfailback,
> > print_pgfailback)
> > =A0static int
> > =A0no_path_retry_helper(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0
> > @@ -1219,11 +1228,11 @@ no_path_retry_helper(vector strvec, void
> > *ptr, const char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RE=
TRY_FAIL;
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "queue"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RE=
TRY_QUEUE;
> > -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NO_PATH_RETR=
Y_UNDEF;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec,=
 ptr, 1, INT_MAX, file,
> > line_nr, buff);
>=20
> This will set no_path_retry to 1 if the input was something like "0  "
> or a negative value. The previous code would have set
> NO_PATH_RETRY_UNDEF (=3D=3D 0). That's a semantic change, as the code
> checks for NO_PATH_RETRY_UNDEF in various places. Was this intentional?
>=20

Not completely. I do think that is makes sense not to change the
existing value if the input is invalid. I admit that I didn't think
about the fact that "0  " wouldn't be the same as "0". It certainly
makes sense to change this so that do_set_int() accepts 0, and then we
can handle 0 afterwards.

It might also make sense in some cases to simply treat values outside
the range as invalid, instead of capping them. Thoughts?

> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0return rc;
> > =A0}
> > =A0
> > =A0int
> > @@ -1365,6 +1374,7 @@ snprint_mp_reservation_key (struct config
> > *conf, struct strbuf *buff,
> > =A0static int
> > =A0set_off_int_undef(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D0;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > =A0
> > @@ -1374,11 +1384,11 @@ set_off_int_undef(vector strvec, void *ptr,
> > const char *file, int line_nr)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "no") || !strcmp(buff, "0"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_NO;
> > -=A0=A0=A0=A0=A0=A0=A0else if ((*int_ptr =3D atoi(buff)) < 1)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D NU_UNDEF;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D do_set_int(strvec,=
 ptr, 1, INT_MAX, file,
> > line_nr, buff);
>=20
> Likewise, you'd set 1 here for negative input or "0  ", while
> previously the result would be NU_UNDEF =3D=3D 0.=20
>=20
> Negative values are of course garbage and I'm unsure if trailing spaces
> can occur at this point in the code, but do_set_int() handles them.

Same here.

-Ben

> Regards,
> Martin
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

