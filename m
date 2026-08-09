Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCF014A60F
	for <dm-devel@lists.linux.dev>; Sun,  9 Aug 2026 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786281649; cv=none; b=OGnFRzdCwar3TCj79r2q8XC3et3dv3hG2CqPFihty0KPlI6EJazHasuxbZXwd8+jospcKMiR2oPEW/2GCtJzZ2ol3vsouQnQfXIEI8hiBzbst84oR20mOkN/owZ0pSakvwH4xkRurvioRDqUtkhm+o5INLaTPmyTG3maOsMiBFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786281649; c=relaxed/simple;
	bh=eFlFQDjxmT8wbIF3QRFIdPsrh2lsOq/XSa0wEF4QFLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NU0YRHvRVXKDfD7fSBXssI6TUeluHv/HeP8DKV/XpwEeR75yxVQheK/TdLTQDH/2XxFBXngHVJCpOiSxlO2Qt9Svf8Do6ldCopyZz9ACSzlwmDAG44yPQ30jMe0qpIbBE6N93qhclmclgznPeNp6tCyVbP/SWy3A4f0mut/RGHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RnNi41d1; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RnNi41d1"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hHz606YP3z1XM5kD;
	Sun,  9 Aug 2026 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786281636; x=1788873637; bh=qpn6cSz95QgFeifQ3LXDLTeE
	F2vkptrFsjsEYP+zsDQ=; b=RnNi41d1YEgLBV4dEVgBCKDjWjM666F7VeQa8Ag6
	qM41jPnXstxNV0Ricld54HqXCcqWFp2Ddd48U0cH4yUPnw9i8IB+HianfX4tFyad
	hRnHic0jD4LIdZaQtxg0cE75MX1iprtH+RkgVIVsYuqFKpoKpsVgoJ/vMEV19Mly
	A2pjVH8BPW6oqj6FMBAEOxpPRA0iyBle+pIVdij8cgaExhJm6B6vxr5jikdRUMPv
	Nm9lCWgiON9xPLaXZSlc5Dwu4uLr8c9FTc3sil8BeDWPjg8wYHA3Pk4+bYb7wWaY
	LRUDIJvMPI6WnSxnuQ02sYrFRapxU9qCqMA5vy/rq64L5A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9bEVhrzMG4NT; Sun,  9 Aug 2026 13:20:36 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hHz5t1gJ9z1XM4Sx;
	Sun,  9 Aug 2026 13:20:33 +0000 (UTC)
Message-ID: <cc5ed697-e769-4f40-aa9c-19c90b79fa7b@acm.org>
Date: Sun, 9 Aug 2026 06:20:33 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: unlock allocation mutex before retry
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20260809051839.3504080-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260809051839.3504080-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/26 10:18 PM, Runyu Xiao wrote:
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 608b617fb817..aabb9a5f85a7 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1674,6 +1674,8 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
>   		if (!pages) {
>   			crypt_free_buffer_pages(cc, clone);
>   			bio_put(clone);
> +			if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
> +				mutex_unlock(&cc->bio_alloc_lock);
>   			gfp_mask |= __GFP_DIRECT_RECLAIM;
>   			order = 0;
>   			goto retry;

Please refactor crypt_alloc_buffer() such that context analysis can be
enabled instead of making this function more complex. One way to do this
is by moving the crypt_alloc_buffer() code that occurs between the
mutex_lock() and mutex_unlock() calls into a helper function.

See also https://docs.kernel.org/dev-tools/context-analysis.html.

Thanks,

Bart.
