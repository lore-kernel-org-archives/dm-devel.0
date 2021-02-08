Return-Path: <SRS0=blFE=HK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897FCC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:49:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8040364E6E
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8040364E6E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-rUfkV17dNHW1Wp6MOodZKw-1; Mon, 08 Feb 2021 05:49:53 -0500
X-MC-Unique: rUfkV17dNHW1Wp6MOodZKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BFE0CC626;
	Mon,  8 Feb 2021 10:49:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0AE160C64;
	Mon,  8 Feb 2021 10:49:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D497018095CB;
	Mon,  8 Feb 2021 10:49:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118AniuV010848 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 05:49:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 844442026D16; Mon,  8 Feb 2021 10:49:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F1642026D13
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:49:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 200C1802A60
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 10:49:42 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-263-TfxWg5GeOhGCtiY8V6Fu_A-1; Mon, 08 Feb 2021 05:49:37 -0500
X-MC-Unique: TfxWg5GeOhGCtiY8V6Fu_A-1
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ2mq0dqxzjJ2C;
	Mon,  8 Feb 2021 18:48:11 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server
	id 14.3.498.0; Mon, 8 Feb 2021 18:49:31 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
Date: Mon, 8 Feb 2021 18:49:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 118AniuV010848
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/2/8 17:50, Martin Wilck wrote:
> On Mon, 2021-02-08 at 15:41 +0800, lixiaokeng wrote:
>>
>> Hi Martin,
>>
>> There is a _cleanup_ in device_new_from_nulstr. If uevent_thr exit in
>> device_new_from_nulstr and some keys is not be append to sd_device,
>> the _cleanup_ will be called, which leads to multipathd crashes with
>> the stack.
>>
>> When I use your advice,
>>
>>
>> On 2021/1/26 16:34, Martin Wilck wrote:
>>> =A0=A0=A0 int oldstate;
>>>
>>> =A0=A0=A0 pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate);
>>>
>>> =A0=A0=A0 udev_monitor_receive_device(...)
>>>
>>> =A0=A0=A0 pthread_setcancelstate(oldstate, NULL);
>>> =A0=A0=A0 pthread_testcancel();
>>
>> this coredump does not seem to appear anymore (several hours with
>> test scripts).
>=20
> Thanks for your continued hard work on this, but I can't follow you. In
> this post:
>=20
> https://listman.redhat.com/archives/dm-devel/2021-January/msg00396.html
>=20
> you said that this advice did _not_ help. Please clarify.
>=20

Hi Martin,
At that time, I did not know how the crash occurred in the systemd interfac=
e.
There were still some crashes with pthread_testcancel(), for example
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

I thought these crashes might be related to crash in systemd interface.

However, I think these may be independent questions after analyzing
coredump and discussing with the community. So I test it again.
?? and _Unwind_XXX crashes still exist but no crash in
device_monitor_receive_device.

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

