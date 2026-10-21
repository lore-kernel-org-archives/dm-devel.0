Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575151;
	b=EVqzOkm4U3NZOa6e2/myshtS6YsGRfcwl7CvdFdblN4SkXrFUkTMCHp5dKuPHZjjjeOp
	 S1UWr0q5tJ2grgcg4YR6ALzUZxvj0HAeXU1X1yrF1paplUxIj6FxVO0w1jhLbX5bk72Yh
	 6qO79BD1aIPOFxpXvUbCEGG0uhnXZBob3KCG0N2Ny+Vt710dR/LZs9ds7t08MVSnqtHMM
	 +f+4/5cc+wGSi3B10UPGlsQg4kajuTSgPICnAD0XsL7JuctHLK1g92uMIDBA0kKy0j7xi
	 GQ0GG3+nC9JvxQ+CHIjJQntpQMST2fUlalhV6zwVFWpd3AEkRC/VXan7OpawrupzzEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575151;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server;
	bh=AZY0SdXNkTTC2afHQv6zkLHauHeQHgV0pUcff6Mv0ik=;
	b=glssHaTpeQLbfUYdjvAG7P9cDHo0vG9AJQWhgcg7vVhzlPiYmTKl0JFMSkneQLemesTv
	 zIf1O4O+o5LMdisD6iQo5iIED9wIchxmG2gLggsVRiIGxr7W2NDpj7KmrMKLhtKvMIV82
	 +w7pbdw7Sf4JqrjcxAIDhzenlvb+Vh3jy9PvshbRRZZwAYK+9jdkfWRBc/UBn+fA1GR6H
	 arKs/t2rleqFBNPiNQjobYVN9MAhXVXBmkNS6SVA1egc5fQLohV0QbJWmZxHssIUEdX6o
	 5SX3LW6jmDv6TwNk3SLRzZchTv/J32D2kgb/YhyzDpeCkuWXctjQryheoOF6UiGaApg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DvR+1Pse;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvtQw2rm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DvR+1Pse;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvtQw2rm;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48266606A31D
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 09:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48266606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DvR+1Pse;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvtQw2rm;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DvR+1Pse;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OvtQw2rm
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6448A1F451;
	Wed, 21 Oct 2026 09:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZY0SdXNkTTC2afHQv6zkLHauHeQHgV0pUcff6Mv0ik=;
	b=DvR+1PsebT9m7Ap6OnEa4BHoxUvgFArBVDit+ITICTiRWn10Q9jEFm0XCeJPVQfgF63xWE
	U1aZRNnBVl2GikDDIpRZ5EV+wKBouuneXciyGsfaMtA/yRyRKb9QF2Nc6LJs7xCLoVNPQO
	JlIM9dRWa98gPrlENxzn7x64Gdtg1S0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZY0SdXNkTTC2afHQv6zkLHauHeQHgV0pUcff6Mv0ik=;
	b=OvtQw2rmMjURRirrko5Co6CPqzcarD6WZpdcg6n+pzGF33Yz7Ftgg1dd97iOY+C4sOPn3v
	3PPTmrCIYra36kCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DvR+1Pse;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OvtQw2rm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZY0SdXNkTTC2afHQv6zkLHauHeQHgV0pUcff6Mv0ik=;
	b=DvR+1PsebT9m7Ap6OnEa4BHoxUvgFArBVDit+ITICTiRWn10Q9jEFm0XCeJPVQfgF63xWE
	U1aZRNnBVl2GikDDIpRZ5EV+wKBouuneXciyGsfaMtA/yRyRKb9QF2Nc6LJs7xCLoVNPQO
	JlIM9dRWa98gPrlENxzn7x64Gdtg1S0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZY0SdXNkTTC2afHQv6zkLHauHeQHgV0pUcff6Mv0ik=;
	b=OvtQw2rmMjURRirrko5Co6CPqzcarD6WZpdcg6n+pzGF33Yz7Ftgg1dd97iOY+C4sOPn3v
	3PPTmrCIYra36kCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C40D134A5;
	Wed, 21 Oct 2026 09:32:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o3cXAqyG2GoUGAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:32:28 +0000
Message-ID: <ebb71b2a-f4a4-437b-918a-8be94d41b17f@suse.de>
Date: Wed, 21 Oct 2026 11:32:27 +0200
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] dm zoned: keep polling for idle reclaim after a
 reclaim pass
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-4-illofspeed@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261011175450.952-4-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 6448A1F451
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/11/26 7:54 PM, Kyrylo Biryuk wrote:
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
>   drivers/md/dm-zoned-reclaim.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 88d56d3c86d..5084e10ea7e 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -556,7 +556,16 @@ static void dmz_reclaim_work(struct work_struct *work)
>   		}
>   	}
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
>   }
>   
>   /*

You could simply reschedule here
(ie call 'mod_delayed_work(zrc->wq, &zrc->work, 0)' directly),
as the second branch of the condition will be exercised at the
start of the function anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
