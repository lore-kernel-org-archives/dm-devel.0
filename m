Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C60E8F58
	for <dm-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712021207; cv=none; b=c1AT+IPauivbzLFtZNrGRq1VeKu0sh3s1UICj3yBYkqg6sS+grQP3h3z4xJOJcS8Qi/3RZDrNxB5HXWGqG0jxMYAVudEIliSwkYMoPLlpuZmj8crfqu2pse++thRsC1nVEcGM+jTvfJle6ecKh/bJBKeHoTrjWFw3ZVvb/6NoQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712021207; c=relaxed/simple;
	bh=aVxgl65qe63F9RG61q5/c/8ucEYTRdx9vtPoLeH3Y2k=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=eAl5JvNWtH2aCbTX0XbpYtFeUAgylisgCdt7rL61buqyQL6aYuhsVC4d+IFUeSTogK+1lwoXArape8+2rLdSmL3+3QQogvqqEEyYOKIqQFEF3DS3FTFmJe7mqxD4bpuZGhCDu522bsoDo/Cu/pbweysBo10nhOI8Npa5HPax1F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=KYtPHo9Y; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="KYtPHo9Y"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-78a2290b48eso320386485a.3
        for <dm-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1712021203; x=1712626003; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R2O8HEb1FethHT20zhCThThb/BGPO8YtMtgX7GfGVZI=;
        b=KYtPHo9Yb0wyQ2ep00v5Tk4D7N9sb+JPnQEhR7uQ2vB4te/Mc/jDoW6p5E0GVhq6c1
         FqFizrJIOqwPJ0dRu6gnjqhz7pXjc2Pyral2bdKF3PgC3eh9hPi0ivodc70/Km+6pBAv
         uGyn8Bz7wX5LgjXkLpYJbTGhjh1llAK+zGPrCxqh1RsaB0g6ZZNMovM37EmtRPjwwZln
         fpOKWTBIWemazlFaxaxSLjHNhnJGqHANZ3BGf93Wc2mPdQanO6LcdVLtNxdsZdJ+FF1I
         FOvV9J8AWXb0QAimwcXuYHcvTD8aIc6QlDT3CYZQHRDPR0qpOpHBvqG9H/vsFwQDs5FB
         aUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712021203; x=1712626003;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R2O8HEb1FethHT20zhCThThb/BGPO8YtMtgX7GfGVZI=;
        b=EydXv8Pcjo3g5WnVZqRhXODfLeWGpow6soxs2MupqXIfUogFfK2tx/GUX/gSURYFBX
         helK2Aw5azws+mvNQMsrCmHuYiNkyySrxPBdBpKQwhOmsZEHSkmr0o+069RkwLHpJpkx
         dvDbClKTevlLrdCmdMF2nT5wckhAZIFetETmJY2rS0/uxBXLYMipxTcAtrDu4loIWjrL
         nxSOgDFxI6hR56MVk3zndiPtniq2vK4PJVM275jniRpwiSA00NegB861NUud6hyPoHpH
         /xtWXREdCq/B1hPW/UdXRtw0HC0pSBwCjnNqtQUxrqlrsRO41S3B7SnWtPecvgSEOf4M
         /ytg==
X-Forwarded-Encrypted: i=1; AJvYcCXqIBLgHRRmAAxGigs8ztL84JyvxdAz76/9kn9kNzEDyo1HR6IygKjqMFe06Cu0k3NjbkNoEEGdy5cCewOLkdMhlVoTm+Oc7wg=
X-Gm-Message-State: AOJu0Yy/kNqkotidwedfGaIkIOVtHtnCpaVOsbv5rvxiMCkp+Bbcd2yM
	RlT3m4ut7cVcTtFc8MFRPoPQU8fVj+C4hAEiATqdq+pLcQnPzH+XdPB5NczcpA==
X-Google-Smtp-Source: AGHT+IE++PDnPsCAN5ZlJzJBCsY9VL8rWCNTNagzE8bvtbG+6yPqmGk0WcKC3DLF/KWvtXLzI6otLg==
X-Received: by 2002:ad4:404f:0:b0:699:1026:c0a4 with SMTP id r15-20020ad4404f000000b006991026c0a4mr2755001qvp.38.1712021202974;
        Mon, 01 Apr 2024 18:26:42 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id fn3-20020ad45d63000000b00696934de5f7sm4964016qvb.62.2024.04.01.18.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:26:42 -0700 (PDT)
Date: Mon, 01 Apr 2024 21:26:42 -0400
Message-ID: <18dfbc23f04422e88993a13ff15b6229@paul-moore.com>
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
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH v16 11/20] block|security: add LSM blob to block_device
References: <1711657047-10526-12-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1711657047-10526-12-git-send-email-wufan@linux.microsoft.com>

On Mar 28, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Some block devices have valuable security properties that is only
> accessible during the creation time.

You should mention the new hook in the subject line, something like
the following: "block,lsm: add LSM blob and new LSM hook for block
devices".

> For example, when creating a dm-verity block device, the dm-verity's
> roothash and roothash signature, which are extreme important security
> metadata, are passed to the kernel. However, the roothash will be saved
> privately in dm-verity, which prevents the security subsystem to easily
> access that information. Worse, in the current implementation the
> roothash signature will be discarded after the verification, making it
> impossible to utilize the roothash signature by the security subsystem.
> 
> With this patch, an LSM blob is added to the block_device structure.
> This enables the security subsystem to store security-sensitive data
> related to block devices within the security blob. For example, LSM can
> use the new LSM blob to save the roothash signature of a dm-verity,
> and LSM can make access decision based on the data inside the signature,
> like the signer certificate.
> 
> The implementation follows the same approach used for security blobs in
> other structures like struct file, struct inode, and struct superblock.
> The initialization of the security blob occurs after the creation of the
> struct block_device, performed by the security subsystem. Similarly, the
> security blob is freed by the security subsystem before the struct
> block_device is deallocated or freed.
> 
> This patch also introduces a new hook to save block device's integrity
> data. For example, for dm-verity, LSMs can use this hook to save
> the roothash signature of a dm-verity into the security blob,
> and LSMs can make access decisions based on the data inside
> the signature, like the signer certificate.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + Minor style changes from checkpatch --strict
> 
> v4:
>   + No Changes
> 
> v5:
>   + Allow multiple callers to call security_bdev_setsecurity
> 
> v6:
>   + Simplify security_bdev_setsecurity break condition
> 
> v7:
>   + Squash all dm-verity related patches to two patches,
>     the additions to dm-verity/fs, and the consumption of
>     the additions.
> 
> v8:
>   + Split dm-verity related patches squashed in v7 to 3 commits based on
>     topic:
>       + New LSM hook
>       + Consumption of hook outside LSM
>       + Consumption of hook inside LSM.
> 
>   + change return of security_bdev_alloc / security_bdev_setsecurity
>     to LSM_RET_DEFAULT instead of 0.
> 
>   + Change return code to -EOPNOTSUPP, bring inline with other
>     setsecurity hooks.
> 
> v9:
>   + Add Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
>   + Remove unlikely when calling LSM hook
>   + Make the security field dependent on CONFIG_SECURITY
> 
> v10:
>   + No changes
> 
> v11:
>   + No changes
> 
> v12:
>   + No changes
> 
> v13:
>   + No changes
> 
> v14:
>   + No changes
> 
> v15:
>   + Drop security_bdev_setsecurity() for new hook
>     security_bdev_setintegrity() in the next commit
>   + Update call_int_hook() for 260017f
> 
> v16:
>   + Drop Reviewed-by tag for the new changes
>   + Squash the security_bdev_setintegrity() into this commit
>   + Rename enum from lsm_intgr_type to lsm_integrity_type
>   + Switch to use call_int_hook() for bdev_setintegrity()
>   + Correct comment
>   + Fix return in security_bdev_alloc()
> ---
>  block/bdev.c                  |  7 +++
>  include/linux/blk_types.h     |  3 ++
>  include/linux/lsm_hook_defs.h |  5 ++
>  include/linux/lsm_hooks.h     |  1 +
>  include/linux/security.h      | 26 ++++++++++
>  security/security.c           | 89 +++++++++++++++++++++++++++++++++++
>  6 files changed, 131 insertions(+)



> diff --git a/include/linux/security.h b/include/linux/security.h
> index f35af7b6cfba..8e646189740e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1483,6 +1492,23 @@ static inline int lsm_fill_user_ctx(struct lsm_ctx __user *uctx,
>  {
>  	return -EOPNOTSUPP;
>  }
> +
> +static inline int security_bdev_alloc(struct block_device *bdev)
> +{
> +	return 0;
> +}
> +
> +static inline void security_bdev_free(struct block_device *bdev)
> +{
> +}
> +
> +static inline int security_bdev_setintegrity(struct block_device *bdev,
> +					     enum lsm_integrity_type, type,

I'm sure by now you've seen the reports about the errant comma ...

> +					     const void *value, size_t size)
> +{
> +	return 0;
> +}
> +
>  #endif	/* CONFIG_SECURITY */

--
paul-moore.com
