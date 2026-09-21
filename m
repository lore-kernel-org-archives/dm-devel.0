Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE986497B90
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994091; cv=none; b=Ot4zGs8nbiavcCqFK2oKoKd9DHE1FD7GT7vgrRQkFfmsKp2UydcoLN0B09BLaGg+aBlZp0Ra8unMv3jEG4B0STy5UoeZ1Gi1efJ7uUWlI/a8lyPk6kCyZBcfy+PKRssQRk360bQS2fYuG2vVBuAnpEBVqSQqrmFXDrbk11p0OaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994091; c=relaxed/simple;
	bh=eWBf+45lhOFK8uOAMnp35FpO515Uk7wNaiKiE1aQyJA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MV+2ukCPOnvAmBeFlQQzjAE9dSf+P/+WaIBh/zTZAK3ZlYGv7kPaHH1j/lUZnFK2DxRa2swhfAP1Yj2lUJXiq6skQPK/SkyPpxJ54RkLSTrZI89l1mjMu68JOf9Qwq2ypWIyjAsh/LZJAx4s+o4YqaRnk6SpD/Dv8wLc4JPdqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WsKN2Py2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WsKN2Py2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789994086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJtJ1q798iXoJVsOSYr9Ko5j3s4fLjSotEtGJn22wAE=;
	b=WsKN2Py2I3lyNNSW80zkS2jGtZ+7gfCeHRPNLToT1Mlr1h9Tqc33Uo/srOuephNbfPReLN
	g4s+7DlVB+4u0UVwmTLxFSW+miflar5bjMQ/ctHFVEdRZwdM0YM3YH06wee8+c7VJUbz+g
	hczHcgGV5IJ4YysqRJFCu1Dt+QazDmg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-sP2K_if7PG2WD_EpbMiNgQ-1; Mon,
 21 Sep 2026 08:34:41 -0400
X-MC-Unique: sP2K_if7PG2WD_EpbMiNgQ-1
X-Mimecast-MFC-AGG-ID: sP2K_if7PG2WD_EpbMiNgQ_1789994079
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AF701955F54;
	Mon, 21 Sep 2026 12:34:39 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8413619539A1;
	Mon, 21 Sep 2026 12:34:36 +0000 (UTC)
Date: Mon, 21 Sep 2026 14:34:34 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Wentao Liang <vulab@iscas.ac.cn>
cc: cengku@gmail.com, dm-devel@lists.linux.dev, dongsheng.yang@linux.dev, 
    linux-kernel@vger.kernel.org, Jianyun Gao <jianyungao89@gmail.com>
Subject: Re: [PATCH] dm-pcache: Fix use-after-free in kset_replay()
In-Reply-To: <20260917094133.2145340-1-vulab@iscas.ac.cn>
Message-ID: <ab890e71-8075-76f8-a91b-0beb78a0d3b7@redhat.com>
References: <20260917094133.2145340-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 6jx2Ypx4wLVPcNyJaKg-SxzeetFZvS62GAw6QE8Ij8E_1789994079
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

This patch conflicts with the patch 
c2e894eac398b258f12fdec73ed6ba081047f7b3 (which also fixes the 
use-after-free condition).

Please, download the current kernel 7.3-rc4 and test if the bug is still 
present there. If it is, send a patch against 7.3-rc4.

Mikulas


On Thu, 17 Sep 2026, Wentao Liang wrote:

> When the generation of the segment referenced by a replayed key is
> stale, kset_replay() releases the key with cache_key_put().  The caller
> holds the only reference, so the key is freed, yet the function then
> dereferences key->cache_pos to pin the segment.
> 
> Pin the segment before the key can be released.
> 
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/md/dm-pcache/cache_key.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
> index e068e878231b..668c16a2e111 100644
> --- a/drivers/md/dm-pcache/cache_key.c
> +++ b/drivers/md/dm-pcache/cache_key.c
> @@ -730,6 +730,12 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
>  
>  		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
>  
> +		/*
> +		 * Pin the segment while the key is still alive: the stale key
> +		 * below is released and freed by cache_key_put().
> +		 */
> +		cache_seg_get(key->cache_pos.cache_seg);
> +
>  		/* Check if the segment generation is valid for insertion. */
>  		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
>  			cache_key_put(key);
> @@ -739,8 +745,6 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
>  			cache_key_insert(&cache->req_key_tree, key, true);
>  			spin_unlock(&cache_subtree->tree_lock);
>  		}
> -
> -		cache_seg_get(key->cache_pos.cache_seg);
>  	}
>  
>  	return 0;
> -- 
> 2.34.1
> 

