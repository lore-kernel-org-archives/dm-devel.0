Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC27BC04A94
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477619;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sxKQpv41SFQPN++1pmG6Ho7V53G8D0Lw7n4LIaPPtyI=;
	b=Ul49lnW5CqtxJ/9alK0GuW5xXsaadyoEY0SzZOkWW34Wek72RdmMj9D7aiE2DsyMAEsRq6
	js4wJDOnvcaMvUYyC7aLxnkJaQX2oaGRAjKBteb3iV4D/M2Uqny2e3Y3o/s0fWxuSMFYPr
	DUdUSTM1ZdsYf2+wN5R62ABxEDitnrY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-eP0jOdS5PLucLlTvhj7gUg-1; Tue, 08 Aug 2023 02:53:34 -0400
X-MC-Unique: eP0jOdS5PLucLlTvhj7gUg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A99E1010389;
	Tue,  8 Aug 2023 06:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10B3DC1602B;
	Tue,  8 Aug 2023 06:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F93419452CD;
	Tue,  8 Aug 2023 06:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 413221946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 06:33:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 301F21121314; Tue,  8 Aug 2023 06:33:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 27E2F1121315
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 06:33:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBCEF2999B33
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 06:33:14 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-nqCdLfqIOzm4i8IRd99RGQ-1; Tue, 08 Aug 2023 02:33:13 -0400
X-MC-Unique: nqCdLfqIOzm4i8IRd99RGQ-1
Received: by mail-pf1-f176.google.com with SMTP id
 d2e1a72fcca58-6873f64a290so1465089b3a.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 23:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691476392; x=1692081192;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=m1STCrinczuq8FuoUgLs8N4vldOealvmees85dm6MPY=;
 b=bu/wBAt71u+14PFVGMj17QoTlymoAfBknFtHN5wMJAs3JPh+k3UzXMRla7ShFpNeMN
 mZRxYBbgnfWYLqOHdSJCXnXdYZ3PjhTwYYD7r/l7Se2CBnVi67SnL/usk2MMkdwkgNqn
 Kgw6ojpQ85JvP3mA/GWtEGNSHXJSlRvcDbMd+QqM+27fyEDls2J2HDmxuV/PGdWkigfz
 NbcrNbtBGrp+Di650nxagVkRX66yQkuvPGrus8zFlF7a030pGrcTJfVa8GiCr9MsTJ+e
 isr/VGOPm0UXGVY5HaKyiohkmuuYSUf6S8BV/LagCrKbRp4n8Nq1llN1aluzDHKw5vO7
 UpiA==
X-Gm-Message-State: ABy/qLZcqMU47vB6u3PjJs+SHYfa1PlWpQCOQ1EC9yKj5fAnMhsP4HCu
 l26H7OoJqV7duvk2pmFWUtahpQ==
X-Google-Smtp-Source: APBJJlEAHd7r+M3vyCUQDMAxEjMveuzSqb/Q6wUuSUNAB0Ns9zs1qKL/YECIY4J9DtcJjA3HpA/s7A==
X-Received: by 2002:a05:6a21:998c:b0:13d:1ebf:5dfc with SMTP id
 ve12-20020a056a21998c00b0013d1ebf5dfcmr38062815pzb.5.1691476391828; 
 Mon, 07 Aug 2023 23:33:11 -0700 (PDT)
Received: from [10.70.252.135] ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 ff12-20020a056a002f4c00b0067f2f7eccdcsm7204570pfb.193.2023.08.07.23.32.59
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 07 Aug 2023 23:33:11 -0700 (PDT)
Message-ID: <0e7b16ce-19f9-0c70-4a94-f05cbfee613a@bytedance.com>
Date: Tue, 8 Aug 2023 14:32:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
To: Dave Chinner <david@fromorbit.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-45-zhengqi.arch@bytedance.com>
 <ZNGkcp3Dh8hOiFpk@dread.disaster.area>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZNGkcp3Dh8hOiFpk@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: Re: [dm-devel] [PATCH v4 44/48] mm: shrinker: add a secondary array
 for shrinker_info::{map, nr_deferred}
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 cel@kernel.org, x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 simon.horman@corigine.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 linux-nfs@vger.kernel.org, rcu@vger.kernel.org, linux-bcache@vger.kernel.org,
 dlemoal@kernel.org, Muchun Song <songmuchun@bytedance.com>,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 brauner@kernel.org, tytso@mit.edu, gregkh@linuxfoundation.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Dave,

On 2023/8/8 10:12, Dave Chinner wrote:
> On Mon, Aug 07, 2023 at 07:09:32PM +0800, Qi Zheng wrote:
>> Currently, we maintain two linear arrays per node per memcg, which are
>> shrinker_info::map and shrinker_info::nr_deferred. And we need to resize
>> them when the shrinker_nr_max is exceeded, that is, allocate a new array,
>> and then copy the old array to the new array, and finally free the old
>> array by RCU.
>>
>> For shrinker_info::map, we do set_bit() under the RCU lock, so we may set
>> the value into the old map which is about to be freed. This may cause the
>> value set to be lost. The current solution is not to copy the old map when
>> resizing, but to set all the corresponding bits in the new map to 1. This
>> solves the data loss problem, but bring the overhead of more pointless
>> loops while doing memcg slab shrink.
>>
>> For shrinker_info::nr_deferred, we will only modify it under the read lock
>> of shrinker_rwsem, so it will not run concurrently with the resizing. But
>> after we make memcg slab shrink lockless, there will be the same data loss
>> problem as shrinker_info::map, and we can't work around it like the map.
>>
>> For such resizable arrays, the most straightforward idea is to change it
>> to xarray, like we did for list_lru [1]. We need to do xa_store() in the
>> list_lru_add()-->set_shrinker_bit(), but this will cause memory
>> allocation, and the list_lru_add() doesn't accept failure. A possible
>> solution is to pre-allocate, but the location of pre-allocation is not
>> well determined.
> 
> So you implemented a two level array that preallocates leaf
> nodes to work around it? It's remarkable complex for what it does,

Yes, here I have implemented a two level array like the following:

+---------------+--------+--------+-----+
| shrinker_info | unit 0 | unit 1 | ... | (secondary array)
+---------------+--------+--------+-----+
                      ^
                      |
                 +---------------+-----+
                 | nr_deferred[] | map | (leaf array)
                 +---------------+-----+
                 (shrinker_info_unit)

The leaf array is never freed unless the memcg is destroyed. The
secondary array will be resized every time the shrinker id exceeds
shrinker_nr_max.

> I can't help but think a radix tree using a special holder for
> nr_deferred values of zero would end up being simpler...

I tried. If the shrinker uses list_lru, then we can preallocate
xa node where list_lru_one is pre-allocated. But for other types of
shrinkers, the location of pre-allocation is not easy to determine
(Such as deferred_split_shrinker). And we can't force all memcg aware
shrinkers to use list_lru, so I gave up using xarray and implemented the 
above two-level array.

> 
>> Therefore, this commit chooses to introduce a secondary array for
>> shrinker_info::{map, nr_deferred}, so that we only need to copy this
>> secondary array every time the size is resized. Then even if we get the
>> old secondary array under the RCU lock, the found map and nr_deferred are
>> also true, so no data is lost.
> 
> I don't understand what you are trying to describe here. If we get
> the old array, then don't we get either a stale nr_deferred value,
> or the update we do gets lost because the next shrinker lookup will
> find the new array and os the deferred value stored to the old one
> is never seen again?

As shown above, the leaf array will not be freed when shrinker_info is
expanded, so the shrinker_info_unit can be indexed from both the old
and the new shrinker_info->unit[x]. So the updated nr_deferred and map
will not be lost.

> 
>>
>> [1]. https://lore.kernel.org/all/20220228122126.37293-13-songmuchun@bytedance.com/
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
>> ---
> .....
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index a27779ed3798..1911c06b8af5 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -12,15 +12,50 @@ DECLARE_RWSEM(shrinker_rwsem);
>>   #ifdef CONFIG_MEMCG
>>   static int shrinker_nr_max;
>>   
>> -/* The shrinker_info is expanded in a batch of BITS_PER_LONG */
>> -static inline int shrinker_map_size(int nr_items)
>> +static inline int shrinker_unit_size(int nr_items)
>>   {
>> -	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
>> +	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
>>   }
>>   
>> -static inline int shrinker_defer_size(int nr_items)
>> +static inline void shrinker_unit_free(struct shrinker_info *info, int start)
>>   {
>> -	return (round_up(nr_items, BITS_PER_LONG) * sizeof(atomic_long_t));
>> +	struct shrinker_info_unit **unit;
>> +	int nr, i;
>> +
>> +	if (!info)
>> +		return;
>> +
>> +	unit = info->unit;
>> +	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
>> +
>> +	for (i = start; i < nr; i++) {
>> +		if (!unit[i])
>> +			break;
>> +
>> +		kvfree(unit[i]);
>> +		unit[i] = NULL;
>> +	}
>> +}
>> +
>> +static inline int shrinker_unit_alloc(struct shrinker_info *new,
>> +				       struct shrinker_info *old, int nid)
>> +{
>> +	struct shrinker_info_unit *unit;
>> +	int nr = DIV_ROUND_UP(new->map_nr_max, SHRINKER_UNIT_BITS);
>> +	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
>> +	int i;
>> +
>> +	for (i = start; i < nr; i++) {
>> +		unit = kvzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
> 
> A unit is 576 bytes. Why is this using kvzalloc_node()?

Ah, will use kzalloc_node() in the next version.

> 
>> +		if (!unit) {
>> +			shrinker_unit_free(new, start);
>> +			return -ENOMEM;
>> +		}
>> +
>> +		new->unit[i] = unit;
>> +	}
>> +
>> +	return 0;
>>   }
>>   
>>   void free_shrinker_info(struct mem_cgroup *memcg)
>> @@ -32,6 +67,7 @@ void free_shrinker_info(struct mem_cgroup *memcg)
>>   	for_each_node(nid) {
>>   		pn = memcg->nodeinfo[nid];
>>   		info = rcu_dereference_protected(pn->shrinker_info, true);
>> +		shrinker_unit_free(info, 0);
>>   		kvfree(info);
>>   		rcu_assign_pointer(pn->shrinker_info, NULL);
>>   	}
> 
> Why is this safe? The info and maps are looked up by RCU, so why is
> freeing them without a RCU grace period expiring safe?

The free_shrinker_info() will be called in alloc_shrinker_info() and
mem_cgroup_css_free().

In alloc_shrinker_info(), it will only be called in the error path, so
shrinker_info_unit and shrinker_info can be safely freed.

In mem_cgroup_css_free(), when we get here, the traversal of this memcg
has ended and will not be found again. That is to say, the corresponding
shrink_slab() is also over, so shrinker_info_unit and shrinker_info can
also be safely freed here.

> 
> Yes, it was safe to do this when it was all under a semaphore, but
> now the lookup and use is under RCU, so this freeing isn't
> serialised against lookups anymore...
> 
> 
>> @@ -40,28 +76,27 @@ void free_shrinker_info(struct mem_cgroup *memcg)
>>   int alloc_shrinker_info(struct mem_cgroup *memcg)
>>   {
>>   	struct shrinker_info *info;
>> -	int nid, size, ret = 0;
>> -	int map_size, defer_size = 0;
>> +	int nid, ret = 0;
>> +	int array_size = 0;
>>   
>>   	down_write(&shrinker_rwsem);
>> -	map_size = shrinker_map_size(shrinker_nr_max);
>> -	defer_size = shrinker_defer_size(shrinker_nr_max);
>> -	size = map_size + defer_size;
>> +	array_size = shrinker_unit_size(shrinker_nr_max);
>>   	for_each_node(nid) {
>> -		info = kvzalloc_node(sizeof(*info) + size, GFP_KERNEL, nid);
>> -		if (!info) {
>> -			free_shrinker_info(memcg);
>> -			ret = -ENOMEM;
>> -			break;
>> -		}
>> -		info->nr_deferred = (atomic_long_t *)(info + 1);
>> -		info->map = (void *)info->nr_deferred + defer_size;
>> +		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
>> +		if (!info)
>> +			goto err;
>>   		info->map_nr_max = shrinker_nr_max;
>> +		if (shrinker_unit_alloc(info, NULL, nid))
>> +			goto err;
> 
> That's going to now do a lot of small memory allocation when we have
> lots of shrinkers active....
> 
>> @@ -150,17 +175,34 @@ static int expand_shrinker_info(int new_id)
>>   	return ret;
>>   }
>>   
>> +static inline int shriner_id_to_index(int shrinker_id)
> 
> shrinker_id_to_index

Will fix.

> 
>> +{
>> +	return shrinker_id / SHRINKER_UNIT_BITS;
>> +}
>> +
>> +static inline int shriner_id_to_offset(int shrinker_id)
> 
> shrinker_id_to_offset

Will fix.

> 
>> +{
>> +	return shrinker_id % SHRINKER_UNIT_BITS;
>> +}
> 
> ....
>> @@ -209,26 +251,31 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
>>   				   struct mem_cgroup *memcg)
>>   {
>>   	struct shrinker_info *info;
>> +	struct shrinker_info_unit *unit;
>>   
>>   	info = shrinker_info_protected(memcg, nid);
>> -	return atomic_long_xchg(&info->nr_deferred[shrinker->id], 0);
>> +	unit = info->unit[shriner_id_to_index(shrinker->id)];
>> +	return atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
>>   }
>>   
>>   static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
>>   				  struct mem_cgroup *memcg)
>>   {
>>   	struct shrinker_info *info;
>> +	struct shrinker_info_unit *unit;
>>   
>>   	info = shrinker_info_protected(memcg, nid);
>> -	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
>> +	unit = info->unit[shriner_id_to_index(shrinker->id)];
>> +	return atomic_long_add_return(nr, &unit->nr_deferred[shriner_id_to_offset(shrinker->id)]);
>>   }
>>   
>>   void reparent_shrinker_deferred(struct mem_cgroup *memcg)
>>   {
>> -	int i, nid;
>> +	int nid, index, offset;
>>   	long nr;
>>   	struct mem_cgroup *parent;
>>   	struct shrinker_info *child_info, *parent_info;
>> +	struct shrinker_info_unit *child_unit, *parent_unit;
>>   
>>   	parent = parent_mem_cgroup(memcg);
>>   	if (!parent)
>> @@ -239,9 +286,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
>>   	for_each_node(nid) {
>>   		child_info = shrinker_info_protected(memcg, nid);
>>   		parent_info = shrinker_info_protected(parent, nid);
>> -		for (i = 0; i < child_info->map_nr_max; i++) {
>> -			nr = atomic_long_read(&child_info->nr_deferred[i]);
>> -			atomic_long_add(nr, &parent_info->nr_deferred[i]);
>> +		for (index = 0; index < shriner_id_to_index(child_info->map_nr_max); index++) {
>> +			child_unit = child_info->unit[index];
>> +			parent_unit = parent_info->unit[index];
>> +			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
>> +				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
>> +				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
>> +			}
>>   		}
>>   	}
>>   	up_read(&shrinker_rwsem);
>> @@ -407,7 +458,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>>   {
>>   	struct shrinker_info *info;
>>   	unsigned long ret, freed = 0;
>> -	int i;
>> +	int offset, index = 0;
>>   
>>   	if (!mem_cgroup_online(memcg))
>>   		return 0;
>> @@ -419,56 +470,63 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>>   	if (unlikely(!info))
>>   		goto unlock;
>>   
>> -	for_each_set_bit(i, info->map, info->map_nr_max) {
>> -		struct shrink_control sc = {
>> -			.gfp_mask = gfp_mask,
>> -			.nid = nid,
>> -			.memcg = memcg,
>> -		};
>> -		struct shrinker *shrinker;
>> +	for (; index < shriner_id_to_index(info->map_nr_max); index++) {
>> +		struct shrinker_info_unit *unit;
> 
> This adds another layer of indent to shrink_slab_memcg(). Please
> factor it first so that the code ends up being readable. Doing that
> first as a separate patch will also make the actual algorithm
> changes in this patch be much more obvious - this huge hunk of
> diff is pretty much impossible to review...

OK, I will send this patch together with PATCH v4 01/02/03/43 as
a single cleanup patchset.

Thanks,
Qi

> 
> -Dave.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

