Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0217F7
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 02:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710988876; cv=none; b=Hcvru/lZhcezKqPlRqSgiwhmRvSf5sel8wDuocBtbm2c4Vp9+wMjzG6xYNeRIzmym4GJsYqBdJhoJ2jbHUeuKm0L+Fwwt1MrMmymLvatAAZrD78vaDL+fdmLlqSaJ+4FAjdk1au67SUxQ7ymZ3GcdspmWKb5eSqTP7xM1ZyqQRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710988876; c=relaxed/simple;
	bh=48raKXF2/dxohRpGhJPb6ohvogqVUVsODvFjK9PsDZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZ+ANwZBltCn2zOq4cSIIbRTFRc0Xa8RbRAroboI8i0kUC3spfJlMyYcCfqa0GQMbjMc7Dec8rkNN/ImeDMNHQqFzVzRLQ+dpublWGB0ldmWHYiurdkEhMqMUEffsfTK7tQ3s3Z3hgDtRfqg3Z08waaL4A/exKdaj/X6c0ya7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+yruWUJ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+yruWUJ"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e73e8bdea2so491474b3a.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 19:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710988874; x=1711593674; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oC50l27jOECYM15O9eydIrzegzfUqf9NwMLtBgxKr8c=;
        b=R+yruWUJLOgsny9y6yO6Rv3DxkJzSKu7BdqJ39Y6NqXjz/2tn5wL6MjLp5pR2dDeOr
         X9/BgaziCCZnoVzRJXghoU7XNOcpNEn9WARA3gGaIMPNdeyid2sFFUX7Z1M00pEPNaAl
         TM0IoLLgiltizKFElR/zy+eoMHMgkbWWcyDA8qsxyli4Ubi5uE2lfQPIwa7jy+O7ZVOA
         vTr7EG0FkdLdPmzoNf7SEEfv7Fi3lfNCIg7/Njv46pXjbXk9z4SfnQbvdvEFVSZdLOxa
         ryRZ8JDW//ox2EhFdqhpJjTPEABZ7V60JedsbvNyZdZYFDIXD2QskbrqA3fSQfavUXEk
         TTKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710988874; x=1711593674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oC50l27jOECYM15O9eydIrzegzfUqf9NwMLtBgxKr8c=;
        b=GkJT80+k/xlOHLcdShI0FSCdxrP5YuNusU/ctZV49wq0nvptmxXMpgbP8zg/8TXlHK
         64ozz4S8yIaIZwHXLH7OZJJk+rl5mIqKhEjIrFx2fVjj+Gqybkw7xFwR8WfON9uTb+sc
         1Ke+gRvW44poAe6J6/2WZyKpbGwirWASZ4N1uadN44BhDIIg6naisZs3XraTpPayRtwY
         9Gbnq/xD781b2hzIY1lmJiSkYoPg9/DThO9GD9oJy3Zyil62tquYcNWS3S63EcA7rdzS
         cVxlf50PV3rcjxTVYdNUdHTLKWF1CGokQ2V7UiuiYq/ZV2O+3vAoL/UF9ln61aw2I/vi
         tp6Q==
X-Gm-Message-State: AOJu0YyMQtE9vO6y6TLmeBlnOLlZVdV2liQFENcwJfZHXDLQGJtVKNGj
	c1UamYurKCM6M23t/jezk23qp88VM8rwbw8CokL+MeW92cBzEr0K
X-Google-Smtp-Source: AGHT+IG3zYL4p822in0uZcrtSSRhEnn3bZVlVmtmYmq8uos5bhZnQwunEtdTbqVC8cBMviSfbc6cJQ==
X-Received: by 2002:a05:6a00:2395:b0:6e7:1833:883b with SMTP id f21-20020a056a00239500b006e71833883bmr4729815pfc.26.1710988874509;
        Wed, 20 Mar 2024 19:41:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fa31-20020a056a002d1f00b006e6c856c0f3sm12363668pfb.188.2024.03.20.19.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 19:41:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 20 Mar 2024 19:41:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, Ken Raeburn <raeburn@redhat.com>
Subject: Re: [PATCH] dm vdo: use kernel byteswapping routines instead of GCC
 ones
Message-ID: <7e210190-915c-4bba-985e-483e8f340384@roeck-us.net>
References: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe10f7bf2332c868deb88bb59967fa1880b1b34f.1710970229.git.msakai@redhat.com>

On Wed, Mar 20, 2024 at 05:44:05PM -0400, Matthew Sakai wrote:
> From: Ken Raeburn <raeburn@redhat.com>
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Ken Raeburn <raeburn@redhat.com>
> Signed-off-by: Matthew Sakai <msakai@redhat.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/md/dm-vdo/murmurhash3.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/murmurhash3.c b/drivers/md/dm-vdo/murmurhash3.c
> index 00c9b9c05001..124026cb676a 100644
> --- a/drivers/md/dm-vdo/murmurhash3.c
> +++ b/drivers/md/dm-vdo/murmurhash3.c
> @@ -8,6 +8,8 @@
>  
>  #include "murmurhash3.h"
>  
> +#include <asm/byteorder.h>
> +
>  static inline u64 rotl64(u64 x, s8 r)
>  {
>  	return (x << r) | (x >> (64 - r));
> @@ -16,24 +18,12 @@ static inline u64 rotl64(u64 x, s8 r)
>  #define ROTL64(x, y) rotl64(x, y)
>  static __always_inline u64 getblock64(const u64 *p, int i)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> -	return p[i];
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> -	return __builtin_bswap64(p[i]);
> -#else
> -#error "can't figure out byte order"
> -#endif
> +	return le64_to_cpup(&p[i]);
>  }
>  
>  static __always_inline void putblock64(u64 *p, int i, u64 value)
>  {
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> -	p[i] = value;
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> -	p[i] = __builtin_bswap64(value);
> -#else
> -#error "can't figure out byte order"
> -#endif
> +	p[i] = cpu_to_le64(value);
>  }
>  
>  /* Finalization mix - force all bits of a hash block to avalanche */
> -- 
> 2.42.0
> 
