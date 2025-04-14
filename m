Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8968236C
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744588893; cv=none; b=qchHJjQUDfeAErmTVEii1seP9bovQ4mm1ZBhIFqO6rzjIKWeFzLq8zbGlc4nVAxS+hEQOWTTRDIUocGxQl2ibVRT8fZjYB1sc67oTjNiWsEhhzu8UN50LQ+JKwgpDi6pjd3zClxLQVnmI+ffxW3cxvvQlMuzvKvKNi8cYyDlftI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744588893; c=relaxed/simple;
	bh=GnQIoaH1f3jbdTWYH7gznLVCZEMtonSv7z04t53GrgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQGYArZCgK4mID1UY5Imln7J4BABaG/mJiuHK7cPrBe0Rjiog9qwSdF/7xEStZ9nRzMVNZiV09FrgoYyXq1rivA9xEDKYJwn+Nv5WOghhaRBaNuw7Yqt5aU7vPlxt2d+68Qj5ofDSvOHNMa6IKdMCzEQl6ck8KO8ULBIlbOd+vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apoPUum3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apoPUum3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1CDC4CEDD;
	Mon, 14 Apr 2025 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744588893;
	bh=GnQIoaH1f3jbdTWYH7gznLVCZEMtonSv7z04t53GrgA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=apoPUum31dBHmUvPbaRquwsDeIUYxhC6ExLzQUp45QY+/H+KTFMZRQKBb6IwR7vXc
	 AHKaaDkEYTyyiUzS+mG5yZCK8W1w1RgdRKix7baOD6P6VRYhzyqwnFvllA8z1h05KB
	 Bs9bfNw/deunp5SJtQ2n1n3JHzf+qGiXqP/4gHTh/RvdT9M6IMxXH8OUOajEal0p9a
	 mB6tX7WU/I7YE87EB9x63XQ2A7PRgKeCFw0uJ5qSXuxlkbJvtUS+WjlbgAk/AJJie5
	 CU+XbIFx0YVdRIbmpkPlW4bv/+jC1cNyCXsUL/ZoKaJ5eQwr7wQH/GyRUquFuGe6F4
	 1ApIfL5uysSAA==
Message-ID: <29dacc6c-3f5a-4dc9-a095-828058264664@kernel.org>
Date: Mon, 14 Apr 2025 09:00:45 +0900
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

Nice !

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
