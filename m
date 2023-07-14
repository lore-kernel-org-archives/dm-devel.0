Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA44EB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 20:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689366537;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M13XOx0GzMqwiO267jlcxb+Y7RDRGQei1UqMK1CXqiI=;
	b=W3fEiPw7Ng+Tiqr1GKkmbxEbF0PWEVGrSC4EmwyJ3roXWZG8W4sF8NEDIXEwhdnusR8qlO
	jU9iYoYcZqd+Kklx70X90tk3qLTYKJu7pBDUQ3cVDORI8BS2Cs3Dix72MoPj1sR3Cx7Io8
	kSBD99xJXyqh/0K6y+KypKO+OytXRdo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-EqkrIO66MC-1nQJEJSQJmw-1; Fri, 14 Jul 2023 16:28:54 -0400
X-MC-Unique: EqkrIO66MC-1nQJEJSQJmw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 539F78D1684;
	Fri, 14 Jul 2023 20:28:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 671D2492C13;
	Fri, 14 Jul 2023 20:28:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3047B1946594;
	Fri, 14 Jul 2023 20:28:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA511194658F
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 20:28:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 888E91121339; Fri, 14 Jul 2023 20:28:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 808B41121333
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:28:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65361800969
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 20:28:48 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-396-ZhVfORMdNJSpaOmgMR9-PQ-1; Fri,
 14 Jul 2023 16:28:46 -0400
X-MC-Unique: ZhVfORMdNJSpaOmgMR9-PQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 353B820ABD64; Fri, 14 Jul 2023 13:28:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 353B820ABD64
Date: Fri, 14 Jul 2023 13:28:45 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230714202845.GB15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
 <309cfd62a474a7e93be6a0886a3d5aa8.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <309cfd62a474a7e93be6a0886a3d5aa8.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:01AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE must have a centralized function to evaluate incoming callers
> > against IPE's policy. This iteration of the policy for against the rules
> > for that specific caller is known as the evaluation loop.
> 
> Can you rewrite that second sentence, it reads a bit awkward and I'm
> unclear as to the meaning.
> 
Sure, it is indeed not clear, I might rewrite the whole message in the next version.

> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile |  1 +
> >  security/ipe/eval.c   | 94 +++++++++++++++++++++++++++++++++++++++++++
> >  security/ipe/eval.h   | 25 ++++++++++++
> >  3 files changed, 120 insertions(+)
> >  create mode 100644 security/ipe/eval.c
> >  create mode 100644 security/ipe/eval.h
> 
> ...
> 
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > new file mode 100644
> > index 000000000000..59144b2ecdda
> > --- /dev/null
> > +++ b/security/ipe/eval.c
> > @@ -0,0 +1,94 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <linux/sched.h>
> > +#include <linux/rcupdate.h>
> > +
> > +#include "ipe.h"
> > +#include "eval.h"
> > +#include "hooks.h"
> 
> There is no "hooks.h" at this point in the patchset.
> 
> In order for 'git bisect' to remain useful (and it can be a very handy
> tool), we need to ensure that each point in the patchset compiles
> cleanly.
> 
Sorry for the mistake here, I will avoid this kind of problems in the future.

> > +#include "policy.h"
> > +
> > +struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +/**
> > + * evaluate_property - Analyze @ctx against a property.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + * @p: Supplies a pointer to the property to be evaluated.
> > + *
> > + * Return:
> > + * * true	- The current @ctx match the @p
> > + * * false	- The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> > +			      struct ipe_prop *p)
> > +{
> > +	return false;
> > +}
> > +
> > +/**
> > + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + *
> > + * This is the loop where all policy evaluation happens against IPE policy.
> > + *
> > + * Return:
> > + * * 0		- OK
> > + * * -EACCES	- @ctx did not pass evaluation.
> > + * * !0		- Error
> > + */
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> > +{
> > +	int rc = 0;
> > +	bool match = false;
> > +	enum ipe_action_type action;
> > +	struct ipe_policy *pol = NULL;
> > +	const struct ipe_rule *rule = NULL;
> > +	const struct ipe_op_table *rules = NULL;
> > +	struct ipe_prop *prop = NULL;
> > +
> > +	rcu_read_lock();
> > +
> > +	pol = rcu_dereference(ipe_active_policy);
> > +	if (!pol) {
> > +		rcu_read_unlock();
> > +		return 0;
> > +	}
> > +
> > +	if (ctx->op == __IPE_OP_INVALID) {
> > +		action = pol->parsed->global_default_action;
> > +		goto eval;
> 
> It looks like you are missing a rcu_read_unlock() in this case.
> 
Thanks for pointing that out. I will add the unlock. 
> Also, given how simplistic the evaluation is in this case, why not
> just do it here, saving the assignment, jump, etc.?
> 
>   if (ctx->op == INVALID) {
>     rcu_read_unlock()
>     if (global_action == DENY)
>       return -EACCES;
>     return 0;
>   }
> 
The jump is actually for auditing the decision in the next patch, while
it does make more sense to not jump when the auditing is not introduced. 
I will make the return here then switch to jump in the auditing patch.

> > +	}
> > +
> > +	rules = &pol->parsed->rules[ctx->op];
> > +
> > +	list_for_each_entry(rule, &rules->rules, next) {
> > +		match = true;
> > +
> > +		list_for_each_entry(prop, &rule->props, next)
> > +			match = match && evaluate_property(ctx, prop);
> 
> Why not break from this loop once evaluate_property() returns false?
> 
Yes we can break when one property evals to false, thanks for the advice.

> > +
> > +		if (match)
> > +			break;
> > +	}
> > +
> > +	if (match)
> > +		action = rule->action;
> > +	else if (rules->default_action != __IPE_ACTION_INVALID)
> > +		action = rules->default_action;
> > +	else
> > +		action = pol->parsed->global_default_action;
> > +
> > +	rcu_read_unlock();
> > +eval:
> > +	if (action == __IPE_ACTION_DENY)
> > +		rc = -EACCES;
> > +
> > +	return rc;
> 
> This can just be 'return 0;' right?
> 
For this patch, if we just return on error, then yes the end of the function
could just return 0. But when auditing(audit rc) and permissive switch(overwrite rc)
are introduced then return on error might not be the clean way. So I kept
the rc variable in this patch. I can change the style in this patch then
switch to use rc when auditing and permissive switch are introduced.

-Fan

> > +}
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

