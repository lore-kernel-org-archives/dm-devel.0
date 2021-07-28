Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E551C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 01:31:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B283660F41
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 01:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B283660F41
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-hcrA_ddUNwOEmR-NBoJw9A-1; Tue, 27 Jul 2021 21:31:55 -0400
X-MC-Unique: hcrA_ddUNwOEmR-NBoJw9A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45CF4107B7E5;
	Wed, 28 Jul 2021 01:31:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA7F19D9D;
	Wed, 28 Jul 2021 01:31:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A607618005A2;
	Wed, 28 Jul 2021 01:31:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16S1VgE2006574 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 21:31:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F1D2E2044716; Wed, 28 Jul 2021 01:31:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC9972049CD7
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 01:31:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB395101A54C
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 01:31:38 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
	[209.85.214.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-7-UEDqsFG5PN6YLfHthzParw-1; Tue, 27 Jul 2021 21:31:36 -0400
X-MC-Unique: UEDqsFG5PN6YLfHthzParw-1
Received: by mail-pl1-f176.google.com with SMTP id a20so807306plm.0
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 18:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=yHc64D7GeFGFvPKcL3/klEXdsXGAyEbOGkW4X7dqYZk=;
	b=qEETDb5F31iQ8QcM6LWmM98yB2uGAJz7mVYiEqVo7dw2nZ2s3brFvAw0EQDybiYrFI
	CVrsDWc7NU1/Tr3JzOIK9J8Fj59WRj4zwTf06Oi0ww/OQy/NQGn98Sbjl5ARxvTtAsZt
	shQ12Ukpx45zGHQTRut1CEabylCa/HMgSSABwF4JGusipfwZoIP3CTf/ghy6hmF7F4VR
	DJFfUDyQiXH+aM5qgDycWZnOBH7i4+PuulnyYdjZ3jtyVpAihYf0fQ8gOnqoz6QyYIFM
	b3AvKcRR2pOGdN6T6NMHpWk3m86MntxvyjY7crBj5JA6B6BX67oWPgFYuWtoQgyu4bPU
	qdOw==
X-Gm-Message-State: AOAM532AkPqa+53OupuDc+NxpVQ1Wctbw+RepG40c1cz9tSAbEq9Zqy9
	d4WoUiusm775UZ/Fnama17r9Pg==
X-Google-Smtp-Source: ABdhPJzWMYJQkYrSLemCw68WHvxxx2yrrdVHcAiwavOx0x2TeSqkNy6ZylLwTbIdJTyjO+rAuqNUqw==
X-Received: by 2002:a62:b414:0:b029:317:52d:7fd5 with SMTP id
	h20-20020a62b4140000b0290317052d7fd5mr25840599pfn.30.1627435895354;
	Tue, 27 Jul 2021 18:31:35 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
	by smtp.gmail.com with ESMTPSA id
	a16sm5054336pfo.66.2021.07.27.18.31.32
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 27 Jul 2021 18:31:34 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>
References: <20210727055646.118787-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <eba0b98f-5b0e-32c4-3b09-fa1946192517@kernel.dk>
Date: Tue, 27 Jul 2021 19:31:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210727055646.118787-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-arch@vger.kernel.org, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	Ira Weiny <ira.weiny@intel.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [dm-devel] switch the block layer to use kmap_local_page v3
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/26/21 11:56 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the core block layer code and all users of the
> existing bvec kmap helpers to use kmap_local_page.  Drivers that
> currently use open coded kmap_atomic calls will converted in a follow
> on series.
> 
> To do so a new kunmap variant is added that calls
> flush_kernel_dcache_page.  I'm not entirely sure where to call
> flush_dcache_page vs flush_kernel_dcache_page, so I've tried to follow
> the documentation here, but additional feedback would be welcome.
> 
> Note that the ps3disk has a minir conflict with the
> flush_kernel_dcache_page removal in linux-next through the -mm tree.
> I had hoped that change would go into 5.14, but it seems like it is
> being held for 5.15.

Applied for 5.15, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

