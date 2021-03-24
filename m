Return-Path: <SRS0=Kq+o=IW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56B9C433C1
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:43:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0DFB460240
	for <dm-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFB460240
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-1bhnPR91MVW5gpPn2Pyy8Q-1; Wed, 24 Mar 2021 11:43:41 -0400
X-MC-Unique: 1bhnPR91MVW5gpPn2Pyy8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCF6E1927801;
	Wed, 24 Mar 2021 15:43:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 926A75C230;
	Wed, 24 Mar 2021 15:43:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3090C1809C83;
	Wed, 24 Mar 2021 15:43:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12OFhWbf030448 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Mar 2021 11:43:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BB20321CAC6D; Wed, 24 Mar 2021 15:43:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B59AF21CAC6C
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 15:43:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF0793673A
	for <dm-devel@redhat.com>; Wed, 24 Mar 2021 15:43:29 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
	[209.85.210.176]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-42-304a0cLJM8eSWHdYn-uS1g-1; Wed, 24 Mar 2021 11:43:23 -0400
X-MC-Unique: 304a0cLJM8eSWHdYn-uS1g-1
Received: by mail-pf1-f176.google.com with SMTP id q5so17606559pfh.10;
	Wed, 24 Mar 2021 08:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=QggucVUwSzig6GMS5zGAfRIs6DTm/Z/TqSfdC+FdYj4=;
	b=BKK1KPc4AvGbXbGPDpOtnu4JFYPBJT7Mz4NTcrwc8hvtbAq6pxX1pxIJJj1MDq5YwA
	6bHIqsZTGwT7xn3TzLYrPER5GMbR7/oK7vEUAomaNxbbybWXXF4NLv2YBnBLmI5LBygI
	pH4IuXKNUxj2JHOMaX695G9fzca+OBYZax1H61F8OdXwrMg1r/loSXV6MmzgW1yedSSd
	h988nBGSDaYU2wDsHVhNGqVwHOleRMb/I5xuAG/RuRt18sYM4KC5wWg8FjGaPNP/QHe6
	prvD0AWPfoLya1bWXYDj/PyiqBEwOzQUOBaYz6NxhBahL2tfFdwKyPlbBSDCdIJgTlnp
	5S1g==
X-Gm-Message-State: AOAM530GqBLHKFpq+XPNNs2q6n4OX+1s7Eo42gYGJ4pT0Ae+XKJLURad
	495Q3DPkPwlCnfk8tr00Uen702Qly0g=
X-Google-Smtp-Source: ABdhPJzY590vZ7RjrvvjVHPdylv4paVDI2xrLYyTvKklWkN770EUwLBBPU8PIiuD9xG2KyBtvIWaOQ==
X-Received: by 2002:a63:4441:: with SMTP id t1mr3645875pgk.124.1616600601382; 
	Wed, 24 Mar 2021 08:43:21 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:3b29:de57:36aa:67b9?
	([2601:647:4802:9070:3b29:de57:36aa:67b9])
	by smtp.gmail.com with ESMTPSA id
	y24sm2923614pfn.213.2021.03.24.08.43.20
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 24 Mar 2021 08:43:20 -0700 (PDT)
To: Ming Lei <ming.lei@redhat.com>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
	<522a2c87-e9f3-e62a-e09b-084821c698a0@grimberg.me>
	<YFnYhBIiFhiyX8Wb@T590>
	<713f2a27-4a2c-8723-3dfd-de6d68956eb2@grimberg.me>
	<YFqDXeEsDNBfoWqW@T590>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <86cdc9a2-9640-9625-0741-e43f0ad40250@grimberg.me>
Date: Wed, 24 Mar 2021 08:43:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YFqDXeEsDNBfoWqW@T590>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 09/13] block: use per-task poll
 context to implement bio based io poll
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


>> Well, when it will failover, it will probably be directed to the poll
>> queues. Maybe I'm missing something...
> 
> In this patchset, because it isn't submitted directly from FS, there
> isn't one polling context associated with this bio, so its HIPRI flag
> will be cleared, then fallback to irq mode.

I think that's fine for failover I/O...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

