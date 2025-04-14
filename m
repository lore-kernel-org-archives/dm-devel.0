Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DC4A06
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 00:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744589862; cv=none; b=sdwnL4f/XFHseCPDoD33odVGOGB1Y+aM1D5rj9Swc7SANhT+FB98VC2qDLSPGfmDzJJSRxVy6EWAcmgwIi0Qy58px8Qh246iKfo80IcLVUh9AEgXAVYBtAoA2Xruvnj/CrHeQhVBwa/NbW9ebtg1esL7Ulm7gqBqMvtX8M8MEX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744589862; c=relaxed/simple;
	bh=XkZWRoPEbbTkSFRZIGawWtHzvXx+0stnmwHJOBuhwvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MnZ+MDHsn9+Wb44B1JnLfc/ACtvancWDFQWKs5MSPqNk7cyXQf6Sq0yrB11rqMaH5eILL/GPhu0xQxYHBCqugHpgDgnhQ9/rfDlfjsmXlL+OZ7UzveuDzXUYNvY53S46uJPXMTfWWXRoFpeuiRZohTBgnb3q40KlYqLGwsqoJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOuNHoKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOuNHoKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09938C4CEDD;
	Mon, 14 Apr 2025 00:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744589861;
	bh=XkZWRoPEbbTkSFRZIGawWtHzvXx+0stnmwHJOBuhwvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mOuNHoKPUKNPeLnVzYq0iYnUdyPTAm20E76UxM7sITJps7ZXDgfIYiLIh/6o769Tm
	 ww81YTgHp58KUTRE23wpZP8EsSS+4ZaCsUPW2284Dq0DLNqptq8WPkWbMoBy67tVoE
	 WssuOauVN3S3WCbBgJX3wC1ApYxHgv4bhAyfH3h/9VqjBJPoTOl97VHJohOtd3n2oY
	 FlOHUVW70O7rKkMwO2kp7GvBxzbtsepcMTPZID3IoxK70RhLt6B8HYP3XziIw2uW/f
	 rSG1pnQ5JzggZ/j20eoXu4Efm+1tY5qYsCnA2Jcd7dVsreRpfEyeOExEMzEH6aDB/T
	 NDDG6PGQzSDTQ==
Message-ID: <b74b450c-ec31-415e-9edd-8d819fd08ae0@kernel.org>
Date: Mon, 14 Apr 2025 09:16:53 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: don't busy-wait in kthread
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christian Loehle <christian.loehle@arm.com>
References: <20250411205656.60709-1-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250411205656.60709-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/25 5:56 AM, Benjamin Marzinski wrote:
> When using a kthread to delay the IOs, dm-delay would continuously loop,
> checking if IOs were ready to submit. It had a cond_resched() call in
> the loop, but might still loop hundreds of millions of times waiting for
> an IO that was scheduled to be submitted 10s of ms in the future. With
> the change to make dm-delay over zoned devices always use kthreads
> regardless of the length of the delay, this wasted work only gets worse.
> 
> To solve this and still keep roughly the same precision for very short
> delays, dm-delay now calls fsleep() for 1/8th of the smallest non-zero
> delay it will place on IOs, or 1 ms, whichever is smaller. The reason
> that dm-delay doesn't just use the actual expiration time of the next
> delayed IO to calculated the sleep time is that delay_dtr() must wait
> for the kthread to finish before deleting the table. If a zoned device
> with a long delay queued an IO shortly before being suspended and
> removed, the IO would be flushed in delay_presuspend(), but the removing
> the device would still have to wait for the remainder of the long delay.
> This time is now capped at 1 ms.
> 
> Fixes: 70bbeb29fab09 ("dm delay: for short delays, use kthread instead of timers and wq")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Works fine !

Tested-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
