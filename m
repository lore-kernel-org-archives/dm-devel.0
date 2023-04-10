Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41DE1C77B61
	for <dm-devel@archiver.kernel.org>; Mon, 10 Apr 2023 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681152826;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yj63GdK/3NJFI0aiaocl5E2+bJahcojEsR78pm2Co8Q=;
	b=UMmZ/qrgK8T1W1s0CxUhpaRjW+ibAsAkYYztFGuATs3KTVb8u6NuBjGmivIY4XHOwmmXeZ
	USkHVJp0f5QSBaz/C9zmd6boOUjRTajxAFvSkNO6rtWxpYfIkAYfMMaNO59lwNXcu10KhW
	hNHEUjYSd505mcinMaukPRZT/2XZys4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-46VCACWuPga0hKGpCeBXgg-1; Mon, 10 Apr 2023 14:53:43 -0400
X-MC-Unique: 46VCACWuPga0hKGpCeBXgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB9A01C09043;
	Mon, 10 Apr 2023 18:53:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4601814171B7;
	Mon, 10 Apr 2023 18:53:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 081121946588;
	Mon, 10 Apr 2023 18:53:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39F0E1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Apr 2023 18:53:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B9952166B31; Mon, 10 Apr 2023 18:53:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 143992166B30
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 18:53:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E41E4803494
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 18:53:37 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-215-a4_a3DmNOIqjd0yyFiyIyg-1; Mon,
 10 Apr 2023 14:53:36 -0400
X-MC-Unique: a4_a3DmNOIqjd0yyFiyIyg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 99EB92174E2A; Mon, 10 Apr 2023 11:53:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99EB92174E2A
Date: Mon, 10 Apr 2023 11:53:34 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 02, 2023 at 02:03:11PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> >
> > IPE must have a centralized function to evaluate incoming callers
> > against IPE's policy. This iteration of the policy against the rules
> > for that specific caller is known as the evaluation loop.
> >
> > In addition, IPE is designed to provide system level trust guarantees,
> > this usually implies that trust starts from bootup with a hardware root
> > of trust, which validates the bootloader. After this, the bootloader
> > verifies the kernel and the initramfs.
> >
> > As there's no currently supported integrity method for initramfs, and
> > it's typically already verified by the bootloader, introduce a property
> > that causes the first superblock to have an execution to be "pinned",
> > which is typically initramfs.
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ...
> 
> > ---
> >  security/ipe/Makefile        |   1 +
> >  security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
> >  security/ipe/eval.h          |  28 ++++++
> >  security/ipe/hooks.c         |  25 +++++
> >  security/ipe/hooks.h         |  14 +++
> >  security/ipe/ipe.c           |   1 +
> >  security/ipe/policy.c        |  20 ++++
> >  security/ipe/policy.h        |   3 +
> >  security/ipe/policy_parser.c |   8 +-
> >  9 files changed, 279 insertions(+), 1 deletion(-)
> >  create mode 100644 security/ipe/eval.c
> >  create mode 100644 security/ipe/eval.h
> >  create mode 100644 security/ipe/hooks.c
> >  create mode 100644 security/ipe/hooks.h
> >
> > diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> > index 16bbe80991f1..d7f2870d7c09 100644
> > --- a/security/ipe/Makefile
> > +++ b/security/ipe/Makefile
> > @@ -6,6 +6,7 @@
> >  #
> >
> >  obj-$(CONFIG_SECURITY_IPE) += \
> > +       eval.o \
> >         hooks.o \
> >         ipe.o \
> >         policy.o \
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > new file mode 100644
> > index 000000000000..48b5104a3463
> > --- /dev/null
> > +++ b/security/ipe/eval.c
> > @@ -0,0 +1,180 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "ipe.h"
> > +#include "eval.h"
> > +#include "hooks.h"
> > +#include "policy.h"
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <linux/sched.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/spinlock.h>
> > +
> > +struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +static struct super_block *pinned_sb;
> > +static DEFINE_SPINLOCK(pin_lock);
> > +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> > +
> > +/**
> > + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> > + * @f: Supplies a file structure to source the super_block from.
> > + */
> > +static void pin_sb(const struct file *f)
> > +{
> > +       if (!f)
> > +               return;
> > +       spin_lock(&pin_lock);
> > +       if (pinned_sb)
> > +               goto out;
> > +       pinned_sb = FILE_SUPERBLOCK(f);
> > +out:
> > +       spin_unlock(&pin_lock);
> > +}
> 
> Since you don't actually use @f, just the super_block, you might
> consider passing the super_block as the parameter and not the
> associated file.
> 
> I'd probably also flip the if-then to avoid the 'goto', for example:
> 
>   static void pin_sb(const struct super_block *sb)
>   {
>     if (!sb)
>       return;
>     spin_lock(&pin_lock);
>     if (!pinned_sb)
>       pinned_sb = sb;
>     spin_unlock(&pin_lock);
>   }
> 

Sure, I can change the code accordingly. 

> Also, do we need to worry about the initramfs' being unmounted and the
> super_block going away?
> 

If initramfs is being unmounted, the boot_verified property will never be TRUE,
which is an expected behavior. In an actual use case, we can leverage this
property to only enable files in initramfs during the booting stage, and later switch
to another policy without the boot_verified property after unmounting the initramfs.
This approach helps keep the allowed set of files minimum at each stage.

> > +/**
> > + * from_pinned - Determine whether @f is source from the pinned super_block.
> > + * @f: Supplies a file structure to check against the pinned super_block.
> > + *
> > + * Return:
> > + * * true      - @f is sourced from the pinned super_block
> > + * * false     - @f is not sourced from the pinned super_block
> > + */
> > +static bool from_pinned(const struct file *f)
> > +{
> > +       bool rv;
> > +
> > +       if (!f)
> > +               return false;
> > +       spin_lock(&pin_lock);
> > +       rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
> > +       spin_unlock(&pin_lock);
> > +       return rv;
> > +}
> > +
> > +/**
> > + * build_eval_ctx - Build an evaluation context.
> > + * @ctx: Supplies a pointer to the context to be populdated.
> > + * @file: Supplies a pointer to the file to associated with the evaluation.
> > + * @op: Supplies the IPE policy operation associated with the evaluation.
> > + */
> > +void build_eval_ctx(struct ipe_eval_ctx *ctx,
> > +                   const struct file *file,
> > +                   enum ipe_op_type op)
> > +{
> > +       ctx->file = file;
> > +       ctx->op = op;
> > +       ctx->from_init_sb = from_pinned(file);
> > +}
> 
> I was a little concerned about the spinlock around the pinned
> superblock being a potential issue so I was checking the callers of
> `build_eval_ctx()` and realized there are no callers in this patch ...
> ?  Maybe it makes sense for `build_eval_ctx()` to be in this patch but
> it seems a little odd.
> 

I can try to move this function to a later patch.

> > +/**
> > + * evaluate_property - Analyze @ctx against a property.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + * @p: Supplies a pointer to the property to be evaluated.
> > + *
> > + * Return:
> > + * * true      - The current @ctx match the @p
> > + * * false     - The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> > +                             struct ipe_prop *p)
> > +{
> > +       bool eval = false;
> > +
> > +       switch (p->type) {
> > +       case ipe_prop_boot_verified_false:
> > +               eval = !ctx->from_init_sb;
> > +               break;
> > +       case ipe_prop_boot_verified_true:
> > +               eval = ctx->from_init_sb;
> > +               break;
> > +       default:
> > +               eval = false;
> 
> You don't need to set @eval to false both when it is declared or in
> the 'default' case.
> 
> Honestly, you don't need @eval at all, you can simply replace all of
> the @eval assignment statements with return statements.
> 

Yep, this makes sense to me, I will replace them with returns.

> > +       }
> > +
> > +       return eval;
> > +}
> > +
> > +/**
> > + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + *
> > + * This is the loop where all policy evaluation happens against IPE policy.
> > + *
> > + * Return:
> > + * * 0         - OK
> > + * * -EACCES   - @ctx did not pass evaluation.
> > + * * !0                - Error
> > + */
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> > +{
> > +       int rc = 0;
> > +       bool match = false;
> > +       enum ipe_action_type action;
> > +       struct ipe_policy *pol = NULL;
> > +       const struct ipe_rule *rule = NULL;
> > +       const struct ipe_op_table *rules = NULL;
> > +       struct ipe_prop *prop = NULL;
> > +
> > +       if (ctx->op == ipe_op_exec)
> > +               pin_sb(ctx->file);
> 
> If I understand things correctly, the initramfs is determined by the
> first process to be executed?  I think that's reasonable, but I'm
> beginning to wonder if that pinned super_block spinlock is going to be
> a problem, especially for something that is written once (twice if you
> consider the ERR_PTR(-EIO) on umount), yet read for each IPE policy
> evaluation.
> 
> I'm okay if you want to keep this as a spinlock for now, but this
> seems like a good candidate for RCU, and the change would be trivial
> since it is a single pointer.
> 

I agree switching to RCU will be better, I will change this part.

> > +       pol = ipe_get_policy_rcu(ipe_active_policy);
> 
> I don't think you can safely drop the RCU lock and leave the RCU
> critical section while you are still using @ipe_active_policy.  I
> think the right thing to do is to get rid of `ipe_get_policy_rcu()`
> and simply place from here on down in `ipe_evaluate_event()` in a RCU
> critical section.  Doing so would ensure that @ipe_active_policy could
> not be free'd/replaced from underneath you while evaluating an event.
> 

Yes After reading the RCU documentation, I realized that we were mistaken.
I will place the entire eval function into the critical section instead.

> > +       if (!pol)
> > +               goto out;
> > +
> > +       if (ctx->op == ipe_op_max) {
> > +               action = pol->parsed->global_default_action;
> > +               goto eval;
> > +       }
> > +
> > +       rules = &pol->parsed->rules[ctx->op];
> > +
> > +       list_for_each_entry(rule, &rules->rules, next) {
> > +               match = true;
> > +
> > +               list_for_each_entry(prop, &rule->props, next)
> > +                       match = match && evaluate_property(ctx, prop);
> > +
> > +               if (match)
> > +                       break;
> > +       }
> > +
> > +       if (match)
> > +               action = rule->action;
> > +       else if (rules->default_action != ipe_action_max)
> > +               action = rules->default_action;
> > +       else
> > +               action = pol->parsed->global_default_action;
> > +
> > +eval:
> > +       if (action == ipe_action_deny)
> > +               rc = -EACCES;
> > +
> > +out:
> > +       return rc;
> > +}
> > +
> > +/**
> > + * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.
> > + * @mnt_sb: super_block to check against the pinned super_block.
> > + *
> > + * This function is called a super_block like the initramfs's is freed,
> > + * if the super_block is currently pinned by ipe it will be invalided,
> > + * so ipe won't consider the block device is boot verified afterward.
> > + */
> > +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
> > +{
> > +       spin_lock(&pin_lock);
> > +
> > +       if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb == pinned_sb)
> > +               pinned_sb = ERR_PTR(-EIO);
> 
> I think you only need to check if @pinned_sb is equal to @mnt_sb,
> that's all that really matters here.
> 

Agree, will remove the unnecessary part.

> > +       spin_unlock(&pin_lock);
> > +}
> > diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> > new file mode 100644
> > index 000000000000..887797438b9b
> > --- /dev/null
> > +++ b/security/ipe/eval.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#ifndef IPE_EVAL_H
> > +#define IPE_EVAL_H
> > +
> > +#include <linux/file.h>
> > +#include <linux/types.h>
> > +
> > +#include "hooks.h"
> > +#include "policy.h"
> > +
> > +extern struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +struct ipe_eval_ctx {
> > +       enum ipe_op_type op;
> > +
> > +       const struct file *file;
> > +       bool from_init_sb;
> > +};
> > +
> > +void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
> > +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> > +
> > +#endif /* IPE_EVAL_H */
> > diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> > new file mode 100644
> > index 000000000000..335b773c7ae1
> > --- /dev/null
> > +++ b/security/ipe/hooks.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "ipe.h"
> > +#include "hooks.h"
> > +#include "eval.h"
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/mman.h>
> > +
> > +/**
> > + * ipe_sb_free_security - ipe security hook function for super_block.
> > + * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
> > + *
> > + * IPE does not have any structures with mnt_sb, but uses this hook to
> > + * invalidate a pinned super_block.
> > + */
> > +void ipe_sb_free_security(struct super_block *mnt_sb)
> > +{
> > +       ipe_invalidate_pinned_sb(mnt_sb);
> > +}
> > diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> > new file mode 100644
> > index 000000000000..30fe455389bf
> > --- /dev/null
> > +++ b/security/ipe/hooks.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef IPE_HOOKS_H
> > +#define IPE_HOOKS_H
> > +
> > +#include <linux/fs.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/security.h>
> > +
> > +void ipe_sb_free_security(struct super_block *mnt_sb);
> > +
> > +#endif /* IPE_HOOKS_H */
> > diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> > index 9ed3bf4dcc04..551c6d90ac11 100644
> > --- a/security/ipe/ipe.c
> > +++ b/security/ipe/ipe.c
> > @@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
> >  };
> >
> >  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
> > +       LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
> >  };
> >
> >  /**
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > index e446f4b84152..772d876b1087 100644
> > --- a/security/ipe/policy.c
> > +++ b/security/ipe/policy.c
> > @@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> >  err:
> >         return ERR_PTR(rc);
> >  }
> > +
> > +/**
> > + * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
> > + *
> > + * @p: rcu-protected pointer to a policy.
> > + *
> > + * Not safe to call on IS_ERR.
> > + *
> > + * Return: the value of @p
> > + */
> > +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
> > +{
> > +       struct ipe_policy *rv = NULL;
> > +
> > +       rcu_read_lock();
> > +       rv = rcu_dereference(p);
> > +       rcu_read_unlock();
> > +
> > +       return rv;
> > +}
> > diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> > index 6af2d9a811ec..967d816cd5cd 100644
> > --- a/security/ipe/policy.h
> > +++ b/security/ipe/policy.h
> > @@ -26,6 +26,8 @@ enum ipe_action_type {
> >  };
> >
> >  enum ipe_prop_type {
> > +       ipe_prop_boot_verified_false,
> > +       ipe_prop_boot_verified_true,
> >         ipe_prop_max
> >  };
> >
> > @@ -73,5 +75,6 @@ struct ipe_policy {
> >  struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> >                                   const char *pkcs7, size_t pkcs7len);
> >  void ipe_free_policy(struct ipe_policy *pol);
> > +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
> >
> >  #endif /* IPE_POLICY_H */
> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > index c7ba0e865366..7efafc482e46 100644
> > --- a/security/ipe/policy_parser.c
> > +++ b/security/ipe/policy_parser.c
> > @@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
> >  }
> >
> >  static const match_table_t property_tokens = {
> > -       {ipe_prop_max,                                  NULL}
> > +       {ipe_prop_boot_verified_false,  "boot_verified=FALSE"},
> > +       {ipe_prop_boot_verified_true,   "boot_verified=TRUE"},
> > +       {ipe_prop_max,                  NULL}
> >  };
> >
> >  /**
> > @@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
> >         token = match_token(t, property_tokens, args);
> >
> >         switch (token) {
> > +       case ipe_prop_boot_verified_false:
> > +       case ipe_prop_boot_verified_true:
> > +               p->type = token;
> > +               break;
> >         case ipe_prop_max:
> >         default:
> >                 rc = -EBADMSG;
> > --
> > 2.39.0
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

