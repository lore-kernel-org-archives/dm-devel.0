Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565C2C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 932B164DCE
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 932B164DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-_GXs2OxiPba6GASq7q14bA-1; Thu, 28 Jan 2021 03:51:22 -0500
X-MC-Unique: _GXs2OxiPba6GASq7q14bA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C58D1005E46;
	Thu, 28 Jan 2021 08:51:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EB9EC5D9E8;
	Thu, 28 Jan 2021 08:51:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D8431809C9F;
	Thu, 28 Jan 2021 08:51:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S36tdE019460 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 22:06:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 29C8A2166B2A; Thu, 28 Jan 2021 03:06:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 232052166B2B
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 03:06:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38501800883
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 03:06:50 +0000 (UTC)
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-423-dcI3h8H7MeipAnazjlob0Q-1;
	Wed, 27 Jan 2021 22:06:47 -0500
X-MC-Unique: dcI3h8H7MeipAnazjlob0Q-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
	TI=SMTPD_---0UN61yfy_1611803201
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UN61yfy_1611803201) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 28 Jan 2021 11:06:41 +0800
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
	<20210127171941.GA11530@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <2ed9966f-b390-085a-1a51-5bf65038d533@linux.alibaba.com>
Date: Thu, 28 Jan 2021 11:06:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127171941.GA11530@redhat.com>
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
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 0/6] dm: support IO polling for bio-based
	dm device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 1/28/21 1:19 AM, Mike Snitzer wrote:
> On Mon, Jan 25 2021 at  7:13am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> Since currently we have no simple but efficient way to implement the
>> bio-based IO polling in the split-bio tracking style, this patch set
>> turns to the original implementation mechanism that iterates and
>> polls all underlying hw queues in polling mode. One optimization is
>> introduced to mitigate the race of one hw queue among multiple polling
>> instances.
>>
>> I'm still open to the split bio tracking mechanism, if there's
>> reasonable way to implement it.
>>
>>
>> [Performance Test]
>> The performance is tested by fio (engine=io_uring) 4k randread on
>> dm-linear device. The dm-linear device is built upon nvme devices,
>> and every nvme device has one polling hw queue (nvme.poll_queues=1).
>>
>> Test Case		    | IOPS in IRQ mode | IOPS in polling mode | Diff
>> 			    | (hipri=0)	       | (hipri=1)	      |
>> --------------------------- | ---------------- | -------------------- | ----
>> 3 target nvme, num_jobs = 1 | 198k 	       | 276k		      | ~40%
>> 3 target nvme, num_jobs = 3 | 608k 	       | 705k		      | ~16%
>> 6 target nvme, num_jobs = 6 | 1197k 	       | 1347k		      | ~13%
>> 3 target nvme, num_jobs = 6 | 1285k 	       | 1293k		      | ~0%
>>
>> As the number of polling instances (num_jobs) increases, the
>> performance improvement decreases, though it's still positive
>> compared to the IRQ mode.
> 
> I think there is serious room for improvement for DM's implementation;
> but the block changes for this are all we'd need for DM in the longrun
> anyway (famous last words).

Agreed.


> So on a block interface level I'm OK with
> block patches 1-3.
> 
> I don't see why patch 5 is needed (said the same in reply to it; but I
> just saw your reason below..).
> 
> Anyway, I can pick up DM patches 4 and 6 via linux-dm.git if Jens picks
> up patches 1-3. Jens, what do you think?

cc Jens.

Also I will send a new version later, maybe some refactor on patch5 and
some typo modifications.

> 
>> [Optimization]
>> To mitigate the race when iterating all the underlying hw queues, one
>> flag is maintained on a per-hw-queue basis. This flag is used to
>> indicate whether this polling hw queue currently being polled on or
>> not. Every polling hw queue is exclusive to one polling instance, i.e.,
>> the polling instance will skip this polling hw queue if this hw queue
>> currently is being polled by another polling instance, and start
>> polling on the next hw queue.
>>
>> This per-hw-queue flag map is currently maintained in dm layer. In
>> the table load phase, a table describing all underlying polling hw
>> queues is built and stored in 'struct dm_table'. It is safe when
>> reloading the mapping table.
>>
>>
>> changes since v1:
>> - patch 1,2,4 is the same as v1 and have already been reviewed
>> - patch 3 is refactored a bit on the basis of suggestions from
>> Mike Snitzer.
>> - patch 5 is newly added and introduces one new queue flag
>> representing if the queue is capable of IO polling. This mainly
>> simplifies the logic in queue_poll_store().
> 
> Ah OK, don't see why we want to eat a queue flag for that though!
> 
>> - patch 6 implements the core mechanism supporting IO polling.
>> The sanity check checking if the dm device supports IO polling is
>> also folded into this patch, and the queue flag will be cleared if
>> it doesn't support, in case of table reloading.
> 
> Thanks,
> Mike
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

