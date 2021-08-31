Return-Path: <SRS0=gIOA=NX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57F6C432BE
	for <dm-devel@archiver.kernel.org>; Wed,  1 Sep 2021 06:59:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7165761074
	for <dm-devel@archiver.kernel.org>; Wed,  1 Sep 2021 06:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7165761074
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461--Xu-MwQzNY2nUPUk1eSz_Q-1; Wed, 01 Sep 2021 02:59:12 -0400
X-MC-Unique: -Xu-MwQzNY2nUPUk1eSz_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB475801ADA;
	Wed,  1 Sep 2021 06:59:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A3B5DEB8;
	Wed,  1 Sep 2021 06:59:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08D431809C98;
	Wed,  1 Sep 2021 06:59:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17VDJtvK006939 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 31 Aug 2021 09:19:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 14279214180A; Tue, 31 Aug 2021 13:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C7A7200ACE1
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 13:19:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6C9418A01A5
	for <dm-devel@redhat.com>; Tue, 31 Aug 2021 13:19:48 +0000 (UTC)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
	[209.85.208.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-150-G2HL6E8VNwqkbw0EMeZo3Q-1; Tue, 31 Aug 2021 09:19:42 -0400
X-MC-Unique: G2HL6E8VNwqkbw0EMeZo3Q-1
Received: by mail-ed1-f48.google.com with SMTP id z19so26729403edi.9;
	Tue, 31 Aug 2021 06:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=sHPtKZe+G6zxzj4XJ8SxB02koJw5U2FZ5BVM7LmQV+E=;
	b=b+aF8C+gGguGUWUNOOjp54Oe6UiUdgcr4HoYPVJFFkSYii9HaLPiqFU9Dh7JV3dXPM
	nNG+kZn7QPT1KB528Y1yBFySd9eBEtz/oS+G6GEo4kYUwvS1YScUJNNA8esnF2pqtmPZ
	5OzMBzsoMGnm2/0i1kCGk+IOZX8mx2irC26akNMaSwV8Cr/ZByOUDy+jIqnhhFYOrUSu
	kB52bCqdl6Ou4/J4M84w7b/VvY8I2BEZCCuPK6GH4ICOEMyfaraAZ4qetNzKrq9pqOTW
	X7CdiPQ8R1bzE8fXVDiXKsZhQrYC073dsho9CY0tcQcq3mZj7hw444vElsoGaWhHeHzw
	4i4A==
X-Gm-Message-State: AOAM532msjz/KzurLuAJ0XVJdibkBRhLeEXMkCKmw6yMy6f453gPnn47
	M77b+j2jL70rn60ordVUm4zcFIbM1osLkkBLaMk=
X-Google-Smtp-Source: ABdhPJwT+pZxjrRI5pwhP4OcAeoy4nNGBgvF439fo+caHd7TPPXqp99zWOeMMGPaHPRArVb7drlTb+9fGGonvNasmbw=
X-Received: by 2002:a05:6402:5107:: with SMTP id
	m7mr29849642edd.63.1630415980838; 
	Tue, 31 Aug 2021 06:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
	<CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
	<20210830185541.715f6a39@windsurf>
	<CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
	<20210830211224.76391708@windsurf>
In-Reply-To: <20210830211224.76391708@windsurf>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Tue, 31 Aug 2021 18:49:28 +0530
Message-ID: <CAOuPNLgMd0AThhmSknbmKqp3_P8PFhBGr-jW0Mqjb6K6NchEMg@mail.gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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
X-Mailman-Approved-At: Wed, 01 Sep 2021 02:57:42 -0400
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Tue, 31 Aug 2021 at 00:42, Thomas Petazzoni
<thomas.petazzoni@bootlin.com> wrote:
>
> Hello,
>
> On Mon, 30 Aug 2021 23:48:40 +0530
> Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> > ohh that means we already have a working reference.
> > If possible can you share the details, even 4.19 or higher will be
> > also a good reference.
> >
> > > > Or, another option is to use the new concept from 5.1 kernel that is:
> > > > dm-mod.create = ?
> > > How are you doing it today without dm-mod.create ?
> > I think in 4.14 we don't have dm-mod.create right ?
>
> No, but you can backport it easily. Back at
> http://lists.infradead.org/pipermail/openwrt-devel/2019-November/025967.html
> I provided backports of this feature to OpenWrt, for the 4.14 and 4.19
> kernels.
>
Yes, I can backport it to our 4.14 Kernel.
Can you share the list of patches to be backported to make it work on 4.14 ?
If it's backported also I need to report to our internal kernel, but
it might be slightly easier.
Please share the details.

> > Here is our kernel command line:
> >
> > [    0.000000] Kernel command line: ro rootwait
> > console=ttyMSM0,115200,n8 ....  verity="95384 11923
> > 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3 12026
> > " rootfstype=squashfs ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/dm-0
> > .... init=/sbin/init root=/dev/dm-0 dm="rootfs none ro,0 95384 verity
> > 1 /dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
> > 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
> > aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
> > restart_on_corruption ignore_zero_blocks use_fec_from_device
> > /dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026" ...
>
> I don't see how this can work without the dm-mod.create feature. Are
> you sure the verity= and dm= kernel arguments exist?

Sorry, I am not a security guy and this was done by someone from the
security team.
But, I know that this is already working with ext4.
The moment we change to squashfs, it does not work.

The only difference with squashfs are:
=> verity metadata are kept on separate volume
=> The rootfstype and related stuff are different
=> verity command line related stuff are almost the same.

Also, you mentioned:
>>> Here, it definitely worked to append the hash tree to the squashfs
>>> image and store them in the same partition.
Can you share some details about it ?
How it can be done since squashfs is readonly.
Do, we need to change some parameters during squashfs image generation ?
{
  $(STAGING_DIR_HOST)/bin/mksquashfs4 $(call mkfs_target_dir,$(1)) $@ \
- -nopad -noappend -root-owned \
+ -noappend -root-owned \
}

Also, for the above cmdline, is there any problem with the block size ?
As @Mikulas said before that the block size could be the issue

Also, for squashfs we are passing like this for root=. Is it fine ?
rootfstype=squashfs ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/dm-0

I see that dm-0 is already passed elsewhere so do we really need it ?
I suspect it is not required as a block device.


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

