Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D231FF1DF
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739983240; cv=none; b=hzJxKLO3WebpsbOpmq2g4+Y2CqM8BooJhmQiRYqc1Bh0dhyLZpDDYhe710NPI+etGs1RlCdHQG+JyHkp+TN22JZg64DVB1z5i1X+topyvzsf2KHbF6gPWpqaZd8Vcxk3H09SczsE5UWcPEwxvr9yjeQuUaTRY5rL2P45FTe3UaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739983240; c=relaxed/simple;
	bh=0T7UzcfyGUnQa2pY3emgmGDXuTGtdIMypOioYn0l9UU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0gQGlvGgm86J/2geInSTR87TKVpO9GKnVgm+n2lL+h/VOA8RCrkxes21M8n2hUHFbhmpHDyfLwLNGSS6P/wMUn/tXRxCHZMIwHLzXTLBNN+Xm2gWBCCW3fNatdKpzXxwg2VlN8wjjNG606SnITrpkafCZ2eFwYDbrJgau9/WLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NFzjPdBL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FSR6JaLs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NFzjPdBL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FSR6JaLs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NFzjPdBL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FSR6JaLs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NFzjPdBL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FSR6JaLs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73C4D211FF;
	Wed, 19 Feb 2025 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1739983236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6acPoV1MhFzV2ewoD+L8dKIMOD89uAGP45IUc44RdE=;
	b=NFzjPdBLin9ey7+CnPgKTbLd+gf2KlIVEpTH3MsPZh9t8jZm0bQyonsUO8gdz9g3YMQGxN
	MSCdclX7wmlMfZqxXzhyRTHLGnihfj0mA1mEdddLOkfAyYJv/vAB4soJmuKz+xwVYtin/4
	wlg0kurNu0gfUyprL6dN7Nr9VSp0e3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1739983236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6acPoV1MhFzV2ewoD+L8dKIMOD89uAGP45IUc44RdE=;
	b=FSR6JaLsdRXR2UdObbCt/5607R9FktJVJ2QnMb1wJqtsIihBmsXQLqid5K1fXcyuCAsWLg
	Eb5J6OoT2RjPzgBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1739983236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6acPoV1MhFzV2ewoD+L8dKIMOD89uAGP45IUc44RdE=;
	b=NFzjPdBLin9ey7+CnPgKTbLd+gf2KlIVEpTH3MsPZh9t8jZm0bQyonsUO8gdz9g3YMQGxN
	MSCdclX7wmlMfZqxXzhyRTHLGnihfj0mA1mEdddLOkfAyYJv/vAB4soJmuKz+xwVYtin/4
	wlg0kurNu0gfUyprL6dN7Nr9VSp0e3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1739983236;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6acPoV1MhFzV2ewoD+L8dKIMOD89uAGP45IUc44RdE=;
	b=FSR6JaLsdRXR2UdObbCt/5607R9FktJVJ2QnMb1wJqtsIihBmsXQLqid5K1fXcyuCAsWLg
	Eb5J6OoT2RjPzgBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEE03137DB;
	Wed, 19 Feb 2025 16:40:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oiCPOIMJtmcrTAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 19 Feb 2025 16:40:35 +0000
Message-ID: <cc3ebf94-e1e2-48bc-83f2-d7aaf65b3d27@suse.de>
Date: Wed, 19 Feb 2025 17:40:35 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_data
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 target-devel@vger.kernel.org
References: <20250218182207.3982214-1-hch@lst.de>
 <20250218182207.3982214-4-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250218182207.3982214-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 2/18/25 19:21, Christoph Hellwig wrote:
> Many of the fields in struct bio_integrity_data are only needed for
> the default integrity buffer in the block layer, and the variable
> sized array at the end of the structure makes it very hard to embed
> into caller allocated structures.
> 
> Reduce struct bio_integrity_data to the minimal structure needed in
> common code, and create containing structures for the payload + bvec
> allocation for submitter provided buffers, and the default integrity
> code.  Stop using mempools for the submitter buffers as they don't sit
> below the I/O stack, and instead always use the mempool for automatic
> integrity metadata instead of depending on bio_set that is submitter
> controlled and thus often doesn't have the mempool initialized.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/bio-integrity-auto.c          |  75 +++++++++++++------
>   block/bio-integrity.c               | 107 ++++++----------------------
>   block/bio.c                         |   6 --
>   block/blk.h                         |   2 +-
>   block/t10-pi.c                      |   6 +-
>   drivers/md/dm-integrity.c           |  12 ----
>   drivers/md/dm-table.c               |   6 --
>   drivers/md/md.c                     |  13 ----
>   drivers/target/target_core_iblock.c |  12 ----
>   include/linux/bio-integrity.h       |  25 +------
>   include/linux/bio.h                 |   4 --
>   11 files changed, 80 insertions(+), 188 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
