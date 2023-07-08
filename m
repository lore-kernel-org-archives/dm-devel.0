Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D36EEB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790209;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mJWLFGT6WSx7kDlEd/sjHt2/P3RMxcIJvmV4GLnCBfI=;
	b=Yccp3vxRAbX9Jl/Dujj8zBiw4hCNYvjfWcJ++og9AMVSeVvd98LRnrvHZHyVxzwUFt1eHa
	2lEkMyv5vmapaKtogEW1eIQS2xUW5uHN4cGwOHMOKYZJU39hVGwuT5re/8tDDVVIltYgXf
	8A2Ra3cYhVxhQfzv7wnLf44YB02tjRM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-6Qf-QjquO0eBB7ii91Jgyw-1; Sat, 08 Jul 2023 00:23:26 -0400
X-MC-Unique: 6Qf-QjquO0eBB7ii91Jgyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6103180269A;
	Sat,  8 Jul 2023 04:23:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4F72E40C206F;
	Sat,  8 Jul 2023 04:23:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0AA361946A61;
	Sat,  8 Jul 2023 04:23:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BE631946A70
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 63B611454155; Sat,  8 Jul 2023 04:23:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A59A1454154
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1862F8022EF
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-Rg_cT_dePau4HrN73l87qQ-1; Sat, 08 Jul 2023 00:23:06 -0400
X-MC-Unique: Rg_cT_dePau4HrN73l87qQ-1
Received: by mail-qt1-f175.google.com with SMTP id
 d75a77b69052e-403a1d7d60fso3959561cf.1
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790185; x=1691382185;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mRTut3OlHqKCWiM81ta7SjbBbT2KSyk5zN+hB2sD2J4=;
 b=ZOC/bVjGcnH1liNPdUv18vE9hxhwmoAi8fNJAnx5hy8gjs2GbWHE71PhxUhK7V3V4t
 k257KYVWrfhqHSBc8eusnSue4BvFgnTXO0/p4i64Hjf3/y+PbCzni0lpaJTeWtwzjRaF
 z393/n9/4Uqoe0gYmSiL1/BuPAk1Mm8rpI9le/WRYWwX0siEhybTKk5fCe8y6BAIq4WC
 DyamE3woRgQ8ddZjg5r6lI5hNNdwwT4TTokg9J22fPMSjWM61R1exlhFswWeCfULqhmr
 /8PAnJozdRVQx05OgHQ01JjIxCgbUB5skzUcLepPMqgOrikoBwq1e6G5zqvTteUSIBJW
 f9Ww==
X-Gm-Message-State: ABy/qLaNn4i/a2URFb0cYnm9rZeEOdL0cMCNbS4QM0fCIT5UNKm2eYjd
 +n2jT5RKux06+nATGpOjVIyo
X-Google-Smtp-Source: APBJJlH0ZMT4VYDpNEpFxWjTmlA4/4Jt9uagEi64mvWKwMpvdWefsNCfoeln1MmOFmhza+gokZd1Eg==
X-Received: by 2002:a05:622a:291:b0:400:aa47:a4a1 with SMTP id
 z17-20020a05622a029100b00400aa47a4a1mr8792736qtw.25.1688790185426; 
 Fri, 07 Jul 2023 21:23:05 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 l29-20020ac8459d000000b004035cf1cc1asm1671692qtn.41.2023.07.07.21.23.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:05 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:04 -0400
Message-ID: <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH RFC v10 7/17] ipe: add userspace interface
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
> As is typical with LSMs, IPE uses securityfs as its interface with
> userspace. for a complete list of the interfaces and the respective
> inputs/outputs, please see the documentation under
> admin-guide/LSM/ipe.rst
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile    |   2 +
>  security/ipe/fs.c        | 101 ++++++++
>  security/ipe/fs.h        |  16 ++
>  security/ipe/ipe.c       |   3 +
>  security/ipe/ipe.h       |   2 +
>  security/ipe/policy.c    | 111 +++++++++
>  security/ipe/policy.h    |   9 +
>  security/ipe/policy_fs.c | 481 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 725 insertions(+)
>  create mode 100644 security/ipe/fs.c
>  create mode 100644 security/ipe/fs.h
>  create mode 100644 security/ipe/policy_fs.c

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index 4069ff075093..3e8e4a06a044 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -7,9 +7,36 @@
>  #include <linux/verification.h>
>  
>  #include "ipe.h"
> +#include "eval.h"
> +#include "fs.h"
>  #include "policy.h"
>  #include "policy_parser.h"
>  
> +/* lock for synchronizing writers across ipe policy */
> +DEFINE_MUTEX(ipe_policy_lock);
> +
> +/**
> + * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
> + * @p: Policy to extract the version from.
> + *
> + * Bits (LSB is index 0):
> + *	[48,32] -> Major
> + *	[32,16] -> Minor
> + *	[16, 0] -> Revision
> + *
> + * Return: u64 version of the embedded version structure.
> + */
> +static inline u64 ver_to_u64(const struct ipe_policy *const p)
> +{
> +	u64 r;
> +
> +	r = (((u64)p->parsed->version.major) << 32)
> +	  | (((u64)p->parsed->version.minor) << 16)
> +	  | ((u64)(p->parsed->version.rev));
> +
> +	return r;
> +}
> +
>  /**
>   * ipe_free_policy - Deallocate a given IPE policy.
>   * @p: Supplies the policy to free.
> @@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
>  	if (IS_ERR_OR_NULL(p))
>  		return;
>  
> +	ipe_del_policyfs_node(p);
>  	free_parsed_policy(p->parsed);
>  	if (!p->pkcs7)
>  		kfree(p->text);
> @@ -39,6 +67,65 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>  	return 0;
>  }
>  
> +/**
> + * ipe_update_policy - parse a new policy and replace @old with it.

What does "@old" refer to?  I'm guessing you want to drop the "@".

> + * @root: Supplies a pointer to the securityfs inode saved the policy.
> + * @text: Supplies a pointer to the plain text policy.
> + * @textlen: Supplies the length of @text.
> + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> + * @pkcs7len: Supplies the length of @pkcs7len.
> + *
> + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> + * ipe_new_policy.
> + *
> + * Return:
> + * * !IS_ERR	- The old policy

"The old policy" is what?

> + * * -ENOENT	- Policy doesn't exist
> + * * -EINVAL	- New policy is invalid
> + */
> +struct ipe_policy *ipe_update_policy(struct inode *root,
> +				     const char *text, size_t textlen,
> +				     const char *pkcs7, size_t pkcs7len)
> +{
> +	int rc = 0;
> +	struct ipe_policy *old, *ap, *new = NULL;
> +
> +	lockdep_assert_held(&ipe_policy_lock);
> +
> +	old = (struct ipe_policy *)root->i_private;
> +	if (!old)
> +		return ERR_PTR(-ENOENT);
> +
> +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> +	if (IS_ERR(new))
> +		return new;
> +
> +	if (strcmp(new->parsed->name, old->parsed->name)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (ver_to_u64(old) > ver_to_u64(new)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	root->i_private = new;
> +
> +	ap = rcu_dereference_protected(ipe_active_policy,
> +				       lockdep_is_held(&ipe_policy_lock));
> +	if (old == ap)
> +		rcu_assign_pointer(ipe_active_policy, new);
> +
> +	swap(new->policyfs, old->policyfs);

We don't have to worry about @new, but is there a guarantee that this
function is the only one attempting to modify @old?

*EDIT*: I found that @root is locked by the caller, that's good.  I
would suggest adding this assumption/requirement to the function's
description.  In general whenever a function requires something from
a caller it should be documented in the function's description.

> +out:
> +	return (rc < 0) ? ERR_PTR(rc) : old;
> +err:
> +	ipe_free_policy(new);
> +	goto out;
> +}
> +

...

> diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
> new file mode 100644
> index 000000000000..52a120118cda
> --- /dev/null
> +++ b/security/ipe/policy_fs.c
> @@ -0,0 +1,481 @@

...

> +/**
> + * getactive - Read handler for "ipe/policies/$name/active".
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Suppleis a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * @data will be populated with the 1 or 0 depending on if the
> + * corresponding policy is active.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t getactive(struct file *f, char __user *data,
> +			 size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	const char *str;
> +	struct inode *root = NULL;
> +	const struct ipe_policy *p = NULL;
> +
> +	root = d_inode(f->f_path.dentry->d_parent);
> +
> +	inode_lock_shared(root);
> +	p = (struct ipe_policy *)root->i_private;
> +	if (!p) {
> +		inode_unlock_shared(root);
> +		return -ENOENT;
> +	}
> +	inode_unlock_shared(root);
> +
> +	str = (p == rcu_access_pointer(ipe_active_policy)) ? "1" : "0";

The line above should be wrapped with a RCU lock.

> +	rc = simple_read_from_buffer(data, len, offset, str, 1);
> +
> +	return rc;
> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

