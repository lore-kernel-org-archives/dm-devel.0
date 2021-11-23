Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1950C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 16:43:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-KiU2HcJ3O76fwwRfC8ad_A-1; Tue, 23 Nov 2021 11:43:39 -0500
X-MC-Unique: KiU2HcJ3O76fwwRfC8ad_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED9E810168D8;
	Tue, 23 Nov 2021 16:43:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A64F91017CE3;
	Tue, 23 Nov 2021 16:43:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 549F74E58F;
	Tue, 23 Nov 2021 16:43:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANGhV7U021076 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 11:43:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C889A404727A; Tue, 23 Nov 2021 16:43:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C477D4047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 16:43:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AACA618A652F
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 16:43:31 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-515-yOPQZ5zZMPmWiRl2i9hAhA-1; Tue, 23 Nov 2021 11:43:29 -0500
X-MC-Unique: yOPQZ5zZMPmWiRl2i9hAhA-1
Received: by mail-wr1-f43.google.com with SMTP id d24so40092958wra.0
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 08:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=5neTUk/m2vB9IAM6ngUOM8n9WDJP9MLnMLArs9XbOJw=;
	b=Oe18Rjf9+CgWVv3V9JHqiDI9gh0rbZxLyaTTh4U8f+YMVwUrjffcXSNrKg4hf3EKZx
	7UoYTHQ6Eu/IY6qxlrTrJhQHhZkglAEF3UXGyiJBs+9T+zGckKPIJBn+W+Y8FbQN3Jmd
	cPqfFVsHvUPBmjsMZCJKV8ZBLOThGvvfYkm6ak4CuFp6cNjkNyE5ckvDygM//l+XOdR2
	UmggVPA3K8WMdF19EsgD/08hq7bLeoVzBIc0wCmGONzaK44fQl7b+mc+0udKhvyxAN3T
	XehxNF0xbBUp633BypBz2+MGbPwB6Q7sMb1smWFmZsm6yE9SfF7ozUogCoYfHiMsEA7U
	0Okw==
X-Gm-Message-State: AOAM533/BHml9IXcAqpIEmpOm8uXRkImFPwUi0NpJa+4Bvr2d+gDHWUH
	yvvdng787pE7S0RGfYIkTqJakxJyMxd+/zxkWEWrZA==
X-Google-Smtp-Source: ABdhPJwzTM7lcjHa6kT/XkIFqyUhLvbfIVKMMsj5u/hKr4G+sFpnC60Aiu1g1tWSlFVoSzSbrQwFPZ0Me/zJiV4Yybs=
X-Received: by 2002:a5d:58fb:: with SMTP id f27mr9217095wrd.10.1637685808489; 
	Tue, 23 Nov 2021 08:43:28 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLiXCmH+Ut8kf0DJe2Aonb11RJYeUmYQFsB=oSLbep+MdQ@mail.gmail.com>
In-Reply-To: <CAOuPNLiXCmH+Ut8kf0DJe2Aonb11RJYeUmYQFsB=oSLbep+MdQ@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Date: Tue, 23 Nov 2021 10:43:15 -0600
Message-ID: <CAAFS_9G_gQrBBJ2AWpwBWwZK41qiaFhBXy17XDeL7hOBxOvFeQ@mail.gmail.com>
To: Pintu Agarwal <pintu.ping@gmail.com>
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
Cc: Kees Cook <keescook@chromium.org>, snitzer@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>, helen.koike@collabora.com,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	enric.balletbo@collabora.com, agk@redhat.com
Subject: Re: [dm-devel] dm-verity: How to exactly use the dm-mod.create with
 verity-metadata append
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

On Tue, Nov 23, 2021 at 4:36 AM Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> Hi,
>
> For rootfs dm-verity I am trying to pass dm-mod.create from our
> bootloader but it seems not working for me.
> So, I need some guidance on the parameters that we pass here.
> The documentation also does not seem to help much.
>
> Kernel: 4.14 (with dm-init patch backported)
> Target: Arm-32 / NAND / Simple Busybox / Bootloader (edk2)
> Build: Ubuntu-18.04 / Yocto 2.6
>
> Steps I followed:
> 1) First I am trying to generate the root hash for our rootfs using
> the veritysetup command:
> $ ls -l system.img
> 64172032 ==> IMAGE_SIZE
> $ veritysetup format system.img dm-init-verity.img
> UUID:                   eca62b73-b66a-4249-834b-471e83fc382c
> Hash type:              1
> Data blocks:            15667
> Data block size:        4096
> Hash block size:        4096
> Hash algorithm:         sha256
> Salt:
> 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b
> Root hash:
> 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
>
> 2) Then I am trying to append the verity with the system image itself:
> $ cat dm-init-verity.img >> system.img
>
> 3) After that I am trying to pass dm-mod.create parameter like this:
> dm-mod.create=\"system,,,ro, 0 IMAGE_SIZE/512 verity 1
> /dev/ubiblock0_0 /dev/ubiblock0_0 4096 4096 DATA_BLOCKS 1 sha256
> 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
> 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b\"
>
> 4) The Kernel command line seems to be updated properly:
> [    0.000000] Kernel command line:.. rootfstype=squashfs
> ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/ubiblock0_0
> dm-mod.create="system,,,ro, 0 125336 verity 1 /dev/ubiblock0_0
> /dev/ubiblock0_0 4096 4096 15667 1 sha256
> 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
> 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b" ....
>
> But it does not seem to work as expected.
> It gives below errors:
> ....
> [    4.747708] block ubiblock0_0: created from ubi0:0(system)
> [    4.752313] device-mapper: init: waiting for all devices to be
> available before creating mapped devices
> [    4.752313]
> [    4.766061] device-mapper: verity: sha256 using implementation
> "sha256-generic"
> [    4.776178] device-mapper: ioctl: dm-0 (system) is ready
> [    4.848886] md: Skipping autodetection of RAID arrays.
> (raid=autodetect will force)
> [    4.849288] VFS: Cannot open root device "ubiblock0_0" or
> unknown-block(252,0): error -16

I'd start with changing your root device to point to the device mapper
one you've just created.  E.g., root=/dev/dm-0  Then see how it goes
from there.

> ....
>
> I followed almost the same example from dm-init document:
> "verity":
>   dm-verity,,4,ro,
>     0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
>     fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
>     51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
>
> But this seems only refer to system and verity on a different blocks.
> I am not sure what parameter should be changed if my verity metadata
> is part of system image itself.
> Also, I don't know how 1638400;204800;1 is calculated here based on image size ?

It's the range of sectors covered by the device 0 to size_in_sectors:
  (data_blocks * block_size)/sector_size
  (15667 * 4096)/512
  125336
which you have in your entry already.

> So, people who have made this working successfully, please share the
> correct parameter to be used for the same block device.

hth,
will

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

