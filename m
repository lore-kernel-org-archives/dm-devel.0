Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D241167C;
	Tue, 13 Oct 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903576; cv=none; b=IQc0y6vg6OA4wHUwyJBGYkTTNCLi9IxwSgG98h4ba9NTNOK/22TI8Zv2RFZ1G83b6wPYDOO7ujYwZ03D698X/6QAoKxpX0JzvN1SITtr2qORfr5O9aohxOtXLIxS+qwQsnb4/71OdH74E40gLSaEurpjbWKL+Aqyv7RnCKoh8HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903576; c=relaxed/simple;
	bh=Uk/w9Y/Cej/v4oMGdZu4Ppbtek1/NJcFMnBDO7lLYmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THbwWQMMLaLAN2/Q+prTYeXAwYZnNeGJbv9QOIzBYNGdTnNCtNZdafAU1EZSXeDarY5Ko/flYaGrDnuWGnf96u0hfdKLp3U8j+mtFMsI64VblZBzXTfaU0m2/p7JQn8LqbJi3UZSznqiTcm+9dFv9ijEvG6AmjyT7kwT3o9plvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSinpyNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSinpyNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD01F000FF;
	Tue, 13 Oct 2026 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791903575;
	bh=FBqhqoccxQjBaW9F4lL9i82vm7mnTwRh2qZETKYobj4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jSinpyNIdaH/vmqgS2frtYVq4qOCCR8ETq8ZdRgQkc4YQVj9iPd2uVukzyitqwl8z
	 r83dZ+BBHCpt1DNT72FJ8GcRhYlqrqvc8HJcwBkd0qATiBw5f2w569/nS6yUEu+S50
	 Qd8or9wRFRqk+jZE9PA1HH1dZfjayEDWDhjeiOWpScm1vvG5Jq8lQCbBg/3E9+ODVs
	 B4Rd3JI2iYZe51h7TpWhpqzjfemUjMdJnhJpvOjE2gPmMZyNOi7fBlW9SPfiG6aYTH
	 fDZ+zp+G5+/ht3KwCoQ89GBWTdHTNoifvH6hX/v+GCw8wJ/y95Q1rQF7n83MCh2yJS
	 zdBhiVIPuXEsA==
Message-ID: <bf59b38e-635d-48b8-861f-e50961472e92@kernel.org>
Date: Tue, 13 Oct 2026 16:59:31 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] dm zoned: do not busy-loop idle reclaim when no
 zone needs reclaim
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com, snitzer@kernel.org, agk@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261013145522.17499-1-illofspeed@gmail.com>
 <20261013145522.17499-5-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261013145522.17499-5-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/13 16:55, Kyrylo Biryuk wrote:
> An idle target whose random (and cache) zones are all unmapped keeps its
> reclaim work running without pause:
> 
>   - since commit 90a9b8693f1b ("dm zoned: reclaim random zones when
>     idle"), dmz_should_reclaim() returns true when the target is idle and
>     the total number of random (and cache) zones is non-zero, whether or
>     not any of them holds data;
>   - dmz_do_reclaim() then finds no candidate and returns -EBUSY;
>   - dmz_reclaim_work() runs dmz_check_dev(), which checks every device
>     for media events (a TEST UNIT READY on SCSI disks), and
>     dmz_schedule_reclaim() requeues the work with no delay because
>     dmz_should_reclaim() is still true.
> 
> Without the previous patch, a pass ending while the target is busy and
> has enough free zones can leave reclaim unqueued, which ends the loop;
> keeping the idle poll armed makes it recur whenever the target becomes
> idle. On three 27 TB host-managed drives used
> without cache devices (all random zones free) it kept about three CPUs
> busy and sent about 155,000 TEST UNIT READY commands per second to each
> drive while the target was idle.
> 
> Only reclaim on idle when a random or cache zone actually holds data (the
> intent of the "p_unmap < 100" test that commit replaced), and
> handle -EBUSY like -ENOSPC: nothing can progress and no I/O failed, so
> poll again after the idle period instead of rescheduling at once, and
> skip the device check. Use queue_delayed_work() for that poll so work an
> allocation has already queued is not postponed.
> 
> Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>

This is undoing what patch 1 does. So can you squash this into patch 1 to avoid
the churn?

> ---
>  drivers/md/dm-zoned-reclaim.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index f1f9adf6039..0d62ade1466 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -470,9 +470,10 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
>   */
>  static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
>  {
> -	unsigned int nr_reclaim;
> +	unsigned int nr_reclaim, nr_unmap;
>  
>  	nr_reclaim = dmz_nr_rnd_zones(zrc->metadata, zrc->dev_idx);
> +	nr_unmap = dmz_nr_unmap_rnd_zones(zrc->metadata, zrc->dev_idx);
>  
>  	if (dmz_nr_cache_zones(zrc->metadata)) {
>  		/*
> @@ -483,10 +484,11 @@ static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
>  		if (zrc->dev_idx == 0)
>  			return false;
>  		nr_reclaim += dmz_nr_cache_zones(zrc->metadata);
> +		nr_unmap += dmz_nr_unmap_cache_zones(zrc->metadata);
>  	}
>  
> -	/* Reclaim when idle */
> -	if (dmz_target_idle(zrc) && nr_reclaim)
> +	/* Reclaim when idle, but only if a random or cache zone holds data */
> +	if (dmz_target_idle(zrc) && nr_reclaim > nr_unmap)
>  		return true;
>  
>  	/* If there are still plenty of cache zones, do not reclaim */
> @@ -543,17 +545,19 @@ static void dmz_reclaim_work(struct work_struct *work)
>  		dmz_nr_rnd_zones(zmd, zrc->dev_idx));
>  
>  	ret = dmz_do_reclaim(zrc);
> +	if (ret == -ENOSPC || ret == -EBUSY) {
> +		/*
> +		 * No zone to copy into (-ENOSPC) or no zone to reclaim
> +		 * (-EBUSY): nothing can progress now and no I/O failed.
> +		 * Rescheduling immediately would spin; poll instead, without
> +		 * postponing work that an allocation has already queued.
> +		 */
> +		queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> +		return;
> +	}
>  	if (ret && ret != -EINTR) {
>  		if (!dmz_check_dev(zmd))
>  			return;
> -		if (ret == -ENOSPC) {
> -			/*
> -			 * No zone to copy into: nothing can progress now.
> -			 * Rescheduling immediately would spin; poll instead.
> -			 */
> -			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> -			return;
> -		}
>  	}
>  
>  	dmz_schedule_reclaim(zrc);


-- 
Damien Le Moal
Western Digital Research
