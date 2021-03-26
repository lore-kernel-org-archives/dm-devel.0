Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFE1C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 23:51:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B362361993
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 23:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B362361993
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504--PeS2_UHNLmegaJpua3yJg-1; Fri, 26 Mar 2021 19:50:57 -0400
X-MC-Unique: -PeS2_UHNLmegaJpua3yJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2DA381746E;
	Fri, 26 Mar 2021 23:50:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F27125D6DC;
	Fri, 26 Mar 2021 23:50:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C4DD4BB7C;
	Fri, 26 Mar 2021 23:50:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QNomgs015752 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 19:50:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3B62910545C3; Fri, 26 Mar 2021 23:50:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36DD71112C3C
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 23:50:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FCAC185A7B2
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 23:50:45 +0000 (UTC)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
	[209.85.221.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-16-8sdV7hlnNZubovXWvd6PdA-1; Fri, 26 Mar 2021 19:50:43 -0400
X-MC-Unique: 8sdV7hlnNZubovXWvd6PdA-1
Received: by mail-wr1-f42.google.com with SMTP id v11so7131243wro.7;
	Fri, 26 Mar 2021 16:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=M+PQnIkV3+gVEFRjrcyaTRchrQ0uO17XWUZMBVGlqWM=;
	b=WXmdzDyHn+BH/DnNLkLuFky0O6Yft9anVkRtrVRxC0YP3xVj0aT+Dx9CV5adT4hEvF
	FlwzN0R43YsGJdbY2GkgKdET/PUBlwycrfPni+CQL6LARIkYtATP5UDKiMjqO+Wn1Yrj
	fYa0/0Dz/pq6IxjoC5yDT+j64QVTRxGzYU8g5kVPDSJy3zXwNLtXK46OUS5LAurwfXI5
	qVQzAZqSqRn7uOJRTia6HVTokWDb8Tc1OHJsIYA1/KrLiMWUP9MtJEW3dUGnA0kgXZ2c
	FzTjlKeRQ4FQ2kwOxCZJf5lECGuxZU7UknART2KNxyp6QaSBPQJ1VCdWRp1HEIkJ6jZh
	JAAg==
X-Gm-Message-State: AOAM532+SBlt4qKyxH9hn08+E/xvf62i+PBm07BrujB1QjYj8hMQDt+c
	IooSdqnS5LPzTqkexgpNWQZ/20MQLg==
X-Google-Smtp-Source: ABdhPJxIoFiZtNFcqN1RkUQPTow78y5UhPx6fkyxgq37BvkJU7pAIM99FTPseXqAHY6sWtXzpB3rLg==
X-Received: by 2002:a5d:6106:: with SMTP id v6mr5218251wrt.268.1616802642012; 
	Fri, 26 Mar 2021 16:50:42 -0700 (PDT)
Received: from localhost (92.red-83-33-157.dynamicip.rima-tde.net.
	[83.33.157.92]) by smtp.gmail.com with ESMTPSA id
	p27sm14311223wmi.12.2021.03.26.16.50.41
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 26 Mar 2021 16:50:41 -0700 (PDT)
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20210326030839.15452-1-xose.vazquez@gmail.com>
	<c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
	<d07187d1-ff96-b3f8-6ba4-d65d7d739b2f@gmail.com>
	<ac3799dd447f9f4107f88b69fbd9562d730ff27a.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <7c8d1409-253e-6132-2b65-7fc358c302b2@gmail.com>
Date: Sat, 27 Mar 2021 00:50:40 +0100
MIME-Version: 1.0
In-Reply-To: <ac3799dd447f9f4107f88b69fbd9562d730ff27a.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Zhouweigang <zhouweigang09@huawei.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: convert back HUAWEI/XSG1 to
	multibus
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
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

On 3/26/21 8:55 PM, Martin Wilck wrote:

> On Fri, 2021-03-26 at 19:10 +0100, Xose Vazquez Perez wrote:

>> 1.- It's the official vendor recommendation, and people trust it
>> blindly
>>  =A0=A0=A0=A0 above the multipath-tools setting. Sad but true.
>>  =A0=A0=A0=A0 So it's going to be manually replaced by the vendor's conf=
ig.
>=20
> Some users are like that, sure. But if that was generally true, we
> wouldn't need to adapt our defaults, because everyone would copy the
> configs from the vendor manuals.

I would like that HUAWEI guys fix their docs. Or much better,
make their arrays always work in ALUA mode. I do not see what the
problem is. Other vendors do this with A/A arrays.

>> 2.- It generates an awful warning:
>>
>>  =A0=A0=A0=A0 [This is SLES 12SP5 with 4.12.14-122.54-default on x86_64
>>  =A0=A0=A0=A0 and multipath-tools-0.7.9+195+suse.16740c5-3.6.1.x86_64]
>>
>> # multipath -ll
>>
>> Mar 26 18:34:46 | sdi: prio =3D const (setting: emergency fallback -
>> alua failed)
>> Mar 26 18:34:46 | sdj: prio =3D const (setting: emergency fallback -
>> alua failed)
>> Mar 26 18:34:46 | sdk: prio =3D const (setting: emergency fallback -
>> alua failed)
>> Mar 26 18:34:46 | sdl: prio =3D const (setting: emergency fallback -
>> alua failed)
>> 36a35324100e5x5d408d0526600000001 dm-1 HUAWEI,XSG1
>> size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
>>  =A0=A0 |- 0:0:4:1 sdi 8:128 active ready running
>>  =A0=A0 |- 0:0:5:1 sdj 8:144 active ready running
>>  =A0=A0 |- 1:0:4:1 sdk 8:160 active ready running
>>  =A0=A0 `- 1:0:5:1 sdl 8:176 active ready running
>>
>>  =A0=A0=A0=A0 No nice, mainly for people without knowledge of mpt intern=
als.
>=20
> The problem is that the prioritizer was explicitly set to "alua".
> Therefore multipathd warns, because the configured setting couldn't be
> applied. We could just drop that line, alua would still be selected by
> the autodetection if it was supported, and the message wouldn't be
> printed any more otherwise. Setting "multibus" explicitly isn't
> necessary.
>=20
> Can we agree on that?

Something like the patch below?
It's a frankenstein config, and ALUA should only work for kernels >=3D 4.3

------
 From 47c505f853b37c38d847b411fc7ba763c61ad87b Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Sat, 27 Mar 2021 00:13:57 +0100
Subject: [PATCH] multipath-tools: make HUAWEI/XSG1 config work with alua an=
d multibus
X-Patchwork-Bot: notify

And add recommended no_path_retry and pgfailback values.

Info from:
- RHEL https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddow=
nload&nid=3DEDOC1100113070&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885511000
- SLES https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddow=
nload&nid=3DEDOC1100117892&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885538000

- without HyperMetro:
vendor "HUAWEI"
product "XSG1"
path_grouping_policy multibus
no_path_retry 15

- with HyperMetro:
vendor "HUAWEI"
product "XSG1"
path_grouping_policy group_by_prio
prio alua
failback immediate
no_path_retry 15

ALUA is only used with HyperMetro(cluster of two arrays).

Suggested-by: Martin Wilck <mwilck@suse.com>
Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
  libmultipath/hwtable.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 58fa7387..f09af30e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1082,7 +1082,8 @@ static struct hwentry default_hw[] =3D {
  =09=09.vendor        =3D "HUAWEI",
  =09=09.product       =3D "XSG1",
  =09=09.pgpolicy      =3D GROUP_BY_PRIO,
-=09=09.prio_name     =3D PRIO_ALUA,
+=09=09.pgfailback    =3D -FAILBACK_IMMEDIATE,
+=09=09.no_path_retry =3D 15,
  =09},
  =09/*
  =09 * Kove
--=20
2.30.2


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

