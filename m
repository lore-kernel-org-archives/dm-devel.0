Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAA42EEE93;
	Sun, 11 Oct 2026 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729114; cv=none; b=hFCO2EPoCfFf7rvIQO4bs98d/Wy2qfU0s6SXthUIZmu/5e1XC52vyCmqVqH+bN+qbhoLpuOPliIUiwdFEYihG23V1aoNLWKTDbQhR5yCpKRnAmquIyvKbkmgsWRCraGSgJWeBpjySYR4AU2PhlL7kgTEg2502pvzWh7OIKZujo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729114; c=relaxed/simple;
	bh=Ph6twiIvkvn+imM1XrEaPZhwKnOrD7fUglQifhXXC1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jJOKNS3ylsfAMLf/kvnS/KR4w9gYXmMxogteGsF57HZzccrS31Uu3mk9UUZk4LC6aqnMW4SGm0YKcwUIDQ26wZmpWkJY8ZmUhoHSlGG6sFsnjw6DrBmeQ7ckHEC5cl+/g0pl/LtRwfqdZuODDSEYZOKX8XTWXTVYXeOu/+XZ+RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiMY5eAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiMY5eAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3581F0089B;
	Sun, 11 Oct 2026 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791729113;
	bh=DZVHVJHlI8o+4wzeefk7dOA15aCbLnz24zIHRhQGHxA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EiMY5eAevzmxofRc7SYY0p9vbeXO4zPEnpFcW4sNuVMko22SJhIvYug8bczVDpd5n
	 QPTWamCKdQ3Z5/8MeakkkypFzBtjWB9GQKVfx3Kkmmh+q0wrUo/gvBboDvEV4x/dVf
	 iRlrEMLvWPkHXCgel3HkA6rqeUY5gY81Ob8Gg+0q8JGtTN00CXzwa4jxOqVVZoAbEK
	 +En4UX1FvPZaQOGByJquIJqka/6AW+mvJhlpqrLj9AmwmxjRdM8DyBlPW7xcvZcP3Q
	 w+gG+XBuAYvUiqAbWNj79ZNHa2BYT03MaVjh+5yJobjWFLzOOnZgIevmtduzSv18dH
	 obSDN3iZgzPKg==
Message-ID: <bfbbb428-5a4e-4b61-8fe0-fd0c6c506c64@kernel.org>
Date: Sun, 11 Oct 2026 16:31:50 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] dm zoned: keep polling for idle reclaim after a
 reclaim pass
To: illofspeed <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261010161613.396-1-illofspeed@gmail.com>
 <20261010161613.396-4-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261010161613.396-4-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/10 18:16, illofspeed wrote:
> dmz_reclaim_work() re-arms its DMZ_IDLE_PERIOD poll only when
> dmz_should_reclaim() returns false at the start of a pass. After a pass
> it calls dmz_schedule_reclaim(), which queues the work only if reclaim
> is needed right now. When a pass ends while the target is still busy and
> has enough free zones, nothing is queued at all. Once the target goes
> idle, nothing re-evaluates dmz_should_reclaim() until new I/O arrives or
> user space sends a "reclaim" message, so the random or cache zones that
> filled up under load stay full.
> 
> Seen on md RAID5 members on 27 TB host-managed drives: after heavy
> writes the random zones stayed full for hours on idle targets; the
> workaround was a timer sending "dmsetup message <dev> 0 reclaim". With
> this patch the emptied and filled zones were reclaimed within minutes of
> the targets going idle, without the timer.
> 
> After a pass, requeue the work immediately if reclaim is still needed,
> otherwise re-arm the idle poll.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Assisted-by: LLM
> Signed-off-by: illofspeed <illofspeed@gmail.com>

Patch looks OK to me, but same comment as patch 1 about your SoB name. Please
confirm.

> ---
>  drivers/md/dm-zoned-reclaim.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 2bcc163d209..7feb2628bd0 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -557,7 +557,16 @@ static void dmz_reclaim_work(struct work_struct *work)
>  		}
>  	}
>  
> -	dmz_schedule_reclaim(zrc);
> +	/*
> +	 * Keep the worker alive: when a pass ends while the target is busy
> +	 * with enough free zones, dmz_schedule_reclaim() queues nothing and
> +	 * the idle poll is never re-armed, so zones filled under load are not
> +	 * reclaimed once the target goes idle.
> +	 */
> +	if (dmz_should_reclaim(zrc, dmz_reclaim_percentage(zrc)))
> +		mod_delayed_work(zrc->wq, &zrc->work, 0);
> +	else
> +		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
>  }
>  
>  /*


-- 
Damien Le Moal
Western Digital Research
