Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6B827EFF
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8y6ehUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698273998;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dm0CpobQbsS7czPRbypssTTQ8Y+D288bv9BFBEkdSMg=;
	b=V8y6ehUQhwA6dZ6yFOLCZj1iU8xKKDTLNBmHBgs6rel+QtOwWseksuNykBhWw9fAcSsVkW
	5fXQMx3h/iH2smUcM0WNZkwi3NvIugU+OkApXm9xTNUMRiF9HJpbgUb5PWO6XZ3zumblpJ
	yJ2Y4c9H7hLgGTHGHrs8sVLYP/ZxkpE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-8Y6TQKtmMaO1CULiPIhr3Q-1; Wed, 25 Oct 2023 18:46:35 -0400
X-MC-Unique: 8Y6TQKtmMaO1CULiPIhr3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8FF1101A53B
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 22:46:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FC23C15983
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 22:46:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27C491946595
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 22:46:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9B28F194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 Oct 2023 22:46:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4178B502B; Wed, 25 Oct 2023 22:46:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39DEC502A
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 22:46:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 104362825E82
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 22:46:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-205-ARuZaNb-NFOXNdbQcHT9eA-1; Wed,
 25 Oct 2023 18:46:25 -0400
X-MC-Unique: ARuZaNb-NFOXNdbQcHT9eA-1
Received: from [10.137.106.151] (unknown [131.107.159.23])
 by linux.microsoft.com (Postfix) with ESMTPSA id 02F9D20B74C0;
 Wed, 25 Oct 2023 15:46:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02F9D20B74C0
Message-ID: <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
Date: Wed, 25 Oct 2023 15:45:37 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
 <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> IPE's interpretation of the what the user trusts is accomplished through
>> its policy. IPE's design is to not provide support for a single trust
>> provider, but to support multiple providers to enable the end-user to
>> choose the best one to seek their needs.
>>
>> This requires the policy to be rather flexible and modular so that
>> integrity providers, like fs-verity, dm-verity, dm-integrity, or
>> some other system, can plug into the policy with minimal code changes.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/Makefile        |   2 +
>>   security/ipe/policy.c        | 101 ++++++++
>>   security/ipe/policy.h        |  83 ++++++
>>   security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++++
>>   security/ipe/policy_parser.h |  11 +
>>   5 files changed, 684 insertions(+)
>>   create mode 100644 security/ipe/policy.c
>>   create mode 100644 security/ipe/policy.h
>>   create mode 100644 security/ipe/policy_parser.c
>>   create mode 100644 security/ipe/policy_parser.h
> 
> ...
> 
>> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
>> new file mode 100644
>> index 000000000000..3a529c7950a1
>> --- /dev/null
>> +++ b/security/ipe/policy.c
>> @@ -0,0 +1,101 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
> 
> ...
> 
>> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>> +			  size_t asn1hdrlen)
>> +{
>> +	struct ipe_policy *p = ctx;
>> +
>> +	p->text = (const char *)data;
>> +	p->textlen = len;
>> +
>> +	return 0;
>> +}
> 
> The @asn1hdrlen parameter isn't used in this function, at least at this
> point in the patchset, so you really should remove it.  If it is needed
> later in the patchset you can always update the function.
>
Although the @asn1hdrlen is not used, it's a required parameter for the 
pkcs7 callback. I guess adding a __always_unused might be the right 
solution?

>> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
>> new file mode 100644
>> index 000000000000..c09458bd348d
>> --- /dev/null
>> +++ b/security/ipe/policy_parser.c
>> @@ -0,0 +1,487 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
> 
> ...
> 
>> +/**
>> + * remove_trailing_spaces - Truncate all trailing spaces in a string.
>> + *
>> + * @line: Supplies a poilcy line string for preprocessing.
>> + *
>> + * Return: The length of truncated string.
>> + */
>> +static size_t remove_trailing_spaces(char *line)
>> +{
>> +	size_t i = 0;
>> +
>> +	for (i = strlen(line); i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
>> +		;
> 
> Maybe I've asked this before, I can't remember: could you use the
> isspace() macro here instead of explicitly checking for ' ' and '\t'?
> Yes, isspace() works here. I will update this part.

>    i = strlen(line);
>    while (i > 0 && isspace(line[i - 1]))
>      i--;
>    line[i] = '\0';
> 
>> +	line[i] = '\0';
>> +
>> +	return i;
>> +}
>> +
>> +/**
>> + * parse_version - Parse policy version.
>> + * @ver: Supplies a version string to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Standard errno
>> + */
>> +static int parse_version(char *ver, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	size_t sep_count = 0;
>> +	char *token;
>> +	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
>> +
>> +	while ((token = strsep(&ver, ".")) != NULL) {
>> +		/* prevent overflow */
>> +		if (sep_count >= ARRAY_SIZE(cv))
>> +			return -EBADMSG;
>> +
>> +		rc = kstrtou16(token, 10, cv[sep_count]);
>> +		if (rc)
>> +			return rc;
>> +
>> +		++sep_count;
>> +	}
>> +
>> +	/* prevent underflow */
>> +	if (sep_count != ARRAY_SIZE(cv))
>> +		rc = -EBADMSG;
> 
> You could always just 'return -EBADMSG' here and 'return 0' below to
> simplify things a little.
> 
I agree, this part is kind of unnecessary. I will update accordingly.

>> +	return rc;
>> +}
>> +
>> +enum header_opt {
>> +	IPE_HEADER_POLICY_NAME = 0,
>> +	IPE_HEADER_POLICY_VERSION,
>> +	__IPE_HEADER_MAX
>> +};
>> +
>> +static const match_table_t header_tokens = {
>> +	{IPE_HEADER_POLICY_NAME,	"policy_name=%s"},
>> +	{IPE_HEADER_POLICY_VERSION,	"policy_version=%s"},
>> +	{__IPE_HEADER_MAX,		NULL}
>> +};
>> +
>> +/**
>> + * parse_header - Parse policy header information.
>> + * @line: Supplies header line to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Standard errno
>> + */
>> +static int parse_header(char *line, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	char *t, *ver = NULL;
>> +	substring_t args[MAX_OPT_ARGS];
>> +	size_t idx = 0;
>> +
>> +	while ((t = strsep(&line, IPE_POLICY_DELIM)) != NULL) {
>> +		int token;
>> +
>> +		if (*t == '\0')
>> +			continue;
>> +		if (idx >= __IPE_HEADER_MAX) {
>> +			rc = -EBADMSG;
>> +			goto out;
>> +		}
>> +
>> +		token = match_token(t, header_tokens, args);
>> +		if (token != idx) {
>> +			rc = -EBADMSG;
>> +			goto out;
>> +		}
>> +
>> +		switch (token) {
>> +		case IPE_HEADER_POLICY_NAME:
>> +			p->name = match_strdup(&args[0]);
>> +			if (!p->name)
>> +				rc = -ENOMEM;
>> +			break;
>> +		case IPE_HEADER_POLICY_VERSION:
>> +			ver = match_strdup(&args[0]);
>> +			if (!ver) {
>> +				rc = -ENOMEM;
>> +				break;
>> +			}
>> +			rc = parse_version(ver, p);
>> +			break;
>> +		default:
>> +			rc = -EBADMSG;
>> +		}
>> +		if (rc)
>> +			goto out;
>> +		++idx;
>> +	}
>> +
>> +	if (idx != __IPE_HEADER_MAX) {
>> +		rc = -EBADMSG;
>> +		goto out;
> 
> You probably don't need to 'goto out' here.
>
Yes it's unnecessary, thanks for pointing that out.

>> +	}
>> +
>> +out:
>> +	kfree(ver);
>> +	return rc;
>> +}
> 
> ...
> 
>> +/**
>> + * parse_rule - parse a policy rule line.
>> + * @line: Supplies rule line to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * !IS_ERR	- OK
>> + * * -ENOMEM	- Out of memory
>> + * * -EBADMSG	- Policy syntax error
>> + */
>> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	bool first_token = true, is_default_rule = false;
>> +	bool op_parsed = false;
>> +	enum ipe_op_type op = IPE_OP_INVALID;
>> +	enum ipe_action_type action = IPE_ACTION_INVALID;
>> +	struct ipe_rule *r = NULL;
>> +	char *t;
>> +
>> +	r = kzalloc(sizeof(*r), GFP_KERNEL);
>> +	if (!r)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&r->next);
>> +	INIT_LIST_HEAD(&r->props);
>> +
>> +	while (t = strsep(&line, IPE_POLICY_DELIM), line) {
>> +		if (*t == '\0')
>> +			continue;
>> +		if (first_token && token_default(t)) {
>> +			is_default_rule = true;
>> +		} else {
>> +			if (!op_parsed) {
>> +				op = parse_operation(t);
>> +				if (op == IPE_OP_INVALID)
>> +					rc = -EBADMSG;
>> +				else
>> +					op_parsed = true;
>> +			} else {
>> +				rc = parse_property(t, r);
>> +			}
>> +		}
>> +
>> +		if (rc)
>> +			goto err;
>> +		first_token = false;
>> +	}
>> +
>> +	action = parse_action(t);
>> +	if (action == IPE_ACTION_INVALID) {
>> +		rc = -EBADMSG;
>> +		goto err;
>> +	}
>> +
>> +	if (is_default_rule) {
>> +		if (!list_empty(&r->props)) {
>> +			rc = -EBADMSG;
>> +		} else if (op == IPE_OP_INVALID) {
>> +			if (p->global_default_action != IPE_ACTION_INVALID)
>> +				rc = -EBADMSG;
>> +			else
>> +				p->global_default_action = action;
>> +		} else {
>> +			if (p->rules[op].default_action != IPE_ACTION_INVALID)
>> +				rc = -EBADMSG;
>> +			else
>> +				p->rules[op].default_action = action;
>> +		}
>> +	} else if (op != IPE_OP_INVALID && action != IPE_ACTION_INVALID) {
>> +		r->op = op;
>> +		r->action = action;
>> +	} else {
>> +		rc = -EBADMSG;
>> +	}
> 
> I might be missing something important in the policy syntac, but could
> this function, and perhaps the ipe_parsed_policy struct, be simplified
> if the default action was an explicit rule?
> 
>   "op=DEFAULT action=ALLOW"
>
The complexity here arises from our need for two types of default rules: 
one for global settings and another for operation-specific settings.

To illustrate the flexibility of operation-specific default rules, users 
can set their policy to have a default rule of 'DENY' for execution, 
meaning all execution actions are prohibited by default. This let users 
to create an allow-list for execution. At the same time, the default 
rule for read can be set to 'ALLOW'.  This let users to create an 
deny-list for read.

Adding explicit default rules can simplify ipe_parsed_policy struct, but 
that impose a burden on users that requires users always add the default 
rules the end of the policy. In contrast, our current design allows 
users to place the default rule anywhere in the policy. In practice, we 
often position the default rule at the beginning of the policy, which 
makes it more convenient for users to add new rules.

>> +	if (rc)
>> +		goto err;
>> +	if (!is_default_rule)
>> +		list_add_tail(&r->next, &p->rules[op].rules);
>> +	else
>> +		free_rule(r);
>> +
>> +	return rc;
>> +err:
>> +	free_rule(r);
>> +	return rc;
>> +}
>> +
>> +/**
>> + * free_parsed_policy - free a parsed policy structure.
>> + * @p: Supplies the parsed policy.
>> + */
>> +void free_parsed_policy(struct ipe_parsed_policy *p)
>> +{
>> +	size_t i = 0;
>> +	struct ipe_rule *pp, *t;
>> +
>> +	if (IS_ERR_OR_NULL(p))
>> +		return;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
>> +		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next) {
>> +			list_del(&pp->next);
>> +			free_rule(pp);
>> +		}
>> +
>> +	kfree(p->name);
>> +	kfree(p);
>> +}
>> +
>> +/**
>> + * validate_policy - validate a parsed policy.
>> + * @p: Supplies the fully parsed policy.
>> + *
>> + * Given a policy structure that was just parsed, validate that all
>> + * necessary fields are present, initialized correctly.
>> + *
>> + * A parsed policy can be in an invalid state for use (a default was
>> + * undefined) by just parsing the policy.
>> + *
>> + * Return:
>> + * * 0		- OK
>> + * * -EBADMSG	- Policy is invalid
>> + */
>> +static int validate_policy(const struct ipe_parsed_policy *p)
>> +{
>> +	size_t i = 0;
>> +
>> +	if (p->global_default_action != IPE_ACTION_INVALID)
>> +		return 0;
> 
> Should the if conditional above be "==" and not "!="?
>No, "!=" is the correct one.

The purpose of validation is to ensure that we have enough default rules 
to cover all cases. If the global default action not invalid, it means 
we have a global default rule in the policy to cover all cases, thus we 
simply return 0.

However, if there is no global default rule, then we need to ensure that 
for each operation, there is a operation specific default rule, this is 
validated in the for loop below.

-Fan

>> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
>> +		if (p->rules[i].default_action == IPE_ACTION_INVALID)
>> +			return -EBADMSG;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> --
> paul-moore.com

