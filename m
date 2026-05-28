Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A233B0AE7
	for <dm-devel@lists.linux.dev>; Thu, 28 May 2026 09:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961246; cv=none; b=fbDmVM3fjxOanN4tFYn4J01Epy86xqpsvCzaoSRq9pXI27Osfp8hVvWTIQcWW2s7fza2RN86k7WCLJlHCu17dvzwy9btr4Oe9hc4barbTJJPe1t5kF0UZBvjMUWO60cDh50gE0OhAM/AX59bpIKXI/Lk200FKssd2/EOy9+VUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961246; c=relaxed/simple;
	bh=LRvnskXB+X4BNB2GiegUwlhjWPxgdl0B8lBtUdPNrpI=;
	h=To:Message-Id:In-Reply-To:Subject:Date:From:Mime-Version:
	 Content-Type:References; b=mw5/1JwkmyRMh/Nun8ki8MWCarzIh0Bp7EUl3RSMXN1uQXlQISo5K7jeqyW6j9E900MrNWZ8Bi0xYfFGfRvXIzXWiQhOXJ+L8qdcEcFxrF2k529NDdY+GbOzlVNmxmXtrPMhVvnZWsno1aEJ9Q3XADu9GjBO09TzdrZCKDzzAqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=f6IxMZyJ; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="f6IxMZyJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779961233; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9UT7WvwB/rb2gYlyJ1CXeSOfyjr4rrczbHdlA5RdR2A=;
 b=f6IxMZyJFp+c9JbV6nalgsACa6ywTK60XWPTxYLcMacoimGMeTIISNsa6pSfDOPqgTE54M
 TdB2SnZ0K+1jJhrnThGSyguFd9EsTJ6tiaoQ5ClZ2r2RD0a2GyMK1FMcRBmpOnn56HNXI+
 piX31e+ubuiutRVqmvb8/My4Y/CzbHAft8Km6WVyEbelb0Xj8jFKN3ubLHHEZMH/WcY2GZ
 7mylA30fNLUObt/AReD16dMJ36Yc9RdHwdS1cgoqlvjhHqXaVFlbAZTOI/PSBLnRLxdT+A
 SbdknhZ4DswVyHaY0bs2Ca6PZF5BUT2nbZrJKh39t6rGS+Rk2tc65O4A7q3beA==
X-Lms-Return-Path: <lba+26a180d8f+3b7365+lists.linux.dev+changfengnan@bytedance.com>
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <bmarzins@redhat.com>, 
	<dm-devel@lists.linux.dev>
Message-Id: <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
X-Original-From: Fengnan <changfengnan@bytedance.com>
In-Reply-To: <20260513091349.2194-1-changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
Date: Thu, 28 May 2026 17:40:11 +0800
From: "Fengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
References: <20260513091349.2194-1-changfengnan@bytedance.com>

ping..


=E5=9C=A8 2026/5/13 17:13, Fengnan Chang =E5=86=99=E9=81=93:
> dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> The caller only knows about the dm queue, so it may decide to do a
> spinning poll if it thinks a single queue is being polled. Passing those
> flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> queue from inside dm_poll_bio().
>
> With io_uring IOPOLL on a dm-stripe target this can keep a task in
>
>    dm_poll_bio() -> bio_poll() -> blk_mq_poll()
>
> long enough to trigger an RCU CPU stall, before io_uring gets back to
> io_iopoll_check() and its need_resched() check.
>
> Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> bios. The caller can invoke dm_poll_bio() again if it wants to keep
> polling, and it also gets a chance to reap completions or reschedule
> between passes.
>
> Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll(=
)")
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>   drivers/md/dm.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e178fe19973ea..8f44fbbcf3da2 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct=
 io_comp_batch *iob,
>   	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
>  =20
>   	/* don't poll if the mapped io is done */
> -	if (atomic_read(&io->io_count) > 1)
> -		bio_poll(&io->tio.clone, iob, flags);
> +	if (atomic_read(&io->io_count) > 1) {
> +		/*
> +		 * DM hides the target queues from the upper poller, which may
> +		 * decide it is safe to spin on a single stacked queue.  Do not
> +		 * pass that spinning policy down to a target queue: one slow
> +		 * clone could keep the task inside dm_poll_bio() for a long
> +		 * time.  Poll target bios once and let the caller decide
> +		 * whether to keep polling, reap completions or reschedule.
> +		 */
> +		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
> +	}
>  =20
>   	/* bio_poll holds the last reference */
>   	return atomic_read(&io->io_count) =3D=3D 1;
