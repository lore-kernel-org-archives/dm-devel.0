Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0D13B9D86
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 09:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779874102; cv=none; b=mCKTtmpmqgv5ltJSyom6cRS7ukVLn358rEcPiF5rGcwKCpHZUk0dITqgAfh4T49qezAFBmvAKzo8fvMdNED1a+EK0hVrbXTi0o9arkoKg66Svmmq+svL3JGJxi6u7cUcB9rzLKmL7onSrWdKVtiDtNYfnNfvNvPjTl6N4+32D8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779874102; c=relaxed/simple;
	bh=pG+/Qj/4NXm5ActcW/qp0C47nrn5cFUBxa2hzSfS/1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gBUk6fgcssX01e0jgY5yHizZXWWf8vGO2y0dDqVza4Ax1J7EGE1Al0xaAf46puceH+L6+WT+rHu8mhMfVJVRCQmrYFYzjHVOJfCs7Ex3ysrHL2gO5G/9QeeiAMeYTpxXLxHwmNdDOh7pWWQPg/b3eHe4H/tQ1oA+NL8bkhR8o5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L1INOu0h; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0P2GtVWp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TWjNQT/Q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tmwse2Cf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L1INOu0h";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0P2GtVWp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TWjNQT/Q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tmwse2Cf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18A656A8FF;
	Wed, 27 May 2026 09:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779874099; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaBcr4maZpmdLTKHQiPP6JEa9AtwCsoVUbB6XK7zfNA=;
	b=L1INOu0hQBIs7iOE9wKEU4/jVbMLq5zezgL2m3vbyJtccR7OmuuDI6h9J6hB9pPB232Fi8
	fHuIn8dhfPFJVRY4oS224Gqk8trQNOFLtedSt10mj8M1b4hjrBz3G6siyTzHsxd/QSbhP+
	5vuctKioeXDUKP4JjTC76kBuq/RZnpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779874099;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaBcr4maZpmdLTKHQiPP6JEa9AtwCsoVUbB6XK7zfNA=;
	b=0P2GtVWpKb1pjrZlIf6Ip9BpCx2LvkN+bRlQeF9ObvA70+6nJhqecEP07xwm8ccJJaEM+o
	650i0mq+olcn5zDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779874098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaBcr4maZpmdLTKHQiPP6JEa9AtwCsoVUbB6XK7zfNA=;
	b=TWjNQT/QXakKCw1iVV8hAE6TsMPO8C+fhWDU/2j0wQ9s9JYwExzG4aSNqJojPK4h3qdRuX
	cQFUbm7O5zpG0uH6E7BifglUQ8UKGO1IRgHKnZ5gsh1bGAJW04eFeXr3vf4GLgvms48Vrz
	fpVlAw4EbQOlWKa5KWUwmLSql88cRhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779874098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaBcr4maZpmdLTKHQiPP6JEa9AtwCsoVUbB6XK7zfNA=;
	b=tmwse2CfllPfxt0rpFz/ejUSmm2w5gkpqH0+EDLOyaLHA4C+nyZentL5v+cRQe16Zp0ms+
	AqzRR03bRYMgcGBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E87275A76B;
	Wed, 27 May 2026 09:28:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J2w9ODG5FmqQLwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 09:28:17 +0000
Message-ID: <b4bfe78c-3a19-4702-a663-2735f86d4a56@suse.de>
Date: Wed, 27 May 2026 11:28:17 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/19] libmpathutil: add implementation of generic
 shared pointer
To: Martin Wilck <martin.wilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
 <20260522164415.846589-5-mwilck@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260522164415.846589-5-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On 5/22/26 18:44, Martin Wilck wrote:
> Add a set of simple functions to handle refcounted pointers.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   libmpathutil/libmpathutil.version |  7 +++++
>   libmpathutil/util.c               | 45 ++++++++++++++++++++++++++++---
>   libmpathutil/util.h               |  5 ++++
>   3 files changed, 53 insertions(+), 4 deletions(-)
> 
That really looks like the Hazard pointers from Paul McK and Mathieu 
Desnoyers. Maybe have a look and see if you cannot re-use the
approach here.

> diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
> index c69120d..51594ad 100644
> --- a/libmpathutil/libmpathutil.version
> +++ b/libmpathutil/libmpathutil.version
> @@ -194,3 +194,10 @@ global:
>   local:
>   	*;
>   };
> +
> +LIBMPATHUTIL_6.1 {
> +global:
> +	alloc_shared_ptr;
> +	get_shared_ptr;
> +	put_shared_ptr;
> +} LIBMPATHUTIL_6.0;
> diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> index 23a9797..3c623ec 100644
> --- a/libmpathutil/util.c
> +++ b/libmpathutil/util.c
> @@ -12,15 +12,13 @@
>   #include <dirent.h>
>   #include <unistd.h>
>   #include <errno.h>
> +#include <urcu/uatomic.h>
>   #include "mt-udev-wrap.h"
>   
>   #include "util.h"
>   #include "debug.h"
> -#include "checkers.h"
>   #include "vector.h"
> -#include "structs.h"
> -#include "config.h"
> -#include "log.h"
> +#include "list.h"
>   
>   size_t
>   strchop(char *str)
> @@ -384,3 +382,42 @@ void cleanup_udev_device(struct udev_device **udd)
>   	if (*udd)
>   		udev_device_unref(*udd);
>   }
> +
> +struct shared_ptr {
> +	long refcnt;
> +	void (*destructor)(void *);
> +	char __attribute__((aligned(sizeof(void *)))) ptr[];
> +};
> +
> +void *alloc_shared_ptr(size_t size, void (*destructor)(void *))
> +{
> +	struct shared_ptr *sp = malloc(sizeof(*sp) + size);
> +
> +	if (!sp)
> +		return NULL;
> +	uatomic_set(&sp->refcnt, 1);
> +	sp->destructor = destructor;
> +	return sp->ptr;
> +}
> +
> +void get_shared_ptr(void *ptr)
> +{
> +	struct shared_ptr *sp = container_of(ptr, struct shared_ptr, ptr);
> +
> +	if (uatomic_add_return(&sp->refcnt, 1) < 0)
> +		condlog(0, "%s: refcount overflow", __func__);
> +}
> +
> +void put_shared_ptr(void *ptr)
> +{
> +	struct shared_ptr *sp;
> +
> +	if (!ptr)
> +		return;
> +	sp = container_of(ptr, struct shared_ptr, ptr);
> +	if (uatomic_sub_return(&sp->refcnt, 1) == 0) {
> +		if (sp->destructor)
> +			sp->destructor(ptr);
> +		free(sp);
> +	}
> +}

I _think_ the could be implemented better using RCU primitives;
in the end, what you really care about is whether the pointer is
valid (9which is what RCU provides).
Or indeed use the hazard pointer approach, and count the number
of RCU references to that object ...

> diff --git a/libmpathutil/util.h b/libmpathutil/util.h
> index aed1bc1..ffbb182 100644
> --- a/libmpathutil/util.h
> +++ b/libmpathutil/util.h
> @@ -160,4 +160,9 @@ void cleanup_charp(char **p);
>   void cleanup_ucharp(unsigned char **p);
>   void cleanup_udev_device(struct udev_device **udd);
>   void cleanup_bitfield(union bitfield **p);
> +
> +void *alloc_shared_ptr(size_t size, void (*destructor)(void *));
> +void get_shared_ptr(void *ptr);
> +void put_shared_ptr(void *ptr);
> +
>   #endif /* UTIL_H_INCLUDED */

... or just leave it as it is if the approach is to complex.
I doubt it's time-critical.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
