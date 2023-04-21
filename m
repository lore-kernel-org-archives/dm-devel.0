Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF0AC77B76
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682116589;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X+oDe867hoW/KhCBa7heUOAihG4n0gsrn7Oll2fUTO4=;
	b=PlL0Wl+LzBx4V8U38HWKNAPj36e7A3sQ3JTOlHMEb4NM93YQ3tR289xlR52M8baS1KYBz+
	3hqNdl3HXW5PKMZleHFjstxX4yLVZn7B/v3k2S6PzZ+p9cwkETOuakqA4bq51KAfepoXyX
	XV6dZRQ0q8Tsk+4x/RZsL80yaTL2mso=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-EZefDDLqOKWbf5EEGObn0A-1; Fri, 21 Apr 2023 18:36:26 -0400
X-MC-Unique: EZefDDLqOKWbf5EEGObn0A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48DF13801F6D;
	Fri, 21 Apr 2023 22:36:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F1852492B00;
	Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D05E71946A40;
	Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69D7E19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5AB342026D25; Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 52BD92026D16
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B703C0D861
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 22:36:23 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-IL2oo1gmOoqY93Oq75uBBQ-1; Fri, 21 Apr 2023 18:36:19 -0400
X-MC-Unique: IL2oo1gmOoqY93Oq75uBBQ-1
Received: by mail-pj1-f51.google.com with SMTP id
 98e67ed59e1d1-24b276ee13bso493067a91.1
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 15:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682116578; x=1684708578;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=15RShbsbHafAtkHP7bE1KcywW8eNaWBCC5WwysBd87o=;
 b=RJmwrEuxwMVzR6UKtbI9x57JRTW4dllrpsynuWRRIuY179ktxdogcduycW60HOtH7s
 d0g90uRlI9ZDSt98FxQ/CkMJxRe5iQyXojRysGINme095ZyE9g3+gCFqQu4ZqFwl22/H
 Ny3WdxTh1higNa1gaKUqw73r0fOlswhPVTsAexY2eDeWw3mGk/IZs7vrtlw2Q9GRmcoj
 j2h5Q5ydrj/nGTaXE9fO6rLVTq65wO0XS5UfQ2pXqvxuTohLbq/f362QN5V5yxnD1qDv
 k7+A7OjZXaHtSGcg7Mn98+B8huJqZnfd8VemWIgO5i8F5rHuCZwv2qAlApy/bgHWK6rr
 2uyg==
X-Gm-Message-State: AAQBX9cziLqFYLGHRZ5amH4G9louICL/Runy5KN9PcgsD4b/PvgFhnFl
 D29TO5G29uhJ5fJfMaMiM4CqEg==
X-Google-Smtp-Source: AKy350Y1d3Fo78/V0SBbMlTnA/KEzF4Q+15jV06Q1VNcWOt1KOIozBpCp75pUHwmvH01uVtRJ4USXg==
X-Received: by 2002:a17:90a:195d:b0:247:446f:7d05 with SMTP id
 29-20020a17090a195d00b00247446f7d05mr6076988pjh.0.1682116578148; 
 Fri, 21 Apr 2023 15:36:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 il7-20020a17090b164700b00247150f2091sm5021149pjb.8.2023.04.21.15.36.15
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 21 Apr 2023 15:36:17 -0700 (PDT)
Message-ID: <e032f210-f8cc-6441-2481-3c5341f8e72f@kernel.dk>
Date: Fri, 21 Apr 2023 16:36:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Luis Chamberlain <mcgrof@kernel.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
 <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
 <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 3/5] iomap: simplify iomap_init() with
 PAGE_SECTORS
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
Cc: djwong@kernel.org, philipp.reisner@linbit.com, linux-mm@kvack.org,
 dm-devel@redhat.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 christoph.boehmwalder@linbit.com, Matthew Wilcox <willy@infradead.org>,
 hch@infradead.org, p.raghav@samsung.com, senozhatsky@chromium.org,
 snitzer@kernel.org, linux-block@vger.kernel.org, kbusch@kernel.org,
 da.gomez@samsung.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 minchan@kernel.org, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/21/23 4:30?PM, Luis Chamberlain wrote:
> On Fri, Apr 21, 2023 at 04:24:57PM -0600, Jens Axboe wrote:
>> On 4/21/23 4:02?PM, Luis Chamberlain wrote:
>>> On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
>>>> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
>>>>> Just use the PAGE_SECTORS generic define. This produces no functional
>>>>> changes. While at it use left shift to simplify this even further.
>>>>
>>>> How is FOO << 2 simpler than FOO * 4?
>>>>
>>>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>>>> +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
>>>
>>> We could just do:
>>>
>>>
>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>> +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,
>>>
>>> The shift just seemed optimal if we're just going to change it.
>>
>> It's going to generate the same code, but the multiplication is arguably
>> easier to read (or harder to misread).
> 
> Then let's stick with the 4 * PAGE_SECTORS. Let me know if you need another
> patch.

Just send out a v2 at some point, you've also got a number of cases
where there are superfluous parenthesis, at least in patch 4, and Willy
pointed one out in an earlier patch too. Didn't check the last one.

This will be 6.5 anyway I think, I already sent out the changes for the
6.4 merge window.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

