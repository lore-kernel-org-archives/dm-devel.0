Return-Path: <SRS0=hK9d=GJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4189C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 15:36:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21C4D2311E
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 15:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21C4D2311E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-a3cN1dJvPpukGHc_3J4qPA-1; Wed, 06 Jan 2021 10:36:00 -0500
X-MC-Unique: a3cN1dJvPpukGHc_3J4qPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EAE5BBF01;
	Wed,  6 Jan 2021 15:35:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B40E319CBE;
	Wed,  6 Jan 2021 15:35:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A35614A7C6;
	Wed,  6 Jan 2021 15:35:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 106FZhsi013134 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Jan 2021 10:35:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B67EAA9F34; Wed,  6 Jan 2021 15:35:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0025A9F42
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 15:35:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2600E101A53F
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 15:35:37 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-460-lu2RJasxOBa58Cs5R7-1UA-1;
	Wed, 06 Jan 2021 10:35:32 -0500
X-MC-Unique: lu2RJasxOBa58Cs5R7-1UA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C7F50B59C;
	Wed,  6 Jan 2021 15:35:30 +0000 (UTC)
Message-ID: <bba832d8942aeba9edde6eedbce0d7139625b176.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Chongyun Wu <wucy11@chinatelecom.cn>, "bmarzins@redhat.com"
	<bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Date: Wed, 06 Jan 2021 16:35:24 +0100
In-Reply-To: <4a94424e-5fae-0f7f-b9be-56ccb5f1a0df@chinatelecom.cn>
References: <4a94424e-5fae-0f7f-b9be-56ccb5f1a0df@chinatelecom.cn>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 106FZhsi013134
X-loop: dm-devel@redhat.com
Cc: yubin1@chinatelecom.cn, zhangzijian@chinatelecom.cn
Subject: Re: [dm-devel] [PATCH v3 resend] multipathd: fix path checkint not
 changed when path state changed from delay to failed
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

On Wed, 2021-01-06 at 09:39 +0800, Chongyun Wu wrote:
> Thank you, Ben and Martin, this is the resend version in text format.
>=20
> =A0From 45dad5fa6a9fb42648c8f5f54d6db974974d9612 Mon Sep 17 00:00:00
> 2001
> From: Chongyun Wu <wucy11@chinatelecom.cn>
> Date: Wed, 16 Dec 2020 13:59:16 +0800
> Subject: [PATCH] multipathd: fix path checkint not changed when path=20
> state changed from delay to failed
>=20
> Check_path: when path state change back to failed from delay state,=20
> should change this path's check interval time to the shortest delay
> to=20
> faster path state check.
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Chongyun Wu <wucy11@chinatelecom.cn>

Thanks again, pushed to the "upstream-queue" branch on
github.com/openSUSE/multipath-tools.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

