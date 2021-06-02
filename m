Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FFFC4708F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:33:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C3EE7610C8
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 18:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3EE7610C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622658800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cSNG6SHCHmztrwsJiDrWdH8twe1YH1mHoZNS6/ini/A=;
	b=cDzDw9O7A4WnonrVQkeYE8ReoKOXnN/G13Rha7mI2zeZQkDEcHZ0vPWyVMoQBXrF8+gBiZ
	Cn8KNGGMe8JlKB+b8w8j8bsvfoQHeKx6r4MPsA81v2G+GnohUzQ2/mUqVqO7hAY0BQV6zj
	ngwyY6VSHtCTxcs/Dt3+myGRkUlZOWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191--TepxOWZMJucJkNjd2eXPA-1; Wed, 02 Jun 2021 14:33:17 -0400
X-MC-Unique: -TepxOWZMJucJkNjd2eXPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 784D2107ACCA;
	Wed,  2 Jun 2021 18:33:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFE7C60C16;
	Wed,  2 Jun 2021 18:33:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C21921801264;
	Wed,  2 Jun 2021 18:33:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152IX34I012427 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 14:33:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 327CE21CAC67; Wed,  2 Jun 2021 18:33:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E25421CAC66
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 18:33:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7765880348D
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 18:33:00 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
	[209.85.222.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-250-RIqUW9GiNvCZCmAKUgGYkQ-1; Wed, 02 Jun 2021 14:32:58 -0400
X-MC-Unique: RIqUW9GiNvCZCmAKUgGYkQ-1
Received: by mail-qk1-f169.google.com with SMTP id 76so3335233qkn.13
	for <dm-devel@redhat.com>; Wed, 02 Jun 2021 11:32:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=OZfWnyGhrXM/HiypV9I9vq0r6H69jPBHbzJN6dXGJH8=;
	b=n8pHb4m6FNU14Ge4uH/TPZIsjbNE3211dADXwbZ0leA5lzRypRQPnmmE1wUOdRICgr
	Co7MwvVSENORI9Wg4YmyHvpPhYb4uJtpkyU0s+LnAH54qEIqQqItE9XVzl9YxMIuJ97v
	b3YRVicfEicFwpZcoGePYrMSJPqsofCp0NAZkL+SFtl9DKJ08uvbm1yS1RPjPiugS+07
	gtjFg7Vm+RnRFnjeUSRlt0INY0o1EABNBKgK2S2gdn6OarsQUWEkf0ocUa8uK7e3v7jF
	tTRLIDsB0GpB15b1gyyDr8oT8XV54AnyObuYS056ZXprEYUE+1uVYSbnD/oAG4viromx
	Vy7g==
X-Gm-Message-State: AOAM530p9cCqAMRhQX7keNV3TVEf19l0cmg3tQg1AebI+PCIbw4HWoTy
	L6Oxs25XXGH24qC9h7RkHnQ=
X-Google-Smtp-Source: ABdhPJzzM6kheOdfWXSbb1PAabbfizCNSV+LWnIC08jGDEnphrDSjkBmy6+qhDfsG8T7sHT+13Lnrg==
X-Received: by 2002:ae9:e706:: with SMTP id m6mr29510020qka.74.1622658777897; 
	Wed, 02 Jun 2021 11:32:57 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id y19sm357953qki.15.2021.06.02.11.32.56
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Jun 2021 11:32:57 -0700 (PDT)
Date: Wed, 2 Jun 2021 14:32:55 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <YLfO168QXfAWJ9dn@redhat.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 00/11] dm: Improve zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 01 2021 at  6:57P -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2021/05/26 6:25, Damien Le Moal wrote:
> > This series improve device mapper support for zoned block devices and
> > of targets exposing a zoned device.
> 
> Mike, Jens,
> 
> Any feedback regarding this series ?
> 
> > 
> > The first patch improve support for user requests to reset all zones of
> > the target device. With the fix, such operation behave similarly to
> > physical block devices implementation based on the single zone reset
> > command with the ALL bit set.
> > 
> > The following 2 patches are preparatory block layer patches.
> > 
> > Patch 4 and 5 are 2 small fixes to DM core zoned block device support.
> > 
> > Patch 6 reorganizes DM core code, moving conditionally defined zoned
> > block device code into the new dm-zone.c file. This avoids sprinkly DM
> > with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.
> > 
> > Patch 7 improves DM zone report helper functions for target drivers.
> > 
> > Patch 8 fixes a potential problem with BIO requeue on zoned target.
> > 
> > Finally, patch 9 to 11 implement zone append emulation using regular
> > writes for target drivers that cannot natively support this BIO type.
> > The only target currently needing this emulation is dm-crypt. With this
> > change, a zoned dm-crypt device behaves exactly like a regular zoned
> > block device, correctly executing user zone append BIOs.
> > 
> > This series passes the following tests:
> > 1) zonefs tests on top of dm-crypt with a zoned nullblk device
> > 2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
> > 3) btrfs fstests on top of dm-crypt with zoned nullblk devices.
> > 
> > Comments are as always welcome.

I've picked up DM patches 4-8 because they didn't depend on the first
3 block patches.

But I'm fine with picking up 1-3 if Jens provides his Acked-by.
And then I can pickup the remaining DM patches 9-11.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

