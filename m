Return-Path: <SRS0=xPb5=LF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E15C48BD1
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:56:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF1BA613D9
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF1BA613D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-aHRmge6uM3yU-YenNsmjHQ-1; Fri, 11 Jun 2021 13:56:04 -0400
X-MC-Unique: aHRmge6uM3yU-YenNsmjHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14B0F19611C7;
	Fri, 11 Jun 2021 17:55:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B65960C05;
	Fri, 11 Jun 2021 17:55:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC06A46F82;
	Fri, 11 Jun 2021 17:55:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15BHtIgF026112 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Jun 2021 13:55:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C7C921122D9; Fri, 11 Jun 2021 17:55:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 17D992111616
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 17:55:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED5C80D0E2
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 17:55:14 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
	[209.85.214.174]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-499-KnXVq9saOBCW_obs0BIdzA-1; Fri, 11 Jun 2021 13:55:12 -0400
X-MC-Unique: KnXVq9saOBCW_obs0BIdzA-1
Received: by mail-pl1-f174.google.com with SMTP id v13so3208618ple.9
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 10:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=FiCqgV8kjys+3xuqiyCwJtcf1Wj53LQ5ch2SqyLytgY=;
	b=h6l5/rczFTgvJjaOSzH8cVEujRBZGBoUepeJ/Vnu9bRJ2P+dOHowex69iWiVTo8Ebf
	PB3GGmnT4hBJMUgEsJdP31a0UAxKaQT1MnKIFgsV7c13KvYJWdKRTstgJ5CS59daOQho
	kTFoY2C1u+fhOEaMrNI0AJXiCUPWItvMFJETyp1CYUdIq5VoTBqcCwPSBCF6AfXNmznf
	sCgXTSA2pf8mOkWEuNXy7ge9/35TNkt6vs7BVsCRVyLkw5r6hgkbOJeTAL1XgpbayATz
	VloRJ9zHosHHmedNDyM9X8zD6lPJ96r9omcHhYaPC8brZFm/JtYdNdpCFeGP5fHpLbZF
	9Yvw==
X-Gm-Message-State: AOAM532PaqagDv2y8tB0KNXXTkPMFA2zWFVTqo5hW86Yt1uUynHq1Q1X
	WwUxQNVpWEp6CQ772pWsver4tw==
X-Google-Smtp-Source: ABdhPJxMGSnZ9kJAsN6p7k0McSncvftPUJip5kVUuOxTF3REguFHe02Lgz4i9/8fJhn7M2nOfjp+aA==
X-Received: by 2002:a17:90a:9481:: with SMTP id
	s1mr5656508pjo.48.1623434110978; 
	Fri, 11 Jun 2021 10:55:10 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	x3sm6384950pgx.8.2021.06.11.10.55.07
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 11 Jun 2021 10:55:10 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fa9590e3-20eb-5215-d2f7-6489169c232c@kernel.dk>
Date: Fri, 11 Jun 2021 11:55:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210602065345.355274-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Geoff Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	=?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] simplify gendisk and request_queue allocation for
 blk-mq based drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/2/21 12:53 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series is the scond part of cleaning up lifetimes and allocation of
> the gendisk and request_queue structure.  It adds a new interface to
> allocate the disk and queue together for blk based drivers, and uses that
> in all drivers that do not have any caveats in their gendisk and
> request_queue lifetime rules.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

