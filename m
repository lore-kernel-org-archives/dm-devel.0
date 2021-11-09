Return-Path: <SRS0=QKrD=P5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80760C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 07:47:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B64661130
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 07:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B64661130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-cTmD1N2qODag5upG6mY42A-1; Wed, 10 Nov 2021 02:47:40 -0500
X-MC-Unique: cTmD1N2qODag5upG6mY42A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DA5615720;
	Wed, 10 Nov 2021 07:47:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E46F79453;
	Wed, 10 Nov 2021 07:47:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9617A18199EE;
	Wed, 10 Nov 2021 07:47:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9FZ8cX017251 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 10:35:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EEBA04047279; Tue,  9 Nov 2021 15:35:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFB24047272
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 15:35:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C54ED1066559
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 15:35:07 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
	[209.85.208.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-pXVFfLrlOja7lmUGn1y9AQ-1; Tue, 09 Nov 2021 10:35:04 -0500
X-MC-Unique: pXVFfLrlOja7lmUGn1y9AQ-1
Received: by mail-ed1-f50.google.com with SMTP id ee33so78647350edb.8;
	Tue, 09 Nov 2021 07:35:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=qNKxbY+CJKEKz5I5jfTajE0gm0ARDEZSOX6nNnQ06Ds=;
	b=kiD11QRTpxTYaAJobuiYhNVauYOPtO6gYEngQzD+9CNnXw3BsRNdZp3Cpx3p6sWXzX
	VlHPq9seFM96U9sKVg/xfl5PRf4+ww+iB8eR3TMTa2QFQ7RIFV/YP71KGqrYlOJzrwHQ
	oRLF2QyMiZNPvvuYASRYBVgeq/2qrmnbFhJ6sYgGmJ8WKHnMpiigFyMJL5qwi8+R6fWI
	OZhMEcD+zd/eP3cOl9BSJmzZd8U4z5sxiiJ2v+KMpVZBP02VcU1cMIropWXj6FaJmaeE
	Fdozk6nQ/ViaS6SAqtGq6+2fq331BtNMKf+aW12eM6zjKnFHjQkkrZb40GWYxgNwb7sq
	2/Hg==
X-Gm-Message-State: AOAM5304mDUmGStz8V+0QKFPMRc/S4CQXX3mtnLWGzsaAO62wrF+3CxU
	vy9gZn3ugmL++ZoyWmHdPHZ1uXBwIlwYZMs5xhE=
X-Google-Smtp-Source: ABdhPJz3XYwx9pVakfx2STu6CYLqj/G+Ya7i+K/njYwnyhQXDgoupRe5ikHsWAMxrdD4KeZhZ4/qfjONVlKpPr2sjMc=
X-Received: by 2002:a05:6402:3586:: with SMTP id
	y6mr11479655edc.332.1636472102206; 
	Tue, 09 Nov 2021 07:35:02 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
	<CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
In-Reply-To: <CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Tue, 9 Nov 2021 21:04:50 +0530
Message-ID: <CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>, sumit.semwal@linaro.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 10 Nov 2021 02:37:12 -0500
Subject: Re: [dm-devel] Kernel-4.14: With ubuntu-18.04 building rootfs
 images and booting gives SQUASHFS error: xz decompression failed,
 data probably corrupt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 9 Nov 2021 at 16:45, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> Hi,
>
> On Mon, 8 Nov 2021 at 20:00, Pintu Agarwal <pintu.ping@gmail.com> wrote:
> >
> > Hi,
> > Here are few details.
> > * Linux Kernel: 4.14
> > * Processor: Qualcomm Arm32 Cortex-A7
> > * Storage: NAND 512MB
> > * Platform: Simple busybox
> > * Filesystem: UBIFS, Squashfs
> > * Build system: Linux Ubuntu 18.04 with Yocto build system
> > * Consists of nand raw partitions, squashfs ubi volumes.
> >
> > What we are trying to do:
> > We are trying to boot dm-verity enabled rootfs on our system.
> > The images for rootfs were generated on Ubuntu 18.04 machine using
> > Yocto build system.
> >
> > Issue:
> > Earlier, when we were using Ubuntu 16.04 to generate our images, the
> > system was booting fine even with dm-verity enabled.
> > Recently we switched to Ubuntu 18.04 build machine, and now with the
> > same changes we are seeing the below squashfs error, just after the
> > mount.
> > Note: with 18.04 also our rootfs is mounting successfully and
> > dm-verity is also working fine.
> > We only get these squashfs errors flooded in the boot logs:
> > {{{
> > ....
> > [    5.153479] device-mapper: init: dm-0 is ready
> > [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
> > ....
> > [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
> > [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> > [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
> > [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
> > [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
> > [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
> > [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
> > ....
> > }}}
> >
> Just one question:
> Is there any history about these squashfs errors while cross-compiling
> images on Ubuntu 18.04 or higher ?
>
One quick observation:
This issue is seen only when we enable dm-verity in our bootloader and
cross-building the bootloader/kernel (with Yocto 2.6 toolchain
arm-oe-linux-gnueabi-) on Ubuntu 18.04.
The issue is *NOT* seen (on the same device) when building the
dm-verity enabled kernel on Ubuntu 16.04.

Is it something to do with the cross-toolchain difference between
Ubuntu 16 and 18 ?


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

