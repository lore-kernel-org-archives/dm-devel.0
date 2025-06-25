Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80F52BCF6F
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869000; cv=none; b=Td+3s2p32jUdotBkEa5Z/UozncLAXSvouMJt/G1EBRr1Wk4N/R3tFMgbUXHds04iLoHvbmcWFQawSX/KAn1Y2i4ZQHwfiINNA7lvCrEcJqqNbz8YW65C++b25jkQhZ9JS4rtqeX5fb8brLpQj2W3eWE5VfD6TWRXkGbnUWAYsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869000; c=relaxed/simple;
	bh=PIgQ/OhHVdyOcBPbU8zJu9keHDx4UYcPiGojGBH2l5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sufCKXiVzx4lbaRR8LyIfpeEH5i8IPiFnlFMnYYfMqOc5IgbAXukVimHhEZA7dgB/SIE4KBrZu4h6xpq494XOXTTbnGxCyYpIYaFe9UWw+9qtxppvmOgpYd8PVui1hG5yqvxeiTHqeRkIh5H6D8HcOlBvZAPKzc1/4WuZDc79RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YKvXtAvt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YKvXtAvt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bS6jd6h46zm0jwG;
	Wed, 25 Jun 2025 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750868996; x=1753460997; bh=UtVnoW5nMETFTzgvm7ldIpwz
	2KLWzYzih+TVX6kghjw=; b=YKvXtAvtMId00l/Nph22skjdSWuR/Fyt/m7Z3BgC
	NVudlSvC5vOGMmDSgG5iL/lAOH/3vbRQAXnlSlWZOGJgpGwcVmY/NLS1U/V8DURq
	8cSk3WXbpcO7hG7PdU4h/0pThHU1nhQkBkl9PJZXgi7gzjStaXCLfSGtqO797Qqi
	EfmmCBJ2S/bIrrQCdvh4fwIsCbN86ZO5+hFc8Mfe4LUgaIGar9z3sXB9yO8ae3w5
	fQoYqpu5ZehWx3YYm9gX8Co/Cyeqdb4DS+qEQojrEJpErQaEkM/hvstEZkmPkrOL
	xg/G+TyQgFYmp+0P3/J9q0Mb6zUIY9HCyvoCimUCmQlNCg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8PiHY6A7T9iZ; Wed, 25 Jun 2025 16:29:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bS6jX2d8wzm0jwK;
	Wed, 25 Jun 2025 16:29:51 +0000 (UTC)
Message-ID: <3f292307-30ac-442c-a694-5fc3560036a4@acm.org>
Date: Wed, 25 Jun 2025 09:29:50 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] block: Make REQ_OP_ZONE_FINISH a write operation
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-2-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250625093327.548866-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 2:33 AM, Damien Le Moal wrote:
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 3d1577f07c1c..930daff207df 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -350,11 +350,11 @@ enum req_op {
>   	/* Close a zone */
>   	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
>   	/* Transition a zone to full */
> -	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)12,
> +	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
>   	/* reset a zone write pointer */
> -	REQ_OP_ZONE_RESET	= (__force blk_opf_t)13,
> +	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
>   	/* reset all the zone present on the device */
> -	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)15,
> +	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
>   
>   	/* Driver private requests */
>   	REQ_OP_DRV_IN		= (__force blk_opf_t)34,

Since we are renumbering operation types, how about also
renumbering REQ_OP_ZONE_OPEN and/or REQ_OP_ZONE_CLOSE? Neither operation
modifies data on the storage medium nor any write pointers so these
operations shouldn't be considered as write operations, isn't it?

Thanks,

Bart.
