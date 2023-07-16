Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A420C001DC
	for <dm-devel@archiver.kernel.org>; Sun, 16 Jul 2023 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689521810;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EpAeOLZhbKoN2RzULvrm0CIiNPVPcdoJlRIg9fphJoU=;
	b=SJy8rVw9Jo/BN11I+WnnyZEUHOpaMraQMBAi/ABn3+5kC5BSRLczQiA4oh/nOSNOnt12LO
	S7n3FASwXaS+RssIrca2OckRQ94/zslZ65spigKR5Fym3QdopDCZk+35qO9qnULJrmaxkK
	4NV6CMgU2Z2zg5BgicWro2Zy/M+ue3M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-L2sxRt3MOdqOH_IsVFIsDg-1; Sun, 16 Jul 2023 11:36:47 -0400
X-MC-Unique: L2sxRt3MOdqOH_IsVFIsDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CE52857FD3;
	Sun, 16 Jul 2023 15:36:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E19AF6CCA;
	Sun, 16 Jul 2023 15:36:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEE5E194658F;
	Sun, 16 Jul 2023 15:36:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2320E194658C
 for <dm-devel@listman.corp.redhat.com>; Sun, 16 Jul 2023 15:36:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 014ECF6CC7; Sun, 16 Jul 2023 15:36:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ED5007D552
 for <dm-devel@redhat.com>; Sun, 16 Jul 2023 15:36:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE05B185A795
 for <dm-devel@redhat.com>; Sun, 16 Jul 2023 15:36:42 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-LSfzHwitOhWOvCZTxVwvQw-1; Sun, 16 Jul 2023 11:36:39 -0400
X-MC-Unique: LSfzHwitOhWOvCZTxVwvQw-1
Received: by mail-qk1-f197.google.com with SMTP id
 af79cd13be357-7679e5ebad2so561707185a.3
 for <dm-devel@redhat.com>; Sun, 16 Jul 2023 08:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689521798; x=1692113798;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=SjKpqR/un+xqnmH4u/xs4cWkynkrba3RxsIKpUmzl5A=;
 b=RsdkE2P58JRH/JAddA4N26iyByX5BrM2L9inxQVHZR4Knmr+0w2ThZuVvNksA9TW3S
 Q6f6fHC5RGb3nNYlYaRmBax2SMvlntjL7N5vmxLeMpexO487kp6MpWg7paHQHcoXZtBt
 YbDNnAIdX9+oQN01L0AvNbFrU/NXCS8Bnq3dOvsyL9KfCa5Uisf+lK9c4rPkw9zxKZLB
 3y1nO/w5OgONXWzsrIGkBFbHPjf8/nJovYEKqRJE2lqzeoM7LJwfWXXWbLj6BlHW6LLx
 Y18jv8lRmMbecrqpAh8/nOuLz/i+N5FT0jg+Y/aIny9lMqdWvX1kunzAxw8LOHI0JFnX
 wo5g==
X-Gm-Message-State: ABy/qLYIjL+RrDtV/K8/EfWy/k6SOtlR8U/E4Ld+doYr6hxi7NVVWhqB
 5F5AF7ghHsJ+3ArdYOXByjTwGCRFj9Zz2uD9gMWvfUzuYjh9PsFcjaoVTXVrRKL7RvL/hi7A/T6
 TIZ7zJDntusEQERakEggAjg==
X-Received: by 2002:a05:620a:e1b:b0:767:f130:8f8a with SMTP id
 y27-20020a05620a0e1b00b00767f1308f8amr11678572qkm.49.1689521798779; 
 Sun, 16 Jul 2023 08:36:38 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGf+9RMl8b0IZ7BAM8vVkiIbftoUFL/qQ02Lwshk7jN2Z9DSLREpZmbP00aTzB4D/vKmJjFrA==
X-Received: by 2002:a05:620a:e1b:b0:767:f130:8f8a with SMTP id
 y27-20020a05620a0e1b00b00767f1308f8amr11678558qkm.49.1689521798519; 
 Sun, 16 Jul 2023 08:36:38 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 g7-20020ae9e107000000b0075cd80fde9esm5405203qkm.89.2023.07.16.08.36.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 16 Jul 2023 08:36:37 -0700 (PDT)
Date: Sun, 16 Jul 2023 11:36:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <CAH6w=aztzhm3Sa-afN2Xk-7mp1BVtTKNXJ=JyXqJvm3wtEnd3Q@mail.gmail.com>
References: <20230713055841.24815-1-mark-pk.tsai@mediatek.com>
 <2023071603-lustily-defraud-2149@gregkh>
MIME-Version: 1.0
In-Reply-To: <2023071603-lustily-defraud-2149@gregkh>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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
Cc: linux-arm-kernel@lists.infradead.org, Peter Korsgaard <peter@korsgaard.com>,
 Jonathan Corbet <corbet@lwn.net>, yj.chiang@mediatek.com,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org, "development, device-mapper" <dm-devel@redhat.com>,
 linux-mediatek@lists.infradead.org, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 16, 2023, 11:16 AM Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Jul 13, 2023 at 01:58:37PM +0800, Mark-PK Tsai wrote:
> > From: Peter Korsgaard <peter@korsgaard.com>
> > 
> > Just calling wait_for_device_probe() is not enough to ensure that
> > asynchronously probed block devices are available (E.G. mmc, usb), so
> > add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get
> > dm-init to explicitly wait for specific block devices before
> > initializing the tables with logic similar to the rootwait logic that
> > was introduced with commit  cc1ed7542c8c ("init: wait for
> > asynchronously scanned block devices").
> > 
> > E.G. with dm-verity on mmc using:
> > dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"
> > 
> > [    0.671671] device-mapper: init: waiting for all devices to be 
> available before creating mapped devices
> > [    0.671679] device-mapper: init: waiting for device PARTLABEL=hash-a 
> ...
> > [    0.710695] mmc0: new HS200 MMC card at address 0001
> > [    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
> > [    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
> > [    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
> > [    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, 
> chardev (249:0)
> > [    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
> > [    0.751282] device-mapper: init: waiting for device PARTLABEL=root-a 
> ...
> > [    0.751306] device-mapper: init: all devices available
> > [    0.751683] device-mapper: verity: sha256 using implementation 
> "sha256-generic"
> > [    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
> > [    0.766540] VFS: Mounted root (squashfs filesystem) readonly on 
> device 254:0.
> > 
> > Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> > ---
> >  .../admin-guide/device-mapper/dm-init.rst     |  8 +++++++
> >  drivers/md/dm-init.c                          | 22 ++++++++++++++++++-
> >  2 files changed, 29 insertions(+), 1 deletion(-)
>
> What is the git commit id of this change in Linus's tree?
>
> thanks,
>
> greg k-h
>
>

Hey Greg,

This change shouldn't be backported to stable@. It is a feature, if
Mark-PK feels they need it older kernels they need to carry the change
in their own tree. Or at a minimum they need to explain why this
change is warranted in stable@.

But to answer your original question the upstream commit is:

035641b01e72 dm init: add dm-mod.waitfor to wait for asynchronously probed block devices

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

