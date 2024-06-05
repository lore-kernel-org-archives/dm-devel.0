Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7265E17C79;
	Wed,  5 Jun 2024 02:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554375; cv=none; b=nvZ9u+memPIhUNWKyhAdzSjnZwu/+YT/rNnYaEvl5zHZ9FJI7JZRfaPfPjD1IjnP0zeo2TrbhQg4CSRzXpPYjujWK39+2kZNJadnP8Plp7vUMgLEnhqfWauESSGu8SuvPGzZVV1NuE7n8RdXua0HjS6sowUbKfEctT4nfNNxbDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554375; c=relaxed/simple;
	bh=mCYltvarmnJzuB/JYMF2tS28nkqb57Jb6w48cm8ErRw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SeRcHCgyKYFkjzg+bDFvrxdOmSSniQZI81eYXfS2cpMYRW0zVFlxBip2ZHc2TI1s2KkoL5c3EL7HyI7EegdBsg9/EtdOk9xzLcFexEK9jORBJgR9xCU8y84Gd941dyTTsxleVBr08iS6t6sCRVuc1JEWXa5QbUEwsestHrbdUFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3sCSnY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3sCSnY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C3AC2BBFC;
	Wed,  5 Jun 2024 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717554375;
	bh=mCYltvarmnJzuB/JYMF2tS28nkqb57Jb6w48cm8ErRw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=K3sCSnY87X8QiORDGcFdWB2u45FDynbdhuhxtpxBniUBJ/W2GpABQMVbzXyyoVUUp
	 4ZRadEBkCneIAm64dsHOXW+ND7T8U38liaz9w1V9l6xo18EdCQJz0rFiokfF+Gz/GP
	 qYW/ZV0Vjw0HXLwL9eDelf3tAQABdl2PQah51ZQTHLWqM7HP3cg/f+e+4GFIFJAnKT
	 7Yq8eHnb72DPa8yYjlwYLMpjC5R97qgh8gZPX2/ihdKKhy5Xf8ZCsMJ2S20OkXjimF
	 odXdtyZ0g3yYAeiRNqaak9i9Q80t3wqdHstoudlDDb2b8ugKJS9budKl+mnK5ZSWBJ
	 Oi0jw9bfxUKZw==
Message-ID: <20c3778a-3f11-4291-a12f-e7cec3a4f278@kernel.org>
Date: Wed, 5 Jun 2024 11:26:12 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] Fix DM zone resource limits stacking
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20240605022445.105747-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240605022445.105747-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 11:24, Damien Le Moal wrote:
> This is V2 of the patch 4/4 of the series "Zone write plugging and DM
> zone fixes". This patch fixes DM zone resource limits stacking (max open
> zones and max active zones limits). Patch 1 is new and is added to help
> catch problems and eventual regressions of the handling of these limits.

I forgot to mention that I am working with Shin'ichiro to add blktests cases to
extend zbd test group coverage to DM zone resource limits.


-- 
Damien Le Moal
Western Digital Research

