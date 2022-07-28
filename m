Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852B8C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658977095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WNR4NngzUxkMFSvmbYB1joAzDxdvliyMVECY5RCvrN8=;
	b=HTYbHqOtDmh2BpRSgZxTiYN2XNd4lrTz4npFgYMbp6oV7UFK2PfcSgK+haUH9Ey7uUftbx
	26QqqanmRgGNsaorhGrzKUaArlMTl2hVJWwzhVcXZ8RlR9Ye8GeLFliNpL+dGrQFsb4p7B
	rVJJoXRn0LszmSWg4XX50gxvqAwJdPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-FkbQ5X1JNU2fcsaVetX7wQ-1; Wed, 27 Jul 2022 22:58:12 -0400
X-MC-Unique: FkbQ5X1JNU2fcsaVetX7wQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AB9E8037AA;
	Thu, 28 Jul 2022 02:58:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 36D31403160;
	Thu, 28 Jul 2022 02:58:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DD0D1945DAB;
	Thu, 28 Jul 2022 02:58:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7CA31945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 02:58:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A85A72166B29; Thu, 28 Jul 2022 02:58:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A46E02166B26
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 02:58:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 894DA3C0D842
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 02:58:07 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
 [209.85.216.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-VxtYZTpQPxGNTKRi0JEPtg-1; Wed, 27 Jul 2022 22:58:04 -0400
X-MC-Unique: VxtYZTpQPxGNTKRi0JEPtg-1
Received: by mail-pj1-f52.google.com with SMTP id
 c19-20020a17090ae11300b001f2f94ed5c6so4200103pjz.1
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 19:58:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=aQxaeeJ5JgMVcJcw8Ko279QSx3iejqMvsto3fG7z2rc=;
 b=OBMhZhjZfsUw7+GWrxYHlGre6GV2dSlNFxDN/WsUXfVuQBu+t07srQ8cOi590BRYoB
 RWX+QPro9Sy57wRIfDsLoIeB1seSUL9+bs4a+lDj19mksDykSVu7O4jmRke2uE+Vqfrm
 dR08TstYL0mX/Z6IlpVoSWWW6eFK9Od/OSk7apQa1WYkBZU8N/crzoWd/nrqlNStRZHN
 3hkMqh8qWAGfSKjLUdiB8Mx4HI+BWYxVHTWe309m8cWXhBkUKOX19UYFW9tUUYI4Oihx
 cs4d4Gfk4vMIM/5SeYfINaC816Yx4i6d+TEOTEBRTdVvJr1w2jKSaCy3QucKTPK/pSHL
 6clg==
X-Gm-Message-State: AJIora+NJatgWVcSZuhDqAbO+yGJerlqMd+UJrb+ItnCrfVup5zYDHBh
 9aNnYDwQZRE9OTm/AxuGc/s=
X-Google-Smtp-Source: AGRyM1vzNaQ3usdPkws9TvBM7VWRcatZbgUmBSHGre6iDPg8J6DngaQMIdNpC0DUbU1GPefINTER8g==
X-Received: by 2002:a17:902:d590:b0:16d:8a08:fa7d with SMTP id
 k16-20020a170902d59000b0016d8a08fa7dmr13863590plh.122.1658977083051; 
 Wed, 27 Jul 2022 19:58:03 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
 by smtp.gmail.com with ESMTPSA id
 z11-20020aa7990b000000b005281d926733sm14543586pff.199.2022.07.27.19.58.01
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jul 2022 19:58:02 -0700 (PDT)
Message-ID: <024d16ac-d685-0fcf-1ad3-e99946852b03@acm.org>
Date: Wed, 27 Jul 2022 19:58:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <CGME20220727162246eucas1p1a758799f13d36ba99d30bf92cc5e2754@eucas1p1.samsung.com>
 <20220727162245.209794-1-p.raghav@samsung.com>
 <51255650-ddc2-4f3d-52e5-14007b9ff538@acm.org>
 <f2f29f97-5994-37f9-c922-31158c1c1b9a@opensource.wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f2f29f97-5994-37f9-c922-31158c1c1b9a@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 00/11] support non power of 2 zoned device
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/27/22 18:52, Damien Le Moal wrote:
> On 7/28/22 08:19, Bart Van Assche wrote:
>> On 7/27/22 09:22, Pankaj Raghav wrote:
>>> This series adds support to npo2 zoned devices in the block and nvme
>>> layer and a new **dm target** is added: dm-po2z-target. This new
>>> target will be initially used for filesystems such as btrfs and
>>> f2fs that does not have native npo2 zone support.
>>
>> Should any SCSI changes be included in this patch series? From sd_zbc.c:
>>
>> 	if (!is_power_of_2(zone_blocks)) {
>> 		sd_printk(KERN_ERR, sdkp,
>> 			  "Zone size %llu is not a power of two.\n",
>> 			  zone_blocks);
>> 		return -EINVAL;
>> 	}
> 
> There are no non-power of 2 SMR drives on the market and no plans to have
> any as far as I know. Users want power of 2 zone size. So I think it is
> better to leave sd_zbc & scsi_debug as is for now.

Zoned UFS devices will support ZBC and may have a zone size that is not 
a power of two.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

