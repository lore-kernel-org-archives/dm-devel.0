Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD1C8C76195
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 23:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679699484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J4Q5G1x8Gxxilm0PiKwa0U6Q4JkricqbgkdK9rUUNFo=;
	b=JjtcPLr/RNk4OCe/hvo32l2SGi+XZqdFCj6oEn3/SJH5Tw3fKEksYu8AJgDCH1AdjZSpYp
	aGfAz2lgea9x601lC1mN1HxWBaihm2Aqmylx6vsyuixG4DiwXdKkkCWu81X93unxTnZScT
	ZGupfKBFnKHpfohXlUuBBgoXleetfgE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-2h-eq8PkOP6irb6aDbyC3A-1; Fri, 24 Mar 2023 19:11:21 -0400
X-MC-Unique: 2h-eq8PkOP6irb6aDbyC3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A3CB1C08993;
	Fri, 24 Mar 2023 23:11:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3FDE140EBF4;
	Fri, 24 Mar 2023 23:11:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A43F01946A5E;
	Fri, 24 Mar 2023 23:11:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44FB31946A5A
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 23:11:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0601F2A68; Fri, 24 Mar 2023 23:11:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2D6E18EC7
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 23:11:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC9E53C0F38F
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 23:11:16 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10--iZpHrvzMJutq54IOzFOIA-1; Fri, 24 Mar 2023 19:11:15 -0400
X-MC-Unique: -iZpHrvzMJutq54IOzFOIA-1
Received: by mail-pj1-f45.google.com with SMTP id
 l9-20020a17090a3f0900b0023d32684e7fso6497295pjc.1
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 16:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679699474; x=1682291474;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=4AG8XZ588zOoU/1W2BkCpxa6WVbxvvO3WvuuWjv7bwk=;
 b=f/ryWWTdTVFcbaeb68BPlLNz4/0b5+RsedkOARB3o5Oh3gXarVD/NH50aGiCAlahly
 //x/L3iRIXj1kO/GotCAdqa816XPX7HiJ+FfVDbXt9JZVjBmoHwwe3ZcwCe+qQF+pPpm
 EBQmqS+EuR1iqlmNwzDLVl0wyRx5IrOK4UpjMLAPXvlbwTl8dQP7alkiVTacCqEAmZsW
 FqZRQd04MogEfHFlpRxrlMPci0YJiaC9ywH9pp3biFVIHvrZgVrr/qFNwQbYpUpKkQKz
 wWtGznQFprxT9qERGv4kvBEUeumLoWmCz9UPGAdudjVS3PoNGHtwx0l3leEc7KsnWs32
 zhXw==
X-Gm-Message-State: AO0yUKXDGZvqguILJCQstUdJ5ZYZ4bjTphBsfUsO3cqyTk5F0GgLmecs
 UOZZWfM17uhvHenheRruE6bgLA==
X-Google-Smtp-Source: AK7set+XFzZaJLA53+kx0/SHeEfdBJK/e85/nJlzWqlLgjz6Hp+dUQCBbIoXUqWljtYv1QX69csjBA==
X-Received: by 2002:a05:6a20:6914:b0:cc:bf13:7b1c with SMTP id
 q20-20020a056a20691400b000ccbf137b1cmr3206485pzj.0.1679699473818; 
 Fri, 24 Mar 2023 16:11:13 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 d10-20020a634f0a000000b0050f56964426sm11899902pgb.54.2023.03.24.16.11.12
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 24 Mar 2023 16:11:13 -0700 (PDT)
Message-ID: <e552ad80-37fe-247e-aaf1-064572ccc154@kernel.dk>
Date: Fri, 24 Mar 2023 17:11:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Mike Snitzer <snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
 <20230324175656.85082-4-snitzer@kernel.org>
 <a1b8ceb8-0a67-86a1-2222-1625f6ebbe33@kernel.dk>
 <ZB4p2NfwIhh9raxa@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZB4p2NfwIhh9raxa@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [dm-6.4 PATCH v2 3/9] dm bufio: improve concurrent
 IO performance
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
Cc: linux-block@vger.kernel.org, keescook@chromium.org, heinzm@redhat.com,
 ejt@redhat.com, nhuck@google.com, ebiggers@kernel.org, dm-devel@redhat.com,
 mpatocka@redhat.com, luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/24/23 4:53?PM, Mike Snitzer wrote:
> On Fri, Mar 24 2023 at  3:34P -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> Just some random drive-by comments.
>>
>>> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
>>> index 1de1bdcda1ce..a58f8ac3ba75 100644
>>> --- a/drivers/md/dm-bufio.c
>>> +++ b/drivers/md/dm-bufio.c
>>> +static void lru_destroy(struct lru *lru)
>>> +{
>>> +	BUG_ON(lru->cursor);
>>> +	BUG_ON(!list_empty(&lru->iterators));
>>> +}
>>
>> Ehm no, WARN_ON_ONCE() for these presumably.
> 
> Yeah, I raised concern about the BUG_ONs with Joe. Will try to rid the
> code of BUG_ONs as follow-on work.

Please do.

>>> @@ -116,9 +366,579 @@ struct dm_buffer {
>>>  #endif
>>>  };
>>>  
>>> +/*--------------------------------------------------------------*/
>>> +
>>> +/*
>>> + * The buffer cache manages buffers, particularly:
>>> + *  - inc/dec of holder count
>>> + *  - setting the last_accessed field
>>> + *  - maintains clean/dirty state along with lru
>>> + *  - selecting buffers that match predicates
>>> + *
>>> + * It does *not* handle:
>>> + *  - allocation/freeing of buffers.
>>> + *  - IO
>>> + *  - Eviction or cache sizing.
>>> + *
>>> + * cache_get() and cache_put() are threadsafe, you do not need to
>>> + * protect these calls with a surrounding mutex.  All the other
>>> + * methods are not threadsafe; they do use locking primitives, but
>>> + * only enough to ensure get/put are threadsafe.
>>> + */
>>> +
>>> +#define NR_LOCKS 64
>>> +#define LOCKS_MASK (NR_LOCKS - 1)
>>> +
>>> +struct tree_lock {
>>> +	struct rw_semaphore lock;
>>> +} ____cacheline_aligned_in_smp;
>>> +
>>> +struct dm_buffer_cache {
>>> +	/*
>>> +	 * We spread entries across multiple trees to reduce contention
>>> +	 * on the locks.
>>> +	 */
>>> +	struct tree_lock locks[NR_LOCKS];
>>> +	struct rb_root roots[NR_LOCKS];
>>> +	struct lru lru[LIST_SIZE];
>>> +};
>>
>> This:
>>
>> struct foo_tree {
>> 	struct rw_semaphore lock;
>> 	struct rb_root root;
>> 	struct lru lru;
>> } ____cacheline_aligned_in_smp;
>>
>> would be a lot better.
>>
>> And where does this NR_LOCKS come from? Don't make up magic values out
>> of thin air. Should this be per-cpu? per-node? N per node? I'll bet you
>> that 64 is way too much for most use cases, and too little for others.
> 
> I cannot speak to the 64 magic value (other than I think it worked
> well for Joe's testbed).  But the point of this exercise is to split
> the lock to avoid contention.  Using 64 accomplishes this. Having
> there be more or less isn't _that_ critical.  The hash to get the
> region index isn't a function of cpu.  We aren't after lockless here.

I don't doubt it worked well in his setup, and it'll probably be fine in
a lot of setups. But the point still stands - it's a magic value, it
should at least be documented. And 64 is likely way too much on a lot of
machines.

> Now that said, will certainly discuss further with Joe and see if we
> can be smarter here.
> 
> Your suggestion to combine members certainly makes a lot of sense.  I
> ran with it relative to the bio-prison-v1 (patch 9) changes which have
> the same layout. Definitely a win on in-core memory as well as
> avoiding cacheline thrashing while accessing the lock and then the
> rb_root members (as is always expected):

Right, this is why I suggested doing it like that. It's not very smart
to split related members like that, wastes both memory and is less
efficient than doing the right thing.

>> I stopped reading here, the patch is just too long. Surely this could be
>> split up?
>>
>>  1 file changed, 1292 insertions(+), 477 deletions(-)
>>
>> That's not a patch, that's a patch series.
> 
> I don't want to upset you or the community but saying this but:
> in this narrow instance where a sizable percentage of the file got
> rewritten: to properly review this work you need to look at the full
> scope of the changes in combination.

That's nonsense. That's like saying "to see what this series does, apply
the whole thing and compare it with the file before". With that logic,
why even split changes ever.

A big patch that could be split is harder to properly review than a lot
of small patches. Nobody ever reviews a 1000+ line patch. But I guess we
can just stop reviewing?

It should be split, it's really not up for debate.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

