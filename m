Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDD3C63777
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:23:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A74842224C
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A74842224C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-mq5IasJaMEqR9PplB61JeQ-1; Fri, 20 Nov 2020 04:23:05 -0500
X-MC-Unique: mq5IasJaMEqR9PplB61JeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70EF880EFAE;
	Fri, 20 Nov 2020 09:22:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54BA760BE2;
	Fri, 20 Nov 2020 09:22:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F34EC4EEF6;
	Fri, 20 Nov 2020 09:22:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK2iQxr017210 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 21:44:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A0912E598D; Fri, 20 Nov 2020 02:44:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B085C1255
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 02:44:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07E14811E76
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 02:44:23 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-539-tEJzXfk-OuKsaetJeKti7A-1; Thu, 19 Nov 2020 21:44:20 -0500
X-MC-Unique: tEJzXfk-OuKsaetJeKti7A-1
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CcgPh1xSJz6xZ6;
	Fri, 20 Nov 2020 10:25:28 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.144) by DGGEMS406-HUB.china.huawei.com
	(10.3.19.206) with Microsoft SMTP Server id 14.3.487.0;
	Fri, 20 Nov 2020 10:25:42 +0800
To: John Dorminy <jdorminy@redhat.com>
References: <20200821020345.3358-1-thunder.leizhen@huawei.com>
	<b4643e74-aad9-385f-01f2-f8e48ba4dbef@suse.de>
	<ad100923-e479-faf0-f749-ac8e4cf87899@huawei.com>
	<8aa638b7-6cfd-bf3d-8015-fbe59f28f31f@suse.de>
	<c2f8cf50-d9f7-df19-40eb-0543e6208c0d@huawei.com>
	<CAMeeMh_iBFpmSjgm8aC1WO-=iQPU5rQ2-Z6oe0L8nt5ke=+XQw@mail.gmail.com>
From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <c0013047-e202-085c-f841-4468ae4072fa@huawei.com>
Date: Fri, 20 Nov 2020 10:25:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
	Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAMeeMh_iBFpmSjgm8aC1WO-=iQPU5rQ2-Z6oe0L8nt5ke=+XQw@mail.gmail.com>
X-Originating-IP: [10.174.176.144]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 20 Nov 2020 04:22:47 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
	linux-block <linux-block@vger.kernel.org>, dm-devel <dm-devel@redhat.com>,
	linux-bcache <linux-bcache@vger.kernel.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: move the PAGE_SECTORS definition
 into <linux/blkdev.h>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2020/11/20 9:27, John Dorminy wrote:
> Greetings;
> 
> There are a lot of uses of PAGE_SIZE/SECTOR_SIZE scattered around, and
> it seems like a medium improvement to be able to refer to it as
> PAGE_SECTORS everywhere instead of just inside dm, bcache, and
> null_blk. Did this change progress forward somewhere?

Actually, I'm trying to make further replacements after this patch is applied.
But there was no response except Coly Li.

> 
> Thanks!
> 
> John Dorminy
> 
> 
> On Mon, Sep 7, 2020 at 3:40 AM Leizhen (ThunderTown)
> <thunder.leizhen@huawei.com> wrote:
>>
>> Hi, Jens Axboe, Alasdair Kergon, Mike Snitzer:
>>   What's your opinion?
>>
>>
>> On 2020/8/21 15:05, Coly Li wrote:
>>> On 2020/8/21 14:48, Leizhen (ThunderTown) wrote:
>>>>
>>>>
>>>> On 8/21/2020 12:11 PM, Coly Li wrote:
>>>>> On 2020/8/21 10:03, Zhen Lei wrote:
>>>>>> There are too many PAGE_SECTORS definitions, and all of them are the
>>>>>> same. It looks a bit of a mess. So why not move it into <linux/blkdev.h>,
>>>>>> to achieve a basic and unique definition.
>>>>>>
>>>>>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>>>>>
>>>>>
>>>>> A lazy question about page size > 4KB: currently in bcache code the
>>>>> sector size is assumed to be 512 sectors, if kernel page > 4KB, it is
>>>>> possible that PAGE_SECTORS in bcache will be a number > 8 ?
>>>>
>>>> Sorry, I don't fully understand your question. I known that the sector size
>>>> can be 512 or 4K, and the PAGE_SIZE can be 4K or 64K. So even if sector size
>>>> is 4K, isn't it greater than 8 for 64K pages?
>>>>
>>>> I'm not sure if the question you're asking is the one Matthew Wilcox has
>>>> answered before:
>>>> https://www.spinics.net/lists/raid/msg64345.html
>>>
>>> Thank you for the above information. Currently bcache code assumes
>>> sector size is always 512 bytes, you may see how many "<< 9" or ">> 9"
>>> are used. Therefore I doubt whether current code may stably work on e.g.
>>> 4Kn SSDs (this is only doubt because I don't have such SSD).
>>>
>>> Anyway your patch is fine to me. This change to bcache doesn't make
>>> thins worse or better, maybe it can be helpful to trigger my above
>>> suspicious early if people do have this kind of problem on 4Kn sector SSDs.
>>>
>>> For the bcache part of this patch, you may add,
>>> Acked-by: Coly Li <colyli@suse.de>
>>>
>>> Thanks.
>>>
>>> Coly Li
>>>
>>>>>> ---
>>>>>>  drivers/block/brd.c           | 1 -
>>>>>>  drivers/block/null_blk_main.c | 1 -
>>>>>>  drivers/md/bcache/util.h      | 2 --
>>>>>>  include/linux/blkdev.h        | 5 +++--
>>>>>>  include/linux/device-mapper.h | 1 -
>>>>>>  5 files changed, 3 insertions(+), 7 deletions(-)
>>>>>>
>>>>>
>>>>> [snipped]
>>>>>
>>>>>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
>>>>>> index c029f7443190805..55196e0f37c32c6 100644
>>>>>> --- a/drivers/md/bcache/util.h
>>>>>> +++ b/drivers/md/bcache/util.h
>>>>>> @@ -15,8 +15,6 @@
>>>>>>
>>>>>>  #include "closure.h"
>>>>>>
>>>>>> -#define PAGE_SECTORS              (PAGE_SIZE / 512)
>>>>>> -
>>>>>>  struct closure;
>>>>>>
>>>>>>  #ifdef CONFIG_BCACHE_DEBUG
>>>>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>>>>> index bb5636cc17b91a7..b068dfc5f2ef0ab 100644
>>>>>> --- a/include/linux/blkdev.h
>>>>>> +++ b/include/linux/blkdev.h
>>>>>> @@ -949,11 +949,12 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>>>>>>   * multiple of 512 bytes. Hence these two constants.
>>>>>>   */
>>>>>>  #ifndef SECTOR_SHIFT
>>>>>> -#define SECTOR_SHIFT 9
>>>>>> +#define SECTOR_SHIFT              9
>>>>>>  #endif
>>>>>>  #ifndef SECTOR_SIZE
>>>>>> -#define SECTOR_SIZE (1 << SECTOR_SHIFT)
>>>>>> +#define SECTOR_SIZE               (1 << SECTOR_SHIFT)
>>>>>>  #endif
>>>>>> +#define PAGE_SECTORS              (PAGE_SIZE / SECTOR_SIZE)
>>>>>>
>>>>>>  /*
>>>>>>   * blk_rq_pos()                   : the current sector
>>>>> [snipped]
>>>>>
>>>>>
>>>>
>>>
>>>
>>> .
>>>
>>
> 
> 
> .
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

