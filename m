Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0697EFBFD;
	Tue, 30 Apr 2024 22:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714517409; cv=none; b=UTABCsKT6IQDBHvcTPKYhELEYMA6kb56pne4UFp8gudSoGZCX1B6TVM/fs8JGsQa1C3kThBdTclNK3YxoN/8eljPLyssFLdJ867hShIx+L/3MKP5QahJKzIGw8jlyusADhVIgcJ1eR2G73KkY/NJwGeBTT5QFbYFJXiOLhKRjrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714517409; c=relaxed/simple;
	bh=+0PCWyqq/oVXCE2rQysVcS78moJ/4NoK0UKhpjSntNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mhx+Fv1leND0oZ1FzjP2gvfazOdvJMKArrC5iexWenxTkSgHUBGtUK+Gmaik+QglsfPrd4hLf5ZjMVToB6VnLUhnBgE94CpCSwK6VV0DONR8D0QGWvAW0SghxCJMFc0kzGvJZII0jYOIkrWhjJ8E/nZHVQ+WZ34vNaA3HfpqS4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQEHG/1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQEHG/1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1109C2BBFC;
	Tue, 30 Apr 2024 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714517408;
	bh=+0PCWyqq/oVXCE2rQysVcS78moJ/4NoK0UKhpjSntNE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GQEHG/1sLAhUPRQZmDT3neMF6+qk5aDV7hhjR1BVbZHh7WylgcDhLtmo6CmehMc73
	 S1satcH4jmqHqP0FcNPkBNhO1BKGd5Ok551I4FTeU0aE9ON1+ihWpttaIChlp5ILMv
	 cmD5Sv2CjDZ7csQw/AI2HbnUVQXOBLM5ipadTNlaIgYD8P5bGGjsb2Kk5pw1GQtddw
	 /13ucgIH8AFwGUzbdlFPgYqL/PUqWy5LZjWbaAVcN06aQtqIkNmZDwEfiHLnRtRJrw
	 o+ESdXxsftgBpYDHjUmgpmFo2+MY22XXNY9OUSO94nNstVpW4B//iujUDdnxDNEBOG
	 SSm2QBE9iN1Ng==
Message-ID: <c3df1441-94a1-4b7b-b9ed-733d1a1a0639@kernel.org>
Date: Wed, 1 May 2024 07:50:05 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] block: Fix zone write plug initialization from
 blk_revalidate_zone_cb()
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-4-dlemoal@kernel.org> <ZjENmQ6d0tayg_YR@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZjENmQ6d0tayg_YR@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 00:26, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Although I suspect that at some point blk_revalidate_zone_cb should
> grow separate helpers for the conventional and sequential required cases
> as the amount of code in that switch statement is getting a bit out of
> bounds..

Yep, will clean that up later (next cycle).

-- 
Damien Le Moal
Western Digital Research

