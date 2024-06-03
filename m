Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541D83D984
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 06:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397908; cv=none; b=HhVnyCw9ru2M0ETvYWvf0gXPjLVeUriZ4UO01U/cNx7exCrFrksuuZ+NM8DF8wgPEz6cX1OiHYfWUpC4ESeniquZPNQbhe3qrsBJjiUmcDnMxTS2gv70B5TycoU06xBSCAnQ6k45/Fyv7PUi8DRtdUQc7allU+pAu4/D/i7Zc+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397908; c=relaxed/simple;
	bh=/FKSUvGwwW4ooWlosM+oYrDAMphMg2FwPJsG1XQuF44=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VlmwfCDlzWRuAMYWlJFrn6oujSquIt5StsKRqYr/ybJpXvHZOiCRa4P7GIyXNOEe3cTAUT7uJyJ+dAKfZl8hY478vB7/JFg9A7qLUK/Oj6BbWb+IQA1tD+hwRhvT67SJO0AbvAjgd+edNSkTBPhFO81r/W4z3H+px+Rcv5lVBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hCerIpYl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xlazYGvm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hCerIpYl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xlazYGvm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hCerIpYl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xlazYGvm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hCerIpYl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xlazYGvm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 89DD52195A;
	Mon,  3 Jun 2024 06:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKmTPgAOFiTk8ID71kEpx7btVHIC6a9Qho/zarNj5pU=;
	b=hCerIpYl2Mqn+nZU0oiM6r8+eNChZtRa1+6WcdycHBcP0uf6oV5qkAd+rIR/KyXOaujDil
	rwdAumRqTHdo+9qZ4p5Ns5jDrYRAS/WdV+ZIrbul1uM8R7VUWZOyCm9RSf8QnGzrnN0aG7
	ChjkK6SeJCRC/jIcmM+gG44I3ond1Ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKmTPgAOFiTk8ID71kEpx7btVHIC6a9Qho/zarNj5pU=;
	b=xlazYGvm74o5bE6pnaz1xl3j84qcNlbcuUmKj+MxVE9StpAexqwR9z93Tv48V5VTvwP+B2
	oakRl3/pH9y+0zBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hCerIpYl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xlazYGvm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKmTPgAOFiTk8ID71kEpx7btVHIC6a9Qho/zarNj5pU=;
	b=hCerIpYl2Mqn+nZU0oiM6r8+eNChZtRa1+6WcdycHBcP0uf6oV5qkAd+rIR/KyXOaujDil
	rwdAumRqTHdo+9qZ4p5Ns5jDrYRAS/WdV+ZIrbul1uM8R7VUWZOyCm9RSf8QnGzrnN0aG7
	ChjkK6SeJCRC/jIcmM+gG44I3ond1Ww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKmTPgAOFiTk8ID71kEpx7btVHIC6a9Qho/zarNj5pU=;
	b=xlazYGvm74o5bE6pnaz1xl3j84qcNlbcuUmKj+MxVE9StpAexqwR9z93Tv48V5VTvwP+B2
	oakRl3/pH9y+0zBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49B5313A93;
	Mon,  3 Jun 2024 06:58:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3R9FEJBpXWbPUAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 06:58:24 +0000
Message-ID: <864f98a6-6f65-433c-9c53-3b40f4e4a2ee@suse.de>
Date: Mon, 3 Jun 2024 08:58:23 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530054035.491497-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 89DD52195A
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 5/30/24 07:40, Damien Le Moal wrote:
> The generic stacking of limits implemented in the block layer cannot
> correctly handle stacking of zone resource limits (max open zones and
> max active zones) because these limits are for an entire device but the
> stacking may be for a portion of that device (e.g. a dm-linear target
> that does not cover an entire block device). As a result, when DM
> devices are created on top of zoned block devices, the DM device never
> has any zone resource limits advertized, which is only correct if all
> underlying target devices also have no zone resource limits.
> If at least one target device has resource limits, the user may see
> either performance issues (if the max open zone limit of the device is
> exceeded) or write I/O errors if the max active zone limit of one of
> the underlying target devices is exceeded.
> 
> While it is very difficult to correctly and reliably stack zone resource
> limits in general, cases where targets are not sharing zone resources of
> the same device can be dealt with relatively easily. Such situation
> happens when a target maps all sequential zones of a zoned block device:
> for such mapping, other targets mapping other parts of the same zoned
> block device can only contain conventional zones and thus will not
> require any zone resource to correctly handle write operations.
> 
> For a mapped device constructed with such targets, which includes mapped
> devices constructed with targets mapping entire zoned block devices, the
> zone resource limits can be reliably determined using the non-zero
> minimum of the zone resource limits of all targets.
> 
> For mapped devices that include targets partially mapping the set of
> sequential write required zones of zoned block devices, instead of
> advertizing no zone resource limits, it is also better to set the mapped
> device limits to the non-zero minimum of the limits of all targets,
> capped with the number of sequential zones being mapped.
> While still not completely reliable, this allows indicating to the user
> that the underlying devices used have limits.
> 
> This commit improves zone resource limits handling as described above
> using the function dm_set_zone_resource_limits(). This function is
> executed from dm_set_zones_restrictions() and iterates the targets of a
> mapped device to evaluate the max open and max active zone limits. This
> relies on an internal "stacking" of the limits of the target devices
> combined with a direct counting of the number of sequential zones
> mapped by the target.
> 1) For a target mapping an entire zoned block device, the limits are
>     evaluated as the non-zero minimum of the limits of the target device
>     and of the mapped device.
> 2) For a target partially mapping a zoned block device, the number of
>     mapped sequential zones is compared to the total number of sequential
>     zones of the target device to determine the limits: if the target
>     maps all sequential write required zones of the device, then the
>     target can reliably inherit the device limits. Otherwise, the target
>     limits are set to the device limits capped by the number of mapped
>     sequential zones.
> With this evaluation done for each target, the mapped device zone
> resource limits are evaluated as the non-zero minimum of the limits of
> all the targets.
> 
> For configurations resulting in unreliable limits, a warning message is
> issued.
> 
> The counting of mapped sequential zones for the target is done using the
> new function dm_device_count_zones() which performs a report zones on
> the entire block device with the callback dm_device_count_zones_cb().
> This count of mapped sequential zones is used to determine if the mapped
> device contains only conventional zones. This allows simplifying
> dm_set_zones_restrictions() to not do a report zones. For mapped devices
> mapping only conventional zones, dm_set_zone_resource_limits() changes
> the mapped device to a regular device.
> 
> To further cleanup dm_set_zones_restrictions(), the message about the
> type of zone append (native or emulated) is moved inside
> dm_revalidate_zones().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/dm-zone.c | 214 +++++++++++++++++++++++++++++++++++--------
>   1 file changed, 177 insertions(+), 37 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

