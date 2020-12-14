Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F2DC4361B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 08:13:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91A45229C7
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 08:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91A45229C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-ykArak32Mg6OTzGKfFdrTQ-1; Mon, 14 Dec 2020 03:13:33 -0500
X-MC-Unique: ykArak32Mg6OTzGKfFdrTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 837D010054FF;
	Mon, 14 Dec 2020 08:13:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77A6E62681;
	Mon, 14 Dec 2020 08:13:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4346180954D;
	Mon, 14 Dec 2020 08:13:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BE8DJ0b013595 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 03:13:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E4A292026D46; Mon, 14 Dec 2020 08:13:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF4EE2026D11
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 08:13:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8495C858EEC
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 08:13:16 +0000 (UTC)
Received: from mslow2.mail.gandi.net (mslow2.mail.gandi.net
	[217.70.178.242]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-262-4sV-KI7-O_CcT2-McuaTLQ-1; Mon, 14 Dec 2020 03:13:14 -0500
X-MC-Unique: 4sV-KI7-O_CcT2-McuaTLQ-1
Received: from relay7-d.mail.gandi.net (unknown [217.70.183.200])
	by mslow2.mail.gandi.net (Postfix) with ESMTP id 5AF693B692F
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 07:56:53 +0000 (UTC)
X-Originating-IP: 209.85.167.48
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
	[209.85.167.48]) (Authenticated sender: smtp@opensvc.com)
	by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 4E50020006;
	Mon, 14 Dec 2020 07:56:48 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id a9so27778500lfh.2;
	Sun, 13 Dec 2020 23:56:48 -0800 (PST)
X-Gm-Message-State: AOAM5327noVB3uhYjBphRPrTZd8H4/r8e9CzlueToyJwTEwkasdUM2wF
	YTHG3TUzL3dHjBjzuC8Ag70wHcsqN/44Eqbh/eU=
X-Google-Smtp-Source: ABdhPJx7884KX1RYLk9H7u0mpwK9Pi6wkKpxyolo9SjqFV3TvCRCJyKFlmm7Xm4FKdzJQMalmRWERRRoRLLOdLwwbOE=
X-Received: by 2002:a05:651c:546:: with SMTP id
	q6mr9997423ljp.235.1607932607484; 
	Sun, 13 Dec 2020 23:56:47 -0800 (PST)
MIME-Version: 1.0
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Dec 2020 08:56:36 +0100
X-Gmail-Original-Message-ID: <CABr-GnfTqde6t2LFTHbrRkp1qMVbsRUEFBqU6tW1M_uR1svHFg@mail.gmail.com>
Message-ID: <CABr-GnfTqde6t2LFTHbrRkp1qMVbsRUEFBqU6tW1M_uR1svHFg@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Xose Vazquez Perez <xose.vazquez@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [dm-devel] uxsock_timeout default value in man page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3717309719997054853=="

--===============3717309719997054853==
Content-Type: multipart/alternative; boundary="000000000000e45b9b05b667fbfc"

--000000000000e45b9b05b667fbfc
Content-Type: text/plain; charset="UTF-8"

Hello,

a user brought to my attention "multipathd show config | grep
usock_timeout" does not agree with the default value stated in the manpage
: 4000 instead of 1000.

And indeed,

./libmpathcmd/mpath_cmd.h:#define DEFAULT_REPLY_TIMEOUT 4000

Can you confirm this change is valid ?

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d2101ed6..7242d39b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1153,7 +1153,7 @@ In these cases it is recommended to increase the CLI
timeout to avoid
 those issues.
 .RS
 .TP
-The default is: \fB1000\fR
+The default is: \fB4000\fR
 .RE
 .
 .

Best Regards,
Christophe

--000000000000e45b9b05b667fbfc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>a user brought to my attention &=
quot;multipathd show config | grep usock_timeout&quot; does=C2=A0not agree =
with the default value stated in the manpage : 4000 instead of 1000.</div><=
div><br></div><div>And indeed,</div><div><br></div><div>./libmpathcmd/mpath=
_cmd.h:#define DEFAULT_REPLY_TIMEOUT=094000<br></div><div><br></div><div>Ca=
n you confirm this change is valid ?</div><div><br></div><div>diff --git a/=
multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>index d2101ed6..=
7242d39b 100644<br>--- a/multipath/multipath.conf.5<br>+++ b/multipath/mult=
ipath.conf.5<br>@@ -1153,7 +1153,7 @@ In these cases it is recommended to i=
ncrease the CLI timeout to avoid<br>=C2=A0those issues.<br>=C2=A0.RS<br>=C2=
=A0.TP<br>-The default is: \fB1000\fR<br>+The default is: \fB4000\fR<br>=C2=
=A0.RE<br>=C2=A0.<br>=C2=A0.<br></div><div><br></div><div>Best Regards,</di=
v><div>Christophe</div></div>

--000000000000e45b9b05b667fbfc--

--===============3717309719997054853==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============3717309719997054853==--

