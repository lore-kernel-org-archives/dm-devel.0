Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C722522F00
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630556; cv=none; b=sshv9qdbpe129WpDirDEk+Fq7gOqDKMDYWr/wQz3HPvYfLPnoWbc0U2ht4Vqq4XIxkeclatHCFm29krtGmAbEnrW/PeQuuDI/ZuI+VY5CoLqQvAdx7HdSBw0AQ8ee/iwysq2BlessVXDS8Ubg3+ixe4kxGJz4kkeuj3cwCQPA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630556; c=relaxed/simple;
	bh=tSuZX1lp7t0xfJfWqHauhmf6eqcAwELqqV1C4ND0QMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sr6OP1HdxaZ1RVAASz0Zs1aNMC3bTp97GPRy8zCr7u5772bdi8hneriqoSH3XzspdlbTw3sWPT5xQSDH9xcv90i+uxRAU7CfGxM8hH/Y1GtBnndlzCUuH3zPNuYOjTj9RHPmV+9lQQYZiK7nsKNm8S5Jw66/hMN35995aIE4RFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=l3vCcxWC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jEYXFfwP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=l3vCcxWC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jEYXFfwP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="l3vCcxWC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jEYXFfwP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="l3vCcxWC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jEYXFfwP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D7173500B;
	Thu,  2 May 2024 06:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDBjc0JVOwpeMk9MwmiFiciKhSmrWPLIb0b4YE+jks0=;
	b=l3vCcxWC5yCZrfEwXjmO/3Yz49jNKvvmumBYyPRBDwKLFFbFLKOljr4F6dZyOtK/ZK6x8n
	SKTI98HOt1yNYam0D1W5zZkMBi/sexzauDFlBR6i9xfvv7wo/Rq3VJR5gk7TyVkHjNQIs7
	Spo7R27fQopFHy8Wc3Sp+Ez/UGnKwOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDBjc0JVOwpeMk9MwmiFiciKhSmrWPLIb0b4YE+jks0=;
	b=jEYXFfwPwlQKLwOy9b5ZUl3umnjnfXdtnxj0nj9GiJ02wK3OcgPgW90mdaAechpwlEvMNc
	8by28y4WUBqtDEAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l3vCcxWC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jEYXFfwP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDBjc0JVOwpeMk9MwmiFiciKhSmrWPLIb0b4YE+jks0=;
	b=l3vCcxWC5yCZrfEwXjmO/3Yz49jNKvvmumBYyPRBDwKLFFbFLKOljr4F6dZyOtK/ZK6x8n
	SKTI98HOt1yNYam0D1W5zZkMBi/sexzauDFlBR6i9xfvv7wo/Rq3VJR5gk7TyVkHjNQIs7
	Spo7R27fQopFHy8Wc3Sp+Ez/UGnKwOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDBjc0JVOwpeMk9MwmiFiciKhSmrWPLIb0b4YE+jks0=;
	b=jEYXFfwPwlQKLwOy9b5ZUl3umnjnfXdtnxj0nj9GiJ02wK3OcgPgW90mdaAechpwlEvMNc
	8by28y4WUBqtDEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CACF11386E;
	Thu,  2 May 2024 06:15:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GEllL5gvM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:15:52 +0000
Message-ID: <80f0e963-e363-4095-9080-ebaa80e54130@suse.de>
Date: Thu, 2 May 2024 08:15:52 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/14] block: Simplify zone write plug BIO abort
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-14-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,wdc.com:email,lst.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2D7173500B
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 5/1/24 13:09, Damien Le Moal wrote:
> When BIOs plugged in a zone write plug are aborted,
> blk_zone_wplug_bio_io_error() clears the BIO BIO_ZONE_WRITE_PLUGGING
> flag so that bio_io_error(bio) does not end up calling
> blk_zone_write_plug_bio_endio() and we thus need to manually drop the
> reference on the zone write plug held by the aborted BIO.
> 
> Move the call to disk_put_zone_wplug() that is alwasy following the call
> to blk_zone_wplug_bio_io_error() inside that function to simplify the
> code.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

