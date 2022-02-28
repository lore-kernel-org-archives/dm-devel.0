Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED730C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 07:17:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-WQ-Nyqa3M7SwbSSmR1_92w-1; Tue, 01 Mar 2022 02:17:29 -0500
X-MC-Unique: WQ-Nyqa3M7SwbSSmR1_92w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F04AE1006AA5;
	Tue,  1 Mar 2022 07:17:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1083C1037F4C;
	Tue,  1 Mar 2022 07:17:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4091D1CBF;
	Tue,  1 Mar 2022 07:17:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21S8IkCt020052 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 03:18:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D02D0434842; Mon, 28 Feb 2022 08:18:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC55F434840
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 08:18:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0BB585A5BC
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 08:18:46 +0000 (UTC)
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com
	[209.85.221.182]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-588-uy4Fk4vIOIWc_i5dnM8u0Q-1; Mon, 28 Feb 2022 03:18:44 -0500
X-MC-Unique: uy4Fk4vIOIWc_i5dnM8u0Q-1
Received: by mail-vk1-f182.google.com with SMTP id j201so4717348vke.11
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 00:18:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=EVb44ykkDs+f4MAbG4U5GjoBgb488ah3iaA9JdvOooY=;
	b=S0S7ncl+cF9V+Gs4yEliY3QqsJ5XFgbn7brk4YD5ZcYi35pMAJXpxeZqPPRI3LLipp
	oJu0Bj2wlEzutgfEAAaNMf1cDdOJbtY+F/++o5omG7X0TBRjGrro7FNukPvrNwPNRj2e
	oBNu8PvCvcURiGFRcTRvQS2BGgW6ch88/GjJ5NNqvBBcIus0U8gO2yJRyGy+pIsF9nCu
	89+EC9/az2inTzWtMIJ6w6DyB89W5HxU0S8Q/d5FLpNhssXD/MFbNpb4IUcGs5M5Wpjk
	qEimOT5AsuKQ/qwFlEiZ5vjxzeL5kHmyM4HbEZ6pLILWYlK3cxm+Z/Kq5c7VdcBvtXcm
	Ra2A==
X-Gm-Message-State: AOAM5328ocEPYbm5q9KWpjydqUGgPfVDO+cbsKV8QWlHXaHpSZ4OBVGI
	oNp3Ib/KGwjWFuj5go4ar+sWnGh1UhMFmauTpok=
X-Google-Smtp-Source: ABdhPJxhyZpUB9RGDUiNsp2g2BUcqmBdR2rRxOccTiE9XMqsQAP0xeLMCczQQAp8AbYd3NA2ohQ31mLWzwxANmlur+M=
X-Received: by 2002:a05:6122:169d:b0:321:602f:a70f with SMTP id
	29-20020a056122169d00b00321602fa70fmr7596099vkl.3.1646036323802;
	Mon, 28 Feb 2022 00:18:43 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com>
	<20220219210354.GF59715@dread.disaster.area>
	<CACsaVZ+LZUebtsGuiKhNV_No8fNLTv5kJywFKOigieB1cZcKUw@mail.gmail.com>
	<YhN76/ONC9qgIKQc@silpixa00400314>
In-Reply-To: <YhN76/ONC9qgIKQc@silpixa00400314>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Mon, 28 Feb 2022 00:18:33 -0800
Message-ID: <CACsaVZJFane88cXxG_E1VkcMcJm8YVN+GDqQ2+tRYNpCf+m8zA@mail.gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 01 Mar 2022 02:17:20 -0500
Cc: herbert@gondor.apana.org.au, Greg KH <gregkh@linuxfoundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Linux-Kernal <linux-kernel@vger.kernel.org>, qat-linux@intel.com,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Intel QAT on A2SDi-8C-HLN4F causes massive data
 corruption with dm-crypt + xfs
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> The issue is that the implementations of aead and skcipher in the QAT driver are not properly supporting requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.

Thanks Giovanni. Joel (from Intel) reached out to me out of band to
try and sell me further on QAT but wasn't able to follow-up on any
questions (like - how is the device actually used, how can I
personally help, etc).

> If the HW queue is full, the driver returns -EBUSY [1] but does not enqueues the request as dm-crypt expects [2]. Dm-crypt ends up waiting indefinitely for a completion to a request that was never submitted, therefore the stall.

Makes sense - this kernel driver has been destroying users for many
years. I'm disappointed that this critical bricking failure isn't
searchable for others.

> This is not related to QATE-7495 'An incorrectly formatted request to QAT can hang the entire QAT endpoint' [3], which occurs when a malformed request is sent to the device.

That's nice to hear that the device itself isn't dying, but it's been
completely destroying systems for years which itself is a DoS.

> I'm working at patch that resolves this problem. In the meanwhile a workaround is to blacklist the qat_c3xxx.ko driver.

I'm not writing this facetiously, but this driver has caused
incredible harm over the past 5+ years and seems to continue to do so.
As there's no patch proposed yet, I'm looking for the driver to be
completely removed from the tree as it's presently a pure marketing
campaign that's caused significant harm. If the marketing benefits
(like accelerated crypto + hashing) aren't there when the accelerated
instruction set was pulled from these integrated chips - the driver
continues to serve no purpose for consumers beyond damage. Disabling
the core I/O bits in December 2020 to make this barely work continues
to promote this as a side project as it was never resolved in the
driver.

If I can test patches, or assist with the removal of this present
in-tree malware I'm happy to help.

Kyle.


On Mon, Feb 21, 2022 at 3:48 AM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> Hi Kyle,
>
> The issue is that the implementations of aead and skcipher in the QAT
> driver are not properly supporting requests with the
> CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
> If the HW queue is full, the driver returns -EBUSY [1] but does not
> enqueues the request as dm-crypt expects [2]. Dm-crypt ends up waiting
> indefinitely for a completion to a request that was never submitted,
> therefore the stall.
> This is not related to QATE-7495 'An incorrectly formatted request to
> QAT can hang the entire QAT endpoint' [3], which occurs when a malformed
> request is sent to the device.
>
> I'm working at patch that resolves this problem. In the meanwhile a
> workaround is to blacklist the qat_c3xxx.ko driver.
>
> Regarding avoiding this issue on stable kernels. The usage of QAT with
> dm-crypt was already disabled in kernel 5.10 for a different issue
> (the driver allocates memory in the datapath).
> The following patches implement the change:
>     7bcb2c99f8ed crypto: algapi - use common mechanism for inheriting flags
>     2eb27c11937e crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
>     fbb6cda44190 crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
>     b8aa7dc5c753 crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
>     cd74693870fb dm crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
> An option would be to send the patches above to stable, another is to wait
> for a patch that fixes the problems in the QAT driver and send that to
> stable.
> @Herbert, what is the preferred approach here?
>
> Thanks,
>
> [1] https://elixir.bootlin.com/linux/latest/source/drivers/crypto/qat/qat_common/qat_algs.c#L1022
> [2] https://elixir.bootlin.com/linux/latest/source/drivers/md/dm-crypt.c#L1584
> [3] https://01.org/sites/default/files/downloads//336211qatsoftwareforlinux-rn-hwversion1.7021.pdf - page 25
>
> --
> Giovanni
>
>
> On Sat, Feb 19, 2022 at 03:00:51PM -0800, Kyle Sanderson wrote:
> > hi Dave,
> >
> > > This really sounds like broken hardware, not a kernel problem.
> >
> > It is indeed a hardware issue, specifically the intel qat crypto
> > driver that's in-tree - the hardware is fine (see below). The IQAT
> > eratta documentation states that if a request is not submitted
> > properly it can stall the entire device. The remediation guidance from
> > 2020 was "don't do that" and "don't allow unprivileged users access to
> > the device". The in-tree driver is not implemented properly either for
> > this SoC or board - I'm thinking it's related to QATE-7495.
> >
> > https://01.org/sites/default/files/downloads//336211qatsoftwareforlinux-rn-hwversion1.7021.pdf
> >
> > > This implies a dmcrypt level problem - XFS can't make progress is dmcrypt is not completing IOs.
> >
> > That's the weird part about it. Some bio's are completing, others are
> > completely dropped, with some stalling forever. I had to use
> > xfs_repair to get the volumes operational again. I lost a good deal of
> > files and had to recover from backup after toggling the device back on
> > on a production system (silly, I know).
> >
> > > Where are the XFS corruption reports that the subject implies is occurring?
> >
> > I think you're right, it's dm-crypt that's broken here, with
> > ultimately the crypto driver causing this corruption. XFS being the
> > edge to the end-user is taking the brunt of it. There's reports going
> > back to late 2017 of significant issues with this mainlined stable
> > driver.
> >
> > https://bugzilla.redhat.com/show_bug.cgi?id=1522962
> > https://serverfault.com/questions/1010108/luks-hangs-on-centos-running-on-atom-c3758-cpu
> > https://www.phoronix.com/forums/forum/software/distributions/1172231-fedora-33-s-enterprise-linux-next-effort-approved-testbed-for-raising-cpu-requirements-etc?p=1174560#post1174560
> >
> > Any guidance would be appreciated.
> > Kyle.
> > On Sat, Feb 19, 2022 at 1:03 PM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Feb 18, 2022 at 09:02:28PM -0800, Kyle Sanderson wrote:
> > > > A2SDi-8C-HLN4F has IQAT enabled by default, when this device is
> > > > attempted to be used by xfs (through dm-crypt) the entire kernel
> > > > thread stalls forever. Multiple users have hit this over the years
> > > > (through sporadic reporting) - I ended up trying ZFS and encryption
> > > > wasn't an issue there at all because I guess they don't use this
> > > > device. Returning to sanity (xfs), I was able to provision a dm-crypt
> > > > volume no problem on the disk, however when running mkfs.xfs on the
> > > > volume is what triggers the cascading failure (each request kills a
> > > > kthread).
> > >
> > > Can you provide the full stack traces for these errors so we can see
> > > exactly what this cascading failure looks like, please? In reality,
> > > the stall messages some time after this are not interesting - it's
> > > the first errors that cause the stall that need to be investigated.
> > >
> > > A good idea would be to provide the full storage stack decription
> > > and hardware in use, as per:
> > >
> > > https://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> > >
> > > > Disabling IQAT on the south bridge results in a working
> > > > system, however this is not the default configuration for the
> > > > distribution of choice (Ubuntu 20.04.3 LTS), nor the motherboard. I'm
> > > > convinced this never worked properly based on the lack of popularity
> > > > for kernel encryption (crypto), and the embedded nature that
> > > > SuperMicro has integrated this device in collaboration with intel as
> > > > it looks like the primary usage is through external accelerator cards.
> > >
> > > This really sounds like broken hardware, not a kernel problem.
> > >
> > > > Kernels tried were from RHEL8 over a year ago, and this impacts the
> > > > entirety of the 5.4 series on Ubuntu.
> > > > Please CC me on replies as I'm not subscribed to all lists. CPU is C3758.
> > >
> > > [snip stalled kcryptd worker threads]
> > >
> > > This implies a dmcrypt level problem - XFS can't make progress is
> > > dmcrypt is not completing IOs.
> > >
> > > Where are the XFS corruption reports that the subject implies is
> > > occurring?
> > >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

