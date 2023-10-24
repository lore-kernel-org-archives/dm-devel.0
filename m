Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B9C749E
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="erRTmWkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tJ6cgsoW7aQH5On83YMhoiBwYYPuRYMOz8kgYTAfm70=;
	b=erRTmWkTL0oayCqD00wFKVy82Q0hfjmjCYWGKMlZo5up/mGWxOf3MrU65SUKSpAlUbIZA9
	6FoJXgGjv7oqD+k8H4+jyrgZvB7q+snNURuLN942Yvj/BMGttcJZdl/9xBNHcevlw0+9QH
	S5cusu1s5JLk5Njg8avaDIeN8454XVg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-FlgynP_mMzmpd0XXZ25gQQ-1; Mon, 23 Oct 2023 23:52:29 -0400
X-MC-Unique: FlgynP_mMzmpd0XXZ25gQQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D567980171C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCFED492BD9
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B81561946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E5EF71946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C96FDC1596D; Tue, 24 Oct 2023 03:52:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C20A6C15BB8
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:26 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D17D38143A4
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:26 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-W4dOShJMMv2P_DTooEMp-w-1; Mon, 23 Oct 2023 23:52:24 -0400
X-MC-Unique: W4dOShJMMv2P_DTooEMp-w-1
Received: by mail-qv1-f48.google.com with SMTP id
 6a1803df08f44-66d0ceba445so22204316d6.0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119544; x=1698724344;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tJ6cgsoW7aQH5On83YMhoiBwYYPuRYMOz8kgYTAfm70=;
 b=tzexUV9pQg0YVoNtxxER2FlLX76dScNXkH01pnRjLnHf4bAFB4fWWL2T1U9gmDNf4J
 8n32oxdNulhWJ2EDFqt3nb0SbH5LDszl4UjayUiU68HkXYNnOe9rHEP4cnXfCeiO6DJk
 wuQHs2CaN8D9HoIUSn9tnEPxRe7hzYYXq/iRzf0G9NoA51nvlXs7KfUaAEEbZydtwGe8
 Ge+nRpkS+UCnV27Q0A98qRWo8CZS3dMuISTakRimId596UKV8MM3cjd2dnx8y0EFekK7
 zGKh4MKZTznCNPGEoAnZnIFzg+eK6Zbajj38xOQLVIg/tIrEoWz3QkmPe0IWQaFxhI9N
 FAvg==
X-Gm-Message-State: AOJu0YxbrdP2ZSovIZfEAD/lJzzjs1VVPadQ9Y1ny9HfEuiwndRRUt/J
 Z22s35JSLKItSLwuoHgPWwOo
X-Google-Smtp-Source: AGHT+IEGJExcEmKWOA+GK4RiJy1dG9NUrijjKZKzwgQx3WaST0PHhoK9sXJHymPxgN5Fyv3kt+Yfmg==
X-Received: by 2002:ad4:5cc2:0:b0:66d:169a:d41c with SMTP id
 iu2-20020ad45cc2000000b0066d169ad41cmr11857101qvb.19.1698119543857; 
 Mon, 23 Oct 2023 20:52:23 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 i7-20020a37c207000000b0076db5b792basm3162304qkm.75.2023.10.23.20.52.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:23 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:22 -0400
Message-ID: <aa226bdcba26d74304f6c10c290db840.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 3/19] ipe: add evaluation loop
References: <1696457386-3010-4-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-4-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
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
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE must have a centralized function to evaluate incoming callers
> against IPE's policy. This iteration of the policy for against the rules
> for that specific caller is known as the evaluation loop.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
> + Split evaluation loop, access control hooks, and evaluation loop from policy parser and userspace interface to pass mailing list character limit
> 
> v3:
> + Move ipe_load_properties to patch 04.
> + Remove useless 0-initializations Prefix extern variables with ipe_
> + Remove kernel module parameters, as these are exposed through sysctls.
> + Add more prose to the IPE base config option help text.
> + Use GFP_KERNEL for audit_log_start.
> + Remove unnecessary caching system.
> + Remove comments from headers
> + Use rcu_access_pointer for rcu-pointer null check
> + Remove usage of reqprot; use prot only.
> +Move policy load and activation audit event to 03/12
> 
> v4:
> + Remove sysctls in favor of securityfs nodes
> + Re-add kernel module parameters, as these are now exposed through securityfs.
> + Refactor property audit loop to a separate function.
> 
> v5:
> + fix minor grammatical errors
> + do not group rule by curly-brace in audit record,
> + reconstruct the exact rule.
> 
> v6:
> + No changes
> 
> v7:
> + Further split lsm creation into a separate commit from the evaluation loop and audit system, for easier review.
> + Propagating changes to support the new ipe_context structure in the evaluation loop.
> 
> v8:
> + Remove ipe_hook enumeration; hooks can be correlated via syscall record.
> 
> v9:
> + Remove ipe_context related code and simplify the evaluation loop.
> 
> v10:
> + Split eval part and boot_verified part
> 
> v11:
> + Fix code style issues
> ---
>  security/ipe/Makefile |  1 +
>  security/ipe/eval.c   | 96 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h   | 24 +++++++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 security/ipe/eval.c
>  create mode 100644 security/ipe/eval.h

...

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> new file mode 100644
> index 000000000000..5533c359bbeb
> --- /dev/null
> +++ b/security/ipe/eval.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/sched.h>
> +#include <linux/rcupdate.h>
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "policy.h"
> +
> +struct ipe_policy __rcu *ipe_active_policy;
> +
> +/**
> + * evaluate_property - Analyze @ctx against a property.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + * @p: Supplies a pointer to the property to be evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> +			      struct ipe_prop *p)
> +{
> +	return false;
> +}
> +
> +/**
> + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + *
> + * This is the loop where all policy evaluation happens against IPE policy.
> + *
> + * Return:
> + * * 0		- OK
> + * * -EACCES	- @ctx did not pass evaluation.
> + * * !0		- Error
> + */
> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> +{
> +	bool match = false;
> +	enum ipe_action_type action;
> +	struct ipe_policy *pol = NULL;
> +	const struct ipe_rule *rule = NULL;
> +	const struct ipe_op_table *rules = NULL;
> +	struct ipe_prop *prop = NULL;
> +
> +	rcu_read_lock();
> +
> +	pol = rcu_dereference(ipe_active_policy);
> +	if (!pol) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	if (ctx->op == IPE_OP_INVALID) {
> +		rcu_read_unlock();
> +		if (pol->parsed->global_default_action == IPE_ACTION_DENY)
> +			return -EACCES;

Assuming that the RCU lock protects @pol, shouldn't it be held until
after the global_default_action comparison?

> +		return 0;
> +	}
> +
> +	rules = &pol->parsed->rules[ctx->op];
> +
> +	list_for_each_entry(rule, &rules->rules, next) {
> +		match = true;
> +
> +		list_for_each_entry(prop, &rule->props, next) {
> +			match = match && evaluate_property(ctx, prop);

The @match variable will always be true on the right side above, or am
I missing something?

> +			if (!match)
> +				break;
> +		}
> +
> +		if (match)
> +			break;
> +	}
> +
> +	if (match)
> +		action = rule->action;
> +	else if (rules->default_action != IPE_ACTION_INVALID)
> +		action = rules->default_action;
> +	else
> +		action = pol->parsed->global_default_action;
> +
> +	rcu_read_unlock();
> +	if (action == IPE_ACTION_DENY)
> +		return -EACCES;
> +
> +	return 0;
> +}

--
paul-moore.com

