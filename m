Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15E208D7
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714629890; cv=none; b=mHdaj2DLXS+0qR5q5+Okr+uG7JG2tcD1+TJBoZ3D+53I7pHm2ewM41AkTVLcITiff+00KcAlXvYvoZMvyKCKXv789oWwzVuJSat4qzXYmUApm4XJiRXPPBGSpaJXxHk4Hkgnl9HaAtJ+jvEg+wEnJUMxRIp7aDoScvomVRVbYts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714629890; c=relaxed/simple;
	bh=J8ZGnplyDhjHOzjdj5RAmXNXLJt+v85/bEzG7MYvRCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sPxI/Xsu+YPRivlq3OrFCiEqEsQBnui8gI09lBVwNMs6FkqYiR916cvpRQn4iZ5X0qCcq0Twm+JcIUiC4baJ3XNFuQL4mc09PyxjX5u7Xe+oVDjOKs6b7SpDKa6wvFDb8PLijhfS0fWJ6M2GysolDYZLTwVOqlJHWxpzJL0QhCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ofX0hm9l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ry7pFmdD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lMMBHCib; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/u/1A9bz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ofX0hm9l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ry7pFmdD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lMMBHCib";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/u/1A9bz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8D3735000;
	Thu,  2 May 2024 06:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APSIJJlieRuvQrS6MZ8MHrxu6QyRMnXc4gpCxCtjKzo=;
	b=ofX0hm9lnfVChfxcveYkeckvuXn+fz4jyw9X0Ng8KzT9xH1dh/bvWuVCvrTf2pYjUpD/4G
	01eKQUxQ1RxWaPFiNfPQ5Zic7qAUvSXwglgS0qdXZy5QpLfoNSxWhS4XtatNbMcyZU5yxx
	tmKKoBSHgQqZhsmJH8pdfedEXi4YZgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629884;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APSIJJlieRuvQrS6MZ8MHrxu6QyRMnXc4gpCxCtjKzo=;
	b=ry7pFmdD7nwLCnVFPFmUrD7iZxaOjXerPzjZS9VW4PoFBS4pubfoQxAz9aYuMoGrZx5WyO
	G8CsBpG7nY+3fCCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lMMBHCib;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/u/1A9bz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APSIJJlieRuvQrS6MZ8MHrxu6QyRMnXc4gpCxCtjKzo=;
	b=lMMBHCibtojQnz1rbUZLYYUbm7Dm4preirIpAbKeJ+t8zzoh/j/7UIz8qmlOFvnIuOdvkK
	+kw18ftMRg+h5J87lzIWpCwOhvEvH1LwVs7R/CUZ6VRjZ/FrjFT1woqejWBL9ZOel0kCDJ
	+JZYX2phNB8edBuudyDOQP7Ig5CgJXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APSIJJlieRuvQrS6MZ8MHrxu6QyRMnXc4gpCxCtjKzo=;
	b=/u/1A9bz30KDa+Kj4sazcQGS4BURvrHBLCvDS5l8DiLIrhVDNQH95SObox2sgg4bOa2J/O
	4rSKAKjaw8MWN1Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A286913957;
	Thu,  2 May 2024 06:04:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mzr5JfssM2blNAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:04:43 +0000
Message-ID: <6be23b3a-e781-4d33-b0b7-7dd00051f2ce@suse.de>
Date: Thu, 2 May 2024 08:04:42 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/14] block: Hold a reference on zone write plugs to
 schedule submission
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-6-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D8D3735000
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
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/1/24 13:08, Damien Le Moal wrote:
> Since a zone write plug BIO work is a field of struct blk_zone_wplug, we
> must ensure that a zone write plug is never freed when its BIO
> submission work is queued or running. Do this by holding a reference on
> the zone write plug when the submission work is scheduled for execution
> with queue_work() and releasing the reference at the end of the
> execution of the work function blk_zone_wplug_bio_work().
> The helper function disk_zone_wplug_schedule_bio_work() is introduced to
> get a reference on a zone write plug and queue its work. This helper is
> used in disk_zone_wplug_unplug_bio() and disk_zone_wplug_handle_error().
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 26 +++++++++++++++++++++-----
>   1 file changed, 21 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

