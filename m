Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39887C47097
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 17:47:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 21D94613DE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 17:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21D94613DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-dHzmDQ9gPreFQziaKvHijA-1; Thu, 03 Jun 2021 13:47:11 -0400
X-MC-Unique: dHzmDQ9gPreFQziaKvHijA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85E51100945E;
	Thu,  3 Jun 2021 17:47:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F7775D6AB;
	Thu,  3 Jun 2021 17:47:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D93644ED79;
	Thu,  3 Jun 2021 17:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153Hl10P020925 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 13:47:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 23C27113B73; Thu,  3 Jun 2021 17:47:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F55A113B60
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 17:46:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 400DF1825067
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 17:46:58 +0000 (UTC)
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com
	[209.85.166.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-120-znOqTiKrP6aKfJ4vh03-LA-1; Thu, 03 Jun 2021 13:46:53 -0400
X-MC-Unique: znOqTiKrP6aKfJ4vh03-LA-1
Received: by mail-io1-f46.google.com with SMTP id z24so7260747ioi.3
	for <dm-devel@redhat.com>; Thu, 03 Jun 2021 10:46:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=3qpFtT5B6GLJGoBY5auVIaf9nOYgUihdN+2llOJLAB4=;
	b=VqDnDM3ACfOT3aJ5KUS6ZVaHGGpZOnaH/aBXL3UCd+58X5SpDpoLhom5nIY3s+eKXS
	NDfdKL64oXM9RFW3g5XH5t8wWE9L8Z5Ts3HmoSNlekf7wKNNhvT7hiHwG6NhCa4RIkN4
	pwTBTGg4dZxrpfU2fq6ccZqms2xYlwmt6uffVWDe8z/W9rZXdGB9VRB0mLSfw9LS2G8p
	ach5fC5dUlMJFd07MYuY3RQUmryga5uAZwbidzU0mIeilPfrijwRB7fv0AQhzsLs3R3R
	AuGhF9qRNk24WFNxmlZhQznQpjHx/mRKJ0DKFGiyM/7Wb8tTh44AwY3VLdHKBfCZ5Oiz
	NEPg==
X-Gm-Message-State: AOAM531KBNSGGjsEss8VpGao4DJosJk5VFTBPeN7ZaJoA+tdXHqzVR/o
	PXeaw3M4LNV0RlBQum+pxIYdwg==
X-Google-Smtp-Source: ABdhPJxFsxPty1Kc/6oQGUVZmZB2wDpcHWrj1rXqQyzfnvYIGtUsv3kpfwMEaob+VqqLqXyHYI837Q==
X-Received: by 2002:a02:2a0b:: with SMTP id w11mr211672jaw.22.1622742412616;
	Thu, 03 Jun 2021 10:46:52 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id p81sm2062261iod.0.2021.06.03.10.46.51
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 03 Jun 2021 10:46:52 -0700 (PDT)
To: Mike Snitzer <snitzer@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
	<YLfO168QXfAWJ9dn@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a972018e-781b-c0f8-d18a-168c3d1fe963@kernel.dk>
Date: Thu, 3 Jun 2021 11:46:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YLfO168QXfAWJ9dn@redhat.com>
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/2/21 12:32 PM, Mike Snitzer wrote:
> On Tue, Jun 01 2021 at  6:57P -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2021/05/26 6:25, Damien Le Moal wrote:
>>> This series improve device mapper support for zoned block devices and
>>> of targets exposing a zoned device.
>>
>> Mike, Jens,
>>
>> Any feedback regarding this series ?
>>
>>>
>>> The first patch improve support for user requests to reset all zones of
>>> the target device. With the fix, such operation behave similarly to
>>> physical block devices implementation based on the single zone reset
>>> command with the ALL bit set.
>>>
>>> The following 2 patches are preparatory block layer patches.
>>>
>>> Patch 4 and 5 are 2 small fixes to DM core zoned block device support.
>>>
>>> Patch 6 reorganizes DM core code, moving conditionally defined zoned
>>> block device code into the new dm-zone.c file. This avoids sprinkly DM
>>> with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.
>>>
>>> Patch 7 improves DM zone report helper functions for target drivers.
>>>
>>> Patch 8 fixes a potential problem with BIO requeue on zoned target.
>>>
>>> Finally, patch 9 to 11 implement zone append emulation using regular
>>> writes for target drivers that cannot natively support this BIO type.
>>> The only target currently needing this emulation is dm-crypt. With this
>>> change, a zoned dm-crypt device behaves exactly like a regular zoned
>>> block device, correctly executing user zone append BIOs.
>>>
>>> This series passes the following tests:
>>> 1) zonefs tests on top of dm-crypt with a zoned nullblk device
>>> 2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
>>> 3) btrfs fstests on top of dm-crypt with zoned nullblk devices.
>>>
>>> Comments are as always welcome.
> 
> I've picked up DM patches 4-8 because they didn't depend on the first
> 3 block patches.
> 
> But I'm fine with picking up 1-3 if Jens provides his Acked-by.
> And then I can pickup the remaining DM patches 9-11.

I'm fine with 1-3, you can add my Acked-by to those.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

