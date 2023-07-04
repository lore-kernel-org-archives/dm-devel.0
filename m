Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A91C001DD
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971644;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6VcubtN2Nt1bWKMc5t6CCPDmjm5AsjlQNkkxwuzOoLs=;
	b=EoMroQaaAsD3DeXtG56X/FnFHKsYYCB9tsTglxS5fTW9LR0HTPyNoRpia7FMDilSxIQHx+
	c6rTtr2TSoO9aDmqB0fNH+OoOaTi9aRyPXK587zFuwfnvSkDLFlk4q00137nnSYrYN35qe
	ZCbpDnyFgy8zScCNcM9CdSfKjDel3kg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-NGMPSG0gNYKw54MxEWmY2Q-1; Mon, 10 Jul 2023 02:47:20 -0400
X-MC-Unique: NGMPSG0gNYKw54MxEWmY2Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C43280D209;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02DCB492B01;
	Mon, 10 Jul 2023 06:47:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B77E19451D7;
	Mon, 10 Jul 2023 06:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02E4B1946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  4 Jul 2023 03:45:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E48ED1121315; Tue,  4 Jul 2023 03:45:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD0571121314
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 03:45:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABD43811F26
 for <dm-devel@redhat.com>; Tue,  4 Jul 2023 03:45:30 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
 [209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-Pfn9mRsgO4-XyYC7ga_Oww-1; Mon, 03 Jul 2023 23:45:29 -0400
X-MC-Unique: Pfn9mRsgO4-XyYC7ga_Oww-1
Received: by mail-pl1-f181.google.com with SMTP id
 d9443c01a7336-1b7e0904a3aso5922925ad.0
 for <dm-devel@redhat.com>; Mon, 03 Jul 2023 20:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688442328; x=1691034328;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=MFeBrddeuJ5VLdpmCCc9Ly4sKMWZlJ9dQaH0OIDXyXU=;
 b=jjIXz+YJioyEkBJLwXgP7RMQm9nRRGo0CqPDC7Cx9Q+T1rzUuPcFjODTnWgi7dmHdm
 cRXgIaCvmKzuJeXw2AuM+0rprCgnCaSSv+rlHWSRo505cBJ8C1vHUDqJm3K6y0BWVDoX
 Y62blMxZVvMaKo52bTv+SnRlorq43Da/mCstNKndMpJYMfEHrRjA41OrZyRX9YJSvamP
 8LMQgjH3Jqe4AuxL0sRQwuPPhqkGR7V0K3WuaJMJk9k624fq779iBY7XWXDYfb6RDpnP
 9NZkebO7GbQ7YaLNriIVPg5c+hnqfPWZ5XqqtblVSygGRR8mPEDAi6ObpMfVz2CI/ygy
 ivtg==
X-Gm-Message-State: ABy/qLZfGfsWFrOYcREk7srz7CbHO87hf1k1LxO+dcnKIUaGS7HHs1ji
 aET31ZIQscCfcuwV9MZvOhqyNQ==
X-Google-Smtp-Source: APBJJlF81QfMj+OzGuweGT/AC35DngvuObAYHLJM7qqWJeHFGWrQw9pznSu7LGwsdhDNw+giWeybWA==
X-Received: by 2002:a17:902:b20b:b0:1ae:4567:2737 with SMTP id
 t11-20020a170902b20b00b001ae45672737mr12710934plr.2.1688442328020; 
 Mon, 03 Jul 2023 20:45:28 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 az10-20020a170902a58a00b001b1866f7b5csm15891733plb.138.2023.07.03.20.45.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 03 Jul 2023 20:45:27 -0700 (PDT)
Message-ID: <3efa68e0-b04f-5c11-4fe2-2db0784064fc@bytedance.com>
Date: Tue, 4 Jul 2023 11:45:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: paulmck@kernel.org, Dave Chinner <david@fromorbit.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
 <cc894c77-717a-4e9f-b649-48bab40e7c60@paulmck-laptop>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <cc894c77-717a-4e9f-b649-48bab40e7c60@paulmck-laptop>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 linux-btrfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/7/4 00:39, Paul E. McKenney wrote:
> On Fri, Jun 23, 2023 at 04:29:39PM +1000, Dave Chinner wrote:
>> On Thu, Jun 22, 2023 at 05:12:02PM +0200, Vlastimil Babka wrote:
>>> On 6/22/23 10:53, Qi Zheng wrote:
>>>> @@ -1067,33 +1068,27 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>>>>   	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
>>>>   		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
>>>>   
>>>> -	if (!down_read_trylock(&shrinker_rwsem))
>>>> -		goto out;
>>>> -
>>>> -	list_for_each_entry(shrinker, &shrinker_list, list) {
>>>> +	rcu_read_lock();
>>>> +	list_for_each_entry_rcu(shrinker, &shrinker_list, list) {
>>>>   		struct shrink_control sc = {
>>>>   			.gfp_mask = gfp_mask,
>>>>   			.nid = nid,
>>>>   			.memcg = memcg,
>>>>   		};
>>>>   
>>>> +		if (!shrinker_try_get(shrinker))
>>>> +			continue;
>>>> +		rcu_read_unlock();
>>>
>>> I don't think you can do this unlock?
> 
> Sorry to be slow to respond here, this one fell through the cracks.
> And thank you to Qi for reminding me!
> 
> If you do this unlock, you had jolly well better nail down the current
> element (the one referenced by shrinker), for example, by acquiring an
> explicit reference count on the object.  And presumably this is exactly
> what shrinker_try_get() is doing.  And a look at your 24/29 confirms this,
> at least assuming that shrinker->refcount is set to zero before the call
> to synchronize_rcu() in free_module() *and* that synchronize_rcu() doesn't
> start until *after* shrinker_put() calls complete().  Plus, as always,
> the object must be removed from the list before the synchronize_rcu()
> starts.  (On these parts of the puzzle, I defer to those more familiar
> with this code path.  And I strongly suggest carefully commenting this
> type of action-at-a-distance design pattern.)

Yeah, I think I've done it like above. A more detailed timing diagram is
below.

> 
> Why is this important?  Because otherwise that object might be freed
> before you get to the call to rcu_read_lock() at the end of this loop.
> And if that happens, list_for_each_entry_rcu() will be walking the
> freelist, which is quite bad for the health and well-being of your kernel.
> 
> There are a few other ways to make this sort of thing work:
> 
> 1.	Defer the shrinker_put() to the beginning of the loop.
> 	You would need a flag initially set to zero, and then set to
> 	one just before (or just after) the rcu_read_lock() above.
> 	You would also need another shrinker_old pointer to track the
> 	old pointer.  Then at the top of the loop, if the flag is set,
> 	invoke shrinker_put() on shrinker_old.	This ensures that the
> 	previous shrinker structure stays around long enough to allow
> 	the loop to find the next shrinker structure in the list.
> 
> 	This approach is attractive when the removal code path
> 	can invoke shrinker_put() after the grace period ends.
> 
> 2.	Make shrinker_put() invoke call_rcu() when ->refcount reaches
> 	zero, and have the callback function free the object.  This of
> 	course requires adding an rcu_head structure to the shrinker
> 	structure, which might or might not be a reasonable course of
> 	action.  If adding that rcu_head is reasonable, this simplifies
> 	the logic quite a bit.
> 
> 3.	For the shrinker-structure-removal code path, remove the shrinker
> 	structure, then remove the initial count from ->refcount,
> 	and then keep doing grace periods until ->refcount is zero,
> 	then do one more.  Of course, if the result of removing the
> 	initial count was zero, then only a single additional grace
> 	period is required.
> 
> 	This would need to be carefully commented, as it is a bit
> 	unconventional.

Thanks for such a detailed addition!

> 
> There are probably many other ways, but just to give an idea of a few
> other ways to do this.
> 
>>>> +
>>>>   		ret = do_shrink_slab(&sc, shrinker, priority);
>>>>   		if (ret == SHRINK_EMPTY)
>>>>   			ret = 0;
>>>>   		freed += ret;
>>>> -		/*
>>>> -		 * Bail out if someone want to register a new shrinker to
>>>> -		 * prevent the registration from being stalled for long periods
>>>> -		 * by parallel ongoing shrinking.
>>>> -		 */
>>>> -		if (rwsem_is_contended(&shrinker_rwsem)) {
>>>> -			freed = freed ? : 1;
>>>> -			break;
>>>> -		}
>>>> -	}
>>>>   
>>>> -	up_read(&shrinker_rwsem);
>>>> -out:
>>>> +		rcu_read_lock();
>>>
>>> That new rcu_read_lock() won't help AFAIK, the whole
>>> list_for_each_entry_rcu() needs to be under the single rcu_read_lock() to be
>>> safe.
>>
>> Yeah, that's the pattern we've been taught and the one we can look
>> at and immediately say "this is safe".
>>
>> This is a different pattern, as has been explained bi Qi, and I
>> think it *might* be safe.
>>
>> *However.*
>>
>> Right now I don't have time to go through a novel RCU list iteration
>> pattern it one step at to determine the correctness of the
>> algorithm. I'm mostly worried about list manipulations that can
>> occur outside rcu_read_lock() section bleeding into the RCU
>> critical section because rcu_read_lock() by itself is not a memory
>> barrier.
>>
>> Maybe Paul has seen this pattern often enough he could simply tell
>> us what conditions it is safe in. But for me to work that out from
>> first principles? I just don't have the time to do that right now.
> 
> If the code does just the right sequence of things on the removal path
> (remove, decrement reference, wait for reference to go to zero, wait for
> grace period, free), then it would work.  If this is what is happening,
> I would argue for more comments.  ;-)

The order of the removal path is slightly different from this:

     shrink_slab                 unregister_shrinker
     ===========                 ===================
		
    shrinker_try_get()
    rcu_read_unlock()		
                                 1. decrement initial reference
				shrinker_put()
				2. wait for reference to go to zero
				wait_for_completion()
    rcu_read_lock()

    shrinker_put()
				3. remove the shrinker from list
				list_del_rcu()
                                 4. wait for grace period
				kfree_rcu()/synchronize_rcu()


    list_for_each_entry()

    shrinker_try_get()
    rcu_read_unlock()
				5. free the shrinker

So the order is: decrement reference, wait for reference to go to zero,
remove, wait for grace period, free.

I think this can work. And we can only do the *step 3* after we hold the
RCU read lock again, right? Please let me know if I missed something.

Thanks,
Qi

> 
> 							Thanx, Paul
> 
>>> IIUC this is why Dave in [4] suggests unifying shrink_slab() with
>>> shrink_slab_memcg(), as the latter doesn't iterate the list but uses IDR.
>>
>> Yes, I suggested the IDR route because radix tree lookups under RCU
>> with reference counted objects are a known safe pattern that we can
>> easily confirm is correct or not.  Hence I suggested the unification
>> + IDR route because it makes the life of reviewers so, so much
>> easier...
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

