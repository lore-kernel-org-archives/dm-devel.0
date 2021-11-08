Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A951EC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:02:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E9386109F
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3E9386109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-I5Nb0-TnP16mYdcDThkPUQ-1; Tue, 09 Nov 2021 02:02:07 -0500
X-MC-Unique: I5Nb0-TnP16mYdcDThkPUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EAAC56C31;
	Tue,  9 Nov 2021 07:02:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 765CB196F8;
	Tue,  9 Nov 2021 07:02:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88A884A703;
	Tue,  9 Nov 2021 07:02:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8EVE7Z025242 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 09:31:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 944184047279; Mon,  8 Nov 2021 14:31:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 904CB4047272
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 14:31:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77FFB1066685
	for <dm-devel@redhat.com>; Mon,  8 Nov 2021 14:31:14 +0000 (UTC)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
	[209.85.208.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-94-dkZM4BewN4e8KdrDz_N_og-1; Mon, 08 Nov 2021 09:31:10 -0500
X-MC-Unique: dkZM4BewN4e8KdrDz_N_og-1
Received: by mail-ed1-f46.google.com with SMTP id b15so43931746edd.7;
	Mon, 08 Nov 2021 06:31:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=w24kyLgv/+tRpo8I42SDBKmopyeaJ4ePm0P/HuK8v0E=;
	b=mFDrZFH9wUamRrGK5rpW7HsheHpGvraRLSZYB5dPOepB1QG+lrLby2V95f1jiAaiAt
	0VuuoaYyT88SXT39rtF6LUA3w2dRP81J7ufzd7CKgbx3+miheJbVYbnRRp+mji83h5ZR
	VaKexKLmXlOgCjw/reBecbZ0H8NO1Cr1i3W3hCQUX2MPTrONIwuicDPPjzroMPdgoyNl
	ITU/TSv/90Xncaa1gUk5SttrMBtAT2ALh9weEAzqBYv6MoXQMVLgKLHAUNmBgpQKBYaC
	iw8HiY9Djk6Fav9h6GW6zjyAuhvs5B/uJ2xyjo9p+Crex8dmV6rMc/b/rXtiQoBXVbxA
	aw4A==
X-Gm-Message-State: AOAM5338E1/G0juoEwpm6deMOfpF1037yVngiDF71PmgTSBKx4ee6382
	sFcYxOt2hidrPWLu+NSTV94J3RzBmjzbIfQ80V2fsdHF3lq4JA==
X-Google-Smtp-Source: ABdhPJy+CUCy4DtJsFc1sFIUJC3eXz9pThsGdgn6pHpEYmaxe6UL4ZDtO5HI5J/PFwCYYvEgRPLHHE+FhZK20HJ79Gw=
X-Received: by 2002:a17:906:2ad2:: with SMTP id
	m18mr384079eje.64.1636381865427; 
	Mon, 08 Nov 2021 06:31:05 -0800 (PST)
MIME-Version: 1.0
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Mon, 8 Nov 2021 20:00:54 +0530
Message-ID: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>
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
X-Mailman-Approved-At: Tue, 09 Nov 2021 02:01:34 -0500
Subject: [dm-devel] Kernel-4.14: With ubuntu-18.04 building rootfs images
 and booting gives SQUASHFS error: xz decompression failed,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
Here are few details.
* Linux Kernel: 4.14
* Processor: Qualcomm Arm32 Cortex-A7
* Storage: NAND 512MB
* Platform: Simple busybox
* Filesystem: UBIFS, Squashfs
* Build system: Linux Ubuntu 18.04 with Yocto build system
* Consists of nand raw partitions, squashfs ubi volumes.

What we are trying to do:
We are trying to boot dm-verity enabled rootfs on our system.
The images for rootfs were generated on Ubuntu 18.04 machine using
Yocto build system.

Issue:
Earlier, when we were using Ubuntu 16.04 to generate our images, the
system was booting fine even with dm-verity enabled.
Recently we switched to Ubuntu 18.04 build machine, and now with the
same changes we are seeing the below squashfs error, just after the
mount.
Note: with 18.04 also our rootfs is mounting successfully and
dm-verity is also working fine.
We only get these squashfs errors flooded in the boot logs:
{{{
....
[    5.153479] device-mapper: init: dm-0 is ready
[    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
....
[    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
[    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
[    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
[    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
[    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
[    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
[    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
....
}}}

Note: For dm-verity wwe are trying to append the verity-metadata as
part of our rootfs image like this:
...
218 +    with open(verity_md_img, "rb") as input_file:
219 +        with open(sparse_img, "ab") as out_file:
220 +            for line in input_file:
221 +                out_file.write(line)
....

These changes work fine when we build it with Ubuntu 16.04.
So, we are wondering what could be the issue with Ubuntu 18.04 build ?

If there is any history about it please let us know.


Regards,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

