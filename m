Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D069C41513
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 21:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691790988;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=51i2huhicfttqBx7X/k318jOSEm0x2goS5X10rI1Y2o=;
	b=BpGyyGWstKoYHgZRoKrnQn4P0hcZ97f1BT/tgzpT/fSPdFu9xJV9dhnsGeWrouS2sECHQD
	nmG/3QpzPduXBEeumT0/HvDFTAzNeM3nDqAHrkewXN4Rbt5mytdJJJCxZJYoEbvyhkKOAv
	/TFspZz/Eyqz9mJmB9Ziv/ReE7r5I2g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-zXAEOeZqP0ifNKDqyJhleA-1; Fri, 11 Aug 2023 17:56:26 -0400
X-MC-Unique: zXAEOeZqP0ifNKDqyJhleA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9E0B185A78F;
	Fri, 11 Aug 2023 21:56:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F3F62166B25;
	Fri, 11 Aug 2023 21:56:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07D341946594;
	Fri, 11 Aug 2023 21:56:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66FB6194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 21:56:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3317DC15BB8; Fri, 11 Aug 2023 21:56:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A8A9C15BAE
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:56:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DAED101A52E
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 21:56:23 +0000 (UTC)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-BqC9QahEOkapSGPo09Fr8Q-1; Fri, 11 Aug 2023 17:56:20 -0400
X-MC-Unique: BqC9QahEOkapSGPo09Fr8Q-1
Received: by mail-oi1-f176.google.com with SMTP id
 5614622812f47-3a78604f47fso2245283b6e.1; 
 Fri, 11 Aug 2023 14:56:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691790979; x=1692395779;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=prWD167naOCUGhV8W2UI57hYvdDYVXZgEtS8e+7g7BM=;
 b=NYW+4l15WFIZrs4ivXyl21oslKsBosFoj7ZJtvrzpzwBvjCv64IPrLF3aRuWBb1YQX
 fkn6iJiuy7jKZgqlFfD2sk7w4/yK3IeR6moByiXpwimaQf2FAaI0GTBTCMzt/5LJza/h
 iSKu5hH33dU7Uq8TaUK90g3dl96TsFrEAajRljTNuwU95hqhXq0MLNQLPZSs1wkZVqqC
 NkWh4iYDC0bZdeOvGgoUdUcWOPPJRpL3CoNH2bEuzpVd9f1LBAmnKlesnMr0yNfwY8+m
 TBb1ruaypVVS9L3DHImjqpxloPmRfXM21ms80vMlwuRfQYIOThrnzVDAlIyutEuEIh1/
 s47Q==
X-Gm-Message-State: AOJu0Yzij543Nbztc+zokfbuJ70fbXNTiESRrsthcMEfu+0lxCR/FnPa
 AAcLGEA/zav/mB2IfaOrs3o=
X-Google-Smtp-Source: AGHT+IFRmGiyvXV1VwlJ9tihqgTvBvrZ8iEiMT6ZbT0wpIrAxLL1zr/ocUv96iLtdTj5E+o7MmHKDw==
X-Received: by 2002:a05:6358:290f:b0:132:d07d:8f3b with SMTP id
 y15-20020a056358290f00b00132d07d8f3bmr3326632rwb.28.1691790978966; 
 Fri, 11 Aug 2023 14:56:18 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:cdd8:4c3:2f3c:adea?
 ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
 by smtp.gmail.com with ESMTPSA id
 c6-20020a17090a674600b0026b25c05495sm1808427pjm.20.2023.08.11.14.56.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Aug 2023 14:56:18 -0700 (PDT)
Message-ID: <170b68ca-b24c-0723-cc54-7fcdc9004bcc@acm.org>
Date: Fri, 11 Aug 2023 14:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105638epcas5p4db95584b6a432ea4b8b93e060a95e5f1@epcas5p4.samsung.com>
 <20230811105300.15889-2-nj.shetty@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230811105300.15889-2-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v14 01/11] block: Introduce queue limits and
 sysfs for copy-offload support
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
Cc: Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 dlemoal@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: acm.org
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/11/23 03:52, Nitesh Shetty wrote:
> +/* maximum copy offload length, this is set to 128MB based on current testing */
> +#define COPY_MAX_BYTES		(1 << 27)

Since the COPY_MAX_BYTES constant is only used in source file
block/blk-settings.c it should be moved into that file. If you really
want to keep it in include/linux/blkdev.h, a BLK_ prefix should
be added.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

