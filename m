Return-Path: <SRS0=vJVk=ID=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCEBC433E0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 16:05:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF2DD65079
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 16:05:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF2DD65079
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-_SyHYxnVNIOjxg8CeU0isA-1; Fri, 05 Mar 2021 11:05:44 -0500
X-MC-Unique: _SyHYxnVNIOjxg8CeU0isA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815EF10866A3;
	Fri,  5 Mar 2021 16:05:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6A595C674;
	Fri,  5 Mar 2021 16:05:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA03D1809C86;
	Fri,  5 Mar 2021 16:05:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 125G5YuU009684 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Mar 2021 11:05:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDF8B2166BA2; Fri,  5 Mar 2021 16:05:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C80A82166B44
	for <dm-devel@redhat.com>; Fri,  5 Mar 2021 16:05:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FB3780A1D1
	for <dm-devel@redhat.com>; Fri,  5 Mar 2021 16:05:32 +0000 (UTC)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
	[209.85.166.170]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-267-LZA-GI8AMwWb_Aq60gJ5BA-1; Fri, 05 Mar 2021 11:05:30 -0500
X-MC-Unique: LZA-GI8AMwWb_Aq60gJ5BA-1
Received: by mail-il1-f170.google.com with SMTP id d5so2450843iln.6
	for <dm-devel@redhat.com>; Fri, 05 Mar 2021 08:05:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=dOutfGYiG2A+64OXk3o//THXPi5TUSoKfgG/x5Y+cgc=;
	b=RwWEeSazV662S/ZYl1yB0o4SJ80h0mT5suh5BrBIqyc/i9Nj6Oe7tIDMugmRBD/hzN
	Vxh0/2+lymo05Tcg2VB1zOlgXSuoSOhpQ6sI+ZdE+w17gehMkPzR66ndzmU35tLXvsAz
	hFf5pRGL8xmG3YE8pS8jq01D9nOiHC7ZDHoHMFTM82TDpHBHbQMRYl49XG+s9m3VJ+Bb
	VPdUbUe3abliGn4TUlL+yT3WYZJfh0BD9zQmt3aTG/oGxdxwsBbcV6VinNsW9zdoDpR4
	ef2I2aaE6D3pdg5CIflBiP6fvSqhH6bgP1l9q0F99gMYgHQi31Y/uJB6+zpHTRrxXyTz
	qWSg==
X-Gm-Message-State: AOAM531O/P1uj1BSzuD/lH0UEG2urGthRLsRg7obA5Er5XrQAPrODeXa
	2BI69K2G8Aj6t40qAMlqZchcY+LgzCDzbg==
X-Google-Smtp-Source: ABdhPJzv0jdG7nN+mYnWzwgQAczr0646hMx1maK6gX9UzCs8SwL7oosIal47E+i7NmfN4horO3h4Rg==
X-Received: by 2002:a05:6e02:1a6e:: with SMTP id
	w14mr9126622ilv.3.1614960329393; 
	Fri, 05 Mar 2021 08:05:29 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id
	w13sm1535763ilg.48.2021.03.05.08.05.28
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 05 Mar 2021 08:05:28 -0800 (PST)
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190551.473015400@debian-a64.vm>
	<8424036e-fba9-227e-4173-8f6d05562ee3@kernel.dk>
	<alpine.LRH.2.02.2103040511050.7400@file01.intranet.prod.int.rdu2.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0e730b1f-5b49-85f7-c5b7-2d6267c6a7ef@kernel.dk>
Date: Fri, 5 Mar 2021 09:05:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103040511050.7400@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, JeffleXu <jefflexu@linux.alibaba.com>,
	io-uring@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/21 3:14 AM, Mikulas Patocka wrote:
> 
> 
> On Wed, 3 Mar 2021, Jens Axboe wrote:
> 
>> On 3/2/21 12:05 PM, Mikulas Patocka wrote:
>>
>> There seems to be something wrong with how this series is being sent
>> out. I have 1/4 and 3/4, but both are just attachments.
>>
>> -- 
>> Jens Axboe
> 
> I used quilt to send it. I don't know what's wrong with it - if you look 
> at archives at 
> https://listman.redhat.com/archives/dm-devel/2021-March/thread.html , it 
> seems normal.

I guess the archives handle it, but it just shows up as an empty email with
an attachment. Not very conducive to review, so I do suggest you fix how
you're sending them out.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

