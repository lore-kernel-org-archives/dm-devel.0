Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D266EB64DC
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971644;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=njUGHOtelN/2NjrrvVXoZFTisMqMNny04tbqwUV6cc8=;
	b=Q++OsULVDHVxv+1XoKBb8te6VYiaW85Lg74guBNz2076zqkTEPNGxPNfHakO+rzxwQjA3p
	+XddJijjbe9sczzpQv2DXk0Tj+w80F8mw3RRRhIoyJx52sEG60MCsZZqec7hibZexHMGB8
	WmXNQWM+5OF2RWUxq0ccvqNlUGnTdiQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-ibfOgdCHPECQ3WE0-r343Q-1; Mon, 10 Jul 2023 02:47:21 -0400
X-MC-Unique: ibfOgdCHPECQ3WE0-r343Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AA1A10504BE;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 60EC6C54FBC;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 892F719451DE;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 18C8C1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 13:11:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFEF7F5AC5; Fri, 23 Jun 2023 13:11:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8706422B0
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:11:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA36087322C
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 13:11:11 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-GADI8lIvN6uiBWCiAiVFdg-1; Fri, 23 Jun 2023 09:11:09 -0400
X-MC-Unique: GADI8lIvN6uiBWCiAiVFdg-1
Received: by mail-pj1-f54.google.com with SMTP id
 98e67ed59e1d1-25edb2433b8so123012a91.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687525868; x=1690117868;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=/7x6DiXSOkypZgSRa+BISNq5WosZP8Hu0i35XNPtJQQ=;
 b=ZAMiqg/MI5b393BKcuWhDtTV7e/YBduERVAZCve1Q5hT0V+TBiOjtNdWE1AbZ0he3J
 AV3Kh61YaPd5P1uvJYsbTAxb8jgYqpGjM4ifTMDGUWW+FvJQXOgaTNGH4AzyQLDvFe2t
 jpApO8SxkwRKIyTXEfHeuzVfT6xmn6r0SkZmv/pu0RYuTQ1FI3LN4TZPKZ5U9HZE6euv
 5zgLebE0HcqvzOk30qdx2yrC6cEYTubDCQ4tIamY3K6dvI+NBjwd7B5H4hwoYI1lGPmI
 4VK+oUBVIlMhCUgYTJan8DsxgjNa8InBqIakMBjr0jKRkvRZ1jXI1uw9JDeoqZ9HSHPl
 Vq2g==
X-Gm-Message-State: AC+VfDyaBs30ekyPONxfZiKDMYa14cu3lO0BDJudydtvJbzs84kk/j8p
 XI0nvRCn6xj0CQlyMW36IqEJ1w==
X-Google-Smtp-Source: ACHHUZ64Jh43TfSAOTNgwrqo87qYAZfwOnz5bgoh5xCGMYf1cG7+iQJqF84ndnWAmMn6TwTiYqZEBw==
X-Received: by 2002:a17:90b:1bc2:b0:258:9621:913f with SMTP id
 oa2-20020a17090b1bc200b002589621913fmr25470832pjb.3.1687525867887; 
 Fri, 23 Jun 2023 06:11:07 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 1-20020a17090a198100b0024e49b53c24sm1568646pji.10.2023.06.23.06.11.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 06:11:07 -0700 (PDT)
Message-ID: <a21047bb-3b87-a50a-94a7-f3fa4847bc08@bytedance.com>
Date: Fri, 23 Jun 2023 21:10:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Dave Chinner <david@fromorbit.com>, Vlastimil Babka <vbabka@suse.cz>,
 paulmck@kernel.org
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZJU708VIyJ/3StAX@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 24/29] mm: vmscan: make global slab shrink
 lockless
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, brauner@kernel.org,
 tytso@mit.edu, djwong@kernel.org, intel-gfx@lists.freedesktop.org,
 roman.gushchin@linux.dev, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/6/23 14:29, Dave Chinner wrote:
> On Thu, Jun 22, 2023 at 05:12:02PM +0200, Vlastimil Babka wrote:
>> On 6/22/23 10:53, Qi Zheng wrote:
>>> @@ -1067,33 +1068,27 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>>>   	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
>>>   		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
>>>   
>>> -	if (!down_read_trylock(&shrinker_rwsem))
>>> -		goto out;
>>> -
>>> -	list_for_each_entry(shrinker, &shrinker_list, list) {
>>> +	rcu_read_lock();
>>> +	list_for_each_entry_rcu(shrinker, &shrinker_list, list) {
>>>   		struct shrink_control sc = {
>>>   			.gfp_mask = gfp_mask,
>>>   			.nid = nid,
>>>   			.memcg = memcg,
>>>   		};
>>>   
>>> +		if (!shrinker_try_get(shrinker))
>>> +			continue;
>>> +		rcu_read_unlock();
>>
>> I don't think you can do this unlock?
>>
>>> +
>>>   		ret = do_shrink_slab(&sc, shrinker, priority);
>>>   		if (ret == SHRINK_EMPTY)
>>>   			ret = 0;
>>>   		freed += ret;
>>> -		/*
>>> -		 * Bail out if someone want to register a new shrinker to
>>> -		 * prevent the registration from being stalled for long periods
>>> -		 * by parallel ongoing shrinking.
>>> -		 */
>>> -		if (rwsem_is_contended(&shrinker_rwsem)) {
>>> -			freed = freed ? : 1;
>>> -			break;
>>> -		}
>>> -	}
>>>   
>>> -	up_read(&shrinker_rwsem);
>>> -out:
>>> +		rcu_read_lock();
>>
>> That new rcu_read_lock() won't help AFAIK, the whole
>> list_for_each_entry_rcu() needs to be under the single rcu_read_lock() to be
>> safe.
> 
> Yeah, that's the pattern we've been taught and the one we can look
> at and immediately say "this is safe".
> 
> This is a different pattern, as has been explained bi Qi, and I
> think it *might* be safe.
> 
> *However.*
> 
> Right now I don't have time to go through a novel RCU list iteration
> pattern it one step at to determine the correctness of the
> algorithm. I'm mostly worried about list manipulations that can
> occur outside rcu_read_lock() section bleeding into the RCU
> critical section because rcu_read_lock() by itself is not a memory
> barrier.
> 
> Maybe Paul has seen this pattern often enough he could simply tell
> us what conditions it is safe in. But for me to work that out from
> first principles? I just don't have the time to do that right now.

Hi Paul, can you help to confirm this?

> 
>> IIUC this is why Dave in [4] suggests unifying shrink_slab() with
>> shrink_slab_memcg(), as the latter doesn't iterate the list but uses IDR.
> 
> Yes, I suggested the IDR route because radix tree lookups under RCU
> with reference counted objects are a known safe pattern that we can
> easily confirm is correct or not.  Hence I suggested the unification
> + IDR route because it makes the life of reviewers so, so much
> easier...

In fact, I originally planned to try the unification + IDR method you
suggested at the beginning. But in the case of CONFIG_MEMCG disabled,
the struct mem_cgroup is not even defined, and root_mem_cgroup and
shrinker_info will not be allocated. This required more code changes, so
I ended up keeping the shrinker_list and implementing the above pattern.

If the above pattern is not safe, I will go back to the unification +
IDR method.

Thanks,
Qi

> 
> Cheers,
> 
> Dave.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

