Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58230C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E92C861BFD
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 06:54:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E92C861BFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-qJ0rJ7gqMnWP6ReHhpJ9PA-1; Mon, 15 Nov 2021 01:54:40 -0500
X-MC-Unique: qJ0rJ7gqMnWP6ReHhpJ9PA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 590A4824F87;
	Mon, 15 Nov 2021 06:54:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E82060C04;
	Mon, 15 Nov 2021 06:54:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3CC0D181A1D1;
	Mon, 15 Nov 2021 06:54:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AC7J9JI004099 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 02:19:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8BF3A404727C; Fri, 12 Nov 2021 07:19:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8824A4047279
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:19:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F0BD106655A
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 07:19:09 +0000 (UTC)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
	[209.85.208.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-587-daZHGl2hMoCv7-YHoSkEZQ-1; Fri, 12 Nov 2021 02:19:07 -0500
X-MC-Unique: daZHGl2hMoCv7-YHoSkEZQ-1
Received: by mail-ed1-f46.google.com with SMTP id f4so33957622edx.12;
	Thu, 11 Nov 2021 23:19:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=23MuWJBgLsmpo3DWwY1zc1kp+jWhxY7Ijuwd9E4NgEk=;
	b=LWH9EXDwCBL4Tk1g+jUSaqq6dnGaizb+oxmDF6VT382fchWJWXskmhD1vtW7Pb9qRm
	ziyl425JOoI4MSfKzeaiup/MGBeSPj/EDPHZ2GA0GOkcvDrW3P3g2xfLkNdDJ50GZ6lj
	74vMANYiB+Ai7h98MHGRrfCK0y3FwyUqVvaAW3VCpIdeOZY91wB/2xdXJCEEF6NPaWKv
	/m5wz4LlclBucqn47jDrk6iUGwi5KJXgBi97B0YOda3C5fqZkV/IrGd6mf5OVCS5CbZF
	SCvs4XBKpRDGeG5BFYeQto7cMhvefqk5RmDuWjlSkrPWQYdX3R7rn8p3zV3rTlDD16iv
	eCBA==
X-Gm-Message-State: AOAM532FU8enYsbNXZxJJHrdps9SDlIMmTWLt/X79UQZad+rm8e/72Ev
	rNnHDLgPIUfKcbop/He4rjbcEkUKGjCrD5GnOS0=
X-Google-Smtp-Source: ABdhPJx13NMWj+ghQdIXzWAZXD21zp7HK2PPcgzpsVoQ5oiXGPhrERb6kk1sCFUWYPnyLmUI/dMVXMZ3WHQjPvatP2I=
X-Received: by 2002:a17:906:fca3:: with SMTP id
	qw3mr17312375ejb.285.1636701546085; 
	Thu, 11 Nov 2021 23:19:06 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
	<CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
	<CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
In-Reply-To: <CAOuPNLjFtS7ftg=+-K3S+0ndyNYmUNqXo7SHkyV4zK4G9bZ4Og@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Fri, 12 Nov 2021 12:48:55 +0530
Message-ID: <CAOuPNLg_YwyhK6iPZZbRWe57Kkr1d8LjJaDniCvvOqk4t2-Sog@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, drosen@google.com,
	astrachan@google.com, speed.eom@samsung.com,
	Sami Tolvanen <samitolvanen@google.com>, snitzer@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, 9 Nov 2021 at 21:04, Pintu Agarwal <pintu.ping@gmail.com> wrote:

> > > We only get these squashfs errors flooded in the boot logs:
> > > {{{
> > > ....
> > > [    5.153479] device-mapper: init: dm-0 is ready
> > > [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
> > > ....
> > > [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
> > > [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> > > [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
> > > [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
> > > [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
> > > [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
> > > [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
> > > ....
> > > }}}
> > >

One more observation:
When I disable FEC flag in bootloader, I see the below error:
[    8.360791] device-mapper: verity: 253:0: data block 2 is corrupted
[    8.361134] device-mapper: verity: 253:0: data block 3 is corrupted
[    8.366016] SQUASHFS error: squashfs_read_data failed to read block 0x1106
[    8.379652] SQUASHFS error: Unable to read data cache entry [1106]
[    8.379680] SQUASHFS error: Unable to read page, block 1106, size 7770

Also, now I see that the decompress error is gone, but the read error
is still there.

This seems to me that dm-verity detects some corrupted blocks but with
FEC it auto corrects itself, how when dm-verity auto corrects itself,
the squashfs decompression algorithm somehow could not understand it.

So, it seems like there is some mis-match between the way FEC
correction and the squashfs decompression happens ?

Is this issue seen by anybody else here ?


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

