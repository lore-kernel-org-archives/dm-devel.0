Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822DBEB64DA
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 04:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689308305;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yQD15Rjw+TGchZ5PbyZ2WQuAFsBzfyxSM8nW/saT9xM=;
	b=dnvh8IwJh38OcXCz4Mxh8xLDhbKhpWhkFTQZbVA4kaHJb7ojWyP9UzmNXtwfh2vzSG/48s
	Lj/3fbKdxGfx2CfdlD+8/xmjVCCWT8oRz4ka6nLeWgEfh2x5JLZ/lgCq3nE2uktW/maph5
	AqY/nqwJoGS1aZfg90pnOzRjB/5C3gQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-kCrZVG7QNy-qkxVn8IpW1g-1; Fri, 14 Jul 2023 00:18:22 -0400
X-MC-Unique: kCrZVG7QNy-qkxVn8IpW1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5CCCB805951;
	Fri, 14 Jul 2023 04:18:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1221492B01;
	Fri, 14 Jul 2023 04:18:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 617D5194658F;
	Fri, 14 Jul 2023 04:18:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D096D1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 04:18:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E7EC111E3EB; Fri, 14 Jul 2023 04:18:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 962DD111E3EA
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 04:18:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BF74858F1E
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 04:18:16 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-352-lZ9eIDMDPlinldFMrgIAFA-1; Fri,
 14 Jul 2023 00:18:12 -0400
X-MC-Unique: lZ9eIDMDPlinldFMrgIAFA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id CED5321C4671; Thu, 13 Jul 2023 21:18:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CED5321C4671
Date: Thu, 13 Jul 2023 21:18:10 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230714041810.GA15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
 <b2abfd3883dce682ee911413fea2ec66.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <b2abfd3883dce682ee911413fea2ec66.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:00AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE's interpretation of the what the user trusts is accomplished through
> > its policy. IPE's design is to not provide support for a single trust
> > provider, but to support multiple providers to enable the end-user to
> > choose the best one to seek their needs.
> > 
> > This requires the policy to be rather flexible and modular so that
> > integrity providers, like fs-verity, dm-verity, dm-integrity, or
> > some other system, can plug into the policy with minimal code changes.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile        |   2 +
> >  security/ipe/policy.c        |  97 +++++++
> >  security/ipe/policy.h        |  83 ++++++
> >  security/ipe/policy_parser.c | 488 +++++++++++++++++++++++++++++++++++
> >  security/ipe/policy_parser.h |  11 +
> >  5 files changed, 681 insertions(+)
> >  create mode 100644 security/ipe/policy.c
> >  create mode 100644 security/ipe/policy.h
> >  create mode 100644 security/ipe/policy_parser.c
> >  create mode 100644 security/ipe/policy_parser.h
> 
> ...
> 
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > new file mode 100644
> > index 000000000000..4069ff075093
> > --- /dev/null
> > +++ b/security/ipe/policy.c
> > @@ -0,0 +1,97 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/verification.h>
> > +
> > +#include "ipe.h"
> > +#include "policy.h"
> > +#include "policy_parser.h"
> > +
> > +/**
> > + * ipe_free_policy - Deallocate a given IPE policy.
> > + * @p: Supplies the policy to free.
> > + *
> > + * Safe to call on IS_ERR/NULL.
> > + */
> > +void ipe_free_policy(struct ipe_policy *p)
> > +{
> > +	if (IS_ERR_OR_NULL(p))
> > +		return;
> > +
> > +	free_parsed_policy(p->parsed);
> > +	if (!p->pkcs7)
> > +		kfree(p->text);
> 
> Since it's safe to kfree(NULL), you could kfree(p->text) without
> having to check if p->pkcs7 was non-NULL, correct?
> 
when p->pkcs7 is not NULL, p->text points to the plain text policy area inside
the data of p->pkcs7, for such cases p->text is not really an allocated memory chunk
so it cannot be passed to kfree.

I might better add a comment here to avoid confusion in the future.

> > +	kfree(p->pkcs7);
> > +	kfree(p);
> > +}
> 
> ...
> 
> > diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> > new file mode 100644
> > index 000000000000..113a037f0d71
> > --- /dev/null
> > +++ b/security/ipe/policy.h
> > @@ -0,0 +1,83 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef _IPE_POLICY_H
> > +#define _IPE_POLICY_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/types.h>
> > +
> > +enum ipe_op_type {
> > +	__IPE_OP_EXEC = 0,
> > +	__IPE_OP_FIRMWARE,
> > +	__IPE_OP_KERNEL_MODULE,
> > +	__IPE_OP_KEXEC_IMAGE,
> > +	__IPE_OP_KEXEC_INITRAMFS,
> > +	__IPE_OP_IMA_POLICY,
> > +	__IPE_OP_IMA_X509,
> > +	__IPE_OP_MAX
> > +};
> 
> Thanks for capitalizing the enums, that helps make IPE consistent with
> the majority of the kernel.  However, when I talked about using
> underscores for "__IPE_OP_MAX", I was talking about *only*
> "__IPE_OP_MAX" to help indicate it is a sentinel value and not an enum
> value that would normally be used by itself.
> 
> Here is what I was intending:
> 
> enum ipe_op_type {
>   IPE_OP_EXEC = 0,
>   IPE_OP_FIRMWARE,
>   ...
>   IPE_OP_IMA_X509,
>   __IPE_OP_MAX
> };
> 
> > +#define __IPE_OP_INVALID __IPE_OP_MAX
> 
> Similarly, I would remove the underscores from "__IPE_OP_INVALID":
> 
> #define IPE_OP_INVALID __IPE_OP_MAX
> 
> Both of these comments would apply to the other IPE enums as well.
> 
Sorry for the mistake, I will update them.

> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > new file mode 100644
> > index 000000000000..27e5767480b0
> > --- /dev/null
> > +++ b/security/ipe/policy_parser.c
> > @@ -0,0 +1,488 @@
> 
> ...
> 
> > +/**
> > + * parse_header - Parse policy header information.
> > + * @line: Supplies header line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Standard errno
> > + */
> > +static int parse_header(char *line, struct ipe_parsed_policy *p)
> > +{
> > +	int rc = 0;
> > +	char *t, *ver = NULL;
> > +	substring_t args[MAX_OPT_ARGS];
> > +	size_t idx = 0;
> > +
> > +	while ((t = strsep(&line, " \t")) != NULL) {
> 
> It might be nice to define a macro to help reinforce that " \t" are
> the IPE policy delimiters, how about IPE_POLICY_DELIM?
> 
> #define IPE_POLICY_DELIM " \t"
> 
Sure, this is better, I will take this idea.

> > +		int token;
> > +
> > +		if (*t == '\0')
> > +			continue;
> 
> Why would you want to continue if you run into a NUL byte?  You would
> only run into a NUL byte if the line was trimmed due to comments or
> whitespace, correct?  If that is the case, wouldn't you want to
> break out of this loop when hitting a NUL byte?
> 
This happens when two spaces are passed, for example "DEFAULT<space><space>action=DENY"
has two spaces inside, the strsep will create a NUL string when it sees the first space,
so for such cases I think we should just skip to the next token.

> > +		if (idx >= __IPE_HEADER_MAX) {
> > +			rc = -EBADMSG;
> > +			goto err;
> > +		}
> > +
> > +		token = match_token(t, header_tokens, args);
> > +		if (token != idx) {
> > +			rc = -EBADMSG;
> > +			goto err;
> > +		}
> > +
> > +		switch (token) {
> > +		case __IPE_HEADER_POLICY_NAME:
> > +			p->name = match_strdup(&args[0]);
> > +			if (!p->name)
> > +				rc = -ENOMEM;
> > +			break;
> > +		case __IPE_HEADER_POLICY_VERSION:
> > +			ver = match_strdup(&args[0]);
> > +			if (!ver) {
> > +				rc = -ENOMEM;
> > +				break;
> > +			}
> > +			rc = parse_version(ver, p);
> > +			break;
> > +		default:
> > +			rc = -EBADMSG;
> > +		}
> > +		if (rc)
> > +			goto err;
> > +		++idx;
> > +	}
> > +
> > +	if (idx != __IPE_HEADER_MAX) {
> > +		rc = -EBADMSG;
> > +		goto err;
> > +	}
> > +
> > +out:
> > +	kfree(ver);
> > +	return rc;
> > +err:
> > +	kfree(p->name);
> > +	p->name = NULL;
> > +	goto out;
> 
> Do we need to worry about ipe_parsed_policy::name here?  If we are
> returning an error the caller will call free_parsed_policy() for us,
> right?  This would allow us to get rid of the 'err' jump label and
> simply use 'out' for both success and failure.
> 
Yes this is not necessary, I will remove this part.

> > +}
> 
> ...
> 
> > +/**
> > + * parse_rule - parse a policy rule line.
> > + * @line: Supplies rule line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * !IS_ERR	- OK
> > + * * -ENOMEM	- Out of memory
> > + * * -EBADMSG	- Policy syntax error
> > + */
> > +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> > +{
> > +	int rc = 0;
> > +	bool first_token = true, is_default_rule = false;
> > +	bool op_parsed = false;
> > +	enum ipe_op_type op = __IPE_OP_INVALID;
> > +	enum ipe_action_type action = __IPE_ACTION_INVALID;
> > +	struct ipe_rule *r = NULL;
> > +	char *t;
> > +
> > +	r = kzalloc(sizeof(*r), GFP_KERNEL);
> > +	if (!r)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&r->next);
> > +	INIT_LIST_HEAD(&r->props);
> > +
> > +	while (t = strsep(&line, " \t"), line) {
> 
> See my previous comment about IPE_POLICY_DELIM.
> 
> > +		if (*t == '\0')
> > +			continue;
> 
> I still wonder why continuing here is the desired behavior, can you
> help me understand?
This one is the same to the parse header function, when two consecutive
delimitators is passed to strsep it will generate a '\0'.

> 
> > +		if (first_token && token_default(t)) {
> > +			is_default_rule = true;
> > +		} else {
> > +			if (!op_parsed) {
> > +				op = parse_operation(t);
> > +				if (op == __IPE_OP_INVALID)
> > +					rc = -EBADMSG;
> > +				else
> > +					op_parsed = true;
> > +			} else {
> > +				rc = parse_property(t, r);
> > +			}
> > +		}
> > +
> > +		if (rc)
> > +			goto err;
> > +		first_token = false;
> > +	}
> > +
> > +	action = parse_action(t);
> > +	if (action == __IPE_ACTION_INVALID) {
> > +		rc = -EBADMSG;
> > +		goto err;
> > +	}
> > +
> > +	if (is_default_rule) {
> > +		if (!list_empty(&r->props)) {
> > +			rc = -EBADMSG;
> > +		} else if (op == __IPE_OP_INVALID) {
> > +			if (p->global_default_action != __IPE_ACTION_INVALID)
> > +				rc = -EBADMSG;
> > +			else
> > +				p->global_default_action = action;
> > +		} else {
> > +			if (p->rules[op].default_action != __IPE_ACTION_INVALID)
> > +				rc = -EBADMSG;
> > +			else
> > +				p->rules[op].default_action = action;
> > +		}
> > +	} else if (op != __IPE_OP_INVALID && action != __IPE_ACTION_INVALID) {
> > +		r->op = op;
> > +		r->action = action;
> > +	} else {
> > +		rc = -EBADMSG;
> > +	}
> > +
> > +	if (rc)
> > +		goto err;
> > +	if (!is_default_rule)
> > +		list_add_tail(&r->next, &p->rules[op].rules);
> > +	else
> > +		free_rule(r);
> > +
> > +out:
> > +	return rc;
> > +err:
> > +	free_rule(r);
> > +	goto out;
> 
> In keeping with the rule of not jumping to a label only to
> immediately return, and considering that the only place where we jump
> to 'out' is in the 'err' code, let's get rid of the 'out' label and
> have 'err' "return rc" instead of "goto out".
> 
Sure I can change this part, yeah I agree this looks weird. 

-Fan
> > +}
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

