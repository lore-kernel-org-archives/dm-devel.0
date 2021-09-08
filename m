Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25930C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 936FF60F92
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 936FF60F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-4oPDQ0VmPE2zrLZIRLf41g-1; Mon, 13 Sep 2021 02:40:15 -0400
X-MC-Unique: 4oPDQ0VmPE2zrLZIRLf41g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229351006AA3;
	Mon, 13 Sep 2021 06:40:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0433B102AE4A;
	Mon, 13 Sep 2021 06:40:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB54D4EA30;
	Mon, 13 Sep 2021 06:40:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 188BS5Xb029198 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Sep 2021 07:28:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6DDE3207EDD1; Wed,  8 Sep 2021 11:28:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69A2E207AD68
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 11:28:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81A198934F8
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 11:28:02 +0000 (UTC)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com
	[209.85.208.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-ox35LneHO0KVs641Pk8w-A-1; Wed, 08 Sep 2021 07:27:59 -0400
X-MC-Unique: ox35LneHO0KVs641Pk8w-A-1
Received: by mail-ed1-f49.google.com with SMTP id dm15so2385307edb.10;
	Wed, 08 Sep 2021 04:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=T8Mklz6VAwUy6oZgIvPmDqGWckAlnrdzULeYme94/4Q=;
	b=JqR6d85fZTe8KfMuWeP/i5grXwHvIJXLWjCWwFVzXIx/LUQtnh1otzdOpj84jSvw9P
	IGiaupo4tbktppPHsEf5gUA/Rs8nj0J74oY4KQKiVicolOEc77lxHb1EQXNOCT4JGNxE
	UHzNBhRujijg3xGWdR+NRDtyLZQp0IYon+TEBuZM2lAPb5hQmQ9/SI1WsZJPJ3yeagW8
	qUvESgYO4d2Emh8+UIEXDUPtw9CnBzbGgoDbZ3BMQRnOvpXpH2EMPb+YoIwhS2Xc1BPF
	jQL00MDTnKGBypzZMsjMvzq044A0BZslzCut6Xt+AZXeCzYfz2I8LFLD+Nb2L8d4xGkq
	/KcA==
X-Gm-Message-State: AOAM533NGnvenkaqzvAsDngrVLjySyAPLaxgdQorQijPio8hptTy5Qje
	27tF1fPlHAOWouvhmkRAnDwgN9sST2TBHzlBtCM=
X-Google-Smtp-Source: ABdhPJwGfD+i+VdCkJZ7IUmEUFHZnxm9TsQnDXHp+8EbX5wzCKF44hHkvqZBfYGx8AevvBsZcCM3G11fKO55WACtnZo=
X-Received: by 2002:a05:6402:4389:: with SMTP id
	o9mr3325324edc.306.1631100477257; 
	Wed, 08 Sep 2021 04:27:57 -0700 (PDT)
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
	<CAOuPNLgMd0AThhmSknbmKqp3_P8PFhBGr-jW0Mqjb6K6NchEMg@mail.gmail.com>
	<CAOuPNLiW10-E6F_Ndte7U9NPBKa9Y_UuLhgdwAYTc0eYMk5Mqg@mail.gmail.com>
In-Reply-To: <CAOuPNLiW10-E6F_Ndte7U9NPBKa9Y_UuLhgdwAYTc0eYMk5Mqg@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Wed, 8 Sep 2021 16:57:45 +0530
Message-ID: <CAOuPNLj2Xmx52Gtzx5oEKif4Qz-Tz=vaxhRvHQG-5emO7ewRhg@mail.gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Sep 2021 02:39:51 -0400
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

On Mon, 6 Sept 2021 at 21:58, Pintu Agarwal <pintu.ping@gmail.com> wrote:

> On Tue, 31 Aug 2021 at 18:49, Pintu Agarwal <pintu.ping@gmail.com> wrote:
>
> > > No, but you can backport it easily. Back at
> > > http://lists.infradead.org/pipermail/openwrt-devel/2019-November/025967.html
> > > I provided backports of this feature to OpenWrt, for the 4.14 and 4.19
> > > kernels.

Can you please let me know where to get the below patches for
backporting to our kernel:
 create mode 100644
target/linux/generic/backport-4.14/390-dm-add-support-to-directly-boot-to-a-mapped-device.patch
 create mode 100644
target/linux/generic/backport-4.14/391-dm-init-fix-max-devices-targets-checks.patch
 create mode 100644
target/linux/generic/backport-4.14/392-dm-ioctl-fix-hang-in-early-create-error-condition.patch
 create mode 100644
target/linux/generic/backport-4.14/393-Documentation-dm-init-fix-multi-device-example.patch

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

