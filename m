Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AF2C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:37:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-M7RSzQSwPwyN5kHF7gDkcw-1; Fri, 04 Feb 2022 08:36:57 -0500
X-MC-Unique: M7RSzQSwPwyN5kHF7gDkcw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACAA9100D841;
	Fri,  4 Feb 2022 13:36:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6130384A10;
	Fri,  4 Feb 2022 13:36:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86CBB4A7C8;
	Fri,  4 Feb 2022 13:36:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 214DY6Cg030369 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 08:34:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 71E25C23DC5; Fri,  4 Feb 2022 13:34:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E2B8C23DC3
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 13:34:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54B2B2B16868
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 13:34:06 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
	[209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-147-9OelmazuPh-En0yuZw6ymw-1; Fri, 04 Feb 2022 08:34:04 -0500
X-MC-Unique: 9OelmazuPh-En0yuZw6ymw-1
Received: by mail-pl1-f172.google.com with SMTP id x3so5169199pll.3
	for <dm-devel@redhat.com>; Fri, 04 Feb 2022 05:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=KWj5VHbmtPCAG80WBX4yW0jMIjhI+i8MGje98xVpJ28=;
	b=8Oi26sUzIirEOL2K2gud/UczqsOQGBoF5hpJENo2fHoUyJUuvjzqx559+F8xqstMZ3
	VdFZLK+xi2unl37AxeLU2kSWi+/AkbBnm9d+MqjJ6bD2ZmyWd8PdkseFOLWTOLECaRwB
	eSTP1EKtQ7cmO4G5WDHTpX/t/xyBukODVryQVJu+TZnDrTSG7XzWpHTkdiBz+c/F+YSM
	2/4OQKeHXBjcWxMhQN2s+/e3ftIx+xP947iyOv+zrruJls9wL5U+3FCTRhdkOnhG8rbG
	n85OT1JV4FegBsvp34LYpaCeLLxwf0WEm/jLGCZJvJLn4oC/P/oFoLIR6EODs9f24J6h
	XRyg==
X-Gm-Message-State: AOAM531voqIs4ZC8NwjOLD0pk0PD8AQpBldBIMh4caHwwac7jbnwhtOF
	9wTIRIB/EGT8rW4Piuk0TFtb4w==
X-Google-Smtp-Source: ABdhPJxj+mWKk80hBHd+iZIf+Sws1xCuDe5XG9c0N/wSw4I51o6nz5iMnvsk4OFG8pEwrP+T/IACJA==
X-Received: by 2002:a17:90b:3511:: with SMTP id
	ls17mr3138025pjb.241.1643981643450; 
	Fri, 04 Feb 2022 05:34:03 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id f8sm2818712pfv.24.2022.02.04.05.34.02
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 04 Feb 2022 05:34:03 -0800 (PST)
To: Mikulas Patocka <mpatocka@redhat.com>, Bart Van Assche <bvanassche@acm.org>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<efd2e976-4d2d-178e-890d-9bde1a89c47f@acm.org>
	<alpine.LRH.2.02.2202031310530.28604@file01.intranet.prod.int.rdu2.redhat.com>
	<a2ec9086-72d2-4a4e-c4fa-fe53bf5ba092@acm.org>
	<alpine.LRH.2.02.2202040657060.19134@file01.intranet.prod.int.rdu2.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2c33ecab-7154-a476-8038-451e37785201@kernel.dk>
Date: Fri, 4 Feb 2022 06:34:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2202040657060.19134@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 1/3] block: add copy offload support
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/4/22 5:09 AM, Mikulas Patocka wrote:
> 
> 
> On Thu, 3 Feb 2022, Bart Van Assche wrote:
> 
>> On 2/3/22 10:50, Mikulas Patocka wrote:
>>> On Tue, 1 Feb 2022, Bart Van Assche wrote:
>>>> On 2/1/22 10:32, Mikulas Patocka wrote:
>>>>>    /**
>>>>> + * blk_queue_max_copy_sectors - set maximum copy offload sectors for
>>>>> the
>>>>> queue
>>>>> + * @q:  the request queue for the device
>>>>> + * @size:  the maximum copy offload sectors
>>>>> + */
>>>>> +void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int
>>>>> size)
>>>>> +{
>>>>> +	q->limits.max_copy_sectors = size;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);
>>>>
>>>> Please either change the unit of 'size' into bytes or change its type into
>>>> sector_t.
>>>
>>> blk_queue_chunk_sectors, blk_queue_max_discard_sectors,
>>> blk_queue_max_write_same_sectors, blk_queue_max_write_zeroes_sectors,
>>> blk_queue_max_zone_append_sectors also have the unit of sectors and the
>>> argument is "unsigned int". Should blk_queue_max_copy_sectors be
>>> different?
>>
>> As far as I know using the type sector_t for variables that represent a number
>> of sectors is a widely followed convention:
>>
>> $ git grep -w sector_t | wc -l
>> 2575
>>
>> I would appreciate it if that convention would be used consistently, even if
>> that means modifying existing code.
>>
>> Thanks,
>>
>> Bart.
> 
> Changing the sector limit variables in struct queue_limits from
> unsigned int to sector_t would increase the size of the structure and
> its cache footprint.
> 
> And we can't send bios larger than 4GiB anyway because bi_size is
> 32-bit.
> 
> Jens, what do you think about it? Should the sectors limits be
> sector_t?

Why make it larger than it needs to?

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

