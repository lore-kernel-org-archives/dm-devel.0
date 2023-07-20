Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA4EEB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689875936;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IMG0Zo6QMMLvXiXhoadK7+jK5beyMvu0Vo5KIwuyTlo=;
	b=ZlgcvGYaDEwPfz068KUG1ZgagV3G5no1Ix1tv9Al37jrQQUB7g5StbvdD0eHJhgjHMKgLR
	mxiQsr3v8yFtjTIT0DLzLahlAiOBxrgBgPgfAROTp89w63DlzycqeEbedQ3rzQNBTNHKIY
	DIKW3wzDdnjuqCJ//oP9gK8XvHPp+O4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-7FGAdvIiO1GbaGIErFYT7g-1; Thu, 20 Jul 2023 13:58:53 -0400
X-MC-Unique: 7FGAdvIiO1GbaGIErFYT7g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 451571C05EB0;
	Thu, 20 Jul 2023 17:58:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D822492C13;
	Thu, 20 Jul 2023 17:58:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE59319465BD;
	Thu, 20 Jul 2023 17:58:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6EFE819465BA
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 17:58:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBD9740C2072; Thu, 20 Jul 2023 17:57:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E450740C206F
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 17:57:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C480E858F1E
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 17:57:59 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-yYL2aoVAPuGj0a_BBsSw2w-1; Thu, 20 Jul 2023 13:57:57 -0400
X-MC-Unique: yYL2aoVAPuGj0a_BBsSw2w-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3A85361B9C;
 Thu, 20 Jul 2023 17:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2150BC433C8;
 Thu, 20 Jul 2023 17:57:55 +0000 (UTC)
Date: Thu, 20 Jul 2023 19:57:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Message-ID: <2023072033-hedge-buffing-8862@gregkh>
References: <CAH6w=aztzhm3Sa-afN2Xk-7mp1BVtTKNXJ=JyXqJvm3wtEnd3Q@mail.gmail.com>
 <20230717015728.12641-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
In-Reply-To: <20230717015728.12641-1-mark-pk.tsai@mediatek.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 5.15] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: peter@korsgaard.com, snitzer@redhat.com, linux-doc@vger.kernel.org,
 yj.chiang@mediatek.com, corbet@lwn.net, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 linux-mediatek@lists.infradead.org, agk@redhat.com, matthias.bgg@gmail.com,
 linux-arm-kernel@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linuxfoundation.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 17, 2023 at 09:57:28AM +0800, Mark-PK Tsai wrote:
> > On Sun, Jul 16, 2023, 11:16 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Thu, Jul 13, 2023 at 01:58:37PM +0800, Mark-PK Tsai wrote:
> > > > From: Peter Korsgaard <peter@korsgaard.com>
> > > > 
> > > > Just calling wait_for_device_probe() is not enough to ensure that
> > > > asynchronously probed block devices are available (E.G. mmc, usb), so
> > > > add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get
> > > > dm-init to explicitly wait for specific block devices before
> > > > initializing the tables with logic similar to the rootwait logic that
> > > > was introduced with commit  cc1ed7542c8c ("init: wait for
> > > > asynchronously scanned block devices").
> > > > 
> > > > E.G. with dm-verity on mmc using:
> > > > dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"
> > > > 
> > > > [    0.671671] device-mapper: init: waiting for all devices to be 
> > > available before creating mapped devices
> > > > [    0.671679] device-mapper: init: waiting for device PARTLABEL=hash-a 
> > > ...
> > > > [    0.710695] mmc0: new HS200 MMC card at address 0001
> > > > [    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
> > > > [    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
> > > > [    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
> > > > [    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, 
> > > chardev (249:0)
> > > > [    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
> > > > [    0.751282] device-mapper: init: waiting for device PARTLABEL=root-a 
> > > ...
> > > > [    0.751306] device-mapper: init: all devices available
> > > > [    0.751683] device-mapper: verity: sha256 using implementation 
> > > "sha256-generic"
> > > > [    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
> > > > [    0.766540] VFS: Mounted root (squashfs filesystem) readonly on 
> > > device 254:0.
> > > > 
> > > > Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
> > > > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> > > > ---
> > > >  .../admin-guide/device-mapper/dm-init.rst     |  8 +++++++
> > > >  drivers/md/dm-init.c                          | 22 ++++++++++++++++++-
> > > >  2 files changed, 29 insertions(+), 1 deletion(-)
> > >
> > > What is the git commit id of this change in Linus's tree?
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > >
> > 
> > Hey Greg,
> > 
> > This change shouldn't be backported to stable@. It is a feature, if
> > Mark-PK feels they need it older kernels they need to carry the change
> > in their own tree. Or at a minimum they need to explain why this
> > change is warranted in stable@.
> 
> Thanks for your comment.
> The reason why we think this should be backported to stable kernel is
> that it actually fix the potential race condition when make block
> device probe async in stable kernel.
> And we'd like to fix this upstream rather than just take it in
> our custom tree.

Potential race condition, is this actually able to be hit in real life?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

