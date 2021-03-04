Return-Path: <SRS0=PkBB=IC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D203C433E6
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9695764F41
	for <dm-devel@archiver.kernel.org>; Thu,  4 Mar 2021 14:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9695764F41
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-ZLjEpI5eNZK3jdmq0ySokQ-1; Thu, 04 Mar 2021 09:42:15 -0500
X-MC-Unique: ZLjEpI5eNZK3jdmq0ySokQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAF9657;
	Thu,  4 Mar 2021 14:42:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAEFF60C43;
	Thu,  4 Mar 2021 14:42:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 785C257DC2;
	Thu,  4 Mar 2021 14:42:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1242w8Z2029230 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 21:58:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57AB8202A438; Thu,  4 Mar 2021 02:58:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 52673202A422
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 02:58:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EFB78E4AA2
	for <dm-devel@redhat.com>; Thu,  4 Mar 2021 02:58:05 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com
	(out30-133.freemail.mail.aliyun.com [115.124.30.133]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-391-fJMiDqlXOaapxU9_Rwxp-w-1;
	Wed, 03 Mar 2021 21:58:00 -0500
X-MC-Unique: fJMiDqlXOaapxU9_Rwxp-w-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R771e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0UQJ-nD5_1614826675
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQJ-nD5_1614826675) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 04 Mar 2021 10:57:56 +0800
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
	<33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
	<alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
Date: Thu, 4 Mar 2021 10:57:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 04 Mar 2021 09:41:43 -0500
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, caspar@linux.alibaba.com,
	hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/3/21 6:09 PM, Mikulas Patocka wrote:
> 
> 
> On Wed, 3 Mar 2021, JeffleXu wrote:
> 
>>
>>
>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>>
>>> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>>> cookie.
>>>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> ---
>>>  drivers/md/dm.c |    5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> Index: linux-2.6/drivers/md/dm.c
>>> ===================================================================
>>> --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>> +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>>>  		}
>>>  	}
>>>  
>>> +	if (ci.poll_cookie != BLK_QC_T_NONE) {
>>> +		while (atomic_read(&ci.io->io_count) > 1 &&
>>> +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>> +	}
>>> +
>>>  	/* drop the extra reference count */
>>>  	dec_pending(ci.io, errno_to_blk_status(error));
>>>  }
>>
>> It seems that the general idea of your design is to
>> 1) submit *one* split bio
>> 2) blk_poll(), waiting the previously submitted split bio complets
> 
> No, I submit all the bios and poll for the last one.
> 
>> and then submit next split bio, repeating the above process. I'm afraid
>> the performance may be an issue here, since the batch every time
>> blk_poll() reaps may decrease.
> 
> Could you benchmark it?
> 

I will once I finished some other issues.


>> Besides, the submitting routine and polling routine is bound together
>> here, i.e., polling is always synchronous.
> 
> __split_and_process_bio calls __split_and_process_non_flush in a loop

I also noticed that you sent this patch.
https://patchwork.kernel.org/project/dm-devel/patch/alpine.LRH.2.02.2103010457510.631@file01.intranet.prod.int.rdu2.redhat.com/

I agree with you that this while() loop here is unnecessary. And thus
there's no loop calling __split_and_process_non_flush() in
__split_and_process_bio().


> __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
> When we processed all the bios, we poll for the last cookie here:
> 
>         if (ci.poll_cookie != BLK_QC_T_NONE) {
>                 while (atomic_read(&ci.io->io_count) > 1 &&
>                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>         }

So what will happen if one bio submitted to dm device crosses the device
boundary among several target devices (e.g., dm-stripe)? Please refer
the following call graph.

```
submit_bio
  __submit_bio_noacct
    disk->fops->submit_bio(), calling into __split_and_process_bio(),
call __split_and_process_non_flush() once, submitting the *first* split bio
    disk->fops->submit_bio(), calling into __split_and_process_bio(),
call __split_and_process_non_flush() once, submitting the *second* split bio
    ...
```


So the loop is in __submit_bio_noacct(), rather than
__split_and_process_bio(). Your design will send the first split bio,
and then poll on this split bio, then send the next split bio, polling
on this, go on and on...

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

