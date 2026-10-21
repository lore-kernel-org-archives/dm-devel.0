Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792574702;
	b=Lk8jW7bclFie+O2pvYUij6opDHpoT/7iOOyTuUp/hnXoZ4bmsXfzRaKrBLmDZt/K2Eum
	 gqIdelsJrLjPCPLhds1a4ny0nGcTNIngwT39CeJ699NhZusl88l9k4GbO2yFb32/XoqAG
	 Z1A+V+3WY46+WQFlABBASNIGWAJ8X7+yihogKOIfPherRwerOcD+GeNw+zlmkIE64I511
	 yAfCmqQlKMmDloQyUp0zMyIUnq//zbSFF/1zw5kLEK0dGulcxeOBozjiUDIg2rDAOe+wD
	 Ss0MRBv4kHtY1Lb7J+yO6rkv+ZOYdO5sOF49zw9f0RtzGdQP7CmcQu8Ae9lJTQpHsEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792574702;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=uaqSg1SlCXfDpsE5/FtzM0QxJkQtdiSMMrqW33UTt04=;
	b=pIBTaEEPhcG8dVGjPGJx5u5561poifC66W6uIN1LKNvlL4z0GyeUo0dS1XbvLzAMK7qE
	 WErZptGbGAXf6qOF0omSnfg3tXh1CHrasD38EbIAb3moCHHMu8GC6iKhXBBMJQ770kavC
	 H4s8coYvVyseVJZ04Uf4toTIi/lwquroWX7eZYgzZ+SSNJ8R/+YCsQSGz02OasM7RQwxa
	 9ck+UrLDJ/SibwxuK1XUFFBHT8iy64LKs3FpvuMmBzJEFM47I5F/N2c4ozFCMgASKZpM5
	 Xdi+nfTeUEV2KweEjWxIFJ1Ph1Bctxdr5SDrvXgmdjxUwnpcXLbg70s8tCmRm8oQDSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lcy0WJ1B;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jORInsZr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=v5mi7gW9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=elejB6yO;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2398E606A31A
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 09:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2398E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lcy0WJ1B;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jORInsZr;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=v5mi7gW9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=elejB6yO
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0851D21CC7;
	Wed, 21 Oct 2026 09:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792574700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaqSg1SlCXfDpsE5/FtzM0QxJkQtdiSMMrqW33UTt04=;
	b=lcy0WJ1BqDCEjeAB+DnlxghFjYwEg8yI8SGWuv/G6QwibmjmA0X9+JqFggaAD36NvGzff/
	M6tDlpS/JvwIXBwr9j+dj1vcE+kWljnflYPyon7xUMG3F63OX30k2SCX1GP9qza7cQYtBB
	8zhEE6chKMXONvsSLO+mMovNcLRcHMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792574700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaqSg1SlCXfDpsE5/FtzM0QxJkQtdiSMMrqW33UTt04=;
	b=jORInsZrpxEWYRPm+qip5iLwV+q+RwEEnJ1lbSfpph5+JXPELUoMh9s8TIdAkWMuqiN/TH
	Z+6Oaps5SGzznKDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792574699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaqSg1SlCXfDpsE5/FtzM0QxJkQtdiSMMrqW33UTt04=;
	b=v5mi7gW9+u95hrkvLamXAOkmE/JqTcE+FjW5bpptmYtCMroPLsTHA5pAgDfgtquYiY7DXX
	8MCSKf7fo+GXFaRYBDovijvKz4BU3WqGbAqo3IHH/Fj5ONEyybroFVKC36kbW6NSM37X1N
	P2pmPQgeGX1dMnTmF5zlMy3FLTjk5qQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792574699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaqSg1SlCXfDpsE5/FtzM0QxJkQtdiSMMrqW33UTt04=;
	b=elejB6yOFg2iX4EZrPOkkWGS31jNTqHRWzT4ZeP3a6mgibyNDzzZRuuyyv7xPrXhiJvIp0
	xOqEiDigFCaXAfBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C999C134A5;
	Wed, 21 Oct 2026 09:24:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FcqZKOqE2GpuEAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:24:58 +0000
Message-ID: <fb66fd1f-a3e5-41a5-ae7a-8f518fb87d95@suse.de>
Date: Wed, 21 Oct 2026 11:24:41 +0200
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] dm zoned: back off when reclaim finds no
 destination zone
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-2-illofspeed@gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261011175450.952-2-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,lists.linux.dev];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/11/26 7:54 PM, Kyrylo Biryuk wrote:
> When dmz_do_reclaim() fails with -ENOSPC because no free zone is
> available to copy the data into, dmz_reclaim_work() still ends with
> dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
> keeps returning true, the work is queued again with no delay and the
> worker spins on the same failing pass.
> 
> Re-arm the idle poll instead, so that reclaim is retried after
> DMZ_IDLE_PERIOD. The next patch makes -ENOSPC the expected result when
> an idle target has random zones but no free sequential zone.
> 
> Tested on a 7.2.6 kernel as an out-of-tree dm-zoned module, together
> with the next two patches, on emulated host-managed drives (tcmu-runner
> ZBC handler) and on three 27 TB host-managed drives used as md RAID5
> members.
> 
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
> ---
>   drivers/md/dm-zoned-reclaim.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index c041413c729..315f0da99f3 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -540,6 +540,14 @@ static void dmz_reclaim_work(struct work_struct *work)
>   	if (ret && ret != -EINTR) {
>   		if (!dmz_check_dev(zmd))
>   			return;
> +		if (ret == -ENOSPC) {
> +			/*
> +			 * No zone to copy into: nothing can progress now.
> +			 * Rescheduling immediately would spin; poll instead.
> +			 */
> +			mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
> +			return;
> +		}
>   	}
>   
>   	dmz_schedule_reclaim(zrc);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
