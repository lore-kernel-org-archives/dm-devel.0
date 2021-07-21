Return-Path: <SRS0=Fc2L=MO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5923C63793
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jul 2021 07:22:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 479BB61279
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jul 2021 07:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 479BB61279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-ZgvXpI0sMaSbUQF9XmUVMQ-1; Thu, 22 Jul 2021 03:22:39 -0400
X-MC-Unique: ZgvXpI0sMaSbUQF9XmUVMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7335D804140;
	Thu, 22 Jul 2021 07:22:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32BA85D6D1;
	Thu, 22 Jul 2021 07:22:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B91761818481;
	Thu, 22 Jul 2021 07:22:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16LF101A009265 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Jul 2021 11:01:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6DA749E7A; Wed, 21 Jul 2021 15:01:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68F2C9E75
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 15:00:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9FC110AC3A7
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 15:00:56 +0000 (UTC)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
	[209.85.208.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-200-BKua0UEhPHifeTYa2cWh8A-1; Wed, 21 Jul 2021 11:00:52 -0400
X-MC-Unique: BKua0UEhPHifeTYa2cWh8A-1
Received: by mail-ed1-f53.google.com with SMTP id w14so2771541edc.8;
	Wed, 21 Jul 2021 08:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=3QH0L1galc4dXmyAjj6SONbiSv0qVq6f5DQ4NUtGEno=;
	b=IyNdHLzI6EZ+T+aJKgPlkhbfBJmAcHOT02FBcU0W9yJX/b5arLf6RG66in5IDLMWvo
	2zNV8TGygJKR+ix4WIQwhIsRQDHbQxUZTOnsa9PX9GMy8eLNV8B30M3aCeoWZ/AivMDt
	iDwFX3ICPQDX4BGnUwcsfd0xLA8AtCHBCojV/e4OPjVrVvuf/bu3s2VOgXPmLGCRkPi6
	RoiYNKgyFCbZEB1id5R5+RaOvSqK561E+mKXRrKfHbwnzWmn+rk+nA2C+3tVQnapB8LY
	cZaDJD3a/Y2HGRMKI54GbUGV6Fi7Zh6ao/hIrRuI6sZ+x16WLH/3eQt7sXvSDLPHzNNN
	72Ww==
X-Gm-Message-State: AOAM5314ihzkn3ga47DVYXDCobsmlufKR2PcjElkKngQ2wgACagTfxGa
	gUxxdDmSedIbiiJjM86vIlDCwYP/ux3KD424YypCKKBgtpo=
X-Google-Smtp-Source: ABdhPJwsdM7NhMOEPZ+TG7bCz9J7fuNtMI27TGWdC6n7lbhoBMHBK0YuVNjfgWVfOXR7v0uUr3SK5Qg0rxNOhwip2XI=
X-Received: by 2002:a05:6402:19a:: with SMTP id
	r26mr47901608edv.230.1626879650292; 
	Wed, 21 Jul 2021 08:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Wed, 21 Jul 2021 20:30:38 +0530
Message-ID: <CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
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
X-Mailman-Approved-At: Thu, 22 Jul 2021 03:22:29 -0400
Cc: snitzer@redhat.com, Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	linux-mtd <linux-mtd@lists.infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>, shli@kernel.org, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 20 Jul 2021 at 17:12, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Hi
>
> Try to set up dm-verity with block size 512 bytes.
>
> I don't know what block size does squashfs use, but if the filesystem
> block size is smaller than dm-verity block size, it doesn't work.
>
Okay thank you so much for this clue,
It seems we are using 65536 as the squashfs block size:
==> mksquashfs [...] - comp xz -Xdict-size 32K -noI -Xbcj arm -b 65536
-processors 1

But for dm-verity we are giving block size of 4096
==> [    0.000000] Kernel command line:[..] verity="96160 12020
d7b8a7d0c01b9aec888930841313a81603a50a2a7be44631c4c813197a50d681 0 "
rootfstype=squashfs root=/dev/mtdblock34 ubi.mtd=30,0,30 [...]
root=/dev/dm-0 dm="system none ro,0 96160 verity 1 /dev/mtdblock34
/dev/mtdblock39 4096 4096 12020 8 sha256
d7b8a7d0c01b9aec888930841313a81603a50a2a7be44631c4c813197a50d681
aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7"

Now, we are checking by giving squashfs block size also as 4096

In case, if this does not work, what else could be the other option ?
Can we try with initramfs approach ?

Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

