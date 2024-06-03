Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C7C3770D
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 06:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397768; cv=none; b=jHQj2ySvjZ7tC54D2jAhz0NE05jiZPLGRI2HYI8MFh+F03PloT+/+iHvVUo/mr9mGODB6xcp/R4/uiPhX4QuVZbnUYBhStGEOeFKKObKAhUS0EqRYwm6Wzj+pWKkfZN8vxvOxszd5BFdR2KX6qflIrDWgeAlCQbFiFJKKF12W0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397768; c=relaxed/simple;
	bh=KIGvY+MbRJ3nLX178YKdWtSSaicFBJJNy2pNsGh14X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DUvQ6r1NkvkrARW/TZQyJmWu0THejwDn+qEnzLpukGEkoWDcwJdwj5ysqZKiMrGjgvU574l/vdojaJ3nsZzrd61wXyM+j1YKpUpnw5wk1WwSi8X3cbE9VP4E823JSHLaY0n5Jlqqvk0SRZymLPIb77P0+jxI0ePEoIT2fOaQs+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C+GaNuKC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VNYamgWA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=C+GaNuKC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VNYamgWA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C+GaNuKC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VNYamgWA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="C+GaNuKC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VNYamgWA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A159F2001C;
	Mon,  3 Jun 2024 06:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2zDzUA0s0A1+g4eE+GY7AnTC33a//9vU+8BF/BdvRM=;
	b=C+GaNuKCYr1lv6hX2NyKNBzhfAeiq3cwp4qmalxWgMZmR1VybGA0Xvc4mOpk7k7EjI3q+q
	ONP4+y08OWNqW1P408aNrATfNDvzqtFQd6qMsLGahRGsl9YW2t9WaG+ySIPPjDs3H6gZea
	rmAPvNyOR3lDRRwPgM0+Mf8M1n2yRaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2zDzUA0s0A1+g4eE+GY7AnTC33a//9vU+8BF/BdvRM=;
	b=VNYamgWAk+K01cY+cQ1PoiurOGGf9CrUQ199urQJjB+xcajK4/4WFuy3LD88zu0hxRvflY
	RPJa+nG5MA2GjhCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2zDzUA0s0A1+g4eE+GY7AnTC33a//9vU+8BF/BdvRM=;
	b=C+GaNuKCYr1lv6hX2NyKNBzhfAeiq3cwp4qmalxWgMZmR1VybGA0Xvc4mOpk7k7EjI3q+q
	ONP4+y08OWNqW1P408aNrATfNDvzqtFQd6qMsLGahRGsl9YW2t9WaG+ySIPPjDs3H6gZea
	rmAPvNyOR3lDRRwPgM0+Mf8M1n2yRaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2zDzUA0s0A1+g4eE+GY7AnTC33a//9vU+8BF/BdvRM=;
	b=VNYamgWAk+K01cY+cQ1PoiurOGGf9CrUQ199urQJjB+xcajK4/4WFuy3LD88zu0hxRvflY
	RPJa+nG5MA2GjhCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 422F813A93;
	Mon,  3 Jun 2024 06:56:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QMiTCQNpXWZwTwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 06:56:03 +0000
Message-ID: <3bc0736b-726f-4506-bc02-65de3ebf2222@suse.de>
Date: Mon, 3 Jun 2024 08:56:03 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530054035.491497-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]

On 5/30/24 07:40, Damien Le Moal wrote:
> A zoned device may have a last sequential write required zone that is
> smaller than other zones. However, all tests to check if a zone write
> plug write offset exceeds the zone capacity use the same capacity
> value stored in the gendisk zone_capacity field. This is incorrect for a
> zoned device with a last runt (smaller) zone.
> 
> Add the new field last_zone_capacity to struct gendisk to store the
> capacity of the last zone of the device. blk_revalidate_seq_zone() and
> blk_revalidate_conv_zone() are both modified to get this value when
> disk_zone_is_last() returns true. Similarly to zone_capacity, the value
> is first stored using the last_zone_capacity field of struct
> blk_revalidate_zone_args. Once zone revalidation of all zones is done,
> this is used to set the gendisk last_zone_capacity field.
> 
> The checks to determine if a zone is full or if a sector offset in a
> zone exceeds the zone capacity in disk_should_remove_zone_wplug(),
> disk_zone_wplug_abort_unaligned(), blk_zone_write_plug_init_request(),
> and blk_zone_wplug_prepare_bio() are modified to use the new helper
> functions disk_zone_is_full() and disk_zone_wplug_is_full().
> disk_zone_is_full() uses the zone index to determine if the zone being
> tested is the last one of the disk and uses the either the disk
> zone_capacity or last_zone_capacity accordingly.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c      | 35 +++++++++++++++++++++++++++--------
>   include/linux/blkdev.h |  1 +
>   2 files changed, 28 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

