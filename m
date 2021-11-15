Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31B8C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B48263219
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4B48263219
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-hrhd6fA6Nea4pPjmNipCEQ-1; Mon, 15 Nov 2021 01:54:40 -0500
X-MC-Unique: hrhd6fA6Nea4pPjmNipCEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEE0791288;
	Mon, 15 Nov 2021 06:54:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69DA10190A7;
	Mon, 15 Nov 2021 06:54:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 83CBF4A703;
	Mon, 15 Nov 2021 06:54:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AF66cHK003570 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 01:06:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8429F40CFD10; Mon, 15 Nov 2021 06:06:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ED8040CFD07
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 06:06:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6535A811E7A
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 06:06:38 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
	[209.85.208.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-444-TKpvv_fnP9mfRtkuUFPGPA-1; Mon, 15 Nov 2021 01:06:29 -0500
X-MC-Unique: TKpvv_fnP9mfRtkuUFPGPA-1
Received: by mail-ed1-f44.google.com with SMTP id m14so67066531edd.0;
	Sun, 14 Nov 2021 22:06:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=WJyGtaduRtIJa/ZtDrFpN3oGhSX1GbTvjUgEHPLUCMg=;
	b=WNz20naBC8gDRR1O0PNU9wlpovGbWbTYXeJdcMw2G9XoF6RlY58zO0TnjEMomPDQwO
	VaFfIX0rEEmb30m6DTvf1J8IwKglP5VzLJk4i0MxD7IGw5o0CUfDGPzfGWirD52aUVjW
	f7Kyw4o4GXBBv7eNXsEdtOQ8Lrhd6thclaMi+zYvWePQBiU45z+4cHaPtQUXO5vgNXsN
	s6IXFQ9HXaWJoIbYHaqgKbOZTr/Yu7hXTNBuBAX08dmCppuhSNfEvG7SJ5MqsNOBZ9mo
	l9srMKeh6QZoR654f/ln8ewt2repTpU7T8DGcOEwsNHlI2/5dnv0RSgZ5o8YlbVOxJjY
	Tkew==
X-Gm-Message-State: AOAM5304AeMKWhxClrYgmMVCKCK3M7D44oLXKHILCjxzS037XoofgA7x
	1MdWzM215DXg9zYjDX/U+jqKKEsqCIvpIu5ACDA=
X-Google-Smtp-Source: ABdhPJz5iujEF0gRIOihMaP1aSj04ay9mLJHtbI3Soyz1R6lWjRspvRUCY8gecc7utX0rH6lPACQni3RuU+0WhQtFOU=
X-Received: by 2002:aa7:cd8a:: with SMTP id x10mr51748057edv.3.1636956387892; 
	Sun, 14 Nov 2021 22:06:27 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
	<CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
	<CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
	<CAOuPNLg_YwyhK6iPZZbRWe57Kkr1d8LjJaDniCvvOqk4t2-Sog@mail.gmail.com>
	<CAOuPNLgYhm=goOiABjUFsAvRW+s2NqHjHYdm5MA9PvoUAMxOpg@mail.gmail.com>
	<4b99139a-802a-8255-adf5-2d3f9d0ccf7c@squashfs.org.uk>
In-Reply-To: <4b99139a-802a-8255-adf5-2d3f9d0ccf7c@squashfs.org.uk>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Mon, 15 Nov 2021 11:36:16 +0530
Message-ID: <CAOuPNLg3Te_QwNaUq25TVQ5zav_ER78tM6gakdGLtEVqWL2+AA@mail.gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Nov 2021 01:54:31 -0500
Cc: squashfs-devel@lists.sourceforge.net,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Daniel Rosenberg <drosen@google.com>,
	Richard Weinberger <richard@nod.at>, snitzer@redhat.com,
	open list <linux-kernel@vger.kernel.org>, astrachan@google.com,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>, speed.eom@samsung.com
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 15 Nov 2021 at 00:40, Phillip Lougher <phillip@squashfs.org.uk> wrote:
>
> On 14/11/2021 07:06, Pintu Agarwal wrote:
> > + Adding squashfs-devel to get opinion from squashfs side.
> >
> > On Fri, 12 Nov 2021 at 12:48, Pintu Agarwal <pintu.ping@gmail.com> wrote:
> >>
> >> Hi,
> >>
> >> On Tue, 9 Nov 2021 at 21:04, Pintu Agarwal <pintu.ping@gmail.com> wrote:
> >>
> >>>>> We only get these squashfs errors flooded in the boot logs:
> >>>>> {{{
> >>>>> ....
> >>>>> [    5.153479] device-mapper: init: dm-0 is ready
> >>>>> [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
> >>>>> ....
> >>>>> [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
> >>>>> [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> >>>>> [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
> >>>>> [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
> >>>>> [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
> >>>>> [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
> >>>>> [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
> >>>>> ....
> >>>>> }}}
> >>>>>
> >>
> >> One more observation:
> >> When I disable FEC flag in bootloader, I see the below error:
> >> [    8.360791] device-mapper: verity: 253:0: data block 2 is corrupted
> >> [    8.361134] device-mapper: verity: 253:0: data block 3 is corrupted
> >> [    8.366016] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> >> [    8.379652] SQUASHFS error: Unable to read data cache entry [1106]
> >> [    8.379680] SQUASHFS error: Unable to read page, block 1106, size 7770
> >>
> >> Also, now I see that the decompress error is gone, but the read error
> >> is still there.
> >>
> >> This seems to me that dm-verity detects some corrupted blocks but with
> >> FEC it auto corrects itself, how when dm-verity auto corrects itself,
> >> the squashfs decompression algorithm somehow could not understand it.
> >>
> >> So, it seems like there is some mis-match between the way FEC
> >> correction and the squashfs decompression happens ?
> >>
> >> Is this issue seen by anybody else here ?
> >>
> >
> > The squashfs version used by Kernel:
> > [    0.355958] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> >
> > The squashfs version available on Ubuntu:
> > mksquashfs version 4.3-git (2014/06/09)
> >
> > The squashfs version used by Yocto 2.6:
> > squashfs-tools/0001-squashfs-tools-Allow-setting-selinux-xattrs-through-.patch:61:
> >     printf("mksquashfs version 4.3-git (2014/09/12)\n");
> >
> > We create dm-verity squashfs image using version 4.3 whereas, the
> > kernel uses 4.0 version to decompress it.
> > Is there something missing here?
> >
> > When FEC (Forward Error Correction) comes into picture, then squashfs
> > decompress fails.
> > When we remove FEC flag from dm-verity then decompress works but read
> > error still occurs.
> > This seems as if something is missing either in FEC handling or either
> > in squashfs decompress logic.
> >
> > Just wanted to know if there are any fixes already available in the
> > mainline for this ?
> >
> >
>
> As Squashfs maintainer I want you to stop randomly blaming anything and
> everything here.  You won't fix anything doing that.
>
> In a previous email you stated
>
>
> >
> > One quick observation:
> > This issue is seen only when we enable dm-verity in our bootloader and
> > cross-building the bootloader/kernel (with Yocto 2.6 toolchain
> > arm-oe-linux-gnueabi-) on Ubuntu 18.04.
> > The issue is *NOT* seen (on the same device) when building the
> > dm-verity enabled kernel on Ubuntu 16.04.
> >
> > Is it something to do with the cross-toolchain difference between
> > Ubuntu 16 and 18 ?
> >
>
> If that is the case, then it is not an issue with Squashfs or any
> kernel code, it is a build time issue and *that* is where you should
> be concentrating your efforts.  Find out what differences are there.
>
> You don't seem to understand that a Squashfs filesystem generated
> by any Mksquashfs 4.X is mountable *without* errors on any kernel
> since 2.6.29 (January 2009).  Looking for mismatches between
> Mksquashfs and/or kernel version and blaming that for the above
> different behaviour is a complete waste of time.
>

I am sorry, but I am not blaming anybody here.
I am just trying to put my observation here and trying to understand
if someone else have seen a similar issue.
Toolchain side also, it seems the same as it comes from Yocto itself.

It seems there is some relation between dm-verity FEC correction and
squashfs decompression.
So I was looking for some clues from both sides.

Anyways, thank you so much for your suggestion.
Yes, we are analysing the Yocto side build difference as well between
Ubuntu 16 and 18.

Thank you!
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

