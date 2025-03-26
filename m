Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC81BC9E2
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 16:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743007259; cv=none; b=m7G2+XXxDCKYAyVfhV9jjv1ldzc8p6oqvfybN+OiuFPSGOMfqxiGBKIarS0IXQ4ZssOR7KhrYjfvVWrTGBiyYLRoDDJpcvWH31tLQJ9uAcHbvGvvS2ImdlJIDbwV++aLY5rnWIHfRQuTHIKujX34/PKVq/yaz2GXMsuw1qekjdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743007259; c=relaxed/simple;
	bh=hM/NheaQfuMoUdlsLtDq8WZibH5SuiaaMLLZxbfZwXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5UzUTnNw60Pge7OhmqXMq75/ijYRz4/oR+IxQ+8BPy0rjgmnC2a1bzqoEcXpOtTXu5AfSSQEDV7JQegLEqLsGF07pwWuXdEgWlWRiPNwqlP74YBSrxl3NDE2RbIqMdKw20zSTijjKmDs9BUgLkEst76uoVGAVWaRG7kjGoqNk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dD5eyPmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dD5eyPmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985FDC4CEE2;
	Wed, 26 Mar 2025 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743007258;
	bh=hM/NheaQfuMoUdlsLtDq8WZibH5SuiaaMLLZxbfZwXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dD5eyPmHyEw87Gkwx53uoqquw2VYaL5EdXy8WlLo/QDgg6RkAZae7qMsOQ0nJCxrZ
	 H5tMexA7JWBuAhUuDXpsrCLh3G4xeFZvDDAX18bYV77f369m+WmIG8uMyd4QOLMHTU
	 vEFumOABxs0b5+5IJyORkC4Jo0sFFdLezHqdxsTnSNRTt3cJIXE2WiAcBgnHlmToCo
	 3s9wuB0ehB9vjV24bogm299Lbgwv2G/ldSnTbccbMJgaQ4h7VQ0sYaWT5fzgeHWusK
	 GoXz8d42L/EGUJ0u7y77TCz4QY6j6xUXiVtgBLtgACvg3vWZFAYuI8pyPUZ33eMsVi
	 gYi1AqgI2XWFw==
Date: Wed, 26 Mar 2025 09:40:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: dm-devel@lists.linux.dev, eranm@google.com, guoweichao@oppo.com,
	mpatocka@redhat.com, snitzer@kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250326164057.GA1243@sol.localdomain>
References: <20250325174318.GA559858@google.com>
 <6c4f18d8-39f9-4eac-9bb2-d6f0d9c3b376@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4f18d8-39f9-4eac-9bb2-d6f0d9c3b376@oppo.com>

On Wed, Mar 26, 2025 at 10:09:22AM +0800, LongPing Wei wrote:
> Hi, Eric
> 
> > If the CPU has been in softirq context for too long, then stop
> > choosing softirq context and instead fall back to the traditional
> > workqueue.  This could help address objections about increased use of >
> softirq context.
> 
> Could you share me some example about this?
> 

The objection that keeps getting raised to doing more work in softirq context is
that the latency of real-time tasks, such as audio tasks, may increase due to
softirqs having a higher priority than all tasks.  Causing audio skipping, etc.

The logic in handle_softirqs() in kernel/softirq.c actually goes a ways towards
addressing this already: it processes softirqs for at most 2 ms or until
rescheduling of the interrupted task gets requested, before deferring them to
ksoftirqd which runs at normal task priority.

The gaps that I see are (a) 2 ms is longer than desired, and (b) the limit does
not apply to *individual* softirqs.  Looking at (b), observe that the block
softirq (blk_done_softirq()) completes a list of I/O requests.  If there are a
lot of requests in that list, it could theoretically take more than the 2 ms
limit that kernel/softirq.c is meant to enforce (which is already too long).

So the objection would be that, even with dm-verity choosing to do in-line
verification only for 4 KiB requests which take only a few microseconds each, a
lot of requests could still add up to cause a long time to be spent in a single
softirq context.  (At least in theory.  AFAIK no one has confirmed that this is
actually a problem in practice with the 4 KiB limit applied.  But this is the
objection that I keep hearing whenever anyone suggests doing more in softirqs.)

But if dm-verity could detect this case happening and start deferring
verification work to task context, that should mostly address this concern, IMO.

One idea which *might* get us most of the way there pretty easily would be to do
the in-line verification only when need_resched() returns false.

- Eric
