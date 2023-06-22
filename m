Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65515C001DC
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687498019;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rLOjpsVVFkuofUpXaBxOcfhYb/GQmIMwEVtno7zWxys=;
	b=cA+N20IozhxmmwqsztQ/il1VraEHp7tRw9PzU5DLJubVuGr4xe0d1kqMd3wHxvV8nXXjE3
	jWlkkKLp1FEs5cB+FeUI0lXganlSlye1pgwQISbPSdg7g6Vc6PXVgjr5M5x0rJPrgYRl9f
	11tt9dHJ1TZh0TCbmrEZRFxrOvEhGcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-c3efVsHoOd6TkDOQW2Tnmg-1; Fri, 23 Jun 2023 01:26:54 -0400
X-MC-Unique: c3efVsHoOd6TkDOQW2Tnmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F196894EDB;
	Fri, 23 Jun 2023 05:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C064C478CF;
	Fri, 23 Jun 2023 05:26:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5722519451C4;
	Fri, 23 Jun 2023 05:25:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AFAFC1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 16:42:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 924D540462BF; Thu, 22 Jun 2023 16:42:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B33940C6CD1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:42:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DE4390ED23
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:42:57 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-QfY2TtdtOvmbrjxjykzlwg-1; Thu, 22 Jun 2023 12:42:52 -0400
X-MC-Unique: QfY2TtdtOvmbrjxjykzlwg-1
Received: by mail-pl1-f178.google.com with SMTP id
 d9443c01a7336-1b50a419ab6so12328585ad.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 09:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687452171; x=1690044171;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=oifDDt/8MZ0rdnM+EbP9Ms7uDYDrGRiSNH3qP5ivz9M=;
 b=d+35rcIP8TMaLYh4z7KQZADWNYKbFTa+bUZtom9XrRX7PuTYiR3Er4xtPSy8tPGP51
 o0RK+42H7e3SSVjKjwVc+DzZol30WfmcRJgd1jwZ4hK3zYKyrtnwBXTvZ+wlRhNFZmvg
 xXwGn9k89W8cwrg1By65NAVoTYWZKUt+Rg9Go0hxcD543swAcB0tOx5MspliyV7T52pA
 vC9LSh8gcp/Xo14/HFUjNTi5lDryGxVjIaeRfOpfYqSfILZmE7l+x2QLt9aJCGe5UpYX
 bzshUcxmGYn7JxRx5/t8D7afRL4SsJqBYxiNNWA1ItmpA+SfQcE2Yj0Tn4QraWr2/jVN
 WPAQ==
X-Gm-Message-State: AC+VfDxw5Ci6uLlcB1XKRVlomp3QHoFKhvH+FAPumR26jZyppmcfaxG1
 bMDOoraMWkEzkI7onxpfDWRS7w==
X-Google-Smtp-Source: ACHHUZ5eOaprsNeMGoS/c3YRbgjq0Q3etzQC5gGN62kzJzL3UknVNp4h1mzWf/mLVXZ4etMQnPzcug==
X-Received: by 2002:a17:902:da91:b0:1b0:3d54:358f with SMTP id
 j17-20020a170902da9100b001b03d54358fmr22008253plx.0.1687452170916; 
 Thu, 22 Jun 2023 09:42:50 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 o5-20020a1709026b0500b001b077301a58sm5615540plk.79.2023.06.22.09.42.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 22 Jun 2023 09:42:50 -0700 (PDT)
Message-ID: <bfcf8b34-2efc-258e-bcec-d6ce10220205@bytedance.com>
Date: Fri, 23 Jun 2023 00:42:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
 david@fromorbit.com, tkhai@ya.ru, roman.gushchin@linux.dev,
 djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2023/6/22 23:12, Vlastimil Babka wrote:
> On 6/22/23 10:53, Qi Zheng wrote:
>> The shrinker_rwsem is a global read-write lock in
>> shrinkers subsystem, which protects most operations
>> such as slab shrink, registration and unregistration
>> of shrinkers, etc. This can easily cause problems in
>> the following cases.
>>
>> 1) When the memory pressure is high and there are many
>>     filesystems mounted or unmounted at the same time,
>>     slab shrink will be affected (down_read_trylock()
>>     failed).
>>
>>     Such as the real workload mentioned by Kirill Tkhai:
>>
>>     ```
>>     One of the real workloads from my experience is start
>>     of an overcommitted node containing many starting
>>     containers after node crash (or many resuming containers
>>     after reboot for kernel update). In these cases memory
>>     pressure is huge, and the node goes round in long reclaim.
>>     ```
>>
>> 2) If a shrinker is blocked (such as the case mentioned
>>     in [1]) and a writer comes in (such as mount a fs),
>>     then this writer will be blocked and cause all
>>     subsequent shrinker-related operations to be blocked.
>>
>> Even if there is no competitor when shrinking slab, there
>> may still be a problem. If we have a long shrinker list
>> and we do not reclaim enough memory with each shrinker,
>> then the down_read_trylock() may be called with high
>> frequency. Because of the poor multicore scalability of
>> atomic operations, this can lead to a significant drop
>> in IPC (instructions per cycle).
>>
>> We used to implement the lockless slab shrink with
>> SRCU [1], but then kernel test robot reported -88.8%
>> regression in stress-ng.ramfs.ops_per_sec test case [2],
>> so we reverted it [3].
>>
>> This commit uses the refcount+RCU method [4] proposed by
>> by Dave Chinner to re-implement the lockless global slab
>> shrink. The memcg slab shrink is handled in the subsequent
>> patch.
>>
>> Currently, the shrinker instances can be divided into
>> the following three types:
>>
>> a) global shrinker instance statically defined in the kernel,
>> such as workingset_shadow_shrinker.
>>
>> b) global shrinker instance statically defined in the kernel
>> modules, such as mmu_shrinker in x86.
>>
>> c) shrinker instance embedded in other structures.
>>
>> For case a, the memory of shrinker instance is never freed.
>> For case b, the memory of shrinker instance will be freed
>> after the module is unloaded. But we will call synchronize_rcu()
>> in free_module() to wait for RCU read-side critical section to
>> exit. For case c, the memory of shrinker instance will be
>> dynamically freed by calling kfree_rcu(). So we can use
>> rcu_read_{lock,unlock}() to ensure that the shrinker instance
>> is valid.
>>
>> The shrinker::refcount mechanism ensures that the shrinker
>> instance will not be run again after unregistration. So the
>> structure that records the pointer of shrinker instance can be
>> safely freed without waiting for the RCU read-side critical
>> section.
>>
>> In this way, while we implement the lockless slab shrink, we
>> don't need to be blocked in unregister_shrinker() to wait
>> RCU read-side critical section.
>>
>> The following are the test results:
>>
>> stress-ng --timeout 60 --times --verify --metrics-brief --ramfs 9 &
>>
>> 1) Before applying this patchset:
>>
>>   setting to a 60 second run per stressor
>>   dispatching hogs: 9 ramfs
>>   stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
>>                             (secs)    (secs)    (secs)   (real time) (usr+sys time)
>>   ramfs            880623     60.02      7.71    226.93     14671.45        3753.09
>>   ramfs:
>>            1 System Management Interrupt
>>   for a 60.03s run time:
>>      5762.40s available CPU time
>>         7.71s user time   (  0.13%)
>>       226.93s system time (  3.94%)
>>       234.64s total time  (  4.07%)
>>   load average: 8.54 3.06 2.11
>>   passed: 9: ramfs (9)
>>   failed: 0
>>   skipped: 0
>>   successful run completed in 60.03s (1 min, 0.03 secs)
>>
>> 2) After applying this patchset:
>>
>>   setting to a 60 second run per stressor
>>   dispatching hogs: 9 ramfs
>>   stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
>>                             (secs)    (secs)    (secs)   (real time) (usr+sys time)
>>   ramfs            847562     60.02      7.44    230.22     14120.66        3566.23
>>   ramfs:
>>            4 System Management Interrupts
>>   for a 60.12s run time:
>>      5771.95s available CPU time
>>         7.44s user time   (  0.13%)
>>       230.22s system time (  3.99%)
>>       237.66s total time  (  4.12%)
>>   load average: 8.18 2.43 0.84
>>   passed: 9: ramfs (9)
>>   failed: 0
>>   skipped: 0
>>   successful run completed in 60.12s (1 min, 0.12 secs)
>>
>> We can see that the ops/s has hardly changed.
>>
>> [1]. https://lore.kernel.org/lkml/20230313112819.38938-1-zhengqi.arch@bytedance.com/
>> [2]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
>> [3]. https://lore.kernel.org/all/20230609081518.3039120-1-qi.zheng@linux.dev/
>> [4]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/shrinker.h |  6 ++++++
>>   mm/vmscan.c              | 33 ++++++++++++++-------------------
>>   2 files changed, 20 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>> index 7bfeb2f25246..b0c6c2df9db8 100644
>> --- a/include/linux/shrinker.h
>> +++ b/include/linux/shrinker.h
>> @@ -74,6 +74,7 @@ struct shrinker {
>>   
>>   	refcount_t refcount;
>>   	struct completion completion_wait;
>> +	struct rcu_head rcu;
>>   
>>   	void *private_data;
>>   
>> @@ -123,6 +124,11 @@ struct shrinker *shrinker_alloc_and_init(count_objects_cb count,
>>   void shrinker_free(struct shrinker *shrinker);
>>   void unregister_and_free_shrinker(struct shrinker *shrinker);
>>   
>> +static inline bool shrinker_try_get(struct shrinker *shrinker)
>> +{
>> +	return refcount_inc_not_zero(&shrinker->refcount);
>> +}
>> +
>>   static inline void shrinker_put(struct shrinker *shrinker)
>>   {
>>   	if (refcount_dec_and_test(&shrinker->refcount))
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6f9c4750effa..767569698946 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -57,6 +57,7 @@
>>   #include <linux/khugepaged.h>
>>   #include <linux/rculist_nulls.h>
>>   #include <linux/random.h>
>> +#include <linux/rculist.h>
>>   
>>   #include <asm/tlbflush.h>
>>   #include <asm/div64.h>
>> @@ -742,7 +743,7 @@ void register_shrinker_prepared(struct shrinker *shrinker)
>>   	down_write(&shrinker_rwsem);
>>   	refcount_set(&shrinker->refcount, 1);
>>   	init_completion(&shrinker->completion_wait);
>> -	list_add_tail(&shrinker->list, &shrinker_list);
>> +	list_add_tail_rcu(&shrinker->list, &shrinker_list);
>>   	shrinker->flags |= SHRINKER_REGISTERED;
>>   	shrinker_debugfs_add(shrinker);
>>   	up_write(&shrinker_rwsem);
>> @@ -800,7 +801,7 @@ void unregister_shrinker(struct shrinker *shrinker)
>>   	wait_for_completion(&shrinker->completion_wait);
>>   
>>   	down_write(&shrinker_rwsem);
>> -	list_del(&shrinker->list);
>> +	list_del_rcu(&shrinker->list);
>>   	shrinker->flags &= ~SHRINKER_REGISTERED;
>>   	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
>>   		unregister_memcg_shrinker(shrinker);
>> @@ -845,7 +846,7 @@ EXPORT_SYMBOL(shrinker_free);
>>   void unregister_and_free_shrinker(struct shrinker *shrinker)
>>   {
>>   	unregister_shrinker(shrinker);
>> -	kfree(shrinker);
>> +	kfree_rcu(shrinker, rcu);
>>   }
>>   EXPORT_SYMBOL(unregister_and_free_shrinker);
>>   
>> @@ -1067,33 +1068,27 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>>   	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
>>   		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
>>   
>> -	if (!down_read_trylock(&shrinker_rwsem))
>> -		goto out;
>> -
>> -	list_for_each_entry(shrinker, &shrinker_list, list) {
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(shrinker, &shrinker_list, list) {
>>   		struct shrink_control sc = {
>>   			.gfp_mask = gfp_mask,
>>   			.nid = nid,
>>   			.memcg = memcg,
>>   		};
>>   
>> +		if (!shrinker_try_get(shrinker))
>> +			continue;
>> +		rcu_read_unlock();
> 
> I don't think you can do this unlock?
> 
>> +
>>   		ret = do_shrink_slab(&sc, shrinker, priority);
>>   		if (ret == SHRINK_EMPTY)
>>   			ret = 0;
>>   		freed += ret;
>> -		/*
>> -		 * Bail out if someone want to register a new shrinker to
>> -		 * prevent the registration from being stalled for long periods
>> -		 * by parallel ongoing shrinking.
>> -		 */
>> -		if (rwsem_is_contended(&shrinker_rwsem)) {
>> -			freed = freed ? : 1;
>> -			break;
>> -		}
>> -	}
>>   
>> -	up_read(&shrinker_rwsem);
>> -out:
>> +		rcu_read_lock();
> 
> That new rcu_read_lock() won't help AFAIK, the whole
> list_for_each_entry_rcu() needs to be under the single rcu_read_lock() to be
> safe.

In the unregister_shrinker() path, we will wait for the refcount to zero
before deleting the shrinker from the linked list. Here, we first took
the rcu lock, and then decrement the refcount of this shrinker.

     shrink_slab                 unregister_shrinker
     ===========                 ===================
				
				/* wait for B */
				wait_for_completion()
   rcu_read_lock()

   shrinker_put() --> (B)
				list_del_rcu()
                                 /* wait for rcu_read_unlock() */
				kfree_rcu()

   /*
    * so this shrinker will not be freed here,
    * and can be used to traverse the next node
    * normally?
    */
   list_for_each_entry()

   shrinker_try_get()
   rcu_read_unlock()

Did I miss something?

> 
> IIUC this is why Dave in [4] suggests unifying shrink_slab() with
> shrink_slab_memcg(), as the latter doesn't iterate the list but uses IDR.
> 
>> +		shrinker_put(shrinker);
>> +	}
>> +	rcu_read_unlock();
>>   	cond_resched();
>>   	return freed;
>>   }
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

