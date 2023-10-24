Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F0C101E3
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYRtXJk8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698119560;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=55ZRJ15k5rlJjmFui052IxveaRjJKA9VJGl0uzNotB8=;
	b=AYRtXJk8AUxxg+m7dpD4sDn23RpJUSLjwNkWnRtYbUJJqo0y74hQ3DhdEzKo6qoPyz60l3
	z7RDRIuoGiGbAcOrFqpjlqea3Qh1OHIpnSoVSqFXLjRijutpnpIqn15snB/4CBO3/26tt2
	t1U7GU4rn7b9MsPNlEvAOT+LS2Y/998=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-LdVciSaiPtGqTjZTBnyAqQ-1; Mon, 23 Oct 2023 23:52:39 -0400
X-MC-Unique: LdVciSaiPtGqTjZTBnyAqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1473857CF6
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA7E48C0B
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC43C1946589
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47C651946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2A75C492BFC; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22F81492BFB
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 023A880F8F6
 for <dm-devel@redhat.com>; Tue, 24 Oct 2023 03:52:38 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-AZStu4RVNLuKdBB075gOcQ-2; Mon, 23 Oct 2023 23:52:36 -0400
X-MC-Unique: AZStu4RVNLuKdBB075gOcQ-2
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-7788fb06997so282735585a.0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 20:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698119555; x=1698724355;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=55ZRJ15k5rlJjmFui052IxveaRjJKA9VJGl0uzNotB8=;
 b=DvmPCvz9zIYEEo2JLdNjw6slo8YJJpedBj6x6+s293+tLmailv40lA7uvG/Tdb5wFr
 9BTW+b5GvxWM+Xxwaj/KDYd+oSCUIRB3fMJWjlFqI4COG08I5LnDrLjkqcCZEncMDlXz
 kn7lVyuTEgAkL+rISI9rXEpL4IOSLTmmSpSpYlcY5jDV0TphRaD2vguTaglvUniyrPJo
 3GoXA+DjskmSz+UHT2/N+hGOb0256IQT9P12REKJM7MWIjBHvW6XTsx8s+6nqfD/sQ5t
 I3nFHqD3mMWyFJaC6zuVlJkzL3jdZuFR8F04IvdilMBci3tEbGdwpbWmM/LwfA4mrJgC
 kdSg==
X-Gm-Message-State: AOJu0Yyb771gC5yM77cgh8d6rXXv7pmbd9I8U2jq883cCCyTCqv/VVjk
 n3vGs9lolLffpMRjiA9s6odA
X-Google-Smtp-Source: AGHT+IFhehT5SBIN3u4k21hQKcqd9tt3cVRe5RSL6o1ZuOBt7dfMcEzUGFp3iEoi8dzbbuQJKBLFmg==
X-Received: by 2002:a05:6214:626:b0:66d:5dec:6099 with SMTP id
 a6-20020a056214062600b0066d5dec6099mr11383093qvx.41.1698119555528; 
 Mon, 23 Oct 2023 20:52:35 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 ee3-20020a0562140a4300b0065b260eafd9sm3357598qvb.87.2023.10.23.20.52.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Oct 2023 20:52:34 -0700 (PDT)
Date: Mon, 23 Oct 2023 23:52:34 -0400
Message-ID: <c2a88a9292a6ce1e301ec2244657f385.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Subject: Re: [PATCH RFC v11 16/19] ipe: enable support for fs-verity as a
 trust provider
References: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
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
> Enable IPE policy authors to indicate trust for a singular fsverity
> file, identified by the digest information, through "fsverity_digest"
> and all files using fsverity's builtin signatures via
> "fsverity_signature".
> 
> This enables file-level integrity claims to be expressed in IPE,
> allowing individual files to be authorized, giving some flexibility
> for policy authors. Such file-level claims are important to be expressed
> for enforcing the integrity of packages, as well as address some of the
> scalability issues in a sole dm-verity based solution (# of loop back
> devices, etc).
> 
> This solution cannot be done in userspace as the minimum threat that
> IPE should mitigate is an attacker downloads malicious payload with
> all required dependencies. These dependencies can lack the userspace
> check, bypassing the protection entirely. A similar attack succeeds if
> the userspace component is replaced with a version that does not
> perform the check. As a result, this can only be done in the common
> entry point - the kernel.
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
>   * Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
>   * Use common-audit function for fsverity_signature.
>   + Change fsverity implementation to use fsverity_get_digest
>   + prevent unnecessary copy of fs-verity signature data, instead
>     just check for presence of signature data.
>   + Remove free_inode_security hook, as the digest is now acquired
>     at runtime instead of via LSM blob.
> 
> v9:
>   + Adapt to the new parser
> 
> v10:
>   + Update the fsverity get digest call
> 
> v11:
>   + No changes
> ---
>  security/ipe/Kconfig         |  13 +++++
>  security/ipe/audit.c         |  23 ++++++++
>  security/ipe/eval.c          | 110 +++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h          |  10 ++++
>  security/ipe/hooks.c         |  30 ++++++++++
>  security/ipe/hooks.h         |   7 +++
>  security/ipe/ipe.c           |  13 +++++
>  security/ipe/ipe.h           |   3 +
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |   8 +++
>  10 files changed, 220 insertions(+)

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index b5c58655ac74..e3a8552a76a4 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -79,6 +100,8 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
>  		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
>  		if (ptr->type == IPE_PROP_DMV_ROOTHASH)
>  			audit_dmv_roothash(ab, ptr->value);
> +		if (ptr->type == IPE_PROP_FSV_DIGEST)
> +			audit_fsv_digest(ab, ptr->value);

My comments on audit_dmv_roothash() also apply here.

>  		audit_log_format(ab, " ");
>  	}
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 82ad48d7aa3d..f0194b0ca2ff 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -172,6 +191,91 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * evaluate_fsv_digest - Analyze @ctx against a fsv digest property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
> +				struct ipe_prop *p)
> +{
> +	enum hash_algo alg;
> +	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];
> +
> +	if (!ctx->ino)
> +		return false;
> +	if (!fsverity_get_digest((struct inode *)ctx->ino,
> +				 digest,
> +				 NULL,
> +				 &alg))
> +		return false;
> +
> +	return ipe_digest_eval(p->value,
> +			       digest,
> +			       hash_digest_size[alg],
> +			       hash_algo_name[alg]);
> +}
> +
> +/**
> + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> +				   struct ipe_prop *p)
> +{
> +	return !ctx->ino ||
> +	       !IS_VERITY(ctx->ino) ||
> +	       !ctx->ipe_inode ||
> +	       !ctx->ipe_inode->fs_verity_signed;
> +}
> +
> +/**
> + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true - The current @ctx match the @p
> + * * false - The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> +				  struct ipe_prop *p)
> +{
> +	return ctx->ino &&
> +	       IS_VERITY(ctx->ino) &&
> +	       ctx->ipe_inode &&
> +	       ctx->ipe_inode->fs_verity_signed;
> +}

See my previous comments about the false/true functions.

> +#else

--
paul-moore.com

