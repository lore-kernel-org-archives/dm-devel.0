Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3D320E
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630232; cv=none; b=pugW9iH2rgqh30O5I3claVSB67TcNmv6JeFNJNBd/D6x17dLW6HkH/ICXDHDCkrrSEi0Yx3GVt7h4QnohOLzs926/+I87YmpXry5GU8sOWeiXAwSWEHK6pc417XG7ncBCHvtxAkr7WtJZM7F4su7JhjUdw3CBARYBPi26jSADEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630232; c=relaxed/simple;
	bh=ppuKUVxA9dGPs7rCf1of1v+JZHzcseeeDW4CiLH/X8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PN5ELoW3DTd/6pA+UR6XF8aZpoIDnpWcpxfmjmqIcrZHe+uxlJ5e49hZbQB4oCiIqiXClUTZdDgFNQBCikdXktHMMmrMYAb+DNYgLNjNyLDwaEqcFcL3zgWSAkJrlrWHgyON1I8K9cyLzRVFjYEbJOvK0/53YC89AblHnP4QMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aOuDcLog; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cPyU1dmL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aOuDcLog; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cPyU1dmL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aOuDcLog";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cPyU1dmL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aOuDcLog";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cPyU1dmL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D6E9223A3;
	Thu,  2 May 2024 06:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h//2mcCYdAo3Cw6CwrZ6pFoa0E10bNhXKvi1FmNlz0Q=;
	b=aOuDcLogDaN6iK16gJk+MAv9fGdA00eTMPpddZHXwi/19qHD+X7hQPae8OTtxaoMS23KbW
	RSiUNfw6KkBVUzO8AleFzKIjrNI8Hq32bH6+CZx6V233pxZAWf62df6de40WQqw6FyThRV
	dwtlFbY/gXtCSIQ4MxnBNkwtXVwiSuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h//2mcCYdAo3Cw6CwrZ6pFoa0E10bNhXKvi1FmNlz0Q=;
	b=cPyU1dmLcu8wSkxyXKT8Gix0DX6qADYJ4O1JB2wklKiGCECqi8Dpcmsx/mfarL2mr/lhfj
	Tf6cFBS4UEKN0tDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h//2mcCYdAo3Cw6CwrZ6pFoa0E10bNhXKvi1FmNlz0Q=;
	b=aOuDcLogDaN6iK16gJk+MAv9fGdA00eTMPpddZHXwi/19qHD+X7hQPae8OTtxaoMS23KbW
	RSiUNfw6KkBVUzO8AleFzKIjrNI8Hq32bH6+CZx6V233pxZAWf62df6de40WQqw6FyThRV
	dwtlFbY/gXtCSIQ4MxnBNkwtXVwiSuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h//2mcCYdAo3Cw6CwrZ6pFoa0E10bNhXKvi1FmNlz0Q=;
	b=cPyU1dmLcu8wSkxyXKT8Gix0DX6qADYJ4O1JB2wklKiGCECqi8Dpcmsx/mfarL2mr/lhfj
	Tf6cFBS4UEKN0tDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 275D713957;
	Thu,  2 May 2024 06:10:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2CrPBVUuM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:10:29 +0000
Message-ID: <023d105a-b2f2-4f51-ab4c-0fceb0f51958@suse.de>
Date: Thu, 2 May 2024 08:10:28 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/14] block: Fix flush request sector restore
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-9-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/1/24 13:09, Damien Le Moal wrote:
> Make sure that a request bio is not NULL before trying to restore the
> request start sector.
> 
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Fixes: 6f8fd758de63 ("block: Restore sector of flush requests")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-flush.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index 2f58ae018464..c17cf8ed8113 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -130,7 +130,8 @@ static void blk_flush_restore_request(struct request *rq)
>   	 * original @rq->bio.  Restore it.
>   	 */
>   	rq->bio = rq->biotail;
> -	rq->__sector = rq->bio->bi_iter.bi_sector;
> +	if (rq->bio)
> +		rq->__sector = rq->bio->bi_iter.bi_sector;
>   
>   	/* make @rq a normal request */
>   	rq->rq_flags &= ~RQF_FLUSH_SEQ;

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

