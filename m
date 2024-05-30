Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5393175AA
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 01:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717033452; cv=none; b=UtZ8w00Au/uoZJotnmi2HlVoZEHLhYjYq73+8f11MsPIqySEJCzikuC9vTpTKEXSmad6c0YvDiPJvz3pZ3j3QNPQ4dDuOLxCDXXHt6XzlD5DQ/QyI3ZLNkeMHm+GHOu2vPfmkhsH9bi2OLjwkNi7XZp9Z26/6nCdO14Tzt9Fm90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717033452; c=relaxed/simple;
	bh=Dkoyl9eH9xPX6SY5fo5wWTjDVemt885sICBQQfc3AMc=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=W09aFt2OrOaoLA4Y9IcTvtunSBDqBJtTwJaXLx5hxdvWIhZ4nKHUO1J1Ytse036e3nyzylYS+1p5wrtUn08buNVdokPc9Xw5y68QJtDlS32fwr+1KCdnqDtPAFumtc6N7kOrLmldi9js8AghFkJL6TTvYlZC6V3/euOFqkIDLMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=OZs49bdX; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="OZs49bdX"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-794ba2d4579so28594285a.1
        for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 18:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1717033450; x=1717638250; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JjXN8NpGNA42fcHFLopHeCrptlo6zAQlCC9qZAnbVGo=;
        b=OZs49bdX172Xjx8ykjzyk2Xp5SDwUZmS/TJdXVQ0P893tC38aC6p77T079CnzjDNCh
         EY3eplVlPQcJ9+sDVVBoOxn6vJthvjrezvJd4AhNyqkkTuajgwRmBYZLrSb2FYJnTPkl
         DfOgs9VpuEV74/N/guT+AvAYNRU7MobOh+0IwtvlpHW7P3e3Wass68yq+xwdn1HLl7KL
         GmwyBVZgaHXYVR5jsuMQVnrH6AM+sqqr0zKHdv/Hy9MpGvmykphww26D2dDUUvsoFqeI
         k+0sEbGKJ/ZtxymuO5UBaEO+GUNX2ai3ekXFOQj6DOX1JR+1tObbqPPLAdCrwVgTo3Ln
         RU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717033450; x=1717638250;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JjXN8NpGNA42fcHFLopHeCrptlo6zAQlCC9qZAnbVGo=;
        b=uU1+vXbtr7ks/JjXEBKu7WIkR4HIWHs3hmFpJZId6Q9wMS9VukQDJOviS73swhCdKL
         EmqjW34ZSV8qbcVavjruLVN8u9cbnY8Yssx3Tgwhua+4hj2gUUj81XKYADNf9ypJOX1G
         v4vJpf7n7o5BDrWCQ9HqCGJT9zxmS8ffA7hR2NGxJko43YCBKf++Vq6Hw4HkGBroEWfj
         ukoEFjnDARrwCH1ungkcVi8abi5ltF2UVqlRh9OgdRZTILxtdyYNWo75Djv2tOw40s6z
         Ju8XxFIC8JNq3TP0DRFMcU67VkYDA4pb+BojfIrsP8znuNasalORq2ZpX8y6Vv/mpWdt
         RrRA==
X-Forwarded-Encrypted: i=1; AJvYcCX8KDksFM/WJjYJCPaOTJG5OooJWYDGMVgkVCrT6mdyP4lwZq4RHRZA39wNnGHhRiM9ge1F+rOZLD0VUswegUkNa4wpgjedqdc=
X-Gm-Message-State: AOJu0YxYmSkNuJ3bDqGbqGFb2BBewc4WUtiZD6OsZPT8lVRDt2AXB7S+
	+Zom1UIEZde736djPx6uxruVjrUAnYypdWhXYaXwTLdmbFP2+9hq+wZJBQkuNw==
X-Google-Smtp-Source: AGHT+IHXci0OO4XwCTtBxInLkT4T/ekembfibhyph2b2S2yaT2IF0CDBqyIyOJ5rHbQjEbyfTzapiA==
X-Received: by 2002:a05:620a:2403:b0:794:8ffe:c79b with SMTP id af79cd13be357-794e9da1764mr108898385a.19.1717033449619;
        Wed, 29 May 2024 18:44:09 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794ba86855bsm375195885a.69.2024.05.29.18.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 18:44:09 -0700 (PDT)
Date: Wed, 29 May 2024 21:44:08 -0400
Message-ID: <2ecde610ca3f0cabcbb111e3432f2dd5@paul-moore.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0 
Content-Type: text/plain; charset=utf-8 
Content-Disposition: inline 
Content-Transfer-Encoding: 8bit
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH v19 13/20] ipe: add support for dm-verity as a trust  provider
References: <1716583609-21790-14-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1716583609-21790-14-git-send-email-wufan@linux.microsoft.com>

On May 24, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Allows author of IPE policy to indicate trust for a singular dm-verity
> volume, identified by roothash, through "dmverity_roothash" and all
> signed and validated dm-verity volumes, through "dmverity_signature".
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + No changes
> 
> v4:
>   + No changes
> 
> v5:
>   + No changes
> 
> v6:
>   + Fix an improper cleanup that can result in
>     a leak
> 
> v7:
>   + Squash patch 08/12, 10/12 to [11/16]
> 
> v8:
>   + Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
>     & block/
>   + Use common-audit function for dmverity_signature.
>   + Change implementation for storing the dm-verity digest to use the
>     newly introduced dm_verity_digest structure introduced in patch
>     14/20.
> 
> v9:
>   + Adapt to the new parser
> 
> v10:
>   + Select the Kconfig when all dependencies are enabled
> 
> v11:
>   + No changes
> 
> v12:
>   + Refactor to use struct digest_info* instead of void*
>   + Correct audit format
> 
> v13:
>   + Remove the CONFIG_IPE_PROP_DM_VERITY dependency inside the parser
>     to make the policy grammar independent of the kernel config.
> 
> v14:
>   + No changes
> 
> v15:
>   + Fix one grammar issue in KCONFIG
>   + Switch to use security_bdev_setintegrity() hook
> 
> v16:
>   + Refactor for enum integrity type
> 
> v17:
>   + Add years to license header
>   + Fix code and documentation style issues
>   + Return -EINVAL in ipe_bdev_setintegrity when passed type is not
>     supported
>   + Use new enum name LSM_INT_DMVERITY_SIG_VALID
> 
> v18:
>   + Add Kconfig IPE_PROP_DM_VERITY_SIGNATURE and make both DM_VERITY
>     config auto-selected
> 
> v19:
>   + No changes
> ---
>  security/ipe/Kconfig         |  27 ++++++++
>  security/ipe/Makefile        |   1 +
>  security/ipe/audit.c         |  29 ++++++++-
>  security/ipe/digest.c        | 118 +++++++++++++++++++++++++++++++++++
>  security/ipe/digest.h        |  26 ++++++++
>  security/ipe/eval.c          |  93 ++++++++++++++++++++++++++-
>  security/ipe/eval.h          |  12 ++++
>  security/ipe/hooks.c         |  93 +++++++++++++++++++++++++++
>  security/ipe/hooks.h         |   8 +++
>  security/ipe/ipe.c           |  15 +++++
>  security/ipe/ipe.h           |   4 ++
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |  24 ++++++-
>  13 files changed, 449 insertions(+), 4 deletions(-)
>  create mode 100644 security/ipe/digest.c
>  create mode 100644 security/ipe/digest.h

...

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index b68719bf44fb..51f1e63c295c 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -191,3 +193,94 @@ void ipe_unpack_initramfs(void)
>  {
>  	ipe_sb(current->fs->root.mnt->mnt_sb)->initramfs = true;
>  }
> +
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +/**
> + * ipe_bdev_free_security() - Free IPE's LSM blob of block_devices.
> + * @bdev: Supplies a pointer to a block_device that contains the structure
> + *	  to free.
> + */
> +void ipe_bdev_free_security(struct block_device *bdev)
> +{
> +	struct ipe_bdev *blob = ipe_bdev(bdev);
> +
> +	ipe_digest_free(blob->root_hash);
> +}
> +
> +#ifdef CONFIG_IPE_PROP_DM_VERITY_SIGNATURE
> +static void ipe_set_dmverity_signature(struct ipe_bdev *blob,
> +				       const void *value,
> +				       size_t size)
> +{
> +	blob->dm_verity_signed = size > 0 && value;
> +}
> +#else
> +static inline void ipe_set_dmverity_signature(struct ipe_bdev *blob,
> +					      const void *value,
> +					      size_t size)
> +{
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY_SIGNATURE */
> +
> +/**
> + * ipe_bdev_setintegrity() - Save integrity data from a bdev to IPE's LSM blob.
> + * @bdev: Supplies a pointer to a block_device that contains the LSM blob.
> + * @type: Supplies the integrity type.
> + * @value: Supplies the value to store.
> + * @size: The size of @value.
> + *
> + * This hook is currently used to save dm-verity's root hash or the existence
> + * of a validated signed dm-verity root hash into LSM blob.
> + *
> + * Return: %0 on success. If an error occurs, the function will return the
> + * -errno.
> + */
> +int ipe_bdev_setintegrity(struct block_device *bdev, enum lsm_integrity_type type,
> +			  const void *value, size_t size)
> +{
> +	const struct dm_verity_digest *digest = NULL;
> +	struct ipe_bdev *blob = ipe_bdev(bdev);
> +	struct digest_info *info = NULL;
> +
> +	if (type == LSM_INT_DMVERITY_ROOTHASH) {
> +		if (!value) {
> +			ipe_digest_free(blob->root_hash);
> +			blob->root_hash = NULL;
> +
> +			return 0;
> +		}
> +		digest = value;
> +
> +		info = kzalloc(sizeof(*info), GFP_KERNEL);
> +		if (!info)
> +			return -ENOMEM;
> +
> +		info->digest = kmemdup(digest->digest, digest->digest_len,
> +				       GFP_KERNEL);
> +		if (!info->digest)
> +			goto dmv_roothash_err;
> +
> +		info->alg = kstrdup(digest->alg, GFP_KERNEL);
> +		if (!info->alg)
> +			goto dmv_roothash_err;
> +
> +		info->digest_len = digest->digest_len;
> +
> +		if (blob->root_hash)
> +			ipe_digest_free(blob->root_hash);

The above if/free looks like a new addition from v18 and I'm not quite
sure why the `blob->root_hash` NULL check is necessary as
ipe_digest_free() does a IS_ERR_OR_NULL() check right at the top.

Likely harmless and doubtful to have any noticable performance impact,
but I wanted to mention it just in case ...

> +		blob->root_hash = info;
> +
> +		return 0;
> +dmv_roothash_err:
> +		ipe_digest_free(info);
> +
> +		return -ENOMEM;
> +	} else if (type == LSM_INT_DMVERITY_SIG_VALID) {
> +		ipe_set_dmverity_signature(blob, value, size);
> +
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */

--
paul-moore.com
