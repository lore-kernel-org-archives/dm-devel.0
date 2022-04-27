Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFACC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 23:54:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-bdU30P81OF6hla1Wn8ssVw-1; Wed, 27 Apr 2022 19:54:09 -0400
X-MC-Unique: bdU30P81OF6hla1Wn8ssVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82EC31C05AF7;
	Wed, 27 Apr 2022 23:54:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F7FE111D78B;
	Wed, 27 Apr 2022 23:54:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFEC71947046;
	Wed, 27 Apr 2022 23:54:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E75F1947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 23:54:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82AD4550A27; Wed, 27 Apr 2022 23:54:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E415469A4C
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:54:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6397929AA2EF
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:54:03 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-nkfnQA4bO7e27sloD0Mm7w-1; Wed, 27 Apr 2022 19:54:01 -0400
X-MC-Unique: nkfnQA4bO7e27sloD0Mm7w-1
Received: by mail-pj1-f46.google.com with SMTP id fv2so2778544pjb.4;
 Wed, 27 Apr 2022 16:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=t4qis+J9QIOKnM3fbYktt9NFhZKrRI7DhwX8G2bL9zc=;
 b=Oc3D1gxkkW+tYbmkZBGgqW5iafolxsS63UXserdpQdmyoMCPS1wTFQv6lWHUMkovjN
 Dyk7JU+Re+ss/lZ2H6Q9k1hTNZt36gtUj0HwKHspRfgxZ2nPDcQdmXSMEZgquHZsQaKi
 K+yq5jlkLYWpCqlGbDsllZgfDUQGjtMzYV60s2PB4B8dEZRpZBlGsfTM1XTUhdyCfI8O
 H2NP+WR9rkEsQiSNMi0g2S+WzLEmouGe3kTRByJUL33AMkhfeF3CE5Ia9Xq7w4RwrKwv
 fMePYAVYHj4zHqT+yqYra5Gt8gfVEoxo6fVT+kwCeP9RLCyD2Pg7HARB3CAlRlrDC6tg
 n6xg==
X-Gm-Message-State: AOAM531Xpb7VRJStEFVmwkAo1P3OQKMFhjBwaHC7EAeBLpXjiZOgY77e
 5zeiln5OZ4etSuAVe2G50nw=
X-Google-Smtp-Source: ABdhPJzohQgvyNpdAnb7nqeKJuNjp6awQ1YNHqFULIu63hwwYMU72SrE0583NaL55rzyxWBEIH5+Qg==
X-Received: by 2002:a17:902:cf0b:b0:151:9d28:f46f with SMTP id
 i11-20020a170902cf0b00b001519d28f46fmr30536375plg.53.1651103639942; 
 Wed, 27 Apr 2022 16:53:59 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6cbb:d78e:9b3:bb62?
 ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
 by smtp.gmail.com with ESMTPSA id
 p125-20020a62d083000000b0050d475ed4d2sm10860790pfg.197.2022.04.27.16.53.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Apr 2022 16:53:59 -0700 (PDT)
Message-ID: <bc18532b-a98f-26f2-4dd1-d189c0415820@acm.org>
Date: Wed, 27 Apr 2022 16:53:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160259eucas1p25aab0637fec229cd1140e6aa08678f38@eucas1p2.samsung.com>
 <20220427160255.300418-4-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 03/16] block: add bdev_zone_no helper
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/27/22 09:02, Pankaj Raghav wrote:
> +static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return blk_queue_zone_no(q, sec);
> +	return 0;
> +}

This patch series has been split incorrectly: the same patch that 
introduces a new function should also introduce a caller to that function.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

