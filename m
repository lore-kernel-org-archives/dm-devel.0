Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1926C49EAB
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3792D61C5E
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3792D61C5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-pXVUKmKsM42bdn6IHvDzsA-1; Mon, 28 Jun 2021 05:52:42 -0400
X-MC-Unique: pXVUKmKsM42bdn6IHvDzsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B82E804146;
	Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 176D619C46;
	Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B96601809C99;
	Mon, 28 Jun 2021 09:52:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15L1WYdV019903 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 20 Jun 2021 21:32:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 18BAA1112C3B; Mon, 21 Jun 2021 01:32:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14B941112C3A
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 01:32:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 145EF1875067
	for <dm-devel@redhat.com>; Mon, 21 Jun 2021 01:32:30 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-543-BNZw4V5uPIOCf7Sq46AHQA-1;
	Sun, 20 Jun 2021 21:32:26 -0400
X-MC-Unique: BNZw4V5uPIOCf7Sq46AHQA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R281e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0Ud2o7Yc_1624239140
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0Ud2o7Yc_1624239140) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 21 Jun 2021 09:32:21 +0800
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
	<YMywCX6nLqLiHXyy@T590> <YM0IjWVuPya1SV0V@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a0eaa522-bce4-4636-b33e-6562a9d3cd10@linux.alibaba.com>
Date: Mon, 21 Jun 2021 09:32:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YM0IjWVuPya1SV0V@redhat.com>
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
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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



On 6/19/21 4:56 AM, Mike Snitzer wrote:
> [you really should've changed the subject of this email to
> "[RFC PATCH V3 3/3] dm: support bio polling"]
> 
> On Fri, Jun 18 2021 at 10:39P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
>> From 47e523b9ee988317369eaadb96826323cd86819e Mon Sep 17 00:00:00 2001
>> From: Ming Lei <ming.lei@redhat.com>
>> Date: Wed, 16 Jun 2021 16:13:46 +0800
>> Subject: [RFC PATCH V3 3/3] dm: support bio polling
>>
>> Support bio(REQ_POLLED) polling in the following approach:
>>
>> 1) only support io polling on normal READ/WRITE, and other abnormal IOs
>> still fallback on IRQ mode, so the target io is exactly inside the dm
>> io.
>>
>> 2) hold one refcnt on io->io_count after submitting this dm bio with
>> REQ_POLLED
>>
>> 3) support dm native bio splitting, any dm io instance associated with
>> current bio will be added into one list which head is bio->bi_end_io
>> which will be recovered before ending this bio
>>
>> 4) implement .poll_bio() callback, call bio_poll() on the single target
>> bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
>> dec_pending() after the target io is done in .poll_bio()
>>
>> 4) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
>> which is based on Jeffle's previous patch.
> 
> ^ nit: two "4)", last should be 5.
> 
>>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V3:
>> 	- covers all comments from Jeffle
> 
> Would really appreciate it if Jeffle could test these changes like he
> did previous dm IO polling patchsets he implemented.  Jeffle?

My pleasure. I would test it today and post the test result as soon as
possible.


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

