Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C883C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664550855;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pHPl0JmTGsh6cdUDiz1Becw5nsh+JJWKHGZsEFA8C8w=;
	b=B3Xj60Kts1arNFSPUs4Hv+4EPNSmgr8E9l9fy6jHOpX5iRcsUxKuJdFamVc4ngj2Yi8r5i
	eDVw3FeP0pm/VpGVZQUuCDA9LodZ1jZ20ERzon2K4hgCSf7HtUEcorSDP1Xd8xQ5ZmwuN3
	eAMtiyvLzju/gevkcaDuoppkHKEOlrw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-K5e5cZZeMFaS7g---eoTpw-1; Fri, 30 Sep 2022 11:14:12 -0400
X-MC-Unique: K5e5cZZeMFaS7g---eoTpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56C061C09C91;
	Fri, 30 Sep 2022 15:14:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4D8C17583;
	Fri, 30 Sep 2022 15:14:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A21B31946A54;
	Fri, 30 Sep 2022 15:14:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0520F1946A52
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Sep 2022 15:14:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD588492B06; Fri, 30 Sep 2022 15:14:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C630F492B04
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 15:14:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC355882821
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 15:14:05 +0000 (UTC)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-558-_gxB7F9ZMw6HkxPqSXcVpA-1; Fri, 30 Sep 2022 11:14:04 -0400
X-MC-Unique: _gxB7F9ZMw6HkxPqSXcVpA-1
Received: by mail-io1-f47.google.com with SMTP id l127so1003163iof.12
 for <dm-devel@redhat.com>; Fri, 30 Sep 2022 08:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=JfR2GfqXfwHVRcahJmnUzB1Y/QLxN5cyd7oQednba7g=;
 b=ET548xV2CF/1uAdLKUUJMswgFXfn+2XpSIC2bCnjs3i6UollGPWx1dqkmXenA92iiK
 L85lS/R75XmOVolH4ur++HE22ShjQGAAhIqSq90H9TyY+QukYlph/4zo16ziZPHx4bDC
 Vlzey+87UVH9xjDy+ja8C0gEBAJWFBO69Ur/6W4yCIoR1DCKa4DpkQjVXxN8+rhotpyQ
 M/qJl36pAQZRmhpBSipRRYfD2uglA9s6XjPcIYMx5UpIXJ0ju2S5NmoVUdD2IszxB8wt
 QnDvUpwdBiM7KHDIgF3JzHZFEGl1Rif+jc2Jy+/b7arPox3Y2ZB2IZHzep+ZHpt8rMyc
 Q/eQ==
X-Gm-Message-State: ACrzQf3SxDst5M/m7nkr2hxCv2H5GWmIRGtY5KG5GwMTKwD+xTta1c8O
 LsDxzpm1XoiuACsTimbIG0Z1KA==
X-Google-Smtp-Source: AMsMyM56qoijmhJXnYPF8kxaWuSK3ez2mfK6ZmVjsiLUqUdOlYO1SRhJq4es+Rf++wuS3uh8BhpzXw==
X-Received: by 2002:a6b:b80a:0:b0:6a4:949:4681 with SMTP id
 i10-20020a6bb80a000000b006a409494681mr4032792iof.96.1664550843041; 
 Fri, 30 Sep 2022 08:14:03 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
 by smtp.gmail.com with ESMTPSA id
 t2-20020a056e02060200b002eae6cf8898sm1052303ils.30.2022.09.30.08.14.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 30 Sep 2022 08:14:02 -0700 (PDT)
Message-ID: <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
Date: Fri, 30 Sep 2022 09:13:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de,
 Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Johannes.Thumshirn@wdc.com, jaegeuk@kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/29/22 12:31 AM, Pankaj Raghav wrote:
>> Hi Jens,
>>   Please consider this patch series for the 6.1 release.
>>
> 
> Hi Jens, Christoph, and Keith,
>  All the patches have a Reviewed-by tag at this point. Can we queue this up
> for 6.1?

It's getting pretty late for 6.1 and I'd really like to have both Christoph
and Martin sign off on these changes.

-- 
Jens Axboe


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

