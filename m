Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BA8C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 19:58:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 07AAC61995
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 19:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07AAC61995
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-622MSuCYPL-Cl3yQ3-hseQ-1; Fri, 26 Mar 2021 15:58:29 -0400
X-MC-Unique: 622MSuCYPL-Cl3yQ3-hseQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40A271084C9F;
	Fri, 26 Mar 2021 19:58:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A0A1349A;
	Fri, 26 Mar 2021 19:58:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B4DA1809C84;
	Fri, 26 Mar 2021 19:58:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QJtZlg023585 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 15:55:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1EBBD2026D65; Fri, 26 Mar 2021 19:55:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 195C12026D48
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 19:55:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5342E101A531
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 19:55:32 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-20-nc1-kOWOOwaOTLOQDYeU8w-1;
	Fri, 26 Mar 2021 15:55:26 -0400
X-MC-Unique: nc1-kOWOOwaOTLOQDYeU8w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BD394AC6A;
	Fri, 26 Mar 2021 19:55:24 +0000 (UTC)
Message-ID: <ac3799dd447f9f4107f88b69fbd9562d730ff27a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	<bmarzins@redhat.com>
Date: Fri, 26 Mar 2021 20:55:23 +0100
In-Reply-To: <d07187d1-ff96-b3f8-6ba4-d65d7d739b2f@gmail.com>
References: <20210326030839.15452-1-xose.vazquez@gmail.com>
	<c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
	<d07187d1-ff96-b3f8-6ba4-d65d7d739b2f@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QJtZlg023585
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-03-26 at 19:10 +0100, Xose Vazquez Perez wrote:
> On 3/26/21 6:24 PM, Martin Wilck wrote:
>=20
> > Forgive me if I'm missing something here, but what is this good
> > for?
> > multipathd detects ALUA support by default.
> >=20
> > =A0 1 if the device doesn't support ALUA, it falls back to "const"
> > anyway,
> > =A0=A0=A0 in which case "group_by_prio" degenerates to "multibus" - whi=
ch
> > is
> > =A0=A0=A0 exactly what this patch does;
> > =A0 2 if the device supports ALUA, but returns the same ALUA state
> > for
> > =A0=A0=A0 all ports, again "group_by_prio" degenerates to "multibus";
> > =A0 3 if the device supports ALUA and returns different states for
> > =A0=A0=A0 different ports, "group_by_prio" is the best bet anyway.
> >=20
> > So why not just use "group_by_prio"?
> You are right, but:
>=20
> 1.- It's the official vendor recommendation, and people trust it
> blindly
> =A0=A0=A0=A0 above the multipath-tools setting. Sad but true.
> =A0=A0=A0=A0 So it's going to be manually replaced by the vendor's config=
.

Some users are like that, sure. But if that was generally true, we
wouldn't need to adapt our defaults, because everyone would copy the
configs from the vendor manuals.

> 2.- It generates an awful warning:
>=20
> =A0=A0=A0=A0 [This is SLES 12SP5 with 4.12.14-122.54-default on x86_64
> =A0=A0=A0=A0 and multipath-tools-0.7.9+195+suse.16740c5-3.6.1.x86_64]
>=20
> # multipath -ll
>=20
> Mar 26 18:34:46 | sdi: prio =3D const (setting: emergency fallback -
> alua failed)
> Mar 26 18:34:46 | sdj: prio =3D const (setting: emergency fallback -
> alua failed)
> Mar 26 18:34:46 | sdk: prio =3D const (setting: emergency fallback -
> alua failed)
> Mar 26 18:34:46 | sdl: prio =3D const (setting: emergency fallback -
> alua failed)
> 36a35324100e5x5d408d0526600000001 dm-1 HUAWEI,XSG1
> size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
> =A0=A0 |- 0:0:4:1 sdi 8:128 active ready running
> =A0=A0 |- 0:0:5:1 sdj 8:144 active ready running
> =A0=A0 |- 1:0:4:1 sdk 8:160 active ready running
> =A0=A0 `- 1:0:5:1 sdl 8:176 active ready running
>=20
> =A0=A0=A0=A0 No nice, mainly for people without knowledge of mpt internal=
s.

The problem is that the prioritizer was explicitly set to "alua".
Therefore multipathd warns, because the configured setting couldn't be
applied. We could just drop that line, alua would still be selected by
the autodetection if it was supported, and the message wouldn't be
printed any more otherwise. Setting "multibus" explicitly isn't
necessary.

Can we agree on that?

>=20
> 3.- The LUN is blacklisted by Fedora and
> derivatives(RHEL,CentOS,Oracle,...)
> =A0=A0=A0=A0 And the installation program is unable to see it, this invol=
ves
> manual intervention.
> =A0=A0=A0=A0 See page 76 of the OceanStor RHEL Guide.
>=20

That would be for Ben to fix ;-)

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

