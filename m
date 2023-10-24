Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416779D0
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ghtdn1yD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119555;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gkQv4NPpuq+SSSCpl9UyQF6YqX/MV1oQ90uakIxS1+8=;
	b=Ghtdn1yD+Na+UYzhyt/jBrleSV/oLNxRtfpgGbnB/p6rBRuNW1eOTHWOz+tB091iJ4kBCq
	beuHPqSp3X+T6tKe3cj65wpC7BtYaRhBT1XL4S78om09+q4RDbIflinWRnKBJZhGyUvt4Z
	9+3J5aek5mgp5pGQo5T0TVpjtbs41s8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-681-cxdgiU_GOBWV2sEyRFBazw-1; Mon, 23 Oct 2023 23:52:34 -0400
X-MC-Unique: cxdgiU_GOBWV2sEyRFBazw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3919D185A78E
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2FCE81C060AE
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C271E1946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C84BF1946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9F4D88CEF; Tue, 24 Oct 2023 03:52:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9845B8C0B
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:32 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69B24101A529
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:32 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-5ujlbYytMvqXqsjf15lr_g-1; Mon, 23 Oct 2023 23:52:28 -0400
X-MC-Unique: 5ujlbYytMvqXqsjf15lr_g-1
Received: by mail-qk1-f171.google.com with SMTP id
 af79cd13be357-7789cc5c8ccso330253885a.0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119548; x=1698724348;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=gkQv4NPpuq+SSSCpl9UyQF6YqX/MV1oQ90uakIxS1+8=;
 b=B2CKd4ipoMVfglhnclrbDL2Pu0yoLcjr3foCN/c09T90Riaf7RU9vmjeOXUscSwK2s
 RWLhWlRBiqixqKbesIVehqjdhUtShmfMOGTFczf2t2jW40sG3vNMpMCthU933m0kDxUm
 WfInEwqW7Umdm3jSzFU92OAXLJa2RNvP+iZanUchtkfF07QUT9XV1Ss830X4+R1h7NyM
 mN7OcSPz96eRjYzzMQkgg2lUunBRRbJ2O2zcKTznDePSxLK9doz0MWQ6Y/b8y7NOt6vW
 uQxgn4Q+j/yITlFFh1Zlnz6rgj6gO8ziV+P0zDI5pXZFYaJVFJJDJn82ILdDf9s3YveI
 McMQ==
X-Gm-Message-State: AOJu0YxLlC5VgY0NrekhnkY2LLO3nZZ0CMRDkFwIdsM1rIcMpY3pO3hQ
 l5KJEzwSm97EqU4+tWolJknn
X-Google-Smtp-Source: AGHT+IGpiqDf/TKC1eRppc/Gn4MIT1ywdMmENtPJG/iCE8tbE4s8HLyLA6+qJAYdCissawMFbRrNGA==
X-Received: by 2002:a05:620a:1a8d:b0:774:21d8:b0bb with SMTP id
 bl13-20020a05620a1a8d00b0077421d8b0bbmr14769901qkb.24.1698119548174; 
 Mon, 23 Oct 2023 20:52:28 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 x1-20020a05620a098100b0076f21383b6csm3157623qkx.112.2023.10.23.20.52.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:27 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:27 -0400
Message-ID: <9217384a1f58c5d3431b90f100c7de85.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 8/19] uapi|audit|ipe: add ipe auditing support
References: <1696457386-3010-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-9-git-send-email-wufan@linux.microsoft.com>
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
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
> 
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
>       old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649
>       new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
>       new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F
>       auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
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
> policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD
> auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed a new policy has been loaded into the kernel
> with the policy name, policy version and policy hash.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> 
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
>   + Further split lsm creation, the audit system, the evaluation loop,
>     and access control hooks into separate patches.
>   + Further split audit system patch into two separate patches; one
>     for include/uapi, and the usage of the new defines.
>   + Split out the permissive functionality into another separate patch,
>     for easier review.
>   + Correct misuse of audit_log_n_untrusted string to audit_log_format
>   + Use get_task_comm instead of comm directly.
>   + Quote certain audit values
>   + Remove unnecessary help text on choice options - these were
>     previously
>     idented at the wrong level
>   + Correct a stale string constant (ctx_ns_enforce to ctx_enforce)
> 
> v8:
> 
>   + Change dependency for CONFIG_AUDIT to CONFIG_AUDITSYSCALL
>   + Drop ctx_* prefix
>   + Reuse, where appropriate, the audit fields from the field
>     dictionary. This transforms:
>       ctx_pathname  -> path
>       ctx_ino       -> ino
>       ctx_dev       -> dev
> 
>   + Add audit records and event examples to commit description.
>   + Remove new_audit_ctx, replace with audit_log_start. All data that
>     would provided by new_audit_ctx is already present in the syscall
>     audit record, that is always emitted on these actions. The audit
>     records should be correlated as such.
>   + Change audit types:
>     + AUDIT_TRUST_RESULT                -> AUDIT_IPE_ACCESS
>       +  This prevents overloading of the AVC type.
>     + AUDIT_TRUST_POLICY_ACTIVATE       -> AUDIT_MAC_CONFIG_CHANGE
>     + AUDIT_TRUST_POLICY_LOAD           -> AUDIT_MAC_POLICY_LOAD
>       + There were no significant difference in meaning between
>         these types.
> 
>   + Remove enforcing parameter passed from the context structure
>     for AUDIT_IPE_ACCESS.
>     +  This field can be inferred from the SYSCALL audit event,
>        based on the success field.
> 
>   + Remove all fields already captured in the syscall record. "hook",
>     an IPE specific field, can be determined via the syscall field in
>     the syscall record itself, so it has been removed.
>       + ino, path, and dev in IPE's record refer to the subject of the
>         syscall, while the syscall record refers to the calling process.
> 
>   + remove IPE prefix from policy load/policy activation events
>   + fix a bug wherein a policy change audit record was not fired when
>     updating a policy
> 
> v9:
>   + Merge the AUDIT_IPE_ACCESS definition with the audit support commit
>   + Change the audit format of policy load and switch
>   + Remove the ipe audit kernel switch
> 
> v10:
>   + Create AUDIT_IPE_CONFIG_CHANGE and AUDIT_IPE_POLICY_LOAD
>   + Change field names per upstream feedback
> 
> v11:
>   + Fix style issues
> ---
>  include/uapi/linux/audit.h |   3 +
>  security/ipe/Kconfig       |   2 +-
>  security/ipe/Makefile      |   1 +
>  security/ipe/audit.c       | 195 +++++++++++++++++++++++++++++++++++++
>  security/ipe/audit.h       |  18 ++++
>  security/ipe/eval.c        |  32 ++++--
>  security/ipe/eval.h        |   8 ++
>  security/ipe/fs.c          |  70 +++++++++++++
>  security/ipe/policy.c      |   5 +
>  9 files changed, 327 insertions(+), 7 deletions(-)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..e123701d5e3b
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,195 @@
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
> +#define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
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

I would suggest taking the same approach for both @audit_op_names and
@audit_prop_names; either include the field name in the string array
for both or leave it out of both.

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
> +	list_for_each_entry(ptr, &r->props, next)
> +		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
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

Does it make sense to move @match_type into the ipe_eval_ctx struct?

> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +		     enum ipe_match match_type,
> +		     enum ipe_action_type act, const struct ipe_rule *const r)
> +{
> +	struct inode *inode;
> +	struct audit_buffer *ab;
> +	const char *op = audit_op_names[ctx->op];
> +
> +	if (act != IPE_ACTION_DENY && !READ_ONCE(success_audit))
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
> +			audit_log_format(ab, " ino=%lu ", inode->i_ino);
> +		}
> +	}
> +
> +	if (match_type == IPE_MATCH_RULE)
> +		audit_rule(ab, r);
> +	else if (match_type == IPE_MATCH_TABLE)
> +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> +				 ACTSTR(act));
> +	else
> +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> +				 ACTSTR(act));
> +
> +	audit_log_end(ab);
> +}

--
paul-moore.com

