Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B46F6F072
	for <dm-devel@lists.linux.dev>; Sun, 28 Apr 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714321240; cv=none; b=uPNlQrb5JEhUQ3Ofsgrelq23tz0MV9exFgGFWSdKwzmLt4gC0eKOHQh6eIiryH4ow00PZQTNDBINPT5P8ybkCOnqsWZmNpUiVEd96/NGxXTaaALMyWNS0M7xwiz/VkQp2AJKPOQsNiYu8xszw2BW1mzEdE+gtS/5WyIc+NQpoaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714321240; c=relaxed/simple;
	bh=f2tCTky93nnJ0/jqNwc4K5lgk7+27FoSdTl9Rtji8Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkeUUKafUYZMOIKqnmGY+1OMQ3fGMhVu5F5C+JlRY24WriS1V55J83PlOP7dnE4+lVy0eZ5ck6jDDpARkddlPXpO2Csb9HMUuC86dvqddWEaguAY8rMIKzwle244Hj84H8xLOXDWW22iW/6QsZEK0Mu7SBbt95IKgfxEqYdo98A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jAbNiyhG; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jAbNiyhG"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6edc61d0ff6so3759573b3a.2
        for <dm-devel@lists.linux.dev>; Sun, 28 Apr 2024 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714321238; x=1714926038; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0P05sbTDVKF10bastmOP91IsPryc/NUcAbtYXYan6I=;
        b=jAbNiyhGdru4QXtb0r7I5jfPqE0X7bniXI5bqtDGyuJrLJzXKiUnkDFGIvKx31rymz
         sKk9ERqQL9kAs+zZuKlu9DOTJ79HFPVYQvNWXewu9zyUarCTt/GtKpqn7bj70FLacDUD
         uHe1A1XzCpODJwkb1GdoFsR9QNooMXrcUOAvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714321238; x=1714926038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0P05sbTDVKF10bastmOP91IsPryc/NUcAbtYXYan6I=;
        b=E+EPz7aps08wxwhBED4hOhQDgRGbKLDX2/afZOT/COFIeSB0Fp59uqizxYYQdq6kUd
         UYFBa/W2pnsJoeoVpBXmU94oc3fFtknOEPWRT++MbCktw1O1zJ8wp4zmz+bDqC+OE6Lb
         JrxMRd283BZ2HUD6MMhPMZe7sKOmTqLsVBm2DV14ZSoZrzUQKQWLlZUL//HbGB4bi4T0
         tnGdl1IVP8bS6rmy5hGatMHIJaExJYUIY39HAJTdDUwoWX7O7AZvHc5+uW2Jr9qEcJ2L
         VrYEHyn6EAt5KAgpiLTByXqTRTHkQdTqTBMmxINOh1go4eMe5H5MTorRQA6+b4i/W4wu
         cPxw==
X-Gm-Message-State: AOJu0YwlivNP7V+ZjAHuWQcIm6LchlNHZJVyaSv4yKEWXrmMdtFsGbTO
	dBWubJbu4uMwAKE67IM4Tq0kHha7j2jMt5M8myWHLJRciz8WUGd0Pwv4Zv/8dw==
X-Google-Smtp-Source: AGHT+IFkaDzmX7ELAKuw05rSAr08yJ1Id1jgQf7epd5aC+J6wUjWWfyK74FRP5NTwJtxMo+Cs8R7Jg==
X-Received: by 2002:a05:6a21:99a7:b0:1a7:8610:bccd with SMTP id ve39-20020a056a2199a700b001a78610bccdmr10541458pzb.57.1714321237815;
        Sun, 28 Apr 2024 09:20:37 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm14235446pgt.87.2024.04.28.09.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 09:20:36 -0700 (PDT)
Date: Sun, 28 Apr 2024 09:20:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dm-devel@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: Re: [bug report] dm ioctl: harden copy_params()'s copy_from_user()
 from malicious users
Message-ID: <202404280901.96E2E1AD9@keescook>
References: <f84a96d7-2df4-4f79-8c27-83a1d9574412@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f84a96d7-2df4-4f79-8c27-83a1d9574412@moroto.mountain>

On Sun, Apr 28, 2024 at 04:12:07PM +0300, Dan Carpenter wrote:
> Hi DM Maintainers and kernel hardenning people,

Hello! :)

> drivers/md/dm-ioctl.c
>     1931 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
>     1932                        int ioctl_flags, struct dm_ioctl **param, int *param_flags)
>     1933 {
>     1934         struct dm_ioctl *dmi;
>     1935         int secure_data;
>     1936         const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
>     1937 
>     1938         /* check_version() already copied version from userspace, avoid TOCTOU */
>     1939         if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
>     1940                            (char __user *)user + sizeof(param_kernel->version),
>     1941                            minimum_data_size - sizeof(param_kernel->version)))
>     1942                 return -EFAULT;
>     1943 
>     1944         if (unlikely(param_kernel->data_size < minimum_data_size) ||
>     1945             unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
> 
> So what's happening here is that struct dm_ioctl->data[] is declared as
> a 7 byte array, but it's actually a variable size array which could be
> more or less than 7 bytes.

Repeating from include/uapi/linux/dm-ioctl.h:

struct dm_ioctl {
...
        __u32 data_size;        /* total size of data passed in
                                 * including this struct */

        __u32 data_start;       /* offset to start of data
                                 * relative to start of this struct */
...
        char data[7];           /* padding or data */
};


> 
>     1946                 DMERR("Invalid data size in the ioctl structure: %u",
>     1947                       param_kernel->data_size);
>     1948                 return -EINVAL;
>     1949         }
>     1950 
>     1951         secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
>     1952 
>     1953         *param_flags = secure_data ? DM_WIPE_BUFFER : 0;
>     1954 
>     1955         if (ioctl_flags & IOCTL_FLAGS_NO_PARAMS) {
>     1956                 dmi = param_kernel;
>     1957                 dmi->data_size = minimum_data_size;
>     1958                 goto data_copied;
>     1959         }
>     1960 
>     1961         /*
>     1962          * Use __GFP_HIGH to avoid low memory issues when a device is
>     1963          * suspended and the ioctl is needed to resume it.
>     1964          * Use kmalloc() rather than vmalloc() when we can.
>     1965          */
>     1966         dmi = NULL;
>     1967         dmi = kvmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH);
> 
> We allocate the correct size of the variable element array.
> 
>     1968 
>     1969         if (!dmi) {
>     1970                 if (secure_data && clear_user(user, param_kernel->data_size))
>     1971                         return -EFAULT;
>     1972                 return -ENOMEM;
>     1973         }
>     1974 
>     1975         *param_flags |= DM_PARAMS_MALLOC;
>     1976 
>     1977         /* Copy from param_kernel (which was already copied from user) */
>     1978         memcpy(dmi, param_kernel, minimum_data_size);
>     1979 
> --> 1980         if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,
>     1981                            param_kernel->data_size - minimum_data_size))
> 
> Doesn't the kernel hardenning stuff have run time checks for if we
> write beyond the end of a 7 byte array?  Why not just declare it as a
> zero element array?

The usercopy hardening was implemented before we had reliable array
bounds handling in the compilers, so it actually looks up the allocation
size when performing its checks. So, it'll only yell if
"param_kernel->data_size - minimum_data_size" is larger than
"param_kernel->data_size - offset-into-allocation-for &dmi->data" (which
is minimum_data_size).

Now, it sure would be nice to not be lying to the compiler about the
size of "data", so I would generally recommend this change to the UAPI:

diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 1990b5700f69..170465be55af 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -143,7 +143,10 @@ struct dm_ioctl {
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
 				 * the block device */
-	char data[7];		/* padding or data */
+	union {
+		char padding[7];/* minimum structure padding */
+		__DECLARE_FLEX_ARRAY(char, data);
+	};
 };
 
 /*

On the other hand, if nothing is actively broken, we could just leave it
as-is? (But if we ever try to memcpy() out of dmi->data, we're going to
run into trouble.)


The Subject in the email is "bug report", though. Is there something
here that is breaking?


Also on a related note, the validation for the "data_start" member seems
a bit fragile. It does get checked everywhere that uses if FWICT, but
it feels like it'd be better in validate_params(). *shrug*

-Kees

-- 
Kees Cook
