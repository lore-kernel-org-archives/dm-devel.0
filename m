Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8053BEB64DD
	for <dm-devel@archiver.kernel.org>; Sun, 16 Jul 2023 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689521108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OL9UdoDQpoxlAyvv6+n9Hg2nnMzMl5xH1JcJgu7zEg4=;
	b=eMNVMcUh3Czvnp5bMqWcAvfsid3j0iRXiCDzOZo+x0J0zTzgaSieDCaP5C8IY1lU2Cnbv8
	NahVosuaFiTkS0mWx4jLKUDn79lbA3+y42GoB8xNbJPKA28S4vyfCHa6hbaX1aJioTyEH+
	qY8eECfqEWGJAfo+M3fFGYK3O1zzDr4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-QHl8b9mpP8Ol1Tan4xvy4A-1; Sun, 16 Jul 2023 11:25:05 -0400
X-MC-Unique: QHl8b9mpP8Ol1Tan4xvy4A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FEA2856F66;
	Sun, 16 Jul 2023 15:25:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C0BB7492B03;
	Sun, 16 Jul 2023 15:24:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F982194658C;
	Sun, 16 Jul 2023 15:24:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F03EF1946588
 for <dm-devel@listman.corp.redhat.com>; Sun, 16 Jul 2023 15:24:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD950111F3C1; Sun, 16 Jul 2023 15:24:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5E97111F3BB
 for <dm-devel@redhat.com>; Sun, 16 Jul 2023 15:24:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96ADB8D168D
 for <dm-devel@redhat.com>; Sun, 16 Jul 2023 15:24:56 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-bliRhVrINdaFMGiSyoBDnA-1; Sun, 16 Jul 2023 11:24:55 -0400
X-MC-Unique: bliRhVrINdaFMGiSyoBDnA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8499160D32;
 Sun, 16 Jul 2023 15:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65317C433C8;
 Sun, 16 Jul 2023 15:16:23 +0000 (UTC)
Date: Sun, 16 Jul 2023 17:16:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Message-ID: <2023071603-lustily-defraud-2149@gregkh>
References: <20230713055841.24815-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
In-Reply-To: <20230713055841.24815-1-mark-pk.tsai@mediatek.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Cc: Peter Korsgaard <peter@korsgaard.com>, Mike Snitzer <snitzer@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, yj.chiang@mediatek.com,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Matthias Brugger <matthias.bgg@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linuxfoundation.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 13, 2023 at 01:58:37PM +0800, Mark-PK Tsai wrote:
> From: Peter Korsgaard <peter@korsgaard.com>
> 
> Just calling wait_for_device_probe() is not enough to ensure that
> asynchronously probed block devices are available (E.G. mmc, usb), so
> add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get
> dm-init to explicitly wait for specific block devices before
> initializing the tables with logic similar to the rootwait logic that
> was introduced with commit  cc1ed7542c8c ("init: wait for
> asynchronously scanned block devices").
> 
> E.G. with dm-verity on mmc using:
> dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"
> 
> [    0.671671] device-mapper: init: waiting for all devices to be available before creating mapped devices
> [    0.671679] device-mapper: init: waiting for device PARTLABEL=hash-a ...
> [    0.710695] mmc0: new HS200 MMC card at address 0001
> [    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
> [    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
> [    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
> [    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, chardev (249:0)
> [    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
> [    0.751282] device-mapper: init: waiting for device PARTLABEL=root-a ...
> [    0.751306] device-mapper: init: all devices available
> [    0.751683] device-mapper: verity: sha256 using implementation "sha256-generic"
> [    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
> [    0.766540] VFS: Mounted root (squashfs filesystem) readonly on device 254:0.
> 
> Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> ---
>  .../admin-guide/device-mapper/dm-init.rst     |  8 +++++++
>  drivers/md/dm-init.c                          | 22 ++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)

What is the git commit id of this change in Linus's tree?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

