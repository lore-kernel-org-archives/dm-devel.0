Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A824F19CC11;
	Sun,  9 Mar 2025 23:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741562313; cv=none; b=RithYoiTiRdmuiERkARlYnsnqh0ZKyh2ZWwVKKf0MrJUDHJsE5AuzScIhgK3kbGS5MAS68cKIDsXme3J1ZP82D6FQgbJYCzyMTdgRypbVhg5gC0ZeltOnlwRdFfjz5Q8ZlFPFRMr/gBkuT4waDtfYNDxMkphZfkRnumDBdKAa9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741562313; c=relaxed/simple;
	bh=ssZi1NnO4kInr227dJEulpXlELbivxzpH4k2fDF+plw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=npyrPOFgrodOM7cuwtYrdwPTkiWjQbZqOtFNZbPBSpvgJA44oqiBIv0r16uIcdckR85f8ozWQ8GIMpmMM1Avoh7qwcxJa+cH8O8Yxw4oi5b1sfhawUVqqJnKykmVd6WiTi8avXSXZxkqZs7gDNykL/NClTBNXqTQKZku+Z08Brg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTuG63+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTuG63+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECD6C4CEE3;
	Sun,  9 Mar 2025 23:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741562313;
	bh=ssZi1NnO4kInr227dJEulpXlELbivxzpH4k2fDF+plw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fTuG63+kTeS9SeJuuz9Ej4dcdjU3FfRHZjas9M2ugW5OW0eIQ8NsokMSZ/Izyk1cc
	 ed9lCwh4zHFLTng2hPDiKy+tsuubqWYqlN4VkulPzoUy/vhteoCNHTjgqwajEGcgeB
	 /DU+eTeyWMGhMpC5pqkbp7/9HtpRmR944XDuVdhKKm8rApVGmlE366IFDgpmHQZNKn
	 BfaGVMBmNnenOlQiSkllBCUL1LwWQAg9q5bJiYFJb/hNmZBmYgSVD4g3pugpWfDqvW
	 kzn55TApBf2Ra8kKH65xOFtJNGSsLqqDwc/KTom3MtWa8Mamzyhj0aiK41V/SUMuNZ
	 I2yjWpqicn/lw==
Message-ID: <671584b2-89ca-42f0-b7d5-a16bc77c3dab@kernel.org>
Date: Mon, 10 Mar 2025 08:18:31 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] dm: don't change md if dm_table_set_restrictions()
 fails
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-2-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-2-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:28, Benjamin Marzinski wrote:
> __bind was changing the disk capacity, geometry and mempools of the
> mapped device before calling dm_table_set_restrictions() which could
> fail, forcing dm to drop the new table. Failing here would leave the
> device using the old table but with the wrong capacity and mempools.
> 
> Move dm_table_set_restrictions() earlier in __bind(). Since it needs the
> capacity to be set, save the old version and restore it on failure.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Does this need a "Fixes" tag maybe ?

Otherwise looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
