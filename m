Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C56DDB1
	for <dm-devel@lists.linux.dev>; Mon, 29 Apr 2024 05:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714369805; cv=none; b=GkLQeILtulXzMN2nbuPbCaw6B3QSH84ATwp6A+iUALVErkY9X0ALVjT40+MJy1i3h+CA723mVxWrFHFWYjaGmmeV7ap97CsG9tJB4H2LoBLzgrSIrN/rrODhm8Nj7p9y7buZY8yUPuDgj+sWp4+LQGtqYFjdsI4RDRxNA3sUsNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714369805; c=relaxed/simple;
	bh=IZ0pCnE6LGKSv1BY8600SAA+8YX35szUvdWSAvdru5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+4Ydcu42k3Oh/+Y7eNXx3vljY3vvjRproATZJN6hF5vjE+SNISvoFqrZ4Q3D2c2YSyBZjpk1Z6thv20xSyKjx0vdRb99mL25wILxl3yZiiu7OCOOXrsyBS6pewCP+ihESc4Zatpy9VKlWAkIJX2dhpuu7JF7Cw95w2nQ4MU4r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S6knsJOv; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S6knsJOv"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a58f1f36427so138865266b.3
        for <dm-devel@lists.linux.dev>; Sun, 28 Apr 2024 22:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714369801; x=1714974601; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fBC8NsME8FDQrSM2a9ldWs4Dp8svNoY8pDm9JIJNDxs=;
        b=S6knsJOv8vgLJKBD7yNyvXHLGKlGr53kLHXEyurmtYg6YV2LKbGeGOCCp53YnMQwit
         tuDYeXvrZNFALsbixxT6ncFDSVT6o6Cc2AE5/FZzzHweMh91dZ3OR+eIkXbFXXHNaSI5
         j8mecpJfGl/o4UAsXpEWeYjkjaGoO3tL1kNnbQXJZXUdHVMFSFjV3GIz1yS6qKjwK54j
         ounAiUutkiboBqq0ucwA2L3fZE9VkCNURXjOhb1YyF9f1mq0y/WmXwrGjU/nNAL8gG18
         ngYeBIyxnS4hvp1YrXZ3odFlvt9qB7jIp266wkcWtGo+wi1u8mVWjuEWRZ82ZlpyYXGD
         QUsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714369801; x=1714974601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBC8NsME8FDQrSM2a9ldWs4Dp8svNoY8pDm9JIJNDxs=;
        b=GuuR9QHS/EJc2FYk4lup2aLpBXQlNPob3iAHtMPEg7x4JkOJqSFdxX9FOIPg70/68Q
         avD7ml9tISuejh9tIENf71JFxhjSukeTzCWxPGctD8ZsoqrYPBt540rrzTcFC2AuhxVR
         vgY4nmmLhOnrjbEjFZta17FnkMIpX7FkpGF8YzmkNPoQK9vUWH3jJ7kvqBiDl4GA0u2B
         GLZr8anYxsUMDoCS7K461D8fFtcB8FujkvyoYWO0nkaNI5Mp2m8kO+MOIpNW1hfBpory
         PS5uZI497Sj0wauZpuGe5i3IUbDsw82Fo7cu2rNuIC00WUFIPDwCkOGakUHxcoqgKsd5
         9vLw==
X-Gm-Message-State: AOJu0YxoLGwu0Il/NeAncrkvcE/Gzz/7huCcYC6aKLCWUgzHzZvIub8n
	xFZpuUzOLMgyySzTppHTu1dgZWirbsVkEtP58ve7luZGAEBlvM8Tpjfguc5VS4A=
X-Google-Smtp-Source: AGHT+IHz+gH2i2CuUvU4/lWr2eFTF6pfN39+7821KdJqT1JXS0SoRmi+x1kCqWIvwpXfweuET6tjKA==
X-Received: by 2002:a17:907:1b27:b0:a55:b592:7e0a with SMTP id mp39-20020a1709071b2700b00a55b5927e0amr7295555ejc.48.1714369801217;
        Sun, 28 Apr 2024 22:50:01 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a4739efd7cesm13602468ejp.60.2024.04.28.22.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 22:50:00 -0700 (PDT)
Date: Mon, 29 Apr 2024 08:49:55 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: dm-devel@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [bug report] dm ioctl: harden copy_params()'s copy_from_user()
 from malicious users
Message-ID: <5cde5d51-a8f2-4c30-a016-1fd8e34212e0@moroto.mountain>
References: <f84a96d7-2df4-4f79-8c27-83a1d9574412@moroto.mountain>
 <202404280901.96E2E1AD9@keescook>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202404280901.96E2E1AD9@keescook>

On Sun, Apr 28, 2024 at 09:20:35AM -0700, Kees Cook wrote:
> On Sun, Apr 28, 2024 at 04:12:07PM +0300, Dan Carpenter wrote:
> > Hi DM Maintainers and kernel hardenning people,
> 
> Hello! :)
> 
> > drivers/md/dm-ioctl.c
> >     1931 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
> >     1932                        int ioctl_flags, struct dm_ioctl **param, int *param_flags)
> >     1933 {
> >     1934         struct dm_ioctl *dmi;
> >     1935         int secure_data;
> >     1936         const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
> >     1937 
> >     1938         /* check_version() already copied version from userspace, avoid TOCTOU */
> >     1939         if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
> >     1940                            (char __user *)user + sizeof(param_kernel->version),
> >     1941                            minimum_data_size - sizeof(param_kernel->version)))
> >     1942                 return -EFAULT;
> >     1943 
> >     1944         if (unlikely(param_kernel->data_size < minimum_data_size) ||
> >     1945             unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
> > 
> > So what's happening here is that struct dm_ioctl->data[] is declared as
> > a 7 byte array, but it's actually a variable size array which could be
> > more or less than 7 bytes.
> 
> Repeating from include/uapi/linux/dm-ioctl.h:
> 
> struct dm_ioctl {
> ...
>         __u32 data_size;        /* total size of data passed in
>                                  * including this struct */
> 
>         __u32 data_start;       /* offset to start of data
>                                  * relative to start of this struct */
> ...
>         char data[7];           /* padding or data */
> };
> 

Ugh...  Those comments are out of date.

What happened was that back in the day we added padding to make the
struct the same size on both 32 bit and 64 bit so that we could do
pointer math like "param + 1" and it would work on both arches.
But they couldn't call it "padding" because there was already a struct
member with that name so it was called "data".

And then people started using it for data and made it a variable length
array.  When it's a variable length array obviously "param + 1" is not
going to work.  So the original purpose of the padding is now gone.

So now to calculate the real, allocated size of the struct we take
the sizeof() of the struct, subtract 7, and add the number of bytes in
->data[].  #LOL


> The Subject in the email is "bug report", though. Is there something
> here that is breaking?
> 

I was going to send an automated email but then I changed it.

regards,
dan carpenter

