Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8420DC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 02:26:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B49B064E83
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 02:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B49B064E83
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-StxFwKLTPZ2YS-dV_D2HZw-1; Tue, 23 Feb 2021 21:26:50 -0500
X-MC-Unique: StxFwKLTPZ2YS-dV_D2HZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C15B80196E;
	Wed, 24 Feb 2021 02:26:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C818C5D6A1;
	Wed, 24 Feb 2021 02:26:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41F7E4E58E;
	Wed, 24 Feb 2021 02:26:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O2QeeC005851 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 21:26:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 58439200BFFC; Wed, 24 Feb 2021 02:26:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52D0A2126C9E
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 02:26:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EB4F1022F09
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 02:26:38 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
	[209.85.214.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-61-J7jcjs7jPCSxc9y9cxQGWQ-1; Tue, 23 Feb 2021 21:26:36 -0500
X-MC-Unique: J7jcjs7jPCSxc9y9cxQGWQ-1
Received: by mail-pl1-f171.google.com with SMTP id d11so250984plo.8
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 18:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
	b=Bz/3CqMOTu4XQ+6k2P6vMZXI4TEYIyhXpBJ1RN/Y8BGFUwrNG43GErbnxTvkVdrrA8
	wEb5648566kIgiX1D7ga8Vjxd53sTwCsjX072NKba1j6fIWVi8YN9Nmxb8uALEzg+N7r
	dgbZ7yOXtvoHE4qIV3Kw3FoqvfkuZ8wTUTqwfzRk5IOUa+Bd/2u6XuHcqpIalddPCtUN
	MVKDiF6xaoV/pyKIYZHUhl43AZVoe562MgD0KiUjOHdkeAzxZBUWNj5kAXJou/OkLzUq
	M8M+XHSIcZvMaM0/rCqb/abncnn187ou4AAtjSHfO/C+NDGWQFxHGm/z3IwRLFaeGdKt
	+5/A==
X-Gm-Message-State: AOAM530beVwc3QEbkFaTebQZmqoe/IxMEfld6cMfu6EydwOWmEGL85aw
	e2XAqmPbroqR1/VRYGj32CnDN6weI/j4eQ==
X-Google-Smtp-Source: ABdhPJyR3nz4/2Xe5wJThbH4JmwtF3FCVmv1vow0MEov3q6812/SA95OV/EDU86jIg7awO+mA89rHA==
X-Received: by 2002:a17:902:ec83:b029:e3:ec1f:9dfe with SMTP id
	x3-20020a170902ec83b02900e3ec1f9dfemr15422462plg.59.1614133595027;
	Tue, 23 Feb 2021 18:26:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
	by smtp.gmail.com with ESMTPSA id z11sm309175pgc.6.2021.02.23.18.26.34
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 23 Feb 2021 18:26:34 -0800 (PST)
To: Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>
References: <alpine.LRH.2.02.2102221312070.5407@file01.intranet.prod.int.rdu2.redhat.com>
	<YDSwyrLeiP/fKgZH@T590>
	<alpine.LRH.2.02.2102231125170.27597@file01.intranet.prod.int.rdu2.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <20807c3a-5d44-4f90-4d73-c1cfab251b18@kernel.dk>
Date: Tue, 23 Feb 2021 19:26:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102231125170.27597@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
	Marian Csontos <mcsontos@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2] blk-settings: make sure that max_sectors
 is aligned on "logical_block_size" boundary
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

