Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA94C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:31:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4519922B3F
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4519922B3F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-km-fBU83P8KXoho2ZUBDUg-1; Mon, 25 Jan 2021 13:31:41 -0500
X-MC-Unique: km-fBU83P8KXoho2ZUBDUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D15B9BBEF4;
	Mon, 25 Jan 2021 18:31:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AB3763BA7;
	Mon, 25 Jan 2021 18:31:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B532C18095FF;
	Mon, 25 Jan 2021 18:31:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PIVW9W005994 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 13:31:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E8D742166B2C; Mon, 25 Jan 2021 18:31:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E44272166B29
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:31:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5ACC11875040
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:31:29 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
	[209.85.216.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-42-n78WR9x9NQilwVzDFN0yfw-1; Mon, 25 Jan 2021 13:31:27 -0500
X-MC-Unique: n78WR9x9NQilwVzDFN0yfw-1
Received: by mail-pj1-f52.google.com with SMTP id l18so135159pji.3
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 10:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=fj+Mfh+iRTxHQ178jS8NvM3lFwTcOTHpKQTHJjUZLmQ=;
	b=Z/Z3Xw/rYRxnh53jKYPNXdnQS6R/S9w3gsmgPSjMtWaR88Az9Vmi/Yz5kWjTc6GPMw
	yYs9FOHklAAyN/G1frYQ6YLn0/EnCMJ/yiQzIaS51m8+hnXtiaHDW/tU411KahKZfEF/
	B8bB5nHiGKN8D8o8nkJaaykMrs6Bz4y1EC65px3vVo6NlPAGkcEap969PGhCmUkMsn3+
	1sr5a9KfXxVxpAY73QU3Y3oINMBEltXpE/lAZd5WAFoBACDcsUl0x1eWW5ENWr0jicgS
	fxj4z/YBmizxgAJtmF1NPj67DBEnZwaIU8JnR8TlCoveWZde35cKJseUTFFnxV5tjh6X
	HDaQ==
X-Gm-Message-State: AOAM533TdS/DGxA5mYReFmcbwXayiQTHdGNgDXX6WDes0SXAE/H4ruoz
	/bPABBI7qRELdETIJ4tpnUzCiA==
X-Google-Smtp-Source: ABdhPJw45UKblJYIjAuYyqjrm84zW5HcAl4q2OlrL0kcx51YsGL6Wwv5aF+a7froFnxQYB/1Z5yYqg==
X-Received: by 2002:a17:902:b717:b029:dc:3e69:6dd5 with SMTP id
	d23-20020a170902b717b02900dc3e696dd5mr1995124pls.70.1611599485884;
	Mon, 25 Jan 2021 10:31:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	24sm10567912pgt.14.2021.01.25.10.31.24
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 25 Jan 2021 10:31:25 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-6-hch@lst.de>
	<dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
	<20210125175528.GA13451@lst.de>
	<2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk>
	<13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
	<20210125181349.GA14432@lst.de>
	<1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk>
	<20210125181826.GA14957@lst.de>
	<22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
	<20210125182150.GA15367@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <387c824a-c713-a087-2f6f-434ba127b1df@kernel.dk>
Date: Mon, 25 Jan 2021 11:31:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125182150.GA15367@lst.de>
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
Cc: linux-s390 <linux-s390@vger.kernel.org>,
	linux-bcache <linux-bcache@vger.kernel.org>, Coly Li <colyli@suse.de>,
	"open list:SOFTWARE RAID \(Multiple Disks\) SUPPORT"
	<linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-block <linux-block@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 05/10] block: do not reassig ->bi_bdev when
 partition remapping
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On 1/25/21 11:21 AM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 11:19:23AM -0700, Jens Axboe wrote:
>> On 1/25/21 11:18 AM, Christoph Hellwig wrote:
>>> On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
>>>> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
>>>>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
>>>>>> Partition table entries are not in disk order.
>>>>>
>>>>> And the issue shows up with the series just up to the this patch,
>>>>> without any later patches?
>>>>
>>>> At that patch specifically. I bisected it, and then I double checked
>>>> by running the previous commit (boots fine), then apply this one, and
>>>> then I run into that error. So it should be 100% reliable.
>>>
>>> Ok, I have an idea.  With EOD message you mean this printk, right:
>>>
>>> 	pr_info_ratelimited("attempt to access beyond end of device\n"
>>>                             "%s: rw=%d, want=%llu, limit=%llu\n",
>>> 			    ...
>>>
>>> right?
>>
>> Yep
> 
> Can you give this untested patch a spin?  This should fix the
> case where we check the eod for the original partition with the
> remapped bi_sectors.  Looking into a local reproducer now.

Yep, with that applied on top my laptop boots again.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

