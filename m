Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE36126772D;
	Wed, 30 Jul 2025 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753899747; cv=none; b=cWZ1+Ib/YzPxGhwFecB+NEuI4Uof6NmPAe6bI4kQQjMF+33D0/MAnGq6iIqg6ki5DVFem6n0w5sUCGf2Ex7nG5iaJW1N0RB7RCSpnuExYzR2UMCxLRpnu2D5g5g+/u0GoEKwn5EAy2uCbeuU9IWHnjBtQBmmMfdOGkHE/haIylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753899747; c=relaxed/simple;
	bh=gKwZJ0pGGO7ENueq4KJlWZlwAydoQTAE/8zp2zC0RL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FJqhVE+wIEuwDpIp5S7Cw4T0NM4PSFodX4gpdQ6tHkE+guI0XBq9nNGRYXfB8a1N7aHeVKsqDUNDWo7zxFHqnVMCB/NPEp5HPpYcCAO/dUANVTe5weRU8P4Lx10BbOKyQydmvTjNFnj02jEO1d8UhN5KIU25oqDhiDUvPfL6CIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swlGH5+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swlGH5+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADCCC4CEE3;
	Wed, 30 Jul 2025 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753899746;
	bh=gKwZJ0pGGO7ENueq4KJlWZlwAydoQTAE/8zp2zC0RL8=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=swlGH5+fvz4Eyjs0wTXrREvlsLUcNx9Lk541Skt/dGIbTwAz78+y06Uc+Y3crHZKB
	 WHZfzhhE0jQqYA2W3/Q0XEEY9/pm0Vnt1L2s77Rc96cSKVwnG2jRfDFxmUjcSGsSk7
	 C2NINNkRG4QNKR5e/bJOI8jExNJ0mq7HTeT+Smn0Bl2cYSpRr2zfm60FVeIA8+i0xL
	 RKncFTNK78GFAvnHGFuqSLaQWGu1Fpn3OijQnqrwqFf2LqMpzNu7+uFkwSu9YbK9Wf
	 uA+p05ZNVRHuTaSiiRb483pHO8fYaECyHLICS7g2PdNG5plbEJWlthfWuZ9XGWFHyT
	 tbCGJ/DG0VPRQ==
Message-ID: <e2af7f3b-8897-4cc2-ad36-4487f68638f1@kernel.org>
Date: Thu, 31 Jul 2025 02:22:19 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v2 md-6.17] md: rename recovery_cp to resync_offset
To: linan666@huaweicloud.com, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250722033340.1933388-1-linan666@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250722033340.1933388-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/22 11:33, linan666@huaweicloud.com 写道:
> From: Li Nan<linan122@huawei.com>
>
> 'recovery_cp' was used to represent the progress of sync, but its name
> contains recovery, which can cause confusion. Replaces 'recovery_cp'
> with 'resync_offset' for clarity.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
> v2: cook on md-6.17
>
>   drivers/md/md.h                |  2 +-
>   include/uapi/linux/raid/md_p.h |  2 +-
>   drivers/md/dm-raid.c           | 42 ++++++++++++++--------------
>   drivers/md/md-bitmap.c         |  8 +++---
>   drivers/md/md-cluster.c        | 16 +++++------
>   drivers/md/md.c                | 50 +++++++++++++++++-----------------
>   drivers/md/raid0.c             |  6 ++--
>   drivers/md/raid1-10.c          |  2 +-
>   drivers/md/raid1.c             | 10 +++----
>   drivers/md/raid10.c            | 16 +++++------
>   drivers/md/raid5-ppl.c         |  6 ++--
>   drivers/md/raid5.c             | 30 ++++++++++----------
>   12 files changed, 95 insertions(+), 95 deletions(-)
Applied to md-6.17
Thanks

