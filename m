Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C61EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 06:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687500738;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+tWXRrIsAr0hPjdakfq9mBtbzWgUTyHIknwJhE2w67k=;
	b=F0WkN1eGPEYiySuCrlp7HKDBd6Q+5TwSVdQozxnhLc3rVGJyqkAvJ0MGIURRaI2AOyy+pn
	x576FrULVmWtSqBYMzTlTSds/2K/d/1jlS7VMFxMTt0M/16uUM9KlVFtd33vTI6o7nlTvw
	5efOON4awKSd9Kuczw+L6dU/Plk/UQk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592--MHRamC6Pvy4q9c8jxkt1g-1; Fri, 23 Jun 2023 02:12:15 -0400
X-MC-Unique: -MHRamC6Pvy4q9c8jxkt1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1286A185A793;
	Fri, 23 Jun 2023 06:12:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3F8E40C2070;
	Fri, 23 Jun 2023 06:12:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D3D81946588;
	Fri, 23 Jun 2023 06:12:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B9FBA1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 06:12:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7DADF200B402; Fri, 23 Jun 2023 06:12:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7646E200A3AD
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:12:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 552853C01D88
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:12:10 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-L2hrFMayMfadCH9jhU8Gjw-1; Fri, 23 Jun 2023 02:12:08 -0400
X-MC-Unique: L2hrFMayMfadCH9jhU8Gjw-1
Received: by mail-qk1-f169.google.com with SMTP id
 af79cd13be357-763ddd51fcaso19929985a.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 23:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687500728; x=1690092728;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=g6Rx1Xf0LH0dvCkca5awQZbD4QgAJXvuKCZBBi/mUhU=;
 b=QXG8tMTbC7fvjN+K21hwGxpQbCdeenCre1zlOQWaTEkuKzXs1aD3w4QeRhKvk/NMXv
 UTNCoWyOyxaFpF62KjToLnSReZG9MuTWbtZC3NE7BSbdLanDtIkiH9YBONk/O6Q256XY
 mvWR7CrhFtzQVobSLWcLVn9PV8YeEqKag/e+hH9s6Vc1suT1UJRZQ2JMLqb48zijAxst
 xOArFCZrkjdyVMqfjoUcRA6eKw7yanD3Wjv6ENEa3zTF0ZFo/p1/XBkNyx77JOviZ7El
 hI94RmzcFugM6OzUOUt2ReCI23P5dEUsiFxZC/9RYe4D+dmelJXdrjRlQEuDNpGdDNXY
 vDKA==
X-Gm-Message-State: AC+VfDz8Mj4bucKEdCAXCWSZ7BCYua+DMxTm81/2G7xRNy+wyuv7vCx6
 WytsUtY1n23jgbuhh1qDOkIUGg==
X-Google-Smtp-Source: ACHHUZ5b6N+FK7PXoTwlvRKh6LsH0vyG6YXCaEWGf5NRL5zfUiNEb8MHT84h6djsafTCO/ahpimwww==
X-Received: by 2002:a05:6214:764:b0:62d:e913:f9ae with SMTP id
 f4-20020a056214076400b0062de913f9aemr22933956qvz.1.1687500727864; 
 Thu, 22 Jun 2023 23:12:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au.
 [49.180.13.202]) by smtp.gmail.com with ESMTPSA id
 p28-20020a634f5c000000b0055387ffef10sm5712930pgl.24.2023.06.22.23.12.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 23:12:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qCa1b-00F8aV-2d;
 Fri, 23 Jun 2023 16:12:03 +1000
Date: Fri, 23 Jun 2023 16:12:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Message-ID: <ZJU3s8tyGsYTVS8f@dread.disaster.area>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-3-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
In-Reply-To: <20230622085335.77010-3-zhengqi.arch@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 22, 2023 at 04:53:08PM +0800, Qi Zheng wrote:
> Introduce some helpers for dynamically allocating shrinker instance,
> and their uses are as follows:
> 
> 1. shrinker_alloc_and_init()
> 
> Used to allocate and initialize a shrinker instance, the priv_data
> parameter is used to pass the pointer of the previously embedded
> structure of the shrinker instance.
> 
> 2. shrinker_free()
> 
> Used to free the shrinker instance when the registration of shrinker
> fails.
> 
> 3. unregister_and_free_shrinker()
> 
> Used to unregister and free the shrinker instance, and the kfree()
> will be changed to kfree_rcu() later.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/shrinker.h | 12 ++++++++++++
>  mm/vmscan.c              | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 43e6fcabbf51..8e9ba6fa3fcc 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -107,6 +107,18 @@ extern void unregister_shrinker(struct shrinker *shrinker);
>  extern void free_prealloced_shrinker(struct shrinker *shrinker);
>  extern void synchronize_shrinkers(void);
>  
> +typedef unsigned long (*count_objects_cb)(struct shrinker *s,
> +					  struct shrink_control *sc);
> +typedef unsigned long (*scan_objects_cb)(struct shrinker *s,
> +					 struct shrink_control *sc);
> +
> +struct shrinker *shrinker_alloc_and_init(count_objects_cb count,
> +					 scan_objects_cb scan, long batch,
> +					 int seeks, unsigned flags,
> +					 void *priv_data);
> +void shrinker_free(struct shrinker *shrinker);
> +void unregister_and_free_shrinker(struct shrinker *shrinker);

Hmmmm. Not exactly how I envisioned this to be done.

Ok, this will definitely work, but I don't think it is an
improvement. It's certainly not what I was thinking of when I
suggested dynamically allocating shrinkers.

The main issue is that this doesn't simplify the API - it expands it
and creates a minefield of old and new functions that have to be
used in exactly the right order for the right things to happen.

What I was thinking of was moving the entire shrinker setup code
over to the prealloc/register_prepared() algorithm, where the setup
is already separated from the activation of the shrinker.

That is, we start by renaming prealloc_shrinker() to
shrinker_alloc(), adding a flags field to tell it everything that it
needs to alloc (i.e. the NUMA/MEMCG_AWARE flags) and having it
returned a fully allocated shrinker ready to register. Initially
this also contains an internal flag to say the shrinker was
allocated so that unregister_shrinker() knows to free it.

The caller then fills out the shrinker functions, seeks, etc. just
like the do now, and then calls register_shrinker_prepared() to make
the shrinker active when it wants to turn it on.

When it is time to tear down the shrinker, no API needs to change.
unregister_shrinker() does all the shutdown and frees all the
internal memory like it does now. If the shrinker is also marked as
allocated, it frees the shrinker via RCU, too.

Once everything is converted to this API, we then remove
register_shrinker(), rename register_shrinker_prepared() to
shrinker_register(), rename unregister_shrinker to
shrinker_unregister(), get rid of the internal "allocated" flag
and always free the shrinker.

At the end of the patchset, every shrinker should be set
up in a manner like this:


	sb->shrinker = shrinker_alloc(SHRINKER_MEMCG_AWARE|SHRINKER_NUMA_AWARE,
				"sb-%s", type->name);
	if (!sb->shrinker)
		return -ENOMEM;

	sb->shrinker->count_objects = super_cache_count;
	sb->shrinker->scan_objects = super_cache_scan;
	sb->shrinker->batch = 1024;
	sb->shrinker->private = sb;

	.....

	shrinker_register(sb->shrinker);

And teardown is just a call to shrinker_unregister(sb->shrinker)
as it is now.

i.e. the entire shrinker regsitration API is now just three
functions, down from the current four, and much simpler than the
the seven functions this patch set results in...

The other advantage of this is that it will break all the existing
out of tree code and third party modules using the old API and will
no longer work with a kernel using lockless slab shrinkers. They
need to break (both at the source and binary levels) to stop bad
things from happening due to using uncoverted shrinkers in the new
setup.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

