Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74054C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 17:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659547168;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yHs991S3ZhDbAHRSrWU4foOb9Hdl3476fws33aFzlN8=;
	b=JMWdS9DqNY7STiKY9xnC85cfAs3MgYAL1+AAs1WtB5kztGwBMgUQCwh/Jan8fYZMQFdaKg
	KQmk9+leX483xqFN3d4mLxukKUSWEuAu7EDcKyGlNz+JaPAuCcgIn2dZNOD9sgOQpa/DHm
	1SlF9PBp3BxAsWVBv7j2d4SN+cbvkdM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-mp49ZpBDO9KEt6bh5ncq5Q-1; Wed, 03 Aug 2022 13:19:24 -0400
X-MC-Unique: mp49ZpBDO9KEt6bh5ncq5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2991038107A4;
	Wed,  3 Aug 2022 17:19:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D288D400EA85;
	Wed,  3 Aug 2022 17:19:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D8D71926FCB;
	Wed,  3 Aug 2022 17:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63C231945DB3
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 17:18:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F2252026987; Wed,  3 Aug 2022 17:18:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B5C62026D07
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:18:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DF14909326
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 17:18:56 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-FL-5GwltMy-e8zo5YVtNBA-1; Wed, 03 Aug 2022 13:18:47 -0400
X-MC-Unique: FL-5GwltMy-e8zo5YVtNBA-1
Received: by mail-pg1-f182.google.com with SMTP id i71so10155252pge.9;
 Wed, 03 Aug 2022 10:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=TwJQ/yYNiTQ3gXYdp9ajvzFbzU+GLcBJYBbzELtb76o=;
 b=QmTPDTdHr62Fr6KmQRtkVWlePErdIxYI2XkAUFlU8sfgFiTNNrHmKpxZu+y/+rtJ5K
 IsAREjt14IBasUvEbHbxJQUZil5daKQG90z3lRODaRiWz/A6f/6lPtuf1nLB755+JRe1
 riGEZ9boAjTTmHYna4CDAf/GKXWiocbJNTKjfRfR6ThXmVmMoUZQBbeEFyaEK1PrNCiV
 mU+f30nQkRtc1o6mCcmrVVHna06wcV8tPB4OQm/C+CAkEuv5OZWGgQVMCtb6aJrmYT/o
 vwt+TjeGuoZp9Qw6gYcw/qdbVwkv+vOZbM5YFT2KoSqfVpAytkdZFzsFOivFM5A7RsZB
 wGvQ==
X-Gm-Message-State: ACgBeo0lZrchO9o/hRS1bG3LXFEyqvOqk+O8zgMNAepMLjWJmkJCzZ2W
 3L0cuiQUM5KAG88mmMENihM=
X-Google-Smtp-Source: AGRyM1ut0iw8ACYHFdssYF1RXnkAJwY8ims1WoIWh5sfrKcVetqVvRyv8YyN43reQB04YYQHCbVNEQ==
X-Received: by 2002:a05:6a00:3392:b0:52b:4896:b317 with SMTP id
 cm18-20020a056a00339200b0052b4896b317mr27047195pfb.17.1659547125023; 
 Wed, 03 Aug 2022 10:18:45 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:db71:edb7:462a:44af?
 ([2620:15c:211:201:db71:edb7:462a:44af])
 by smtp.gmail.com with ESMTPSA id
 d81-20020a621d54000000b0050dc76281f8sm3824637pfd.210.2022.08.03.10.18.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 03 Aug 2022 10:18:44 -0700 (PDT)
Message-ID: <3dd40197-776d-9003-3c8f-1791587ade0b@acm.org>
Date: Wed, 3 Aug 2022 10:18:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, damien.lemoal@opensource.wdc.com,
 agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094805eucas1p1c68ba40d319331c2c34059f966ba2d83@eucas1p1.samsung.com>
 <20220803094801.177490-4-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220803094801.177490-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v9 03/13] block: allow blk-zoned devices to
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
 dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/3/22 02:47, Pankaj Raghav wrote:
> +		if (!is_power_of_2(zone->len) && zone->capacity < zone->len) {
> +			pr_err("%s: Invalid zone capacity: %lld with non power-of-2 zone size: %lld",
> +			       disk->disk_name, zone->capacity, zone->len);

If this patch series needs to be reposted, please leave out the second 
and third colon (:) from the above error message. Once this comment has 
been addressed, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

