Return-Path: <SRS0=LcFQ=FX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EF6C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 19 Dec 2020 10:27:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC23E23BDE
	for <dm-devel@archiver.kernel.org>; Sat, 19 Dec 2020 10:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC23E23BDE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-4EJTsXopPCCh2wjSr2b-Sg-1; Sat, 19 Dec 2020 05:27:19 -0500
X-MC-Unique: 4EJTsXopPCCh2wjSr2b-Sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42873190A7A2;
	Sat, 19 Dec 2020 10:27:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEF2271D53;
	Sat, 19 Dec 2020 10:27:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54452180954D;
	Sat, 19 Dec 2020 10:27:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BJAR7XF026248 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 19 Dec 2020 05:27:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A57B2026D36; Sat, 19 Dec 2020 10:27:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15C9E2026D49
	for <dm-devel@redhat.com>; Sat, 19 Dec 2020 10:27:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC92C800157
	for <dm-devel@redhat.com>; Sat, 19 Dec 2020 10:27:04 +0000 (UTC)
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net
	[217.70.178.232]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-281-dMLlDyBlOX67nzkgmP7CJw-1; Sat, 19 Dec 2020 05:27:01 -0500
X-MC-Unique: dMLlDyBlOX67nzkgmP7CJw-1
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
	[209.85.167.45]) (Authenticated sender: smtp@opensvc.com)
	by relay12.mail.gandi.net (Postfix) with ESMTPSA id 62E46200005;
	Sat, 19 Dec 2020 10:26:59 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id o13so12024210lfr.3;
	Sat, 19 Dec 2020 02:26:59 -0800 (PST)
X-Gm-Message-State: AOAM530Ip5kPHjAgp9nppmuKux78jREGEvK3S/XsxbJUJTSkRzrJYSto
	Mb6ryCC5hWnMyV5xMnuFMQbBhOBfYkhGT3ykirw=
X-Google-Smtp-Source: ABdhPJx1LVVoTwW9vawNSmkVM1RamnHXol8NwkAkLOKV3S+xeEAFQ7PieYE4E44eKkpoAJswx1DkZw5ZZ/9nVGCRqD8=
X-Received: by 2002:a19:c783:: with SMTP id x125mr2993866lff.303.1608373618615;
	Sat, 19 Dec 2020 02:26:58 -0800 (PST)
MIME-Version: 1.0
References: <3baec678cfdc3c8ed2024b2df2f316d1694fe699.camel@suse.com>
In-Reply-To: <3baec678cfdc3c8ed2024b2df2f316d1694fe699.camel@suse.com>
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 19 Dec 2020 11:26:47 +0100
X-Gmail-Original-Message-ID: <CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
Message-ID: <CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] Basic Github CI for multipath-tools
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
Content-Type: multipart/mixed; boundary="===============3165325291209893650=="

--===============3165325291209893650==
Content-Type: multipart/alternative; boundary="000000000000342d5005b6ceaaf5"

--000000000000342d5005b6ceaaf5
Content-Type: text/plain; charset="UTF-8"

Sure, nice work.

Would you like to create a PR, to merge it upstream ?
So we can test if this process makes sense.

Regards,
Christophe

On Sat, Dec 19, 2020 at 1:07 AM Martin Wilck <mwilck@suse.com> wrote:

> Hi Christophe, all,
>
> I have created a basic CI for multipath-tools on github:
>
> https://github.com/openSUSE/multipath-tools/actions
>
> It builds multipath-tools with different compilers and runs the
> unit tests. It's currently on the "upstream-tip" branch only,
> which is otherwise identical to upstream-queue (today, at least).
>
> Christophe, would you be willing to pull this into the main
> repo one day?
>
> Regards,
> Martin
>
>
>

--000000000000342d5005b6ceaaf5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sure, nice work.<div><br></div><div>Would you like to crea=
te a PR, to merge it upstream ?</div><div>So we can test if this process ma=
kes sense.</div><div><br></div><div>Regards,</div><div>Christophe</div></di=
v><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On S=
at, Dec 19, 2020 at 1:07 AM Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.=
com">mwilck@suse.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">Hi Christophe, all,<br>
<br>
I have created a basic CI for multipath-tools on github:<br>
<br>
<a href=3D"https://github.com/openSUSE/multipath-tools/actions" rel=3D"nore=
ferrer" target=3D"_blank">https://github.com/openSUSE/multipath-tools/actio=
ns</a><br>
<br>
It builds multipath-tools with different compilers and runs the<br>
unit tests. It&#39;s currently on the &quot;upstream-tip&quot; branch only,=
<br>
which is otherwise identical to upstream-queue (today, at least).<br>
<br>
Christophe, would you be willing to pull this into the main<br>
repo one day?<br>
<br>
Regards,<br>
Martin<br>
<br>
<br>
</blockquote></div>

--000000000000342d5005b6ceaaf5--

--===============3165325291209893650==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============3165325291209893650==--

