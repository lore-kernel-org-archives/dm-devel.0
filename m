Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB9A6BB2F
	for <dm-devel@lists.linux.dev>; Sun, 28 Apr 2024 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714309935; cv=none; b=CFp2wgHyGmX93ldUDlKqYpUAJJVNd8VlIWQS+GS3TVllqxzs+ZpXX5RUUXFZFR1muchFoW3hFkqL8BV9Pn23+1rTbwgyHB75D02saVIZZUoJtAGCFYUvP8Lq+MDk2Anfp+HXqfBenhvhV2bUigxf+qZ4AlkK1bJDl1Xei99ZLCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714309935; c=relaxed/simple;
	bh=KLxM9YkdCvUGN0XvVsZ2GkkSmsruBVL2Lgf+5mm+kSA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EoJJsilBVWx7/YVZ40+8nckERjEK83VSckFdc7JiaIA59iaPsy1W9jNhUleu15b+7ofMOn0R/WNeP2WDvYDJhFVOttSrDhMNDL5DHORtnn6fzWW9o7+3gwwG1XfYvsOxauU4f9kGjOSGE89rBDx0/sUa0TBYvTuyZ5H0688OqQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jajQUu0l; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jajQUu0l"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51ae315bb20so4337120e87.1
        for <dm-devel@lists.linux.dev>; Sun, 28 Apr 2024 06:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714309931; x=1714914731; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ek36Ely/+scMwi7ZAeRLEtew44ioNM5oYhC6FNlT0xI=;
        b=jajQUu0l8EELYavOHiOzw0TMGZXYk/A22CjgukpAQ8mfbIm2vOp7glG6x4T26z1E72
         hgF4o8UTgA3r2Zcsb1riMulc68nJUKBZCekoMXR+XgaOCBkb/VnzkT4dTk2CNzX87cOl
         08v47KWP9+vn5bI5liVSNOmGgszNDabbBV6qW7ZsiGv8QOY7itlhKM4j3pLd5QkE/VrO
         bxM6ckJx5GNYK4hHVGJFtQq2RwtNkYrARpJ4SrgwqRXNsnTzBah+CZF79os24D8olzkl
         /a81psqqB2l3+4hS8Zal0MSYMAdOjDcwCnVvFeYLoUUe8AqqFupffvPM4N4n0CgXr9pm
         gwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714309931; x=1714914731;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ek36Ely/+scMwi7ZAeRLEtew44ioNM5oYhC6FNlT0xI=;
        b=f8NG2FFlVgC6M2WSRBW/nqxc/v4qt1sGoblJy7aa4gvRAubJoeMemuOZsoU797ScvW
         zSzc3hZcUxRKV9zV1JSA6eUYdjrb68coIWNYjhOXBzxHPtx/o49B8VkzbNrb1AFQQdk/
         OnPZABhDx01W1cZ48hsqZ/zZQTuasGNHQW7jxlcpw9eGHy+obiWTP8zStdlkVbko+qsy
         N9fjstnjo5SPhb+5irgAuZV04snoEVQ6Jvu+B4rn1z+nfoQVoPjnLDfPL8eunwJvqNs3
         FnrJiAAPdclyz9zaIcswu0sjt3fPnVUhLqzlGFGpjQ53ycRySK1JbLp+PD3BQc1e0xZZ
         Sqpw==
X-Gm-Message-State: AOJu0YwoK8/YBjOL/mCWcW1OlZyy4YV/v2fcpfOtVWPysQuP07YlqjSI
	o5kYbu7R90bq3dsinqdZX5uNT2neN1P9IYWVlsJDCfkvfwanRvPiFcQZZBacBStPHfpEmhF1Or/
	k
X-Google-Smtp-Source: AGHT+IF/TZNLcxN+Q75lqk7glUXfuSVex5fY5hbQREJfj2J4DwYtYJ0ssqTgpuPBH5gZNETuxfo20Q==
X-Received: by 2002:a05:6512:2001:b0:51d:910b:4acb with SMTP id a1-20020a056512200100b0051d910b4acbmr642083lfb.59.1714309930836;
        Sun, 28 Apr 2024 06:12:10 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id q13-20020a5085cd000000b005726b83071esm1735966edh.4.2024.04.28.06.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 06:12:10 -0700 (PDT)
Date: Sun, 28 Apr 2024 16:12:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: dm-devel@lists.linux.dev
Cc: linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [bug report] dm ioctl: harden copy_params()'s copy_from_user() from
 malicious users
Message-ID: <f84a96d7-2df4-4f79-8c27-83a1d9574412@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi DM Maintainers and kernel hardenning people,

drivers/md/dm-ioctl.c
    1931 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
    1932                        int ioctl_flags, struct dm_ioctl **param, int *param_flags)
    1933 {
    1934         struct dm_ioctl *dmi;
    1935         int secure_data;
    1936         const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
    1937 
    1938         /* check_version() already copied version from userspace, avoid TOCTOU */
    1939         if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
    1940                            (char __user *)user + sizeof(param_kernel->version),
    1941                            minimum_data_size - sizeof(param_kernel->version)))
    1942                 return -EFAULT;
    1943 
    1944         if (unlikely(param_kernel->data_size < minimum_data_size) ||
    1945             unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {

So what's happening here is that struct dm_ioctl->data[] is declared as
a 7 byte array, but it's actually a variable size array which could be
more or less than 7 bytes.

    1946                 DMERR("Invalid data size in the ioctl structure: %u",
    1947                       param_kernel->data_size);
    1948                 return -EINVAL;
    1949         }
    1950 
    1951         secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
    1952 
    1953         *param_flags = secure_data ? DM_WIPE_BUFFER : 0;
    1954 
    1955         if (ioctl_flags & IOCTL_FLAGS_NO_PARAMS) {
    1956                 dmi = param_kernel;
    1957                 dmi->data_size = minimum_data_size;
    1958                 goto data_copied;
    1959         }
    1960 
    1961         /*
    1962          * Use __GFP_HIGH to avoid low memory issues when a device is
    1963          * suspended and the ioctl is needed to resume it.
    1964          * Use kmalloc() rather than vmalloc() when we can.
    1965          */
    1966         dmi = NULL;
    1967         dmi = kvmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH);

We allocate the correct size of the variable element array.

    1968 
    1969         if (!dmi) {
    1970                 if (secure_data && clear_user(user, param_kernel->data_size))
    1971                         return -EFAULT;
    1972                 return -ENOMEM;
    1973         }
    1974 
    1975         *param_flags |= DM_PARAMS_MALLOC;
    1976 
    1977         /* Copy from param_kernel (which was already copied from user) */
    1978         memcpy(dmi, param_kernel, minimum_data_size);
    1979 
--> 1980         if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,
    1981                            param_kernel->data_size - minimum_data_size))

Doesn't the kernel hardenning stuff have run time checks for if we
write beyond the end of a 7 byte array?  Why not just declare it as a
zero element array?

    1982                 goto bad;
    1983 data_copied:
    1984         /* Wipe the user buffer so we do not return it to userspace */
    1985         if (secure_data && clear_user(user, param_kernel->data_size))
    1986                 goto bad;
    1987 
    1988         *param = dmi;
    1989         return 0;
    1990 
    1991 bad:
    1992         free_params(dmi, param_kernel->data_size, *param_flags);
    1993 
    1994         return -EFAULT;
    1995 }

regards,
dan carpenter
