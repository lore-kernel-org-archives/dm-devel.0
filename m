Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70672D3A6D
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 19:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764702560; cv=none; b=lmLXomQ2MvDozZLFQFQRcHNEljuZdNkz1n8AlseRjpoOr9ghPopGcTrQzT/EaPDay1mmI56qs7Hla5FWqgFf8sTTv+Dx9h6GHbP7EHuAae07Ezpq6nblrOKE/dYrplMtOhxPDpE7CrpxtUsmBDz1JH77lRLoIIkcaxXloqbJynE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764702560; c=relaxed/simple;
	bh=eic7VupvcAv7zXoBNTtQUGqrI/6Q//PRBLyrcFfdTiA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=V6bcTtVACYRQyk0BPD4f/+081+rXPob09OE6SGAPo9ZAZVWKRUsZzMNnNeqOV9kHyCs9ntR3dbZH/sRVUOFhSLgEiVAJCKnmaN1rnWfr2f7RKvNK43rnTN5RZau1lP4hBfudvgHLdo1SHjS37vXZrNJhTkR5N93Xaj+X2+dhFRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L9C457rP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L9C457rP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764702557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eA7lZuWHkEtNy/vxk2znDzmB51SQTmNGp4hf3xxYoNo=;
	b=L9C457rPNhgHGpC59nJS4Y2DjCI1Xe9PMPMNR0eRWM+Oc/RykRSNk2t+/tnHfxek6/q7FT
	qdvOENOKWH8K9DKl0DXrWAvyUUHXP7axF6cHs1KVKzxqdx53SbTFbhDQFLdJovE7R2gmFG
	enQQijHVuIpJ0ScnOHCcuP8g4D4TDMI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-mU7jOhMiNjyzOXfgO3yRYA-1; Tue,
 02 Dec 2025 14:09:14 -0500
X-MC-Unique: mU7jOhMiNjyzOXfgO3yRYA-1
X-Mimecast-MFC-AGG-ID: mU7jOhMiNjyzOXfgO3yRYA_1764702553
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C4C819560AD;
	Tue,  2 Dec 2025 19:09:12 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D20130001A4;
	Tue,  2 Dec 2025 19:09:10 +0000 (UTC)
Date: Tue, 2 Dec 2025 20:09:07 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Li Chen <me@linux.beauty>
cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>
Subject: Re: [PATCH 0/2] dm-pcache: fix metadata indexing and persistence
 issues
In-Reply-To: <20251202121158.111092-1-me@linux.beauty>
Message-ID: <7a233190-82ae-b95c-1988-9b746ef6a8b1@redhat.com>
References: <20251202121158.111092-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Both patches accepted, thanks.

Mikulas



On Tue, 2 Dec 2025, Li Chen wrote:

> From: Li Chen <chenl311@chinatelecom.cn>
> 
> dm-pcache stores metadata (cache_info and segment_info) in 4K-aligned
> slots on the cache device, using sequence numbers and CRC to identify
> the latest valid copy.
> 
> However, the cache_info and segment_info paths were computing their
> on-media index using sizeof(struct) instead of the 4K metadata stride.
> As a result:
> 
>   * cache_info updates (including gc_percent set via a dmsetup message)
>     were written to invalid offsets between metadata slots and failed
>     to persist across table reloads or reboots.
> 
>   * segment_info indexing became desynchronized, so rotation to the
>     "next" slot no longer matched the location returned by
>     pcache_meta_find_latest().
> 
> The issue can be reproduced with:
> 
>   dmsetup create pcache_vdb --table \
>     "0 $(blockdev --getsz /dev/vdb) pcache /dev/pmem0 /dev/vdb 4 \
>      cache_mode writeback data_crc false"
> 
>   # Check default gc_percent (70)
>   dmsetup status pcache_vdb
> 
>   # Change gc_percent to 10
>   dmsetup message pcache_vdb 0 "gc_percent 10"
> 
>   # Verify change is active in memory
>   dmsetup status pcache_vdb
> 
>   # Reboot the system...
> 
>   # Without patch (gc_percent reverts to 70):
>   dmsetup status pcache_vdb
> 
>   # With patch (gc_percent persists as 10):
>   dmsetup status pcache_vdb
> 
> This series fixes the issue by deriving the metadata slot index from
> the pointer returned by pcache_meta_find_latest(), using the 4K stride
> (CACHE_INFO_SIZE / SEG_INFO_SIZE). This ensures that updates to
> cache_info and segment_info are written to valid slots and remain
> consistent with the on-media layout.
> 
> Li Chen (2):
>   dm pcache: fix cache info indexing
>   dm pcache: fix segment info indexing
> 
>  drivers/md/dm-pcache/cache.c         | 13 ++++++++++---
>  drivers/md/dm-pcache/cache_segment.c |  6 +++++-
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> -- 
> 2.51.0
> 
> 

