Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC150C05027
	for <dm-devel@archiver.kernel.org>; Thu,  9 Feb 2023 03:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675913889;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IJy6APZlkRzh/9zP/0QCeSwgU4kH6b74b5OyKekUzaQ=;
	b=Pa1eI5+BVF8upawwquC8QIel/wYGhND6ku3syUKFAw5p1/HVmOyIJ0IHxtFYqgvcCfPziF
	uo0CgwtknhEuardtz0RoQll3Fjaf301dZ0H5DIb+ckSpp5sxjd2SrddtrWDgkbWw3Mhln6
	dP6zQkJT3Ne8R5kdZly4mI+rM6rvwHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-E5qd3drWObq4Fw2XKCWyUg-1; Wed, 08 Feb 2023 22:38:06 -0500
X-MC-Unique: E5qd3drWObq4Fw2XKCWyUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15CA387B2A0;
	Thu,  9 Feb 2023 03:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94D6418EC2;
	Thu,  9 Feb 2023 03:38:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 63CBF194658D;
	Thu,  9 Feb 2023 03:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D8FE41946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Feb 2023 03:37:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB86C2166B2C; Thu,  9 Feb 2023 03:37:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A396C2166B2B
 for <dm-devel@redhat.com>; Thu,  9 Feb 2023 03:37:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 852D385A5A3
 for <dm-devel@redhat.com>; Thu,  9 Feb 2023 03:37:59 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-HCcgC_WvMo-r6KjP9mEL7g-1; Wed, 08 Feb 2023 22:37:55 -0500
X-MC-Unique: HCcgC_WvMo-r6KjP9mEL7g-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 78040CE22A2;
 Thu,  9 Feb 2023 03:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811C9C433EF;
 Thu,  9 Feb 2023 03:30:35 +0000 (UTC)
Date: Wed, 8 Feb 2023 19:30:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Message-ID: <Y+Ro2Uor21d/Gfqc@sol.localdomain>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <1675119451-23180-13-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH v9 12/16] fsverity: consume builtin
 signature via LSM hook
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
Cc: axboe@kernel.dk, tytso@mit.edu, paul@paul-moore.com, dm-devel@redhat.com,
 corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

So disregarding the fact that using the fsverity builtin signatures still seems
like a bad idea to me, here's a few comments on the diff itself:

On Mon, Jan 30, 2023 at 02:57:27PM -0800, Fan Wu wrote:
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 81ff94442f7b..7e6fa52c0e9c 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -7,7 +7,9 @@
>  
>  #include "fsverity_private.h"
>  
> +#include <linux/security.h>
>  #include <linux/slab.h>
> +#include <crypto/public_key.h>

There's no need to include <crypto/public_key.h>.

>  
>  static struct kmem_cache *fsverity_info_cachep;
>  
> @@ -146,7 +148,7 @@ static int compute_file_digest(struct fsverity_hash_alg *hash_alg,
>   * appended signature), and check the signature if present.  The
>   * fsverity_descriptor must have already undergone basic validation.
>   */
> -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>  					   struct fsverity_descriptor *desc)
>  {
>  	struct fsverity_info *vi;
> @@ -182,6 +184,15 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  
>  	err = fsverity_verify_signature(vi, desc->signature,
>  					le32_to_cpu(desc->sig_size));
> +	if (err) {
> +		fsverity_err(inode, "Error %d verifying signature", err);
> +		goto out;
> +	}

The above error message is unnecessary because fsverity_verify_signature()
already prints an error message on failure.

> +
> +	err = security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME, desc->signature,
> +					 le32_to_cpu(desc->sig_size), 0);

This runs even if CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled.  Is that
really the right behavior?

Also a nit: please stick to the preferred line length of 80 characters.
See Documentation/process/coding-style.rst

> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 143a530a8008..5d7b9496f9c4 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -9,6 +9,7 @@
>  
>  #include <linux/cred.h>
>  #include <linux/key.h>
> +#include <linux/security.h>
>  #include <linux/slab.h>
>  #include <linux/verification.h>

This change is unnecessary.

> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 40f14e5fed9d..29e9888287ba 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -254,4 +254,6 @@ static inline bool fsverity_active(const struct inode *inode)
>  	return fsverity_get_info(inode) != NULL;
>  }
>  
> +#define FS_VERITY_INODE_SEC_NAME "fsverity.inode-info"

"inode-info" is very vague.  Shouldn't it be named "builtin-sig" or something?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

