Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A98DC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 16:50:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-OAuT6Ns_MbWNwfUhsJNRjg-1; Tue, 03 May 2022 12:50:49 -0400
X-MC-Unique: OAuT6Ns_MbWNwfUhsJNRjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D3713806709;
	Tue,  3 May 2022 16:50:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D4B240CFD19;
	Tue,  3 May 2022 16:50:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D10141947049;
	Tue,  3 May 2022 16:50:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A8F31947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 16:50:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FB9E15392F6; Tue,  3 May 2022 16:50:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BF07153AD12
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:50:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84070801E67
 for <dm-devel@redhat.com>; Tue,  3 May 2022 16:50:44 +0000 (UTC)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-2wePg4CYPLq4sMrJtphIOQ-1; Tue, 03 May 2022 12:50:42 -0400
X-MC-Unique: 2wePg4CYPLq4sMrJtphIOQ-1
Received: by mail-oi1-f176.google.com with SMTP id z8so18782104oix.3;
 Tue, 03 May 2022 09:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=XGyhawv5lvAz+jR7b+4J1tPg3EThTh3JtzLNgN/2cvM=;
 b=lYD3C+MSLCY9zGgyDHUW3sPMzGcTaNJ222Cy7VTs8I5XH0gLt7leF6sOcKHjBvE0vj
 lLHZi+VrYKkH/6210Eo6iuaJcXI2HRTh629++zvhnvKsYo4KxXa9fwzE+WR5W8KqZsr5
 sQKgeZJtLd7W2q+mrlIJPkLilnLtD3m/CnkY6yzy+nivnGBiJM/ToNe31PtnjbLUQrDn
 RRLIYpthm1Ar4I516zoHZrV9fB/NVNL02ZuHqIb3KAw7OmmcdwdxZIOq85kmpAJPGkRY
 VdqzKZXBO65IYG0ooEIQCBUz9O5iZ9oT0s4CastI/6L0uuwWEF82iTTs/ii29swxdVsI
 EDbw==
X-Gm-Message-State: AOAM531MmLavx/P1a7osl4fHmvvDBcdhfOCxcIEKJHHkF7onJol9TePe
 tZ+z7gAFQZw3bxzdSbJ3f9I=
X-Google-Smtp-Source: ABdhPJy1OCeyAd/qiMByFFTTxHMId2iF4W5yKbLjTMlEc1yur0rFxDRZF7LK/3VXrAqw2kuZPRsPmQ==
X-Received: by 2002:a05:6808:2126:b0:325:c9f5:46e1 with SMTP id
 r38-20020a056808212600b00325c9f546e1mr2356270oiw.239.1651596641690; 
 Tue, 03 May 2022 09:50:41 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
 by smtp.gmail.com with ESMTPSA id
 v15-20020a4ae6cf000000b0035eb4e5a6cdsm5044278oot.35.2022.05.03.09.50.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 09:50:40 -0700 (PDT)
Message-ID: <1e3afa38-0652-0a6a-045c-79a0b9c19f30@acm.org>
Date: Tue, 3 May 2022 09:50:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, damien.lemoal@opensource.wdc.com,
 dsterba@suse.com, johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224@eucas1p1.samsung.com>
 <20220427160255.300418-6-p.raghav@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220427160255.300418-6-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 05/16] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/27/22 09:02, Pankaj Raghav wrote:
> -	sector &= ~(ns->zsze - 1);
> +	sector = rounddown(sector, ns->zsze);

The above change breaks 32-bit builds since ns->zsze is 64 bits wide and 
since rounddown() uses the C division operator instead of div64_u64().

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

