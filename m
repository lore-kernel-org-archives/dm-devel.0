Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA022457E70;
	Sun, 11 Oct 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791728684; cv=none; b=tywuXBCOBPQFkLuKWynyBliPlLKsnAyqIrV619zxtkOZQ0Zma8GQXi37kIST796G2gytXBUc94l23ULLWgqY6OFF9XXEUXA2hMzdkehS+jLpPBc7vzJUdEmM3+lbWwMinL6REnQ4M+wKxWzCDhr190gUiihs7lDHEjm0EPYUiuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791728684; c=relaxed/simple;
	bh=7OuPkA05lxWAWmslGV/kGo2Lx+rWwjRRkTYxusK2sAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KWfnkYxylrLPeKDBManxRoZJr8ygd5dEYhuvLeM4v1ibQ6k8K8FAzE+nB2TPaa0HyQW03RYrWMZQbWY+VqnQCxeTAh0kFsixndr9xLAd7DFEoPZqBxDUQRHd+4CFBkoyz0fMcpuhdSZzZng0Qy0gSzROn+juhdzo8MP6VHdpWFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BbSWmR3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbSWmR3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90641F0089B;
	Sun, 11 Oct 2026 14:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791728683;
	bh=+SdkMP0w2cZlGgfO55P1ngr5T49211PQ3wMbwRxd+GQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BbSWmR3JkgGo8ATLKb37Xzrxw6N8O5ioRCImF6/grZMZ53SAVDnptjg+exQoI6+uO
	 jc5vr6xsyeBJc0Z78G3iYeppaF7FenX152Sa7wLMdD3lTJfmPS82OvKkXkYcwRLVtM
	 K6mfe2UMLzTuRfAlQmqHcQ1H5cJZbsqPHjrA7erLTw56A/u6+ae+Ym0V9+Sj6as3Q5
	 wl9angf3PxDJUSo77umx5DreXNXJbFUjg2ey2xqxI5z9pJEhLpuC4haFOwBtljt/lB
	 YWJ8C5G34ojgJcxkXQGJSYWTi9cZefHjV/OE2u3SKqJxxauaBHoDVWzbg628OYsVQv
	 Ed6qdVRNKeH3Q==
Message-ID: <8d1ee370-2785-438d-9c5b-8363584a23aa@kernel.org>
Date: Sun, 11 Oct 2026 16:24:40 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] dm zoned: back off when reclaim finds no
 destination zone
To: illofspeed <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261010161613.396-1-illofspeed@gmail.com>
 <20261010161613.396-2-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261010161613.396-2-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/10 18:16, illofspeed wrote:
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
> Signed-off-by: illofspeed <illofspeed@gmail.com>

Patch looks OK, but is "ilofspeed" your full name?

> ---
>  drivers/md/dm-zoned-reclaim.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index c041413c729..315f0da99f3 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
>  	if (ret && ret != -EINTR) {
>  		if (!dmz_check_dev(zmd))
>  			return;
> +		if (ret == -ENOSPC) {
> +			/*
> +			 * No zone to copy into: nothing can progress now.
> +			 * Rescheduling immediately would spin; poll instead.
> +			 */
> +			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> +			return;
> +		}
>  	}
>  
>  	dmz_schedule_reclaim(zrc);


-- 
Damien Le Moal
Western Digital Research
