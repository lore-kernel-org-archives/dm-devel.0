Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B65396
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOZU7Z+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SJeWgPJnFP9SHHxUPbKsetSyEOFGY5VrSBabMhJS80Q=;
	b=eOZU7Z+VeRolKR/YwxOIw1+hYUtLtmcBWCjqFdRSMpVeFmgILK3iScjXZQVCLAj1eH1d5X
	yMqli+ZrBazxohjKryzCz1xd6RBpU2Un6ZdZxMtxlGwR1bQuJqhsIL7yZkivvy73f0cq+l
	6624jjZMcbpawyIDBqlYy3chL/t6MAo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-Wy-PiChpNIyCgv3rKzrLmQ-1; Mon,
 23 Oct 2023 23:52:49 -0400
X-MC-Unique: Wy-PiChpNIyCgv3rKzrLmQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24E8C1C04B41
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1DAEB40C6F7B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6A48194658C
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B38E71946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A10052166B27; Tue, 24 Oct 2023 03:52:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A0A62166B26
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:43 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75AB238143A3
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:43 +0000 (UTC)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com
 [209.85.222.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-7rCnADEWM62qnkxzYA8Otw-1; Mon, 23 Oct 2023 23:52:41 -0400
X-MC-Unique: 7rCnADEWM62qnkxzYA8Otw-1
Received: by mail-qk1-f181.google.com with SMTP id
 af79cd13be357-777754138bdso268474785a.1
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119554; x=1698724354;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=SJeWgPJnFP9SHHxUPbKsetSyEOFGY5VrSBabMhJS80Q=;
 b=vk+gKtMNrgg3E8yWV44aLKtLwlh0b1AnUajgNW+xZBBC57wF0CqZEHfNkDRXsN0Uqt
 C8K9TiJdRSec5te7gtT6itYp70vuADmQzbH0vEPXT5dOlen9zOp9SdGha6BFEvrC/W6q
 ctrrT/XLBc9qeNClGgalsvC86bpGiLrKkITBbNl5RP3NqO67oJk+ThsFpElaeUojTv2R
 +x9zmjRmMxU6Ezc7+lvcRh4S64qPLUd/+4wpHlozmsA9KVsbJrravgbnWBiJW6MbeE1v
 0tvXgA6opLDQultzc9FrA6Ak7myCJckf1pxtiu2Tido4CIn/ISUYMfCdyqnbbeRB+Dcw
 dItw==
X-Gm-Message-State: AOJu0Yxxhf7+M9OhlQcxcR6vE35sXIMhMkI/LNEZgBcObIOqCqwwva5g
 c/fWB5qv8N+KNjqZ2umExhLU
X-Google-Smtp-Source: AGHT+IH2nCw7lcCJOC1jGaMBVsqfLXNVaAdsff3fbIwOETvTCI7/MGjJFVZyviKRDzofuJU8klNdDQ==
X-Received: by 2002:a05:620a:2907:b0:778:b78b:3338 with SMTP id
 m7-20020a05620a290700b00778b78b3338mr7760648qkp.10.1698119554427; 
 Mon, 23 Oct 2023 20:52:34 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 i6-20020a05620a404600b007742c6823a3sm3143889qko.108.2023.10.23.20.52.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:33 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:33 -0400
Message-ID: <6efb7a80ba0eb3e02b3ae7a5c0a210f3.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 15/19] fsverity: consume builtin signature via LSM
 hook
References: <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
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
> fsverity represents a mechanism to support both integrity and
> authenticity protection of a file, supporting both signed and unsigned
> digests.
> 
> An LSM which controls access to a resource based on authenticity and
> integrity of said resource, can then use this data to make an informed
> decision on the authorization (provided by the LSM's policy) of said
> claim.
> 
> This effectively allows the extension of a policy enforcement layer in
> LSM for fsverity, allowing for more granular control of how a
> particular authenticity claim can be used. For example, "all (built-in)
> signed fsverity files should be allowed to execute, but only these
> hashes are allowed to be loaded as kernel modules".
> 
> This enforcement must be done in kernel space, as a userspace only
> solution would fail a simple litmus test: Download a self-contained
> malicious binary that never touches the userspace stack. This
> binary would still be able to execute.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v6:
>   + Not present
> 
> v7:
>   Introduced
> 
> v8:
>   + Split fs/verity/ changes and security/ changes into separate patches
>   + Change signature of fsverity_create_info to accept non-const inode
>   + Change signature of fsverity_verify_signature to accept non-const inode
>   + Don't cast-away const from inode.
>   + Digest functionality dropped in favor of:
>     ("fs-verity: define a function to return the integrity protected
>       file digest")
>   + Reworded commit description and title to match changes.
>   + Fix a bug wherein no LSM implements the particular fsverity @name
>     (or LSM is disabled), and returns -EOPNOTSUPP, causing errors.
> 
> v9:
>   + No changes
> 
> v10:
>   + Rename the signature blob key
>   + Cleanup redundant code
>   + Make the hook call depends on CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> 
> v11:
>   + No changes
> ---
>  fs/verity/fsverity_private.h |  2 +-
>  fs/verity/open.c             | 26 +++++++++++++++++++++++++-
>  include/linux/fsverity.h     |  2 ++
>  3 files changed, 28 insertions(+), 2 deletions(-)

We need an ACK from some VFS folks on this.

> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
> index d071a6e32581..4a82716e852f 100644
> --- a/fs/verity/fsverity_private.h
> +++ b/fs/verity/fsverity_private.h
> @@ -108,7 +108,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
>  				     unsigned int log_blocksize,
>  				     const u8 *salt, size_t salt_size);
>  
> -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>  					   struct fsverity_descriptor *desc);
>  
>  void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 6c31a871b84b..5b48e2c39086 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -8,6 +8,7 @@
>  #include "fsverity_private.h"
>  
>  #include <linux/mm.h>
> +#include <linux/security.h>
>  #include <linux/slab.h>
>  
>  static struct kmem_cache *fsverity_info_cachep;
> @@ -172,12 +173,28 @@ static int compute_file_digest(const struct fsverity_hash_alg *hash_alg,
>  	return err;
>  }
>  
> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> +static int fsverity_inode_setsecurity(struct inode *inode,
> +				      struct fsverity_descriptor *desc)
> +{
> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
> +					  desc->signature,
> +					  le32_to_cpu(desc->sig_size), 0);
> +}
> +#else
> +static inline int fsverity_inode_setsecurity(struct inode *inode,
> +					     struct fsverity_descriptor *desc)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_IPE_PROP_FS_VERITY*/
> +
>  /*
>   * Create a new fsverity_info from the given fsverity_descriptor (with optional
>   * appended builtin signature), and check the signature if present.  The
>   * fsverity_descriptor must have already undergone basic validation.
>   */
> -struct fsverity_info *fsverity_create_info(const struct inode *inode,
> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>  					   struct fsverity_descriptor *desc)
>  {
>  	struct fsverity_info *vi;
> @@ -242,6 +259,13 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  		spin_lock_init(&vi->hash_page_init_lock);
>  	}
>  
> +	err = fsverity_inode_setsecurity(inode, desc);
> +	if (err == -EOPNOTSUPP)
> +		err = 0;
> +
> +	if (err)
> +		goto fail;
> +
>  	return vi;
>  
>  fail:
> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 1eb7eae580be..9666721baf15 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -319,4 +319,6 @@ static inline int fsverity_prepare_setattr(struct dentry *dentry,
>  	return 0;
>  }
>  
> +#define FS_VERITY_INODE_SEC_NAME "fsverity.builtin-sig"
> +
>  #endif	/* _LINUX_FSVERITY_H */
> -- 
> 2.25.1

--
paul-moore.com

