Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792574810;
	b=kafTZNQduoWQSTQzOqwsQJA8bTtq6EkzQH771Un0/zcdyeToysGfoxfL5NzD6sQ0Q5tj
	 YAJ/5yubUwjvx4ztBNbPHSr0y3HCCMcl7uapdF6sQ5EIBVfkTEaft4f9DK/LG74UCdkx0
	 6PfNbtCoGtuIBpdrE670mvtVCvRKUqYttgVfjV7AyuH4UcclczgQqiq+IYpD3IJsi7HrK
	 2aYLNMq8PN2dt8mQmuenrg/sG6D+HfSn5SnNvjuGmDGFj2cv4mxZAbQLH6Tii8gSG/vXt
	 4VMYd/PznpNgs1d2V8JLS0tfBlsISfxybnQaWG5nJaaS8gfFMHNjsh/nObi5gmPzkQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792574810;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=feZx8A3LJLDItS8+5mlB1uDh0Mh7qq5T9i8a38X1/4g=;
	b=aVAzKa6PINVrE9OvQFXGv3fNS4mj9qWgHHQmfVcW/Otc0v0roB32whnjesFMto5ve1tp
	 zpohA35oFGL4K35neWPgiGcV3s8NzvEHmR1i2Vegz7uelDQbMpVWs6SIGTYVpgK/sAb/i
	 JwWl9VQVOXaS4RAyfCuFGFuIbSgevurT4+OidbXI2wyaG+JIxYJZt4trYhojyZ15kkpsh
	 +gyQhSOAX37xMCQCBhR88ndQdbkE7POqdoONirtYkaoIH7eCGsb/r21rbtit1FCnxLUji
	 k5V62LJ/n/HQSx8Ri77MAcj3A0Pw+KuQyLZIEaZVMfzM1U3R39CVvda4Aslal1kwE1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Blm12+0T;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eH4VstLm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Blm12+0T;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eH4VstLm;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE4606A31D
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 09:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CFE4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Blm12+0T;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eH4VstLm;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Blm12+0T;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eH4VstLm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 56A431F457;
	Wed, 21 Oct 2026 09:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792574808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feZx8A3LJLDItS8+5mlB1uDh0Mh7qq5T9i8a38X1/4g=;
	b=Blm12+0Ti/8Ikob40bbbGk7eZi4neefooN0ZmPaCexhzz+8sbuAiphAigkbmQvQBN6ShrA
	pLxvMAnr1ntxAOoDo1kUyQD5pj6MA7nk4bVUgnX0tliRkqgrxW1gxihLGQKVJ8OIU+2dwf
	TsFeK7qRXBxNkWu6bGAtoDBeHSIUpmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792574808;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feZx8A3LJLDItS8+5mlB1uDh0Mh7qq5T9i8a38X1/4g=;
	b=eH4VstLmSaQLPV92wza1b9QRgPUh5bTeyKb+dR3KUZ0XRIGlaEgQ3+u70AgOnznvbvU0q0
	VZTrBdWrOCDjp0DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792574808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feZx8A3LJLDItS8+5mlB1uDh0Mh7qq5T9i8a38X1/4g=;
	b=Blm12+0Ti/8Ikob40bbbGk7eZi4neefooN0ZmPaCexhzz+8sbuAiphAigkbmQvQBN6ShrA
	pLxvMAnr1ntxAOoDo1kUyQD5pj6MA7nk4bVUgnX0tliRkqgrxW1gxihLGQKVJ8OIU+2dwf
	TsFeK7qRXBxNkWu6bGAtoDBeHSIUpmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792574808;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feZx8A3LJLDItS8+5mlB1uDh0Mh7qq5T9i8a38X1/4g=;
	b=eH4VstLmSaQLPV92wza1b9QRgPUh5bTeyKb+dR3KUZ0XRIGlaEgQ3+u70AgOnznvbvU0q0
	VZTrBdWrOCDjp0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AE88134A5;
	Wed, 21 Oct 2026 09:26:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Th/GMleF2GorEgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:26:47 +0000
Message-ID: <22f965be-ed14-4e70-a332-46c092898eea@suse.de>
Date: Wed, 21 Oct 2026 11:26:47 +0200
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
Subject: Re: [PATCH v3 2/3] dm zoned: do not reclaim a random zone into
 another random zone
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-3-illofspeed@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261011175450.952-3-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/11/26 7:54 PM, Kyrylo Biryuk wrote:
> dmz_reclaim_rnd_data() falls back to a random destination zone when no
> free sequential zone is available and the target has cache zones. When
> the target is idle and the cache zone list is empty,
> dmz_get_rnd_zone_for_reclaim() selects random zones of the zoned device
> as well, so a random zone is then copied into another random zone. That
> frees nothing: the next pass picks the next random zone and copies it
> again, for as long as the target stays idle.
> 
> Seen on a two-device target (256 GiB regular cache device plus a 27 TB
> host-managed drive) used as an md RAID5 member: after a full rebuild
> every chunk was mapped and no sequential zone was free, and the idle
> drive read and wrote about 72 MB/s each without pause for hours while
> the free zone counters in "dmsetup status" did not change. Reproduced on
> emulated host-managed drives (tcmu-runner ZBC handler): 340 MB/s of
> copying on an idle target, 0 MB/s with this patch.
> 
> Only switch to a random destination zone when the zone being reclaimed
> is a cache zone: moving it to the zoned device still frees cache space.
> 
> Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
> ---
>   drivers/md/dm-zoned-reclaim.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 315f0da99f3..88d56d3c86d 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -288,7 +288,13 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>   again:
>   	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
>   			       alloc_flags | DMZ_ALLOC_RECLAIM);
> -	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
> +	/*
> +	 * If no free sequential zone is available, a cache zone can still be
> +	 * moved into a free random zone of the zoned device, which frees cache
> +	 * space. Do not do this for a random zone: moving it into another
> +	 * random zone frees nothing and, on an idle target, repeats forever.
> +	 */
> +	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_is_cache(dzone)) {
>   		alloc_flags = DMZ_ALLOC_RND;
>   		goto again;
>   	}

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
