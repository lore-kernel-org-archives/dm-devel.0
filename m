Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B289C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 23:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658964714;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ppFSxdnU4noIlwM1F+f5Z6SmlArLHhxp3B8Nr5BE5LI=;
	b=D8Gp2ffiemT6MDquEqq83auTWYUss4t5CJWYDf3PJhedPzJcUHg5s46AQ8jub4YBRpKTiq
	pm5PiV8sddRawVmT4CatpM1JUPQcbvV7Z/bwSAd+Y5NYZhbHQ7lZViS54WfgxUVqvDssqs
	OHJ4o+E2lmC3PUxqYGH1dMyv+Gk6mnE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-aK1jcrNrNkunQEGGzk6gZg-1; Wed, 27 Jul 2022 19:31:52 -0400
X-MC-Unique: aK1jcrNrNkunQEGGzk6gZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6077F3802121;
	Wed, 27 Jul 2022 23:31:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F78D18EB7;
	Wed, 27 Jul 2022 23:31:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0AF091945DAB;
	Wed, 27 Jul 2022 23:31:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DCF51945DA7
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 23:16:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 421A7141511F; Wed, 27 Jul 2022 23:16:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D67F1415118
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 23:16:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 262FB101A54E
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 23:16:38 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-5FksqFPDPkqNb_LM6_sgqw-1; Wed, 27 Jul 2022 19:16:36 -0400
X-MC-Unique: 5FksqFPDPkqNb_LM6_sgqw-1
Received: by mail-pg1-f176.google.com with SMTP id f65so109121pgc.12
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=9RCSjgTld4jFxyRMFpo8i47HSyAGNN8HsW/U7jGMYJo=;
 b=tKv0MKWuTs0Px5MGFse5/Ib27di/OY0ZzqhTsy1Fl6NNezZS4zq3jS+p7b41SRHj38
 u+l4a6GCn7chGKe3yzzxOKYLmwTXMk2sRZZzySUDk458g2GPotKYuEqKszxQqEC8i9OC
 +nxS7/MYopLUgSeKaK8OGFsh9ai93CYV/Cdis0VZlIq2eoqKmJw+Dwm09Px7YrzfNpOu
 45gGt0fJ0m6bM4ZcaCz3SGBoymHDLOD7BxFTSsc+jDr6iphP6i9V8vEs4+9MzHRkEQ2S
 tP2wY13ERmlgVca3HkvRh5NLCrbkMSeSVB6HkNMgO2rLu4eIAv6O7nVUw+dwmIT0qi1n
 tOeg==
X-Gm-Message-State: AJIora9GT4h7AklMkqD5kWAsujd3eA2Qw+Hcb4tooZ6qGKaORK2HVm73
 e9gw1hYyXdD4oIWwI2rwj+s=
X-Google-Smtp-Source: AGRyM1vSsVlL/urmNVN47qPHjbOavQDlMzKZVyvZFSg6UpuKUdlr1Wsfk2LxjLM4G7rsl977tP28Ug==
X-Received: by 2002:a05:6a00:114f:b0:528:2c7a:634c with SMTP id
 b15-20020a056a00114f00b005282c7a634cmr23853833pfm.41.1658963794531; 
 Wed, 27 Jul 2022 16:16:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a84e:2ec1:1b57:b033?
 ([2620:15c:211:201:a84e:2ec1:1b57:b033])
 by smtp.gmail.com with ESMTPSA id
 f25-20020a635559000000b0041983a8d8c2sm12585044pgm.39.2022.07.27.16.16.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jul 2022 16:16:33 -0700 (PDT)
Message-ID: <7984b969-9025-6b31-2645-da08daeefafb@acm.org>
Date: Wed, 27 Jul 2022 16:16:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, damien.lemoal@opensource.wdc.com,
 hch@lst.de, axboe@kernel.dk, snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162248eucas1p2ff8c3c2b021bedcae3960024b4e269e9@eucas1p2.samsung.com>
 <20220727162245.209794-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220727162245.209794-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 02/11] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 7/27/22 09:22, Pankaj Raghav wrote:
> Checking if a given sector is aligned to a zone is a common
> operation that is performed for zoned devices. Add
> bdev_is_zone_start helper to check for this instead of opencoding it
> everywhere.

I can't find the bdev_is_zone_start() function in this patch?

> To make this work bdev_get_queue(), bdev_zone_sectors() and
> bdev_is_zoned() are moved earlier without modifications.

Can that change perhaps be isolated into a separate patch?

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3d286a256d3d..1f7e9a90e198 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -570,7 +570,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>   		return BLK_STS_NOTSUPP;
>   
>   	/* The bio sector must point to the start of a sequential zone */
> -	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	if (!bdev_is_zone_aligned(bio->bi_bdev, bio->bi_iter.bi_sector) ||
>   	    !bio_zone_is_seq(bio))
>   		return BLK_STS_IOERR;

The bdev_is_zone_start() name seems more clear to me than 
bdev_is_zone_aligned(). Has there already been a discussion about which 
name to use for this function?

> +		/*
> +		 * Non power-of-2 zone size support was added to remove the
> +		 * gap between zone capacity and zone size. Though it is technically
> +		 * possible to have gaps in a non power-of-2 device, Linux requires
> +		 * the zone size to be equal to zone capacity for non power-of-2
> +		 * zoned devices.
> +		 */
> +		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
> +			pr_warn("%s: Invalid zone capacity for non power of 2 zone size",
> +				disk->disk_name);

Given the severity of this error, shouldn't the zone capacity and length 
be reported in the error message?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

