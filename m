Return-Path: <SRS0=QKrD=P5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03161C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 07:37:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C51B60E98
	for <dm-devel@archiver.kernel.org>; Wed, 10 Nov 2021 07:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8C51B60E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-Eg_6BN-VM7-tMgfV7UeYlA-1; Wed, 10 Nov 2021 02:37:28 -0500
X-MC-Unique: Eg_6BN-VM7-tMgfV7UeYlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EEBE15720;
	Wed, 10 Nov 2021 07:37:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9016762A44;
	Wed, 10 Nov 2021 07:37:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0131C4E58F;
	Wed, 10 Nov 2021 07:37:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A9BGC1K029305 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 06:16:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07297112131B; Tue,  9 Nov 2021 11:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 022E71121318
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 11:16:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 139FF811E78
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 11:16:09 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
	[209.85.208.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-292-gKs2behMOqaDhkqlwnceKg-1; Tue, 09 Nov 2021 06:16:07 -0500
X-MC-Unique: gKs2behMOqaDhkqlwnceKg-1
Received: by mail-ed1-f50.google.com with SMTP id v11so72798962edc.9;
	Tue, 09 Nov 2021 03:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to;
	bh=rVsY0bOoMyeQFsYvQfJLYPtYkclxmkriKyxzCkOTXMg=;
	b=R7XEA6Z3G1l1T2LvVGTdXDYFo7jy/O74kC5RPu8DOhDlKrxWwdsL8m/z+mFAMhScAn
	asLPDsvcE0AgFXld9fppEzdf1kzr1HZdgxBYF8MR0UEG3eGyx7juHIiB2GQpjCYfZZ5F
	J70jacQtIsJNQxH2qgt2HoZ93+fWRMIINTd4f8/qklOBI/WCRuSpr2/uYYEC2gh9Bb2A
	j3EEiQOcM9PnI4DqnDEZm3PdmD+glUqenhqvIW+jTfBnnyKEQPe0izOVekgz3EjUilr2
	0FbFl8AgsOyrdsfW3yw2N4FvuUyMhvQDqY/Lfr2H/T0WinJZ+JlbkHXmGCnF+rLkqc1J
	HTCA==
X-Gm-Message-State: AOAM530GbSwRqhozaSx6BjSPFwNF2CefFVgyAc46JJAUIMbPuTdUUwra
	05HyWLpZk621AT2rWRZ7NcSW7Xca2imjSeLeynM=
X-Google-Smtp-Source: ABdhPJzQ1KrAe4zoA1w0iikZNSeX4IFNasgdzFgtAvBS7Sxn2unVRfdx+qvtVYnyIBY69xv5eswfCYx/TYLXEzzlvIk=
X-Received: by 2002:a17:906:2ad2:: with SMTP id
	m18mr8841239eje.64.1636456565939; 
	Tue, 09 Nov 2021 03:16:05 -0800 (PST)
MIME-Version: 1.0
References: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
In-Reply-To: <CAOuPNLinoW5Cx=xbUcT-DB4RiQkAPpe=9hsc-Rkch0LxD0mh+Q@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Tue, 9 Nov 2021 16:45:54 +0530
Message-ID: <CAOuPNLgquwOJg85kDcf67+4kTYP9N=45FvV+VDTJr6txYi5-wg@mail.gmail.com>
To: open list <linux-kernel@vger.kernel.org>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Mikulas Patocka <mpatocka@redhat.com>, Richard Weinberger <richard@nod.at>,
	Florian Fainelli <f.fainelli@gmail.com>, sumit.semwal@linaro.org,
	adriens@google.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Mon, 8 Nov 2021 at 20:00, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> Hi,
> Here are few details.
> * Linux Kernel: 4.14
> * Processor: Qualcomm Arm32 Cortex-A7
> * Storage: NAND 512MB
> * Platform: Simple busybox
> * Filesystem: UBIFS, Squashfs
> * Build system: Linux Ubuntu 18.04 with Yocto build system
> * Consists of nand raw partitions, squashfs ubi volumes.
>
> What we are trying to do:
> We are trying to boot dm-verity enabled rootfs on our system.
> The images for rootfs were generated on Ubuntu 18.04 machine using
> Yocto build system.
>
> Issue:
> Earlier, when we were using Ubuntu 16.04 to generate our images, the
> system was booting fine even with dm-verity enabled.
> Recently we switched to Ubuntu 18.04 build machine, and now with the
> same changes we are seeing the below squashfs error, just after the
> mount.
> Note: with 18.04 also our rootfs is mounting successfully and
> dm-verity is also working fine.
> We only get these squashfs errors flooded in the boot logs:
> {{{
> ....
> [    5.153479] device-mapper: init: dm-0 is ready
> [    5.334282] VFS: Mounted root (squashfs filesystem) readonly on device 253:0.
> ....
> [    8.954120] SQUASHFS error: xz decompression failed, data probably corrupt
> [    8.954153] SQUASHFS error: squashfs_read_data failed to read block 0x1106
> [    8.970316] SQUASHFS error: Unable to read data cache entry [1106]
> [    8.970349] SQUASHFS error: Unable to read page, block 1106, size 776c
> [    8.980298] SQUASHFS error: Unable to read data cache entry [1106]
> [    8.981911] SQUASHFS error: Unable to read page, block 1106, size 776c
> [    8.988280] SQUASHFS error: Unable to read data cache entry [1106]
> ....
> }}}
>
Just one question:
Is there any history about these squashfs errors while cross-compiling
images on Ubuntu 18.04 or higher ?


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

