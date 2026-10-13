Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54C42853F3
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791875756; cv=none; b=OcCvRiij92OveaR+LH5NrPqIFjTg24j+mW7RaSidwKRE8dAkkVUbfol8HQFMbdBJIWa1OMk+uKMc2YjVNU9RFTvEGtV3n9bSfkqIE5FOJWXlyLYHcZyWWfP4r9XpXqfttG2OinGgYfLP0vIS9MYdtulW9TDoizqrbizt0VYLkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791875756; c=relaxed/simple;
	bh=L4FLZ5chqT8+tAXrT8MgCJFwGMuDBbUdjlAqAI1q+cU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M/K844viq282lz6DzTB/GRFO8MvAwz5BFMPBIMiLc0vCFQ7YFaLhJy9aTM584jq9W/jh5Oa32X/+AY6xSNe4p2/8finYnrVgro7sUkMKiei4VlU6O0kDQnHQKJNiScaF/XzZuXLUUTfbUeQBOTxnW+I2dMFHEkQZR7SG0kgQ1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tGgUV+Lm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=s2QFJeAc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QwYmIcNC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z03WxFNC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tGgUV+Lm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="s2QFJeAc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QwYmIcNC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z03WxFNC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A54F01F43B;
	Tue, 13 Oct 2026 07:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791875752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjVfiQP7AeHd0++T5S99eU8Nj5puoVDS7wlkNXdkKP4=;
	b=tGgUV+LmqA/1tFWJataIQA0n+MRpTGj6V5TVnOMJ7I7+DqF/mZRH/AYe6O+euzo3Ie9XGS
	W5PupmwLQAJwjG6YYNXWuLrLbQmDjWp86MymIuJvzxV3Ag9H9ZAlD7uT7sTVK4dDLHZlxX
	43DYKNzfYwCoSKppKBmHiZ735P6MTEw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791875752;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjVfiQP7AeHd0++T5S99eU8Nj5puoVDS7wlkNXdkKP4=;
	b=s2QFJeAcWWBVhLKJcVqHHO5uR6vc85W88SpcVzv0lhoyPrSrvMvsR9yPe0/i21/qhG4pFa
	SIwNTelHGEjT0nCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QwYmIcNC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z03WxFNC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791875750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjVfiQP7AeHd0++T5S99eU8Nj5puoVDS7wlkNXdkKP4=;
	b=QwYmIcNCrRntS8ZzFT1/xOLBE6ED9WamNCyRrGEdPcY33lYxtS2avvRzj8Aul7GPGK6FID
	2+wXBUPGOul/fHhAjR8te464Mpa58Xt3nPnmWDtRxU6O/22C/AyV6NYwycBXcp+ZGa4kcw
	v9gHzSVO6WX0mhg5L2MfTvwvAQzqtbU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791875750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SjVfiQP7AeHd0++T5S99eU8Nj5puoVDS7wlkNXdkKP4=;
	b=z03WxFNCBGSoMVBpmWGylOgMGSsxfQXE8by+zjdVac7oUYn5kMzycPORWdMJJ1iH8FHQb/
	YsemZEUanv6Gk0Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 403421349D;
	Tue, 13 Oct 2026 07:15:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zpiHMKXazWpNUwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 13 Oct 2026 07:15:50 +0000
Message-ID: <b2a6b9f6-53a8-4250-aae6-a0837f0f598d@suse.de>
Date: Tue, 13 Oct 2026 09:15:33 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] dm zoned: back off when reclaim finds no destination
 zone
To: illofspeed <volvo.mail@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20261010105122.398-1-volvo.mail@gmail.com>
 <20261010105122.398-2-volvo.mail@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261010105122.398-2-volvo.mail@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.00
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim]
X-Spam-Level: 
X-Rspamd-Queue-Id: A54F01F43B
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/10/26 12:51 PM, illofspeed wrote:
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
> Signed-off-by: illofspeed <volvo.mail@gmail.com>
> ---
>   drivers/md/dm-zoned-reclaim.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index c041413c729..315f0da99f3 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
>   	if (ret && ret != -EINTR) {
>   		if (!dmz_check_dev(zmd))
>   			return;
> +		if (ret == -ENOSPC) {
> +			/*
> +			 * No zone to copy into: nothing can progress now.
> +			 * Rescheduling immediately would spin; poll instead.
> +			 */
> +			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> +			return;
> +		}
>   	}
>   
>   	dmz_schedule_reclaim(zrc);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
