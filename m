Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A06FC761A6
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680172524;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YqPhXtwTPUE/QJewZU/SkQPPcyTELd46dyNxkGUsQcg=;
	b=BPCtgc6B2oedhsmte6y4uGnvPDACcYdJ4IZWsakyCmsmq5s+VMLlnCrA8QT7ygGch2JpkZ
	HAJ/4ZsU7fXYJrYmoMjRepxpz5t2GH71Y5y/eU8cuhG9mz71rJcEA9fSs/iXf9hw98zO6z
	l2ZWDqAYCH+eQs8NqLUdzaEKQtNQJEw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-b1Ww-3P2NEiMRz4qDvTtAA-1; Thu, 30 Mar 2023 06:35:21 -0400
X-MC-Unique: b1Ww-3P2NEiMRz4qDvTtAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C247E811E7C;
	Thu, 30 Mar 2023 10:35:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BEBE2027040;
	Thu, 30 Mar 2023 10:35:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F3DBC194658F;
	Thu, 30 Mar 2023 10:35:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD4C91946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 10:35:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE04F400F277; Thu, 30 Mar 2023 10:35:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A6DE0400F275
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:35:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CB48811E7C
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:35:14 +0000 (UTC)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com
 [209.85.208.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-s00-0_wwMGWj7qvjFmpO7Q-1; Thu, 30 Mar 2023 06:35:09 -0400
X-MC-Unique: s00-0_wwMGWj7qvjFmpO7Q-1
Received: by mail-ed1-f50.google.com with SMTP id t10so74413171edd.12;
 Thu, 30 Mar 2023 03:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680172508;
 h=content-transfer-encoding:in-reply-to:content-language:references
 :cc:to:from:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/+Yo3o7Bh73ZwnbLTlk+cGmiKix3sfZ90SgmJn40fPo=;
 b=al8IYL71L8Zml2Oz2aILnNZyczMry8j3KvxcF3YYJ7JtU2Oytkha6eysjq4TZkSurM
 S6JmlzbGyMcwMBzbM8yPsU54ag5XqZs0PfUZ++uZGMjDGeF+DD/aY3bKZyX7vliDHrZF
 6tPP4TKw9zz/RUh5aH2zd4xqR2Tpx/rM75EAmLHmTaGL6v/AU61QP7uBKXfHbAEOSP5v
 WlOnfuZE43cGizRq5yxagpttN+JopuHGKmN+w2VqTFarju96AVTmuzifduByukUxAy3D
 LkQ0Ac4zEhNDbyAays9InakZ9kWY+MDijpJIKalLsnW/489LaAW3LRdhyOOYgim/xXJX
 UlDg==
X-Gm-Message-State: AAQBX9cIqDFs6Hv+i3QeVk0EF+7aAN3MJFdVx53w1B2kguc7Dv7MwRhk
 NTblMkm+XQQlK02RxIfL/nlRdf9ZiFVAGQ==
X-Google-Smtp-Source: AKy350b/ThKIaFLxcYevqQajuUVNwY4lJmy5JcJj0Ys0YNBiu9pjow7GtCvY3EocTNLGzOE5sFxnlw==
X-Received: by 2002:a05:6402:798:b0:4fb:5089:6e01 with SMTP id
 d24-20020a056402079800b004fb50896e01mr24076930edy.6.1680172508044; 
 Thu, 30 Mar 2023 03:35:08 -0700 (PDT)
Received: from [147.251.45.223] (eduroam45-223.fi.muni.cz. [147.251.45.223])
 by smtp.gmail.com with ESMTPSA id
 x30-20020a50d61e000000b004c30e2fc6e5sm17886607edi.65.2023.03.30.03.35.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Mar 2023 03:35:07 -0700 (PDT)
Message-ID: <19c4d177-8e8f-ae4f-deac-9c30cfb76f60@gmail.com>
Date: Thu, 30 Mar 2023 12:35:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
From: Milan Broz <gmazyland@gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.21.2303071203060.15370@file01.intranet.prod.int.rdu2.redhat.com>
 <1bdeec11-46d8-6cc0-dfe0-99e65bbd8333@gmail.com>
In-Reply-To: <1bdeec11-46d8-6cc0-dfe0-99e65bbd8333@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2] dm-zero, dm-error: support discards
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/10/23 09:05, Milan Broz wrote:
> On 3/7/23 18:32, Mikulas Patocka wrote:
>> dm-zero, dm-error: support discards
>>
>> This patch adds discard support to dm-zero and dm-error. dm-zero ignores
>> the discards, dm-error return -EIO. It is useful when the user combines
>> dm-zero or dm-error with other discard-supporting targets in the same
>> table; without dm-zero or dm-error support, discards would be disabled for
>> the whole combined device.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Mike, do you plan this patch for 6.4 (I do not see it in for-next branch yet)
or it needs some changes still?

Thanks,
Milan

> 
> For the v2 (including the error target):
> 
> Tested-by: Milan Broz <gmazyland@gmail.com>
> 
> But I would better split it to two patches (per target).
> 
> And as kabi mentioned elsewhere - I understand it the way that discards
> should fail for error target, as it can be in somewhere down the stack
> just write of zeroes (so the patch is IMO correct).
> 
> Milan
> 
>>
>> ---
>>    drivers/md/dm-table.c  |    6 +++++-
>>    drivers/md/dm-target.c |   11 ++++++++++-
>>    drivers/md/dm-zero.c   |   12 +++++++++++-
>>    3 files changed, 26 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/drivers/md/dm-zero.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/md/dm-zero.c
>> +++ linux-2.6/drivers/md/dm-zero.c
>> @@ -27,6 +27,7 @@ static int zero_ctr(struct dm_target *ti
>>    	 * Silently drop discards, avoiding -EOPNOTSUPP.
>>    	 */
>>    	ti->num_discard_bios = 1;
>> +	ti->discards_supported = true;
>>    
>>    	return 0;
>>    }
>> @@ -45,6 +46,7 @@ static int zero_map(struct dm_target *ti
>>    		zero_fill_bio(bio);
>>    		break;
>>    	case REQ_OP_WRITE:
>> +	case REQ_OP_DISCARD:
>>    		/* writes get silently dropped */
>>    		break;
>>    	default:
>> @@ -57,13 +59,21 @@ static int zero_map(struct dm_target *ti
>>    	return DM_MAPIO_SUBMITTED;
>>    }
>>    
>> +static void zero_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> +{
>> +	limits->max_discard_sectors = UINT_MAX;
>> +	limits->max_hw_discard_sectors = UINT_MAX;
>> +	limits->discard_granularity = 512;
>> +}
>> +
>>    static struct target_type zero_target = {
>>    	.name   = "zero",
>> -	.version = {1, 1, 0},
>> +	.version = {1, 2, 0},
>>    	.features = DM_TARGET_NOWAIT,
>>    	.module = THIS_MODULE,
>>    	.ctr    = zero_ctr,
>>    	.map    = zero_map,
>> +	.io_hints = zero_io_hints,
>>    };
>>    
>>    static int __init dm_zero_init(void)
>> Index: linux-2.6/drivers/md/dm-table.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/md/dm-table.c
>> +++ linux-2.6/drivers/md/dm-table.c
>> @@ -1670,8 +1670,12 @@ int dm_calculate_queue_limits(struct dm_
>>    
>>    		blk_set_stacking_limits(&ti_limits);
>>    
>> -		if (!ti->type->iterate_devices)
>> +		if (!ti->type->iterate_devices) {
>> +			/* Set I/O hints portion of queue limits */
>> +			if (ti->type->io_hints)
>> +				ti->type->io_hints(ti, &ti_limits);
>>    			goto combine_limits;
>> +		}
>>    
>>    		/*
>>    		 * Combine queue limits of all the devices this target uses.
>> Index: linux-2.6/drivers/md/dm-target.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/md/dm-target.c
>> +++ linux-2.6/drivers/md/dm-target.c
>> @@ -119,6 +119,7 @@ static int io_err_ctr(struct dm_target *
>>    	 * Return error for discards instead of -EOPNOTSUPP
>>    	 */
>>    	tt->num_discard_bios = 1;
>> +	tt->discards_supported = true;
>>    
>>    	return 0;
>>    }
>> @@ -145,6 +146,13 @@ static void io_err_release_clone_rq(stru
>>    {
>>    }
>>    
>> +static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> +{
>> +	limits->max_discard_sectors = UINT_MAX;
>> +	limits->max_hw_discard_sectors = UINT_MAX;
>> +	limits->discard_granularity = 512;
>> +}
>> +
>>    static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>>    		long nr_pages, enum dax_access_mode mode, void **kaddr,
>>    		pfn_t *pfn)
>> @@ -154,13 +162,14 @@ static long io_err_dax_direct_access(str
>>    
>>    static struct target_type error_target = {
>>    	.name = "error",
>> -	.version = {1, 5, 0},
>> +	.version = {1, 6, 0},
>>    	.features = DM_TARGET_WILDCARD,
>>    	.ctr  = io_err_ctr,
>>    	.dtr  = io_err_dtr,
>>    	.map  = io_err_map,
>>    	.clone_and_map_rq = io_err_clone_and_map_rq,
>>    	.release_clone_rq = io_err_release_clone_rq,
>> +	.io_hints = io_err_io_hints,
>>    	.direct_access = io_err_dax_direct_access,
>>    };
>>    
>>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

