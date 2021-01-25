Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5776C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:19:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D8A4C22D04
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 18:19:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8A4C22D04
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-xSgQH3l1MLuWa3TDjlFQOA-1; Mon, 25 Jan 2021 13:19:39 -0500
X-MC-Unique: xSgQH3l1MLuWa3TDjlFQOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35B70BBEE5;
	Mon, 25 Jan 2021 18:19:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 056B26F985;
	Mon, 25 Jan 2021 18:19:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B17C5002C;
	Mon, 25 Jan 2021 18:19:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PIJXfB004867 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 13:19:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 123406B582; Mon, 25 Jan 2021 18:19:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CA8C6B5B4
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:19:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A617E101042C
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 18:19:30 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
	[209.85.216.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-414-u_PyCr63Pciy-IM5I9JN_w-1; Mon, 25 Jan 2021 13:19:28 -0500
X-MC-Unique: u_PyCr63Pciy-IM5I9JN_w-1
Received: by mail-pj1-f43.google.com with SMTP id md11so106621pjb.0
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 10:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Q+/mfuYQSBHyRxbxoCqJHONl7gyYID+NujOLx72Mjs0=;
	b=Qdh62YaNc3z6tqbuihyJRJGRrrsIQvCRqw75eu9GjrHKWZ0S7eftvU+dw9+1ljQ2rB
	D3US3BlbFtfW0CIhqTKL/3FeEwP6PH9Y9xfyKOxefdwik7BcFpvO/d4RcFfapXC0SJn2
	UrE4N6mPTZfRHECc1370U6KqlWWRDuMzgFQEq45l3MnUMenta4urlbCzq3Jkvmi6xEd9
	3Z62AuGRjK9irhNLo/g3glFhQSNDktiEVlLvJlNcMVeZMNzxgYJV4oCKbRhjl0wzuJ6M
	AspttsuXds9F7/qR2ugCr1n71GYNfaASCIs4oVLsT8RZfN7ONy8Sl0M+0GOqB5Cb3C0U
	ltXA==
X-Gm-Message-State: AOAM5307au7DtquOXJNQhkdBRpziMbwJ5414p1HcwQ+exyVZdr868vhU
	NB7SQYz4qf0Nl2+03HdQ2tQ0Ag==
X-Google-Smtp-Source: ABdhPJzLxWAjZR087hDUUpZIANX9xYizUG/Yfc4cDQXg+npguCra4sXCIPHWABpU2lEAEkIShp5VPg==
X-Received: by 2002:a17:902:e8cc:b029:de:a258:68af with SMTP id
	v12-20020a170902e8ccb02900dea25868afmr1729070plg.7.1611598765943;
	Mon, 25 Jan 2021 10:19:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	mj21sm68984pjb.12.2021.01.25.10.19.24
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 25 Jan 2021 10:19:25 -0800 (PST)
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
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
Date: Mon, 25 Jan 2021 11:19:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125181826.GA14957@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/25/21 11:18 AM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
>> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
>>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
>>>> Partition table entries are not in disk order.
>>>
>>> And the issue shows up with the series just up to the this patch,
>>> without any later patches?
>>
>> At that patch specifically. I bisected it, and then I double checked
>> by running the previous commit (boots fine), then apply this one, and
>> then I run into that error. So it should be 100% reliable.
> 
> Ok, I have an idea.  With EOD message you mean this printk, right:
> 
> 	pr_info_ratelimited("attempt to access beyond end of device\n"
>                             "%s: rw=%d, want=%llu, limit=%llu\n",
> 			    ...
> 
> right?

Yep

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

