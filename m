Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3169AC433FE
	for <dm-devel@archiver.kernel.org>; Sat,  1 Oct 2022 02:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664590478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/eVXL+mjUBOSrQ/lNzofO4oO0AbLSzWeeAQX96RwHpk=;
	b=bg5qSVvq9fe/3QBNhqrRDfbzNUJfPqlkU/Prcq0G0ZMF8jxKDn9yzx3jxmg4HX1q8TY3JW
	inpzX2MuCs9s/UsIJmeqw59zZxcKD4OVsRaYjjd23jWiD9aKwLLQhqMRjt/iHOJ9nYGW4C
	9+1+uqsIKjRnP1DT8NJPq2XWKKklJEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-2wn0nfjXOVih_b5oov3Irg-1; Fri, 30 Sep 2022 22:14:34 -0400
X-MC-Unique: 2wn0nfjXOVih_b5oov3Irg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C2E7101AA66;
	Sat,  1 Oct 2022 02:14:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 386F02166B26;
	Sat,  1 Oct 2022 02:14:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A3A6F1946A67;
	Sat,  1 Oct 2022 02:14:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC6AA1946A52
 for <dm-devel@listman.corp.redhat.com>; Sat,  1 Oct 2022 02:14:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D2A640C6EC4; Sat,  1 Oct 2022 02:14:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6589D40C6EC2
 for <dm-devel@redhat.com>; Sat,  1 Oct 2022 02:14:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4947385A59D
 for <dm-devel@redhat.com>; Sat,  1 Oct 2022 02:14:28 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-k_ebY_vxOkSetBxCkMKgIg-1; Fri, 30 Sep 2022 22:14:26 -0400
X-MC-Unique: k_ebY_vxOkSetBxCkMKgIg-1
Received: by mail-pf1-f171.google.com with SMTP id c3so827409pfb.12;
 Fri, 30 Sep 2022 19:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date;
 bh=39nUKBxMEtQ4k/548GHzcQvvgKYGFvJDlLo/dLbAsKs=;
 b=SmeCkDpRMiTQGIKXR7045/RZY0LM4fcCylZ+ufHoaFQ1+ImxL9grokEW4AVZEmhLAJ
 hQ+Lmfrmju9vwq8GZ4s4lNlQwVHsLBV/Xj2qgc2CBerUgjhVHV1c13HgZPXFtCWECICZ
 U3ood2ADBQy6cvEg02Q7Mg1ja7bB3lxV+H5M1yWyH7AVhvH2A5ItAQDb011zAiCOpR9d
 iecTbjTZlCgid6EHRb+GN9JBPPerDXdQj6AUYDhF1wLj0+nfzOK1zj5Y6qBdcZZSIGYa
 CYG+bR85rCAjreJmZNWN/sTBE/QLWdLv5n7qTStI5P8uC5ZORCkWrocQNhwQmadZSRiQ
 DkAA==
X-Gm-Message-State: ACrzQf2OwfJtL6JhDAsmrhF7sW1I75WjE4NrS9X6JLEqFT60vXo64T6g
 GbqRgls3lqBZ3VQJaJJpyTY=
X-Google-Smtp-Source: AMsMyM5IZ9SWdvy+3MR23M5okJI2LPj5kq09p3lxCfop3u62wqmizBiTv5Ld8kTbr49f1xoKgTuRYA==
X-Received: by 2002:a65:42c8:0:b0:41a:8138:f47f with SMTP id
 l8-20020a6542c8000000b0041a8138f47fmr10062728pgp.476.1664590464635; 
 Fri, 30 Sep 2022 19:14:24 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 o3-20020a17090ac08300b0020a73eec389sm69517pjs.3.2022.09.30.19.14.22
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 30 Sep 2022 19:14:23 -0700 (PDT)
Message-ID: <c54b3271-1e3f-75cc-2a90-0d5b9b5e93b2@acm.org>
Date: Fri, 30 Sep 2022 19:14:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Jens Axboe <axboe@kernel.dk>, Pankaj Raghav <p.raghav@samsung.com>,
 hch@lst.de, Keith Busch <kbusch@kernel.org>
References: <CGME20220923173619eucas1p13e645adbe1c8eb62fb48b52c0248ed65@eucas1p1.samsung.com>
 <20220923173618.6899-1-p.raghav@samsung.com>
 <5e9d678f-ffea-e015-53d8-7e80f3deda1e@samsung.com>
 <bd9479f4-ff87-6e5d-296e-e31e669fb148@kernel.dk>
 <0e5088a5-5408-c5bd-bf97-00803cb5faed@acm.org>
 <bb2b3784-422f-fc82-e5be-e4d24412e21f@opensource.wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bb2b3784-422f-fc82-e5be-e4d24412e21f@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 matias.bjorling@wdc.com, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, Johannes.Thumshirn@wdc.com,
 jaegeuk@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/30/22 17:45, Damien Le Moal wrote:
> On 10/1/22 04:38, Bart Van Assche wrote:
>> Since this has not been mentioned in the cover letter, I want to add
>> that in the near future we will need these patches for Android devices.
>> JEDEC is working on supporting zoned storage for UFS devices, the
>> storage devices used in all modern Android phones. Although it would be
>> possible to make the offset between zone starts a power of two by
>> inserting gap zones between data zones, UFS vendors asked not to do this
>> and hence need support for zone sizes that are not a power of two. An
>> advantage of not having to deal with gap zones is better filesystem
>> performance since filesystem extents cannot span gap zones. Having to
>> split filesystem extents because of gap zones reduces filesystem
>> performance.
> 
> As mentioned many times, my opinion is that a good implementation should
> *not* have any extent span zone boundaries. So personally, I do not
> consider such argument as a valid justification for the non-power-of-2
> zone size support.

Hi Damien,

Although the filesystem extent issue probably can be solved in software, 
the argument that UFS vendors strongly prefer not to have gap zones and 
hence need support for zone sizes that are not a power of two remains.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

