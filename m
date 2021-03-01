Return-Path: <SRS0=9wY3=H7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96919C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:54:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AC3CE64E54
	for <dm-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC3CE64E54
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-mSCrQR9MMm6_YvQxWUJEiA-1; Mon, 01 Mar 2021 09:54:35 -0500
X-MC-Unique: mSCrQR9MMm6_YvQxWUJEiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 286CC18B9E80;
	Mon,  1 Mar 2021 14:54:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C021960636;
	Mon,  1 Mar 2021 14:54:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EFB918095CB;
	Mon,  1 Mar 2021 14:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 121EsNwo016755 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Mar 2021 09:54:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BA22B2026D48; Mon,  1 Mar 2021 14:54:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D3A202A429
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 14:54:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56E61185A7BC
	for <dm-devel@redhat.com>; Mon,  1 Mar 2021 14:54:19 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-269-JLpgRAmaP1yHzh3Byrjyfg-1; Mon, 01 Mar 2021 09:54:01 -0500
X-MC-Unique: JLpgRAmaP1yHzh3Byrjyfg-1
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dq3C01XxzzjSWZ;
	Mon,  1 Mar 2021 22:52:28 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server
	id 14.3.498.0; Mon, 1 Mar 2021 22:53:42 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
Date: Mon, 1 Mar 2021 22:53:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 121EsNwo016755
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/2/3 21:57, Martin Wilck wrote:
> On Wed, 2021-02-03 at 18:48 +0800, lixiaokeng wrote:
>>
>>
>> On 2021/2/3 4:52, Martin Wilck wrote:
>>> did this fix your "crash on exit" issue?
>>
>> Unfortunately, the issue is not solved.
>>
>> There will be some different coredump stack.
>>
>> 0.8.5 (I'm not sure there are only two stacks in 0.8.5)
>> First stack:
>> Program terminated with signal SIGSEGV, Segmentation fault.
>> #0=A0 0x00007f59a0109647 in ?? ()
>> [Current thread is 1 (LWP 1997690)]
>> (gdb) bt
>> #0=A0 0x00007f59a0109647 in ?? ()
>> #1=A0 0x0000000000000000 in ?? ()
>> (gdb) info threads
>> =A0 Id=A0=A0 Target Id=A0=A0=A0=A0=A0=A0=A0=A0 Frame
>> * 1=A0=A0=A0 LWP 1997690=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
>> =A0 2=A0=A0=A0 LWP 1996840=A0=A0=A0=A0=A0=A0 0x00007f59a0531de7 in ?? ()
>> =A0 3=A0=A0=A0 LWP 1997692=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
>> =A0 4=A0=A0=A0 LWP 1996857=A0=A0=A0=A0=A0=A0 0x00007f59a020d169 in ?? ()
>>
>> Second stack:
>> #0=A0 0x0000ffffb6118f4c in aarch64_fallback_frame_state
>> (context=3D0xffffb523f200, context=3D0xffffb523f200, fs=3D0xffffb523e700=
)
>> at ./md-unwind-support.h:74
>> #1=A0 uw_frame_state_for (context=3Dcontext@entry=3D0xffffb523f200,=20
>> fs=3Dfs@entry=3D0xffffb523e700) at ../../../libgcc/unwind-dw2.c:1257
>> #2=A0 0x0000ffffb6119ef4 in _Unwind_ForcedUnwind_Phase2
>> (exc=3Dexc@entry=3D0xffffb52403b0, context=3Dcontext@entry=3D0xffffb523f=
200)
>> at ../../../libgcc/unwind.inc:155
>> #3=A0 0x0000ffffb611a284 in _Unwind_ForcedUnwind (exc=3D0xffffb52403b0,=
=20
>> stop=3Dstop@entry=3D0xffffb64846c0 <unwind_stop>,
>> stop_argument=3D0xffffb523f630) at ../../../libgcc/unwind.inc:207
>> #4=A0 0x0000ffffb6484860 in __GI___pthread_unwind (buf=3D<optimized out>=
)
>> at unwind.c:121
>> #5=A0 0x0000ffffb6482d08 in __do_cancel () at pthreadP.h:304
>> #6=A0 __GI___pthread_testcancel () at pthread_testcancel.c:26
>> #7=A0 0x0000ffffb5c528e8 in ?? ()
>>
>=20

Hi Martin:
   Here I add condlog(2, "start funcname"), pthread_cleanup_push(func_print=
, NULL)
in every pthread_create func. When these two core happened, "exit tur_threa=
d"
are less than "start tur_thread". So the trouble may be in tur_thread.

I will use
=09int oldstate;
=09pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate);
 =09...
=09pthread_setcancelstate(oldstate, NULL);
=09pthread_testcancel();
to test it.

Regards,
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

