Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E42C678D5
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 08:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678178143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mUTm3ony3eACKWNlG7yHa/h869jhELvjToYMe4jSjnU=;
	b=A1fe2UnFR13PQ7MDqRgp20csUkrOSLyTbLhdPOLMKBMKttcssa/OW3FOXybMrZ6XIsjV82
	CcTgPBYTZdtRR93DfgoJ8Sc6+sUK4LleA5ugJNiDJjt6MvN3iiu83LvXudYID9txo6he14
	v6NspoEmmaB9vVn9ZJecG6PUbSsOcis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-lqCOryA6OIWsMGxvsQMvrw-1; Tue, 07 Mar 2023 03:35:40 -0500
X-MC-Unique: lqCOryA6OIWsMGxvsQMvrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA1EA802D2E;
	Tue,  7 Mar 2023 08:35:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 53314400F8FA;
	Tue,  7 Mar 2023 08:35:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3EF4E1946595;
	Tue,  7 Mar 2023 08:35:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B2D301946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 08:35:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A483235454; Tue,  7 Mar 2023 08:35:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C53F18EC6
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 08:35:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DCC8887403
 for <dm-devel@redhat.com>; Tue,  7 Mar 2023 08:35:35 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-VkMFVfM5PrGaUxH3N9e2eQ-1; Tue, 07 Mar 2023 03:35:33 -0500
X-MC-Unique: VkMFVfM5PrGaUxH3N9e2eQ-1
Received: by mail-ed1-f54.google.com with SMTP id o12so49083161edb.9;
 Tue, 07 Mar 2023 00:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678178132;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=YxBHqmf69MjK408ek4FCBC7NJ0Y3JMrmYMYOTzYKM7c=;
 b=olHpCUiFnCpaHSj6rr4pUr8q0+zE6TSyxKoQwMB5M48Fkk5o9qL2vyu6xVMax823HO
 qwE0C+Izo5cx/CDa3KQPFqPswsiCXnFWCkQdhzP9M1wuepmI0QHMUwQ9JGeoInam4w3F
 4g7DibcJGpmaJ02X8g1ZdRa456a5CEWy9i9b5A959sXkq2X3qK043jv/IgS3KL7g73QF
 HQUZw5xy289PMumBZRju0V2GZ2sHEsBQOn9RJEWt5MFELo13dhhHogvijLCTLXYNgn1M
 G3FcvuN39ojz26e/AQXw8DAhL94WU0P5ZRn8CHh4CTC8SE9AyHsxlqpFflYMZuf9pRC6
 EXFg==
X-Gm-Message-State: AO0yUKX4gWbmkZvPyGrdeJKPDpVmTrKLdzgGJ7ciRYzIZluJNSGkzV7f
 3ibzKFY2xVy/pGAdBScqqSahhmwo81Q=
X-Google-Smtp-Source: AK7set+jgL0dJuRWQIRphsttO49wksBGPsQIk/19gmjZGIQK1pXbN5IKsvfl3Vmr71u1NPOHdGLNFA==
X-Received: by 2002:aa7:d6d0:0:b0:4ae:eb17:3afc with SMTP id
 x16-20020aa7d6d0000000b004aeeb173afcmr10326805edr.7.1678178132408; 
 Tue, 07 Mar 2023 00:35:32 -0800 (PST)
Received: from [147.251.42.107] (nbbroz2.fi.muni.cz. [147.251.42.107])
 by smtp.gmail.com with ESMTPSA id
 t26-20020a50d71a000000b004be774e4587sm6291103edi.80.2023.03.07.00.35.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 07 Mar 2023 00:35:31 -0800 (PST)
Message-ID: <11c8212f-e2be-013d-acf7-0402ef13cfac@gmail.com>
Date: Tue, 7 Mar 2023 09:35:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
References: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] dm-zero: support discards
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/6/23 20:10, Mikulas Patocka wrote:
> This patch adds discard support to dm-zero. The discards are ignored.
> It is useful when the user combines dm-zero with other discard-supporting
> targets in the same table; without dm-zero support, discards would be
> disabled for the whole combined device.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Tested-by: Milan Broz <gmazyland@gmail.com>

Just for the context: cryptsetup use dm-zero to mask certain areas
(in Bitlocker-compatible mapping) and discard flag disappeared in this situation
(discard is not supported configuration here, but it should work :)
Originally reported here https://gitlab.com/cryptsetup/cryptsetup/-/issues/718

Propagating discard support in dm-zero is definitely useful for other uses, though.

Thanks,
Milan

> 
> ---
>   drivers/md/dm-table.c |    9 ++++++++-
>   drivers/md/dm-zero.c  |    4 +++-
>   2 files changed, 11 insertions(+), 2 deletions(-)
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
> @@ -59,7 +61,7 @@ static int zero_map(struct dm_target *ti
>   
>   static struct target_type zero_target = {
>   	.name   = "zero",
> -	.version = {1, 1, 0},
> +	.version = {1, 2, 0},
>   	.features = DM_TARGET_NOWAIT,
>   	.module = THIS_MODULE,
>   	.ctr    = zero_ctr,
> Index: linux-2.6/drivers/md/dm-table.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-table.c
> +++ linux-2.6/drivers/md/dm-table.c
> @@ -1670,8 +1670,15 @@ int dm_calculate_queue_limits(struct dm_
>   
>   		blk_set_stacking_limits(&ti_limits);
>   
> -		if (!ti->type->iterate_devices)
> +		if (!ti->type->iterate_devices) {
> +			if (ti->discards_supported) {
> +				ti_limits.max_discard_sectors = UINT_MAX;
> +				ti_limits.max_hw_discard_sectors = UINT_MAX;
> +				ti_limits.discard_granularity = 512;
> +				ti_limits.discard_alignment = 0;
> +			}
>   			goto combine_limits;
> +		}
>   
>   		/*
>   		 * Combine queue limits of all the devices this target uses.
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

