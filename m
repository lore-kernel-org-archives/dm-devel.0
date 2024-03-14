Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD32717591
	for <dm-devel@lists.linux.dev>; Thu, 14 Mar 2024 23:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710459315; cv=none; b=fqMMj7bpRwmbLuuKD9GkU6fmFM97+TpFtShACJfmMGCOkqmj6lzSo/s6plfz+y4F+ti1NdTe8Jkxk36k0MEATgqJ1Y0Lt8QoZUJIygyjciJMJqjLgX4ibl4buEO/TSmuDRv4D3ydUPg8zL8nce7Hx7iBsh+z28YJ4tyCexKJfSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710459315; c=relaxed/simple;
	bh=O1Pff7eAihB48Bz8XaabnNfcFgNRo7LQ5mqmWeDX7ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkc01p1sCt7fJ5UJP7hCcDV1E/3rn62P/wgDgkhTzuA/Ka6i8n2wZKGmqrrevFQwmPJP/BX/Xz3PgcfoEwyCqfvF7cAp6LCIT5cKIqiRaA/weg5p/xqvNO1X22SnNIYCu49CnO67FkIQhS1Pj5SvHy2OZQZuweoTz052fbC75O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fW+u6Uvn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fW+u6Uvn"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc75972f25so11264865ad.1
        for <dm-devel@lists.linux.dev>; Thu, 14 Mar 2024 16:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710459313; x=1711064113; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W6Xw2waQfNCPf/M5RAIMX7gnuEX08ICVGrEBe0UGAx0=;
        b=fW+u6Uvn4fBdm8cuTdPeiC659ZoIMhe/URZT227RI6pKPYcjTceM7HxvxA99YPkjOU
         OpPIpqyvhfQ2JCkwmnYz9lGv/0bn4kEr7Uj4757qF4JJLJ6aWzM2sm6wxN0Ll2h+00EB
         2KAjZeCH+OYOghjMbYLs6ap514SGABYmIEc/OsCH0U+0onqcScA4GUpAb1ZRVtSol8qs
         ioIvL1DDePZ2s6PU1Eab6PjdPHuSxZidw/J31J0OnWfuMmcd/AVZN81z283OPpQbQPXZ
         evp61UHz6ZZSUqMjNgAiSIX5Cc1But4uuDacNbBd9u4Xk3UzdrdpFIs5zlO15pBo+t3U
         bPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710459313; x=1711064113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6Xw2waQfNCPf/M5RAIMX7gnuEX08ICVGrEBe0UGAx0=;
        b=BS6C+UF7bBJqZCirK3t8Q78ydszHEWOSCR64vUluIPCuwWQkCZMhPuChgSFSQ/2eKM
         skfOhh/VtPHDKnVTlDocI+UQaMYv3bvA69FGd9vO/cP00q/LzrXMzuuL2YIUkEJh5/AL
         I/Orekfkbn249UX5YOtmcuHS1+vXg1G3/33BRBB/n+6ZjghicGVgr7lJYBsnX63+moJJ
         MhwjkIJNUGq534Zw9eRQX2A8ywArC0jNvfnaLqkE8LuTW0FUR8YQvyX+Ps102Rq9E4Hn
         Q4llK/SDWa/Tc1F4EqSf2cb5FOU34M/6I10p1nfZEgHNnfJKDPS5ZQlrYqrHnDVKdTZY
         PFQQ==
X-Gm-Message-State: AOJu0YzwFhqgYQFJ7wS632d6+S8STL0LDIe7WuIRBecv1pIq81tx2EwL
	uq3zWOz85CyPF4RVZZD7Kv2gndQlU/cxMVau43Yw8ot8etNMDdVsmyV2/pVr
X-Google-Smtp-Source: AGHT+IFu17ZuKR7DK43CijnrmYB1eppOiMpA8+39kWpLCxZM8OpG8tgYl+e7xkSytpOsl3aA211JyA==
X-Received: by 2002:a17:903:32c1:b0:1de:c6d:ce1e with SMTP id i1-20020a17090332c100b001de0c6dce1emr4032164plr.50.1710459313262;
        Thu, 14 Mar 2024 16:35:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902bf4900b001deeac592absm509322pls.180.2024.03.14.16.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 16:35:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 14 Mar 2024 16:35:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing
 algorithm
Message-ID: <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
References: <20231026214136.1067410-1-msakai@redhat.com>
 <20231026214136.1067410-3-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026214136.1067410-3-msakai@redhat.com>

On Thu, Oct 26, 2023 at 05:40:59PM -0400, Matthew Sakai wrote:
> MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was originally
> written by Austin Appleby and placed in the public domain. This version has
> been modified to produce the same result on both big endian and little
> endian processors, making it suitable for use in portable persistent data.
> 
> Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
> Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
> Co-developed-by: Ken Raeburn <raeburn@redhat.com>
> Signed-off-by: Ken Raeburn <raeburn@redhat.com>
> Co-developed-by: John Wiele <jwiele@redhat.com>
> Signed-off-by: John Wiele <jwiele@redhat.com>
> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> ---
[ ... ]
> +
> +#define ROTL64(x, y) rotl64(x, y)
> +static __always_inline u64 getblock64(const u64 *p, int i)
> +{
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	return p[i];
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +	return __builtin_bswap64(p[i]);
> +#else
> +#error "can't figure out byte order"
> +#endif
> +}
> +
> +static __always_inline void putblock64(u64 *p, int i, u64 value)
> +{
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +	p[i] = value;
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +	p[i] = __builtin_bswap64(value);
> +#else
> +#error "can't figure out byte order"
> +#endif
> +}

On sparc64, with gcc 11.4, the above code results in:

ERROR: modpost: "__bswapdi2" [drivers/md/dm-vdo/dm-vdo.ko] undefined!

Guenter
