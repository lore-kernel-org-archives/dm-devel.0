Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6152619BBA
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630511; cv=none; b=VeHm/GjCWwtVXI3HYU1NGtgZaANitCAOlnn4gIAJuyyOa35/zGtoFflPuc17SafoWkiNIH6VFIyH8K1eRIdWpmAHRioGY388+aT7dt/KtZqB2tO7Qkev/tZkpA9yaf7d6Elk0kivO8XtPSmf/Wyz2YNV4ytK0x1uT0lG/uc2sIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630511; c=relaxed/simple;
	bh=mODD/uGz84YTx/bvfHPqga3eSkLO2uVT+/T83xRPyLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LM8hUw9LMnkuiyv+1KMdmeF2QNdJ3IUlRQWAxGdDTvdLJ6+Dk6gOUhJjzfZZiMqG1vHjeQbFjWlnrEAGlvpzxZQLxlCQhZFipQm/8CgL1KPJrLf17PrNLoCZoB3BPf7/ltyQSXX977HfTJqE/nemTzH4jCPVUqurxLIZWzSxe8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CaaMlsnE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=a6285Fhd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SDhUI4kH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4yiOJdpR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CaaMlsnE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="a6285Fhd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SDhUI4kH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4yiOJdpR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4E8B135011;
	Thu,  2 May 2024 06:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys3t1LREoz/T/mMSI7+nluAsJeVPhkSxM7KPkHgdoJ0=;
	b=CaaMlsnEL5400TFbk5gOdP6HfSX7H4vt+Mbo9mnKkshZOul23WBRHVTXsM8VKZWPGIkMrg
	Vk2ESomtN9QQpmFBJWPR2gZdttAKCXJt1ajHbyClZQpwATY5dFdnjvtE83dgkzxlA58zW3
	KXZt1TY5hC3P61yrPNup5QYW6rFzvjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys3t1LREoz/T/mMSI7+nluAsJeVPhkSxM7KPkHgdoJ0=;
	b=a6285FhdUMyGjD3OcSgcxEkS/TWdkj0xOIIqVw/uiPCXnHeEiZF4w47zLIX7EDSfrtTvAt
	cDd6CuJeXbmfLtAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SDhUI4kH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4yiOJdpR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys3t1LREoz/T/mMSI7+nluAsJeVPhkSxM7KPkHgdoJ0=;
	b=SDhUI4kHVUylXrUanfJbjy55BC8IB3mRFgDgqdx+ZXajXdPmYfpUfKHxfTt4VtL5sAbeIP
	1SyooRUBWOHizHzNmEM2NlbY9L8F4QAbAom0zaecToilA5ZMR7H31QdWP5TDZOTgly+W7u
	uqqqvAVYdihavCDMpiQ50wC2xOtDUZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys3t1LREoz/T/mMSI7+nluAsJeVPhkSxM7KPkHgdoJ0=;
	b=4yiOJdpRgObtdLdNzEBRUFmKusauANmGWCrD8LQ73Yl+JgfYqBUYiWyvzduBUb/3FDx6dL
	LNm2yR2bRkIXTiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F200E1386E;
	Thu,  2 May 2024 06:15:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8AE1OGkvM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:15:05 +0000
Message-ID: <1081de0e-ad89-4e5c-bae7-b5ab57c478c9@suse.de>
Date: Thu, 2 May 2024 08:15:05 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] block: Simplify blk_zone_write_plug_bio_endio()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-13-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4E8B135011
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[wdc.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:email,lst.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]

On 5/1/24 13:09, Damien Le Moal wrote:
> We already have the disk variable obtained from the bio when calling
> disk_get_zone_wplug(). So use that variable instead of dereferencing the
> bio bdev again for the disk argument of disk_get_zone_wplug().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

