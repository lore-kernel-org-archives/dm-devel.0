Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5511F16B
	for <dm-devel@lists.linux.dev>; Sun, 26 Apr 2026 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777213688; cv=none; b=B7j152IJ7qv7Q9RSCUQ7vnqqvpWeo69tXZ6AQuW64/19rT5vPvdyrgR6YIq0cft/VGdS3EI3t92BYJkFZbtHb6OHtZeh2wL4RqtE9uYxBu9hmZoiHxFpDYcmwN8nFfpBgFaZGdFoGMu4ldDiUwS4HEC9vGBqQjDcvcs4ev8HwyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777213688; c=relaxed/simple;
	bh=+bORunN9DihtZKlWmsbyAGvFX7FDw4aL3SCDlhq8TbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpwFCHlxAJp8ZxwGsDNO6QEb+vtdn3Ea0cg8nWRlVU7JfpsJd5Pk2AXZ0A2es4zCmNyF5vARUNj3gDfP5NfF7kYVEc4Xzn8TL5L0fQr0i2cMDenzD1nn+elL8E3YhZ0huRRv7415MdcA8+DqvzW0etMdssg1RD2L/9XWezCFejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=GJr6WW1F; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="GJr6WW1F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=E9QmRybu2HwGPax/8gg8zi6sH9jkn1UXfiltYEM9caY=;
	b=GJr6WW1FFj6/yFQO/D5b9Z35SC7l1yTBhxhkj4vkJEDWXnmtfwNBf1YT1GYzae
	P0Gt/eizsqh6vY6sMw6Mw1boLItuuLSQUjjE1+H0HF3nkXamKKPRxDHvIBIeT+aq
	TIDE6L1lz40dD6JtPB2Ok5ChCODfw8DCkX8wZ/USbRfTA=
Received: from [IPV6:2408:8210:480a:2590:ec66:74e8:68a7:a44b] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3lxKMIO5pdslVAQ--.7227S2;
	Sun, 26 Apr 2026 22:26:22 +0800 (CST)
Message-ID: <c646232a-f2bf-439a-88c9-737dde9b1725@126.com>
Date: Sun, 26 Apr 2026 22:26:20 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] kernel/module: Decouple klp and ftrace from
 load_module
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>, rafael@kernel.org, lenb@kernel.org,
 mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, paulmck@kernel.org, frederic@kernel.org,
 mcgrof@kernel.org, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org, live-patching@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 kgdb-bugreport@lists.sourceforge.net, netdev@vger.kernel.org
References: <20260413080701.180976-1-chensong_2000@189.cn>
 <1191caf5-6a61-4622-a15e-854d3701f4fc@suse.com>
 <a35f5f94-7d5a-4347-974b-b270c89ef241@189.cn>
 <1db425bf-58a9-4768-8c38-3ae25d7662a5@suse.com>
 <aeD2_FrFL6E3dbAC@pathway.suse.cz>
 <20260420112707.aa3627ca9f975eeaf7d8ea0e@kernel.org>
Content-Language: en-US
From: Song Chen <chensong_2000@126.com>
In-Reply-To: <20260420112707.aa3627ca9f975eeaf7d8ea0e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3lxKMIO5pdslVAQ--.7227S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3JrW8Wry8Gr4xKw15uFy3Jwb_yoW3GFWDpF
	9xWF17Gr4DXr9rCa1Ivw1UZr17K34UGr4jqr15GFyxGryqyFn7JFy8Gr109FykJrWkZry2
	qr4UAry7A345JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UG-eOUUUUU=
X-CM-SenderInfo: xfkh02prqjsjqqqqqiyswou0bp/xtbBsw5BwGnuII7qoQAA3e

Hi,


On 4/20/26 10:27, Masami Hiramatsu (Google) wrote:
> On Thu, 16 Apr 2026 16:49:32 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
>> On Thu 2026-04-16 13:18:30, Petr Pavlu wrote:
>>> On 4/15/26 8:43 AM, Song Chen wrote:
>>>> On 4/14/26 22:33, Petr Pavlu wrote:
>>>>> On 4/13/26 10:07 AM, chensong_2000@189.cn wrote:
>>>>>> diff --git a/include/linux/module.h b/include/linux/module.h
>>>>>> index 14f391b186c6..0bdd56f9defd 100644
>>>>>> --- a/include/linux/module.h
>>>>>> +++ b/include/linux/module.h
>>>>>> @@ -308,6 +308,14 @@ enum module_state {
>>>>>>        MODULE_STATE_COMING,    /* Full formed, running module_init. */
>>>>>>        MODULE_STATE_GOING,    /* Going away. */
>>>>>>        MODULE_STATE_UNFORMED,    /* Still setting it up. */
>>>>>> +    MODULE_STATE_FORMED,
>>>>>
>>>>> I don't see a reason to add a new module state. Why is it necessary and
>>>>> how does it fit with the existing states?
>>>>>
>>>> because once notifier fails in state MODULE_STATE_UNFORMED (now only ftrace has someting to do in this state), notifier chain will roll back by calling blocking_notifier_call_chain_robust, i'm afraid MODULE_STATE_GOING is going to jeopardise the notifers which don't handle it appropriately, like:
>>>>
>>>> case MODULE_STATE_COMING:
>>>>       kmalloc();
>>>> case MODULE_STATE_GOING:
>>>>       kfree();
>>>
>>> My understanding is that the current module "state machine" operates as
>>> follows. Transitions marked with an asterisk (*) are announced via the
>>> module notifier.
>>>
>>> ---> UNFORMED --*> COMING --*> LIVE --*> GOING -.
>>>          ^            |                     ^    |
>>>          |            '---------------------*    |
>>>          '---------------------------------------'
>>>
>>> The new code aims to replace the current ftrace_module_init() call in
>>> load_module(). To achieve this, it adds a notification for the UNFORMED
>>> state (only when loading a module) and introduces a new FORMED state for
>>> rollback. FORMED is purely a fake state because it never appears in
>>> module::state. The new structure is as follows:
>>>
>>>          ,--*> (FORMED)
>>>          |
>>> --*> UNFORMED --*> COMING --*> LIVE --*> GOING -.
>>>          ^            |                     ^    |
>>>          |            '---------------------*    |
>>>          '---------------------------------------'
>>>
>>> I'm afraid this is quite complex and inconsistent. Unless it can be kept
>>> simple, we would be just replacing one special handling with a different
>>> complexity, which is not worth it.
>>
>>>>>
>>>>>> +    if (err)
>>>>>> +        goto ddebug_cleanup;
>>>>>>          /* Finally it's fully formed, ready to start executing. */
>>>>>>        err = complete_formation(mod, info);
>>>>>> -    if (err)
>>>>>> +    if (err) {
>>>>>> +        blocking_notifier_call_chain_reverse(&module_notify_list,
>>>>>> +                MODULE_STATE_FORMED, mod);
>>>>>>            goto ddebug_cleanup;
>>>>>> +    }
>>>>>>    -    err = prepare_coming_module(mod);
>>>>>> +    err = prepare_module_state_transaction(mod,
>>>>>> +                MODULE_STATE_COMING, MODULE_STATE_GOING);
>>>>>>        if (err)
>>>>>>            goto bug_cleanup;
>>>>>>    @@ -3522,7 +3519,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>>>>>        destroy_params(mod->kp, mod->num_kp);
>>>>>>        blocking_notifier_call_chain(&module_notify_list,
>>>>>>                         MODULE_STATE_GOING, mod);
>>>>>
>>>>> My understanding is that all notifier chains for MODULE_STATE_GOING
>>>>> should be reversed.
>>>> yes, all, from lowest priority notifier to highest.
>>>> I will resend patch 1 which was failed due to my proxy setting.
>>>
>>> What I meant here is that the call:
>>>
>>> blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING, mod);
>>>
>>> should be replaced with:
>>>
>>> blocking_notifier_call_chain_reverse(&module_notify_list, MODULE_STATE_GOING, mod);
>>>
>>>>
>>>>>
>>>>>> -    klp_module_going(mod);
>>>>>>     bug_cleanup:
>>>>>>        mod->state = MODULE_STATE_GOING;
>>>>>>        /* module_bug_cleanup needs module_mutex protection */
>>>>>
>>>>> The patch removes the klp_module_going() cleanup call in load_module().
>>>>> Similarly, the ftrace_release_mod() call under the ddebug_cleanup label
>>>>> should be removed and appropriately replaced with a cleanup via
>>>>> a notifier.
>>>>>
>>>>      err = prepare_module_state_transaction(mod,
>>>>                  MODULE_STATE_UNFORMED, MODULE_STATE_FORMED);
>>>>      if (err)
>>>>          goto ddebug_cleanup;
>>>>
>>>> ftrace will be cleanup in blocking_notifier_call_chain_robust rolling back.
>>>>
>>>>      err = prepare_module_state_transaction(mod,
>>>>                  MODULE_STATE_COMING, MODULE_STATE_GOING);
>>>>
>>>> each notifier including ftrace and klp will be cleanup in blocking_notifier_call_chain_robust rolling back.
>>>>
>>>> if all notifiers are successful in MODULE_STATE_COMING, they all will be clean up in
>>>>   coming_cleanup:
>>>>      mod->state = MODULE_STATE_GOING;
>>>>      destroy_params(mod->kp, mod->num_kp);
>>>>      blocking_notifier_call_chain(&module_notify_list,
>>>>                       MODULE_STATE_GOING, mod);
>>>>
>>>> if  something wrong underneath.
>>>
>>> My point is that the patch leaves a call to ftrace_release_mod() in
>>> load_module(), which I expected to be handled via a notifier.
>>
>> I think that I have got it. The ftrace code needs two notifiers when
>> the module is being loaded and two when it is going.
>>
>> This is why Sond added the new state. But I think that we would
>> need two new states to call:
>>
>>      + ftrace_module_init() in MODULE_STATE_UNFORMED
>>      + ftrace_module_enable() in MODULE_STATE_FORMED
>>
>> and
>>
>>      + ftrace_free_mem() in MODULE_STATE_PRE_GOING
>>      + ftrace_free_mem() in MODULE_STATE_GOING
>>
>>
>> By using the ascii art:
>>
>>   -*> UNFORMED -*> FORMED -> COMING -*> LIVE -*> PRE_GOING -*> GOING -.
>>                |          |         |                ^           ^    ^
>>                |          |         '----------------'           |    |
>>                |          '--------------------------------------'    |
>>                '------------------------------------------------------'
>>
>>
>> But I think that this is not worth it.
> 
> Agree.
> 
> If this needs to be ordered so strictly, why we will use a "single"
> module notifier chain for this complex situation?
> 
> I think the notifier call chain is just for notice a single signal,
> instead of sending several different signals, especially if there is
> any dependency among the callbacks.
> 
> If notification callbacks need to be ordered, they are currently
> sorted by representing priority numerically, but this is quite
> fragile for updating. It has to look up other registered priorities
> and adjust the order among dependencies each time. For this reason,
> this mechanism is not suitable for global ordering. (It's like line
> numbers in BASIC.)
> It is probably only useful for representing dependencies between
> two components maintained by the same maintainer.
> 
> I'm against a general-purpose system that makes everything modular.
> It unnecessarily complicates things. If there are processes that
> require strict ordering, especially processes that must be performed
> before each stage as part of the framework, they should be called
> directly from the framework, not via notification callbacks.
> 
> This makes it simpler and more robust to maintain.
> 
> Only the framework's end users should utilize notification callbacks.
> 
> Thank you,
> 
> 

my motivation is to decouple ftrace and klp from module loader and make 
blocking_notifier_chain more generic, but it doesn't become generic 
completely. I understand your and Petr's comments and agree.

Thanks

Best regards

Song

>>
>> Best Regards,
>> Petr
>>
> 
> 

