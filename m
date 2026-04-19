Received: from mail.189.cn (189sx01-ptr.21cn.com [125.88.204.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616C7322A
	for <dm-devel@lists.linux.dev>; Sun, 19 Apr 2026 00:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=125.88.204.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776557264; cv=none; b=E6LPCkNdeMWrWpva1QbqYtq5ZYIxq89SulPvmPwB8gxJnoXaYzYZxv21GXootCH2hMXyrbZZtF5WOBcGCW81R7fm0DTAEyNM3uxBdNTXEWBeYMHlIjpxL4gZF6cxswIuZ98UPoo3Rgr0ny/w64lwclI0J6uvciySDv/cO3T+JXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776557264; c=relaxed/simple;
	bh=0ipQ/PLQ6jhEKQTcQGumSpMwCnoayW4daignXtWP0L0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMr2bodMVi7TvGwe6jKM/jAtkXfTCr4FAe3+/gs2JIdmT4nEX1mHlZE9u1XQzmY5FaT/J/JTZE7fPlXJATvkISSsg9pxLl/Cv9+XUC71EFFQs1IBItVpLIGOljMXW6JaxiQ4Y2k4hF/U1t64lJH1Hfd2mxuABTletawnMIVloJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn; spf=pass smtp.mailfrom=189.cn; arc=none smtp.client-ip=125.88.204.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=189.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=189.cn
HMM_SOURCE_IP:10.158.243.18:0.362915355
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-60.27.224.181 (unknown [10.158.243.18])
	by mail.189.cn (HERMES) with SMTP id 1BEC840029A;
	Sun, 19 Apr 2026 08:07:30 +0800 (CST)
Received: from  ([60.27.224.181])
	by gateway-153622-dep-76cc7bc9cd-8dbpn with ESMTP id 299ad2dedf004eb4b49ca2003e46e8d1 for pmladek@suse.com;
	Sun, 19 Apr 2026 08:07:33 CST
X-Transaction-ID: 299ad2dedf004eb4b49ca2003e46e8d1
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 60.27.224.181
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <7486bf8e-9713-43ed-af4d-ecefec00c980@189.cn>
Date: Sun, 19 Apr 2026 08:07:27 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
To: Petr Mladek <pmladek@suse.com>
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
 samitolvanen@google.com, atomlin@atomlin.com, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <aeC7ByGA5MHBcGQR@pathway.suse.cz>
Content-Language: en-US
From: Song Chen <chensong_2000@189.cn>
In-Reply-To: <aeC7ByGA5MHBcGQR@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,


On 4/16/26 18:33, Petr Mladek wrote:
> On Wed 2026-04-15 15:01:37, chensong_2000@189.cn wrote:
>> From: Song Chen <chensong_2000@189.cn>
>>
>> The current notifier chain implementation uses a single-linked list
>> (struct notifier_block *next), which only supports forward traversal
>> in priority order. This makes it difficult to handle cleanup/teardown
>> scenarios that require notifiers to be called in reverse priority order.
>>
>> A concrete example is the ordering dependency between ftrace and
>> livepatch during module load/unload. see the detail here [1].
>>
>> This patch replaces the single-linked list in struct notifier_block
>> with a struct list_head, converting the notifier chain into a
>> doubly-linked list sorted in descending priority order. Based on
>> this, a new function notifier_call_chain_reverse() is introduced,
>> which traverses the chain in reverse (ascending priority order).
>> The corresponding blocking_notifier_call_chain_reverse() is also
>> added as the locking wrapper for blocking notifier chains.
>>
>> The internal notifier_call_chain_robust() is updated to use
>> notifier_call_chain_reverse() for rollback: on error, it records
>> the failing notifier (last_nb) and the count of successfully called
>> notifiers (nr), then rolls back exactly those nr-1 notifiers in
>> reverse order starting from last_nb's predecessor, without needing
>> to know the total length of the chain.
>>
>> With this change, subsystems with symmetric setup/teardown ordering
>> requirements can register a single notifier_block with one priority
>> value, and rely on blocking_notifier_call_chain() for forward
>> traversal and blocking_notifier_call_chain_reverse() for reverse
>> traversal, without needing hard-coded call sequences or separate
>> notifier registrations for each direction.
>>
>> [1]:https://lore.kernel.org/all
>> 	/alpine.LNX.2.00.1602172216491.22700@cbobk.fhfr.pm/
>>
>> --- a/include/linux/notifier.h
>> +++ b/include/linux/notifier.h
>> @@ -53,41 +53,41 @@ typedef	int (*notifier_fn_t)(struct notifier_block *nb,
> [...]
>>   struct notifier_block {
>>   	notifier_fn_t notifier_call;
>> -	struct notifier_block __rcu *next;
>> +	struct list_head __rcu entry;
>>   	int priority;
>>   };
> [...]
>>   #define ATOMIC_INIT_NOTIFIER_HEAD(name) do {	\
>>   		spin_lock_init(&(name)->lock);	\
>> -		(name)->head = NULL;		\
>> +		INIT_LIST_HEAD(&(name)->head);		\
> 
> I would expect the RCU variant here, aka INIT_LIST_HEAD_RCU().

I'm not familiar with list rcu, but i will look into it and give it a try.
> 
>> --- a/kernel/notifier.c
>> +++ b/kernel/notifier.c
>> @@ -14,39 +14,47 @@
>>    *	are layered on top of these, with appropriate locking added.
>>    */
>>   
>> -static int notifier_chain_register(struct notifier_block **nl,
>> +static int notifier_chain_register(struct list_head *nl,
>>   				   struct notifier_block *n,
>>   				   bool unique_priority)
>>   {
>> -	while ((*nl) != NULL) {
>> -		if (unlikely((*nl) == n)) {
>> +	struct notifier_block *cur;
>> +
>> +	list_for_each_entry(cur, nl, entry) {
>> +		if (unlikely(cur == n)) {
>>   			WARN(1, "notifier callback %ps already registered",
>>   			     n->notifier_call);
>>   			return -EEXIST;
>>   		}
>> -		if (n->priority > (*nl)->priority)
>> -			break;
>> -		if (n->priority == (*nl)->priority && unique_priority)
>> +
>> +		if (n->priority == cur->priority && unique_priority)
>>   			return -EBUSY;
>> -		nl = &((*nl)->next);
>> +
>> +		if (n->priority > cur->priority) {
>> +			list_add_tail(&n->entry, &cur->entry);
>> +			goto out;
>> +		}
>>   	}
>> -	n->next = *nl;
>> -	rcu_assign_pointer(*nl, n);
>> +
>> +	list_add_tail(&n->entry, nl);
> 
> I would expect list_add_tail_rcu() here.
> 
>> @@ -59,25 +67,25 @@ static int notifier_chain_unregister(struct notifier_block **nl,
>>    *			value of this parameter is -1.
>>    *	@nr_calls:	Records the number of notifications sent. Don't care
>>    *			value of this field is NULL.
>> + *	@last_nb:  Records the last called notifier block for rolling back
>>    *	Return:		notifier_call_chain returns the value returned by the
>>    *			last notifier function called.
>>    */
>> -static int notifier_call_chain(struct notifier_block **nl,
>> +static int notifier_call_chain(struct list_head *nl,
>>   			       unsigned long val, void *v,
>> -			       int nr_to_call, int *nr_calls)
>> +			       int nr_to_call, int *nr_calls,
>> +				   struct notifier_block **last_nb)
>>   {
>>   	int ret = NOTIFY_DONE;
>> -	struct notifier_block *nb, *next_nb;
>> -
>> -	nb = rcu_dereference_raw(*nl);
>> +	struct notifier_block *nb;
>>   
>> -	while (nb && nr_to_call) {
>> -		next_nb = rcu_dereference_raw(nb->next);
>> +	if (!nr_to_call)
>> +		return ret;
>>   
>> +	list_for_each_entry(nb, nl, entry) {
> 
> I would expect the RCU variant here, aka list_for_each_rcu()
> 
> These are just two random examples which I found by a quick look.
> 
> I guess that the notifier API is very old and it does not use all
> the RCU API features which allow to track safety when
> CONFIG_PROVE_RCU and CONFIG_PROVE_RCU_LIST are enabled.
> 
> It actually might be worth to audit the code and make it right.
> 
>>   #ifdef CONFIG_DEBUG_NOTIFIERS
>>   		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
>>   			WARN(1, "Invalid notifier called!");
>> -			nb = next_nb;
>>   			continue;
>>   		}
>>   #endif
> 
> That said, I am not sure if the ftrace/livepatching handlers are
> the right motivation for this. Especially when I see the
> complexity of the 2nd patch [*]
> 
> After thinking more about it. I am not even sure that the ftrace and
> livepatching callbacks are good candidates for generic notifiers.
> They are too special. It is not only about ordering them against
> each other. But it is also about ordering them against other
> notifiers. The ftrace/livepatching callbacks must be the first/last
> during module load/release.
> 
> [*] The 2nd patch is not archived by lore for some reason.
>      I have found only a review but it gives a good picture, see
>      https://lore.kernel.org/all/1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com/
> 
> Best Regards,
> Petr
> 

Thanks.

BR

Song
