Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55C6C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 13:58:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0DDD564E4B
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 13:58:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DDD564E4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-wtv1lU0JOjSSZAeJADutsw-1; Wed, 03 Feb 2021 08:58:15 -0500
X-MC-Unique: wtv1lU0JOjSSZAeJADutsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F43E85B6C3;
	Wed,  3 Feb 2021 13:58:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27C5260C66;
	Wed,  3 Feb 2021 13:58:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3835118095CB;
	Wed,  3 Feb 2021 13:58:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113DvhuP016001 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 08:57:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2160B1031F48; Wed,  3 Feb 2021 13:57:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C76F10F8E24
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 13:57:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32019185A795
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 13:57:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-371-_mLsCAglNli03RYei3cx2w-1;
	Wed, 03 Feb 2021 08:57:32 -0500
X-MC-Unique: _mLsCAglNli03RYei3cx2w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E78A6ACBA;
	Wed,  3 Feb 2021 13:57:30 +0000 (UTC)
Message-ID: <dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 03 Feb 2021 14:57:29 +0100
In-Reply-To: <99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 113DvhuP016001
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-02-03 at 18:48 +0800, lixiaokeng wrote:
>=20
>=20
> On 2021/2/3 4:52, Martin Wilck wrote:
> > did this fix your "crash on exit" issue?
>=20
> Unfortunately, the issue is not solved.
>=20
> There will be some different coredump stack.
>=20
> 0.8.5 (I'm not sure there are only two stacks in 0.8.5)
> First stack:
> Program terminated with signal SIGSEGV, Segmentation fault.
> #0=A0 0x00007f59a0109647 in ?? ()
> [Current thread is 1 (LWP 1997690)]
> (gdb) bt
> #0=A0 0x00007f59a0109647 in ?? ()
> #1=A0 0x0000000000000000 in ?? ()
> (gdb) info threads
> =A0 Id=A0=A0 Target Id=A0=A0=A0=A0=A0=A0=A0=A0 Frame
> * 1=A0=A0=A0 LWP 1997690=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
> =A0 2=A0=A0=A0 LWP 1996840=A0=A0=A0=A0=A0=A0 0x00007f59a0531de7 in ?? ()
> =A0 3=A0=A0=A0 LWP 1997692=A0=A0=A0=A0=A0=A0 0x00007f59a0109647 in ?? ()
> =A0 4=A0=A0=A0 LWP 1996857=A0=A0=A0=A0=A0=A0 0x00007f59a020d169 in ?? ()
>=20
> Second stack:
> #0=A0 0x0000ffffb6118f4c in aarch64_fallback_frame_state
> (context=3D0xffffb523f200, context=3D0xffffb523f200, fs=3D0xffffb523e700)
> at ./md-unwind-support.h:74
> #1=A0 uw_frame_state_for (context=3Dcontext@entry=3D0xffffb523f200,=20
> fs=3Dfs@entry=3D0xffffb523e700) at ../../../libgcc/unwind-dw2.c:1257
> #2=A0 0x0000ffffb6119ef4 in _Unwind_ForcedUnwind_Phase2
> (exc=3Dexc@entry=3D0xffffb52403b0, context=3Dcontext@entry=3D0xffffb523f2=
00)
> at ../../../libgcc/unwind.inc:155
> #3=A0 0x0000ffffb611a284 in _Unwind_ForcedUnwind (exc=3D0xffffb52403b0,=
=20
> stop=3Dstop@entry=3D0xffffb64846c0 <unwind_stop>,
> stop_argument=3D0xffffb523f630) at ../../../libgcc/unwind.inc:207
> #4=A0 0x0000ffffb6484860 in __GI___pthread_unwind (buf=3D<optimized out>)
> at unwind.c:121
> #5=A0 0x0000ffffb6482d08 in __do_cancel () at pthreadP.h:304
> #6=A0 __GI___pthread_testcancel () at pthread_testcancel.c:26
> #7=A0 0x0000ffffb5c528e8 in ?? ()
>=20

Please check your glibc and gcc versions. Google turns up some general
issues with pthread_cancel() and certain library versions, especially
on ARM. There's a chance that this isn't a multipath-tools bug after
all.

https://www.google.com/search?q=3DSIGSEGV+_Unwind_ForcedUnwind_Phase2

You could also try to compile with clang and see if the error goes
away.

> If exit() before all pthread_cancel in child of 0.7.7, there is no
> any crash.

What do you mean with "exit() before all pthread_cancel"? If this
happens on pthread_cancel(), and you don't call that function, this
would actually be expected.

Regards,
Martin

> So I believe there are many races in thread cancel but I don't know
> how it comes.



>=20
> Regards,
> Lixiaokeng
>=20



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

