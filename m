Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D93364BA
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717397712; cv=none; b=QzJeJDQ3kUHgxCy6JHUtnRiPgFxG0dmi1+j7Sth9EF7ltI47zswYo/5yTLp4t+FD+isCGI7SqvQ06STKWW9ug9BgPOHu1EIdRPAu5gXeObAoRi+PURUepfDMzy2mwRxYUCu88mizxtniAQvMf1muSTKlGTV8g/lS1fJj3B/SNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717397712; c=relaxed/simple;
	bh=xTKU7i1z9dx+1Mgs2CS+EfXKaONygR3UN6DqI1Gw6jE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ALtNhsX6FyzOtIfDRwazhpxD8s6rmnz0b/OwQdcbUWjWcAvaEY3GQ7TtfY+Rr78vNZy/zriNTlpL9FOqCY9nAaA7U+s/Pq4MgZwcVY2jdekVg+vVdpI8VLZ6gucjXaaX0lZboehFOf+me4sNEZ1iBVwc4zQxmtpi1EL83FwdA4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EA67DNgy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wEBaXEKG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pp0A1rlX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+OAlWfYR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EA67DNgy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wEBaXEKG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pp0A1rlX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+OAlWfYR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4AC3E221EB;
	Mon,  3 Jun 2024 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmCZhfBpcNrULmCovNLPRRHTL9kMqbxGJpPKANiG+B0=;
	b=EA67DNgy0/aZLDAyJxNAznoFBUZR+kL2cJRqS2CSWDwZ7iwvh5aIkbxRN7wKHGYNHTW354
	eCyE0StJ/FRaO9uJQ99UexagZZGSZut55B9ispN0B3s5vrqVvas/3xHHVuc3sP5QDfPBCn
	qR6CxIEGqjPohNXTOM0Vx5KXVj0jUh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmCZhfBpcNrULmCovNLPRRHTL9kMqbxGJpPKANiG+B0=;
	b=wEBaXEKGFT0phPXLESZMK8yqwYtKMuXXw9FB0dx2PVK0RIqZsj8reJV2mgWX1PKWIv0Xwx
	CaxRKiCXabg755Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pp0A1rlX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+OAlWfYR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717397708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmCZhfBpcNrULmCovNLPRRHTL9kMqbxGJpPKANiG+B0=;
	b=pp0A1rlXkOiod02JXUaO8Dftyn7suBOkwKfB3h5iVjeGYL34ulif/HGJhAxVjyusL6dTPw
	UWbmevSvRx3ui+XKiIrncA949Hjy+ojsQ+2ZUb4xwdVVk9LIKajPu52rOhyvHmVZr5UsHX
	irVRZyBjEpjNyKf3LFoEVbJ63T+lJ5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717397708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmCZhfBpcNrULmCovNLPRRHTL9kMqbxGJpPKANiG+B0=;
	b=+OAlWfYRRCJkTnZeVnKhLXZlC61qUKXUltTUZoDI6dyUDLecr17zxeiH1scdX5tVVXg5Kt
	hjAK5kVbBo9DyBDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8A8013A93;
	Mon,  3 Jun 2024 06:55:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qJckN8toXWZwTwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 03 Jun 2024 06:55:07 +0000
Message-ID: <14d4323b-db5c-42ee-8e20-d968747eb449@suse.de>
Date: Mon, 3 Jun 2024 08:55:07 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] block: Fix validation of zoned device with a runt
 zone
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-3-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240530054035.491497-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4AC3E221EB
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email]

On 5/30/24 07:40, Damien Le Moal wrote:
> Commit ecfe43b11b02 ("block: Remember zone capacity when revalidating
> zones") introduced checks to ensure that the capacity of the zones of
> a zoned device is constant for all zones. However, this check ignores
> the possibility that a zoned device has a smaller last zone with a size
> not equal to the capacity of other zones. Such device correspond in
> practice to an SMR drive with a smaller last zone and all zones with a
> capacity equal to the zone size, leading to the last zone capacity being
> different than the capacity of other zones.
> 
> Correctly handle such device by fixing the check for the constant zone
> capacity in blk_revalidate_seq_zone() using the new helper function
> disk_zone_is_last(). This helper function is also used in
> blk_revalidate_zone_cb() when checking the zone size.
> 
> Fixes: ecfe43b11b02 ("block: Remember zone capacity when revalidating zones")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

