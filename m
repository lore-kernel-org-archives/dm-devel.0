Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB2F43304D;
	Tue, 13 Oct 2026 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884353; cv=none; b=cqq4ngwEFbYopmLq/gLQxsFVt/2FZ6EKk1EIM+BPh37DLZC+t3MP8hr825ruUB9lNbD8eleoIxOilL5jDPyBpZ3QZMCrMNiK2jFYE0RDTsfs8XqyxnUqgLTdvqQfFu1YePDe7Hb287WzeoklY1MjCShkTwtIhYmTUQEsuAmRjEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884353; c=relaxed/simple;
	bh=mTDTH+/8XoH7cAMwhbDfe6CLAL86ksKw2m8E9Lpf6RQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6GNxuSEyJTvwYVptEakg+CXG0x/+I9D1xXR33k3xosrHQqebcaBjzKg0J3rUAe7vadfibmUl/AU1cJcrPLAdQrE5tU7jK34yKWuMirjdDGGpniliUBue0PWS0QHUOowvvZ2V3+b1kwJyjhvmhecFwGbmddvKkGRUB4w2KlRn+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBCA+0wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBCA+0wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBC91F000FF;
	Tue, 13 Oct 2026 09:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791884352;
	bh=KqkUkyq/4czwVshNqTczqjlpaIKuhc2cWHb+11lGCvY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XBCA+0wxPLog3jxBcuPKGhxD30Cy6aKAKaX8cOrJFE+1zr2Agj2L9+1MKXZsthwnD
	 2B9VqKKzNRbN5hjzczjrM88y6z4i1MTdEFiQEdTLyDHCX7oJ+L6SsliZVsed0djgio
	 NU0DBDK4rcoFI1aWj2+T6Uy4aU3fZPxGqJIhlkWap2gW7QBZypvZ/U+H0CEkQASaU6
	 Aq/9QQ0bI7wq/yetp8htMo6gq9RUsekk+zNs9oOHm9KqF6am2SXn3XtPnVAJBU+NvL
	 vBdZk/tRM/sCeJj5ctAqLKyWuluabK5r1TwogiWO4IesAm8k86u0YJbEkjChyBXyjd
	 +aaaBsKXfoCjw==
Message-ID: <fbd4371c-c9eb-4c60-a3e1-670835591e96@kernel.org>
Date: Tue, 13 Oct 2026 11:39:09 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] dm zoned: keep polling for idle reclaim after a
 reclaim pass
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-4-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261011175450.952-4-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/11 19:54, Kyrylo Biryuk wrote:
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
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
> ---
>  drivers/md/dm-zoned-reclaim.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 88d56d3c86d..5084e10ea7e 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -556,7 +556,16 @@ static void dmz_reclaim_work(struct work_struct *work)
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

This looks OK, but why hardcode this here instead of modifying
dmz_schedule_reclaim() to add the "else" case?


>  }
>  
>  /*


-- 
Damien Le Moal
Western Digital Research
