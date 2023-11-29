Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350361BDE4;
	Wed, 29 Nov 2023 20:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAPr/pDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DC2C433CA;
	Wed, 29 Nov 2023 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701288035;
	bh=qWUQirFKWRiblfw3zPB4C99l56UyCJAjh7X5MpvzrTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eAPr/pDMHuMHVgLcvpVTs3xRM2yiYGvuvaNrTm17Ed+WYZ6q48wSpdA//iHgvkT0i
	 NEpX508bf6XsHKg57lJfI3nHE/eYGknPzb/MZeUiMwepXVZFeToG+HZMAaE4zPKyRi
	 dtwO94COZ2rZiP1fRVWV/x7HXNzHIAvP4FSS/SABoUfTW+3oXE2Up9DEea0iNlCCd2
	 sLPi7mSspQ7V1CPKmNnrFKzbNFnzpFuDFcKk3zI7IxDwDTyl3GHwAJmxrHsrNJsyJU
	 MrO8ktQhiEAZlxE75tPbpEoftF88DhnFYsLmjLBfq/9zJma7EM9bBsgC3fMYWmyCLR
	 J1dyAoz1kER1w==
Date: Wed, 29 Nov 2023 15:00:34 -0500
From: Sasha Levin <sashal@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christian Loehle <christian.loehle@arm.com>,
	stable-commits@vger.kernel.org, stable@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: Patch "dm delay: for short delays, use kthread instead of timers
 and wq" has been added to the 6.6-stable tree
Message-ID: <ZWeYYodi5TeKlDw8@sashalap>
References: <20231129025441.892320-1-sashal@kernel.org>
 <cac7f5be-454c-5ae1-e025-9ad1d84999fc@redhat.com>
 <bdf739ae-5e45-4192-b682-81f05982c220@arm.com>
 <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com>
 <ZWd3HCVNTkZYREGo@sashalap>
 <b8d0fdf7-fca4-4a2d-3dd-94b2c97b7fb4@redhat.com>
 <ZWeIiCcZXwZkY1_J@sashalap>
 <ef29ecb1-5853-88cc-16c0-98cf17c2519@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ef29ecb1-5853-88cc-16c0-98cf17c2519@redhat.com>

On Wed, Nov 29, 2023 at 08:02:23PM +0100, Mikulas Patocka wrote:
>
>
>On Wed, 29 Nov 2023, Sasha Levin wrote:
>
>> On Wed, Nov 29, 2023 at 07:16:52PM +0100, Mikulas Patocka wrote:
>> >
>> >
>> >On Wed, 29 Nov 2023, Sasha Levin wrote:
>> >
>> >> On Wed, Nov 29, 2023 at 06:28:16PM +0100, Mikulas Patocka wrote:
>> >> >
>> >> >
>> >> >On Wed, 29 Nov 2023, Christian Loehle wrote:
>> >> >
>> >> >> Hi Mikulas,
>> >> >> Agreed and thanks for fixing.
>> >> >> Has this been selected for stable because of:
>> >> >> 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and
>> >> >> delay_bio")
>> >> >> If so, I would volunteer do the backports for that for you at least.
>> >> >
>> >> >I wouldn't backport this patch - it is an enhancement, not a bugfix, so it
>> >> >doesn't qualify for the stable kernel backports.
>> >>
>> >> Right - this watch was selected as a dependency for 6fc45b6ed921
>> >> ("dm-delay: fix a race between delay_presuspend and delay_bio").
>> >>
>> >> In general, unless it's impractical, we'd rather take a dependency chain
>> >> rather than deal with a non-trivial backport as those tend to have
>> >> issues longer term.
>> >>
>> >> --
>> >> Thanks,
>> >> Sasha
>> >
>> >The patch 70bbeb29fab0 ("dm delay: for short delays, use kthread instead
>> >of timers and wq") changes behavior of dm-delay from using timers to
>> >polling, so it may cause problems to people running legacy kernels - the
>> >polling consumes more CPU time than the timers - so I think it shouldn't
>> >go to the stable kernels where users expect that there will be no
>> >functional change.
>> >
>> >Here I'm submitting the patch 6fc45b6ed921 backported for 6.6.3.
>>
>> Is this okay for 6.1 too?
>
>Yes, it is. It applies to kernels as old as 4.19.

Great, applied all the way back to 4.19. Thanks!

-- 
Thanks,
Sasha
