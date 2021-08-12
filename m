Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C66C432BE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5256F610CD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 06:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5256F610CD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=corelight.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-irv-eaH9NhyI0w2IiG4EOA-1; Fri, 13 Aug 2021 02:41:23 -0400
X-MC-Unique: irv-eaH9NhyI0w2IiG4EOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60881008064;
	Fri, 13 Aug 2021 06:41:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 836EF1036D05;
	Fri, 13 Aug 2021 06:41:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2FBDF181A100;
	Fri, 13 Aug 2021 06:41:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CJlnCV013876 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 15:47:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8CDFC11FC6B; Thu, 12 Aug 2021 19:47:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 883C211F4CC
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 19:47:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A664802700
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 19:47:46 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
	[209.85.128.48]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-87-GF5MXV-wODe8sLGMyU7pfQ-1; Thu, 12 Aug 2021 15:47:44 -0400
X-MC-Unique: GF5MXV-wODe8sLGMyU7pfQ-1
Received: by mail-wm1-f48.google.com with SMTP id f10so2210171wml.2
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 12:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
	:references:mime-version;
	bh=4yVVGSubGIAUjMvYqinX3dOobTEZJ/iEvN/MAz4QKJE=;
	b=J7ugW88OqTkyA1WCVs90sUvvIJKRJ3dOQKK4mwno7vA//9P8VqJ4hhTKKoFPzldZ97
	cBNsvn/jh+EfiQ+IEkQ4plDv79dNtC0GyzS1bczIv4RKx0Jqd/0RFZ+koUX9Igi8VDrF
	kiwue92wyEm/7sKsbIEyh4k2a28v7kvTtDoAQNcRe4liJX+pgbPvYGvykVERRP93V/Mv
	OSukiZXKc/VqOkroWgWZ9ED4cP/rUTkilQu7ZD84eqqvBDHervUnsljvEMABvDgpqT18
	SvQPc0fMjFW9rZaxMDmUjHSPCRxT+4UNmuiZJIC+zQ1YIXrQvDjSskOjLBAMxDMeu5+3
	8rPg==
X-Gm-Message-State: AOAM5305p231/mygMPvDr02E9dyoWhh6YsUao/A1R2ZhhM3fKmTjlKJo
	zJ6V8yBws5VnJLTv/3s3s1iHZFy6LfXNsDRp
X-Google-Smtp-Source: ABdhPJxNVjkpAjnzz5UjbfS4wJEc64a2YdkvYd2C7720q3Wixp8ZPHcyKINHebBS9SpwNcmn8cLfKg==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id
	l15mr223608wmq.106.1628797662888; 
	Thu, 12 Aug 2021 12:47:42 -0700 (PDT)
Received: from tinkyx280 ([2a02:8108:8440:5da4:6c41:9e8b:2e76:271])
	by smtp.gmail.com with ESMTPSA id k6sm3977149wrm.10.2021.08.12.12.47.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 12 Aug 2021 12:47:42 -0700 (PDT)
Date: Thu, 12 Aug 2021 21:47:41 +0200 (CEST)
From: Arne Welzel <arne.welzel@corelight.com>
To: Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2108101420250.26585@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <39101295-ed12-33c1-ce1-86a649f5582@corelight.com>
References: <20210808134205.1981531-1-arne.welzel@corelight.com>
	<alpine.LRH.2.02.2108101420250.26585@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
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
X-Mailman-Approved-At: Fri, 13 Aug 2021 02:36:56 -0400
Cc: dm-crypt@saout.de, dm-devel@redhat.com, DJ Gregor <dj@corelight.com>,
	agk@redhat.com, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] dm crypt: Avoid percpu_counter spinlock
 contention in crypt_page_alloc()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mikulas,

On Tue, 10 Aug 2021, Mikulas Patocka wrote:

> Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
>

thank you for the review. After looking at the submitted patch again,
seems more proper to use >= as the condition:

> > + if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) > dm_crypt_pages_per_client) &&
                                                                        ^^
                                                                        >=
Would it be okay if I resend the patch with this changed and add your
Reviewed-by still? Would also fix some wording in the description and
dedent the perf report output somewhat.

Thanks,
   Arne

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

