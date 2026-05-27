Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5753ECBE7
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779874850; cv=none; b=fuJm3rYvyRo+KxkaxExPEHeUG8SwpVYZw+F+eU5CSZv/bMRyr+pFPzGbi37ktULM9zkIM7vjenoeCAogQxySHRHkanjJR/J9CAQGbq6jpu5LHHAww1M6Lo8083Z3zNwQqiB0VLSXvn2U9W3t5pPoI0BP764hF9tM88JTEcqGdPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779874850; c=relaxed/simple;
	bh=DbvNa1LODdJyJAgZDJJgSZ4h11ow+n5OVQekrwCtNDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WEUvX3AVyFPPMPllEPqbw3lAVIjz9QcNEk5JxDC/7PrjquNnG9ISCT+j0NBpcrnXL6J7BKdSSpg3jK3KJJA5iciIfuIHdvAzCzANV7L6DJ9GCyNXfZJuMCBVxNd18gUy6vUp/pC7wpuebWdDg2s+8lmmHURN3OooEdoiaFRllhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U1AqYOZE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v2QYYAf8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kRyG3C5z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wUazKZOG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U1AqYOZE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v2QYYAf8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kRyG3C5z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wUazKZOG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4F896AE18;
	Wed, 27 May 2026 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779874847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dN9dlz5qdf+blBI754mOy1icazM2aYt74kZKnD/Uls=;
	b=U1AqYOZEXrY8Qq8IpJu8UohKhjVWCDHkLvE0zk0605F4YVcjTNOnAo4foCWfOCu5Q3kHfp
	2F8ya2ld2u4F+nq7WZu2wyp7crgQDsp2JZ+eYcA/pWWcQtekPf4RHpzICbo+BV4OziDcKP
	3xe0lYb0UQLodCCvGzccLpw+XMFOiyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779874847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dN9dlz5qdf+blBI754mOy1icazM2aYt74kZKnD/Uls=;
	b=v2QYYAf8sj/nZgtswXWo3ADVOG10CE7bgBmzgONjelmdvJAl57f6cUuqh6Y8DGuawjeQgY
	tJml5k8bzIt6dzCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kRyG3C5z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wUazKZOG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779874845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dN9dlz5qdf+blBI754mOy1icazM2aYt74kZKnD/Uls=;
	b=kRyG3C5zGJHGabRQLduId1gQ02QYSxPnoWlHLwU0q5f5MP9Kl9CAbFaisYj6CO3ouo8TYD
	nFCW2kEKhNTmNlsM/pr/r1Z+wuHiyDJLheiXGkIWv0Ao5ap5jeL4Gq4CLUvY45OSXP7gLo
	9nXMaqmtl4yRhiZqW/BMXrwjuDcAv3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779874845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dN9dlz5qdf+blBI754mOy1icazM2aYt74kZKnD/Uls=;
	b=wUazKZOGKLKaiRT3uhw3nBzJv6w+CgjM3IFORDFU+eW4ZYs6kF40FcGYLRu78I5vvnuRR5
	YtMhPYmQgFL16yDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF39A5A776;
	Wed, 27 May 2026 09:40:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZqAgLh28Fmo/PAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 09:40:45 +0000
Message-ID: <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
Date: Wed, 27 May 2026 11:40:45 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
To: Martin Wilck <martin.wilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
 <20260522164415.846589-10-mwilck@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260522164415.846589-10-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D4F896AE18
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,suse.de:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.01

On 5/22/26 18:44, Martin Wilck wrote:
> Use shared_ptr to track the runner_context refcount.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   libmpathutil/runner.c | 30 +++++++++---------------------
>   1 file changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
> index 8c6d6b9..56abd03 100644
> --- a/libmpathutil/runner.c
> +++ b/libmpathutil/runner.c
> @@ -30,7 +30,6 @@ const char *runner_state_name(int state)
>   }
>   
>   struct runner_context {
> -	int refcount;
>   	int status;
>   	struct timespec deadline;
>   	pthread_t thr;
> @@ -39,17 +38,6 @@ struct runner_context {
>   	char __attribute__((aligned(sizeof(void *)))) data[];
>   };
>   
> -static void release_context(struct runner_context *rctx)
> -{
> -	int n;
> -
> -	n = uatomic_sub_return(&rctx->refcount, 1);
> -	assert(n >= 0);
> -
> -	if (n == 0)
> -		free(rctx);
> -}
> -
>   static void cleanup_context(struct runner_context **prctx)
>   {
>   	struct runner_context *rctx = *prctx;
> @@ -65,7 +53,7 @@ static void cleanup_context(struct runner_context **prctx)
>   			"%s: runner %p finished in state '%s'", __func__, rctx,
>   			runner_state_name(st));
>   	}
> -	release_context(rctx);
> +	put_shared_ptr(rctx);
>   }
>   
>   static void *runner_thread(void *arg)
> @@ -147,7 +135,7 @@ repeat:
>   void release_runner(struct runner_context *rctx)
>   {
>   	cancel_runner(rctx);
> -	release_context(rctx);
> +	put_shared_ptr(rctx);
>   }
>   
>   int check_runner(struct runner_context *rctx, void *data, unsigned int size)
> @@ -195,17 +183,17 @@ struct runner_context *get_runner(runner_func func, void *data,
>   		return NULL;
>   	}
>   
> -	rctx = malloc(sizeof(*rctx) + size);
> +	rctx = alloc_shared_ptr(sizeof(*rctx) + size, NULL);
>   	if (!rctx)
>   		return NULL;
>   
>   	rctx->func = func;
>   	/*
> -	 * We have to set the refcount to 2 here. The runner thread may be
> -	 * cancelled before it even had the chance to increase the refcount,
> -	 * which could result in a use-after-free in cleanup_context().
> +	 * Take an additional reference here. The runner thread may be
> +	 * cancelled before it even had the chance to take a reference, which
> +	 * could result in a use-after-free in cleanup_context().
>   	 */
> -	uatomic_set(&rctx->refcount, 2);
> +	get_shared_ptr(rctx);
>   	uatomic_set(&rctx->status, RUNNER_IDLE);
>   	memcpy(rctx->data, data, size);
>   
> @@ -222,8 +210,8 @@ struct runner_context *get_runner(runner_func func, void *data,
>   
>   	if (rc) {
>   		condlog(1, "%s: pthread_create(): %s", __func__, strerror(rc));
> -		uatomic_dec(&rctx->refcount);
> -		release_context(rctx);
> +		put_shared_ptr(rctx);
> +		put_shared_ptr(rctx);
>   		return NULL;
>   	}
>   	return rctx;

Hmm. While I fully get the idea why one would want to use refcounted 
objects, there really is only one snag: this is multipath.
We really, _really_, should make sure the daemon can execute even if
the root filesystem is not available.
So if we start dropping the reference for the checker (eg if the last 
path drops and the checker is no longer used), we might end up freeing
the memory (and dropping the modules altogether).
But if the path comes back we need to reinstate the checker, which not
only requires additional memory (which might need a recursion into the
filesystem to get free pages) but we also might need to read the checker
module from disk (again). So plenty of opportunity to deaslock waithing
for the disk be become readable.

Maybe it's an idea to have multipathd loading the modules initially,
keeping a reference to them, and then dropping the reference once
multipathd itself shuts down?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
