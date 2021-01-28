Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5291C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:22:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26A5664DE5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 16:22:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26A5664DE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-tXrTzytxPkW5m6FY45lFjQ-1; Thu, 28 Jan 2021 11:22:46 -0500
X-MC-Unique: tXrTzytxPkW5m6FY45lFjQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFA59107ACE3;
	Thu, 28 Jan 2021 16:22:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 901FB16D5E;
	Thu, 28 Jan 2021 16:22:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A5761809C9F;
	Thu, 28 Jan 2021 16:22:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SGIf6j005906 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 11:18:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 805F91041AF1; Thu, 28 Jan 2021 16:18:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B3501041AF5
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 16:18:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75F1A1875040
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 16:18:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-550-tZDsNa50POmthgUTkaidJQ-1;
	Thu, 28 Jan 2021 11:18:34 -0500
X-MC-Unique: tZDsNa50POmthgUTkaidJQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id D441DAC41;
	Thu, 28 Jan 2021 16:18:32 +0000 (UTC)
Message-ID: <dbb9bf6a80f0811e5f42c2b7a4e90b547d950345.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Thu, 28 Jan 2021 17:18:31 +0100
In-Reply-To: <c7bfb222-4491-8a92-5ed5-f493c6f9bf0c@huawei.com>
References: <621a2062-b6eb-d88d-e53a-9c0a6b19cfbb@huawei.com>
	<d592fd0d5eeb2a0a865a395b456e24fc5a359ebf.camel@suse.com>
	<322a434b-9c5d-e145-3de4-e244493b4085@huawei.com>
	<e838410f254c12bfa3643a0cd3c50d31017346d0.camel@suse.com>
	<c7bfb222-4491-8a92-5ed5-f493c6f9bf0c@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10SGIf6j005906
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-28 at 21:17 +0800, lixiaokeng wrote:
>=20
> > >=20
> > > =A0=A0 Thanks very much. Your suggestions is very helpful.
> > > =A0=A0 The problem reproduced and the bug seems that shown in
> > > https://bugzilla.redhat.com/show_bug.cgi?id=3D1293594.
> >=20
> > Really? I don't see a connection to your case there. It's about
> > glusterfs and libgcc...
> >=20
> > Martin
> >=20
> >=20
> Hi Martin:
>=20
> =A0=A0=A0 Change code as your suggestion, multipathd crash happens easly.
> Stack:
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
> This issue seems being different from that I described firstly.
> Do you think they are related?

Yes. The thread crashes when it's cancelled. I think we have a problem
in a cleanup handler that we installed with pthread_cleanup_push().


> Will udev_device_unref lead to double free about first issue?

Any double free could cause it if it happens in a pthread cleanup
handler (iow, if we free something in the cleanup handler that had
been freed already).

What code base exactly were you using?

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

