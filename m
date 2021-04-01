Return-Path: <SRS0=Hv8r=I6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F47C433ED
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 16:00:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 273F86112E
	for <dm-devel@archiver.kernel.org>; Thu,  1 Apr 2021 16:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 273F86112E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=opensvc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-XlAcRLvzPBGlwIAtC_SGhw-1; Thu, 01 Apr 2021 12:00:48 -0400
X-MC-Unique: XlAcRLvzPBGlwIAtC_SGhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E48B6853ED4;
	Thu,  1 Apr 2021 16:00:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C64B41001281;
	Thu,  1 Apr 2021 16:00:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 887591809C83;
	Thu,  1 Apr 2021 16:00:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 131G0W7d007756 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 1 Apr 2021 12:00:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E8892026D07; Thu,  1 Apr 2021 16:00:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 275E42026D6B
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 16:00:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28DF6802BEE
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 16:00:29 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net
	[217.70.178.240]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-154-KFDEaE4rMSW_LIO33RV2cg-1; Thu, 01 Apr 2021 12:00:26 -0400
X-MC-Unique: KFDEaE4rMSW_LIO33RV2cg-1
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id B34E9D3BDA
	for <dm-devel@redhat.com>; Thu,  1 Apr 2021 15:32:04 +0000 (UTC)
X-Originating-IP: 209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
	[209.85.215.169]) (Authenticated sender: smtp@opensvc.com)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DE5E1E0007;
	Thu,  1 Apr 2021 15:31:59 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id t140so1728452pgb.13;
	Thu, 01 Apr 2021 08:31:59 -0700 (PDT)
X-Gm-Message-State: AOAM533j7cdcf1M/ISGCMkCyRZlBfrhMqQUEzcas5m5mJEyQCidkQDza
	pDhYmUpLVbKU9CQD7+RFinKv1FksAIdc8Y7a7r4=
X-Google-Smtp-Source: ABdhPJxX7fXPcaJgU3D834w9DPoAvFrer4zt/VmB2cf/mSpySSuivR7qu/n0aGH12CkaP4JdALwVyyLN/CtPRVhlB2c=
X-Received: by 2002:aa7:9982:0:b029:222:4029:7447 with SMTP id
	k2-20020aa799820000b029022240297447mr7924819pfh.34.1617291117985;
	Thu, 01 Apr 2021 08:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <6e41265416b9487f5af4b160c28da3294a8ae1f2.camel@suse.com>
In-Reply-To: <6e41265416b9487f5af4b160c28da3294a8ae1f2.camel@suse.com>
From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 1 Apr 2021 17:31:46 +0200
X-Gmail-Original-Message-ID: <CABr-GnfZEuvc0WU_DRpHdKzR=1BqT8Edeianjv-K6cOxjNF8eA@mail.gmail.com>
Message-ID: <CABr-GnfZEuvc0WU_DRpHdKzR=1BqT8Edeianjv-K6cOxjNF8eA@mail.gmail.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath-tools pull request
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2974425461224176578=="

--===============2974425461224176578==
Content-Type: multipart/alternative; boundary="00000000000096050605beeaee91"

--00000000000096050605beeaee91
Content-Type: text/plain; charset="UTF-8"

Thank you for this new process.
The PR is merged and the version is tagged.

On Tue, Mar 30, 2021 at 2:52 PM Martin Wilck <mwilck@suse.com> wrote:

> @All,
>
> I've created a pull request for multipath-tools:
> https://github.com/opensvc/multipath-tools/pull/4
>
> Please contact me if you find something wrong or missing.
>
> Regards
> Martin
>
>
>

--00000000000096050605beeaee91
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you for this new process.<div>The PR is merged and t=
he version is tagged.</div></div><br><div class=3D"gmail_quote"><div dir=3D=
"ltr" class=3D"gmail_attr">On Tue, Mar 30, 2021 at 2:52 PM Martin Wilck &lt=
;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">@All,<br>
<br>
I&#39;ve created a pull request for multipath-tools:<br>
<a href=3D"https://github.com/opensvc/multipath-tools/pull/4" rel=3D"norefe=
rrer" target=3D"_blank">https://github.com/opensvc/multipath-tools/pull/4</=
a><br>
<br>
Please contact me if you find something wrong or missing.<br>
<br>
Regards<br>
Martin<br>
<br>
<br>
</blockquote></div>

--00000000000096050605beeaee91--

--===============2974425461224176578==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2974425461224176578==--

