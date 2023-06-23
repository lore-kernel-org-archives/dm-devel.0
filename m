Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A201DEB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971624;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Oq0oiyqSUreQuwM7JbfqWpXl101SUrtE67WFbmc/fEQ=;
	b=TPOlknnDj9LHWr9u/SXe3zox6I7t3K9t8Ffn1+wR3pZTqEeVqI+vq0ekvEpVhEMIyo13RM
	tnJo6EKc/i4g+rvP54ix5nMmPoiztnjmBO0/0jwmZSYKDGZbUQHExhIb+QOJ8OnKssQWUI
	l/QfaVr4wD4GkDz8CQ+vvKO6p2rJkgI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-O7hL3v2gO_6Zu345jHMwmQ-1; Mon, 10 Jul 2023 02:47:00 -0400
X-MC-Unique: O7hL3v2gO_6Zu345jHMwmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B09B2A59568;
	Mon, 10 Jul 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E87F7C575E1;
	Mon, 10 Jul 2023 06:46:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A811919451E2;
	Mon, 10 Jul 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E38411946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 12:49:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C0A97F5AC5; Fri, 23 Jun 2023 12:49:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B8C1BF41C8
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 12:49:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C3480027F
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 12:49:18 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-8lFhzKc6NOKEvw8GSA-kqw-1; Fri, 23 Jun 2023 08:49:16 -0400
X-MC-Unique: 8lFhzKc6NOKEvw8GSA-kqw-1
Received: by mail-pj1-f41.google.com with SMTP id
 98e67ed59e1d1-25eabe8b5fcso128676a91.1
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 05:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687524556; x=1690116556;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=N8pNNe3/2YXc1UbpwIO0yIQjjCMHlVzYoQIGO6mvjFk=;
 b=DS7kabWOSuFxm4DlvezqV8fQC0Fe3r1uadB0x6nqBh4wVTGg5IRwhaYvvwFh+GXuGh
 qxHG5UxY8pF/KfWt/rUAK/MLKiJ6q/ftKYwM4KehNC/53FJZBE9Q39l8vP89OY9BSRjD
 WE21lg/z4GE+XCP97LWzK75mlCSpeGOgRfIztg5suSymIhQFgfROGTky4iIf3GVUw0rF
 bCo+5vqsiZE43NH49y3+pte2vj73Jrc8vjGimQl9nmT2377PgEAbY7Kx8NU0M/C5fAKn
 XY6AJheW4g2DDBLlpcnuibuw+IudtykcaVsmBn0c92IKcZcqWXTvz+HFIlqNHNbtS25c
 yrSA==
X-Gm-Message-State: AC+VfDz2GvwOJNOPU5a3ve8oPVsKBmeVPtbUZQmOde8gMfgwwWNJVkDd
 8zsDV8zYHdCsh0s5qfm3deY02Q==
X-Google-Smtp-Source: ACHHUZ6eQKAAK+mFZK9b/rl5yBeScp7LGUAVTtY7Qwt+jrMMbGjG/tQ037wkOBUmA1P5xX8mDtOLpg==
X-Received: by 2002:a17:90b:350f:b0:258:d367:63c with SMTP id
 ls15-20020a17090b350f00b00258d367063cmr24920553pjb.1.1687524555690; 
 Fri, 23 Jun 2023 05:49:15 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 30-20020a17090a001e00b0026135208e97sm1471795pja.19.2023.06.23.05.49.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 23 Jun 2023 05:49:15 -0700 (PDT)
Message-ID: <d8632edc-5021-4dc8-b75a-3995a710f196@bytedance.com>
Date: Fri, 23 Jun 2023 20:49:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
To: Dave Chinner <david@fromorbit.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-3-zhengqi.arch@bytedance.com>
 <ZJU3s8tyGsYTVS8f@dread.disaster.area>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <ZJU3s8tyGsYTVS8f@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH 02/29] mm: vmscan: introduce some helpers for
 dynamically allocating shrinker
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
 paulmck@kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-nfs@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org, vbabka@suse.cz,
 brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi Dave,

On 2023/6/23 14:12, Dave Chinner wrote:
> On Thu, Jun 22, 2023 at 04:53:08PM +0800, Qi Zheng wrote:
>> Introduce some helpers for dynamically allocating shrinker instance,
>> and their uses are as follows:
>>
>> 1. shrinker_alloc_and_init()
>>
>> Used to allocate and initialize a shrinker instance, the priv_data
>> parameter is used to pass the pointer of the previously embedded
>> structure of the shrinker instance.
>>
>> 2. shrinker_free()
>>
>> Used to free the shrinker instance when the registration of shrinker
>> fails.
>>
>> 3. unregister_and_free_shrinker()
>>
>> Used to unregister and free the shrinker instance, and the kfree()
>> will be changed to kfree_rcu() later.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/shrinker.h | 12 ++++++++++++
>>   mm/vmscan.c              | 35 +++++++++++++++++++++++++++++++++++
>>   2 files changed, 47 insertions(+)
>>
>> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>> index 43e6fcabbf51..8e9ba6fa3fcc 100644
>> --- a/include/linux/shrinker.h
>> +++ b/include/linux/shrinker.h
>> @@ -107,6 +107,18 @@ extern void unregister_shrinker(struct shrinker *shrinker);
>>   extern void free_prealloced_shrinker(struct shrinker *shrinker);
>>   extern void synchronize_shrinkers(void);
>>   
>> +typedef unsigned long (*count_objects_cb)(struct shrinker *s,
>> +					  struct shrink_control *sc);
>> +typedef unsigned long (*scan_objects_cb)(struct shrinker *s,
>> +					 struct shrink_control *sc);
>> +
>> +struct shrinker *shrinker_alloc_and_init(count_objects_cb count,
>> +					 scan_objects_cb scan, long batch,
>> +					 int seeks, unsigned flags,
>> +					 void *priv_data);
>> +void shrinker_free(struct shrinker *shrinker);
>> +void unregister_and_free_shrinker(struct shrinker *shrinker);
> 
> Hmmmm. Not exactly how I envisioned this to be done.
> 
> Ok, this will definitely work, but I don't think it is an
> improvement. It's certainly not what I was thinking of when I
> suggested dynamically allocating shrinkers.
> 
> The main issue is that this doesn't simplify the API - it expands it
> and creates a minefield of old and new functions that have to be
> used in exactly the right order for the right things to happen.
> 
> What I was thinking of was moving the entire shrinker setup code
> over to the prealloc/register_prepared() algorithm, where the setup
> is already separated from the activation of the shrinker.
> 
> That is, we start by renaming prealloc_shrinker() to
> shrinker_alloc(), adding a flags field to tell it everything that it
> needs to alloc (i.e. the NUMA/MEMCG_AWARE flags) and having it
> returned a fully allocated shrinker ready to register. Initially
> this also contains an internal flag to say the shrinker was
> allocated so that unregister_shrinker() knows to free it.
> 
> The caller then fills out the shrinker functions, seeks, etc. just
> like the do now, and then calls register_shrinker_prepared() to make
> the shrinker active when it wants to turn it on.
> 
> When it is time to tear down the shrinker, no API needs to change.
> unregister_shrinker() does all the shutdown and frees all the
> internal memory like it does now. If the shrinker is also marked as
> allocated, it frees the shrinker via RCU, too.
> 
> Once everything is converted to this API, we then remove
> register_shrinker(), rename register_shrinker_prepared() to
> shrinker_register(), rename unregister_shrinker to
> shrinker_unregister(), get rid of the internal "allocated" flag
> and always free the shrinker.

IIUC, you mean that we also need to convert the original statically
defined shrinker instances to dynamically allocated.

I think this is a good idea, it helps to simplify the APIs and also
remove special handling for case a and b (mentioned in cover letter).

> 
> At the end of the patchset, every shrinker should be set
> up in a manner like this:
> 
> 
> 	sb->shrinker = shrinker_alloc(SHRINKER_MEMCG_AWARE|SHRINKER_NUMA_AWARE,
> 				"sb-%s", type->name);
> 	if (!sb->shrinker)
> 		return -ENOMEM;
> 
> 	sb->shrinker->count_objects = super_cache_count;
> 	sb->shrinker->scan_objects = super_cache_scan;
> 	sb->shrinker->batch = 1024;
> 	sb->shrinker->private = sb;
> 
> 	.....
> 
> 	shrinker_register(sb->shrinker);
> 
> And teardown is just a call to shrinker_unregister(sb->shrinker)
> as it is now.
> 
> i.e. the entire shrinker regsitration API is now just three
> functions, down from the current four, and much simpler than the
> the seven functions this patch set results in...
> 
> The other advantage of this is that it will break all the existing
> out of tree code and third party modules using the old API and will
> no longer work with a kernel using lockless slab shrinkers. They
> need to break (both at the source and binary levels) to stop bad
> things from happening due to using uncoverted shrinkers in the new
> setup.

Got it. And totally agree.

I will do it in the v2.

Thanks,
Qi

> 
> -Dave.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

