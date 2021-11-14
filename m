Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40340C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF2EC6321A
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF2EC6321A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-uA_5redBPA6qnDU8PevorA-1; Mon, 15 Nov 2021 01:54:40 -0500
X-MC-Unique: uA_5redBPA6qnDU8PevorA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE5BD100C660;
	Mon, 15 Nov 2021 06:54:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFF43197FC;
	Mon, 15 Nov 2021 06:54:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 738E34A704;
	Mon, 15 Nov 2021 06:54:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AE76R7w004315 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Nov 2021 02:06:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14DE52166B26; Sun, 14 Nov 2021 07:06:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC3F2166B25
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 07:06:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC6D0811E76
	for <dm-devel@redhat.com>; Sun, 14 Nov 2021 07:06:18 +0000 (UTC)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
	[209.85.208.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-570-hFEHgQzsOFCl3Br8bvtRBQ-1; Sun, 14 Nov 2021 02:06:14 -0500
X-MC-Unique: hFEHgQzsOFCl3Br8bvtRBQ-1
Received: by mail-ed1-f43.google.com with SMTP id r12so56561313edt.6;
	Sat, 13 Nov 2021 23:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=lTAWwzCDf/mzTJzs3+RMQBARAQp9pv2hNSSRu5s7rGk=;
	b=kPvrL/OEfh6fqoc+857YQuFBg+L5BOhB6ysbZytY+JyFB3KS2dnl64F0ocCzirmvz5
	NAC+xWbSR5I/mqgFNS/aU3l5WpXPAGTH7X7/uhT+jtkKYiMstdAYiXoBrEJv5b40mk9u
	5lVIHKnP/gl24q9d3UXs1znrguKBRih/G5FlLfiCeNoQ+mJdEQ5wiihwQsMbRQlrxgg/
	mYIj9f6HZg/NqFJvbbxCLjfBQO9p21NYkmqPyVksoeX6/lW22lgUKCOZ5XU1w1fvf+tr
	fvJWpmJkNe/pOX/q90zNMpIyYROsuOrIy6VSW731ENo4ssdA/HlkeUO5jhDaBiCrz5JK
	gXIQ==
X-Gm-Message-State: AOAM533WfxqAs1lXHuCH33joR1sVClvsLaSyjalS7KNjV5XPmPY2t2qc
	NQi2sBi/IKKEMoQpmOa52PVcWyKeFvuNCwqeEGg=
X-Google-Smtp-Source: ABdhPJz6F7eb7ZlPz+uZ1ryBjKV5MJY+6g8VTzYPNDQv8d/IMiyQJel1uICTBXlYxhNSBRKxb1cJsAgM4Rtiu1G511Y=
X-Received: by 2002:a17:906:b084:: with SMTP id
	x4mr35926642ejy.214.1636873572801; 
	Sat, 13 Nov 2021 23:06:12 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
	<CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
	<CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
	<CAOuPNLg_YwyhK6iPZZbRWe57Kkr1d8LjJaDniCvvOqk4t2-Sog@mail.gmail.com>
In-Reply-To: <CAOuPNLg_YwyhK6iPZZbRWe57Kkr1d8LjJaDniCvvOqk4t2-Sog@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Sun, 14 Nov 2021 12:36:01 +0530
Message-ID: <CAOuPNLgYhm=goOiABjUFsAvRW+s2NqHjHYdm5MA9PvoUAMxOpg@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Daniel Rosenberg <drosen@google.com>, astrachan@google.com,
	speed.eom@samsung.com, Sami Tolvanen <samitolvanen@google.com>,
	snitzer@redhat.com, squashfs-devel@lists.sourceforge.net
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Nov 2021 01:54:31 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

+ Adding squashfs-devel to get opinion from squashfs side.

On Fri, 12 Nov 2021 at 12:48, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> Hi,
>
> On Tue, 9 Nov 2021 at 21:04, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> > > > We only get these squashfs errors flooded in the boot logs:
> > > > {{{
> > > > ....
> > > > [    5.153479] device-mapper: init: dm-0 is ready
> > > > [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
> > > > ....
> > > > [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
> > > > [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> > > > [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
> > > > [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
> > > > [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
> > > > [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
> > > > [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
> > > > ....
> > > > }}}
> > > >
>
> One more observation:
> When I disable FEC flag in bootloader, I see the below error:
> [    8.360791] device-mapper: verity: 253:0: data block 2 is corrupted
> [    8.361134] device-mapper: verity: 253:0: data block 3 is corrupted
> [    8.366016] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> [    8.379652] SQUASHFS error: Unable to read data cache entry [1106]
> [    8.379680] SQUASHFS error: Unable to read page, block 1106, size 7770
>
> Also, now I see that the decompress error is gone, but the read error
> is still there.
>
> This seems to me that dm-verity detects some corrupted blocks but with
> FEC it auto corrects itself, how when dm-verity auto corrects itself,
> the squashfs decompression algorithm somehow could not understand it.
>
> So, it seems like there is some mis-match between the way FEC
> correction and the squashfs decompression happens ?
>
> Is this issue seen by anybody else here ?
>

The squashfs version used by Kernel:
[    0.355958] squashfs: version 4.0 (2009/01/31) Phillip Lougher

The squashfs version available on Ubuntu:
mksquashfs version 4.3-git (2014/06/09)

The squashfs version used by Yocto 2.6:
squashfs-tools/0001-squashfs-tools-Allow-setting-selinux-xattrs-through-.patch:61:
   printf("mksquashfs version 4.3-git (2014/09/12)\n");

We create dm-verity squashfs image using version 4.3 whereas, the
kernel uses 4.0 version to decompress it.
Is there something missing here?

When FEC (Forward Error Correction) comes into picture, then squashfs
decompress fails.
When we remove FEC flag from dm-verity then decompress works but read
error still occurs.
This seems as if something is missing either in FEC handling or either
in squashfs decompress logic.

Just wanted to know if there are any fixes already available in the
mainline for this ?


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

