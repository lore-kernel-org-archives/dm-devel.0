Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F7839F193
	for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 10:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776335633; cv=none; b=cXl+PEQCX99W/IY1uakX4oVHoIK771JJ68j7OAFYoSjJmgI/SG2ZWQdiGQsCLBpqmyNdKQvZfmVw0dMjqekqBDYYv2qtYW+3+evFrb1+sBgVlvoalQX3wiLhiDTj1T1gdHsjWbXTHgmF+sxo4xCSBrHYmT8FpQz/FWw3jXDEDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776335633; c=relaxed/simple;
	bh=PnkhtnPlWqR69u9/G7kOgPwF0gnYlgcUF1nrMIPg0fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVCRFyPgAtEZyuMb6Wrtn+9JMHmdMDuxZ8pcgEuEbVOJIA8NawHSUnnvs1xHUP1E5mGJHBLkEoC5l1YbFC2ToRocllsktoQvu6bRKwIEaDPfcDCUZwDHu4mu+yuNep1eBdhB9v8ESr9QLNgQibJ1uEi7dDk2W5g9293SilDXKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kd0BqUTD; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kd0BqUTD"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a041eae5so58285465e9.1
        for <dm-devel@lists.linux.dev>; Thu, 16 Apr 2026 03:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776335627; x=1776940427; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PFX0kfy1JVc6bVB6CE0bGMq+YH6jFLY5/9CO0YM6hrU=;
        b=Kd0BqUTDxKwNzLOQUgyK+cM6EAEYYimYCxRRrvC8egXLfTmhu0vRCJh+XxhMpPg8Mu
         KKIuaqQog+ruCMtOly9fz28XlFMCirhO0pECF50WCZ81bKqFPbjbqGhtPdqzIq467U6h
         WknkSgIJTS/y4dbewmSvNuRgrk8yR4m6t0XxZG5EbWXzYfATjKC8FqGRuiJDXzT4xCH+
         R+hxLPRfP0bHolo0jOCjpsckjAY5YnBEPWhNJkEQeukgInZp2uXKkDG/12cbnIkaIu7/
         Yaolt1Az+c5fS7Ob3Xwo3FRctNyZox3wpRHyBPf/Y8Hg7XYRMA/rGwD6564QC7GyqsqC
         BLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335627; x=1776940427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFX0kfy1JVc6bVB6CE0bGMq+YH6jFLY5/9CO0YM6hrU=;
        b=EFDoxybLqOWe3kzVhoofwldmBQc+S8huAhpwIzBz1aXkL2cuNKWzXS8AJolnL8ezJc
         Lzxl8drrXoxvMizrey/sU+gMkHvBVlpZw3PITT7qsXcIK/yS6hAVJpIgvUUUyfOBdIOE
         IwoKV1gxAODVVRiZiUpDETe25kSh2TFmguY3FRhAWvGpWxWEH05OKSP2slsfWoVriZn5
         LzdtTUmdLtosV43NhWSnMMoYnRtXoDOQXFxddoIw+1nbHOgtpUU86puGr0mwpKHk6jBX
         6XNP6idrsT3TXjdiq5Igp8At/pNu8QW0JKU3RxZcZMGBvL2GZuMq13yePkoZEVC8isaH
         aSXA==
X-Forwarded-Encrypted: i=1; AFNElJ9KBRnmI0Y/HgATlF9Fc2XbeYOxvweba3q5dL6bPwwIMajRxq2uAEsfISv+JR+r7XXU9MZLMsWHMw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4zdKjA6j/mxObUcE+PO0kLbYfT/K2gO0rHJhnlpGXEmxnPK23
	HRahLKk9LZoBL41ZYoQQwqM/ELfd1D3I1QUpz9owTeTdyljrb3ZqsZqdbBBLaF39DZE=
X-Gm-Gg: AeBDiesAgXn72eiYaHV70l/R2MFgMi2T6H8dokyUPqmoTRsaZI1MnsGYCykryGAadrd
	H1VU4Ty2YZykw2x2ipBkDm5GltA/dGw+oTNxljwafFVCjFseLKjVV2X4WfH5FSsdDUBrFmF5yMB
	hH8yC0+JlJ44b22Kiwp6Bg2HvnRAGkRC99bV7tm0QDdq2piuMubmjIaUNYRi/wPxO9FMuGPiMc0
	wyBnKU78yH6y73r81sgDxddE2gYH+LVEH9GfDzFjI+jLU2kZgda1VuFjkwTLjmC5ybUa5T2fMmK
	FPnUH/b39Za9KLYgK7g1MFBVuWCfbaRZeEbogPDIUxVR/fc49l6jz9g3qwYo4QhExWk9Klzp4c0
	R9eXiMY/W6x2QWT5GGZzXOr++RpkXrqDo7c43Ixso3MzYk9NkpDoavpDUDnZrkv2+hGQs75+ut+
	UF85rLC2/VVxejz1yLwO9bvkXA7w==
X-Received: by 2002:a05:600c:3b96:b0:488:b098:b653 with SMTP id 5b1f17b1804b1-488d67f0a8amr350880245e9.13.1776335626808;
        Thu, 16 Apr 2026 03:33:46 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead402ee8sm12369872f8f.37.2026.04.16.03.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 03:33:46 -0700 (PDT)
Date: Thu, 16 Apr 2026 12:33:43 +0200
From: Petr Mladek <pmladek@suse.com>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
	sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mhiramat@kernel.org, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aeC7ByGA5MHBcGQR@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>

On Wed 2026-04-15 15:01:37, chensong_2000@189.cn wrote:
> From: Song Chen <chensong_2000@189.cn>
> 
> The current notifier chain implementation uses a single-linked list
> (struct notifier_block *next), which only supports forward traversal
> in priority order. This makes it difficult to handle cleanup/teardown
> scenarios that require notifiers to be called in reverse priority order.
> 
> A concrete example is the ordering dependency between ftrace and
> livepatch during module load/unload. see the detail here [1].
> 
> This patch replaces the single-linked list in struct notifier_block
> with a struct list_head, converting the notifier chain into a
> doubly-linked list sorted in descending priority order. Based on
> this, a new function notifier_call_chain_reverse() is introduced,
> which traverses the chain in reverse (ascending priority order).
> The corresponding blocking_notifier_call_chain_reverse() is also
> added as the locking wrapper for blocking notifier chains.
> 
> The internal notifier_call_chain_robust() is updated to use
> notifier_call_chain_reverse() for rollback: on error, it records
> the failing notifier (last_nb) and the count of successfully called
> notifiers (nr), then rolls back exactly those nr-1 notifiers in
> reverse order starting from last_nb's predecessor, without needing
> to know the total length of the chain.
> 
> With this change, subsystems with symmetric setup/teardown ordering
> requirements can register a single notifier_block with one priority
> value, and rely on blocking_notifier_call_chain() for forward
> traversal and blocking_notifier_call_chain_reverse() for reverse
> traversal, without needing hard-coded call sequences or separate
> notifier registrations for each direction.
> 
> [1]:https://lore.kernel.org/all
> 	/alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/
> 
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -53,41 +53,41 @@ typedef	int (*notifier_fn_t)(struct notifier_block *nb,
[...]
>  struct notifier_block {
>  	notifier_fn_t notifier_call;
> -	struct notifier_block __rcu *next;
> +	struct list_head __rcu entry;
>  	int priority;
>  };
[...]
>  #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
>  		spin_lock_init(&(name)->lock);	\
> -		(name)->head = NULL;		\
> +		INIT_LIST_HEAD(&(name)->head);		\

I would expect the RCU variant here, aka INIT_LIST_HEAD_RCU().

> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -14,39 +14,47 @@
>   *	are layered on top of these, with appropriate locking added.
>   */
>  
> -static int notifier_chain_register(struct notifier_block **nl,
> +static int notifier_chain_register(struct list_head *nl,
>  				   struct notifier_block *n,
>  				   bool unique_priority)
>  {
> -	while ((*nl) != NULL) {
> -		if (unlikely((*nl) == n)) {
> +	struct notifier_block *cur;
> +
> +	list_for_each_entry(cur, nl, entry) {
> +		if (unlikely(cur == n)) {
>  			WARN(1, "notifier callback %ps already registered",
>  			     n->notifier_call);
>  			return -EEXIST;
>  		}
> -		if (n->priority > (*nl)->priority)
> -			break;
> -		if (n->priority == (*nl)->priority && unique_priority)
> +
> +		if (n->priority == cur->priority && unique_priority)
>  			return -EBUSY;
> -		nl = &((*nl)->next);
> +
> +		if (n->priority > cur->priority) {
> +			list_add_tail(&n->entry, &cur->entry);
> +			goto out;
> +		}
>  	}
> -	n->next = *nl;
> -	rcu_assign_pointer(*nl, n);
> +
> +	list_add_tail(&n->entry, nl);

I would expect list_add_tail_rcu() here.

> @@ -59,25 +67,25 @@ static int notifier_chain_unregister(struct notifier_block **nl,
>   *			value of this parameter is -1.
>   *	@nr_calls:	Records the number of notifications sent. Don't care
>   *			value of this field is NULL.
> + *	@last_nb:  Records the last called notifier block for rolling back
>   *	Return:		notifier_call_chain returns the value returned by the
>   *			last notifier function called.
>   */
> -static int notifier_call_chain(struct notifier_block **nl,
> +static int notifier_call_chain(struct list_head *nl,
>  			       unsigned long val, void *v,
> -			       int nr_to_call, int *nr_calls)
> +			       int nr_to_call, int *nr_calls,
> +				   struct notifier_block **last_nb)
>  {
>  	int ret = NOTIFY_DONE;
> -	struct notifier_block *nb, *next_nb;
> -
> -	nb = rcu_dereference_raw(*nl);
> +	struct notifier_block *nb;
>  
> -	while (nb && nr_to_call) {
> -		next_nb = rcu_dereference_raw(nb->next);
> +	if (!nr_to_call)
> +		return ret;
>  
> +	list_for_each_entry(nb, nl, entry) {

I would expect the RCU variant here, aka list_for_each_rcu()

These are just two random examples which I found by a quick look.

I guess that the notifier API is very old and it does not use all
the RCU API features which allow to track safety when
CONFIG_PROVE_RCU and CONFIG_PROVE_RCU_LIST are enabled.

It actually might be worth to audit the code and make it right.

>  #ifdef CONFIG_DEBUG_NOTIFIERS
>  		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
>  			WARN(1, "Invalid notifier called!");
> -			nb = next_nb;
>  			continue;
>  		}
>  #endif

That said, I am not sure if the ftrace/livepatching handlers are
the right motivation for this. Especially when I see the
complexity of the 2nd patch [*]

After thinking more about it. I am not even sure that the ftrace and
livepatching callbacks are good candidates for generic notifiers.
They are too special. It is not only about ordering them against
each other. But it is also about ordering them against other
notifiers. The ftrace/livepatching callbacks must be the first/last
during module load/release.

[*] The 2nd patch is not archived by lore for some reason.
    I have found only a review but it gives a good picture, see
    https://lore.kernel.org/all/1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com/

Best Regards,
Petr
