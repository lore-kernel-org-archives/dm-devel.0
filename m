Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D56C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7303A60F36
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 08:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7303A60F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-ux8_gCgXPF6PjjoMsB-RnA-1; Mon, 01 Nov 2021 04:45:34 -0400
X-MC-Unique: ux8_gCgXPF6PjjoMsB-RnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D52E8030AF;
	Mon,  1 Nov 2021 08:45:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F1ED19C79;
	Mon,  1 Nov 2021 08:45:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D65801806D03;
	Mon,  1 Nov 2021 08:45:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19TFpoOL023823 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 11:51:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2733840C1242; Fri, 29 Oct 2021 15:51:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23611400F3F3
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 15:51:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09AC6800883
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 15:51:50 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
	[209.85.208.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-237-za2Of2IpPMaLPo4hUGTdnA-1; Fri, 29 Oct 2021 11:51:48 -0400
X-MC-Unique: za2Of2IpPMaLPo4hUGTdnA-1
Received: by mail-ed1-f41.google.com with SMTP id w1so21180647edd.0;
	Fri, 29 Oct 2021 08:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=NESlwwMORorwSWYzWjNc0O70aEVgaVjtuvkdZI1/8es=;
	b=vD2ghor1FL8vPbGMBWcKF5ulfwU3uJoRMM0kazCFwztl177skqvpcz2cFjdcenAyhN
	TcrRQyRPWKkVt8gfQksUSdeh1fHTQAcgIeUXdi18RhR8IkXeYq0+EEGCubwYHV53YvHQ
	cC3E9KHWyK12EYGAU6Azffn0rar/PkWU24HCY6oLKe7NYDdiAujCgy+vRqwBB7OKYqv8
	sZcwPsxJO6YJ6nwalF2GS0fRAy6QRqpisvlV/9b9sqWM97Sd2HcVclnLtIH58SJ6fhqd
	kENYLQmmCGHFAvLP5E7jdSDm38U6bfGiwC202Bq1hl6SbxQ97x/NV693s9fOKlSvXPC7
	dLfw==
X-Gm-Message-State: AOAM530/5W0qJs6j4bfoeDRtTp6JzCu80z92Ohyp0S7DBRd4hFEww/yc
	Ns71qLSxDSxIf2H+HKdDHmexAHzY/5LUdV0T58w=
X-Google-Smtp-Source: ABdhPJwaZoIDWVCGaHYKcnttqgtKxA/h8msb9rhToLx+whKahsfVfCWinU7ltf1BsXNc6XsBxJ1fumjug1/uaYuC90g=
X-Received: by 2002:a05:6402:274f:: with SMTP id
	z15mr16361253edd.306.1635522704379; 
	Fri, 29 Oct 2021 08:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
	<CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
	<20210830185541.715f6a39@windsurf>
	<CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
	<20210830211224.76391708@windsurf>
	<CAOuPNLgMd0AThhmSknbmKqp3_P8PFhBGr-jW0Mqjb6K6NchEMg@mail.gmail.com>
	<CAOuPNLiW10-E6F_Ndte7U9NPBKa9Y_UuLhgdwAYTc0eYMk5Mqg@mail.gmail.com>
	<CAOuPNLj2Xmx52Gtzx5oEKif4Qz-Tz=vaxhRvHQG-5emO7ewRhg@mail.gmail.com>
	<YTinqiH9h+Q9bYsr@kroah.com>
In-Reply-To: <YTinqiH9h+Q9bYsr@kroah.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Fri, 29 Oct 2021 21:21:33 +0530
Message-ID: <CAOuPNLhzfGDoQsEZB5eH30WvH2w9hyMEU8Bt81SzK-scaAwgwA@mail.gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 01 Nov 2021 04:45:25 -0400
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, snitzer@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi All,

On Wed, 8 Sept 2021 at 17:38, Greg KH <gregkh@linuxfoundation.org> wrote:

> > > > > No, but you can backport it easily. Back at
> > > > > http://lists.infradead.org/pipermail/openwrt-devel/2019-November/025967.html
> > > > > I provided backports of this feature to OpenWrt, for the 4.14 and 4.19
> > > > > kernels.
> >
> > Can you please let me know where to get the below patches for
> > backporting to our kernel:
> >  create mode 100644
> > target/linux/generic/backport-4.14/390-dm-add-support-to-directly-boot-to-a-mapped-device.patch
> >  create mode 100644
> > target/linux/generic/backport-4.14/391-dm-init-fix-max-devices-targets-checks.patch
> >  create mode 100644
> > target/linux/generic/backport-4.14/392-dm-ioctl-fix-hang-in-early-create-error-condition.patch
> >  create mode 100644
> > target/linux/generic/backport-4.14/393-Documentation-dm-init-fix-multi-device-example.patch
>
> If you are stuck on an older kernel version, then you need to get
> support from the vendor that is forcing you to be on that kernel
> version, as you are already paying them for support.  Please take
> advantage of that, as no one knows what is really in "your kernel".
>

This is to update this thread that now I am able to successfully
bring-up dm-verity with NAND+ubiblock+squashfs on our 4.14 kernel
itself without backporting the patches.
Now, I am able to boot dm-verity using both initramfs and bootloader approach.
The initramfs booting issue was our internal issue which was related
to Kernel size configuration in UEFI.
The bootloader approach issue was related to system image size issue,
where we need to pass the exact image size to find the verity-metadata
offset at the end of system image.

However, I felt that dm-verity documentation still needs to be
enhanced further with a better example.
With the 5.4 Kernel, I may further explore the option of using
dm-mod.create option, then I might get more clarity on how best to use
it.

Thank you all for your help and support!

Regards,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

