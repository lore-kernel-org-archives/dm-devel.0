Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBACC433DB
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:37:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CF00464E28
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:37:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF00464E28
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-u8kFMIsBPAKyl8riL9BasQ-1; Wed, 03 Mar 2021 19:37:46 -0500
X-MC-Unique: u8kFMIsBPAKyl8riL9BasQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44587100728F;
	Thu,  4 Mar 2021 00:37:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6108A6F7E8;
	Thu,  4 Mar 2021 00:37:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B23C418095CB;
	Thu,  4 Mar 2021 00:37:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1240bYRS010659 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 19:37:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C9686157E92B; Thu,  4 Mar 2021 00:37:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C57B9157E92A
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 00:37:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E914C85A5A6
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 00:37:31 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
	[209.85.215.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-566-hDKwmxA6MmultY2IL9V8KA-1; Wed, 03 Mar 2021 19:37:30 -0500
X-MC-Unique: hDKwmxA6MmultY2IL9V8KA-1
Received: by mail-pg1-f170.google.com with SMTP id b21so17652980pgk.7
	for <dm-devel@redhat.com>; Wed, 03 Mar 2021 16:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=3lw4xYsAYM4nNGD3pp839+oyNk5fzKw4o00Jp0gKL3g=;
	b=rrp29EuvdrTmJMZVh3TwdXOCSwtjU9ziZBH789+QPSoq1RTjO9Re4E2P1z8MCDWydm
	pVJqQ7MnUKhPqyLfA73RJWAFRqck37ICPu2KlR+lc8HOpgksH6J3Oi5ej5nowL+e57j8
	k8Z1qWGVcagCVAzpAvVT8lq3wVax6l1UwyMW56kMyXo1aH/X4cfwjg3Hvtc/ZxRGQL9L
	mlF5dvzvTnnVbU9iljySMbv5H453p8mqQ0rBxo0ZXCnUlXEO6Pt5EVuoh5BQu9BqwbWX
	OFLRS/Aw6UhE7WyMLYAzUyADfu2gjT70zhTGKQDR714olFtD7O8YubAEgNvl908vFVZY
	74ew==
X-Gm-Message-State: AOAM533q9NVdgKYrv5l0ly5DCPTBHQZW+OrxAz70rfbXdk+Dx52EPiBC
	LlBQ6l1oQ0uKnbX267O8LK9V6A==
X-Google-Smtp-Source: ABdhPJwMGv3OcuecvAWs+zF2L0Hj4jwyck66kQjBzy0EQ4mvd/le2HXi8XyCGl94ffMOcSh1fbFt7Q==
X-Received: by 2002:a63:4442:: with SMTP id t2mr1309496pgk.23.1614818248751;
	Wed, 03 Mar 2021 16:37:28 -0800 (PST)
Received: from ?IPv6:2600:380:7540:52b5:3f01:150c:3b2:bf47?
	([2600:380:7540:52b5:3f01:150c:3b2:bf47])
	by smtp.gmail.com with ESMTPSA id
	e10sm8019732pgd.63.2021.03.03.16.37.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 03 Mar 2021 16:37:28 -0800 (PST)
To: Mikulas Patocka <mpatocka@redhat.com>,
	JeffleXu <jefflexu@linux.alibaba.com>, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, caspar@linux.alibaba.com,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210302190551.473015400@debian-a64.vm>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8424036e-fba9-227e-4173-8f6d05562ee3@kernel.dk>
Date: Wed, 3 Mar 2021 17:37:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210302190551.473015400@debian-a64.vm>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/4] block: introduce a function
 submit_bio_noacct_mq_direct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/2/21 12:05 PM, Mikulas Patocka wrote:

There seems to be something wrong with how this series is being sent
out. I have 1/4 and 3/4, but both are just attachments.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

