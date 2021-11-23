Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F3DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:36:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-wdgOXxldMAe9AAM67CqYYw-1; Tue, 23 Nov 2021 18:36:17 -0500
X-MC-Unique: wdgOXxldMAe9AAM67CqYYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14867871803;
	Tue, 23 Nov 2021 23:36:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 578C918432;
	Tue, 23 Nov 2021 23:36:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 388964A703;
	Tue, 23 Nov 2021 23:36:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANAaVm1011822 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 05:36:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1BD262026D7F; Tue, 23 Nov 2021 10:36:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 169992026D67
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 10:36:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FE99811E7A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 10:36:25 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
	[209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-567-pSO7wdoSPcCWeARh9Z-L3g-1; Tue, 23 Nov 2021 05:36:21 -0500
X-MC-Unique: pSO7wdoSPcCWeARh9Z-L3g-1
Received: by mail-ed1-f41.google.com with SMTP id o20so45613861eds.10;
	Tue, 23 Nov 2021 02:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
	bh=VQJ6CdunLhhxPVsr+8Cb/isFyJRrndJrABiFEBMcKdE=;
	b=gR0arzD90j5tldnpGrOreVfuFdkly9FOd6lVIrr1z4B3FQ/rvZzapfu6seY+TCjf3w
	LdMOQ8WOvscQQK4GKGukrEITCB4+DkuNDvHATZSt6aIqTm4nY+wDuvzGPTpoz5C1nBkN
	C70C5B0aJWEtG3wZBKPHqxtEhaEMyAI8Rir+PkoM8vX0quq8RCux5F9+ZSDPncRveq5M
	PUjZ1syrpeejDO/0tMGCL4svs9CnwvYmjUVWSTrJanhErfhHC8YV5h1htCg2tfzOXXSu
	lqqRYP3yKVJ5Kn3JZwNGNFisx81KS2zmhltpINKk4bwZx8KyXrhILi9drZP+hfhDS+0m
	7jZA==
X-Gm-Message-State: AOAM531+tNWXej0o0zDLNEpsg/eLpv/c2N5E9HiW6+DhK5P7phEdSKUl
	4qY/jvhBlmI7FsCddySXNbbuzqL2JPyZG7SBMfOHKv/wXsc=
X-Google-Smtp-Source: ABdhPJzm3DTP1MZxdqjayOarBF034HP+d2wEyoI39+wkYagw7aqD/G2MHVKA5OJDylJTzwPzGPBa9/0UiuRqo+uiYbE=
X-Received: by 2002:a17:906:b084:: with SMTP id
	x4mr6307130ejy.214.1637663779673; 
	Tue, 23 Nov 2021 02:36:19 -0800 (PST)
MIME-Version: 1.0
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Tue, 23 Nov 2021 16:06:08 +0530
Message-ID: <CAOuPNLiXCmH+Ut8kf0DJe2Aonb11RJYeUmYQFsB=oSLbep+MdQ@mail.gmail.com>
To: dm-devel@redhat.com, helen.koike@collabora.com, wad@chromium.org,
	Kees Cook <keescook@chromium.org>, enric.balletbo@collabora.com,
	snitzer@redhat.com, agk@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 23 Nov 2021 18:32:52 -0500
Cc: open list <linux-kernel@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>
Subject: [dm-devel] dm-verity: How to exactly use the dm-mod.create with
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

For rootfs dm-verity I am trying to pass dm-mod.create from our
bootloader but it seems not working for me.
So, I need some guidance on the parameters that we pass here.
The documentation also does not seem to help much.

Kernel: 4.14 (with dm-init patch backported)
Target: Arm-32 / NAND / Simple Busybox / Bootloader (edk2)
Build: Ubuntu-18.04 / Yocto 2.6

Steps I followed:
1) First I am trying to generate the root hash for our rootfs using
the veritysetup command:
$ ls -l system.img
64172032 ==> IMAGE_SIZE
$ veritysetup format system.img dm-init-verity.img
UUID:                   eca62b73-b66a-4249-834b-471e83fc382c
Hash type:              1
Data blocks:            15667
Data block size:        4096
Hash block size:        4096
Hash algorithm:         sha256
Salt:
8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b
Root hash:
10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af

2) Then I am trying to append the verity with the system image itself:
$ cat dm-init-verity.img >> system.img

3) After that I am trying to pass dm-mod.create parameter like this:
dm-mod.create=\"system,,,ro, 0 IMAGE_SIZE/512 verity 1
/dev/ubiblock0_0 /dev/ubiblock0_0 4096 4096 DATA_BLOCKS 1 sha256
10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b\"

4) The Kernel command line seems to be updated properly:
[    0.000000] Kernel command line:.. rootfstype=squashfs
ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/ubiblock0_0
dm-mod.create="system,,,ro, 0 125336 verity 1 /dev/ubiblock0_0
/dev/ubiblock0_0 4096 4096 15667 1 sha256
10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b" ....

But it does not seem to work as expected.
It gives below errors:
....
[    4.747708] block ubiblock0_0: created from ubi0:0(system)
[    4.752313] device-mapper: init: waiting for all devices to be
available before creating mapped devices
[    4.752313]
[    4.766061] device-mapper: verity: sha256 using implementation
"sha256-generic"
[    4.776178] device-mapper: ioctl: dm-0 (system) is ready
[    4.848886] md: Skipping autodetection of RAID arrays.
(raid=autodetect will force)
[    4.849288] VFS: Cannot open root device "ubiblock0_0" or
unknown-block(252,0): error -16
....

I followed almost the same example from dm-init document:
"verity":
  dm-verity,,4,ro,
    0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
    fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
    51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584

But this seems only refer to system and verity on a different blocks.
I am not sure what parameter should be changed if my verity metadata
is part of system image itself.
Also, I don't know how 1638400;204800;1 is calculated here based on image size ?

So, people who have made this working successfully, please share the
correct parameter to be used for the same block device.

Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

