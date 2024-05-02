Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2520B3E
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714629700; cv=none; b=Rd27V8jrPsd5HRrVLkLnM2wO7zxYBtBSfgmxTXpjPd9kBKppP0gKhWj6s4vh4iTjATeK5iFPOK1zBz8lEs3sJq5sOJySyOUuTRdoYcGi4z4lPmyc95MgAK+g97qOuQ1BSI0UI19bkeoGN3XGRHpBFS3zTKSuOWoZ6wKYX6lkb6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714629700; c=relaxed/simple;
	bh=24y/adWqW1rl1yP9Sv19wdN8G5tINJXTHiI5PpZHHqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nriPg0EC9cAF8/oVGynh/kqlcxvYZXXIaabWzZLkLV/TAFo+GlcCkoMlmqBY07ZmYnhdSuhh3yF8DcKaAz/Bwt5TLBnPD2Xc4Ag/7/WnTrkiWgEsWeNdjqo6zwoikD5z5QsQutXjIAYG5JQ6WwfRXxD0VqKh3SHILvFn8YAP2X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bSmiEice; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=upUwknJ0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bSmiEice; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=upUwknJ0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bSmiEice";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="upUwknJ0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bSmiEice";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="upUwknJ0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5BA7D1FB9D;
	Thu,  2 May 2024 06:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUh5u85AxSj9q1siCpGmNrk8RqWdqZRdcHAFdefXOTA=;
	b=bSmiEiceEbiA0kTbmmaBMr72aKM9io28zE2rUEAgdVFt7yUB+g6Rgdr7gUFESi2tRttdKG
	MJ7/Rsunp70N+iwFRUkNtX7Yrf/j0+PYQCtERjEReYaZholUqiWPvyhl8CF8nu6ETgvLlr
	3F2MTuFfoTNuyIPHBLl7NGtMkjSaAhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUh5u85AxSj9q1siCpGmNrk8RqWdqZRdcHAFdefXOTA=;
	b=upUwknJ0vY+QW1p2aQnISL1emjlAJGPg0qoF7IndXQafSVXJPg3LzrfRM9BL1Gg5Du6Fof
	17ix/7m1nccvSRBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUh5u85AxSj9q1siCpGmNrk8RqWdqZRdcHAFdefXOTA=;
	b=bSmiEiceEbiA0kTbmmaBMr72aKM9io28zE2rUEAgdVFt7yUB+g6Rgdr7gUFESi2tRttdKG
	MJ7/Rsunp70N+iwFRUkNtX7Yrf/j0+PYQCtERjEReYaZholUqiWPvyhl8CF8nu6ETgvLlr
	3F2MTuFfoTNuyIPHBLl7NGtMkjSaAhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629697;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUh5u85AxSj9q1siCpGmNrk8RqWdqZRdcHAFdefXOTA=;
	b=upUwknJ0vY+QW1p2aQnISL1emjlAJGPg0qoF7IndXQafSVXJPg3LzrfRM9BL1Gg5Du6Fof
	17ix/7m1nccvSRBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 279E413957;
	Thu,  2 May 2024 06:01:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ha/WBUEsM2YANAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:01:37 +0000
Message-ID: <d4f71b64-b2d3-4350-b502-bbcfcc9614ce@suse.de>
Date: Thu, 2 May 2024 08:01:35 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/14] block: Fix reference counting for zone write
 plugs in error state
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-5-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/1/24 13:08, Damien Le Moal wrote:
> When zone is reset or finished, disk_zone_wplug_set_wp_offset() is
> called to update the zone write plug write pointer offset and to clear
> the zone error state (BLK_ZONE_WPLUG_ERROR flag) if it is set.
> However, this processing is missing dropping the reference to the zone
> write plug that was taken in disk_zone_wplug_set_error() when the error
> flag was first set. Furthermore, the error state handling must release
> the zone write plug lock to first execute a report zones command. When
> the report zone races with a reset or finish operation that clears the
> error, we can end up decrementing the zone write plug reference count
> twice: once in disk_zone_wplug_set_wp_offset() for the reset/finish
> operation and one more time in disk_zone_wplugs_work() once
> disk_zone_wplug_handle_error() completes.
> 
> Fix this by introducing disk_zone_wplug_clear_error() as the symmetric
> function of disk_zone_wplug_set_error(). disk_zone_wplug_clear_error()
> decrements the zone write plug reference count obtained in
> disk_zone_wplug_set_error() only if the error handling has not started
> yet, that is, only if disk_zone_wplugs_work() has not yet taken the zone
> write plug off the error list. This ensure that either
> disk_zone_wplug_clear_error() or disk_zone_wplugs_work() drop the zone
> write plug reference count.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 75 +++++++++++++++++++++++++++++++----------------
>   1 file changed, 49 insertions(+), 26 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 7824bd52c82c..23ad1de0da62 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -658,6 +658,54 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
>   	bio_list_merge(&zwplug->bio_list, &bl);
>   }
>   
> +static inline void disk_zone_wplug_set_error(struct gendisk *disk,
> +					     struct blk_zone_wplug *zwplug)
> +{
> +	unsigned long flags;
> +
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
> +		return;
> +

I still get nervous when I see an unprotected flag being set.
Especially in code which is known to race with error handling.
Wouldn't it be better to check the flag under the lock or at
least use 'test_and_set_bit' here?

> +	/*
> +	 * At this point, we already have a reference on the zone write plug.
> +	 * However, since we are going to add the plug to the disk zone write
> +	 * plugs work list, increase its reference count. This reference will
> +	 * be dropped in disk_zone_wplugs_work() once the error state is
> +	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
> +	 * finished.
> +	 */
> +	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;

And that is even worse. We might have been interrupted between these
two lines, invalidating the first check.

Please consider using 'test_and_set_bit()' here.

> +	atomic_inc(&zwplug->ref);
> +
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +}
> +
> +static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
> +					       struct blk_zone_wplug *zwplug)
> +{
> +	unsigned long flags;
> +
> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
> +		return;
> +
> +	/*
> +	 * We are racing with the error handling work which drops the reference
> +	 * on the zone write plug after handling the error state. So remove the
> +	 * plug from the error list and drop its reference count only if the
> +	 * error handling has not yet started, that is, if the zone write plug
> +	 * is still listed.
> +	 */
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	if (!list_empty(&zwplug->link)) {
> +		list_del_init(&zwplug->link);
> +		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> +		disk_put_zone_wplug(zwplug);
> +	}
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +}
> +

Similar comments to above: you are clearing the flag under the lock,
but don't check or set under the lock...

>   /*
>    * Set a zone write plug write pointer offset to either 0 (zone reset case)
>    * or to the zone size (zone finish case). This aborts all plugged BIOs, which
> @@ -691,12 +739,7 @@ static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
>   	 * in a good state. So clear the error flag and decrement the
>   	 * error count if we were in error state.
>   	 */
> -	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
> -		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
> -		spin_lock(&disk->zone_wplugs_lock);
> -		list_del_init(&zwplug->link);
> -		spin_unlock(&disk->zone_wplugs_lock);
> -	}
> +	disk_zone_wplug_clear_error(disk, zwplug);
>   
>   	/*
>   	 * The zone write plug now has no BIO plugged: remove it from the
> @@ -885,26 +928,6 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
>   	spin_unlock_irqrestore(&zwplug->lock, flags);
>   }
>   
> -static inline void disk_zone_wplug_set_error(struct gendisk *disk,
> -					     struct blk_zone_wplug *zwplug)
> -{
> -	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {
> -		unsigned long flags;
> -
> -		/*
> -		 * Increase the plug reference count. The reference will be
> -		 * dropped in disk_zone_wplugs_work() once the error state
> -		 * is handled.
> -		 */
> -		zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
> -		atomic_inc(&zwplug->ref);
> -
> -		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> -		list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
> -		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> -	}
> -}
> -
>   /*
>    * Check and prepare a BIO for submission by incrementing the write pointer
>    * offset of its zone write plug and changing zone append operations into

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

