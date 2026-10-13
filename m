Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D73D5C06;
	Tue, 13 Oct 2026 09:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883945; cv=none; b=XsrqYoVGfyY4LxMfka865paZrV9W9HRO1uUKDfDmPbtPwX2qfdFzewPKY0ddXsXdDvM+ydaLvvziBiIsR8vhaWAAxVU1ymh/wcO+zv9NN6UpiaZryQvdgr6lj5f4WSLP6JqSwHqrkKMWdEVH34JcK4CT5kXr5cET9jOGuXlA1s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883945; c=relaxed/simple;
	bh=AEUjfr2MLiIhThRpGDnulh/upbSp4ArxxRlxM5Rj+DI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwLq2ehqj/TLT8PGpROz27pIqpsnJSqSlP5TQhhU78uqmswnkM1pwfr3m4V1iFJsOQf/PWLWrbtjYJ9Que3ZkGqC75VLW2xTCVj/SNBW2aDn/B95AxlxzW6xeO/TwkMONJCMdu5LWVIPG7zarMl4UBP8RFcT/6ZnoalQU3HUeec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZR+LkcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZR+LkcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624801F000FF;
	Tue, 13 Oct 2026 09:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791883943;
	bh=syHbkCtoQcXGtAMGODU8mjIoubwis8W7djgCLmX4K2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aZR+LkcOjnUYY+axLBsQOfuxtO+OdH9zA1Ln1oN66khsmWR0AxWXGyPOJ9m+FiTrr
	 vW8WUNtWQuiKIiowizh2EhkooubrYEdf+6/8DwLKWtbNWKKMoFQbL/47Tw++haKmHB
	 Y8LO4ASgHKcNSDrHbJZTON6VgHczGMdDjg9WsR31Mgjn+O9W8iyGpSuqYtd3MYnCeC
	 Lp9iD0PrAfMUkFj1tSXBAfX4cCEuNsO5MdTupuLbaikl4jnftgRdrsjYg1EbLyXWNX
	 EYVcl0lOldHLyVtUAaGWXWJTYHvyXTUofMa4Tk47n/JXegq8kyYjS2AlRX9YgP45/e
	 68545DcQmVAHA==
Message-ID: <13eaede8-ea0c-4215-870d-fef60919aed8@kernel.org>
Date: Tue, 13 Oct 2026 11:32:20 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] dm zoned: back off when reclaim finds no
 destination zone
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-2-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261011175450.952-2-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/11 19:54, Kyrylo Biryuk wrote:
> When dmz_do_reclaim() fails with -ENOSPC because no free zone is
> available to copy the data into, dmz_reclaim_work() still ends with
> dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
> keeps returning true, the work is queued again with no delay and the
> worker spins on the same failing pass.
> 
> Re-arm the idle poll instead, so that reclaim is retried after
> DMZ_IDLE_PERIOD. The next patch makes -ENOSPC the expected result when
> an idle target has random zones but no free sequential zone.
> 
> Tested on a 7.2.6 kernel as an out-of-tree dm-zoned module, together
> with the next two patches, on emulated host-managed drives (tcmu-runner
> ZBC handler) and on three 27 TB host-managed drives used as md RAID5
> members.
> 
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>

Looks OK but testing should always be done on the latest mainline kernel, or
linux-next.

This also needs a Fixes tag. With that added, please feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
