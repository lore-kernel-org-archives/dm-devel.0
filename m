Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B59DC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:36:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3CB66135E
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3CB66135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636644998;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XHf4pmFKMDPniDrimhHC9qne1vci/IZDDL4dNHZOLpY=;
	b=ZAbc6VGX2AE/kc2xkDBqVKVD+tbPvABH20tQV6zpQCarYJJZXxeAJ72gpKla9P3yeHhCkq
	TsIZjnt040sJnYul+tv+jIQIKPUYZIU/pWjGjQo4wTgr38JUVLf5fVtz1I+dkOIivkc2+r
	IOR5ejT1gOWVoyZZmqRmqBuk0jupteM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-K1GvMo1ZP_KDv4b6S4NNTQ-1; Thu, 11 Nov 2021 10:36:34 -0500
X-MC-Unique: K1GvMo1ZP_KDv4b6S4NNTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B16F10151E0;
	Thu, 11 Nov 2021 15:36:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF08F19C59;
	Thu, 11 Nov 2021 15:36:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 335514EA2A;
	Thu, 11 Nov 2021 15:36:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABFaIRC007231 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 10:36:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E215060C17; Thu, 11 Nov 2021 15:36:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE95F60C05;
	Thu, 11 Nov 2021 15:36:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ABFaFxY024930; 
	Thu, 11 Nov 2021 09:36:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ABFaETk024929;
	Thu, 11 Nov 2021 09:36:14 -0600
Date: Thu, 11 Nov 2021 09:36:14 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211111153614.GT19591@octiron.msp.redhat.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-8-git-send-email-bmarzins@redhat.com>
	<71d89b6eb201dd69cf8a6a209fa0fc12b8ebe918.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <71d89b6eb201dd69cf8a6a209fa0fc12b8ebe918.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 7/9] libmultipath: deprecate file and
 directory config options
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

On Thu, Nov 11, 2021 at 11:44:44AM +0000, Martin Wilck wrote:
> On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> > Having multipath able to select pathnames for the files and
> > directories
> > it needs causes unnecessary maintainer headaches. Mark these as
> > deprecated, but still support them for now.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> I would have preferred to start ignoring these options right away
> (spitting out warnings). After all, this is upstream, we don't have to=20
> take care of long-term-support users (distros can keep the old behavior
> if they want), and experience shows that depreciation warnings are
> ignored until the deprecated feature is actually removed. But if you
> prefer doing it this way, fine.
>=20
> Let's agree to remove these options soon, i.e. with the official
> release after the next one (0.8.9, presumably).

Sure. Thanks.

>=20
> > ---
> > =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0 | 40 ++++++++++++++++++++++=
+++++++-------
> > --
> > =A0multipath/multipath.conf.5 |=A0 5 +++++
> > =A02 files changed, 36 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 149d3348..1b4e1106 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -268,6 +268,15 @@ def_ ## option ## _handler (struct config *conf,
> > vector strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > +#define declare_def_warn_handler(option,
> > function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
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
> > +=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s line %d, \"" #option "\" is deprec=
ated and
> > will be disabled in a future release", file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &conf->option, file,
> > line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +}
> > +
> > =A0#define declare_def_range_handler(option, minval,
> > maxval)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0\
> > =A0static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0def_ ## option ## _handler (struct config *conf, vector
> > strvec,=A0=A0=A0=A0=A0=A0=A0=A0 \
> > @@ -284,6 +293,17 @@ snprint_def_ ## option (struct config *conf,
> > struct strbuf *buff,=A0=A0\
> > =A0=A0=A0=A0=A0=A0=A0=A0return function(buff, conf-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> > =A0}
> > =A0
> > +#define declare_def_snprint_non_defstr(option, function,
> > value)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +static
> > int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +snprint_def_ ## option (struct config *conf, struct strbuf
> > *buff,=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onst void
> > *data)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0static const char *s =3D
> > value;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0if (!conf->option || strcmp(conf->option, s) =3D=
=3D
> > 0)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> > 0;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0return function(buff, conf-
> > >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> > +}
>=20
> I'd actually print the value here, even if it's empty or equal to the
> default. That would be helpful in the future too, when these options
> are removed. This way customers can verify the settings multipathd is
> using by default.

Sure.

-Ben

> Regards,
> Martin
>=20
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

