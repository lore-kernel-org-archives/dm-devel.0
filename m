Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD08A3B1EF2
	for <dm-devel@lists.linux.dev>; Mon, 10 Aug 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355206; cv=none; b=cMf1mSqX4wkxIJauGaBbZzVnKiZcR3swzUsv0S1Qfmoi5yHcht9TLcsRWfJeP0zWxAoV4U6NKOs++iW5UZEj0WdOyoy9FSOktEJR3F0Ja9GmtATGOKgHrfkWaexk1I8nyPvcxLKsEebPEjYBYV+gTu4Ix+ataFk0knIKgeyg1aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355206; c=relaxed/simple;
	bh=GFClniVWqeMAfO1ThfUgSAgH7y/ZsSnk5hpoki5yf3o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LSK7hxa/bVFEptd3OwV3629Xbpt1Vfx3cU0XR3nC9F1iDbNIScsy2EYx1i9+yPdaAZzCTaYRuw0WMdbuElZG1qCYs5lmKPwjQPXcdb8vppakWtIw/7Pcp71LXrhZVSeUjCAM1Tv/05rPBq0z06q4Ayr/3yMOWOpIuM++Qxt8P94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzaa+02M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzaa+02M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786355203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qux7+j8dXaPrVpMJRdGYi24EXrfglNjwCN8pMONiLkM=;
	b=gzaa+02Mj6r6hARmF1hkS9SDleui5nk1zwYz+4TMauSya/dFQxLBP4qARqx88qjRBr6C/9
	dos+oypq/OihLOjNkM9TdBIrbQHWFfJomTN2CoCT6jWkdJEDACGX02nTa3aRqWCcYxtdsZ
	JFfeS1802bAE+7wEUsXWo59SR4FF5fQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-1aCVgvigNlKExymPORSiXQ-1; Mon,
 10 Aug 2026 05:46:38 -0400
X-MC-Unique: 1aCVgvigNlKExymPORSiXQ-1
X-Mimecast-MFC-AGG-ID: 1aCVgvigNlKExymPORSiXQ_1786355197
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 191D91955F5A;
	Mon, 10 Aug 2026 09:46:37 +0000 (UTC)
Received: from [10.44.32.79] (unknown [10.44.32.79])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12E39422;
	Mon, 10 Aug 2026 09:46:34 +0000 (UTC)
Date: Mon, 10 Aug 2026 11:46:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
    jianhao.xu@seu.edu.cn
Subject: Re: [PATCH] dm-crypt: unlock allocation mutex before retry
In-Reply-To: <20260809051839.3504080-1-runyu.xiao@seu.edu.cn>
Message-ID: <36ae1bb3-09ad-77a2-15fb-4fa76208ad0c@redhat.com>
References: <20260809051839.3504080-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: k2NvrwlcfTmGp1OQSzbo-EzIhgBqd_aVyTJaAL-pUMo_1786355197
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sun, 9 Aug 2026, Runyu Xiao wrote:

> If the initial GFP_NOWAIT page allocation fails, crypt_alloc_buffer()
> sets __GFP_DIRECT_RECLAIM and retries while holding bio_alloc_lock. If a
> later page allocation fails, the retry edge bypasses the common unlock and
> reacquires the same mutex. This can deadlock the dm-crypt I/O path and
> leave I/O for the affected mapping stalled.

Hi

When __GFP_DIRECT_RECLAIM is set, mempool_alloc can't return NULL. So, the 
bug can't happen.

Mikulas

> Release the mutex before retrying, but only when this attempt took the
> direct-reclaim path; the first attempt did not acquire it.
> 
> This issue was identified by a static-analysis checker and manually
> confirmed by following the retry control flow in v6.1.66 and current
> mainline. A source-level control-flow check verified the vulnerable
> ordering and the unlock-before-retry ordering after this change. A small
> POSIX-thread model checked only the mutex re-acquisition condition; it does
> not exercise dm-crypt.
> 
> Fixes: 7145c241a1bf ("dm crypt: avoid deadlock in mempools")
> Cc: stable@vger.kernel.org
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
>  drivers/md/dm-crypt.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 608b617fb817..aabb9a5f85a7 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1674,6 +1674,8 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
>  		if (!pages) {
>  			crypt_free_buffer_pages(cc, clone);
>  			bio_put(clone);
> +			if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> +				mutex_unlock(&cc->bio_alloc_lock);
>  			gfp_mask |= __GFP_DIRECT_RECLAIM;
>  			order = 0;
>  			goto retry;
> -- 
> 2.34.1
> 

