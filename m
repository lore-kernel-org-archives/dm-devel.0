Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB3C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:11:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DEFF360F45
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DEFF360F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636143063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mxDl7NNBZ83q+r7SxCMKJ59mOuDmI9l+BR/bbgH1Vpc=;
	b=DlH5eSS/2tREcAKw5YnCxX1zMPGn/pqZ286MwcBH6JCZ9YP0qINGMuGUsgEJW6X2EdRFFu
	H19YvsGeNPHrlbsrLw4X95U0PT3ij7hjZZytoDbGzok38Qp8H8gximl/ghskYvPMxqPS0a
	1lDVxVUQVMFaMCkrA+nrcM51zgrJE3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-xqxLDM7DP-WNee162YMsPw-1; Fri, 05 Nov 2021 16:11:02 -0400
X-MC-Unique: xqxLDM7DP-WNee162YMsPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 950F18066F6;
	Fri,  5 Nov 2021 20:10:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 165195C25D;
	Fri,  5 Nov 2021 20:10:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 585641806D03;
	Fri,  5 Nov 2021 20:10:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5KAs3P020461 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 16:10:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DFA6F5DA60; Fri,  5 Nov 2021 20:10:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97CB85D9DE;
	Fri,  5 Nov 2021 20:10:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5KAdNN012504; 
	Fri, 5 Nov 2021 15:10:39 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5KAcud012503;
	Fri, 5 Nov 2021 15:10:38 -0500
Date: Fri, 5 Nov 2021 15:10:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105201038.GL19591@octiron.msp.redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-9-git-send-email-bmarzins@redhat.com>
	<c93fc9dcca43a0f385b2c172266ab58cfbbb4767.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c93fc9dcca43a0f385b2c172266ab58cfbbb4767.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 8/8] libmultipath: cleanup invalid config
	handling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 09:11:34PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > Add error reporting to the remaining config handlers. If the value is
> > invalid, do not change the existing config option's value.
>=20
> Like for the previous patch, I'm unsure if this is wise. You rely on a
> reasonable default being set before the function is called. I suppose
> that's the case, but I like seeing the "invalid" value substituted
> right there where the validity is checked. That saves us from searching
> the code for the default value.
>=20
> Maybe I overlooked an important rationale for not touching the values
> in the case of invalid input, please explain.

Since these handlers are only called if people put the corresponding
option in the config files, we had better have sensible defaults if
they're not called (or if they don't set anything).

I admit that I should take a look for cases were we cap an out-of-range
value, to see if it would make more sense to treat it as an invalid
value instead. Also, instead of accepting strings that are simply a
number, we should convert the string, and the check the actual number.
But I don't see any harm in simply ignoring the invalid values. It's no
different than if the user didn't put the invalid line into
multipath.conf

Not setting the values on garbage input makes the handlers more general.
If you have two options that work the same except that they have
different defaults, then by not explicitly setting the value to the
default when you have invalid input, one handler can be used for both
options. set_yes_no() is a good example.  Without my patch, it always
set the value to something, even if the input was garbage. But the
default value it set was "no". That had nothing to do with the default
value of the options that were using it. You could do extra work to make
sure that it would correctly use the option's default value, but you get
the same outcome, with simpler code, just by not changing the default if
you have a garbage value.

Also, many of the handlers never set the value on invalid input. I'm just
making that consistent across all of the handlers.

-Ben

> Cheers,
> Martin
>=20
> >  Also print
> > an error whenever 0 is returned for an invalid value. When the
> > handler
> > returns 1, config processing already fails with an error message.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0libmultipath/dict.c | 73 +++++++++++++++++++++++++++++++------------
> > --
> > =A01 file changed, 51 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index e79fcdd7..8c3b5f72 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -199,8 +199,11 @@ set_yes_no(vector strvec, void *ptr, const char
> > *file, int line_nr)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "yes") =3D=3D 0 || strcmp(buff=
, "1") =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_YES;
> > -=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "no") =3D=3D 0 || strcmp(bu=
ff, "0") =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YN_NO;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for %s:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> > buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -221,7 +224,8 @@ set_yes_no_undef(vector strvec, void *ptr, const
> > char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "yes") =3D=3D 0 || strcmp=
(buff, "1") =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YNU_YES;
> > =A0=A0=A0=A0=A0=A0=A0=A0else
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D YNU_UNDEF;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for %s:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, (char*)VECTOR_SLOT(strvec, 0),
> > buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -471,9 +475,6 @@ def_find_multipaths_handler(struct config *conf,
> > vector strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0char *buff;
> > =A0=A0=A0=A0=A0=A0=A0=A0int i;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (set_yes_no_undef(strvec, &conf->find_multipat=
hs, file,
> > line_nr) =3D=3D 0 && conf->find_multipaths !=3D FIND_MULTIPATHS_UNDEF)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > @@ -486,9 +487,14 @@ def_find_multipaths_handler(struct config *conf,
> > vector strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (conf->find_multipaths =3D=3D YNU_UNDEF) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "illegal value=
 for find_multipaths: %s",
> > buff);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->find_multipaths =3D=
 DEFAULT_FIND_MULTIPATHS;
> > +=A0=A0=A0=A0=A0=A0=A0if (i >=3D __FIND_MULTIPATHS_LAST) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strcmp(buff, "no") =
=3D=3D 0 || strcmp(buff, "0") =3D=3D
> > 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf->find_multipaths =3D FIND_MULTIPATHS_OFF;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (strcmp(buff, "ye=
s") =3D=3D 0 || strcmp(buff,
> > "1") =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf->find_multipaths =3D FIND_MULTIPATHS_ON;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(1, "%s line %d, invalid value for
> > find_multipaths: \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0file, line_nr, buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > @@ -537,8 +543,10 @@ static int uid_attrs_handler(struct config
> > *conf, vector strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!val)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (parse_uid_attrs(val, conf))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "error parsing=
 uid_attrs: \"%s\"", val);
> > -=A0=A0=A0=A0=A0=A0=A0condlog(3, "parsed %d uid_attrs", VECTOR_SIZE(&co=
nf-
> > >uid_attrs));
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d,er=
ror parsing uid_attrs:
> > \"%s\"", file,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ine_nr, val);
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "parsed %d uid=
_attrs", VECTOR_SIZE(&conf-
> > >uid_attrs));
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(val);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > @@ -766,8 +774,11 @@ def_config_dir_handler(struct config *conf,
> > vector strvec, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int =
line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file *=
/
> > -=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> > +=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, c=
onfig_dir option only valid
> > in /etc/multipath.conf",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return set_path(strvec, &conf->config_dir, file=
, line_nr);
> > =A0}
> > =A0declare_def_snprint(config_dir, print_str)
> > @@ -825,7 +836,9 @@ set_mode(vector strvec, void *ptr, int *flags,
> > const char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0if (sscanf(buff, "%o", &mode) =3D=3D 1 && mode =
<=3D 0777) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_=
MODE);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*mode_ptr =3D mode;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for mode:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -850,7 +863,9 @@ set_uid(vector strvec, void *ptr, int *flags,
> > const char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", &uid) =3D=3D 1){
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_=
UID);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uid_ptr =3D uid;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for uid:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -876,7 +891,9 @@ set_gid(vector strvec, void *ptr, int *flags,
> > const char *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", &gid) =3D=3D 1){
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*flags |=3D (1 << ATTR_=
GID);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*gid_ptr =3D gid;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for gid:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > @@ -978,7 +995,8 @@ set_dev_loss(vector strvec, void *ptr, const char
> > *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "infinity"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uint_ptr =3D MAX_DEV_L=
OSS_TMO;
> > =A0=A0=A0=A0=A0=A0=A0=A0else if (sscanf(buff, "%u", uint_ptr) !=3D 1)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*uint_ptr =3D DEV_LOSS_TM=
O_UNSET;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for
> > dev_loss_tmo: \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -1012,13 +1030,19 @@ static int
> > =A0set_pgpolicy(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0char * buff;
> > +=A0=A0=A0=A0=A0=A0=A0int policy;
> > =A0=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D get_pgpolicy_id(buff);
> > +=A0=A0=A0=A0=A0=A0=A0policy =3D get_pgpolicy_id(buff);
> > +=A0=A0=A0=A0=A0=A0=A0if (policy !=3D IOPOLICY_UNDEF)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D policy;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for
> > path_grouping_policy: \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -1131,10 +1155,11 @@ set_rr_weight(vector strvec, void *ptr, const
> > char *file, int line_nr)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "priorities"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D RR_WEIGHT_=
PRIO;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "uniform"))
> > +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "uniform"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*int_ptr =3D RR_WEIGHT_=
NONE;
> > -
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for rr_weight:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -1270,10 +1295,13 @@ def_log_checker_err_handler(struct config
> > *conf, vector strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!buff)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0if (strlen(buff) =3D=3D 4 && !strcmp(buff, "once"=
))
> > +=A0=A0=A0=A0=A0=A0=A0if (!strcmp(buff, "once"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->log_checker_err =
=3D LOG_CHKR_ERR_ONCE;
> > -=A0=A0=A0=A0=A0=A0=A0else if (strlen(buff) =3D=3D 6 && !strcmp(buff, "=
always"))
> > +=A0=A0=A0=A0=A0=A0=A0else if (!strcmp(buff, "always"))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf->log_checker_err =
=3D LOG_CHKR_ERR_ALWAYS;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, i=
nvalid value for
> > log_checker_err: \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, buff);
> > =A0
>=20
> We lack a proper DEFAULT for log_checker_err.
>=20

True. Is it really the only one? I thought that there were a number of
options for which we just relied on the fact that conf is zeroed out
when it's created, so the 0 value (in this case LOG_CHKR_ERR_ALWAYS) is
the implicit default.
=20
> > =A0=A0=A0=A0=A0=A0=A0=A0free(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > @@ -1534,7 +1562,8 @@ hw_vpd_vendor_handler(struct config *conf,
> > vector strvec, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0hwe->vpd_vendor_id =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, invalid value for vpd_ven=
dor:
> > \"%s\"",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0file, line_nr, buff);
> > =A0out:
> > =A0=A0=A0=A0=A0=A0=A0=A0FREE(buff);
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

