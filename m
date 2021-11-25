Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1868FC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 25 Nov 2021 17:52:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-k5z6DNTlMBCwdjz8zMtkVg-1; Thu, 25 Nov 2021 12:51:57 -0500
X-MC-Unique: k5z6DNTlMBCwdjz8zMtkVg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAAA681CCB4;
	Thu, 25 Nov 2021 17:51:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 162255D9CA;
	Thu, 25 Nov 2021 17:51:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA54D4BB7C;
	Thu, 25 Nov 2021 17:51:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1APHpjbM023980 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Nov 2021 12:51:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D078051E4; Thu, 25 Nov 2021 17:51:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA2D651DD
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 17:51:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ECE41066559
	for <dm-devel@redhat.com>; Thu, 25 Nov 2021 17:51:40 +0000 (UTC)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
	[209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-416-AR23ah8yOh-8XD9-Zp41WQ-1; Thu, 25 Nov 2021 12:51:36 -0500
X-MC-Unique: AR23ah8yOh-8XD9-Zp41WQ-1
Received: by mail-ed1-f51.google.com with SMTP id o20so28404965eds.10;
	Thu, 25 Nov 2021 09:51:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=iptSVGzbMcAeJvQpIm3YmgtiZkGGvvz55c0vj1Foiuc=;
	b=Zjbo8/lp3TTIhtZcGbds+/Bptd9pwohk2sRRnkYx/zOj4FgH+gVC28CBAyfqmcAp3q
	sp4qoDPjj/AQ+x0bWZtqqx84ORkNtqnDRu+RakGTffnfKjWaY9yg5HB9wjX3PfizWUzP
	JkWTIC0TJ4QZ79PoJ6g1eXww2+v69xF4IWIjTqlsw+lxQHmo0e9U5SyGuBtCv2vcDDMf
	5DOeoh/ii68E6PmEf6BhO5D/bmcqvIWqbSMEZ2/Oye4xOpgOfG5dQcGpO9qFcf48l3ev
	WdDj8biO1ILQ+7Zqe2bKOUk+aOCeesnfcI0q6Bs9bi57h2kMD1QbBa3cZ7dSIgHTUtdw
	pFug==
X-Gm-Message-State: AOAM532ARdgkvisr3eb3nxF1IInKeddmX9qaTwaVO480RdyedxUHy+sX
	RdeHxa0OuGMsK/4JPJbs9Bn2iSoxfxgjpM47Xw0=
X-Google-Smtp-Source: ABdhPJwdKZ10P/lr8q1OTFlZXjNlS8gl8JmeliCgmLg1BMFnFyc0ZdjgrhjrH1gwJ97jJuZrcxwVRH80zZGl4YjlBQc=
X-Received: by 2002:a50:da0a:: with SMTP id z10mr40028540edj.95.1637862695046; 
	Thu, 25 Nov 2021 09:51:35 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLiXCmH+Ut8kf0DJe2Aonb11RJYeUmYQFsB=oSLbep+MdQ@mail.gmail.com>
	<CAAFS_9G_gQrBBJ2AWpwBWwZK41qiaFhBXy17XDeL7hOBxOvFeQ@mail.gmail.com>
In-Reply-To: <CAAFS_9G_gQrBBJ2AWpwBWwZK41qiaFhBXy17XDeL7hOBxOvFeQ@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Thu, 25 Nov 2021 23:21:23 +0530
Message-ID: <CAOuPNLghnx3gRCSyjBhw1O5Ux+vwuyxhfrAo1eUmGR85zhsbvg@mail.gmail.com>
To: Will Drewry <wad@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 23 Nov 2021 at 22:13, Will Drewry <wad@chromium.org> wrote:
>
> On Tue, Nov 23, 2021 at 4:36 AM Pintu Agarwal <pintu.ping@gmail.com> wrote:
> >
> > Hi,
> >
> > For rootfs dm-verity I am trying to pass dm-mod.create from our
> > bootloader but it seems not working for me.
> > So, I need some guidance on the parameters that we pass here.
> > The documentation also does not seem to help much.
> >
> > Kernel: 4.14 (with dm-init patch backported)
> > Target: Arm-32 / NAND / Simple Busybox / Bootloader (edk2)
> > Build: Ubuntu-18.04 / Yocto 2.6
> >
> > Steps I followed:
> > 1) First I am trying to generate the root hash for our rootfs using
> > the veritysetup command:
> > $ ls -l system.img
> > 64172032 ==> IMAGE_SIZE
> > $ veritysetup format system.img dm-init-verity.img
> > UUID:                   eca62b73-b66a-4249-834b-471e83fc382c
> > Hash type:              1
> > Data blocks:            15667
> > Data block size:        4096
> > Hash block size:        4096
> > Hash algorithm:         sha256
> > Salt:
> > 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b
> > Root hash:
> > 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
> >
> > 2) Then I am trying to append the verity with the system image itself:
> > $ cat dm-init-verity.img >> system.img
> >
> > 3) After that I am trying to pass dm-mod.create parameter like this:
> > dm-mod.create=\"system,,,ro, 0 IMAGE_SIZE/512 verity 1
> > /dev/ubiblock0_0 /dev/ubiblock0_0 4096 4096 DATA_BLOCKS 1 sha256
> > 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
> > 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b\"
> >
> > 4) The Kernel command line seems to be updated properly:
> > [    0.000000] Kernel command line:.. rootfstype=squashfs
> > ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/ubiblock0_0
> > dm-mod.create="system,,,ro, 0 125336 verity 1 /dev/ubiblock0_0
> > /dev/ubiblock0_0 4096 4096 15667 1 sha256
> > 10d9036f6efdd48dd49f09c8ece016a36a2c4d9a01a1f77f01485c65cf0e78af
> > 8b66f42c07f576429109cf4e5d12ec072b23d242a9e653ac3423e49647339f5b" ....
> >
> > But it does not seem to work as expected.
> > It gives below errors:
> > ....
> > [    4.747708] block ubiblock0_0: created from ubi0:0(system)
> > [    4.752313] device-mapper: init: waiting for all devices to be
> > available before creating mapped devices
> > [    4.752313]
> > [    4.766061] device-mapper: verity: sha256 using implementation
> > "sha256-generic"
> > [    4.776178] device-mapper: ioctl: dm-0 (system) is ready
> > [    4.848886] md: Skipping autodetection of RAID arrays.
> > (raid=autodetect will force)
> > [    4.849288] VFS: Cannot open root device "ubiblock0_0" or
> > unknown-block(252,0): error -16
>
> I'd start with changing your root device to point to the device mapper
> one you've just created.  E.g., root=/dev/dm-0  Then see how it goes
> from there.

Yes I tried this already but it seems the problem was something else.

> >
> > I followed almost the same example from dm-init document:
> > "verity":
> >   dm-verity,,4,ro,
> >     0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
> >     fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
> >     51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
> >
> > But this seems only refer to system and verity on a different blocks.
> > I am not sure what parameter should be changed if my verity metadata
> > is part of system image itself.
> > Also, I don't know how 1638400;204800;1 is calculated here based on image size ?
>
> It's the range of sectors covered by the device 0 to size_in_sectors:
>   (data_blocks * block_size)/sector_size
>   (15667 * 4096)/512
>   125336
> which you have in your entry already.
>

Now I made it working using both dmsetup first and then using
dm-mod.create with the same parameters.
There is slightly a different step when appending metadata to the
system image itself.
First, we need to adjust the hash offset for metadata location.
Then we need to specify the offset in terms of number of blocks. This
is still fine.
But the problem is to specify the hash_start which is (number of blocks + 1).

So, I used like this:
veritysetup format --hash-offset=<image size> system.img system.img
(The metadata will be appended automatically at the end of system.img)
This will give the data blocks as well.
dm-mod.create=\"system,,,ro, 0 125336 verity 1 /dev/ubiblock0_0
/dev/ubiblock0_0 4096 4096 15667 15668 sha256
39438d7915f2af8532752d78ce0cc08dc9d23b9e7176518310bc65de5c226c7d
56413cf91ccc9e32ec5b2d36b54e61114ab92a345d8547a194fc86ff4437896c\"

So, this worked for me.

Thank you so much!

Regards,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

