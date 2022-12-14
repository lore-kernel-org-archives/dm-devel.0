Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8C0C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 14 Dec 2022 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671034386;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BVZ65+os5FntnPPXlgZ0fCYub/XZDXi1pwyQxN+LPjs=;
	b=J4iO2H/AiPGrtTgo37z/XTIJn8j60j4F6kfLrFK/egHDXRt9tEwGet21cTosu9shgc2+fK
	sFmRg9xiFbgwdw8tbo/jktRb12VwOrM0GqaKes+6GTt2HadMv8bXI5Oh+vaP8ZhLF9Wsyy
	A4ZqScquCO9zKAOB7ddAK7//GnLlnQA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-LjboKQHeOmydjDy_OkPxaQ-1; Wed, 14 Dec 2022 11:13:03 -0500
X-MC-Unique: LjboKQHeOmydjDy_OkPxaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 914C91805664;
	Wed, 14 Dec 2022 16:13:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3947D7AE5;
	Wed, 14 Dec 2022 16:13:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D3001946A41;
	Wed, 14 Dec 2022 16:13:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C77F319465B9
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Dec 2022 16:12:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 997A840C945A; Wed, 14 Dec 2022 16:12:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 79DCF40ED76E;
 Wed, 14 Dec 2022 16:12:59 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BEGCwvH013360;
 Wed, 14 Dec 2022 10:12:58 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BEGCvpp013359;
 Wed, 14 Dec 2022 10:12:57 -0600
Date: Wed, 14 Dec 2022 10:12:57 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221214161257.GC6245@octiron.msp.redhat.com>
References: <1670974567-8005-1-git-send-email-bmarzins@redhat.com>
 <1670974567-8005-4-git-send-email-bmarzins@redhat.com>
 <e4bd27a114e65fc0fcc5b9038d0d216ab9540dd2.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e4bd27a114e65fc0fcc5b9038d0d216ab9540dd2.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 3/3] libmutipath: validate the argument count
 of config strings
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 14, 2022 at 09:41:50AM +0000, Martin Wilck wrote:
> On Tue, 2022-12-13 at 17:36 -0600, Benjamin Marzinski wrote:
> > The features, path_selector, and hardware_handler config options pass
> > their strings directly into the kernel.=A0 If users omit the argument
> > counts from these strings, or use the wrong value, the kernel's table
> > parsing gets completely messed up, and the error messages it prints
> > don't reflect what actully went wrong. To avoid messing up the
> > kernel table parsing, verify that these strings correctly set the
> > argument count to the number of arguments they have.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/dict.c | 110 ++++++++++++++++++++++++++++++++++++++++--
> > --
> > =A01 file changed, 101 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index f4233882..6645de49 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -116,6 +116,58 @@ set_str(vector strvec, void *ptr, const char
> > *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > +static int
> > +set_arg_str(vector strvec, void *ptr, int count_idx, const char
> > *file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +=A0=A0=A0=A0=A0=A0=A0const char *spaces =3D " \f\n\r\t\v";
>=20
> Nit: I believe '\n' can't occur in values passed from multipath.conf,
> as we don't support multi-line values.

Sure. The goal was to treat the strings the same way as the kernel
would, but I agree we can't get a '\n' from a value in multipath.conf.
Also, for what it's worth, the kernel also treats the character 0xa0 as
a whitespace character (nbsp) since it uses an
almost-but-not-quite-latin1 character set. I've just been ignoring this,
and plan to continue doing so unless someone complains.=20

> Also, should this be "static
> const=A0char * const spaces", maybe?

Sure.

-Ben
=20
> Other than that, this looks good to me.
>=20
> Regards,
> Martin
>=20
>=20
>=20
> > +=A0=A0=A0=A0=A0=A0=A0char *p, *end;
> > +=A0=A0=A0=A0=A0=A0=A0int idx =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0long int count =3D -1;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0p =3D *str_ptr;
> > +=A0=A0=A0=A0=A0=A0=A0while (*p !=3D '\0') {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D strspn(p, spaces);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (*p =3D=3D '\0')
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0idx +=3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (idx =3D=3D count_idx)=
 {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
rrno =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ount =3D strtol(p, &end, 10);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (errno =3D=3D ERANGE || end =3D=3D p ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 !(isspace(*end) || *end =3D=3D '\0')) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0count =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0break;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D strcspn(p, spaces)=
;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (count < 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, m=
issing argument count for
> > %s",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec,
> > 0));
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (count !=3D idx - count_idx) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid argument count for
> > %s:, got '%ld' expected '%d'",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> > count,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
dx - count_idx);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +fail:
> > +=A0=A0=A0=A0=A0=A0=A0free(*str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > =A0static int
> > =A0set_path(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > @@ -288,6 +340,14 @@ def_ ## option ## _handler (struct config *conf,
> > vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0 \
> > =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &conf->option, minval, m=
axval, file,
> > line_nr); \
> > =A0}
> > =A0
> > +#define declare_def_arg_str_handler(option,
> > count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +def_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &conf->option, count_i=
dx, file,
> > line_nr); \
> > +}
> > +
> > =A0#define declare_def_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0snprint_def_ ## option (struct config *conf, struct strbuf
> > *buff,=A0=A0=A0=A0=A0=A0\
> > @@ -340,6 +400,17 @@ hw_ ## option ## _handler (struct config *conf,
> > vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &hwe->option, minval, ma=
xval, file,
> > line_nr); \
> > =A0}
> > =A0
> > +#define declare_hw_arg_str_handler(option,
> > count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +hw_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0struct hwentry * hwe =3D VECTOR_LAST_SLOT(conf-
> > >hwtable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0if
> > (!hwe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &hwe->option, count_id=
x, file,
> > line_nr); \
> > +}
> > +
> > =A0
> > =A0#define declare_hw_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > @@ -371,6 +442,16 @@ ovr_ ## option ## _handler (struct config *conf,
> > vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 file=
, line_nr); \
> > =A0}
> > =A0
> > +#define declare_ovr_arg_str_handler(option,
> > count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +ovr_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0if (!conf-
> > >overrides)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &conf->overrides->opti=
on,
> > count_idx, file, line_nr); \
> > +}
> > +
> > =A0#define declare_ovr_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0snprint_ovr_ ## option (struct config *conf, struct strbuf
> > *buff,=A0=A0=A0=A0=A0=A0\
> > @@ -401,6 +482,17 @@ mp_ ## option ## _handler (struct config *conf,
> > vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0return set_int(strvec, &mpe->option, minval, ma=
xval, file,
> > line_nr); \
> > =A0}
> > =A0
> > +#define declare_mp_arg_str_handler(option,
> > count_idx)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +mp_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int
> > line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0struct mpentry * mpe =3D VECTOR_LAST_SLOT(conf-
> > >mptable);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0if
> > (!mpe)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return set_arg_str(strvec, &mpe->option, count_id=
x, file,
> > line_nr); \
> > +}
> > +
> > =A0#define declare_mp_snprint(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0snprint_mp_ ## option (struct config *conf, struct strbuf
> > *buff,=A0=A0=A0=A0=A0=A0=A0\
> > @@ -584,13 +676,13 @@ snprint_def_marginal_pathgroups(struct config
> > *conf, struct strbuf *buff,
> > =A0}
> > =A0
> > =A0
> > -declare_def_handler(selector, set_str)
> > +declare_def_arg_str_handler(selector, 1)
> > =A0declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
> > -declare_hw_handler(selector, set_str)
> > +declare_hw_arg_str_handler(selector, 1)
> > =A0declare_hw_snprint(selector, print_str)
> > -declare_ovr_handler(selector, set_str)
> > +declare_ovr_arg_str_handler(selector, 1)
> > =A0declare_ovr_snprint(selector, print_str)
> > -declare_mp_handler(selector, set_str)
> > +declare_mp_arg_str_handler(selector, 1)
> > =A0declare_mp_snprint(selector, print_str)
> > =A0
> > =A0static int snprint_uid_attrs(struct config *conf, struct strbuf
> > *buff,
> > @@ -663,13 +755,13 @@ declare_hw_snprint(prio_args, print_str)
> > =A0declare_mp_handler(prio_args, set_str)
> > =A0declare_mp_snprint(prio_args, print_str)
> > =A0
> > -declare_def_handler(features, set_str)
> > +declare_def_arg_str_handler(features, 0)
> > =A0declare_def_snprint_defstr(features, print_str, DEFAULT_FEATURES)
> > -declare_ovr_handler(features, set_str)
> > +declare_ovr_arg_str_handler(features, 0)
> > =A0declare_ovr_snprint(features, print_str)
> > -declare_hw_handler(features, set_str)
> > +declare_hw_arg_str_handler(features, 0)
> > =A0declare_hw_snprint(features, print_str)
> > -declare_mp_handler(features, set_str)
> > +declare_mp_arg_str_handler(features, 0)
> > =A0declare_mp_snprint(features, print_str)
> > =A0
> > =A0declare_def_handler(checker_name, set_str)
> > @@ -1821,7 +1913,7 @@ declare_hw_snprint(revision, print_str)
> > =A0declare_hw_handler(bl_product, set_str)
> > =A0declare_hw_snprint(bl_product, print_str)
> > =A0
> > -declare_hw_handler(hwhandler, set_str)
> > +declare_hw_arg_str_handler(hwhandler, 0)
> > =A0declare_hw_snprint(hwhandler, print_str)
> > =A0
> > =A0/*
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

