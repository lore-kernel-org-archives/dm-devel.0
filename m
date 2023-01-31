Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA196C64EC3
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qmGuKc7AqQLjNqVz63UcnY9XMPh3Gnxiwv1RdanpC30=;
	b=JD7S0zOEBCqv9F+4jV+ScuPVueFubEJ8mw+kLi1eDyZg5zuYDqGe3PN7E+oygLDgOBIvBh
	s2FPWAB9T9pK4nki4G02xURqBe8RNT54PUtDO6TD7QHkyhk5as8XSJ6806a8U5ySm0CZIv
	hIGTLhBc2QbUB/zcc/S143HbuE1oDEE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-5FETMlDTOaasgQixqd9PMQ-1; Wed, 01 Feb 2023 03:04:00 -0500
X-MC-Unique: 5FETMlDTOaasgQixqd9PMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B682E100DEC9;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A192340C141B;
	Wed,  1 Feb 2023 08:03:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF9D71946A70;
	Wed,  1 Feb 2023 08:03:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F6871946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 10:46:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 737BF2166B36; Tue, 31 Jan 2023 10:46:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CCCA2166B34
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 10:46:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A441280605C
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 10:46:51 +0000 (UTC)
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com
 [14.137.139.154]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-pxgFhJVWNCegYrzuOPXFdA-1; Tue, 31 Jan 2023 05:46:46 -0500
X-MC-Unique: pxgFhJVWNCegYrzuOPXFdA-1
Received: from mail02.huawei.com (unknown [172.18.147.227])
 by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P5h1K3s2qz9v7c3;
 Tue, 31 Jan 2023 18:21:57 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
 by APP1 (Coremail) with SMTP id LxC2BwBHw_6T7dhj5nzgAA--.10536S2;
 Tue, 31 Jan 2023 11:29:51 +0100 (CET)
Message-ID: <5df3a80cc0d24e6d95d596910cb5c5356f7007c2.camel@huaweicloud.com>
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
 paul@paul-moore.com
Date: Tue, 31 Jan 2023 11:29:29 +0100
In-Reply-To: <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-Version: 1.0
X-CM-TRANSID: LxC2BwBHw_6T7dhj5nzgAA--.10536S2
X-Coremail-Antispam: 1UD129KBjvAXoW3CFy7WrWkKr1UCF1UJF4xJFb_yoW8Jw4DAo
 WfXa13uF4xtry3CrWj9a17AFW7Wa9Ygw4kJFZ0qrZrJFn2v34UKw1DAa15XF45uF1rJr15
 K34kZayrZF4Ut3Z3n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
 AaLaJ3UjIYCTnIWjp_UUUYU7kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
 8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
 AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF
 7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I
 0E14v26r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
 7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
 Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
 6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
 AIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
 6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAOBF1jj4RRhgAEsu
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 01 Feb 2023 08:03:52 +0000
Subject: Re: [dm-devel] [RFC PATCH v9 03/16] ipe: add evaluation loop and
 introduce 'boot_verified' as a trust provider
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
 linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-audit@redhat.com, linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> IPE must have a centralized function to evaluate incoming callers
> against IPE's policy. This iteration of the policy against the rules
> for that specific caller is known as the evaluation loop.
> 
> In addition, IPE is designed to provide system level trust guarantees,
> this usually implies that trust starts from bootup with a hardware root
> of trust, which validates the bootloader. After this, the bootloader
> verifies the kernel and the initramfs.
> 
> As there's no currently supported integrity method for initramfs, and
> it's typically already verified by the bootloader, introduce a property
> that causes the first superblock to have an execution to be "pinned",
> which is typically initramfs.

Uhm, I think it makes really sense to move the pinned logic in another
patch. This patch is very important, as it contains the policy logic.
It should be standalone.

> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move ipe_load_properties to patch 04.
>   + Remove useless 0-initializations
>   + Prefix extern variables with ipe_
>   + Remove kernel module parameters, as these are
>     exposed through sysctls.
>   + Add more prose to the IPE base config option
>     help text.
>   + Use GFP_KERNEL for audit_log_start.
>   + Remove unnecessary caching system.
>   + Remove comments from headers
>   + Use rcu_access_pointer for rcu-pointer null check
>   + Remove usage of reqprot; use prot only.
>   + Move policy load and activation audit event to 03/12
> 
> v4:
>   + Remove sysctls in favor of securityfs nodes
>   + Re-add kernel module parameters, as these are now
>     exposed through securityfs.
>   + Refactor property audit loop to a separate function.
> 
> v5:
>   + fix minor grammatical errors
>   + do not group rule by curly-brace in audit record,
>     reconstruct the exact rule.
> 
> v6:
>   + No changes
> 
> v7:
>   + Further split lsm creation into a separate commit from the
>     evaluation loop and audit system, for easier review.
> 
>   + Propogating changes to support the new ipe_context structure in the
>     evaluation loop.
> 
> v8:
>   + Remove ipe_hook enumeration; hooks can be correlated via syscall
>     record.
> 
> v9:
>   + Remove ipe_context related code and simplify the evaluation loop.
>   + Merge the evaluation loop commit with the boot_verified commit.
> ---
>  security/ipe/Makefile        |   1 +
>  security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h          |  28 ++++++
>  security/ipe/hooks.c         |  25 +++++
>  security/ipe/hooks.h         |  14 +++
>  security/ipe/ipe.c           |   1 +
>  security/ipe/policy.c        |  20 ++++
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |   8 +-
>  9 files changed, 279 insertions(+), 1 deletion(-)
>  create mode 100644 security/ipe/eval.c
>  create mode 100644 security/ipe/eval.h
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h
> 
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> index 16bbe80991f1..d7f2870d7c09 100644
> --- a/security/ipe/Makefile
> +++ b/security/ipe/Makefile
> @@ -6,6 +6,7 @@
>  #
>  
>  obj-$(CONFIG_SECURITY_IPE) += \
> +	eval.o \
>  	hooks.o \
>  	ipe.o \
>  	policy.o \
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> new file mode 100644
> index 000000000000..48b5104a3463
> --- /dev/null
> +++ b/security/ipe/eval.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/sched.h>
> +#include <linux/rcupdate.h>
> +#include <linux/spinlock.h>
> +
> +struct ipe_policy __rcu *ipe_active_policy;
> +
> +static struct super_block *pinned_sb;
> +static DEFINE_SPINLOCK(pin_lock);
> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> +
> +/**
> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> + * @f: Supplies a file structure to source the super_block from.
> + */
> +static void pin_sb(const struct file *f)
> +{
> +	if (!f)
> +		return;
> +	spin_lock(&pin_lock);
> +	if (pinned_sb)
> +		goto out;
> +	pinned_sb = FILE_SUPERBLOCK(f);
> +out:
> +	spin_unlock(&pin_lock);
> +}
> +
> +/**
> + * from_pinned - Determine whether @f is source from the pinned super_block.
> + * @f: Supplies a file structure to check against the pinned super_block.
> + *
> + * Return:
> + * * true	- @f is sourced from the pinned super_block
> + * * false	- @f is not sourced from the pinned super_block
> + */
> +static bool from_pinned(const struct file *f)
> +{
> +	bool rv;
> +
> +	if (!f)
> +		return false;
> +	spin_lock(&pin_lock);
> +	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
> +	spin_unlock(&pin_lock);
> +	return rv;
> +}
> +
> +/**
> + * build_eval_ctx - Build an evaluation context.
> + * @ctx: Supplies a pointer to the context to be populdated.
> + * @file: Supplies a pointer to the file to associated with the evaluation.
> + * @op: Supplies the IPE policy operation associated with the evaluation.
> + */
> +void build_eval_ctx(struct ipe_eval_ctx *ctx,
> +		    const struct file *file,
> +		    enum ipe_op_type op)
> +{
> +	ctx->file = file;
> +	ctx->op = op;
> +	ctx->from_init_sb = from_pinned(file);
> +}
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
> +	bool eval = false;
> +
> +	switch (p->type) {
> +	case ipe_prop_boot_verified_false:
> +		eval = !ctx->from_init_sb;
> +		break;
> +	case ipe_prop_boot_verified_true:
> +		eval = ctx->from_init_sb;
> +		break;
> +	default:
> +		eval = false;
> +	}
> +
> +	return eval;
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
> +	if (ctx->op == ipe_op_exec)
> +		pin_sb(ctx->file);
> +
> +	pol = ipe_get_policy_rcu(ipe_active_policy);
> +	if (!pol)
> +		goto out;
> +
> +	if (ctx->op == ipe_op_max) {
> +		action = pol->parsed->global_default_action;
> +		goto eval;
> +	}
> +
> +	rules = &pol->parsed->rules[ctx->op];
> +
> +	list_for_each_entry(rule, &rules->rules, next) {
> +		match = true;
> +
> +		list_for_each_entry(prop, &rule->props, next)
> +			match = match && evaluate_property(ctx, prop);
> +
> +		if (match)
> +			break;
> +	}
> +
> +	if (match)
> +		action = rule->action;
> +	else if (rules->default_action != ipe_action_max)
> +		action = rules->default_action;
> +	else
> +		action = pol->parsed->global_default_action;
> +
> +eval:
> +	if (action == ipe_action_deny)
> +		rc = -EACCES;
> +
> +out:
> +	return rc;
> +}
> +
> +/**
> + * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.

Typo: invalidte.

Roberto

> + * @mnt_sb: super_block to check against the pinned super_block.
> + *
> + * This function is called a super_block like the initramfs's is freed,
> + * if the super_block is currently pinned by ipe it will be invalided,
> + * so ipe won't consider the block device is boot verified afterward.
> + */
> +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
> +{
> +	spin_lock(&pin_lock);
> +
> +	if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb == pinned_sb)
> +		pinned_sb = ERR_PTR(-EIO);
> +
> +	spin_unlock(&pin_lock);
> +}
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> new file mode 100644
> index 000000000000..887797438b9b
> --- /dev/null
> +++ b/security/ipe/eval.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#ifndef IPE_EVAL_H
> +#define IPE_EVAL_H
> +
> +#include <linux/file.h>
> +#include <linux/types.h>
> +
> +#include "hooks.h"
> +#include "policy.h"
> +
> +extern struct ipe_policy __rcu *ipe_active_policy;
> +
> +struct ipe_eval_ctx {
> +	enum ipe_op_type op;
> +
> +	const struct file *file;
> +	bool from_init_sb;
> +};
> +
> +void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
> +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> +
> +#endif /* IPE_EVAL_H */
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..335b773c7ae1
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "hooks.h"
> +#include "eval.h"
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/binfmts.h>
> +#include <linux/mman.h>
> +
> +/**
> + * ipe_sb_free_security - ipe security hook function for super_block.
> + * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
> + *
> + * IPE does not have any structures with mnt_sb, but uses this hook to
> + * invalidate a pinned super_block.
> + */
> +void ipe_sb_free_security(struct super_block *mnt_sb)
> +{
> +	ipe_invalidate_pinned_sb(mnt_sb);
> +}
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> new file mode 100644
> index 000000000000..30fe455389bf
> --- /dev/null
> +++ b/security/ipe/hooks.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef IPE_HOOKS_H
> +#define IPE_HOOKS_H
> +
> +#include <linux/fs.h>
> +#include <linux/binfmts.h>
> +#include <linux/security.h>
> +
> +void ipe_sb_free_security(struct super_block *mnt_sb);
> +
> +#endif /* IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index 9ed3bf4dcc04..551c6d90ac11 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
>  };
>  
>  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
> +	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
>  };
>  
>  /**
> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index e446f4b84152..772d876b1087 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
>  err:
>  	return ERR_PTR(rc);
>  }
> +
> +/**
> + * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
> + *
> + * @p: rcu-protected pointer to a policy.
> + *
> + * Not safe to call on IS_ERR.
> + *
> + * Return: the value of @p
> + */
> +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
> +{
> +	struct ipe_policy *rv = NULL;
> +
> +	rcu_read_lock();
> +	rv = rcu_dereference(p);
> +	rcu_read_unlock();
> +
> +	return rv;
> +}
> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> index 6af2d9a811ec..967d816cd5cd 100644
> --- a/security/ipe/policy.h
> +++ b/security/ipe/policy.h
> @@ -26,6 +26,8 @@ enum ipe_action_type {
>  };
>  
>  enum ipe_prop_type {
> +	ipe_prop_boot_verified_false,
> +	ipe_prop_boot_verified_true,
>  	ipe_prop_max
>  };
>  
> @@ -73,5 +75,6 @@ struct ipe_policy {
>  struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
>  				  const char *pkcs7, size_t pkcs7len);
>  void ipe_free_policy(struct ipe_policy *pol);
> +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
>  
>  #endif /* IPE_POLICY_H */
> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> index c7ba0e865366..7efafc482e46 100644
> --- a/security/ipe/policy_parser.c
> +++ b/security/ipe/policy_parser.c
> @@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
>  }
>  
>  static const match_table_t property_tokens = {
> -	{ipe_prop_max,					NULL}
> +	{ipe_prop_boot_verified_false,	"boot_verified=FALSE"},
> +	{ipe_prop_boot_verified_true,	"boot_verified=TRUE"},
> +	{ipe_prop_max,			NULL}
>  };
>  
>  /**
> @@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
>  	token = match_token(t, property_tokens, args);
>  
>  	switch (token) {
> +	case ipe_prop_boot_verified_false:
> +	case ipe_prop_boot_verified_true:
> +		p->type = token;
> +		break;
>  	case ipe_prop_max:
>  	default:
>  		rc = -EBADMSG;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

