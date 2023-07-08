Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EB8EB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790203;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kx8+RFoNjVe2xV8EFZyXB2xX2W4WI7s0/jEGfPZUmtE=;
	b=XCzpOOitCoy+p9Y/GNQV7efQMC/Msqvpe0tMiEyPxt4sRRGX5arkAEN0Vvwj4tel73QRoT
	1I96nn8nHg24fzzk/kduP/rTYvp6tvDTOQqdiHe+wLi6+5MqFg5wvrxyoPKbMNby/ZaSm7
	NhfXhvhXmAp5tScZWff47xhrGZwjOAQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-EaOX51VAMvWzWmcGpHpZLw-1; Sat, 08 Jul 2023 00:23:12 -0400
X-MC-Unique: EaOX51VAMvWzWmcGpHpZLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73DC4800159;
	Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5E10F40C206F;
	Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FE851946A61;
	Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E59C1946A5A
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F7781121333; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07CFD1121330
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA738019DC
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-3mcCheHFNmC_HRT-dV9CdA-1; Sat, 08 Jul 2023 00:23:06 -0400
X-MC-Unique: 3mcCheHFNmC_HRT-dV9CdA-1
Received: by mail-qk1-f172.google.com with SMTP id
 af79cd13be357-7658430eb5dso258737185a.2
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790186; x=1691382186;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=qNlYri3TjRJrXDx/DKkNNseMULe3zgHfRnT558fZAd8=;
 b=PUF+wRXAwffUtyjbQcNyhPYqEMSAu6OaPnRb6YYW3IjpVIZEPuxLziiGjO4IFHFZQu
 uaxEtnc+4H5529Cit+E51T8D4lvdi2OxV+mn2iPtnqhUxcoIgyNDZeJeAUwGO1WPTjxM
 kRsLtfMdyeisFWWXMPuXEZlejJtSNwlsoeUj8FrSBiQSrCVrdX9d45DO5sglqOw+J1ue
 dP7kY0rxtd9452aj6PHklsMi3NqOtXBpxhygBnntcLuQa6xI7cjjx1+Aaio00zkQvRWH
 nFlV6en9kD5SDjbOwayMOYymCbVqD2bMgrf4biQLCTqXthYMeWW5Rvc9nGnfndBH6UOs
 gWQA==
X-Gm-Message-State: ABy/qLZtFQ9RWL6o9Qheu7XWoFrvRTevMDX9sEzLOBudXVu/ek5OTtqu
 xBHmis//64e4MTa4ACwZ5IN8
X-Google-Smtp-Source: APBJJlE9ncmxW5QpPXXqAOWGP53q1BeH5K5yrQHTmt7eMo/WxTYkafvjTLOyPdI/JcoFoFIkIbuDoA==
X-Received: by 2002:a05:620a:2b24:b0:765:ab7c:895e with SMTP id
 do36-20020a05620a2b2400b00765ab7c895emr7160781qkb.24.1688790186322; 
 Fri, 07 Jul 2023 21:23:06 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 f5-20020a05620a068500b00767bac7d537sm576958qkh.24.2023.07.07.21.23.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:06 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:05 -0400
Message-ID: <ec09144af7c7109d8b457ceccd50ba7a.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-9-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v10 8/17] uapi|audit|ipe: add ipe
 auditing support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Users of IPE require a way to identify when and why an operation fails,
> allowing them to both respond to violations of policy and be notified
> of potentially malicious actions on their systems with respect to IPE
> itself.
> 
> This patch introduces 3 new audit events.
> 
> AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
> of a resource.
> AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
> has been changed to another loaded policy.
> AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
> into the kernel.
> 
> This patch also adds support for success auditing, allowing users to
> identify why an allow decision was made for a resource. However, it is
> recommended to use this option with caution, as it is quite noisy.
> 
> Here are some examples of the new audit record types:
> 
> AUDIT_IPE_ACCESS(1420):
> 
>     audit: AUDIT1420 path="/root/vol/bin/hello" dev="sda"
>       ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"

The 'dev' field is already in use by audit, and is used to log the
device major and minor numbers, see audit_log_name() for an example.

I would suggest adopting the existing 'dev' field format, but if you
really want to log the device name as a string you will need to find
another audit field name.

>     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
> 
>     audit: AUDIT1420 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
>       ino=131 rule="DEFAULT action=DENY"
> 
> The above three records were generated when the active IPE policy only
> allows binaries from the initial booted drive(sda) to run. The three
> identical `hello` binary were placed at different locations, only the
> first hello from sda was allowed.
> 
> Field path followed by the file's path name.
> 
> Field dev followed by the device name as found in /dev where the file is
> from.
> Note that for device mappers it will use the name `dm-X` instead of
> the name in /dev/mapper.
> For a file in a temp file system, which is not from a device, it will use
> `tmpfs` for the field.
> The implementation of this part is following another existing use case
> LSM_AUDIT_DATA_INODE in security/lsm_audit.c
> 
> Field ino followed by the file's inode number.
> 
> Field rule followed by the IPE rule made the access decision. The whole
> rule must be audited because the decision is based on the combination of
> all property conditions in the rule.
> 
> Along with the syscall audit event, user can know why a blocked
> happened. For example:
> 
>     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
>     audit[1956]: SYSCALL arch=c000003e syscall=59
>       success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
>       a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
>       gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
>       ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
> 
> The above two records showed bash used execve to run "hello" and got
> blocked by IPE. Note that the IPE records are always prior to a SYSCALL
> record.
> 
> AUDIT_IPE_CONFIG_CHANGE(1421):
> 
>     audit: AUDIT1421
>       old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
>       old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
>       new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
>       new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB
>       auid=4294967295 ses=4294967295 lsm=ipe res=1

You can trim hash digest strings so they better fit in terminals, for
example:

  old_policy_digest=sha256:E3B0C44....

> The above record showed the current IPE active policy switch from
> `Allow_All` to `boot_verified` along with the version and the hash
> digest of the two policies. Note IPE can only have one policy active
> at a time, all access decision evaluation is based on the current active
> policy.
> The normal procedure to deploy a policy is loading the policy to deploy
> into the kernel first, then switch the active policy to it.
> 
> AUDIT_IPE_POLICY_LOAD(1422):
> 
> audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
> policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB
> auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed a new policy has been loaded into the kernel
> with the policy name, policy version and policy hash.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  include/uapi/linux/audit.h |   3 +
>  security/ipe/Kconfig       |   2 +-
>  security/ipe/Makefile      |   1 +
>  security/ipe/audit.c       | 197 +++++++++++++++++++++++++++++++++++++
>  security/ipe/audit.h       |  18 ++++
>  security/ipe/eval.c        |  26 ++++-
>  security/ipe/eval.h        |   8 ++
>  security/ipe/fs.c          |  71 +++++++++++++
>  security/ipe/policy.c      |   5 +
>  9 files changed, 327 insertions(+), 4 deletions(-)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..d3f78a7fc93f
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,197 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/audit.h>
> +#include <linux/types.h>
> +#include <crypto/hash.h>
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +#include "audit.h"
> +
> +#define ACTSTR(x) ((x) == __IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
> +
> +#define IPE_AUDIT_HASH_ALG "sha256"
> +
> +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
> +			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
> +				    "old_active_pol_version=%hu.%hu.%hu "\
> +				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
> +				    "new_active_pol_version=%hu.%hu.%hu "\
> +				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +
> +static const char *const audit_op_names[__IPE_OP_MAX] = {
> +	"EXECUTE",
> +	"FIRMWARE",
> +	"KMODULE",
> +	"KEXEC_IMAGE",
> +	"KEXEC_INITRAMFS",
> +	"IMA_POLICY",
> +	"IMA_X509_CERT",
> +};
> +
> +static const char *const audit_prop_names[__IPE_PROP_MAX] = {
> +	"boot_verified=FALSE",
> +	"boot_verified=TRUE",
> +};
> +
> +/**
> + * audit_rule - audit an IPE policy rule approximation.
> + * @ab: Supplies a pointer to the audit_buffer to append to.
> + * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
> + */
> +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
> +{
> +	const struct ipe_prop *ptr;
> +
> +	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
> +
> +	list_for_each_entry(ptr, &r->props, next) {
> +		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
> +		audit_log_format(ab, " ");

Why make two calls to audit_log_format()?  You can just use "%s " as
the format string.

> +	}
> +
> +	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
> +}
> +
> +/**
> + * ipe_audit_match - audit a match for IPE policy.
> + * @ctx: Supplies a pointer to the evaluation context that was used in the
> + *	 evaluation.
> + * @match_type: Supplies the scope of the match: rule, operation default,
> + *		global default.
> + * @act: Supplies the IPE's evaluation decision, deny or allow.
> + * @r: Supplies a pointer to the rule that was matched, if possible.
> + * @enforce: Supplies the enforcement/permissive state at the point
> + *	     the enforcement decision was made.
> + */
> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +		     enum ipe_match match_type,
> +		     enum ipe_action_type act, const struct ipe_rule *const r)
> +{
> +	struct inode *inode;
> +	struct audit_buffer *ab;
> +	const char *op = audit_op_names[ctx->op];
> +
> +	if (act != __IPE_ACTION_DENY && !READ_ONCE(success_audit))
> +		return;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
> +	if (!ab)
> +		return;
> +
> +	if (ctx->file) {
> +		audit_log_d_path(ab, "path=", &ctx->file->f_path);
> +		inode = file_inode(ctx->file);
> +		if (inode) {
> +			audit_log_format(ab, " dev=");
> +			audit_log_untrustedstring(ab, inode->i_sb->s_id);

See my comments above about using the 'dev' field name, however, you
shouldn't need to log the device name as an untrusted string as the
string is coming from a trusted source within the kernel (the driver).

> +			audit_log_format(ab, " ino=%lu ", inode->i_ino);
> +		}
> +	}
> +
> +	if (match_type == __IPE_MATCH_RULE)
> +		audit_rule(ab, r);
> +	else if (match_type == __IPE_MATCH_TABLE)
> +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> +				 ACTSTR(act));
> +	else
> +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> +				 ACTSTR(act));
> +
> +	audit_log_end(ab);
> +}

...

> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index 88c625d6af97..8fcdb2ea19f4 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -13,6 +13,7 @@
>  #include "policy.h"
>  
>  extern struct ipe_policy __rcu *ipe_active_policy;
> +extern bool success_audit;
>  
>  struct ipe_eval_ctx {
>  	enum ipe_op_type op;
> @@ -21,6 +22,13 @@ struct ipe_eval_ctx {
>  	bool from_init_sb;
>  };
>  
> +enum ipe_match {
> +	__IPE_MATCH_RULE = 0,
> +	__IPE_MATCH_TABLE,
> +	__IPE_MATCH_GLOBAL,
> +	__IPE_MATCH_MAX
> +};
> +
>  void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
>  int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
>  void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> index 522162af741a..6bd2aa84831b 100644
> --- a/security/ipe/fs.c
> +++ b/security/ipe/fs.c
> @@ -8,11 +8,65 @@
>  
>  #include "ipe.h"
>  #include "fs.h"
> +#include "eval.h"
>  #include "policy.h"
> +#include "audit.h"
>  
>  static struct dentry *np __ro_after_init;
>  static struct dentry *root __ro_after_init;
>  struct dentry *policy_root __ro_after_init;
> +static struct dentry *audit_node __ro_after_init;
> +
> +/**
> + * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t setaudit(struct file *f, const char __user *data,
> +			size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	bool value;
> +
> +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	value = READ_ONCE(success_audit);

I don't understand why you are setting @value here only to change its
value in the line below ... ?

> +	rc = kstrtobool_from_user(data, len, &value);
> +	if (rc)
> +		return rc;
> +
> +	WRITE_ONCE(success_audit, value);
> +
> +	return len;
> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

