Return-Path: <SRS0=ugf6=NW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA38C432BE
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:25:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 03B1D6101C
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:25:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 03B1D6101C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-mb09qEWiPd66LqO-O2Vdgw-1; Tue, 31 Aug 2021 03:25:34 -0400
X-MC-Unique: mb09qEWiPd66LqO-O2Vdgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4541E1008062;
	Tue, 31 Aug 2021 07:25:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2E3C1899A;
	Tue, 31 Aug 2021 07:25:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3EC9181A0F2;
	Tue, 31 Aug 2021 07:25:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17UGPdPl014978 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 12:25:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8EDB6202F343; Mon, 30 Aug 2021 16:25:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A840202F342
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:25:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3429811E76
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 16:25:36 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
	[209.85.208.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-169-GoAAi1W3Nr-arh0PzbcvUw-1; Mon, 30 Aug 2021 12:25:32 -0400
X-MC-Unique: GoAAi1W3Nr-arh0PzbcvUw-1
Received: by mail-ed1-f41.google.com with SMTP id s25so22587116edw.0;
	Mon, 30 Aug 2021 09:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=nM2mQX3CjHoVvQzXA9QRVqQGDAbVu2Bb047tmbqXsXo=;
	b=m7CgTBSx+zP4+wH4ujoq60GH9FQN+pRVHpoVA6NOmt6DO76z6YbTPH5qc55bpRd9r5
	1IdUOxIq5jFr5k0YLX0wtUaRuXkceNr0hvg0sjMhoJvUfP4NhvD+wymIJoAkr8x8Ie6Q
	TtWCz4Qq9aX110nm/78Cnlpy1R49wN9oT8mcsZqOh7KJrYc3jr109JUdeOzh67t2UeAO
	nfg/OctnIzOGiXXW3IvAy07jXe7It18CGb/P14xqbzfYIiHQ8xxmz3mVc2JtzuGlYTb/
	5eoS3jLmQKwYn2jRku6mEMd24cBVo45dWsMOj4lzOlG+xmt6El2oqAts998otj4Miqge
	qrhg==
X-Gm-Message-State: AOAM533MDlW5+97GvIEodebvSQ8m7gTB7sjep0e/KZoBUX7rynDaicgC
	ffRRKSORnIfTtRwEqc2lC4yEaDXxvy7p/+DqRRlqxvFANtSW7M16
X-Google-Smtp-Source: ABdhPJxFVwH5a9vwpgHr69uleyHJFXry4tEBhgWEqP3jLJ2yNeNcN8OYKvlGgPaWD3RXyoBlU+G/vqMKDepmDLjCHqM=
X-Received: by 2002:a05:6402:2050:: with SMTP id
	bc16mr5209767edb.92.1630340730956; 
	Mon, 30 Aug 2021 09:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
In-Reply-To: <CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Mon, 30 Aug 2021 21:55:19 +0530
Message-ID: <CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
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
Cc: thomas.petazzoni@bootlin.com, snitzer@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	linux-mtd <linux-mtd@lists.infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 21 Jul 2021 at 22:59, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> On Wed, 21 Jul 2021 at 22:40, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> > > >
> > > > Try to set up dm-verity with block size 512 bytes.
> > > >
> > > > I don't know what block size does squashfs use, but if the filesystem
> > > > block size is smaller than dm-verity block size, it doesn't work.
> > > >
> > > Okay thank you so much for this clue,
> > > It seems we are using 65536 as the squashfs block size:
> >
> > 65536 is the compression block size - it is unrelated to I/O block size.
> >
> > There's a config option SQUASHFS_4K_DEVBLK_SIZE. The documentation says
> > that it uses by default 1K block size and if you enable this option, it
> > uses 4K block size.
> >
> Okay it seems this config is set in our case:
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> So, with this the squashfs and dm-verity block size exactly matches (4K)
>
> > So, try to set it. Or try to reduce dm-verity block size down to 1K.
> >
Hi,

Sorry for coming back to this again..
Unfortunately, none of the options is working for us with squashfs
(bootloader, initramfs).
initramfs have different kinds of challenges because of the partition
size issue.
So, our preferred option is still the bootloader command line approach..

Is there a proven and working solution of dm-verity with squashfs ?
If yes, please share some references.

The current problem with squashfs is that we could not append the
verity-metadata to squashfs, so we store it on a separate volume and
access it.
By specifying it like : /dev/mtdblock53

Then we get the error like this:
{
[    4.950276] device-mapper: init: attempting early device configuration.
[    4.957577] device-mapper: init: adding target '0 95384 verity 1
/dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
restart_on_corruption ignore_zero_blocks use_fec_from_device
/dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026'
[    4.975283] device-mapper: verity: sha256 using implementation
"sha256-generic"
[    4.998728] device-mapper: init: dm-0 is ready

[    5.614498] 1f35            1736 mtdblock53
[    5.614502]  (driver?)
[    5.621098] fc00           61504 ubiblock0_0
[    5.621102]  (driver?)
[    5.627661] fd00           47692 dm-0
[    5.627665]  (driver?)
[    5.633663] No filesystem could mount root, tried:
[    5.633667]  squashfs
[    5.636009]
[    5.643215] Kernel panic - not syncing: VFS: Unable to mount root
fs on unknown-block(253,0)
}

Do you see any other problem here with dm-verity cmdline or with squashfs ?

Is squashfs ever proved to be working with dm-verity on higher kernel version ?
Currently our kernel version is 4.14.

Or, another option is to use the new concept from 5.1 kernel that is:
dm-mod.create = ?
But, currently I don't know how to use it with squashfs either...
Any reference example will be helpful..

Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

