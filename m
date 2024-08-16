Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD539FCE
	for <dm-devel@lists.linux.dev>; Fri, 16 Aug 2024 01:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723772123; cv=none; b=Y80qzDeVL4W6CTWhz6vtQDCHfpOEjPV6FrzEHrW/lrxLfmItYoHTa4u+FOnIgK0L7Pkj91dFq3Xld503DR14r8jvapcitJNae1kEseuqnhkCl88SBozhOrjTw0YcN3hkxdS0+Xe4NbM0lY9utwnf6XdoUN9Vi8VGMzFq2941IeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723772123; c=relaxed/simple;
	bh=jvBB+9uEpCsZl3RSamVgb2vEia8IR9sAMPT8M3Ef1Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Qng4TZPCnbwdCg+VUjnwZJNJY69q+4n4rLdj+sZLlBM3FK0N6VX3J0lw91EILFEPbg8habuV27SwSqjaNWW5qqqWSdYZxd1OgTJoOLrIc24hJfaj32CWXj83fJWxnrOXuS+vnNsBpKfZEancf870H/maqsSYUVFWJmeiGCBa1Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cEcf8KPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cEcf8KPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B43C32786;
	Fri, 16 Aug 2024 01:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723772122;
	bh=jvBB+9uEpCsZl3RSamVgb2vEia8IR9sAMPT8M3Ef1Wo=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=cEcf8KPhpx8WaoLITh+NeVqT49Qz3RreAob2wNC7bO/8MOV8+DpS/yshUZE0OTQM4
	 U4c+1HLtOMq5kBHfiA1M9bC5SDffu/x9NsBzfYWfnhSnIJeunH2MU0Upc/zJZf8Q5o
	 obo2d/jZNp8vlCIcVSQOPI+wHM22lmYHnwi+HT3Bpr7VhsmIKe4xon+ullcwxu2eTS
	 GLsCD2Od8h85GmbEFSKsDmTW7D4Y3RuMi26Gl2SP+c3jilfyO7BpnTL6sPFKisAM4K
	 RgmO4zJk4CVbG72FV11BX6VEzKhksTsjFRy6YlY5EIcJwv+TWLijzjcYIXgsJhAjcq
	 MeATZjNSWIt/g==
Message-ID: <6754083e-18df-4c83-be8f-1879a4e5698b@kernel.org>
Date: Fri, 16 Aug 2024 10:35:21 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Remove unused declaration and empty definition
 "dm_zone_map_bio"
To: Zhang Zekun <zhangzekun11@huawei.com>, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev
References: <20240812115309.113917-1-zhangzekun11@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240812115309.113917-1-zhangzekun11@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 20:53, Zhang Zekun wrote:
> dm_zone_map_bio() has beed removed since commit f211268ed1f9 ("dm: Use
> the block layer zone append emulation"), remain the declaration unused in
> header files. So, let's remove this unused declaration and empty
> definition.
> 
> Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

