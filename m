Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50DC3B781
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 06:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397638; cv=none; b=LNgJ/Rqc2oPwzZ0Cf7XyxgeUVe6TcGUeAXOOCDL0Yi6NKIGOw5BBGKsE3FsZASX0upDfbHDAXp01KcaxOHIV1BMzw0VyicAAlgI59zknIJUQI89R76n2BR1CXdOBTQlxbNbJqecYPbcmtFN7iUwou7fOxgtoH42gTTqpRaEVyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397638; c=relaxed/simple;
	bh=nKUuWSWPs2vNKFmW3QDUB28ySS7E9tkeOYd+S0FF6GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XJ1y5w1f8Csxh5jJh4T72KgFEhs0mwT3rIhADlUPJcy8tvjZ66pXtbmfw0Y2g9yXFGt6llabQIwiICeuq49ot20zDlzyQc0BqdBC6AehDqGpizamqKCnOb4ufU9xZi/i2bFU44nKSt0HAv4Vyb8NukhD8pPshIAufGD/HwEVpTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Tm823oyu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fn4yqxTE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Tm823oyu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fn4yqxTE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Tm823oyu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fn4yqxTE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Tm823oyu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fn4yqxTE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2E4C52001C;
	Mon,  3 Jun 2024 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYKLYvvb6UXmBQ4gamX4cQTEQs4Y1fNlipcTUwzQbjM=;
	b=Tm823oyuBod5FVApecpKSOeETutgwMwEDG/II6UwPH/MrpWhXfavElWk7g5UUXA322DfA3
	8mbMZCCM1wGTKk8kkdH5b5pRqHR0S5FEwkh09k755DF702W2oUu66cbErr76WLKYvLalxu
	Qw+/zBsPzpJe5exQ9N10VS+2VPVrkfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYKLYvvb6UXmBQ4gamX4cQTEQs4Y1fNlipcTUwzQbjM=;
	b=fn4yqxTEtd1yDbspTODBJfwKFP7GznUFpu6iQOy1x6NtEFgzi79UZScl+WOijPk4xgx37G
	5YALJDASheXiIYDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYKLYvvb6UXmBQ4gamX4cQTEQs4Y1fNlipcTUwzQbjM=;
	b=Tm823oyuBod5FVApecpKSOeETutgwMwEDG/II6UwPH/MrpWhXfavElWk7g5UUXA322DfA3
	8mbMZCCM1wGTKk8kkdH5b5pRqHR0S5FEwkh09k755DF702W2oUu66cbErr76WLKYvLalxu
	Qw+/zBsPzpJe5exQ9N10VS+2VPVrkfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYKLYvvb6UXmBQ4gamX4cQTEQs4Y1fNlipcTUwzQbjM=;
	b=fn4yqxTEtd1yDbspTODBJfwKFP7GznUFpu6iQOy1x6NtEFgzi79UZScl+WOijPk4xgx37G
	5YALJDASheXiIYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1EA413A93;
	Mon,  3 Jun 2024 06:53:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V4FmIIJoXWZwTwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 06:53:54 +0000
Message-ID: <2868ac3f-ba6f-460c-a736-6bf94746608f@suse.de>
Date: Mon, 3 Jun 2024 08:53:54 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] null_blk: Do not allow runt zone with zone capacity
 smaller then zone size
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-2-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530054035.491497-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/30/24 07:40, Damien Le Moal wrote:
> A zoned device with a smaller last zone together with a zone capacity
> smaller than the zone size does make any sense as that does not
                                       ^not
> correspond to any possible setup for a real device:
> 1) For ZNS and zoned UFS devices, all zones are always the same size.
> 2) For SMR HDDs, all zones always have the same capacity.
> In other words, if we have a smaller last runt zone, then this zone
> capacity should always be equal to the zone size.
> 
> Add a check in null_init_zoned_dev() to prevent a configuration to have
> both a smaller zone size and a zone capacity smaller than the zone size.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/null_blk/zoned.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 79c8e5e99f7f..f118d304f310 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -74,6 +74,17 @@ int null_init_zoned_dev(struct nullb_device *dev,
>   		return -EINVAL;
>   	}
>   
> +	/*
> +	 * If a smaller zone capacity was requested, do not allow a smaller last
> +	 * zone at the same time as such zone configuration does not correspond
> +	 * to any real zoned device.
> +	 */
> +	if (dev->zone_capacity != dev->zone_size &&
> +	    dev->size & (dev->zone_size - 1)) {
> +		pr_err("A smaller last zone is not allowed with zone capacity smaller than zone size.\n");
> +		return -EINVAL;
> +	}
> +
>   	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
>   	dev_capacity_sects = mb_to_sects(dev->size);
>   	dev->zone_size_sects = mb_to_sects(dev->zone_size);

Otherwise:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

