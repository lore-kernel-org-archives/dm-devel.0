Return-Path: <SRS0=vJVk=ID=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95788C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 18:21:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BB14A650A4
	for <dm-devel@archiver.kernel.org>; Fri,  5 Mar 2021 18:21:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB14A650A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-y2kjW_O7NyqUDdzG1r-qcA-1; Fri, 05 Mar 2021 13:21:41 -0500
X-MC-Unique: y2kjW_O7NyqUDdzG1r-qcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A48B726862;
	Fri,  5 Mar 2021 18:21:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85C051349A;
	Fri,  5 Mar 2021 18:21:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AB2D1809C8B;
	Fri,  5 Mar 2021 18:21:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 125ILX5N026594 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Mar 2021 13:21:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7953A6CA90; Fri,  5 Mar 2021 18:21:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72FE76CA99
	for <dm-devel@redhat.com>; Fri,  5 Mar 2021 18:21:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95B5101037E
	for <dm-devel@redhat.com>; Fri,  5 Mar 2021 18:21:30 +0000 (UTC)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com
	[209.85.166.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-312-2AYhgX-wM7C1jGQ8-uJoBA-1; Fri, 05 Mar 2021 13:21:28 -0500
X-MC-Unique: 2AYhgX-wM7C1jGQ8-uJoBA-1
Received: by mail-il1-f171.google.com with SMTP id e7so2848816ile.7
	for <dm-devel@redhat.com>; Fri, 05 Mar 2021 10:21:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=OEh/sWcetf4+lkEDVwLPAVNhW+72rKN70d51beTZb3Q=;
	b=gqhNjx2GbBQjwCPVH61FtQ1ZX1Lt4pA+Kjq+ojFyAoJmKmObt15GvLJwyiZLstjx82
	wBaUus3uH1SLqB8wmyxixZCYOGNUOnFccdkktNcG+iANTWQ/qA92SjhGK1Kda6pveeAM
	1dl6A+6vvuJ71kEGHe36xlXn7mdxifYucQcQeYAaXh2Ka09Ahu8zVahvvcM95ljcxhL9
	9uQ9t5eYO6e01NDviMGIb5ofiuVx8tzLSiaDOIK19K/WMsibVre0IR9Tgej8CU67wFC1
	uWkayvLm1C/PXgRDDL1Fan02jQXbXeBcYA4/vTADQndmYM9F5uIU9nTp1NQu24d6hJRX
	xVgw==
X-Gm-Message-State: AOAM530lLeaHZdVwy48nVWDuTa81crD8/AIrA/1dvUAPG7r0BoyHSt4X
	8eXN05j6WSIStN6ynHG2eC34eA==
X-Google-Smtp-Source: ABdhPJy7QwpL95S/HOl2DljHxhZENGECbkHbofdfBkOTTuXvGfnc2qKDYfIIf0kBZ1v5ayol17f6Og==
X-Received: by 2002:a05:6e02:12c2:: with SMTP id
	i2mr9419720ilm.34.1614968487685; 
	Fri, 05 Mar 2021 10:21:27 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id w2sm1602885ioa.46.2021.03.05.10.21.27
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 05 Mar 2021 10:21:27 -0800 (PST)
To: Mikulas Patocka <mpatocka@redhat.com>,
	JeffleXu <jefflexu@linux.alibaba.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
	<f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
	<alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <7ff9599c-d729-87b2-4fc0-e2413b2d8718@kernel.dk>
Date: Fri, 5 Mar 2021 11:21:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
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

On 3/4/21 3:09 AM, Mikulas Patocka wrote:
> 
> 
> On Thu, 4 Mar 2021, JeffleXu wrote:
> 
>>> __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
>>> When we processed all the bios, we poll for the last cookie here:
>>>
>>>         if (ci.poll_cookie != BLK_QC_T_NONE) {
>>>                 while (atomic_read(&ci.io->io_count) > 1 &&
>>>                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>>         }
>>
>> So what will happen if one bio submitted to dm device crosses the device
>> boundary among several target devices (e.g., dm-stripe)? Please refer
>> the following call graph.
>>
>> ```
>> submit_bio
>>   __submit_bio_noacct
>>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
>> call __split_and_process_non_flush() once, submitting the *first* split bio
>>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
>> call __split_and_process_non_flush() once, submitting the *second* split bio
>>     ...
>> ```
>>
>>
>> So the loop is in __submit_bio_noacct(), rather than
>> __split_and_process_bio(). Your design will send the first split bio,
>> and then poll on this split bio, then send the next split bio, polling
>> on this, go on and on...
> 
> No. It will send all the bios and poll for the last one.

I took a quick look, and this seems very broken. You must not poll off
the submission path, polling should be invoked by the higher layer when
someone wants to reap events. IOW, dm should not be calling blk_poll()
by itself, only off mq_ops->poll(). Your patch seems to do it off
submission once you submit the last bio in that batch, effectively
implementing sync polling for that series. That's not right.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

