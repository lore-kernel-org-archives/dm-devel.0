Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB81C0015E
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mJWLFGT6WSx7kDlEd/sjHt2/P3RMxcIJvmV4GLnCBfI=;
	b=cDDkynyeHYZQt3MmTuRZGlSzhCWVVYvrotDoglVErotbxrbnkY6jdHikd+OqDPfurNthVZ
	7sIbmsbVU1IcmZJN9HSelEhFJltgNRly5nPU7LGtIA244Vols18Xbvmv5eeotcElnr6RhK
	Cps/B4jcwYi7BS5evjfDxIeOA6ZeF7c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-DWXRcWeqNbqSrscAcVqsMA-1; Sat, 08 Jul 2023 01:37:05 -0400
X-MC-Unique: DWXRcWeqNbqSrscAcVqsMA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E9FD101A54E;
	Sat,  8 Jul 2023 05:37:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B3F6200B402;
	Sat,  8 Jul 2023 05:37:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D02A1946A69;
	Sat,  8 Jul 2023 05:37:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65AB51946A5E
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:37:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48689492CAD; Sat,  8 Jul 2023 05:37:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FAEA492B02
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D40088D0F8
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:02 +0000 (UTC)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com
 [209.85.219.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-tWHrpI1rMOypJ10mAz0Ljw-1; Sat, 08 Jul 2023 01:37:00 -0400
X-MC-Unique: tWHrpI1rMOypJ10mAz0Ljw-1
Received: by mail-qv1-f54.google.com with SMTP id
 6a1803df08f44-635de022557so17094196d6.0
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794620; x=1691386620;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mRTut3OlHqKCWiM81ta7SjbBbT2KSyk5zN+hB2sD2J4=;
 b=CHlOR8i6e5PJUJPuHnPqIMdqT7oBhu0gNwFIAeyD1UlzQrCfwQM5VGxyiJO82mwDuu
 /eyMDUw4WOm1CHt5a5BVU87AYm0pTrmU3wK7pyhqlkqOeaTH33nzWZ8rAfcsTl3W6+aX
 EWqCxgr7EpH9Ch5AmFd7c9wgXxOj4CvZbSd1+YzWbG6xuCrK/dP3Zx/oHciagCv/fv42
 NE7ZFFL6+orRfsV8XWIccDqifCEXWftuwF86MJgEHL0HudA1EXe4rn+grqDBeGd/OnKC
 6dVEGGNhEAw33Cmq28B9hFUQYxD0ABqV/IgyMRw0aayUf7Jlu3TH4Bi7Qd0MdKlkMwGe
 QLLA==
X-Gm-Message-State: ABy/qLbMxA6lGSbMie+u6eFIv3sV4YSyZijAkGO/HaVYiX/ywNMlPPEK
 DvSSRi5fyOd9S765KlV8XZ6f
X-Google-Smtp-Source: APBJJlHQS5XBlGZlR3aeI4P59arzhT77oU+85EVLNEDa/0Wxlnb/6yUwkLDjlhT0yg5nRtXN/pQPYw==
X-Received: by 2002:a0c:dc87:0:b0:62d:efa2:f19f with SMTP id
 n7-20020a0cdc87000000b0062defa2f19fmr6824435qvk.54.1688794620221; 
 Fri, 07 Jul 2023 22:37:00 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 m6-20020a0cdb86000000b006362c5760f8sm2952625qvk.139.2023.07.07.22.36.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:36:59 -0400
Message-ID: <59d0824741118eb63b8ced046f1741f4.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

