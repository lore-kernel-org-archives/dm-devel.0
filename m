Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3648AC433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:59:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 68D222067B
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68D222067B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-esJ2AVd1N3iRZiafP-BnYg-1; Mon, 25 Jan 2021 13:59:06 -0500
X-MC-Unique: esJ2AVd1N3iRZiafP-BnYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B7FF180A0A9;
	Mon, 25 Jan 2021 18:59:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12ED461D33;
	Mon, 25 Jan 2021 18:59:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 87016180954D;
	Mon, 25 Jan 2021 18:58:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PItgQN009432 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 13:55:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C88F6B435; Mon, 25 Jan 2021 18:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E126D9D4
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:55:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E65E858EEC
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:55:39 +0000 (UTC)
Received: from mslow2.mail.gandi.net (mslow2.mail.gandi.net
	[217.70.178.242]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-146-NpKPwt77Pb-nrh_mEeHaLA-1; Mon, 25 Jan 2021 13:55:36 -0500
X-MC-Unique: NpKPwt77Pb-nrh_mEeHaLA-1
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
	by mslow2.mail.gandi.net (Postfix) with ESMTP id 059323B4650
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:27:06 +0000 (UTC)
X-Originating-IP: 209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
	[209.85.215.172]) (Authenticated sender: smtp@opensvc.com)
	by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A2B42FF808;
	Mon, 25 Jan 2021 18:26:59 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id p18so9477665pgm.11;
	Mon, 25 Jan 2021 10:26:59 -0800 (PST)
X-Gm-Message-State: AOAM530hmnbbosAAGtoCGqyYoP9hdEZ2ndvKp8Rqmma/vVG+/e1uvuxu
	Ip7vqNErAUh+SJ7it4GhHR8m80S1gnjVf8y6Gpg=
X-Google-Smtp-Source: ABdhPJz6kg1yXjeL8xYOaJSsYaDHJbhLYt3PKB5RcrwW7ootZdjx/qAFtby89Ds660t8/R0HfAd0lA8YrO4hI+yQc+k=
X-Received: by 2002:a63:5c61:: with SMTP id n33mr1844394pgm.153.1611599218044; 
	Mon, 25 Jan 2021 10:26:58 -0800 (PST)
MIME-Version: 1.0
References: <3baec678cfdc3c8ed2024b2df2f316d1694fe699.camel@suse.com>
	<CABr-Gnd1TJhd7QSge+vAwrJZSHuUjW7hbKd-sFwx=zdNotv_Eg@mail.gmail.com>
	<85d7c08115fd50c413ddcd957f22f40db2215f19.camel@suse.com>
	<f74cbc725ec8cb75016e8061c46eeb628d30bb25.camel@suse.com>
	<eabe0f24-b32f-ff5f-b808-b2c501263d8f@suse.de>
	<b40493f4316db496e80f2aca8215ac52f5acb99a.camel@suse.com>
	<20210111184239.GV3103@octiron.msp.redhat.com>
	<f9634efeb24fcfca360ab93169050c9eb276f9b7.camel@suse.com>
In-Reply-To: <f9634efeb24fcfca360ab93169050c9eb276f9b7.camel@suse.com>
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 25 Jan 2021 19:26:46 +0100
X-Gmail-Original-Message-ID: <CABr-Gnd58Z5fqpepckE4sRRG5MEBpK39ee4=qjnyGvmGid_3fQ@mail.gmail.com>
Message-ID: <CABr-Gnd58Z5fqpepckE4sRRG5MEBpK39ee4=qjnyGvmGid_3fQ@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath-tools: NEW openSUSE github repo
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
Content-Type: multipart/mixed; boundary="===============0487213405018853778=="

--===============0487213405018853778==
Content-Type: multipart/alternative; boundary="000000000000e9726305b9bdae20"

--000000000000e9726305b9bdae20
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I like it very much.
I pulled "fixes" today.

Thank you for this reorganization of the SuSE repo.

Best regards,
Christophe.


On Mon, Jan 25, 2021 at 4:04 PM Martin Wilck <mwilck@suse.com> wrote:

> On Mon, 2021-01-11 at 12:42 -0600, Benjamin Marzinski wrote:
> > On Mon, Jan 11, 2021 at 03:54:01PM +0100, Martin Wilck wrote:
> > >
> > > We should discuss the git workflow. Until now, I've always rebased
> > > my
> > > branches on Christophe's when pulling. I would like to switch to a
> > > merge-based workflow for "queue" and "fixes". This would make it
> > > easier
> > > for third parties to pull from these branches.=C3=82 It would mean th=
at
> > > Christophe's repo won't keep a fully linear history. I'm not sure
> > > if
> > > that matters to anyone, but I wanted to ask anyway. The "tip"
> > > branch
> > > will continue to be rebased (onto "queue").
> >
> >
> > Souds reasonable.
>
> I made a first merge between "queue" and "fixes" now
>
> Christophe, now would be the time to raise your voice if you dislike
> this.
>
> https://github.com/openSUSE/multipath-tools/commits/queue
> https://github.com/openSUSE/multipath-tools/commits/tip
>
> Regards,
> Martin
>
>
>

--000000000000e9726305b9bdae20
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I like it very much.<div>I pulled &quot;fixes&quot; today.=
</div><div><br></div><div>Thank you for this reorganization of the SuSE rep=
o.</div><div><br></div><div>Best regards,</div><div>Christophe.<br><div><br=
></div></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr">On Mon, Jan 25, 2021 at 4:04 PM Martin Wilck &lt;<a href=3D"ma=
ilto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">On Mon, 2021-01-11 at 12:42 -0600, Ben=
jamin Marzinski wrote:<br>
&gt; On Mon, Jan 11, 2021 at 03:54:01PM +0100, Martin Wilck wrote:<br>
&gt; &gt; <br>
&gt; &gt; We should discuss the git workflow. Until now, I&#39;ve always re=
based<br>
&gt; &gt; my<br>
&gt; &gt; branches on Christophe&#39;s when pulling. I would like to switch=
 to a<br>
&gt; &gt; merge-based workflow for &quot;queue&quot; and &quot;fixes&quot;.=
 This would make it<br>
&gt; &gt; easier<br>
&gt; &gt; for third parties to pull from these branches.=C3=82=C2=A0It woul=
d mean that<br>
&gt; &gt; Christophe&#39;s repo won&#39;t keep a fully linear history. I&#3=
9;m not sure<br>
&gt; &gt; if<br>
&gt; &gt; that matters to anyone, but I wanted to ask anyway. The &quot;tip=
&quot;<br>
&gt; &gt; branch<br>
&gt; &gt; will continue to be rebased (onto &quot;queue&quot;).<br>
&gt; <br>
&gt; <br>
&gt; Souds reasonable. <br>
<br>
I made a first merge between &quot;queue&quot; and &quot;fixes&quot; now<br=
>
<br>
Christophe, now would be the time to raise your voice if you dislike<br>
this.<br>
<br>
<a href=3D"https://github.com/openSUSE/multipath-tools/commits/queue" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/openSUSE/multipath-too=
ls/commits/queue</a><br>
<a href=3D"https://github.com/openSUSE/multipath-tools/commits/tip" rel=3D"=
noreferrer" target=3D"_blank">https://github.com/openSUSE/multipath-tools/c=
ommits/tip</a><br>
<br>
Regards,<br>
Martin<br>
<br>
<br>
</blockquote></div>

--000000000000e9726305b9bdae20--

--===============0487213405018853778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0487213405018853778==--

