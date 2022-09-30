Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A19C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664566746;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YhfL8i0eRol5gTfie6X6BpC9EahhxgSpA6efYnFOR7c=;
	b=JraH2Wd2nWQpJ9V0hYkgnuxTKPJQ/ztLwd7UeyLpbt3NMWgs3ywE+be8zimiaVXO925KH+
	ZXpcrJJ3doTt8YcX2kQEh3bm99kcZSzsXoGKMwBHoIOQ8U7h8tusDqp99sZuHQBih0rB9F
	BVvor7tcB0/uZ02v0LjyHh9ZHo4phUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-_boEqoeMPw6lXf_0B2eXaA-1; Fri, 30 Sep 2022 15:39:02 -0400
X-MC-Unique: _boEqoeMPw6lXf_0B2eXaA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B462885A59D;
	Fri, 30 Sep 2022 19:39:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86DC8492B04;
	Fri, 30 Sep 2022 19:38:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06B6F1946A54;
	Fri, 30 Sep 2022 19:38:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC97B1946A52
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Sep 2022 19:38:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AF202166B2A; Fri, 30 Sep 2022 19:38:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93B692166B26
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 19:38:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7382B101A528
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 19:38:55 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-mQ9o_WraNhuClfJeFNs7vQ-1; Fri, 30 Sep 2022 15:38:53 -0400
X-MC-Unique: mQ9o_WraNhuClfJeFNs7vQ-1
Received: by mail-pj1-f41.google.com with SMTP id lx7so5155522pjb.0;
 Fri, 30 Sep 2022 12:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=gjDYcfQrPymPgf4zZHF6ExZnXFdO/ag78V3ukKEreZ8=;
 b=y91hiPYtF366BhF+AJHVjzkv2O46ci8pgB37TGZLT7aU32S15f2ri97jooqDBOk3op
 eehD1gOBiHPabfpo7enq+BOHoW+LlEPx1NTWWIqtcyt6jz3MOqQfgxPSC5Z4gEGZ5YgD
 NhSyjuAJw8bqFIyQfCgAN+qzWL6n4nwqIvwWBzhst2YO5d60u7Ab6a2cIUmU6e5SXUHU
 uzp42nQePBrzaid3cru6b6Rqpv4YpN06Wt6F5gU+iRsk5Lx/G92ZtCWFsOcbjGMvxw+C
 ISo80mGakR1Q2smAZQcB8aGdQfxJ/xRybWYTbyl97x+j/8KEPGwKwmcdPcbdU5Hks6+1
 Amlw==
X-Gm-Message-State: ACrzQf1O0jVdh2ytqwMlT5CrSAE8YHSAXefOH6zGoVaB1kQCHFBhljHp
 7qweLeJgM3HkOX0j1erKG4I=
X-Google-Smtp-Source: AMsMyM6wPTQbb/wpm4NYDTyzteu9Ju/f5nYNm4NlJda34lAJsiPgMThwpAp8l1Io6xLGw26w5R/LwQ==
X-Received: by 2002:a17:90b:3149:b0:202:e9e9:632f with SMTP id
 ip9-20020a17090b314900b00202e9e9632fmr24463065pjb.96.1664566732077; 
 Fri, 30 Sep 2022 12:38:52 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35?
 ([2620:15c:211:201:56f2:482f:20c2:1d35])
 by smtp.gmail.com with ESMTPSA id
 z5-20020aa79f85000000b0052e6c058bccsm2187903pfr.61.2022.09.30.12.38.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 30 Sep 2022 12:38:51 -0700 (PDT)
Message-ID: <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
Date: Fri, 30 Sep 2022 12:38:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
To: Jens Axboe <axboe@kernel.dk>, Pankaj Raghav <p.raghav@samsung.com>,
 hch@lst.de, Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
 <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v15 00/13] support zoned block devices with
 non-power-of-2 zone sizes
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, pankydev8@gmail.com,
 matias.bjorling@wdc.com, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/30/22 08:13, Jens Axboe wrote:
> On 9/29/22 12:31 AM, Pankaj Raghav wrote:
>>> Hi Jens,
>>>    Please consider this patch series for the 6.1 release.
>>>
>>
>> Hi Jens, Christoph, and Keith,
>>   All the patches have a Reviewed-by tag at this point. Can we queue this up
>> for 6.1?
> 
> It's getting pretty late for 6.1 and I'd really like to have both Christoph
> and Martin sign off on these changes.

Hi Jens,

Agreed that it's getting late for 6.1.

Since this has not been mentioned in the cover letter, I want to add 
that in the near future we will need these patches for Android devices. 
JEDEC is working on supporting zoned storage for UFS devices, the 
storage devices used in all modern Android phones. Although it would be 
possible to make the offset between zone starts a power of two by 
inserting gap zones between data zones, UFS vendors asked not to do this 
and hence need support for zone sizes that are not a power of two. An 
advantage of not having to deal with gap zones is better filesystem 
performance since filesystem extents cannot span gap zones. Having to 
split filesystem extents because of gap zones reduces filesystem 
performance.

Thanks,

Bart.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

