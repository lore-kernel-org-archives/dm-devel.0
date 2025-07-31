Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB01E0DB0
	for <dm-devel@lists.linux.dev>; Thu, 31 Jul 2025 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753978707; cv=none; b=RAQeemjZI172Vzo35XljmxQa6oHV4+8xV4sP0m6S4CBAiey5qjKA+wzh4CzVeGb5JxaYhMR2tG85Ww1Tk4r8X+pyAZ6yBum+YZqVKeBUa94tgzPd6l2nuz5xYKp+OuLx1VdyFHrlEmHRGuE44PmgiSN/6DQXu2Pe7jmUwi1vcm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753978707; c=relaxed/simple;
	bh=FDXEA3jQJolNzCsKTIsJT31kjxPjsrr3Q8OmSP5Q2nQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=O+AE6cmhuo+kMfsmuZU2uFJltwDPxVv/otBdjamFppA2BVaTDWNbjJGWzS9zxFUD2P+jVm2ITzFspL4TJFx355mTMohZ2v6SoA2MfkpRwXUB449qJ/rbEoOuukIepTwNa92KrCYy3h3C9TBOPyG2pJqv/+OrOstSGUIBXPAnwRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eny5WS98; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eny5WS98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753978705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=srRzXmQ1CNC0YqW3HuQ3cO4aj9sUQaI7phGkG5gWRvU=;
	b=eny5WS989eNgmdiKk4AA1aGe6zK9a/Zcpgu0fj+lmduHPOgMmHAzLC/umLlMaAze1gL92w
	GdqzkpLNOvNbvD4x/UZ6R4ADelJIerpK4Db5iAB/6Sukymx9hKgQ5olUceOVimBw4wnFxx
	3NLd6Zlpo7BsqGddIohUlvVP/xijELY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-b4Oa1_-1N9W8yH57-gDh-Q-1; Thu,
 31 Jul 2025 12:18:21 -0400
X-MC-Unique: b4Oa1_-1N9W8yH57-gDh-Q-1
X-Mimecast-MFC-AGG-ID: b4Oa1_-1N9W8yH57-gDh-Q_1753978697
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55A2E1805A15;
	Thu, 31 Jul 2025 16:18:04 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 793651955E8C;
	Thu, 31 Jul 2025 16:18:02 +0000 (UTC)
Date: Thu, 31 Jul 2025 18:17:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    cengku@gmail.com
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v4_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <43fa642d-4eeb-4bd8-9d2d-31aaf6bd2486@linux.dev>
Message-ID: <5792087a-e70f-d03a-9f9e-3d4107fa3b12@redhat.com>
References: <20250715133332.1764715-1-dongsheng.yang@linux.dev> <af28999e-8002-0320-3aaf-f9eb0768884c@redhat.com> <f5cfbcd9-e1ac-4412-8ebf-801fb53fa46f@linux.dev> <28811c13-6b6b-593b-83ba-47747517988f@redhat.com>
 <43fa642d-4eeb-4bd8-9d2d-31aaf6bd2486@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Iq-vUwY2XGqIHW-qPnv-gSqvsixvbQW_QXZjG45ibiI_1753978697
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 29 Jul 2025, Dongsheng Yang wrote:

> > > > Just a suggestion for performance improvement: when you hold a 
> > > > spinlock a you need to allocate some memory, you must drop the 
> > > > spinlock, allocate it with GFP_NOIO, reacquire the spinlock and 
> > > > recheck the state. You can improve this logic by allocating with 
> > > > mempool_alloc(GFP_NOWAIT) while you hold the spinlock (GFP_NOWAIT 
> > > > will not sleep, so it's allowed), and fallback to dropping the 
> > > > spinlock only if the GFP_NOWAIT allocation fails.
> > > 
> > > Sounds a good suggestion, I will try it in V5.
> >
> > Yes. When you implement it, don't forget to test the code path that drops
> > the spinlock and uses mempool_alloc(GFP_NOIO), so that it doesn't bitrot
> > over time.
> 
> 
> Sure, the failslab case can cover this path:
> 
> https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_failslab.sh
> 
> 
> Dongsheng

failslab doesn't test mempool allocation failures - see the function 
mempool_alloc_noprof:

it tries to allocate using
	element = pool->alloc(gfp_temp, pool->pool_data);
if it fails (the failure may be caused by failslab), it goes down this 
path
        spin_lock_irqsave(&pool->lock, flags);
        if (likely(pool->curr_nr)) {
                element = remove_element(pool);
                spin_unlock_irqrestore(&pool->lock, flags);
                /* paired with rmb in mempool_free(), read comment there */
                smp_wmb();
                /*
                 * Update the allocation stack trace as this is more useful
                 * for debugging.
                 */
                kmemleak_update_trace(element);
                return element;
        }

so, it will not simulate a situation where the mempool is depleted.

It may be worthwhile to extend failslab, so that it makes mempool_alloc 
randomly return NULL for non-sleeping allocations (i.e. allocations 
without __GFP_DIRECT_RECLAIM) and submit the patch to failslab 
maintainers.

Mikulas

