Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D53C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 07:38:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7743161936
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 07:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7743161936
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-9CL0W9fGMiCqQAWD0hyQiw-1; Mon, 29 Mar 2021 03:38:18 -0400
X-MC-Unique: 9CL0W9fGMiCqQAWD0hyQiw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1650F107BEF5;
	Mon, 29 Mar 2021 07:38:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 536785C5DF;
	Mon, 29 Mar 2021 07:38:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08DD41809C83;
	Mon, 29 Mar 2021 07:38:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12T7aiaR001462 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 03:36:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DB4AD2026D2D; Mon, 29 Mar 2021 07:36:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D50862026D11
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 07:36:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8887F182BA09
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 07:36:42 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-93-ODCGHZS8PdqNdo5kcOv-8Q-1;
	Mon, 29 Mar 2021 03:36:37 -0400
X-MC-Unique: ODCGHZS8PdqNdo5kcOv-8Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1FD37AEF5;
	Mon, 29 Mar 2021 07:36:36 +0000 (UTC)
Message-ID: <9674a5110b09998d00e8c5cb5732d8152cffae47.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Mon, 29 Mar 2021 09:36:35 +0200
In-Reply-To: <7c8d1409-253e-6132-2b65-7fc358c302b2@gmail.com>
References: <20210326030839.15452-1-xose.vazquez@gmail.com>
	<c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
	<d07187d1-ff96-b3f8-6ba4-d65d7d739b2f@gmail.com>
	<ac3799dd447f9f4107f88b69fbd9562d730ff27a.camel@suse.com>
	<7c8d1409-253e-6132-2b65-7fc358c302b2@gmail.com>
User-Agent: Evolution 3.38.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12T7aiaR001462
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-03-27 at 00:50 +0100, Xose Vazquez Perez wrote:
> On 3/26/21 8:55 PM, Martin Wilck wrote:
>=20
> > On Fri, 2021-03-26 at 19:10 +0100, Xose Vazquez Perez wrote:
>=20
> > > 1.- It's the official vendor recommendation, and people trust it
> > > blindly
> > > =A0=A0=A0=A0=A0 above the multipath-tools setting. Sad but true.
> > > =A0=A0=A0=A0=A0 So it's going to be manually replaced by the vendor's
> > > config.
> >=20
> > Some users are like that, sure. But if that was generally true, we
> > wouldn't need to adapt our defaults, because everyone would copy
> > the
> > configs from the vendor manuals.
>=20
> I would like that HUAWEI guys fix their docs. Or much better,
> make their arrays always work in ALUA mode. I do not see what the
> problem is. Other vendors do this with A/A arrays.
>=20
> > > 2.- It generates an awful warning:
> > >=20
> > > =A0=A0=A0=A0=A0 [This is SLES 12SP5 with 4.12.14-122.54-default on x8=
6_64
> > > =A0=A0=A0=A0=A0 and multipath-tools-0.7.9+195+suse.16740c5-3.6.1.x86_=
64]
> > >=20
> > > # multipath -ll
> > >=20
> > > Mar 26 18:34:46 | sdi: prio =3D const (setting: emergency fallback
> > > -
> > > alua failed)
> > > Mar 26 18:34:46 | sdj: prio =3D const (setting: emergency fallback
> > > -
> > > alua failed)
> > > Mar 26 18:34:46 | sdk: prio =3D const (setting: emergency fallback
> > > -
> > > alua failed)
> > > Mar 26 18:34:46 | sdl: prio =3D const (setting: emergency fallback
> > > -
> > > alua failed)
> > > 36a35324100e5x5d408d0526600000001 dm-1 HUAWEI,XSG1
> > > size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
> > > `-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
> > > =A0=A0=A0 |- 0:0:4:1 sdi 8:128 active ready running
> > > =A0=A0=A0 |- 0:0:5:1 sdj 8:144 active ready running
> > > =A0=A0=A0 |- 1:0:4:1 sdk 8:160 active ready running
> > > =A0=A0=A0 `- 1:0:5:1 sdl 8:176 active ready running
> > >=20
> > > =A0=A0=A0=A0=A0 No nice, mainly for people without knowledge of mpt
> > > internals.
> >=20
> > The problem is that the prioritizer was explicitly set to "alua".
> > Therefore multipathd warns, because the configured setting couldn't
> > be
> > applied. We could just drop that line, alua would still be selected
> > by
> > the autodetection if it was supported, and the message wouldn't be
> > printed any more otherwise. Setting "multibus" explicitly isn't
> > necessary.
> >=20
> > Can we agree on that?
>=20
> Something like the patch below?
> It's a frankenstein config, and ALUA should only work for kernels >=3D
> 4.3

Yes. That's good enough IMO. People running older kernels can use the
explicit config (and likely have been doing so anyway).

Add a comment explaining the "hypermetro" dependency, perhaps.

Martin


>=20
> ------
> =A0From 47c505f853b37c38d847b411fc7ba763c61ad87b Mon Sep 17 00:00:00
> 2001
> From: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Date: Sat, 27 Mar 2021 00:13:57 +0100
> Subject: [PATCH] multipath-tools: make HUAWEI/XSG1 config work with
> alua and multibus
> X-Patchwork-Bot: notify
>=20
> And add recommended no_path_retry and pgfailback values.
>=20
> Info from:
> - RHEL=20
> https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddownload=
&nid=3DEDOC1100113070&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885511000
> - SLES=20
> https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddownload=
&nid=3DEDOC1100117892&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885538000
>=20
> - without HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy multibus
> no_path_retry 15
>=20
> - with HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy group_by_prio
> prio alua
> failback immediate
> no_path_retry 15
>=20
> ALUA is only used with HyperMetro(cluster of two arrays).
>=20
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =A0 libmultipath/hwtable.c | 3 ++-
> =A0 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 58fa7387..f09af30e 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1082,7 +1082,8 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "HUAWEI",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D "XSG1",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.prio_name=A0=A0=A0=A0 =3D =
PRIO_ALUA,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D -F=
AILBACK_IMMEDIATE,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D 15,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Kove



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

