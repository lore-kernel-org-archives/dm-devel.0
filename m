Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84347EB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794625;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jLLv/DU/8BJh+xIlOnjMJ5HHRUbflNn62M0sctRgwGY=;
	b=Iie922Xd7UvNlOHWzzVj1/IChmoRe9pT8GBtUD69szbfktpTWOo6wTIb6ygtYdGCaPk4Sa
	mquHBwd/CIC0j3GdB83yO6oOgU0krqrWxRhZqILGGXzQKK+OGTA8aRAoX9+n6NbHBYRkua
	x3LQBrgIiuug+KgQ5s6PdHpKXUAFf2c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-ZXt61RS9OtSpxy1lqGDrVw-1; Sat, 08 Jul 2023 01:37:03 -0400
X-MC-Unique: ZXt61RS9OtSpxy1lqGDrVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4683C802666;
	Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32B4CC09A09;
	Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18F7419452C3;
	Sat,  8 Jul 2023 05:37:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB2AA1946A5E
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:36:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9ED4D1121333; Sat,  8 Jul 2023 05:36:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96F171121331
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:36:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73146101A529
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:36:58 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-LZKcdssyPAuHP0FMnSUC2A-1; Sat, 08 Jul 2023 01:36:56 -0400
X-MC-Unique: LZKcdssyPAuHP0FMnSUC2A-1
Received: by mail-qt1-f180.google.com with SMTP id
 d75a77b69052e-4036507ddadso21666841cf.3
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:36:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794616; x=1691386616;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=8vhWvQ+HIeKxtbu9t/iKboGRzIGP6y7RZUqn4rd0xJo=;
 b=IjllovTdG4lu+Qcvj8YWCTdspIHu1w9aWkgdlhB/z/xo/vQy2D5/6VLk62yuPXObWh
 GVXgTUaTnddZlro9iaAA89gJxinG4qARJw1nAJml/ec5CRusSzw8yneQ3WTezEZWI2Rf
 9pyabfkCLK3zFBgO51GV/0IiaTutQ67oDP+3EiGrkfmxg+1+pQJ2UI4fFF5BPBJrtCIO
 eTv4e9IQ/8RqEOekbQYEKqQIR1iqVbAUQPQVvgb/j09dK3xGl2SkIHTFaprvj8KgboYb
 JY2IC+qTZ6oZopuzNYhKni+BQq9N+z0eFUd8ExVQJpODLBblEUjGS70HYJ0qtoXAxPtf
 MCjg==
X-Gm-Message-State: ABy/qLY9+/4nCefwPNakr2BCj/ryut//XChubYicrFcck5Exg1v+X4YR
 M6atg8Re3ztj6lbBjtLM1h2p
X-Google-Smtp-Source: APBJJlGS6QkcaojJ51y27g6fEhYWrJspUv8fSJt2GrIbyIfM4i/xFNiSjdaR6x7s/mOzbvvPGql2MA==
X-Received: by 2002:ac8:5793:0:b0:402:2e84:f06e with SMTP id
 v19-20020ac85793000000b004022e84f06emr9536600qta.27.1688794616056; 
 Fri, 07 Jul 2023 22:36:56 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 p1-20020a0c9a01000000b0062def68f75csm2971727qvd.124.2023.07.07.22.36.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:36:55 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:36:55 -0400
Message-ID: <d4b1522c467839c02d38ff9da99ebbd3.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v10 2/17] ipe: add policy parser
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE's interpretation of the what the user trusts is accomplished through
> its policy. IPE's design is to not provide support for a single trust
> provider, but to support multiple providers to enable the end-user to
> choose the best one to seek their needs.
> 
> This requires the policy to be rather flexible and modular so that
> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> some other system, can plug into the policy with minimal code changes.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile        |   2 +
>  security/ipe/policy.c        |  97 +++++++
>  security/ipe/policy.h        |  83 ++++++
>  security/ipe/policy_parser.c | 488 +++++++++++++++++++++++++++++++++++
>  security/ipe/policy_parser.h |  11 +
>  5 files changed, 681 insertions(+)
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h
>  create mode 100644 security/ipe/policy_parser.c
>  create mode 100644 security/ipe/policy_parser.h

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> new file mode 100644
> index 000000000000..4069ff075093
> --- /dev/null
> +++ b/security/ipe/policy.c
> @@ -0,0 +1,97 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/verification.h>
> +
> +#include "ipe.h"
> +#include "policy.h"
> +#include "policy_parser.h"
> +
> +/**
> + * ipe_free_policy - Deallocate a given IPE policy.
> + * @p: Supplies the policy to free.
> + *
> + * Safe to call on IS_ERR/NULL.
> + */
> +void ipe_free_policy(struct ipe_policy *p)
> +{
> +	if (IS_ERR_OR_NULL(p))
> +		return;
> +
> +	free_parsed_policy(p->parsed);
> +	if (!p->pkcs7)
> +		kfree(p->text);

Since it's safe to kfree(NULL), you could kfree(p->text) without
having to check if p->pkcs7 was non-NULL, correct?

> +	kfree(p->pkcs7);
> +	kfree(p);
> +}

...

> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> new file mode 100644
> index 000000000000..113a037f0d71
> --- /dev/null
> +++ b/security/ipe/policy.h
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef _IPE_POLICY_H
> +#define _IPE_POLICY_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +
> +enum ipe_op_type {
> +	__IPE_OP_EXEC = 0,
> +	__IPE_OP_FIRMWARE,
> +	__IPE_OP_KERNEL_MODULE,
> +	__IPE_OP_KEXEC_IMAGE,
> +	__IPE_OP_KEXEC_INITRAMFS,
> +	__IPE_OP_IMA_POLICY,
> +	__IPE_OP_IMA_X509,
> +	__IPE_OP_MAX
> +};

Thanks for capitalizing the enums, that helps make IPE consistent with
the majority of the kernel.  However, when I talked about using
underscores for "__IPE_OP_MAX", I was talking about *only*
"__IPE_OP_MAX" to help indicate it is a sentinel value and not an enum
value that would normally be used by itself.

Here is what I was intending:

enum ipe_op_type {
  IPE_OP_EXEC = 0,
  IPE_OP_FIRMWARE,
  ...
  IPE_OP_IMA_X509,
  __IPE_OP_MAX
};

> +#define __IPE_OP_INVALID __IPE_OP_MAX

Similarly, I would remove the underscores from "__IPE_OP_INVALID":

#define IPE_OP_INVALID __IPE_OP_MAX

Both of these comments would apply to the other IPE enums as well.

> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> new file mode 100644
> index 000000000000..27e5767480b0
> --- /dev/null
> +++ b/security/ipe/policy_parser.c
> @@ -0,0 +1,488 @@

...

> +/**
> + * parse_header - Parse policy header information.
> + * @line: Supplies header line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Standard errno
> + */
> +static int parse_header(char *line, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	char *t, *ver = NULL;
> +	substring_t args[MAX_OPT_ARGS];
> +	size_t idx = 0;
> +
> +	while ((t = strsep(&line, " \t")) != NULL) {

It might be nice to define a macro to help reinforce that " \t" are
the IPE policy delimiters, how about IPE_POLICY_DELIM?

#define IPE_POLICY_DELIM " \t"

> +		int token;
> +
> +		if (*t == '\0')
> +			continue;

Why would you want to continue if you run into a NUL byte?  You would
only run into a NUL byte if the line was trimmed due to comments or
whitespace, correct?  If that is the case, wouldn't you want to
break out of this loop when hitting a NUL byte?

> +		if (idx >= __IPE_HEADER_MAX) {
> +			rc = -EBADMSG;
> +			goto err;
> +		}
> +
> +		token = match_token(t, header_tokens, args);
> +		if (token != idx) {
> +			rc = -EBADMSG;
> +			goto err;
> +		}
> +
> +		switch (token) {
> +		case __IPE_HEADER_POLICY_NAME:
> +			p->name = match_strdup(&args[0]);
> +			if (!p->name)
> +				rc = -ENOMEM;
> +			break;
> +		case __IPE_HEADER_POLICY_VERSION:
> +			ver = match_strdup(&args[0]);
> +			if (!ver) {
> +				rc = -ENOMEM;
> +				break;
> +			}
> +			rc = parse_version(ver, p);
> +			break;
> +		default:
> +			rc = -EBADMSG;
> +		}
> +		if (rc)
> +			goto err;
> +		++idx;
> +	}
> +
> +	if (idx != __IPE_HEADER_MAX) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +out:
> +	kfree(ver);
> +	return rc;
> +err:
> +	kfree(p->name);
> +	p->name = NULL;
> +	goto out;

Do we need to worry about ipe_parsed_policy::name here?  If we are
returning an error the caller will call free_parsed_policy() for us,
right?  This would allow us to get rid of the 'err' jump label and
simply use 'out' for both success and failure.

> +}

...

> +/**
> + * parse_rule - parse a policy rule line.
> + * @line: Supplies rule line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * !IS_ERR	- OK
> + * * -ENOMEM	- Out of memory
> + * * -EBADMSG	- Policy syntax error
> + */
> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	bool first_token = true, is_default_rule = false;
> +	bool op_parsed = false;
> +	enum ipe_op_type op = __IPE_OP_INVALID;
> +	enum ipe_action_type action = __IPE_ACTION_INVALID;
> +	struct ipe_rule *r = NULL;
> +	char *t;
> +
> +	r = kzalloc(sizeof(*r), GFP_KERNEL);
> +	if (!r)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&r->next);
> +	INIT_LIST_HEAD(&r->props);
> +
> +	while (t = strsep(&line, " \t"), line) {

See my previous comment about IPE_POLICY_DELIM.

> +		if (*t == '\0')
> +			continue;

I still wonder why continuing here is the desired behavior, can you
help me understand?

> +		if (first_token && token_default(t)) {
> +			is_default_rule = true;
> +		} else {
> +			if (!op_parsed) {
> +				op = parse_operation(t);
> +				if (op == __IPE_OP_INVALID)
> +					rc = -EBADMSG;
> +				else
> +					op_parsed = true;
> +			} else {
> +				rc = parse_property(t, r);
> +			}
> +		}
> +
> +		if (rc)
> +			goto err;
> +		first_token = false;
> +	}
> +
> +	action = parse_action(t);
> +	if (action == __IPE_ACTION_INVALID) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +	if (is_default_rule) {
> +		if (!list_empty(&r->props)) {
> +			rc = -EBADMSG;
> +		} else if (op == __IPE_OP_INVALID) {
> +			if (p->global_default_action != __IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->global_default_action = action;
> +		} else {
> +			if (p->rules[op].default_action != __IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->rules[op].default_action = action;
> +		}
> +	} else if (op != __IPE_OP_INVALID && action != __IPE_ACTION_INVALID) {
> +		r->op = op;
> +		r->action = action;
> +	} else {
> +		rc = -EBADMSG;
> +	}
> +
> +	if (rc)
> +		goto err;
> +	if (!is_default_rule)
> +		list_add_tail(&r->next, &p->rules[op].rules);
> +	else
> +		free_rule(r);
> +
> +out:
> +	return rc;
> +err:
> +	free_rule(r);
> +	goto out;

In keeping with the rule of not jumping to a label only to
immediately return, and considering that the only place where we jump
to 'out' is in the 'err' code, let's get rid of the 'out' label and
have 'err' "return rc" instead of "goto out".

> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

