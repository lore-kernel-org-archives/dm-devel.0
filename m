Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9724518A6D4
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 13:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887643; cv=none; b=UlJzVuEP21P3hltatApceW65GlcENQXnuHP+oTbdq5Jw7NiE+ITQ6mcJ32KIOyKnLYooTXOEVrxaEniWjHqJH1lS7GApLh7x4gYC376FGyKpjGdTZ2ifHvhHinyL+9iFlSD+5p4YM9u+kbfcefIykiTGI2SFfadu3ZZHldZTlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887643; c=relaxed/simple;
	bh=FfLb3rA5XGBA65wlFPPJopeBlH5Py8JhkIXEmEwE9eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgGN00Wou81xw0aI4J5HeHVbfVgGWpyvWOVSzN2hS1GXUbPskpNz3ITW5kiLm2e95ahudREadMIRwJ5k7Qt+RYKjRbLh7NF7fjmmQgZejzHIsAgqTUGwzbN3+v8wCVyIKNTVBg4Glh2CmOjXhpC6lDppcpZD26SECfB2YNNhaLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E7uvayCt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NKHZfHKd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E7uvayCt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NKHZfHKd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E7uvayCt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NKHZfHKd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E7uvayCt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NKHZfHKd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 773AF6B8CB;
	Wed, 27 May 2026 13:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779887639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TAKhRtYczHQd8gte47AQbM2I+m6LM6sbfN7jprck2OY=;
	b=E7uvayCtjpNORxAv8MYsuX9DHA0SMKILQQxhduaBTCDrlCotzalVfKvHDT1oSnz6yOFMAP
	4XOLbgXDcmsI3z51Q+tqiblSFL7fzZhSo0gbVOej9sFr9r1HK8KIx/3Z9tklGC32EEdY94
	ELWz1Bqwv8rmLV2OL9O1BFSzKdpNxBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779887639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TAKhRtYczHQd8gte47AQbM2I+m6LM6sbfN7jprck2OY=;
	b=NKHZfHKd0yUlKmCGPgy5KpX/xgf9gM0BZ7BijyYk4mbjriWCjI8S+GAZtyJZzSUVWyrLvF
	3XtaOIvkKcdI6RAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779887639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TAKhRtYczHQd8gte47AQbM2I+m6LM6sbfN7jprck2OY=;
	b=E7uvayCtjpNORxAv8MYsuX9DHA0SMKILQQxhduaBTCDrlCotzalVfKvHDT1oSnz6yOFMAP
	4XOLbgXDcmsI3z51Q+tqiblSFL7fzZhSo0gbVOej9sFr9r1HK8KIx/3Z9tklGC32EEdY94
	ELWz1Bqwv8rmLV2OL9O1BFSzKdpNxBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779887639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TAKhRtYczHQd8gte47AQbM2I+m6LM6sbfN7jprck2OY=;
	b=NKHZfHKd0yUlKmCGPgy5KpX/xgf9gM0BZ7BijyYk4mbjriWCjI8S+GAZtyJZzSUVWyrLvF
	3XtaOIvkKcdI6RAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52A175A847;
	Wed, 27 May 2026 13:13:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 65azExfuFmqyGAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 13:13:59 +0000
Message-ID: <c03305cd-5408-4b28-bcab-a43a566ce6ef@suse.de>
Date: Wed, 27 May 2026 15:13:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
To: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <20260522164415.846589-1-mwilck@suse.com>
 <20260522164415.846589-10-mwilck@suse.com>
 <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
 <f4188f6ac60be14ca4ee325f776a89184e7ef01a.camel@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <f4188f6ac60be14ca4ee325f776a89184e7ef01a.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On 5/27/26 12:11, Martin Wilck wrote:
> On Wed, 2026-05-27 at 11:40 +0200, Hannes Reinecke wrote:
>> On 5/22/26 18:44, Martin Wilck wrote:
>>> Use shared_ptr to track the runner_context refcount.
>>>
>>> Signed-off-by: Martin Wilck <mwilck@suse.com>
>>> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>>> ---
>>>    libmpathutil/runner.c | 30 +++++++++---------------------
>>>    1 file changed, 9 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
>>> index 8c6d6b9..56abd03 100644
>>> --- a/libmpathutil/runner.c
>>> +++ b/libmpathutil/runner.c
>>> @@ -30,7 +30,6 @@ const char *runner_state_name(int state)
>>>    }
>>>    
>>>    struct runner_context {
>>> -	int refcount;
>>>    	int status;
>>>    	struct timespec deadline;
>>>    	pthread_t thr;
>>> @@ -39,17 +38,6 @@ struct runner_context {
>>>    	char __attribute__((aligned(sizeof(void *)))) data[];
>>>    };
>>>    
>>> -static void release_context(struct runner_context *rctx)
>>> -{
>>> -	int n;
>>> -
>>> -	n = uatomic_sub_return(&rctx->refcount, 1);
>>> -	assert(n >= 0);
>>> -
>>> -	if (n == 0)
>>> -		free(rctx);
>>> -}
>>> -
>>>    static void cleanup_context(struct runner_context **prctx)
>>>    {
>>>    	struct runner_context *rctx = *prctx;
>>> @@ -65,7 +53,7 @@ static void cleanup_context(struct runner_context
>>> **prctx)
>>>    			"%s: runner %p finished in state '%s'",
>>> __func__, rctx,
>>>    			runner_state_name(st));
>>>    	}
>>> -	release_context(rctx);
>>> +	put_shared_ptr(rctx);
>>>    }
>>>    
>>>    static void *runner_thread(void *arg)
>>> @@ -147,7 +135,7 @@ repeat:
>>>    void release_runner(struct runner_context *rctx)
>>>    {
>>>    	cancel_runner(rctx);
>>> -	release_context(rctx);
>>> +	put_shared_ptr(rctx);
>>>    }
>>>    
>>>    int check_runner(struct runner_context *rctx, void *data,
>>> unsigned int size)
>>> @@ -195,17 +183,17 @@ struct runner_context *get_runner(runner_func
>>> func, void *data,
>>>    		return NULL;
>>>    	}
>>>    
>>> -	rctx = malloc(sizeof(*rctx) + size);
>>> +	rctx = alloc_shared_ptr(sizeof(*rctx) + size, NULL);
>>>    	if (!rctx)
>>>    		return NULL;
>>>    
>>>    	rctx->func = func;
>>>    	/*
>>> -	 * We have to set the refcount to 2 here. The runner
>>> thread may be
>>> -	 * cancelled before it even had the chance to increase the
>>> refcount,
>>> -	 * which could result in a use-after-free in
>>> cleanup_context().
>>> +	 * Take an additional reference here. The runner thread
>>> may be
>>> +	 * cancelled before it even had the chance to take a
>>> reference, which
>>> +	 * could result in a use-after-free in cleanup_context().
>>>    	 */
>>> -	uatomic_set(&rctx->refcount, 2);
>>> +	get_shared_ptr(rctx);
>>>    	uatomic_set(&rctx->status, RUNNER_IDLE);
>>>    	memcpy(rctx->data, data, size);
>>>    
>>> @@ -222,8 +210,8 @@ struct runner_context *get_runner(runner_func
>>> func, void *data,
>>>    
>>>    	if (rc) {
>>>    		condlog(1, "%s: pthread_create(): %s", __func__,
>>> strerror(rc));
>>> -		uatomic_dec(&rctx->refcount);
>>> -		release_context(rctx);
>>> +		put_shared_ptr(rctx);
>>> +		put_shared_ptr(rctx);
>>>    		return NULL;
>>>    	}
>>>    	return rctx;
>>
>> Hmm. While I fully get the idea why one would want to use refcounted
>> objects, there really is only one snag: this is multipath.
>> We really, _really_, should make sure the daemon can execute even if
>> the root filesystem is not available.
>> So if we start dropping the reference for the checker (eg if the last
>> path drops and the checker is no longer used), we might end up
>> freeing
>> the memory (and dropping the modules altogether).
> 
> I am pretty sure that we handle this correctly. The current patch set
> doesn't change anything in this respect, except translating the hard-
> coded refcounting into the shared_ptr framework.
> 
>> But if the path comes back we need to reinstate the checker, which
>> not
>> only requires additional memory (which might need a recursion into
>> the
>> filesystem to get free pages) but we also might need to read the
>> checker
>> module from disk (again). So plenty of opportunity to deaslock
>> waithing
>> for the disk be become readable.
> 
> In checker_get(), we call add_checker_class() if the class is not yet
> loaded, which will take one ref on the class, and then get_shared_ptr()
> for every path (including the one for which add_checker_class() had
> been called), which means we have (number of paths + 1) references on
> the class, and will only drop the last ref when multipathd calls
> cleanup_checkers() during exit.
> 
> Therefore I don't think it's possible that we unload the shared library
> prematurely, and have to reload it later.
> 
Hmm.

Really hmmmmm.

If the checkers are loaded during startup, and unloaded on shutdown,
there really is no point in refcounting them, is there?
Wouldn't global pointers to each check sufficient here, avoiding
the need for refcounting altogether?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
