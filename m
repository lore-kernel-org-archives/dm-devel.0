Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619E6C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 20:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-CBERuGhZO5WzfUz80B2Eig-1; Wed, 15 Jun 2022 16:28:20 -0400
X-MC-Unique: CBERuGhZO5WzfUz80B2Eig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C8388041B9;
	Wed, 15 Jun 2022 20:28:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C019FC2811E;
	Wed, 15 Jun 2022 20:28:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9A41B1947040;
	Wed, 15 Jun 2022 20:28:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB2F019466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 20:28:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8975240C1289; Wed, 15 Jun 2022 20:28:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8510E40C1288
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:28:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D5AE80B70A
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:28:15 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-nJVhvfknPfaVn6xGPbnRLQ-1; Wed, 15 Jun 2022 16:28:12 -0400
X-MC-Unique: nJVhvfknPfaVn6xGPbnRLQ-1
Received: by mail-pj1-f43.google.com with SMTP id
 q12-20020a17090a304c00b001e2d4fb0eb4so3206978pjl.4; 
 Wed, 15 Jun 2022 13:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=tCKjUEEB/O98mq0HYBwtkHqa14AHHAARD8/Yh00PhZE=;
 b=TsH0FO/Ph/BPOtGETXyRhXSXhDSzQ2DdMqXHHKwhDTgjLO5I37rfKPd6pkyVTnt4yN
 2/PJvrK0DYJw8Qsuz0rat4TnWg3CzS6HwLKRCJOnZ2l1PBzZDCnzUNfWCEYqboGIZ6av
 BFmdLsjP72GQaqofcTYLWpuHV0wVuafUlowHWhgkaMpgxh9bQy5eOuAeGD0YOtt0A0tP
 dRUUC6bU2RJ7T2hMQJF0c/tHfzHjO6G1i412oFo2KoOBHh0k6x3lrFZ6srqSFlbYAPy1
 0hf/ALQFpK0Z7GTr0JqUVMpDq8HJze/aLaUrrSdugg5QAy1lLHJEElepRjXj4CUcqwRz
 xVsQ==
X-Gm-Message-State: AJIora9jgu/EkFG3OY1Qk0BXnqxvELiAHcEFqwp3X2IyrMJYh2+VgEh/
 y6uSx76rDwqEOrxVdHHOpbc=
X-Google-Smtp-Source: AGRyM1ssYRY17vRnuP2ETISK730/klJkF/7+lw/tAz1SHcUNuW29npshKuTZX6r5VdStdPt6uTHY9Q==
X-Received: by 2002:a17:90b:358d:b0:1ea:4718:82b8 with SMTP id
 mm13-20020a17090b358d00b001ea471882b8mr12165746pjb.244.1655324890558; 
 Wed, 15 Jun 2022 13:28:10 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:36ac:cabd:84b2:80f6?
 ([2620:15c:211:201:36ac:cabd:84b2:80f6])
 by smtp.gmail.com with ESMTPSA id
 w22-20020a1709026f1600b001676f87473fsm8523plk.302.2022.06.15.13.28.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Jun 2022 13:28:09 -0700 (PDT)
Message-ID: <857c444a-02b9-9cef-0c5b-2ecdb2fd46f6@acm.org>
Date: Wed, 15 Jun 2022 13:28:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb@eucas1p1.samsung.com>
 <20220615101920.329421-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220615101920.329421-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v7 02/13] block: allow blk-zoned devices to
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 6/15/22 03:19, Pankaj Raghav wrote:
> @@ -489,14 +489,27 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>   	 * smaller last zone.
>   	 */
>   	if (zone->start == 0) {
> -		if (zone->len == 0 || !is_power_of_2(zone->len)) {
> -			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
> -				disk->disk_name, zone->len);
> +		if (zone->len == 0) {
> +			pr_warn("%s: Invalid zone size", disk->disk_name);
> +			return -ENODEV;
> +		}
> +
> +		/*
> +		 * Don't allow zoned device with non power_of_2 zone size with
> +		 * zone capacity less than zone size.
> +		 */

Please change "power_of_2" into "power-of-2".

> +		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
> +			pr_warn("%s: Invalid zone capacity for non power of 2 zone size",
> +				disk->disk_name);
>   			return -ENODEV;
>   		}

The above check seems wrong to me. I don't see why devices that report a 
capacity that is less than the zone size should be rejected.

> +		/*
> +		 * Division is used to calculate nr_zones for both power_of_2
> +		 * and non power_of_2 zone sizes as it is not in the hot path.
> +		 */

Shouldn't the above comment be moved to the patch description? I'm not 
sure whether having such a comment in the source code is valuable.

> +static inline sector_t blk_queue_offset_from_zone_start(struct request_queue *q,
> +							sector_t sec)
> +{
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	u64 remainder = 0;
> +
> +	if (!blk_queue_is_zoned(q))
> +		return false;

"return false" should only occur in functions returning a boolean. This 
function returns type sector_t.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

