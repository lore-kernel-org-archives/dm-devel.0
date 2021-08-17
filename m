Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830A8C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 17:15:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D3CF860FD9
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 17:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D3CF860FD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-pQBvFtZ4PV-EaJxSmC_5Rg-1; Tue, 17 Aug 2021 13:15:04 -0400
X-MC-Unique: pQBvFtZ4PV-EaJxSmC_5Rg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 865BD100CA94;
	Tue, 17 Aug 2021 17:14:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67E2F5D6AD;
	Tue, 17 Aug 2021 17:14:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CBD4C4BB7C;
	Tue, 17 Aug 2021 17:14:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17HHEimL026458 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Aug 2021 13:14:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C4AE1D1E80; Tue, 17 Aug 2021 17:14:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD60839D8D
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 17:14:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75257800B28
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 17:14:38 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
	[209.85.216.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-166-PtkRMP-fMCGyQDZ6ShxiqA-1; Tue, 17 Aug 2021 13:14:33 -0400
X-MC-Unique: PtkRMP-fMCGyQDZ6ShxiqA-1
Received: by mail-pj1-f48.google.com with SMTP id
	fa24-20020a17090af0d8b0290178bfa69d97so7451944pjb.0; 
	Tue, 17 Aug 2021 10:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=v2ezKXtmZ+KjzYhpA8Y6VRyR3KOD/971FoOogNR18Hs=;
	b=ReKbdpUexsNm7WrsRQ8qINiNhVRm2DUQC7zqiQX4Norl9uofvm/f6HlrJs7rJcpGVJ
	Lev9LPmP0hBF4D7ev92o/xeEUh2eQPhYxsPdVDFKoM9NrsdbqjVyxNSnh2ya5p1Sg4vt
	Y8VE0MFQOnWXnCWdMpEw0wKI0WtTyOLglLl53STRrrB5wirFpCCGlmysDWYzlSbzfV2t
	HzMmWVqmAZJg5M3qb/tUdo02VMoO0Ic6n9WVLDtM+HNYAWmN92g+FJYMw5jDNYN8hPtY
	UGF4bNgkRrAagcbW7/hvLSD1Vqc2ZN9uD9ca8WRWwH1vbD9yYg0OztKEpDegT7I1y7td
	YHUQ==
X-Gm-Message-State: AOAM5326GGs9N9ZgzPRdahdOktguPWDoRxUkjDg64elFZXv/VAU7Vp4F
	z3ZTBIFNYw5IWd/+sKXQPzg=
X-Google-Smtp-Source: ABdhPJxyRl0ks4xxfdYxuKBl/CqSpHH1tc/kfe77IZhXj/2ic6tgtgAm7bavNRKoa2tEHngKC7nW9Q==
X-Received: by 2002:a17:90a:3b4b:: with SMTP id
	t11mr4532753pjf.182.1629220470271; 
	Tue, 17 Aug 2021 10:14:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:201:ae3f:1e44:e6d0:4a44])
	by smtp.gmail.com with ESMTPSA id
	x13sm2822931pjh.30.2021.08.17.10.14.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 17 Aug 2021 10:14:29 -0700 (PDT)
To: SelvaKumar S <selvakuma.s1@samsung.com>, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
	<CGME20210817101758epcas5p1ec353b3838d64654e69488229256d9eb@epcas5p1.samsung.com>
	<20210817101423.12367-4-selvakuma.s1@samsung.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <ad3561b9-775d-dd4d-0d92-6343440b1f8f@acm.org>
Date: Tue, 17 Aug 2021 10:14:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817101423.12367-4-selvakuma.s1@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	djwong@kernel.org, dm-devel@redhat.com, hch@lst.de,
	agk@redhat.com, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, willy@infradead.org,
	nj.shetty@samsung.com, kch@kernel.org, selvajove@gmail.com,
	mpatocka@redhat.com, javier.gonz@samsung.com, kbusch@kernel.org,
	axboe@kernel.dk, damien.lemoal@wdc.com, joshi.k@samsung.com,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-api@vger.kernel.org, johannes.thumshirn@wdc.com,
	linux-fsdevel@vger.kernel.org, joshiiitr@gmail.com, asml.silence@gmail.com
Subject: Re: [dm-devel] [PATCH 3/7] block: copy offload support
	infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/17/21 3:14 AM, SelvaKumar S wrote:
> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> bio with control information as payload and submit to the device.
> Larger copy operation may be divided if necessary by looking at device
> limits. REQ_OP_COPY(19) is a write op and takes zone_write_lock when
> submitted to zoned device.
> Native copy offload is not supported for stacked devices.

Using a single operation for copy-offloading instead of separate 
operations for reading and writing is fundamentally incompatible with 
the device mapper. I think we need a copy-offloading implementation that 
is compatible with the device mapper.

Storing the parameters of the copy operation in the bio payload is 
incompatible with the current implementation of bio_split().

In other words, I think there are fundamental problems with this patch 
series.

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

