Return-Path: <SRS0=ugf6=NW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5044CC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:26:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8CE860200
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:26:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E8CE860200
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-xFRZOEJrOm6Lr-qG8zue-Q-1; Tue, 31 Aug 2021 03:26:00 -0400
X-MC-Unique: xFRZOEJrOm6Lr-qG8zue-Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D2C08799EF;
	Tue, 31 Aug 2021 07:25:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7516B17AC5;
	Tue, 31 Aug 2021 07:25:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 210E4181A0F8;
	Tue, 31 Aug 2021 07:25:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17UIIwLu024773 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 14:18:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 621C1201AC4C; Mon, 30 Aug 2021 18:18:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DDCF201AC4F
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 18:18:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A894D100B8C0
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 18:18:55 +0000 (UTC)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com
	[209.85.218.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-58-_xG21m3kOBO3FyW3VraaQA-1; Mon, 30 Aug 2021 14:18:53 -0400
X-MC-Unique: _xG21m3kOBO3FyW3VraaQA-1
Received: by mail-ej1-f51.google.com with SMTP id n27so33105236eja.5;
	Mon, 30 Aug 2021 11:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=4nZc2m/dOqxmB1eKzo22dnXLX+VFfEl/hwdI2/cyoEM=;
	b=coZEjnL7/ZENbioDmgAuIgAXRcuiL/WfYW6nDS4/SzI9KxkLBvXXsnH6VVub9vMwVX
	cEA1/P7SmBm8XbOj4SXdpdON5eH4xS6vwEggB6AUBIXZ0n5Hk43dKy7x+kIPJL3NQ2mP
	xPUjj1wJ4Az0vXQdEldsV6O3vzCBLW5GH3HfmAQCFemMLfPaj7gBE8V5DWGEHmwvEoM2
	3bNuoHCrZPpD8BpY6aeKO8IdRtW3IUvKgTvfnzq3VBp4bc8t5SNK4ZiEik5U7KWrpfl3
	jgUqyKvD3TyJjyOzn+JUJ6v7BHQwN+lUdP3QedlpCem5FYQA3onq2Dl7nQvrCKUOlelD
	iN8A==
X-Gm-Message-State: AOAM533Ldgc2zjGYdjG9VMs5Z2WnWMIkM4zqwVx1tHgdZGpVyo2r4CXR
	X1u4ynznI0kcGSA57ijbvBP+te+Yi+I+o7xHEMg=
X-Google-Smtp-Source: ABdhPJyQzW3MlAgCliu3WdiEbQ0YtZ+8ycOJa910u+zPDe/bD8bYKE5SakukZYmkGdvUYCdU8uIVUyt9VaN9BvcL3l4=
X-Received: by 2002:a17:906:8cc:: with SMTP id
	o12mr18643103eje.252.1630347531529; 
	Mon, 30 Aug 2021 11:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
	<CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
	<20210830185541.715f6a39@windsurf>
In-Reply-To: <20210830185541.715f6a39@windsurf>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Mon, 30 Aug 2021 23:48:40 +0530
Message-ID: <CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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
X-Mailman-Approved-At: Tue, 31 Aug 2021 03:25:15 -0400
Cc: Sami Tolvanen <samitolvanen@google.com>, snitzer@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>, agk@redhat.com
Subject: Re: [dm-devel] Kernel 4.14: Using dm-verity with squashfs rootfs -
	mounting issue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 30 Aug 2021 at 22:25, Thomas Petazzoni
<thomas.petazzoni@bootlin.com> wrote:
>
> Hello,
>
> On Mon, 30 Aug 2021 21:55:19 +0530
> Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> > Sorry for coming back to this again..
> > Unfortunately, none of the options is working for us with squashfs
> > (bootloader, initramfs).
> > initramfs have different kinds of challenges because of the partition
> > size issue.
> > So, our preferred option is still the bootloader command line approach..
> >
> > Is there a proven and working solution of dm-verity with squashfs ?
> > If yes, please share some references.
> >
> > The current problem with squashfs is that we could not append the
> > verity-metadata to squashfs, so we store it on a separate volume and
> > access it.
>
> Here, it definitely worked to append the hash tree to the squashfs
> image and store them in the same partition.
>
> > By specifying it like : /dev/mtdblock53
> >
> > Then we get the error like this:
> > {
> > [    4.950276] device-mapper: init: attempting early device configuration.
> > [    4.957577] device-mapper: init: adding target '0 95384 verity 1
> > /dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
> > 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
> > aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
> > restart_on_corruption ignore_zero_blocks use_fec_from_device
> > /dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026'
> > [    4.975283] device-mapper: verity: sha256 using implementation
> > "sha256-generic"
> > [    4.998728] device-mapper: init: dm-0 is ready
>
> Could you show the full kernel command line ?
Shared below

> > Do you see any other problem here with dm-verity cmdline or with squashfs ?
> >
> > Is squashfs ever proved to be working with dm-verity on higher kernel version ?
> > Currently our kernel version is 4.14.
>
> I confirm we used squashfs on dm-verity successfully. For sure on 4.19,
> perhaps on older kernels as well.

ohh that means we already have a working reference.
If possible can you share the details, even 4.19 or higher will be
also a good reference.

> > Or, another option is to use the new concept from 5.1 kernel that is:
> > dm-mod.create = ?
> How are you doing it today without dm-mod.create ?
I think in 4.14 we don't have dm-mod.create right ?

> Again, please give your complete kernel command line.
>
Here is our kernel command line:

[    0.000000] Kernel command line: ro rootwait
console=ttyMSM0,115200,n8 ....  verity="95384 11923
16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3 12026
" rootfstype=squashfs ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/dm-0
.... init=/sbin/init root=/dev/dm-0 dm="rootfs none ro,0 95384 verity
1 /dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
restart_on_corruption ignore_zero_blocks use_fec_from_device
/dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026" ...

Do you see any issue here ?
Can you share your command line for squashfs to compare ?

Thank you,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

