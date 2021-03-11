Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34827C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6250564FB0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 09:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6250564FB0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-jD7ePaSkOmC_W9JTfJ3KKw-1; Thu, 11 Mar 2021 04:23:07 -0500
X-MC-Unique: jD7ePaSkOmC_W9JTfJ3KKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCFF9100D1A1;
	Thu, 11 Mar 2021 09:23:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4D145C1BD;
	Thu, 11 Mar 2021 09:23:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E706557DC2;
	Thu, 11 Mar 2021 09:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12B77Wim031996 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 02:07:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 50059101A7F5; Thu, 11 Mar 2021 07:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BBD31018D67
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 07:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F40485A5B7
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 07:07:30 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-518-b_aCoCgvPW6lkPpHvHsp3g-1;
	Thu, 11 Mar 2021 02:07:26 -0500
X-MC-Unique: b_aCoCgvPW6lkPpHvHsp3g-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0URQREIY_1615446438
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0URQREIY_1615446438) by smtp.aliyun-inc.com(127.0.0.1);
	Thu, 11 Mar 2021 15:07:19 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
	<20210310200127.GA22542@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <a67102b8-d799-c072-3d57-5267e3ea060e@linux.alibaba.com>
Date: Thu, 11 Mar 2021 15:07:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310200127.GA22542@redhat.com>
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
X-Mailman-Approved-At: Thu, 11 Mar 2021 04:22:56 -0500
Cc: axboe@kernel.dk, dm-devel@redhat.com, caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	ejt@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 00/11] dm: support IO polling
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/11/21 4:01 AM, Mike Snitzer wrote:
> On Mon, Feb 08 2021 at  3:52am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>> [Performance]
>> 1. One thread (numjobs=1) randread (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw
>> queue per nvme device.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  208k |		 279k | ~34%
>>
>>
>> 2. Three threads (numjobs=3) randread (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw
>> queue per nvme device.
>>
>> It's compared to 3 threads directly randread 3 nvme devices, with one
>> polling hw queue per nvme device. No CPU affinity set for these 3
>> threads. Thus every thread can access every nvme device
>> (filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1), i.e., every thread
>> need to competing for every polling hw queue.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  615k |		 728k | ~18%
>> nvme | 		  728k |		 873k | ~20%
>>
>> The result shows that the performance gain of bio-based polling is
>> comparable as that of mq polling in the same test case.
>>
>>
>> 3. Three threads (numjobs=3) randread (bs=12k, direct=1) one
>> **dm-stripe** device, which is built upon 3 nvme devices, with one
>> polling hw queue per nvme device.
>>
>> It's compared to 3 threads directly randread 3 nvme devices, with one
>> polling hw queue per nvme device. No CPU affinity set for these 3
>> threads. Thus every thread can access every nvme device
>> (filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1), i.e., every thread
>> need to competing for every polling hw queue.
>>
>>      | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---- | --------------- | -------------------- | ----
>>   dm | 		  314k |		 354k | ~13%
>> nvme | 		  728k |		 873k | ~20%
>>
> 
> So this "3." case is meant to illustrate effects of polling when bio is
> split to 3 different underlying blk-mq devices. (think it odd that
> dm-stripe across 3 nvme devices is performing so much worse than a
> single nvme device)
> 
> Would be nice to see comparison of this same workload but _with_ CPU
> affinity to show relative benefit of your patch 11 in this series (where
> you try to leverage CPU pinning).

Actually I have done the test. You can see that without the optimization
in patch 1,, i.e., to leverage CPU pinning, there's only ~13%
performance gain of polling.

As I stated here [1] (see the clause two "2. sub-fastpath"), with the
optimization in patch 11, the performance gain is ~32%. The optimization
behave well. It mainly decreases the race where multiple CPUs competing
for the same hw queue.


[1]
https://patchwork.kernel.org/project/dm-devel/cover/20210303115740.127001-1-jefflexu@linux.alibaba.com/

> 
> In general, I don't think patch 11 a worthwhile effort.  It is a
> half-measure that is trying to paper over the fact that this bio-based
> IO polling patchset is quite coarse grained about how it copes with the
> need to poll multiple devices.

Indeed. It is a result of somewhat compromise. If we have better scheme
improving multi-thread performance, it shall certainly go... I can
explain the difficulty of implementing the optimization in other ways in
the following comment.

> 
> Patch 10 is a proper special case that should be accounted for (when a
> bio isn't split and only gets submitted to a single blk-mq
> device/hctx).  But even patch 10's approach is fragile (we we've
> discussed in private and I'll touch on in reply to patch 10).
> 
> But I think patch 11 should be dropped and we defer optimizing bio
> splitting at a later time with follow-on work.
> 
> Just so you're aware, I'm now thinking the proper way forward is to
> update DM core, at the time of DM table load, to assemble an array of
> underlying _data_ devices in that table (as iterated with
> .iterate_devices) -- this would allow each underlying data device to be
> assigned an immutable index for the lifetime of a DM table.  It'd be
> hooked off the 'struct dm_table' and would share that object's
> lifetime.

I have also considered it. There's two way organizing the table, with
each having its own defect though.

1. Each dm table maintains underlying devices at its own level, e.g., if
dm-0 is built upon dm-1, then the dm table of dm-0 maintains all
underlying devices of dm-0, while the dm table of dm-1 maintaining its
own underlying devices.

In this case, there are multiple arrays at each level. If the returned
cookie is still one integer type, it may be difficult to design the
cookie, making it reflecting one slot among all these multiple arrays.

If the returned cookie is actually a group of indexes, with each
indexing one dm table, then where and how to store these indexes...


2. The dm device at the top most level maintains a large array,
aggregating all underlying devices on all levels.

In this case, one unique array is maintained and one cookie of integer
type is enough. However the defect is that, when one underlying dm
device reloads table, how and when to update the array in the top most
level.

> 
> With that bit of infrastructure in place, we could then take steps to
> make DM's cookie more dense in its description of underlying devices
> that need polling.  This is where I'll get a bit handwavvy.. but I
> raised this idea with Joe Thornber and he is going to have a think about
> it too.
> 
> But this is all to say: optimizing the complex case of bio-splitting
> that is such an integral part of bio-based IO processing needs more than
> what you've attempted to do (noble effort on your part but again, really
> just a half-measure).
> 
> SO I think it best to keep the initial implementation of bio-based
> polling relatively simple by laying foundation for follow-on work.  And
> it is also important to _not_ encode in block core some meaning to what
> _should_ be a largely opaque cookie (blk_qc_t) that is for the
> underlying driver to make sense of.
> 

Agreed. The difficulty of the design pattern is explained in the
corresponding reply for v5.

> 
>>
>> 4. This patchset shall do no harm to the performance of the original mq
>> polling. Following is the test results of one thread (numjobs=1)
>> randread (bs=4k, direct=1) one nvme device.
>>
>> 	    	 | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ---------------- | --------------- | -------------------- | ----
>> without patchset | 	      242k |		     332k | ~39%
>> with patchset    |	      236k |		     332k | ~39%
> 
> OK, good, this needs to be the case.
> 
>>
>> [Changes since v2]
>>
>> Patchset v2 caches all hw queues (in polling mode) of underlying mq
>> devices in dm layer. The polling routine actually iterates through all
>> these cached hw queues.
>>
>> However, mq may change the queue mapping at runtime (e.g., NVMe RESET
>> command), thus the cached hw queues in dm layer may be out-of-date. Thus
>> patchset v3 falls back to the implementation of the very first RFC
>> version, in which the mq layer needs to export one interface iterating
>> all polling hw queues (patch 5), and the bio-based polling routine just
>> calls this interface to iterate all polling hw queues.
>>
>> Besides, several new optimization is proposed.
>>
>>
>> - patch 1,2,7
>> same as v2, untouched
>>
>> - patch 3
>> Considering advice from Christoph Hellwig, while refactoring blk_poll(),
>> split mq and bio-based polling routine from the very beginning. Now
>> blk_poll() is just a simple entry. blk_bio_poll() is simply copied from
>> blk_mq_poll(), while the loop structure is some sort of duplication
>> though.
>>
>> - patch 4
>> This patch is newly added to support turning on/off polling through
>> '/sys/block/<dev>/queue/io_poll' dynamiclly for bio-based devices.
>> Patchset v2 implemented this functionality by added one new queue flag,
>> which is not preferred since the queue flag resource is quite short of
>> nowadays.
>>
>> - patch 5
>> This patch is newly added, preparing for the following bio-based
>> polling. The following bio-based polling will call this helper function,
>> accounting on the corresponding hw queue.
>>
>> - patch 6
>> It's from the very first RFC version, preparing for the following
>> bio-based polling.
>>
>> - patch 8
>> One fixing patch needed by the following bio-based polling. It's
>> actually a v2 of [1]. I had sent the v2 singly in-reply-to [1], though
>> it has not been visible on the mailing list maybe due to the delay.
>>
>> - patch 9
>> It's from the very first RFC version.
>>
>> - patch 10
>> This patch is newly added. Patchset v2 had ever proposed one
>> optimization that, skipping the **busy** hw queues during the iteration
>> phase. Back upon that time, one flag of 'atomic_t' is specifically
>> maintained in dm layer, representing if the corresponding hw queue is
>> busy or not. The idea is inherited, while the implementation changes.
>> Now @nvmeq->cq_poll_lock is used directly here, no need for extra flag
>> anymore.
>>
>> This optimization can significantly reduce the competition for one hw
>> queue between multiple polling instances. Following statistics is the
>> test result when 3 threads concurrently randread (bs=4k, direct=1) one
>> dm-linear device, which is built upon 3 nvme devices, with one polling
>> hw queue per nvme device.
>>
>> 	    | IOPS (IRQ mode) | IOPS (iopoll=1 mode) | diff
>> ----------- | --------------- | -------------------- | ----
>> without opt | 		 318k |		 	256k | ~-20%
>> with opt    |		 314k |		 	354k | ~13%
>> 							
>>
>> - patch 11
>> This is another newly added optimizatin for bio-based polling.
>>
>> One intuitive insight is that, when the original bio submitted to dm
>> device doesn't get split, then the bio gets enqueued into only one hw
>> queue of one of the underlying mq devices. In this case, we no longer
>> need to track all split bios, and one cookie (for the only split bio)
>> is enough. It is implemented by returning the pointer to the
>> corresponding hw queue in this case.
>>
>> It should be safe by directly returning the pointer to the hw queue,
>> since 'struct blk_mq_hw_ctx' won't be freed during the whole lifetime of
>> 'struct request_queue'. Even when the number of hw queues may decrease
>> when NVMe RESET happens, the 'struct request_queue' structure of decreased
>> hw queues won't be freed, instead it's buffered into
>> &q->unused_hctx_list list.
>>
>> Though this optimization seems quite intuitive, the performance test
>> shows that it does no benefit nor harm to the performance, while 3
>> threads concurrently randreading (bs=4k, direct=1) one dm-linear
>> device, which is built upon 3 nvme devices, with one polling hw queue
>> per nvme device.
>>
>> I'm not sure why it doesn't work, maybe because the number of devices,
>> or the depth of the devcice stack is to low in my test case?
> 
> Looks like these patch references are stale (was relative to v3 I
> think).. e.g: "patch 11" from v3 is really "patch 10" in v5.. but its
> implementation has changed because Mikulas pointed out that the
> implementation was unsafe.. IIRC?
> 
> Anyway, I'll just focus on reviewing each patch in this v5 now.
> 
> Thanks,
> Mike
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

