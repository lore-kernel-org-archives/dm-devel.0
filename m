Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0723C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Mar 2022 06:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646202390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=j5gPS02vB+G1lsFqpyrBtvwe7UoeBzr03hpojmXF4bs=;
	b=KOsYs5QY7tmA1l4h+j2ODECJL0xxydVuM1CoKStyKbAU2B547RlCUvMw+NGMjTMv4rdGxZ
	zz2LUP/4Hd05180DQ+Hxa7pI9LuFC1HXBrMxHugt14F3EfMH21pGmZOrM5EjgUyBrOjvT1
	8ZNG8EPwXXtZbb1y4IpRnbiRgfYBw8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-MUPlQJtyNRiBmFYK8vs_zA-1; Wed, 02 Mar 2022 01:26:28 -0500
X-MC-Unique: MUPlQJtyNRiBmFYK8vs_zA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB53106B3A6;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 628697CAFB;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DF7944A5C;
	Wed,  2 Mar 2022 06:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221G6h5g032533 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 11:06:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A3C7400DFB2; Tue,  1 Mar 2022 16:06:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6550440CFD02
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 16:06:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F088F82A682
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 16:06:42 +0000 (UTC)
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
	[209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-43-TgYF850TPfeX-WbnWwmz8w-1; Tue, 01 Mar 2022 11:06:41 -0500
X-MC-Unique: TgYF850TPfeX-WbnWwmz8w-1
Received: by mail-ua1-f71.google.com with SMTP id
	l11-20020ab05a0b000000b00346ea0dfe5dso4240145uad.11
	for <dm-devel@redhat.com>; Tue, 01 Mar 2022 08:06:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=PnAJu4IyOHdBxq/LY26iu1F4PkFL3t7VTOyztkYEGow=;
	b=XEkOy4l1OGby/nvKJGjO/dQICvwfcVOvJKPbeZmapqV/hWWeowtozdgVjYHcX6j5jN
	S9glhPFwqJVluAO4Vt0lKa20Q45lSah3x5BSQZiBdcyFn4XlC8Vt/duUYSzGlc6oSNUs
	zE/3e9ZnDPnUtao3H7fXsgCL9bb08zZBmunWEVgCTSuwnQ1A9X8erf8fEiDcqSmvJbWr
	CGgDaIAigeSlySK1mgqKKCqVeIWI7LA/n3L9wyLYmbPEk1ztxJVDcIiCaFKF4nCCqoW9
	xbJYIUW1jSYToRzuWhVjAtawn2zOQUoq2vs5eFwAqjNhuQAC2ZcecXzCLEBMsX2w1mng
	v5Fw==
X-Gm-Message-State: AOAM531resxh0+n3Dzqt4lEYkSB6hqENQ+h0JkajBI/TxCm1I/0ZRoEi
	kXUqz+rNFD0/Kwf5OmY7peWorRc1QILuQr5EfOHttGrLSrRtWo30NDDbVHBGWSLdT5YT/+tmphU
	3zS/U7G8z0ekeI5lGsVXyUmgCqqAWgW8=
X-Received: by 2002:a67:fb4b:0:b0:31e:a04c:9b60 with SMTP id
	e11-20020a67fb4b000000b0031ea04c9b60mr3679097vsr.39.1646150800870;
	Tue, 01 Mar 2022 08:06:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2vRahcppKTFP25TjFwhTlMKEWuJ1lbCeMFXJl2i+1KsN5weRjcl+75onruKq5XiN2U4eWIDS8XaUiMCuRxw4=
X-Received: by 2002:a67:fb4b:0:b0:31e:a04c:9b60 with SMTP id
	e11-20020a67fb4b000000b0031ea04c9b60mr3679073vsr.39.1646150800643;
	Tue, 01 Mar 2022 08:06:40 -0800 (PST)
MIME-Version: 1.0
References: <20220228141354.1091687-1-luomeng12@huawei.com>
	<YhzsJKjj4VK1wK/W@redhat.com>
	<f73ee01c-49be-a0d3-3646-0afdf166720a@huawei.com>
In-Reply-To: <f73ee01c-49be-a0d3-3646-0afdf166720a@huawei.com>
From: Edward Thornber <thornber@redhat.com>
Date: Tue, 1 Mar 2022 16:06:29 +0000
Message-ID: <CAJ0trDYi5SUHd3fnLL9sKf4rKMyuhDOtD1ASwkd9F9_EczjSfg@mail.gmail.com>
To: luomeng <luomeng12@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Mar 2022 01:25:55 -0500
Cc: yukuai3@huawei.com, "development, device-mapper" <dm-devel@redhat.com>,
	agk <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	ejt <ejt@redhat.com>
Subject: Re: [dm-devel] Revert "dm space maps: don't reset space map
 allocation cursor when committing"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0301766545337779046=="

--===============0301766545337779046==
Content-Type: multipart/alternative; boundary="000000000000b8298405d92a59d1"

--000000000000b8298405d92a59d1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm having trouble understanding your issue.  Does your ramdisk only
allocate backing memory on demand?  (ie. is the ramdisk itself a thinly
provisioned device?).  If so, not supporting discard seems to be the
problem.

Thinp makes no promises about where it will allocate your data.  If you
write a file, delete it, discard and then rewrite the file there is no
guarantee that the file will be written to the same location.

On Tue, Mar 1, 2022 at 2:08 PM luomeng <luomeng12@huawei.com> wrote:

> Because thin-pool is storage over-commitment, one of the following
> scenarios exists: constantly create and delete file, then the search
> doesn't hit the end of the metadata device, but ramdisk hits the end
> (not support discard). So the cursor doesn't reset.
>
> =E5=9C=A8 2022/2/28 23:37, Mike Snitzer =E5=86=99=E9=81=93:
> > What you're saying doesn't make any sense.  Especially when you
> > consider this last part of the commit message:
> > "Fix these issues by leaving the cursor alone, only resetting when the
> >   search hits the end of the metadata device."
>
>

--000000000000b8298405d92a59d1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;m having trouble understanding your issue.=C2=A0 Doe=
s your ramdisk only allocate backing memory on demand?=C2=A0 (ie. is the ra=
mdisk itself a thinly provisioned device?).=C2=A0 If so, not supporting dis=
card seems to be the problem.<div><br></div><div>Thinp makes no promises ab=
out where it will allocate your data.=C2=A0 If you write a file, delete it,=
 discard and then rewrite the file there is no guarantee that the file will=
 be written to the same location.</div></div><br><div class=3D"gmail_quote"=
><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Mar 1, 2022 at 2:08 PM luome=
ng &lt;<a href=3D"mailto:luomeng12@huawei.com">luomeng12@huawei.com</a>&gt;=
 wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Because =
thin-pool is storage over-commitment, one of the following <br>
scenarios exists: constantly create and delete file, then the search <br>
doesn&#39;t hit the end of the metadata device, but ramdisk hits the end <b=
r>
(not support discard). So the cursor doesn&#39;t reset.<br>
<br>
=E5=9C=A8 2022/2/28 23:37, Mike Snitzer =E5=86=99=E9=81=93:<br>
&gt; What you&#39;re saying doesn&#39;t make any sense.=C2=A0 Especially wh=
en you<br>
&gt; consider this last part of the commit message:<br>
&gt; &quot;Fix these issues by leaving the cursor alone, only resetting whe=
n the<br>
&gt;=C2=A0 =C2=A0search hits the end of the metadata device.&quot;<br>
<br>
</blockquote></div>

--000000000000b8298405d92a59d1--

--===============0301766545337779046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============0301766545337779046==--

