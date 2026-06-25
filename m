Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53643BCD3E
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 06:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368445; cv=none; b=tsHTI7quFF4LhyhkVagH7jMScQ67sVYu2HbqjFhevTtjzaCOx4HH89/V1jighrIhVlBVPROK9n0KTG7nREzF/aPp0Ll0VPSOqJ9j58k8toGoacW+/ziBICadWDLQhAg1DkPN76TPErmGTNqeJD6mXTbyTugUHAglPj/1suwH9Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368445; c=relaxed/simple;
	bh=1zm6liw1piOmDUwslq1VS/ljoAF/GAhIy57Ub/PGpXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kUbJbYckVqScP4fk9B8flxcK7OGxfbLosuBcendo22JE+p6qVp9RHjyO4Q43pwK8WX+3qjKupIuDf+WyzzQe+CMjhOBaoQ1fP4PK4V32XXiTu5kTtfkn5qbYIWG7nr4f7V+G++ZVWW7IoMSfuCkawbfY8gW+spkI6qGcT0osWWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wM+w56r6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VQrUJVgP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wM+w56r6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VQrUJVgP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wM+w56r6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VQrUJVgP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wM+w56r6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VQrUJVgP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DA1F7614C;
	Thu, 25 Jun 2026 06:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9OBlrt/I+wG/F5iVAOr1ztffYyzXO4uytI+IQs8u64A=;
	b=wM+w56r6WZQ1WB3hNad1tC04IK2PJ/bDZaMeYi4+iwo54FwNw11uePGC44IpFG5qtERsls
	DQdy8B4pSKOv3jMzGHqNRVE1e29yw6B35w9KUz2zsy1BUWR2P8EM7hPCoFAxk5VMstvUb3
	xG+kNVqAbEbpk5vgWuY6uEqOB6lQwgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9OBlrt/I+wG/F5iVAOr1ztffYyzXO4uytI+IQs8u64A=;
	b=VQrUJVgPUGzibnUK0f0RC6EMRi7Y4CChhzHjN7NQ38C8KwRlFmH+KuH5LPPYrd1qTw4PQd
	nDfBq+/JyOMMgTDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9OBlrt/I+wG/F5iVAOr1ztffYyzXO4uytI+IQs8u64A=;
	b=wM+w56r6WZQ1WB3hNad1tC04IK2PJ/bDZaMeYi4+iwo54FwNw11uePGC44IpFG5qtERsls
	DQdy8B4pSKOv3jMzGHqNRVE1e29yw6B35w9KUz2zsy1BUWR2P8EM7hPCoFAxk5VMstvUb3
	xG+kNVqAbEbpk5vgWuY6uEqOB6lQwgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9OBlrt/I+wG/F5iVAOr1ztffYyzXO4uytI+IQs8u64A=;
	b=VQrUJVgPUGzibnUK0f0RC6EMRi7Y4CChhzHjN7NQ38C8KwRlFmH+KuH5LPPYrd1qTw4PQd
	nDfBq+/JyOMMgTDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0390A779A8;
	Thu, 25 Jun 2026 06:20:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jirxOrnIPGowQAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:20:41 +0000
Message-ID: <8e8e08fe-86e0-418f-8080-0852a72d2049@suse.de>
Date: Thu, 25 Jun 2026 08:20:41 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] block: use blkdev_iov_iter_get_pages status for
 errors
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
 Keith Busch <kbusch@kernel.org>
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260624170905.3972095-2-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624170905.3972095-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

On 6/24/26 7:09 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> blkdev_iov_iter_get_pages() can return various error values, including
> EIO, EFAULT, and ENOMEM. Set the actual reported status so user space
> can know a little more on why an operation failed.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/fops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180dec..0827bb884d473 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -218,7 +218,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
>   
>   		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
>   		if (unlikely(ret)) {
> -			bio_endio_status(bio, BLK_STS_IOERR);
> +			bio_endio_status(bio, errno_to_blk_status(ret));
>   			break;
>   		}
>   		if (iocb->ki_flags & IOCB_NOWAIT) {

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
