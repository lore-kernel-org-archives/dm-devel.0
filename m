Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395A5C6FD19
	for <dm-devel@archiver.kernel.org>; Fri, 10 Mar 2023 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678439160;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7wggznh2Xa9DCC2evbyL8OiCkA9y4k6Ie/TNzztooks=;
	b=DI95LuZdUeqrPAwa1D2TGXh0top7woqEBybE4V1GGpmKFYwQADH9bqBSPBUEFprdwWImLW
	A+GYV1h9G0SGVT77xWYgaCbx6KoW91JEXJBMA1q67aJZpaZLmC2m5sBlpdq1GlDn2+dJd7
	403NRRxetA8I4x6eTDv2KKlesuXwHI4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-L2ylKbI4OvWkwJg3O8VJhw-1; Fri, 10 Mar 2023 04:05:56 -0500
X-MC-Unique: L2ylKbI4OvWkwJg3O8VJhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 083AC3C0DDD0;
	Fri, 10 Mar 2023 09:05:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A426C440DD;
	Fri, 10 Mar 2023 09:05:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19B9119466DF;
	Fri, 10 Mar 2023 09:05:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB43C1946597
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Mar 2023 09:05:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AAE32166B2A; Fri, 10 Mar 2023 09:05:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 929CB2166B26
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 09:05:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFC387B2A0
 for <dm-devel@redhat.com>; Fri, 10 Mar 2023 09:05:49 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-2o0HOowKPQWjY_UIUzo0YA-1; Fri, 10 Mar 2023 04:05:47 -0500
X-MC-Unique: 2o0HOowKPQWjY_UIUzo0YA-1
Received: by mail-ed1-f54.google.com with SMTP id cw28so17702183edb.5;
 Fri, 10 Mar 2023 01:05:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678439145;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=NCy3xOK6FTxzdEgQKk8LYCFfy7ZV/RCsI13XrcbXaOI=;
 b=c3WnFGz+fJmvTlFxyCaZyGuKKM4tQl6RXf3hQmHp4Kag6MnmwYljlzi3Josp2qWy2g
 XMB2yLFLBwlNiJSmGTJ60FLJFop3oxQ37GNTRp8bj7EoJCTXT/CTCZTMdvvJNQk1m5SN
 XOxwm4nc53+HZeAzoDLqm1Q9mI1zh4PhFwXw/LnIwTy8XBQwVtK+d7ArXzrTR7isQoJs
 RSNR7ERGtjmcH03B7NKlKpukUdL2TP+hGtej365oxG2k6aRogozqteEDdP6G01ggqYMQ
 Eq3hHlj08TfnQEDX5Sh98e4ydHdoEpLe2mvycJq/7r2LlXlfH0pStaUEvoj0oTN9rlTR
 UYZA==
X-Gm-Message-State: AO0yUKV53Ks/36mudbUugTaebkEgxH0GNUzIhfwQ0JG/Cxm80qTiiKjg
 kmxNlQBLUWzzystTWSY5iVRgW+8fX5k=
X-Google-Smtp-Source: AK7set+PrEJtQ0L2ApsA40eSvGRpHhlYNXlCTbxGUmiSP07EfUpb+ne4e9vdQ1pGRXVJ7eJ4kNlMGA==
X-Received: by 2002:aa7:c44e:0:b0:4b8:9a32:ec07 with SMTP id
 n14-20020aa7c44e000000b004b89a32ec07mr20312990edr.39.1678439145581; 
 Fri, 10 Mar 2023 01:05:45 -0800 (PST)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 f11-20020a50a6cb000000b004c25b12b7cesm577785edc.42.2023.03.10.01.05.44
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Mar 2023 01:05:45 -0800 (PST)
Message-ID: <1bdeec11-46d8-6cc0-dfe0-99e65bbd8333@gmail.com>
Date: Fri, 10 Mar 2023 10:05:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Zdenek Kabelac <zkabelac@redhat.com>
References: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.21.2303071203060.15370@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <alpine.LRH.2.21.2303071203060.15370@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/7/23 18:32, Mikulas Patocka wrote:
> dm-zero, dm-error: support discards
> 
> This patch adds discard support to dm-zero and dm-error. dm-zero ignores
> the discards, dm-error return -EIO. It is useful when the user combines
> dm-zero or dm-error with other discard-supporting targets in the same
> table; without dm-zero or dm-error support, discards would be disabled for
> the whole combined device.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

For the v2 (including the error target):

Tested-by: Milan Broz <gmazyland@gmail.com>

But I would better split it to two patches (per target).

And as kabi mentioned elsewhere - I understand it the way that discards
should fail for error target, as it can be in somewhere down the stack
just write of zeroes (so the patch is IMO correct).

Milan

> 
> ---
>   drivers/md/dm-table.c  |    6 +++++-
>   drivers/md/dm-target.c |   11 ++++++++++-
>   drivers/md/dm-zero.c   |   12 +++++++++++-
>   3 files changed, 26 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-zero.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-zero.c
> +++ linux-2.6/drivers/md/dm-zero.c
> @@ -27,6 +27,7 @@ static int zero_ctr(struct dm_target *ti
>   	 * Silently drop discards, avoiding -EOPNOTSUPP.
>   	 */
>   	ti->num_discard_bios = 1;
> +	ti->discards_supported = true;
>   
>   	return 0;
>   }
> @@ -45,6 +46,7 @@ static int zero_map(struct dm_target *ti
>   		zero_fill_bio(bio);
>   		break;
>   	case REQ_OP_WRITE:
> +	case REQ_OP_DISCARD:
>   		/* writes get silently dropped */
>   		break;
>   	default:
> @@ -57,13 +59,21 @@ static int zero_map(struct dm_target *ti
>   	return DM_MAPIO_SUBMITTED;
>   }
>   
> +static void zero_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	limits->max_discard_sectors = UINT_MAX;
> +	limits->max_hw_discard_sectors = UINT_MAX;
> +	limits->discard_granularity = 512;
> +}
> +
>   static struct target_type zero_target = {
>   	.name   = "zero",
> -	.version = {1, 1, 0},
> +	.version = {1, 2, 0},
>   	.features = DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr    = zero_ctr,
>   	.map    = zero_map,
> +	.io_hints = zero_io_hints,
>   };
>   
>   static int __init dm_zero_init(void)
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c
> +++ linux-2.6/drivers/md/dm-table.c
> @@ -1670,8 +1670,12 @@ int dm_calculate_queue_limits(struct dm_
>   
>   		blk_set_stacking_limits(&ti_limits);
>   
> -		if (!ti->type->iterate_devices)
> +		if (!ti->type->iterate_devices) {
> +			/* Set I/O hints portion of queue limits */
> +			if (ti->type->io_hints)
> +				ti->type->io_hints(ti, &ti_limits);
>   			goto combine_limits;
> +		}
>   
>   		/*
>   		 * Combine queue limits of all the devices this target uses.
> Index: linux-2.6/drivers/md/dm-target.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-target.c
> +++ linux-2.6/drivers/md/dm-target.c
> @@ -119,6 +119,7 @@ static int io_err_ctr(struct dm_target *
>   	 * Return error for discards instead of -EOPNOTSUPP
>   	 */
>   	tt->num_discard_bios = 1;
> +	tt->discards_supported = true;
>   
>   	return 0;
>   }
> @@ -145,6 +146,13 @@ static void io_err_release_clone_rq(stru
>   {
>   }
>   
> +static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	limits->max_discard_sectors = UINT_MAX;
> +	limits->max_hw_discard_sectors = UINT_MAX;
> +	limits->discard_granularity = 512;
> +}
> +
>   static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>   		long nr_pages, enum dax_access_mode mode, void **kaddr,
>   		pfn_t *pfn)
> @@ -154,13 +162,14 @@ static long io_err_dax_direct_access(str
>   
>   static struct target_type error_target = {
>   	.name = "error",
> -	.version = {1, 5, 0},
> +	.version = {1, 6, 0},
>   	.features = DM_TARGET_WILDCARD,
>   	.ctr  = io_err_ctr,
>   	.dtr  = io_err_dtr,
>   	.map  = io_err_map,
>   	.clone_and_map_rq = io_err_clone_and_map_rq,
>   	.release_clone_rq = io_err_release_clone_rq,
> +	.io_hints = io_err_io_hints,
>   	.direct_access = io_err_dax_direct_access,
>   };
>   
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

