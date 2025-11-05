Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49012C324F
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762326462; cv=none; b=TXUim5IlOJj5IA8avvfxb/o2aDUlA3O2+smieUA2Ch42ZO7J3yT5V5VZCIUN2mjkqcYbyL36s1EGkDwrGi+hYyareyKXsXsWbBjEEXiGB2CJuKKuuB+JCMriJYsbTqDRTc/Opd9Cb9ls7PkHFyT/9u26KFDUW27AjqO6K+/+Hdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762326462; c=relaxed/simple;
	bh=p7hksjvoRajq32fjL/90LbckTAGN7PA0r1C7VGzU7SU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=snHTwu2Y+nXT40yz6uoT915hA3j/8glSXwQiHBe5NNHMoDSTkG4gwNHqE7oIdkT1UQx13Ylw9EUWx68cUcqngFF1kWOV5vYUB6SVriGtKoXQjq7rszmRZv37nrg+jcp3G6wg6NtQwg9okLqkHauMe8G5riLgxXCB7anhGKZcz7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RcSEnDcs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NPwD1HrC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RcSEnDcs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NPwD1HrC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RcSEnDcs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NPwD1HrC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RcSEnDcs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NPwD1HrC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 363A71F394;
	Wed,  5 Nov 2025 07:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxwUrAudPBCL5tqrqLgM/U3Q+i0dXzOUa0usIp5g5RY=;
	b=RcSEnDcsPNdCKiftXG638I2JWJJPjnBAtaUwW4tTbelR/QFqMclU/rbavr12dh1BrDlhtZ
	DasAR5hRJibSuyCU5VHwDrm9ZckeaN14fAgCIpEznY8JWq0F0uLUQeu3GDYBeSZyfIkoG7
	DvKNojROFVgj3LuOYLfcl81l72Y63ps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxwUrAudPBCL5tqrqLgM/U3Q+i0dXzOUa0usIp5g5RY=;
	b=NPwD1HrCPCD2kUsJztUR6+/03/pR0nf0CWHGw57kIjy6Yc1A42il3889FR0BDV1N2nF9Eu
	pm+SL5kEczd4e/Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762326458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxwUrAudPBCL5tqrqLgM/U3Q+i0dXzOUa0usIp5g5RY=;
	b=RcSEnDcsPNdCKiftXG638I2JWJJPjnBAtaUwW4tTbelR/QFqMclU/rbavr12dh1BrDlhtZ
	DasAR5hRJibSuyCU5VHwDrm9ZckeaN14fAgCIpEznY8JWq0F0uLUQeu3GDYBeSZyfIkoG7
	DvKNojROFVgj3LuOYLfcl81l72Y63ps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762326458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UxwUrAudPBCL5tqrqLgM/U3Q+i0dXzOUa0usIp5g5RY=;
	b=NPwD1HrCPCD2kUsJztUR6+/03/pR0nf0CWHGw57kIjy6Yc1A42il3889FR0BDV1N2nF9Eu
	pm+SL5kEczd4e/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95492132DD;
	Wed,  5 Nov 2025 07:07:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O9xsIrn3CmmNEQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 05 Nov 2025 07:07:37 +0000
Message-ID: <f443ebd0-38f9-473d-b214-dbcbedb9bf49@suse.de>
Date: Wed, 5 Nov 2025 08:07:37 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/15] block: refactor blkdev_report_zones() code
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 Keith Busch <keith.busch@wdc.com>, Christoph Hellwig <hch@lst.de>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
 Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.com>
References: <20251104013147.913802-1-dlemoal@kernel.org>
 <20251104013147.913802-9-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251104013147.913802-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:mid,lst.de:email,wdc.com:email,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,wdc.com:email,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 11/4/25 02:31, Damien Le Moal wrote:
> In preparation for implementing cached report zone, split the main part
> of the code of blkdev_report_zones() into the helper function
> blkdev_do_report_zones(), with this new helper taking as argument a
> struct blk_report_zones_args pointer instead of a report callback
> function and its private argument.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
