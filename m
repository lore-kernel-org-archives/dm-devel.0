Return-Path: <SRS0=blFE=HK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F9DC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 11:03:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2434E64E0B
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 11:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2434E64E0B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-GH992jvNOPKCa3I02NDZCQ-1; Mon, 08 Feb 2021 06:03:24 -0500
X-MC-Unique: GH992jvNOPKCa3I02NDZCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A86A2107ACED;
	Mon,  8 Feb 2021 11:03:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39EA150FA1;
	Mon,  8 Feb 2021 11:03:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DC0C418095CB;
	Mon,  8 Feb 2021 11:03:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 118B3EJZ011919 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 06:03:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4670F2166B29; Mon,  8 Feb 2021 11:03:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B5472166B2F
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 11:03:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33C36800C81
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 11:03:09 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-546-bu_ZP2OHM0uYPdoMRs9aVA-1;
	Mon, 08 Feb 2021 06:03:07 -0500
X-MC-Unique: bu_ZP2OHM0uYPdoMRs9aVA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id CAEA9AC6E;
	Mon,  8 Feb 2021 11:03:05 +0000 (UTC)
Message-ID: <7b2c571eb7ff9d54c51037a4fae87796ead1144e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 08 Feb 2021 12:03:05 +0100
In-Reply-To: <6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
	<05408634d2361998782d80b34b7de64d452ba09c.camel@suse.com>
	<6c80ccbe-0c35-aef8-e95b-97acd06a3487@huawei.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 118B3EJZ011919
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-02-08 at 18:49 +0800, lixiaokeng wrote:
>=20
>=20
> On 2021/2/8 17:50, Martin Wilck wrote:
> > On Mon, 2021-02-08 at 15:41 +0800, lixiaokeng wrote:
> > >=20
> > > Hi Martin,
> > >=20
> > > There is a _cleanup_ in device_new_from_nulstr. If uevent_thr
> > > exit in
> > > device_new_from_nulstr and some keys is not be append to
> > > sd_device,
> > > the _cleanup_ will be called, which leads to multipathd crashes
> > > with
> > > the stack.
> > >=20
> > > When I use your advice,
> > >=20
> > >=20
> > > On 2021/1/26 16:34, Martin Wilck wrote:
> > > > =A0=A0=A0 int oldstate;
> > > >=20
> > > > =A0=A0=A0 pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate)=
;
> > > >=20
> > > > =A0=A0=A0 udev_monitor_receive_device(...)
> > > >=20
> > > > =A0=A0=A0 pthread_setcancelstate(oldstate, NULL);
> > > > =A0=A0=A0 pthread_testcancel();
> > >=20
> > > this coredump does not seem to appear anymore (several hours with
> > > test scripts).
> >=20
> > Thanks for your continued hard work on this, but I can't follow
> > you. In
> > this post:
> >=20
> > https://listman.redhat.com/archives/dm-devel/2021-January/msg00396.html
> >=20
> > you said that this advice did _not_ help. Please clarify.
> >=20
>=20
> Hi Martin,
> At that time, I did not know how the crash occurred in the systemd
> interface.
> There were still some crashes with pthread_testcancel(), for example
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

I still don't fully understand. Above you said "this coredump doesn't
seem to appear any more". Am I understanding correctly that you
observed *other* core dumps instead?

The uw_frame_state_for() stack looks healthy (learned that just
recently from one of our experts in the area). Most probably the actual
crash occured in another thread in this case. It would be intersting to
look at a core dump.

The point of my suggestion was not the pthread_testcancel(), but the
blocking of thread cancellation during udev_monitor_receive_device().

> I thought these crashes might be related to crash in systemd
> interface.
>=20
> However, I think these may be independent questions after analyzing
> coredump and discussing with the community. So I test it again.
> ?? and _Unwind_XXX crashes still exist but no crash in
> device_monitor_receive_device.

The "best" solution would probably be to generally disallow
cancellation, and only run pthread_testcancel() at certain points in
the code where we might block (and know that being cancelled would be
safe). That would not only make multipathd safer from crashing, it
would also enable us to remove hundreds of ugly
pthread_cleanup_push()/pop() calls from our code.

Finding all these points would be a challenge though, and if we don't
find them, we risk hanging on exit again, which is bad too, and was
just recently improved.

Regards
Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

