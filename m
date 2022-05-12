Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D997C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 17:22:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-1Vg96N72MROE_i8IT9hC3Q-1; Thu, 12 May 2022 13:22:33 -0400
X-MC-Unique: 1Vg96N72MROE_i8IT9hC3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78396395AFEA;
	Thu, 12 May 2022 17:22:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 651857AE3;
	Thu, 12 May 2022 17:22:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2546D1947058;
	Thu, 12 May 2022 17:22:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7B9F194704A
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 17:22:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86C4814A5683; Thu, 12 May 2022 17:22:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82F0D14A5680
 for <dm-devel@redhat.com>; Thu, 12 May 2022 17:22:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B4992949BDE
 for <dm-devel@redhat.com>; Thu, 12 May 2022 17:22:29 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-aJIafSZMNVODJfTTySV7fA-1; Thu, 12 May 2022 13:22:27 -0400
X-MC-Unique: aJIafSZMNVODJfTTySV7fA-1
Received: by mail-pj1-f51.google.com with SMTP id
 iq2-20020a17090afb4200b001d93cf33ae9so8436525pjb.5; 
 Thu, 12 May 2022 10:22:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=5EH2eizEJHj786C4i7iVooWJ/uE/QSj7BBR5bCHBing=;
 b=lF7jbzs+tNBgiJYEwGRdpyeKELehRICZsUSKoJJvGNzUMY9c8NjV3SkL+64Ozjdh6a
 uawJYmeKd1FiI9hh1zlybKPE2qPzdyNTq+Wck4lnzLuI8/mcJbCIUp1XapS0Ybf4OmqL
 g0lgLCDpC54QCsRPTUsEIfwTZY4HBoT/JA0K3DpCD40DB991qUloPxk24eIuniaCqOc1
 H+TKiyVSi5wldHZl4L/nM2j0FNU2xdu0KtChtGtCq9BgZg7bOeesHwtRIfCeCJLHhV1E
 qvh1N01D2KoPJaF33F/ZTs5P3ebyI2SbIEgO28Ne28dRiEsDzMKWnhY8qQfLno7g2SdC
 0/fg==
X-Gm-Message-State: AOAM533weTVp4AMPoh/2tjETzo2qPcZCmagNT/k1QguFcia+kGuig5AC
 1H2kJ63Aa/OCTGfiB04RNb8=
X-Google-Smtp-Source: ABdhPJygkMTlAbNp9soO/418oUT6tIypetUTVmiczgfvtfjDYTiV1B21f/kf4VZ7nutFi/2LHDujOg==
X-Received: by 2002:a17:903:230e:b0:15e:ce57:d66f with SMTP id
 d14-20020a170903230e00b0015ece57d66fmr874623plh.35.1652376146314; 
 Thu, 12 May 2022 10:22:26 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:78c5:5d65:4254:a5e?
 ([2620:15c:211:201:78c5:5d65:4254:a5e])
 by smtp.gmail.com with ESMTPSA id
 d2-20020a170902cec200b0015e8d4eb2ddsm121808plg.295.2022.05.12.10.22.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 12 May 2022 10:22:25 -0700 (PDT)
Message-ID: <b14775a9-da39-f26a-fa46-b0b1b789c30e@acm.org>
Date: Thu, 12 May 2022 10:22:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, jaegeuk@kernel.org,
 hare@suse.de, dsterba@suse.com, axboe@kernel.dk, hch@lst.de,
 snitzer@kernel.org
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081116eucas1p2cce67bbf30f4c9c4e6854965be41b098@eucas1p2.samsung.com>
 <20220506081105.29134-11-p.raghav@samsung.com>
 <39a80347-af70-8af0-024a-52f92e27a14a@opensource.wdc.com>
 <aef68bcf-4924-8004-3320-325e05ca9b20@samsung.com>
 <9eb00b42-ca5b-c94e-319d-a0e102b99f02@opensource.wdc.com>
 <9f1385a3-b471-fcd9-2c0c-61f544fbc855@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9f1385a3-b471-fcd9-2c0c-61f544fbc855@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v3 10/11] null_blk: allow non power of 2
 zoned devices
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
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
 gost.dev@samsung.com, Josef Bacik <josef@toxicpanda.com>,
 linux-nvme@lists.infradead.org, jiangbo.365@bytedance.com,
 Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 linux-btrfs@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 jonathan.derrick@linux.dev, linux-fsdevel@vger.kernel.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Johannes Thumshirn <jth@kernel.org>,
 Keith Busch <kbusch@kernel.org>, matias.bjorling@wdc.com,
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

On 5/9/22 04:56, Pankaj Raghav wrote:
> Even though I am not sure if this optimization will directly add value
> looking at my experiments with the current change, I can fold this in
> with a comment on top of zone_size_sect_shifts variable stating that
> size can be npo2 and this variable is only meaningful for the po2 size
> scenario.

Have these experiments perhaps been run on an x86_64 CPU? These CPUs 
only need a single instruction to calculate ilog2(). No equivalent of 
that instruction is available on ARM CPUs as far as I know. I think the 
optimization Damien proposed will help on ARM CPUs.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

