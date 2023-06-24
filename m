Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E25C04FDF
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971639;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KOnR/tn+PTF7d0Lr5SaATFYIyBERpyshi9FFruJAB+I=;
	b=YQsuLjpuhhEsIHzhwRusyh91bQPJDABOas8a0+jeadmxwNGUSjjnMFEKYd9Ajqw8mkaJXb
	E00uF6KMNACRBu0t0okIdDK3RTL8usJX4fPor6VhZImW6bnJxhzkfqIZT+e43J4Q3fiLYk
	kKCyxv1yd1yG4oFYWeNToAAzlJl1Km8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-AOi7xjyOPd64glBVt37wlw-1; Mon, 10 Jul 2023 02:47:12 -0400
X-MC-Unique: AOi7xjyOPd64glBVt37wlw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC6F483DCC0;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 89109C575E5;
	Mon, 10 Jul 2023 06:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25E9E193F51B;
	Mon, 10 Jul 2023 06:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 902A21946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 11:08:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26F6F14682FB; Sat, 24 Jun 2023 11:08:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E320140EBB8
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 11:08:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0023F80027F
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 11:08:33 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-5OSzMbYeMEaisjBKH2qNkw-1; Sat, 24 Jun 2023 07:08:30 -0400
X-MC-Unique: 5OSzMbYeMEaisjBKH2qNkw-1
Received: by mail-pl1-f175.google.com with SMTP id
 d9443c01a7336-1b693afe799so2529915ad.1
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 04:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687604909; x=1690196909;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=7tnz7s8ew6fhhs0dR9M9QnK0rlCy7+XAhEAWksz3vrg=;
 b=W2ulXVMgWKo1NYsZkmwsH1/obbtOSt6x0cylJ7rNcqCKAWBvJvxE5sEv63E0p09g58
 nsIgXfl1BFwyaM0TT9Nc6oagyM6h7I+BNxG7Ev0olLt5kCmQuYp72Oz1t64fsS5Ttv0R
 YLqxw6+Rh0ptddO9vmvv5PZE9wq+Gi60s7+GfhdBmx8yeebpA6n1+umzdpyG3OQenj4B
 xZuly+5nERgphFWYIBxjyDSI++EHJYuy9Ilpr3n7KKzSwA0PxLvfuOe9WgFFhIpk3eM0
 Ozgq07bydSc3HfCN/5LDY/OYxACeypAr385lTtgJWSBWHlgB3DKtpelB8RDkfczKG4D4
 Izig==
X-Gm-Message-State: AC+VfDyB7Qwh42i5IGxPHikMlxQBnHqguSwCkmoPjrmuh6SSErKu+IRq
 Y3ONmR6lfdWTApAqe8HjgIzfeg==
X-Google-Smtp-Source: ACHHUZ48xugwBy1Yb59MA7iADNA4mtjxjJVDK/TEG1GiFnnp8kgPq3uDjFXVnvd+Ayx9tItAR27KLA==
X-Received: by 2002:a17:903:32c4:b0:1b3:e352:6d88 with SMTP id
 i4-20020a17090332c400b001b3e3526d88mr29305254plr.6.1687604908733; 
 Sat, 24 Jun 2023 04:08:28 -0700 (PDT)
Received: from [10.4.162.153] ([139.177.225.251])
 by smtp.gmail.com with ESMTPSA id
 bg6-20020a1709028e8600b001b3d0aff88fsm1021644plb.109.2023.06.24.04.08.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Jun 2023 04:08:28 -0700 (PDT)
Message-ID: <a7baf44a-1eb8-d4e1-d112-93cf9cdb7beb@bytedance.com>
Date: Sat, 24 Jun 2023 19:08:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Dave Chinner <david@fromorbit.com>, paulmck@kernel.org
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
 <ZJU708VIyJ/3StAX@dread.disaster.area>
 <a21047bb-3b87-a50a-94a7-f3fa4847bc08@bytedance.com>
 <ZJYaYv4pACmCaBoT@dread.disaster.area>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZJYaYv4pACmCaBoT@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Dave,

On 2023/6/24 06:19, Dave Chinner wrote:
> On Fri, Jun 23, 2023 at 09:10:57PM +0800, Qi Zheng wrote:
>> On 2023/6/23 14:29, Dave Chinner wrote:
>>> On Thu, Jun 22, 2023 at 05:12:02PM +0200, Vlastimil Babka wrote:
>>>> On 6/22/23 10:53, Qi Zheng wrote:
>>> Yes, I suggested the IDR route because radix tree lookups under RCU
>>> with reference counted objects are a known safe pattern that we can
>>> easily confirm is correct or not.  Hence I suggested the unification
>>> + IDR route because it makes the life of reviewers so, so much
>>> easier...
>>
>> In fact, I originally planned to try the unification + IDR method you
>> suggested at the beginning. But in the case of CONFIG_MEMCG disabled,
>> the struct mem_cgroup is not even defined, and root_mem_cgroup and
>> shrinker_info will not be allocated.  This required more code changes, so
>> I ended up keeping the shrinker_list and implementing the above pattern.
> 
> Yes. Go back and read what I originally said needed to be done
> first. In the case of CONFIG_MEMCG=n, a dummy root memcg still needs
> to exist that holds all of the global shrinkers. Then shrink_slab()
> is only ever passed a memcg that should be iterated.
> 
> Yes, it needs changes external to the shrinker code itself to be
> made to work. And even if memcg's are not enabled, we can still use
> the memcg structures to ensure a common abstraction is used for the
> shrinker tracking infrastructure....

Yeah, what I imagined before was to define a more concise struct
mem_cgroup in the case of CONFIG_MEMCG=n, then allocate a dummy root
memcg on system boot:

#ifdef !CONFIG_MEMCG

struct shrinker_info {
	struct rcu_head rcu;
	atomic_long_t *nr_deferred;
	unsigned long *map;
	int map_nr_max;
};

struct mem_cgroup_per_node {
	struct shrinker_info __rcu	*shrinker_info;
};

struct mem_cgroup {
	struct mem_cgroup_per_node *nodeinfo[];
};

#endif

But I have a concern: if all global shrinkers are tracking with the
info->map of root memcg, a shrinker->id needs to be assigned to them,
which will cause info->map_nr_max to become larger than before, then
making the traversal of info->map slower.

> 
>> If the above pattern is not safe, I will go back to the unification +
>> IDR method.
> 
> And that is exactly how we got into this mess in the first place....

I only found one similar pattern in the kernel:

fs/smb/server/oplock.c:find_same_lease_key/smb_break_all_levII_oplock/lookup_lease_in_table

But IIUC, the refcount here needs to be decremented after holding
rcu lock as I did above.

So regardless of whether we choose unification + IDR in the end, I still
want to confirm whether the pattern I implemented above is safe. :)

Thanks,
Qi

> 
> -Dave

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

