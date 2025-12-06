Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1241D19F137
	for <dm-devel@lists.linux.dev>; Sat,  6 Dec 2025 11:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765020997; cv=none; b=IPSXBDTXA37B5Jq18TN2oEEGLdyokUj7UKydDbJxAKxUqCkQOpJRy3NvyWsTVl4lD0TF6SXqAB7SL/21UgytQ1jv6puqDBerT4b0vfXVSTxxBFP3EvlNPWrkh+82X8niFxgO9ac3GSuqwTpXjSxc1V/JZeg7GsgaP7b4+VAQum4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765020997; c=relaxed/simple;
	bh=LbPWW0gk4AZ0y7k7ENs69V3jo3Jfvr3QStiSKbXZ/pI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d0vsro2PvCKW149YH3rkKWJAyee8W1K5b6y/eW1bvPXha1JNkP1jxSChbXCtnwWh9L0ka4+e7h+MT78nYzoaOeuzU0DvxAga7x6QOpVeFurqqRjnuiib3CfEh+Z1IOzx56ZW577+Dy70yEuSMji1a6KS4FhRID/pPhUTnJelTps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c8t8rFlm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c8t8rFlm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765020992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gyRi6lo6I1h4DFTcnWCwpPrxeT2M5QB1IyYjVi8ZYZI=;
	b=c8t8rFlmKE2ycAmEySGFuwe5rBlNcmg2Bv1Pg0Kg67cv2zc4vHSblScIRFIV+YVnVnWuuw
	E3AdtBWhIB5ONZ0rwrLDe0MRTM45EIY5fkdqyAdItt6rRvo29YTw05DGzEDqQmpXNhemNc
	wO+pgX8vb8/VT47GjZ5dE3+pU+4XW04=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-VfcZ1kcON0iyd15MPNOBiA-1; Sat,
 06 Dec 2025 06:36:29 -0500
X-MC-Unique: VfcZ1kcON0iyd15MPNOBiA-1
X-Mimecast-MFC-AGG-ID: VfcZ1kcON0iyd15MPNOBiA_1765020988
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE5B31956080;
	Sat,  6 Dec 2025 11:36:27 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9489D180045B;
	Sat,  6 Dec 2025 11:36:25 +0000 (UTC)
Date: Sat, 6 Dec 2025 12:36:18 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
Subject: Re: [PATCH 1/3] dm-pcache: advance slot index before writing slot
In-Reply-To: <6686f762-5bf3-401a-b69d-a2876864b187@linux.dev>
Message-ID: <d2d28180-417d-ea74-e338-94c2e0736e91@redhat.com>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev> <bea8250d-fc7f-6bda-df57-2814e96fd05f@redhat.com> <6686f762-5bf3-401a-b69d-a2876864b187@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WZ4w5BbVkPhRS5oyw6KAvGVc3L3O7XUDZZ2YMz0bn84_1765020988
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1968846627-1765020987=:1573356"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1968846627-1765020987=:1573356
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Fri, 5 Dec 2025, Dongsheng Yang wrote:

> 
> 在 12/5/2025 12:13 AM, Mikulas Patocka 写道:
> > 
> > On Thu, 4 Dec 2025, Dongsheng Yang wrote:
> > 
> > > In dm-pcache, in order to ensure crash-consistency, a dual-copy scheme
> > > is used to alternately update metadata, and there is a slot index that
> > > records the current slot. However, in the write path the current
> > > implementation writes directly to the current slot indexed by slot
> > > index, and then advances the slot — which ends up overwriting the
> > > existing slot, violating the crash-consistency guarantee.
> > > 
> > > This patch fixes that behavior, preventing metadata from being
> > > overwritten incorrectly.
> > > 
> > > Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> > > ---
> > >   drivers/md/dm-pcache/cache.c         | 8 ++++----
> > >   drivers/md/dm-pcache/cache_segment.c | 8 ++++----
> > >   2 files changed, 8 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> > > index 698697a7a73c..9289c016b7c9 100644
> > > --- a/drivers/md/dm-pcache/cache.c
> > > +++ b/drivers/md/dm-pcache/cache.c
> > > @@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache
> > > *cache)
> > >   	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
> > >   						sizeof(struct
> > > pcache_cache_info));
> > >   +	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
> > > +
> > >   	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
> > >   			sizeof(struct pcache_cache_info));
> > > -
> > > -	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
> > >   }
> > >     static void cache_info_init_default(struct pcache_cache *cache);
> > I'm not sure whether this is bug or not
> 
> 
> It's a bug, if in-place updating for slot happen, there is a potential
> metadata corruption while powercut happening at the same time.
> 
> 
> so I will add
> 
> Cc: stable@vger.kernel.org      # 6.18
> 
> in V2.
> 
> > - but memcpy_flushcache doesn't
> > guarantee that the cache will be flushed (despite it's name) or that
> > writes would be ordered.
> > 
> > You need pmem_wmb(). I see that you are using it at other places.
> 
> 
> Good catch, I will send v2 to add the missing pmem_wmb().
> 
> 
> Thanx

OK. I staged all 3 patches and I'll send to Linus soon.

Mikulas
---1463811712-1968846627-1765020987=:1573356--

