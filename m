Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1813ADC;
	Wed, 29 Nov 2023 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1Jl/mBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119CBC433C8;
	Wed, 29 Nov 2023 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701279518;
	bh=KnhqF6EQzfKo6kHdAZmKtpGG9d8V4VPAuxym4RvzBIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O1Jl/mBLg/WHmxPlIBFWtYX1eJrpo2zbBgNeBlJ+qbJiLBpBWeF6eeGeSfkjLJH0o
	 ffUTT7xeipLKiZdioD/1RVAvG9d8w9ep9OnNBOA6cw/wTgxQ81ZaOdAp9BT02z0Ge1
	 274+0KuiBZNaMCh3771ztzwkUSgmhjUtDejefSi5FIzpTCR2PbEN2tjx0Xapnp0a69
	 yReh+Ipfxp1vlLXsrBco7dLl/c9OcLopzMdDr0paF1v/0YjX+q0U1rDq845YuhM0Nq
	 ZG9ce13+D1/zZABbapf9VuCkT1KhHvkDVpMU+wmbJOK/jAAiG5Y3NJSuXpvOroRuNL
	 Dhn8ePYGx102w==
Date: Wed, 29 Nov 2023 12:38:36 -0500
From: Sasha Levin <sashal@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christian Loehle <christian.loehle@arm.com>,
	stable-commits@vger.kernel.org, stable@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: Patch "dm delay: for short delays, use kthread instead of timers
 and wq" has been added to the 6.6-stable tree
Message-ID: <ZWd3HCVNTkZYREGo@sashalap>
References: <20231129025441.892320-1-sashal@kernel.org>
 <cac7f5be-454c-5ae1-e025-9ad1d84999fc@redhat.com>
 <bdf739ae-5e45-4192-b682-81f05982c220@arm.com>
 <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com>

On Wed, Nov 29, 2023 at 06:28:16PM +0100, Mikulas Patocka wrote:
>
>
>On Wed, 29 Nov 2023, Christian Loehle wrote:
>
>> Hi Mikulas,
>> Agreed and thanks for fixing.
>> Has this been selected for stable because of:
>> 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and delay_bio")
>> If so, I would volunteer do the backports for that for you at least.
>
>I wouldn't backport this patch - it is an enhancement, not a bugfix, so it
>doesn't qualify for the stable kernel backports.

Right - this watch was selected as a dependency for 6fc45b6ed921
("dm-delay: fix a race between delay_presuspend and delay_bio").

In general, unless it's impractical, we'd rather take a dependency chain
rather than deal with a non-trivial backport as those tend to have
issues longer term.

-- 
Thanks,
Sasha
