Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BBCC433E0
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 11:27:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8AC1A23142
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 11:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AC1A23142
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-7adpIVUmMwCoONFkV4k_MA-1; Thu, 07 Jan 2021 06:27:48 -0500
X-MC-Unique: 7adpIVUmMwCoONFkV4k_MA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 377A910054FF;
	Thu,  7 Jan 2021 11:27:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77E975D9D7;
	Thu,  7 Jan 2021 11:27:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A82D54BB7B;
	Thu,  7 Jan 2021 11:27:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 107BRanY012136 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 06:27:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BCAC6100BFFA; Thu,  7 Jan 2021 11:27:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8EE2100BFF1
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 11:27:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F2D5101A53F
	for <dm-devel@redhat.com>; Thu,  7 Jan 2021 11:27:33 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-26-DxvLcKp2PiyBL44r5bT6fw-1;
	Thu, 07 Jan 2021 06:27:31 -0500
X-MC-Unique: DxvLcKp2PiyBL44r5bT6fw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id F3B55AD12;
	Thu,  7 Jan 2021 11:27:29 +0000 (UTC)
Message-ID: <bdeb04efcac09880451505ca2970c6d322c48da5.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Chongyun Wu <wucy11@chinatelecom.cn>, Benjamin Marzinski
	<bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Date: Thu, 07 Jan 2021 12:27:26 +0100
In-Reply-To: <ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
References: <4ca7da32-5777-9089-1e96-a5dbb46c585a@chinatelecom.cn>
	<4c7286abbdd79fc0c726fd119fdda3b7a140e056.camel@suse.com>
	<ffb39ebe-ab7e-f82a-f4cb-5b8353bfda2a@chinatelecom.cn>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 107BRanY012136
X-loop: dm-devel@redhat.com
Cc: yubin1@chinatelecom.cn, zhangzijian@chinatelecom.cn
Subject: Re: [dm-devel] [PATCH] multipathd: LUN protection by checking
 path's wwid change status
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-07 at 10:23 +0800, Chongyun Wu wrote:
> Hello Martin,
> Thanks for view this patch.
>=20
> On 2021/1/7 5:10, Martin Wilck wrote:
> > Hello Chongyun,
> >=20
> > On Mon, 2020-12-28 at 11:34 +0800, Chongyun Wu wrote:
> > > =A0=A0From 37c74873acfc1587e79a6504ca3d42b8fa00d49e Mon Sep 17
> > > 00:00:00
> > > 2001
> > >=20
> > > From: Chongyun Wu <wucy11@chinatelecom.cn>
> > > Date: Mon, 21 Dec 2020 09:51:20 +0800
> > > Subject: [PATCH] multipathd: LUN data protection by checking
> > > path's
> > > wwid
> > > =A0=A0=A0change status
> > >=20
> > > Issue description:
> > > A) Device sda and sdb correspend to LUN1 and LUN2 in storage
> > > backend
> > > and
> > > the upper layer application uses those two devices.
> > > B) Doing illegal operation: unmapping LUN1 and LUN2 in storage
> > > backend,
> > > and export LUN2 and LUN1 to host with exchanged assignment
> > > relation
> > > between sda and sdb.
> > > C) The upper layer application run for a while and found that the
> > > data
> > > in both LUN1 and LUN2 has been corrupted.
> >=20
> > Can you please be explicit about which multipath-tools version you
> > have
> > tested? I thought we had the wwid change issues covered. Ben and I
> > have
> > been putting quite some effort into this recently. Of course we can
> > be
> > wrong, but I'd like to understand the issue fully.
> >=20
> The test version is 0.8.3.

A test with 0.8.5 would be in necessary, then. The INIT_REMOVED logic
has been added after 0.8.4.
> >=20
> > Please confirm that you've been using the latest version from
> > Christophe's repo (or better even, from my upstream-queue), and
> > provide
> > -v3 logs showing what goes wrong.
> Sorry Martin, I haven't save the logs and the enviroment is
> unavailable now.

Well, please report back if you can reproduce the issue with current
upstream.

Regards,
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

