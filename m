Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA9E748D
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToFq/ZSk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119549;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PYQStjjr2Q8HKTHbB20ou4WiXIqkha1Xi9gNGY1VyVs=;
	b=ToFq/ZSkKWcdI7C46vZiGgMjfFlCHRAKRli+YsV04KtGSPjrphuxvx8Rh4cumu/DgiziW8
	UWnbArKIChV5aVoqYn586jNl0VeizvooD7Jd7E+EWA4NGew6kZh9WxhWYH8N25jQzjDo3T
	vsRzi1Dh35j05G9CwGYIY7jOK6Bx2t4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-DrXbbR7WOhelRA9-eghkHw-1; Mon, 23 Oct 2023 23:52:28 -0400
X-MC-Unique: DrXbbR7WOhelRA9-eghkHw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2333E811E91
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18E71492BD9
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD07E1946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 034251946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A77DC2166B27; Tue, 24 Oct 2023 03:52:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FE832166B26
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:25 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B79C1C05131
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:25 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-buFgrh1aPUqMrb55LHU1nA-1; Mon, 23 Oct 2023 23:52:23 -0400
X-MC-Unique: buFgrh1aPUqMrb55LHU1nA-1
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-7781bc3783fso282560085a.1
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119543; x=1698724343;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=PYQStjjr2Q8HKTHbB20ou4WiXIqkha1Xi9gNGY1VyVs=;
 b=AZC5xQfZKDg1rO5SSxT2neHBuxgmOFtcWa42eezLutsd5KXrH6m+XtqIjArPI3T/al
 iPcNrJE8OSuUzkuFIYyGS+xC+0WEUFtGkeH7zKeRBtEKB7gYiMF7lu5pTEfWBOezLNoj
 aGEtuQ3TpMk3FOI3NQVr1y4QHSr5YpGlSLaz4hTz6hMi/fQl0P0kpiCuY1h/yKXOH1UM
 K2awJnP+HCc71CdH9hRti0Eznucgcji8Gz3aIQsAsJl9nRmORbRHj84fwGOn/PmaysM1
 fF/nWf7VYTnNkpL3O0m06ouhgxdiqUXpGgxGzUMFewtYIypqAIt09h5NRazDpqmWXvym
 hqgg==
X-Gm-Message-State: AOJu0YycIjuT+dz6ilYQk324m6DxwXDAWJzbq67UuGkzNijJQHLYehUZ
 Lw8wAJo6/VEleNzoXuslL+Te
X-Google-Smtp-Source: AGHT+IHfXLDpTQH23RQCgDD0EvaJ8t5ssD/FP1FN3NpOgQNJgnc6N7o0sQ0agZuP/Pbj2axyoTKe+g==
X-Received: by 2002:a05:620a:1a25:b0:772:6419:89ab with SMTP id
 bk37-20020a05620a1a2500b00772641989abmr13610179qkb.55.1698119542757; 
 Mon, 23 Oct 2023 20:52:22 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 bi12-20020a05620a318c00b00772662b7804sm3164703qkb.100.2023.10.23.20.52.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:22 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:21 -0400
Message-ID: <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
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
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move policy load and activation audit event to 03/12
>   + Fix a potential panic when a policy failed to load.
>   + use pr_warn for a failure to parse instead of an
>     audit record
>   + Remove comments from headers
>   + Add lockdep assertions to ipe_update_active_policy and
>     ipe_activate_policy
>   + Fix up warnings with checkpatch --strict
>   + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>     nodes.
>   + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>   + Remove strict_parse command line parameter, as it is added
>     by the sysctl command line.
>   + Prefix extern variables with ipe_
> 
> v4:
>   + Remove securityfs to reverse-dependency
>   + Add SHA1 reverse dependency.
>   + Add versioning scheme for IPE properties, and associated
>     interface to query the versioning scheme.
>   + Cause a parser to always return an error on unknown syntax.
>   + Remove strict_parse option
>   + Change active_policy interface from sysctl, to securityfs,
>     and change scheme.
> 
> v5:
>   + Cause an error if a default action is not defined for each
>     operation.
>   + Minor function renames
> 
> v6:
>   + No changes
> 
> v7:
>   + Further split parser and userspace interface into two
>     separate commits, for easier review.
>   + Refactor policy parser to make code cleaner via introducing a
>     more modular design, for easier extension of policy, and
>     easier review.
> 
> v8:
>   + remove unnecessary pr_info emission on parser loading
>   + add explicit newline to the pr_err emitted when a parser
>     fails to load.
> 
> v9:
>   + switch to match table to parse policy
>   + remove quote syntax and KERNEL_READ operation
> 
> v10:
>   + Fix memory leaks in parser
>   + Fix typos and change code styles
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/Makefile        |   2 +
>  security/ipe/policy.c        | 101 ++++++++
>  security/ipe/policy.h        |  83 ++++++
>  security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++++
>  security/ipe/policy_parser.h |  11 +
>  5 files changed, 684 insertions(+)
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h
>  create mode 100644 security/ipe/policy_parser.c
>  create mode 100644 security/ipe/policy_parser.h

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> new file mode 100644
> index 000000000000..3a529c7950a1
> --- /dev/null
> +++ b/security/ipe/policy.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> +			  size_t asn1hdrlen)
> +{
> +	struct ipe_policy *p = ctx;
> +
> +	p->text = (const char *)data;
> +	p->textlen = len;
> +
> +	return 0;
> +}

The @asn1hdrlen parameter isn't used in this function, at least at this
point in the patchset, so you really should remove it.  If it is needed
later in the patchset you can always update the function.

> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> new file mode 100644
> index 000000000000..c09458bd348d
> --- /dev/null
> +++ b/security/ipe/policy_parser.c
> @@ -0,0 +1,487 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +/**
> + * remove_trailing_spaces - Truncate all trailing spaces in a string.
> + *
> + * @line: Supplies a poilcy line string for preprocessing.
> + *
> + * Return: The length of truncated string.
> + */
> +static size_t remove_trailing_spaces(char *line)
> +{
> +	size_t i = 0;
> +
> +	for (i = strlen(line); i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
> +		;

Maybe I've asked this before, I can't remember: could you use the
isspace() macro here instead of explicitly checking for ' ' and '\t'?

  i = strlen(line);
  while (i > 0 && isspace(line[i - 1]))
    i--;
  line[i] = '\0';

> +	line[i] = '\0';
> +
> +	return i;
> +}
> +
> +/**
> + * parse_version - Parse policy version.
> + * @ver: Supplies a version string to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Standard errno
> + */
> +static int parse_version(char *ver, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	size_t sep_count = 0;
> +	char *token;
> +	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
> +
> +	while ((token = strsep(&ver, ".")) != NULL) {
> +		/* prevent overflow */
> +		if (sep_count >= ARRAY_SIZE(cv))
> +			return -EBADMSG;
> +
> +		rc = kstrtou16(token, 10, cv[sep_count]);
> +		if (rc)
> +			return rc;
> +
> +		++sep_count;
> +	}
> +
> +	/* prevent underflow */
> +	if (sep_count != ARRAY_SIZE(cv))
> +		rc = -EBADMSG;

You could always just 'return -EBADMSG' here and 'return 0' below to
simplify things a little.

> +	return rc;
> +}
> +
> +enum header_opt {
> +	IPE_HEADER_POLICY_NAME = 0,
> +	IPE_HEADER_POLICY_VERSION,
> +	__IPE_HEADER_MAX
> +};
> +
> +static const match_table_t header_tokens = {
> +	{IPE_HEADER_POLICY_NAME,	"policy_name=%s"},
> +	{IPE_HEADER_POLICY_VERSION,	"policy_version=%s"},
> +	{__IPE_HEADER_MAX,		NULL}
> +};
> +
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
> +	while ((t = strsep(&line, IPE_POLICY_DELIM)) != NULL) {
> +		int token;
> +
> +		if (*t == '\0')
> +			continue;
> +		if (idx >= __IPE_HEADER_MAX) {
> +			rc = -EBADMSG;
> +			goto out;
> +		}
> +
> +		token = match_token(t, header_tokens, args);
> +		if (token != idx) {
> +			rc = -EBADMSG;
> +			goto out;
> +		}
> +
> +		switch (token) {
> +		case IPE_HEADER_POLICY_NAME:
> +			p->name = match_strdup(&args[0]);
> +			if (!p->name)
> +				rc = -ENOMEM;
> +			break;
> +		case IPE_HEADER_POLICY_VERSION:
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
> +			goto out;
> +		++idx;
> +	}
> +
> +	if (idx != __IPE_HEADER_MAX) {
> +		rc = -EBADMSG;
> +		goto out;

You probably don't need to 'goto out' here.

> +	}
> +
> +out:
> +	kfree(ver);
> +	return rc;
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
> +	enum ipe_op_type op = IPE_OP_INVALID;
> +	enum ipe_action_type action = IPE_ACTION_INVALID;
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
> +	while (t = strsep(&line, IPE_POLICY_DELIM), line) {
> +		if (*t == '\0')
> +			continue;
> +		if (first_token && token_default(t)) {
> +			is_default_rule = true;
> +		} else {
> +			if (!op_parsed) {
> +				op = parse_operation(t);
> +				if (op == IPE_OP_INVALID)
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
> +	if (action == IPE_ACTION_INVALID) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +	if (is_default_rule) {
> +		if (!list_empty(&r->props)) {
> +			rc = -EBADMSG;
> +		} else if (op == IPE_OP_INVALID) {
> +			if (p->global_default_action != IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->global_default_action = action;
> +		} else {
> +			if (p->rules[op].default_action != IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->rules[op].default_action = action;
> +		}
> +	} else if (op != IPE_OP_INVALID && action != IPE_ACTION_INVALID) {
> +		r->op = op;
> +		r->action = action;
> +	} else {
> +		rc = -EBADMSG;
> +	}

I might be missing something important in the policy syntac, but could
this function, and perhaps the ipe_parsed_policy struct, be simplified
if the default action was an explicit rule?

 "op=DEFAULT action=ALLOW"

> +	if (rc)
> +		goto err;
> +	if (!is_default_rule)
> +		list_add_tail(&r->next, &p->rules[op].rules);
> +	else
> +		free_rule(r);
> +
> +	return rc;
> +err:
> +	free_rule(r);
> +	return rc;
> +}
> +
> +/**
> + * free_parsed_policy - free a parsed policy structure.
> + * @p: Supplies the parsed policy.
> + */
> +void free_parsed_policy(struct ipe_parsed_policy *p)
> +{
> +	size_t i = 0;
> +	struct ipe_rule *pp, *t;
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
> +		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next) {
> +			list_del(&pp->next);
> +			free_rule(pp);
> +		}
> +
> +	kfree(p->name);
> +	kfree(p);
> +}
> +
> +/**
> + * validate_policy - validate a parsed policy.
> + * @p: Supplies the fully parsed policy.
> + *
> + * Given a policy structure that was just parsed, validate that all
> + * necessary fields are present, initialized correctly.
> + *
> + * A parsed policy can be in an invalid state for use (a default was
> + * undefined) by just parsing the policy.
> + *
> + * Return:
> + * * 0		- OK
> + * * -EBADMSG	- Policy is invalid
> + */
> +static int validate_policy(const struct ipe_parsed_policy *p)
> +{
> +	size_t i = 0;
> +
> +	if (p->global_default_action != IPE_ACTION_INVALID)
> +		return 0;

Should the if conditional above be "==" and not "!="?

> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
> +		if (p->rules[i].default_action == IPE_ACTION_INVALID)
> +			return -EBADMSG;
> +	}
> +
> +	return 0;
> +}

--
paul-moore.com

