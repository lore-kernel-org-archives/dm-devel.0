Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD24FC433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:36:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23B6322482
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23B6322482
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-XIDOc-qPPCuXSpyl2lP9fg-1; Tue, 05 Jan 2021 05:36:18 -0500
X-MC-Unique: XIDOc-qPPCuXSpyl2lP9fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3C72EC1B0;
	Tue,  5 Jan 2021 10:36:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D70B757FA;
	Tue,  5 Jan 2021 10:36:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 047454E58E;
	Tue,  5 Jan 2021 10:35:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105AZroc019199 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 05:35:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6C5111111C93; Tue,  5 Jan 2021 10:35:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 684FB1111C72
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:35:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44D5B8007D9
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:35:51 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-136-3agnQWiSPlyOjIb5IUluTA-1;
	Tue, 05 Jan 2021 05:35:47 -0500
X-MC-Unique: 3agnQWiSPlyOjIb5IUluTA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id AE737AFBF;
	Tue,  5 Jan 2021 10:35:45 +0000 (UTC)
Message-ID: <6ec7da482c72bd437287f0b6f4d96dfe61406d26.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: wucy11 <wucy11@chinatelecom.cn>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Date: Tue, 05 Jan 2021 11:35:45 +0100
In-Reply-To: <008F6ED7-7117-458B-A573-B7396E4EF537@chinatelecom.cn>
References: <008F6ED7-7117-458B-A573-B7396E4EF537@chinatelecom.cn>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105AZroc019199
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3] multipathd: fix path checkint not changed
 when path state changed from delay to failed
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Chongyun,

On Mon, 2020-12-21 at 11:13 +0800, wucy11 wrote:
> Hi all,
> The new patch shown as below acocording to ben's suggestion, =A0please
> ignore v2, thanks.
>=20
> From 31ec4e9c270ff854b8edc526c5bcc9b24608d751 Mon Sep 17 00:00:00
> 2001
> From: Chongyun Wu <wucy11@chinatelecom.cn>
> Date: Wed, 16 Dec 2020 13:59:16 +0800
> Subject: [PATCH] multipathd: fix path checkint not changed when path
> state
> =A0form delay to failed
>=20
> Check_path: when path state change back to failed from delay state,
> should change
> this path's check interval time to the shortest delay to faster path
> state check.
>=20
> Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>
> ---
> =A0multipathd/main.c | 5 +++++
> =A01 file changed, 5 insertions(+)

Thank you. Please resubmit in text format.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

