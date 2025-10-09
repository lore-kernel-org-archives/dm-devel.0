Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537DA7261A
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 03:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759981353; cv=none; b=MiyxDDpq47KejXqS2xwffmQ4EyhNyDbMmXLsrCo6QcH9SgcyBINRkq7lOaUtZN0WtMYuq8x2ocZmllhl0X7R0GyOVi6wRtzeN6969a6GEhSiqNVeWQjsIjhn8Mcyk2BWmSGL7T7PV5lWxZuac59jGxVZ0r61+ZEEHRS5H62Bv/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759981353; c=relaxed/simple;
	bh=QsF0Lad27cRaa2fqAvJErDggpy5ZZhwxFhVZ1vlBsz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXY81qaF4xOoW0HyCjNXbu//Q2iuqZgt1vPfvC2ZURGorwUFG1qqWeaSgsNrsgwmd/qMyrB1AD/iDEcL5pp2KvN15bWb6r0aftkOJvd4OqhKiUOxRBpfJPk7GciMTNYhg/h2nEMALZQ/DU459gtor90klkIpRT3YxMvBqCJ7qO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/A3K+JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/A3K+JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEDFC4CEE7;
	Thu,  9 Oct 2025 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759981352;
	bh=QsF0Lad27cRaa2fqAvJErDggpy5ZZhwxFhVZ1vlBsz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M/A3K+JRnAuc0AflqarjnPc2BHB0D/xtpV58QuRSGXmVluyuMzO+Cr0DTq/2yLBF4
	 nCSf9wx/Gt88Vwg3RCaVLMbmWdQ/DEbi5n2iZ/utJcrvZi5NBP9SjmXt/ykM+AxUpO
	 kX4bVah5ORN1tR/3ujJThdCInEUggUoMOQjMcb+rodwAdoZ3r/Ev4CMHoupaGSTJ5W
	 Uvwa8/aHmauL0b+PwrenqAurqf1ZkoaQcoWCU4aQKot5gFnd6obje16TPuO75ySnri
	 ki7ajQHWmprQH9v8OLp44C8nGWE7pCratN3wg5UfnDtfc49GuynNokuSt4oUHPYcEf
	 G1kM824TcSbaw==
Message-ID: <fac91ea3-87ef-4f7d-a508-a5761f9d01a9@kernel.org>
Date: Thu, 9 Oct 2025 12:42:30 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: remove useless md->nr_zones variable
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
References: <20251009032411.2896184-1-bmarzins@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251009032411.2896184-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/25 12:24, Benjamin Marzinski wrote:
> md->nr_zones is no longer used for anything. Remove it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
