Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AD9EB64DC
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790192;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Uhgc/N3ClAK/lefiaFoXWHVblc/ASMR3i2NV42vUIF0=;
	b=hlRgkyYDuSw/JrD5D7fwrRpAPzHRALmFUU/RHDrePNTpb8jXZntpyYoV2ffw5sTfR9goFC
	9y2oapekwo9+/1mpVrBQ86te85mJjNHbDIPkpqhZvgirJB4sIDZJwtcGAHoi5qdFDcteKY
	thmvQgn0tykTOd7rigJn62eJU1kM64k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-RYiDrl8sOSKC5FDQcLgZkw-1; Sat, 08 Jul 2023 00:23:09 -0400
X-MC-Unique: RYiDrl8sOSKC5FDQcLgZkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3097F1C05AD5;
	Sat,  8 Jul 2023 04:23:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFCE0F66AD;
	Sat,  8 Jul 2023 04:23:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC09C1946A69;
	Sat,  8 Jul 2023 04:23:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B0611946A54
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CF511121333; Sat,  8 Jul 2023 04:23:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65B6B1121331
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AD2385A58A
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:04 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-a1xzBeEPMGK_UJiUdFDU_A-1; Sat, 08 Jul 2023 00:23:02 -0400
X-MC-Unique: a1xzBeEPMGK_UJiUdFDU_A-1
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-7659c6cae2cso207555385a.1
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790182; x=1691382182;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Pr9IRZWW9eKpjkAEIe/1R+NHyAjULaMI0VUp/S3+Lu8=;
 b=ccsnlYoytxpwGrQKxmeNvtVv2zDKuvwVk8MPlXhUzArHVqxEcGdM2O8s1nVgzf9HSs
 mlWHgY1Ta+XsQvRkagtI3vXd+jTWtqqNZhN6TrNEkU4NWxyZyjJAJ2QeRH5mN4sEc1Ls
 WKnmUxd49q/pAfFTxSvdDQ1RnfQfga10c5tUMfkqH2m67Ba/oWS0GXhv+45CKMwGGjpO
 Rn9fT8fkdH09mdDsEtRm3mUuuCSKFKxdQUNWfyGXsjusQB6kVYDhaMSWd7IDoJk0NyQh
 RZ4VcScHl6Fdk3+mz2PMUazdNITj1ed+rLpZwYVLVYFMhbCQLiTe68llVJLQGuX3xeD1
 C54g==
X-Gm-Message-State: ABy/qLaGmo1yOlqaPsess3u/o9fNM5M97kMLdwfs8TZrmbvqumIwd+uT
 wqvNr2NJpqF4eoKMIeludywi
X-Google-Smtp-Source: APBJJlHdsZGAOfkYCziVX5Ror75QjMOKMxzNmXb1HB5SUTNt6Jwslrp6qJVZliJvjeDkZI073EiDww==
X-Received: by 2002:a05:620a:4310:b0:767:400b:bbca with SMTP id
 u16-20020a05620a431000b00767400bbbcamr8606780qko.48.1688790182012; 
 Fri, 07 Jul 2023 21:23:02 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 y8-20020a37e308000000b007623c96430csm2437979qki.111.2023.07.07.21.23.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:01 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:01 -0400
Message-ID: <309cfd62a474a7e93be6a0886a3d5aa8.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v10 3/17] ipe: add evaluation loop
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
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE must have a centralized function to evaluate incoming callers
> against IPE's policy. This iteration of the policy for against the rules
> for that specific caller is known as the evaluation loop.

Can you rewrite that second sentence, it reads a bit awkward and I'm
unclear as to the meaning.

> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile |  1 +
>  security/ipe/eval.c   | 94 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h   | 25 ++++++++++++
>  3 files changed, 120 insertions(+)
>  create mode 100644 security/ipe/eval.c
>  create mode 100644 security/ipe/eval.h

...

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> new file mode 100644
> index 000000000000..59144b2ecdda
> --- /dev/null
> +++ b/security/ipe/eval.c
> @@ -0,0 +1,94 @@
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
> +#include "hooks.h"

There is no "hooks.h" at this point in the patchset.

In order for 'git bisect' to remain useful (and it can be a very handy
tool), we need to ensure that each point in the patchset compiles
cleanly.

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
> +	int rc = 0;
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
> +	if (ctx->op == __IPE_OP_INVALID) {
> +		action = pol->parsed->global_default_action;
> +		goto eval;

It looks like you are missing a rcu_read_unlock() in this case.

Also, given how simplistic the evaluation is in this case, why not
just do it here, saving the assignment, jump, etc.?

  if (ctx->op == INVALID) {
    rcu_read_unlock()
    if (global_action == DENY)
      return -EACCES;
    return 0;
  }

> +	}
> +
> +	rules = &pol->parsed->rules[ctx->op];
> +
> +	list_for_each_entry(rule, &rules->rules, next) {
> +		match = true;
> +
> +		list_for_each_entry(prop, &rule->props, next)
> +			match = match && evaluate_property(ctx, prop);

Why not break from this loop once evaluate_property() returns false?

> +
> +		if (match)
> +			break;
> +	}
> +
> +	if (match)
> +		action = rule->action;
> +	else if (rules->default_action != __IPE_ACTION_INVALID)
> +		action = rules->default_action;
> +	else
> +		action = pol->parsed->global_default_action;
> +
> +	rcu_read_unlock();
> +eval:
> +	if (action == __IPE_ACTION_DENY)
> +		rc = -EACCES;
> +
> +	return rc;

This can just be 'return 0;' right?

> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

