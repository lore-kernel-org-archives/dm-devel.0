Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A1179BC;
	Wed,  5 Jun 2024 06:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717570001; cv=none; b=e/TeZy3GFaFyZM5//kKoHLCdJ/RdhlivqulABqgXdKE4vgX6BgP+VFbUHHytecH1AJUaW5hRsz43tT2KTRh+IgT6yyo3nSfN1/pH5cJeWhLVDys//LlCM+8PXA7JxagT5s/ktUiLL/vrgoIMTXmw4npjjY6CXTXdFRrPAxS67/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717570001; c=relaxed/simple;
	bh=cStAtdBYughVmacLrRm7vPKXdt0AphsSWbfGEccdlSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mkDkOlKhv/4E26L5JTbxoG7wJv/0hwKiLxu2wcqy7AhypIIAsXWJ2feukEU03W9F8cSZxQjpHrXPCoiY8bQF9bmm4XcVXRxh9GPHBor+DsztIsqEqAxyXfmrHgDM+BkIgoxYCcLC1Vb/Q0oKpWRT+pXp1wr/NqJpQiZRDRFOSVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KV8RTU5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KV8RTU5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1E2C3277B;
	Wed,  5 Jun 2024 06:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717570000;
	bh=cStAtdBYughVmacLrRm7vPKXdt0AphsSWbfGEccdlSM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KV8RTU5XjowIaFoRzFMc8D3qcFhsDufN8RRn7VVrvj50XTX1lnbeQJkfejiN+lyLj
	 DbefSN7BdCS1xwQ70aapM+AfO5q4/DCRUngTaByJWz6LWl/bM4Ek+nlC9H/KJDaKCt
	 YdeYZOS0toq9Eec99HPcHyw2rZzuG3xvhL6nMBTU8xCoG1ZIBC92oEOjdkUIpTIwFe
	 /3O7EH3Zv4BHblkj8G3xu5zlNULX7OWqYrGJHDLr+FwkUia8aMDaF0vHEgXwAU1clL
	 Hvme5eaBI70vYUc5y5xDK3vOqa/kUVrfun1qR09ZWdI9LIHmzhGlc8W7J6ueZWzdEC
	 ebQcisJ3emF4Q==
Message-ID: <af37a28f-9d3e-4121-9961-98bc14dbeb7e@kernel.org>
Date: Wed, 5 Jun 2024 15:46:38 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] block: Imporve checks on zone resource limits
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240605063907.129120-1-dlemoal@kernel.org>
 <20240605063907.129120-2-dlemoal@kernel.org> <20240605064516.GA14642@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240605064516.GA14642@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 15:45, Christoph Hellwig wrote:
> The misspelling of improve in the subject is still there.

Yep. Just saw it. Will resend with that fixed.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

-- 
Damien Le Moal
Western Digital Research

