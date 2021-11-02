Return-Path: <SRS0=3wtw=PV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664D5C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:05:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AF99B610A8
	for <dm-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AF99B610A8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-LWVF8O92MHee5UBe_ghJdQ-1; Tue, 02 Nov 2021 09:05:26 -0400
X-MC-Unique: LWVF8O92MHee5UBe_ghJdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAA6219251CB;
	Tue,  2 Nov 2021 13:05:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E71660CC4;
	Tue,  2 Nov 2021 13:05:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 148921819AC2;
	Tue,  2 Nov 2021 13:05:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A2CxNt8014115 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Nov 2021 08:59:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 734A240CFD10; Tue,  2 Nov 2021 12:59:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DA6E40CFD08
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 12:59:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 555F1802813
	for <dm-devel@redhat.com>; Tue,  2 Nov 2021 12:59:23 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
	[209.85.166.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-258-4ixndS3VNLSV9x4yPh2DYw-1; Tue, 02 Nov 2021 08:59:21 -0400
X-MC-Unique: 4ixndS3VNLSV9x4yPh2DYw-1
Received: by mail-il1-f175.google.com with SMTP id l8so3945512ilv.3
	for <dm-devel@redhat.com>; Tue, 02 Nov 2021 05:59:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=iYiRp0l1uhYjvBkGrtc0hnMXWU1AiLYZRHqgAfjylr0=;
	b=AMlr2cw3o8OBREa4XpAgX3XlJbWbjIEeO8FbzUj64F0XpqXeidQ8znJfMZfjiCUT6C
	+J8I0exhhNduPGuJQ/Y2F5X+xjBlq2ohNVWyy2WYA7iLS1QwRDjxevZBR2DbFarCMDee
	YaQNVGIsoTFlH2l6M5BfApKx/PgSD+QHd6Ssem9QX3HmNv1KBIpIyCWsk+Kosy5rIzGT
	mCPYepR2F/KW2ImhrN5tKpNfbgu6a/ymybdljn9stH2VgmtHvMh8slK+zR7uWYonIfeE
	Lozb6+sqX8SLzl6Rpcjtd9NNQFiE1agBkvLaw5mxzbJZMBj+1ke17Tv8xiOHPFrlcdKz
	so0A==
X-Gm-Message-State: AOAM532EO0R+nGDht5l/X7+5kzqcTIAUHjnTW2UiHrl11Qdw5xhXe9PV
	q9MRXKCFSJeR77LYnowpvj2PsE0XLnzvrg==
X-Google-Smtp-Source: ABdhPJxvALWLpyGcrXCgpmlgX6E6EkmrZY0JmhIZnPbQeBAVBX9qvNHL5hCeTbm0c8VWV+BBzmukow==
X-Received: by 2002:a05:6e02:e41:: with SMTP id
	l1mr20381671ilk.139.1635857960219; 
	Tue, 02 Nov 2021 05:59:20 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
	by smtp.gmail.com with ESMTPSA id m2sm4904622iow.6.2021.11.02.05.59.19
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 02 Nov 2021 05:59:19 -0700 (PDT)
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	Ming Lei <ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
	<20211021145918.2691762-3-ming.lei@redhat.com>
	<10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8cbc1be6-15a5-ed34-53f1-081a05025d34@kernel.dk>
Date: Tue, 2 Nov 2021 06:59:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <10c279f54ed0b24cb1ac0861f9a407e6b64f64da.camel@HansenPartnership.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Yi Zhang <yi.zhang@redhat.com>, linux-scsi@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH 2/3] scsi: make sure that request queue
 queiesce and unquiesce balanced
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/1/21 7:43 PM, James Bottomley wrote:
> On Thu, 2021-10-21 at 22:59 +0800, Ming Lei wrote:
>> For fixing queue quiesce race between driver and block layer(elevator
>> switch, update nr_requests, ...), we need to support concurrent
>> quiesce
>> and unquiesce, which requires the two call balanced.
>>
>> It isn't easy to audit that in all scsi drivers, especially the two
>> may
>> be called from different contexts, so do it in scsi core with one
>> per-device
>> bit flag & global spinlock, basically zero cost since request queue
>> quiesce
>> is seldom triggered.
>>
>> Reported-by: Yi Zhang <yi.zhang@redhat.com>
>> Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue
>> quiesce/unquiesce")
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>>  drivers/scsi/scsi_lib.c    | 45 ++++++++++++++++++++++++++++++----
>> ----
>>  include/scsi/scsi_device.h |  1 +
>>  2 files changed, 37 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 51fcd46be265..414f4daf8005 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2638,6 +2638,40 @@ static int
>> __scsi_internal_device_block_nowait(struct scsi_device *sdev)
>>  	return 0;
>>  }
>>  
>> +static DEFINE_SPINLOCK(sdev_queue_stop_lock);
>> +
>> +void scsi_start_queue(struct scsi_device *sdev)
>> +{
>> +	bool need_start;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&sdev_queue_stop_lock, flags);
>> +	need_start = sdev->queue_stopped;
>> +	sdev->queue_stopped = 0;
>> +	spin_unlock_irqrestore(&sdev_queue_stop_lock, flags);
>> +
>> +	if (need_start)
>> +		blk_mq_unquiesce_queue(sdev->request_queue);
> 
> Well, this is a classic atomic pattern:
> 
> if (cmpxchg(&sdev->queue_stopped, 1, 0))
> 	blk_mq_unquiesce_queue(sdev->request_queue);
> 
> The reason to do it with atomics rather than spinlocks is
> 
>    1. no need to disable interrupts: atomics are locked
>    2. faster because a spinlock takes an exclusive line every time but the
>       read to check the value can be in shared mode in cmpxchg
>    3. it's just shorter and better code.
> 
> The only minor downside is queue_stopped now needs to be a u32.

Are you fine with the change as-is, or do you want it redone? I
can drop the SCSI parts and just queue up the dm fix. Personally
I think it'd be better to get it fixed upfront.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

