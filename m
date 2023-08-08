Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3232CEB64DD
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 02:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691462665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xeFFETVQv7/RcDEPWY4WsWS8RTR7GigNryvoPBOhA0g=;
	b=gY+gSs28IMb3/zPdNC5EPHvKf+Xk2maL10eA8ETmO9RJGzrd0Fq4kUmaKRq8OMkLuiRtQO
	n7IXEOFUiRb+PMqTJ2PcEPj6cezK/CVslSzgfo3V2kLYfVg5ES/fOmmsdzBrvbXzUbFckc
	mViGZgWWpGrWkdeU9MOSMUWgViYjCbw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-ST8Y9J66PHyNKvqJEhTh-A-1; Mon, 07 Aug 2023 22:44:21 -0400
X-MC-Unique: ST8Y9J66PHyNKvqJEhTh-A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57EC53C0F67B;
	Tue,  8 Aug 2023 02:44:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 043B44021B9;
	Tue,  8 Aug 2023 02:44:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 95C2A1946587;
	Tue,  8 Aug 2023 02:44:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76E9F1946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 02:44:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DB11140E963; Tue,  8 Aug 2023 02:44:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25EE2140E950
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 02:44:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 073DA80C909
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 02:44:18 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-hJVCBWH-MuGs7O8PsQJxFw-1; Mon, 07 Aug 2023 22:44:16 -0400
X-MC-Unique: hJVCBWH-MuGs7O8PsQJxFw-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1bc8045e09dso1996775ad.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 19:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691462655; x=1692067455;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ZZ3n364wJBBn5i6olC7X8xOphz5aoEwi3PPn9Humxy4=;
 b=FKPT9OkhgymK0sfnr7NKjSeheO92YqqZIVI+o/kjoxGF1Yvv05+UWnpDKIjJgKu0fu
 gc+TPbz7d2XQLcqvufSy8qxyP9dbO2XdEEAnDp4TRSrV9PpIAUYkOg9h6xs8nc3T9Lua
 73ETvYE+vRvTPIgklNUY4bj48LinwPXRxtufN5pwL8D7qS3vfk+WGQzRdpGDDlQly+zE
 rY4Ls0IWuJ5hQ1s94MG3MhbWw9p/uTRlQHH68qDvLOtS4iSUNRIeCk95dgh5cIqBrnQ5
 S8Z/dDaaywJvxJnfwEQL8wi+IsoE1Dks8jvHbXWGCZq/y8rBP014azp+8TUEa86eycT6
 aemA==
X-Gm-Message-State: AOJu0Yzb8UTgDvz7YW/07UFM/IHkSCcR9ZkAz+moxJhgHEBvsNpTtfn7
 LWzNBsUF4hdu1QbX80D+iWXbig==
X-Google-Smtp-Source: AGHT+IEZT2gUmOSYrkIbMjP5ySF6z1UEt5Q+o+GMN8zU98oO9pgzqqi+i8QK+swPthTlPTk4WQ36Qw==
X-Received: by 2002:a17:902:7287:b0:1b3:f5c7:4e75 with SMTP id
 d7-20020a170902728700b001b3f5c74e75mr9699662pll.58.1691462654669; 
 Mon, 07 Aug 2023 19:44:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au.
 [49.180.166.213]) by smtp.gmail.com with ESMTPSA id
 u2-20020a170902e80200b001b893b689a0sm7632067plg.84.2023.08.07.19.44.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Aug 2023 19:44:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qTChf-002XBg-27;
 Tue, 08 Aug 2023 12:44:11 +1000
Date: Tue, 8 Aug 2023 12:44:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Message-ID: <ZNGr+1orhHaBORJG@dread.disaster.area>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-47-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
In-Reply-To: <20230807110936.21819-47-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 46/48] mm: shrinker: make memcg slab
 shrink lockless
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
 dlemoal@kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, brauner@kernel.org, tytso@mit.edu,
 gregkh@linuxfoundation.org, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, senozhatsky@chromium.org, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 07, 2023 at 07:09:34PM +0800, Qi Zheng wrote:
> Like global slab shrink, this commit also uses refcount+RCU method to make
> memcg slab shrink lockless.

This patch does random code cleanups amongst the actual RCU changes.
Can you please move the cleanups to a spearate patch to reduce the
noise in this one?

> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index d318f5621862..fee6f62904fb 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -107,6 +107,12 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
>  					 lockdep_is_held(&shrinker_rwsem));
>  }
>  
> +static struct shrinker_info *shrinker_info_rcu(struct mem_cgroup *memcg,
> +					       int nid)
> +{
> +	return rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> +}

This helper doesn't add value. It doesn't tell me that
rcu_read_lock() needs to be held when it is called, for one....

>  static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
>  				    int old_size, int new_nr_max)
>  {
> @@ -198,7 +204,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
>  		struct shrinker_info_unit *unit;
>  
>  		rcu_read_lock();
> -		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> +		info = shrinker_info_rcu(memcg, nid);

... whilst the original code here was obviously correct.

>  		unit = info->unit[shriner_id_to_index(shrinker_id)];
>  		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
>  			/* Pairs with smp mb in shrink_slab() */
> @@ -211,7 +217,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
>  
>  static DEFINE_IDR(shrinker_idr);
>  
> -static int prealloc_memcg_shrinker(struct shrinker *shrinker)
> +static int shrinker_memcg_alloc(struct shrinker *shrinker)

Cleanups in a separate patch.

> @@ -253,10 +258,15 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
>  {
>  	struct shrinker_info *info;
>  	struct shrinker_info_unit *unit;
> +	long nr_deferred;
>  
> -	info = shrinker_info_protected(memcg, nid);
> +	rcu_read_lock();
> +	info = shrinker_info_rcu(memcg, nid);
>  	unit = info->unit[shriner_id_to_index(shrinker->id)];
> -	return atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
> +	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
> +	rcu_read_unlock();
> +
> +	return nr_deferred;
>  }

This adds two rcu_read_lock() sections to every call to
do_shrink_slab(). It's not at all clear ifrom any of the other code
that do_shrink_slab() now has internal rcu_read_lock() sections....

> @@ -464,18 +480,23 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>  	if (!mem_cgroup_online(memcg))
>  		return 0;
>  
> -	if (!down_read_trylock(&shrinker_rwsem))
> -		return 0;
> -
> -	info = shrinker_info_protected(memcg, nid);
> +again:
> +	rcu_read_lock();
> +	info = shrinker_info_rcu(memcg, nid);
>  	if (unlikely(!info))
>  		goto unlock;
>  
> -	for (; index < shriner_id_to_index(info->map_nr_max); index++) {
> +	if (index < shriner_id_to_index(info->map_nr_max)) {
>  		struct shrinker_info_unit *unit;
>  
>  		unit = info->unit[index];
>  
> +		/*
> +		 * The shrinker_info_unit will not be freed, so we can
> +		 * safely release the RCU lock here.
> +		 */
> +		rcu_read_unlock();

Why - what guarantees that the shrinker_info_unit exists at this
point? We hold no reference to it, we hold no reference to any
shrinker, etc. What provides this existence guarantee?

> +
>  		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
>  			struct shrink_control sc = {
>  				.gfp_mask = gfp_mask,
> @@ -485,12 +506,14 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>  			struct shrinker *shrinker;
>  			int shrinker_id = calc_shrinker_id(index, offset);
>  
> +			rcu_read_lock();
>  			shrinker = idr_find(&shrinker_idr, shrinker_id);
> -			if (unlikely(!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))) {
> -				if (!shrinker)
> -					clear_bit(offset, unit->map);
> +			if (unlikely(!shrinker || !shrinker_try_get(shrinker))) {
> +				clear_bit(offset, unit->map);
> +				rcu_read_unlock();
>  				continue;
>  			}
> +			rcu_read_unlock();
>  
>  			/* Call non-slab shrinkers even though kmem is disabled */
>  			if (!memcg_kmem_online() &&
> @@ -523,15 +546,20 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
>  					set_shrinker_bit(memcg, nid, shrinker_id);
>  			}
>  			freed += ret;
> -
> -			if (rwsem_is_contended(&shrinker_rwsem)) {
> -				freed = freed ? : 1;
> -				goto unlock;
> -			}
> +			shrinker_put(shrinker);

Ok, so why is this safe to call without holding the rcu read lock?
The global shrinker has to hold the rcu_read_lock() whilst calling
shrinker_put() to guarantee the validity of the list next pointer,
but we don't hold off RCU here so what guarantees a racing global
shrinker walk doesn't trip over this shrinker_put() call dropping
the refcount to zero and freeing occuring in a different context...


> +		/*
> +		 * We have already exited the read-side of rcu critical section
> +		 * before calling do_shrink_slab(), the shrinker_info may be
> +		 * released in expand_one_shrinker_info(), so reacquire the
> +		 * shrinker_info.
> +		 */
> +		index++;
> +		goto again;

With that, what makes the use of shrinker_info in
xchg_nr_deferred_memcg() in do_shrink_slab() coherent and valid?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

