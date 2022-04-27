Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC536C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 23:53:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-DCffRQ3hNs6CkH93SLgxWg-1; Wed, 27 Apr 2022 19:53:16 -0400
X-MC-Unique: DCffRQ3hNs6CkH93SLgxWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF75F3C0E18E;
	Wed, 27 Apr 2022 23:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 939BAC27DB3;
	Wed, 27 Apr 2022 23:53:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E1151947046;
	Wed, 27 Apr 2022 23:53:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F8861947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 23:53:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8007014C26A4; Wed, 27 Apr 2022 23:53:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C58C14C26A0
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:53:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63539185A7A4
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:53:07 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-bzkMMOVZPEq8PaPKH9T5Vg-1; Wed, 27 Apr 2022 19:53:04 -0400
X-MC-Unique: bzkMMOVZPEq8PaPKH9T5Vg-1
Received: by mail-pf1-f177.google.com with SMTP id t13so2856523pfg.2;
 Wed, 27 Apr 2022 16:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=79AFRdpemBVck+ntzsW/yKNt4PCLDqnjtmYL3oWIWPs=;
 b=jrrxEeHxHfD5Ja3/JJbFpfZ4mW5sMNhwsepOF3usKjQdELA3NaCELs9ZlgK/rpTRgP
 u8XYhgA1ZkT2mMr2UQSM59VKM0Xavp3BkZGO+QMp1/jmeCpmBEpvhhqSjnZfl6K04Z0P
 mtdCCMRF3189NewHH2fIFL7gaYULil20GB4Ht7qIWFbw+3PdRFIvQbxq4Cj3fzkTMWUc
 OVPUNjKUFeGY0CtpZeABPkEgBQj84Ay4qSX7I8EwQGyRhX64mF4/9aaVVAk2GniyjMj7
 k5i4Rsqc4vjsfPi8OQhNNNYV5WjMyYCeD7sq1leOiKcm3cX53QWq6Y7eu2Zz9CRijkFl
 6oqA==
X-Gm-Message-State: AOAM531OBLSld9+tgkxqB2WY042I1m5ZkZ1kKD/kO2Dhn09q/XF8pVG4
 3ZpEbFq9GDcoz/jw5tRCJDE=
X-Google-Smtp-Source: ABdhPJwSGv1Za1U51Sy0XzpwyxC0M8/mR/bjHPIzXDoe+MDiEfgeZRKytqp5jH37HlZvkYhAFK/M7Q==
X-Received: by 2002:a05:6a00:a94:b0:4fd:c14b:21cb with SMTP id
 b20-20020a056a000a9400b004fdc14b21cbmr32159218pfl.53.1651103583186; 
 Wed, 27 Apr 2022 16:53:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6cbb:d78e:9b3:bb62?
 ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
 by smtp.gmail.com with ESMTPSA id
 w129-20020a628287000000b0050d4246fbedsm11710895pfd.187.2022.04.27.16.53.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Apr 2022 16:53:02 -0700 (PDT)
Message-ID: <df8104aa-ca86-4053-5334-3bc4ff786c61@acm.org>
Date: Wed, 27 Apr 2022 16:52:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160258eucas1p19548a7094f67b4c9f340add776f60082@eucas1p1.samsung.com>
 <20220427160255.300418-3-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 02/16] block: add blk_queue_zone_aligned and
 bdev_zone_aligned helper
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/27/22 09:02, Pankaj Raghav wrote:
> +static inline bool bdev_zone_aligned(struct block_device *bdev, sector_t sec)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return blk_queue_zone_aligned(q, sec);
> +	return false;
> +}

Which patch uses this function? I can't find any patch in this series 
that introduces a call to this function.

Thanks,

Bart.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

