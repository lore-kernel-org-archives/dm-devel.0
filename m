Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46E163
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 00:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evoYnH2L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698279332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ayg5mamt8HCVNY+t4GHPswTJfJb2ciVUg3Q8qdqL6WE=;
	b=evoYnH2L4qvXdfmRJsY1lu0xF+4cBJOT+Vbn3g+tju3NDm3XLUjwmh4hcOn2TRxwnO/Q7Y
	bJTdg6DXyWUolBn7ehaphSTYjKVi37IMLKfQU2UaYMldhRWdKwq2niOtiYCjXUWKg71Ns8
	mrYuSOp4hjH/YY1J89UDzxmA59tkXsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-ZTUgufQdONSspqH4lY3m_Q-1; Wed, 25 Oct 2023 20:15:31 -0400
X-MC-Unique: ZTUgufQdONSspqH4lY3m_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18140862DC3
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 00:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 119D140C6F79
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 00:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BED751946595
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 00:15:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB1F3194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 Oct 2023 00:15:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 748802026D66; Thu, 26 Oct 2023 00:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C63E2026D4C
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 00:15:29 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36609185A782
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 00:15:29 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-462-houZlifWNE6owhlpKepPhg-1; Wed,
 25 Oct 2023 20:15:27 -0400
X-MC-Unique: houZlifWNE6owhlpKepPhg-1
Received: from [10.137.106.151] (unknown [131.107.159.23])
 by linux.microsoft.com (Postfix) with ESMTPSA id DC7A120B74C0;
 Wed, 25 Oct 2023 17:15:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC7A120B74C0
Message-ID: <84f25e00-3a3a-419f-baea-50d64a1d5575@linux.microsoft.com>
Date: Wed, 25 Oct 2023 17:15:25 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 3/19] ipe: add evaluation loop
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1696457386-3010-4-git-send-email-wufan@linux.microsoft.com>
 <aa226bdcba26d74304f6c10c290db840.paul@paul-moore.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <aa226bdcba26d74304f6c10c290db840.paul@paul-moore.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> IPE must have a centralized function to evaluate incoming callers
>> against IPE's policy. This iteration of the policy for against the rules
>> for that specific caller is known as the evaluation loop.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/Makefile |  1 +
>>   security/ipe/eval.c   | 96 +++++++++++++++++++++++++++++++++++++++++++
>>   security/ipe/eval.h   | 24 +++++++++++
>>   3 files changed, 121 insertions(+)
>>   create mode 100644 security/ipe/eval.c
>>   create mode 100644 security/ipe/eval.h
> 
> ...
> 
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> new file mode 100644
>> index 000000000000..5533c359bbeb
>> --- /dev/null
>> +++ b/security/ipe/eval.c
>> @@ -0,0 +1,96 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +#include <linux/slab.h>
>> +#include <linux/file.h>
>> +#include <linux/sched.h>
>> +#include <linux/rcupdate.h>
>> +
>> +#include "ipe.h"
>> +#include "eval.h"
>> +#include "policy.h"
>> +
>> +struct ipe_policy __rcu *ipe_active_policy;
>> +
>> +/**
>> + * evaluate_property - Analyze @ctx against a property.
>> + * @ctx: Supplies a pointer to the context to be evaluated.
>> + * @p: Supplies a pointer to the property to be evaluated.
>> + *
>> + * Return:
>> + * * true	- The current @ctx match the @p
>> + * * false	- The current @ctx doesn't match the @p
>> + */
>> +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
>> +			      struct ipe_prop *p)
>> +{
>> +	return false;
>> +}
>> +
>> +/**
>> + * ipe_evaluate_event - Analyze @ctx against the current active policy.
>> + * @ctx: Supplies a pointer to the context to be evaluated.
>> + *
>> + * This is the loop where all policy evaluation happens against IPE policy.
>> + *
>> + * Return:
>> + * * 0		- OK
>> + * * -EACCES	- @ctx did not pass evaluation.
>> + * * !0		- Error
>> + */
>> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>> +{
>> +	bool match = false;
>> +	enum ipe_action_type action;
>> +	struct ipe_policy *pol = NULL;
>> +	const struct ipe_rule *rule = NULL;
>> +	const struct ipe_op_table *rules = NULL;
>> +	struct ipe_prop *prop = NULL;
>> +
>> +	rcu_read_lock();
>> +
>> +	pol = rcu_dereference(ipe_active_policy);
>> +	if (!pol) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +
>> +	if (ctx->op == IPE_OP_INVALID) {
>> +		rcu_read_unlock();
>> +		if (pol->parsed->global_default_action == IPE_ACTION_DENY)
>> +			return -EACCES;
> 
> Assuming that the RCU lock protects @pol, shouldn't it be held until
> after the global_default_action comparison?
> 
Yes for this part the unlock should be moved after the comparison. 
Thanks for spotting this.

>> +		return 0;
>> +	}
>> +
>> +	rules = &pol->parsed->rules[ctx->op];
>> +
>> +	list_for_each_entry(rule, &rules->rules, next) {
>> +		match = true;
>> +
>> +		list_for_each_entry(prop, &rule->props, next) {
>> +			match = match && evaluate_property(ctx, prop);
> 
> The @match variable will always be true on the right side above, or am
> I missing something?
> 
Yes the "match &&" are completely unnecessary. I will remove them.

-Fan
>> +			if (!match)
>> +				break;
>> +		}
>> +
>> +		if (match)
>> +			break;
>> +	}
>> +
>> +	if (match)
>> +		action = rule->action;
>> +	else if (rules->default_action != IPE_ACTION_INVALID)
>> +		action = rules->default_action;
>> +	else
>> +		action = pol->parsed->global_default_action;
>> +
>> +	rcu_read_unlock();
>> +	if (action == IPE_ACTION_DENY)
>> +		return -EACCES;
>> +
>> +	return 0;
>> +}
> 
> --
> paul-moore.com

