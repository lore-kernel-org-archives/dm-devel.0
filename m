Return-Path: <SRS0=Fc2L=MO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64E3C63793
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jul 2021 07:23:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3B2B16127C
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jul 2021 07:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B2B16127C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-tbuFKtuNPe2Mgf3r8eOaFA-1; Thu, 22 Jul 2021 03:22:55 -0400
X-MC-Unique: tbuFKtuNPe2Mgf3r8eOaFA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49DD310060E8;
	Thu, 22 Jul 2021 07:22:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2980E1970E;
	Thu, 22 Jul 2021 07:22:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7774E4BB7C;
	Thu, 22 Jul 2021 07:22:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16LHTsa1001102 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Jul 2021 13:29:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 44A3320285AD; Wed, 21 Jul 2021 17:29:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40B7D200E57A
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 17:29:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F810801E80
	for <dm-devel@redhat.com>; Wed, 21 Jul 2021 17:29:51 +0000 (UTC)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com
	[209.85.218.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-283-XpeqFg6UOt21_pPXGr2mXQ-1; Wed, 21 Jul 2021 13:29:47 -0400
X-MC-Unique: XpeqFg6UOt21_pPXGr2mXQ-1
Received: by mail-ej1-f42.google.com with SMTP id hr1so4437630ejc.1;
	Wed, 21 Jul 2021 10:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=XP0iAPTzXCS6/hXN5afn3pCSvhDsfbRfFxq+vdKUGU8=;
	b=imBVW65Yeo8PpQiDp7qo3H5Xd7piZ7BAVFdQA22nUlkOC9HN+Bx3O1aeLF7hkl9rm2
	aqZdTyFtLq1kfIdUpvjXRivnFPAtPlP3RfFFCFEO75rOILISYS+XtfAgZb+kT4/yQUc1
	H7UcG/sd8vFceOkUMEfjA5q4kNAU8cVhbENHFHZpfswkVc6XMWzcndDu6EbPuyAKQG9Q
	/9QGJ0k/NGJOzzUGeqkFEVl4AWgHeNUKr1cecYzzlqvoZvd9KOpZs1Fc0+F5KFdAY993
	KSMhX96wl/zzPwj9arpruonmdEoyfBU/wzAQmh2z7Ofzi5MTg5gnImwU2Fjr7jmzqIb4
	ipbg==
X-Gm-Message-State: AOAM531PBOm36f+AgXJ6cZSxLidEp7kHlNn8FG4XvBbcIXO9n3wIBTFl
	fOd9C4GUieS/tIY1d7g86SNmvO3ajF6h/oMKfswvoamWshq3EA==
X-Google-Smtp-Source: ABdhPJxVd/rBQsk/2obbH5UlqtV4a0WbF0Li9IC6O9OpXl6Zt+WB0yfa2RTbxjYDls2VAOQ7rBIZWAci0SlwjWWDCjc=
X-Received: by 2002:a17:907:2125:: with SMTP id
	qo5mr39615957ejb.252.1626888585194; 
	Wed, 21 Jul 2021 10:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Wed, 21 Jul 2021 22:59:33 +0530
Message-ID: <CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 21 Jul 2021 at 22:40, Mikulas Patocka <mpatocka@redhat.com> wrote:

> > >
> > > Try to set up dm-verity with block size 512 bytes.
> > >
> > > I don't know what block size does squashfs use, but if the filesystem
> > > block size is smaller than dm-verity block size, it doesn't work.
> > >
> > Okay thank you so much for this clue,
> > It seems we are using 65536 as the squashfs block size:
>
> 65536 is the compression block size - it is unrelated to I/O block size.
>
> There's a config option SQUASHFS_4K_DEVBLK_SIZE. The documentation says
> that it uses by default 1K block size and if you enable this option, it
> uses 4K block size.
>
Okay it seems this config is set in our case:
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
So, with this the squashfs and dm-verity block size exactly matches (4K)

> So, try to set it. Or try to reduce dm-verity block size down to 1K.
>
Okay we are trying this.
Thank you so much!!

Regards,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

