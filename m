Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD98145A05
	for <dm-devel@lists.linux.dev>; Mon, 11 Aug 2025 12:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754916291; cv=none; b=m+P8/U8xDLj78Ty83o5rIKdLOpcBI2mvqIATv9SJd6MFDr7pBGW5/Rqptfwe+balE7q+Uq7wEhvH6i9SloiQionJd6e1MzJqInA4hAm4SkJQy0MYIG+49f4MWXAhSo9sCGFtVd9o48G1VeWmJgUBZiO4Rd+ZJuXtzz4xApIVHmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754916291; c=relaxed/simple;
	bh=r9PD8c2V1K8UlQjyYWcnwhI1Wbdsemc+Su+YG7mdqqE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kG7gtS9RQEfYb1Qk5NwFjiQtepgog/VhqPtiJqKZ29v33NsbFvQwFxr1RWEqIWF0R2N5FkilK9uAEOv2a6V8Askvlx4NTdpMDWREwiGfTh7y3HmLXh9GucuCpd7765HLXDMsKKtDRzWw91zrPeDsRoRi+Oc8gIS+wlIfLsSEvk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lrq/Nyby; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lrq/Nyby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754916288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GUFx77mFsjO3+sNdMc+P7xX572cUmISh0hQE2zjvXB4=;
	b=Lrq/Nyby1azbLAvgbtXd5qpXq65+6OqEBxBuWFibhdu2Yzo57kNMdBCp14kbhaE3F3dXKa
	P7Bjq4cAr6sbDzoSfka3H2SasN5JB2imI74TxavLxLADS3Gt5k5unj/35bIOiwYCfgUVps
	S6KWzD4thFV4SvA5b0Pxm9QhykqfKZE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-xerZ-hIiP-GG5T4K7-TLkA-1; Mon,
 11 Aug 2025 08:44:47 -0400
X-MC-Unique: xerZ-hIiP-GG5T4K7-TLkA-1
X-Mimecast-MFC-AGG-ID: xerZ-hIiP-GG5T4K7-TLkA_1754916286
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D4D019560B7;
	Mon, 11 Aug 2025 12:44:46 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F1201955F16;
	Mon, 11 Aug 2025 12:44:44 +0000 (UTC)
Date: Mon, 11 Aug 2025 14:44:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    "open list:DEVICE-MAPPER  (LVM)" <dm-devel@lists.linux.dev>, 
    open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] dm bufio: remove redundant __GFP_NOWARN
In-Reply-To: <20250811123638.550822-3-rongqianfeng@vivo.com>
Message-ID: <649a5bf8-309b-8128-b3f9-971d3a0bb350@redhat.com>
References: <20250811123638.550822-1-rongqianfeng@vivo.com> <20250811123638.550822-3-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi

I think that GFP_NOWAIT already includes __GFP_NORETRY too. So, should we 
drop __GFP_NORETRY as well?

Mikulas


On Mon, 11 Aug 2025, Qianfeng Rong wrote:

> GFP_NOWAIT already includes __GFP_NOWARN, so let's remove the redundant
> __GFP_NOWARN.  Also update comments to clarify the flag semantics.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/md/dm-bufio.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index ff7595caf440..4b20854e92f5 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1337,7 +1337,7 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
>  	char *ptr;
>  	unsigned int len;
>  
> -	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN);
> +	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY);
>  	if (!bio) {
>  		use_dmio(b, op, sector, n_sectors, offset, ioprio);
>  		return;
> @@ -1601,18 +1601,18 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
>  	 * dm-bufio is resistant to allocation failures (it just keeps
>  	 * one buffer reserved in cases all the allocations fail).
>  	 * So set flags to not try too hard:
> -	 *	GFP_NOWAIT: don't wait; if we need to sleep we'll release our
> -	 *		    mutex and wait ourselves.
> +	 *	GFP_NOWAIT: don't wait and don't print a warning in case of
> +	 *		    failure; if we need to sleep we'll release our mutex
> +	 *		    and wait ourselves.
>  	 *	__GFP_NORETRY: don't retry and rather return failure
>  	 *	__GFP_NOMEMALLOC: don't use emergency reserves
> -	 *	__GFP_NOWARN: don't print a warning in case of failure
>  	 *
>  	 * For debugging, if we set the cache size to 1, no new buffers will
>  	 * be allocated.
>  	 */
>  	while (1) {
>  		if (dm_bufio_cache_size_latch != 1) {
> -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC);
>  			if (b)
>  				return b;
>  		}
> -- 
> 2.34.1
> 

