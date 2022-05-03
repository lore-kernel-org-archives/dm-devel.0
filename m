Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F81C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 17:02:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-uWhCVpvZPZ-wgYlBffr2Iw-1; Tue, 03 May 2022 13:02:26 -0400
X-MC-Unique: uWhCVpvZPZ-wgYlBffr2Iw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BAE71C05137;
	Tue,  3 May 2022 17:02:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B40BE463BCC;
	Tue,  3 May 2022 17:02:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BA151947049;
	Tue,  3 May 2022 17:02:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2735D1947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 17:02:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12F2840D2820; Tue,  3 May 2022 17:02:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E8A640D1B9F
 for <dm-devel@redhat.com>; Tue,  3 May 2022 17:02:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA86C86B8B3
 for <dm-devel@redhat.com>; Tue,  3 May 2022 17:02:21 +0000 (UTC)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
 [209.85.167.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-19XyRQA6Nhi1-peji5PA4w-1; Tue, 03 May 2022 13:01:50 -0400
X-MC-Unique: 19XyRQA6Nhi1-peji5PA4w-1
Received: by mail-oi1-f181.google.com with SMTP id r1so18603074oie.4;
 Tue, 03 May 2022 10:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=DRk7BATbee0He7UZ5VJP77cBX11TJXZ34BYAwZ+8AgM=;
 b=J8TpBPDJcnd7Q3McyywyLLpxQUlIqw2HpFCucbAAiN7b5gkke7Oc35ZlX0h/KKKiqF
 0FzDVvmjtdvcNpsp1vDvaNCXzf7Uzfs/o1CrcwBPgxf8kj5G/z1uyt31kT2mYSRzHiOo
 Wyz2mn3XpcNCIEQu+WmpuUZkF+26gnjnIAKpKPD+2UG2myO8fC84yZl3nk99byetAH+e
 KlKQC5WBGVVg8DNi0rPUafZRp0OqT1+oiS1DkFDXjBczTU2Ef2Dqm4O5HB32qwjtFd0H
 MqFyI+E1u9cU9JvKZp4isXRsfLDv2GSzRyt4c/Pg+NeHXxVyGTyRS0nAGds354DRmsmR
 nARg==
X-Gm-Message-State: AOAM530yIzjHiTwXl4Xxz7xOA0IkEp61IKDsgjCiuplYfSwYwsG1mhFE
 G6DWPT/Iqec6BioI97h1Ko0=
X-Google-Smtp-Source: ABdhPJzQ7nN1tdLufKhuqG6pqOb+aTzQGH1sI9Wd1lN/gZWKJGxCZu7MZvXiQsv6VotmI9tLD36qJQ==
X-Received: by 2002:a05:6808:1b10:b0:326:40f5:930c with SMTP id
 bx16-20020a0568081b1000b0032640f5930cmr840804oib.281.1651597309459; 
 Tue, 03 May 2022 10:01:49 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
 by smtp.gmail.com with ESMTPSA id
 a8-20020a4ad5c8000000b0035eb4e5a6c6sm5071917oot.28.2022.05.03.10.01.46
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 10:01:48 -0700 (PDT)
Message-ID: <1b7f3aac-0941-2554-d966-01a6bf76cc58@acm.org>
Date: Tue, 3 May 2022 10:01:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160310eucas1p28cd3c5ff4fb7a04bc77c4c0b9d96bb74@eucas1p2.samsung.com>
 <20220427160255.300418-14-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 13/16] null_blk: allow non power of 2 zoned
 devices
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
Cc: jiangbo.365@bytedance.com, kch@nvidia.com, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/27/22 09:02, Pankaj Raghav wrote:
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index c441a4972064..82a62b543782 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1931,8 +1931,8 @@ static int null_validate_conf(struct nullb_device *dev)
>   		dev->mbps = 0;
>   
>   	if (dev->zoned &&
> -	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
> -		pr_err("zone_size must be power-of-two\n");
> +	    (!dev->zone_size)) {
> +		pr_err("zone_size must not be zero\n");
>   		return -EINVAL;
>   	}

Please combine "if (dev->zoned &&" and "(!dev->zone_size)) {" into a 
single line and leave out the parentheses that became superfluous.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

