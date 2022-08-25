Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E86ECAAA2
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661463919;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N3KzpidpS0vAT5yhy63gxTIqD0l8pR8/ZPB1CRXRLOk=;
	b=AH3KHDg5e+SKqE7xXMcmoRX3TmMjUOTkX6gCYctfFNWFw4UIWhDB816Yax06M/vgNsNAjY
	ZRs4hUj+3Iw4ZqmdHn2Va7Y3TwgcJGMl564oszWk61vEZq1hXh/GcjNS47u3DPMvqmZgLV
	sCv+hDI9nOvbmSF1j6DzyKubiUgdhWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-DEbz8b6tPiGHnX5sBqD8gg-1; Thu, 25 Aug 2022 17:45:18 -0400
X-MC-Unique: DEbz8b6tPiGHnX5sBqD8gg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85AB785A589;
	Thu, 25 Aug 2022 21:45:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2449E2166B26;
	Thu, 25 Aug 2022 21:45:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCC141946A5A;
	Thu, 25 Aug 2022 21:45:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AFF061946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 21:45:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A10921121315; Thu, 25 Aug 2022 21:45:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D6151121314
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:45:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82B973C10694
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 21:45:12 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-i7nwWvNiPNOvVwGmMunYoQ-1; Thu, 25 Aug 2022 17:45:10 -0400
X-MC-Unique: i7nwWvNiPNOvVwGmMunYoQ-1
Received: by mail-pl1-f180.google.com with SMTP id g8so15727115plq.11;
 Thu, 25 Aug 2022 14:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=lGNBkkp4BBDEjfSCq8/qdn5/LeotKxcjg6+Pkd51G6g=;
 b=HHqQmgY4nC9/6MVHgGG7HVWIaVzlBhMlpcaiv3PC/IpqvnFVAXILc9XwHZcoJTv+WT
 lKQAngtQcLBaG2ngmIeH9dIXvhqA14GFqFXpxsNhL5uvqChmxj3zgzyEx7+JaNHZxbei
 0lQ6SBW9qG0W3H5gV2vfvrzaIp+YEcplH3UoxKdgdUkikGGSlNb5Y+3R21OpS8DuSM1n
 y1nwtfV2/YZX6grkfUGsMVCUXBrwnjSELjAYNJKcB96Z9aH1/0YIJdnlsjDGj/FUtwbv
 WVaUFKH5FeJS6SLNVuyAohz4WOmmduH1V66q3jMvVj0Qd1yuAWTsMGU9YMuf/CzH9EiW
 I9Yg==
X-Gm-Message-State: ACgBeo2oop1/+a+ptnhM/1LTS7HmrX7j85ySElY5vuvYW7hkRVuNuGcZ
 lPL/kGHCNscvB3hckkuOnx61yOBpzBHn/g==
X-Google-Smtp-Source: AA6agR58tZ3AbGEr4+IDC4kJWx8+thB6yGtM5mk3JNCEDcPv9jIHtgQv1Iqu8vhglb6GJZCV3zC9Ag==
X-Received: by 2002:a17:903:2310:b0:173:10e1:3a76 with SMTP id
 d16-20020a170903231000b0017310e13a76mr991620plh.160.1661463909550; 
 Thu, 25 Aug 2022 14:45:09 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:349c:3078:d005:5a7e?
 ([2620:15c:211:201:349c:3078:d005:5a7e])
 by smtp.gmail.com with ESMTPSA id
 oe3-20020a17090b394300b001f5513f6fb9sm209053pjb.14.2022.08.25.14.45.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 14:45:08 -0700 (PDT)
Message-ID: <66c80b87-da28-bc9c-11c3-7a9f7354fa15@acm.org>
Date: Thu, 25 Aug 2022 14:45:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, agk@redhat.com, snitzer@kernel.org, 
 axboe@kernel.dk, damien.lemoal@opensource.wdc.com, hch@lst.de
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121903eucas1p230518b312d5260d28e356ba911a27469@eucas1p2.samsung.com>
 <20220823121859.163903-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220823121859.163903-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v12 02/13] block:rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helpers in blkdev.h
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
Cc: pankydev8@gmail.com, Johannes.Thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, gost.dev@samsung.com,
 jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/23/22 05:18, Pankaj Raghav wrote:
> Define bdev_is_zoned(), bdev_zone_sectors() and bdev_get_queue() earlier
> in the blkdev.h include file. Simplify bdev_is_zoned() by removing the
> superfluous NULL check for request queue while we are at it.
> 
> This commit has no functional change, and it is a prep patch for allowing
> zoned devices with non-power-of-2 zone sizes in the block layer.

It seems like a space is missing in the patch subject after the colon? 
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

