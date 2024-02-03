Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFD216419
	for <dm-devel@lists.linux.dev>; Sat,  3 Feb 2024 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999112; cv=none; b=UAsBRW5OAlEedyzG7oVa3OWqU7g9m9b2G1w1o31pYPcCU32/dZnWq7PQ5T4+cyIHxcgK/pyh4o6iyKkD9oTxXNfx5hdVQvCYlXFo+RaBlf5isny6LGbDrMHWVLJnZxNF/zIeGb7ck6Lj6lS7CWh5WqDS4niFY+vKJna6Ekj/AuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999112; c=relaxed/simple;
	bh=Akk3yfd0skBsyfpDvBuTijI4DTSE1uDMrPs5axVSpcY=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=fYdnHq/LfuPA2FZ5wJlniTJdTXmV6m3IzQNXMho4+4azVxPM1N34yAF9Ye5C2seI01vr9HxpVZRlExhvstNd9Qp+pObJPBKWrha3MfMe19ctInSRvBLvt8u0FXzyAsKAaWR317iXFnrMEkDTbrY1MDd3wpURlU7oKx7zhzpxaX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=YxC5hYTu; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="YxC5hYTu"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7853fcc314bso218479385a.1
        for <dm-devel@lists.linux.dev>; Sat, 03 Feb 2024 14:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999109; x=1707603909; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DnWesDs8xRNqrKgsSJ7fCUj/XnlBG4IvaiEQPBxCK/I=;
        b=YxC5hYTuUtUTKD7kb92+bY47s3rkH7kUOV3XCqsLFlUvM8nWticEx2YkHpDlx3D427
         Jp40tLjcCQwHrxvcl3yYFhD6XCyQxaPWqmf7edm2qE4xhB2sBYuG/oWJXuwb5O68pTIt
         Oe+HgPyj+881aAtbLdUn4nd+mvLfx52/0UYMIuVaje2Sw9NEBthtT7XZPDGlAC54lGcj
         FoeFea51JsWW8jI3yV5Xy90ZfZA8bQRGXejPq0kLBGLZMf0rzPfHaYLrW+dj1ot6g8nt
         dFu2OYo/DssmsIPTdrBD1Xl8QI5QpNbXX6FKDkPBSoC/V3y4QxxiyJRl+kb1jJ93myNi
         T8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999109; x=1707603909;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DnWesDs8xRNqrKgsSJ7fCUj/XnlBG4IvaiEQPBxCK/I=;
        b=CC6eeeymRjsqlJIb/b08D5sFU2ZRfPmavej6KfauLYm5sM2ToFU3d4XcOZZx8n9We9
         fztwO/ppT3Ux0WIPAdPGDbqrBDfyQCc7VbcoXPT69KNbc2upoE3QI5Sd8miln6O9brYJ
         LT/V7SbgEmuXERedK0KiAACrfYoY+l7UJex5ruh3KywqiDOuKlfxPZfc7InulcLEKLrm
         wMQLGpZAjWrsfzAn+FbuOaUuw5RjU0C4dPIQ6oOH3EkbWMYm3fHkZq+wSQ8XZGoMmL7Z
         vbpRMubvxmZFsX1jGe4A8Y5UoEaaNPIDH2ijkcnyrRZdBqnTcfxEyW26HkXMvUr9cpY7
         quHg==
X-Gm-Message-State: AOJu0YxZYF7eniRxnna2wdgpc1v5Z1Y7dwoXXHyXSHb6V5Rp3Yyat647
	p64Hlad3PIreZ9OF9qcF5GxP7H3i9cnQ/sGLw+HWglGK9Zf48Jba4AFBn90mEQ==
X-Google-Smtp-Source: AGHT+IFtZe+Q8W1ePYytw7UeC4Jf2MOnkQ6RcSuccAbbwyK+ZuVbp0rOxBJSIWscsGRZX7r4oaJh+g==
X-Received: by 2002:a05:620a:2e3:b0:783:b038:d1a1 with SMTP id a3-20020a05620a02e300b00783b038d1a1mr9095773qko.39.1706999109324;
        Sat, 03 Feb 2024 14:25:09 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVwYaZbKyqip0VIR8GONQxXUcX8op8aMPNo2Ap1p+jdcI0F9O4QdFtfkXUh2izlay/UPxQX4uTdUnml1eWFaVIu3sl4cZN0o9MEZYPtDzuPUBt8ISFeQUgk//7oOgSqTo+LWz7pHI783WZUe7avWlFl2g4RV0ALfs6fSYnt9PmcP3V5e5UUC9OHfUN1hGOhFCEIHdwZdid79pfUdFyuN0HQ1asimEWyLDwYPGdfmyK0n3vX204PQ6L6I7qS+XYcc2+4FDbFfrLjHojE/EkYwAYSDsPcTayfqX5R0GGth4PTwEABerphUsn9JY6Cz1DdD0rhuTOjEi/XLpHp1AvDca0BRlY13p7V9uUBl5XxTmPDaaLTbmdbuj1e2I3b+GHRn4+Guw1TVTp0wlUYUAdXRnJPf1jp9/Mte8sgyYSGDJVgBLodRU8oGcMpA5MLWsHMPY5+8w5xv6eKGe3vsfBvHJH92nrGbL7ODZl7dWe1CNUDc7uQPTJqnToEqjD5Yl1fzWFBuCEy7dobme80FhUuQ9F8QqZX8GC19w5DGqXnrHRf6FF81Ob58I7Z4V+OoQ0FbylAMRBpa+pH
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id g4-20020a37e204000000b00783f534706esm1734412qki.61.2024.02.03.14.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:08 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:08 -0500
Message-ID: <b9ca171301d5abeb78922dd79d65136a@paul-moore.com>
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
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v12 5/20] initramfs|security: Add security hook to  initramfs unpack
References: <1706654228-17180-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-6-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> This patch introduces a new hook to notify security system that the
> content of initramfs has been unpacked into the rootfs.
> 
> Upon receiving this notification, the security system can activate
> a policy to allow only files that originated from the initramfs to
> execute or load into kernel during the early stages of booting.
> 
> This approach is crucial for minimizing the attack surface by
> ensuring that only trusted files from the initramfs are operational
> in the critical boot phase.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v11:
>   + Not present
> 
> v12:
>   + Introduced
> ---
>  include/linux/lsm_hook_defs.h |  4 ++++
>  include/linux/security.h      | 10 ++++++++++
>  init/initramfs.c              |  3 +++
>  security/security.c           | 12 ++++++++++++
>  4 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 185924c56378..b247388786a9 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -425,3 +425,7 @@ LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>  #endif /* CONFIG_IO_URING */
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +LSM_HOOK(void, LSM_RET_VOID, unpack_initramfs_security, void)
> +#endif /* CONFIG_BLK_DEV_INITRD */

Let's just call it "unpack_initramfs", the "_security" part is somewhat
implied since we are talking about a LSM hook ;)

> diff --git a/init/initramfs.c b/init/initramfs.c
> index 76deb48c38cb..075a5794cde5 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -18,6 +18,7 @@
>  #include <linux/init_syscalls.h>
>  #include <linux/task_work.h>
>  #include <linux/umh.h>
> +#include <linux/security.h>
>  
>  static __initdata bool csum_present;
>  static __initdata u32 io_csum;
> @@ -720,6 +721,8 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
>  #endif
>  	}
>  
> +	security_unpack_initramfs();

Given the caller, what do you think of changing the hook name to
"security_initramfs_populated()"?  I think this not only matches up
better with the caller, "do_populate_rootfs()", but since in using the
past tense we help indicate that this hook happens *after* the rootfs
is populated with the initramfs data.

>  done:
>  	/*
>  	 * If the initrd region is overlapped with crashkernel reserved region,
> diff --git a/security/security.c b/security/security.c
> index ddf2e69cf8f2..2a527d4c69bc 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -5581,3 +5581,15 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
>  	return call_int_hook(uring_cmd, 0, ioucmd);
>  }
>  #endif /* CONFIG_IO_URING */
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +/**
> + * security_unpack_initramfs() - Notify LSM that initramfs has been loaded
> + *
> + * Tells the LSM the initramfs has been unpacked into the rootfs.
> + */
> +void security_unpack_initramfs(void)
> +{
> +	call_void_hook(unpack_initramfs_security);
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */
> -- 
> 2.43.0

--
paul-moore.com
