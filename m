Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA53C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 13:21:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9665B64DCE
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 13:21:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9665B64DCE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-8YzeuRNBNC6DmbGtn5SqpA-1; Thu, 28 Jan 2021 08:21:46 -0500
X-MC-Unique: 8YzeuRNBNC6DmbGtn5SqpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA30D107ACE6;
	Thu, 28 Jan 2021 13:21:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F5BA1971B;
	Thu, 28 Jan 2021 13:21:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29CAD4BB7B;
	Thu, 28 Jan 2021 13:21:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SDHean015514 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 08:17:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C04D12011540; Thu, 28 Jan 2021 13:17:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB04B2026D76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 13:17:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9386A185A794
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 13:17:38 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-166-XA7XOUAuOnq8n3rRDoYcSg-1; Thu, 28 Jan 2021 08:17:34 -0500
X-MC-Unique: XA7XOUAuOnq8n3rRDoYcSg-1
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRLZK72TlzMQ1R;
	Thu, 28 Jan 2021 21:15:53 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server
	id 14.3.498.0; Thu, 28 Jan 2021 21:17:18 +0800
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <621a2062-b6eb-d88d-e53a-9c0a6b19cfbb@huawei.com>
	<d592fd0d5eeb2a0a865a395b456e24fc5a359ebf.camel@suse.com>
	<322a434b-9c5d-e145-3de4-e244493b4085@huawei.com>
	<e838410f254c12bfa3643a0cd3c50d31017346d0.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <c7bfb222-4491-8a92-5ed5-f493c6f9bf0c@huawei.com>
Date: Thu, 28 Jan 2021 21:17:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e838410f254c12bfa3643a0cd3c50d31017346d0.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10SDHean015514
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, hexiaowen@huawei.com
Subject: Re: [dm-devel] [QUESTION] multipathd crash when stopping
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable


>>
>> =A0=A0 Thanks very much. Your suggestions is very helpful.
>> =A0=A0 The problem reproduced and the bug seems that shown in
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1293594.
>=20
> Really? I don't see a connection to your case there. It's about
> glusterfs and libgcc...
>=20
> Martin
>=20
>=20
Hi Martin:

    Change code as your suggestion, multipathd crash happens easly.
Stack:
#0  0x0000ffffb6118f4c in aarch64_fallback_frame_state (context=3D0xffffb52=
3f200, context=3D0xffffb523f200, fs=3D0xffffb523e700) at ./md-unwind-suppor=
t.h:74
#1  uw_frame_state_for (context=3Dcontext@entry=3D0xffffb523f200, fs=3Dfs@e=
ntry=3D0xffffb523e700) at ../../../libgcc/unwind-dw2.c:1257
#2  0x0000ffffb6119ef4 in _Unwind_ForcedUnwind_Phase2 (exc=3Dexc@entry=3D0x=
ffffb52403b0, context=3Dcontext@entry=3D0xffffb523f200) at ../../../libgcc/=
unwind.inc:155
#3  0x0000ffffb611a284 in _Unwind_ForcedUnwind (exc=3D0xffffb52403b0, stop=
=3Dstop@entry=3D0xffffb64846c0 <unwind_stop>, stop_argument=3D0xffffb523f63=
0) at ../../../libgcc/unwind.inc:207
#4  0x0000ffffb6484860 in __GI___pthread_unwind (buf=3D<optimized out>) at =
unwind.c:121
#5  0x0000ffffb6482d08 in __do_cancel () at pthreadP.h:304
#6  __GI___pthread_testcancel () at pthread_testcancel.c:26
#7  0x0000ffffb5c528e8 in ?? ()

This issue seems being different from that I described firstly.
Do you think they are related?
Will udev_device_unref lead to double free about first issue?

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

