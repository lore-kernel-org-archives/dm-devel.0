Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293964;
	b=Ohfi0KLGaIoG9A/Gu3qwk+hR0jjNpvoNjzEz1njVImHUk3p/zi068xpS7Fr83W8Iexeg
	 d1SPOf+Ztc4VCGAXI9lwUd2vNHPwbD3MKHjO+P/8T/Y15gj8kyM/g+uATj+HGqKVCknDv
	 OgtG7Ziesk0j8p4jdOzr1ZdTmgPDdy+1qye/R4ukmon8uTXmFo3p7gcfCJecIb5psQlhr
	 jeoBYivbodn5/GCpg9nsNcB9c5FTGqTz3vgzXc+7HqWK+oRtshPRvtuhJP7rQFc74QdTe
	 bAPRiNxB4rbHsNj5TxmaxEAsCa/P0SuERmqRDIAZml5IDgTfo40ZqAVq0c+wwjhkLcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293964;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=dqlkwUV9tYAEbSb1BQ5TfPNY6DFBwHzpfk0RyIwAqNI=;
	b=wTa0NvjlYnygqcIWAqa9yhIOX6uPr9c4Mm9h6AEjB/QjJwycDYnVY9XXBakKiOuO71Mb
	 SQFNPOAlDFtUNGJjdiuyNbYhmjN+SNlGwfr/DjELokBxvRvDyw9d0ah9aAtyOXsxiqFMv
	 ATd1z4sYznjLXrjHCiW7tsk56y1a7Q/TyKkmuznmr+hHSnCOh1caTRH17y43EQ6VQTBUl
	 WaVH3Mukf/wll2kGzU8ur2Q8H3YU7U3OvGVmVeZsCYYGyk+XCMOdE1Ry8KyxY8KNWUoZ8
	 P13YpFyFE1FmKvy+wHju5dMepe0i8dvzGDfHR+Dxm0z2E7znSsWt1grGY8auZlPWh8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kernel.dk;
	spf=pass smtp.mailfrom=kernel.dk;
	dkim=pass header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jdwSe31X;
	arc=none smtp.remote-ip=209.85.161.52
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEFF606A31A
	for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 17:12:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DEFF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel-dk.20260707.gappssmtp.com header.i=@kernel-dk.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jdwSe31X
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6dd4f3f696aso1307706eaf.1
        for <dm-devel@lists.linux.dev>; Thu, 29 Oct 2026 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20260707.gappssmtp.com; s=20260707; t=1793293961; x=1793898761; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dqlkwUV9tYAEbSb1BQ5TfPNY6DFBwHzpfk0RyIwAqNI=;
        b=jdwSe31XtkgGQwQDZj7DA+ixPEB3opDtYffFbQfwlV3nTVE5NP8CNa2QaP1FPJHgIA
         iHsGgg1uV/0uV2wUml/yOOlsE/9w9soji9HQjxTt69xN/41k6wwW31OR4F5bqngWr8je
         UZbHcP6XiioYJoLahrYMa8GoaVerZbywSnow9b3h3Tt/H/iVkU4kafX20XNgvZUUOLEp
         /CpCA0FR8P462BY4v3jZYFAryKVptiQ2RyCMa6Rc+NAWkPTq+Yl6Qul4JTv3qu9+59wJ
         qzxVuGbUGu7Axco06+pMRWXVhDc4v26FVOY1CmNlLI9aQJz/C+DTauy8Aul1syZ3yRdZ
         MESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293961; x=1793898761;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dqlkwUV9tYAEbSb1BQ5TfPNY6DFBwHzpfk0RyIwAqNI=;
        b=z/2KY9+Mib23+jCuaKHJt+JcxhJ4141nC7dibjfOAshh2rHmmigOSRbI3r3vW2RPiq
         XEsKG2o2e6dJdU7VE0jXxMFqC7o7wKB/SI2cTBll9UDkvnzxRyrghRXvrHNhby6c1JZQ
         RnmdAyY/yua/vP1wKKXHEreWl+Gt+WPScJfHLi004rfoML3ae2x6J3Ym1R3FWuvs7utE
         fXAjOShqlarnbVEWKEdlxVIifZnwdaKcP36+4ROHqqk953VogpcYZYHrA21isResFsyo
         wb/fReSEDc0FLxwAp+59j3TMO+daiqw08svW7uNUrmnTEQKU3hOvsfGMLLt1e9cBTBPU
         sh3w==
X-Forwarded-Encrypted: i=1; AKwUvBzHwP4qEiWy+NQcWsim18xcapGiEpDKLcpOYEw0U2nlKalFQC0rhqpP9277rDPISoK2W6NSqHEtSQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLjtMRY+gBuX/yBdt1dAIQjNSVlujXAk/LrVNnY/5YcHOFEDd+E
	rv2A15LJgOe3ndYR7FN95TZ8VV2WbXAEPr96YYJ5huTv0FcTUvvFGuLfG85r9ogpDoqMbFD5sDY
	lhVS/lME=
X-Gm-Gg: AYBFou3UALkspoQkEbeZb1ZXs8/+OGuQ1sl3EOZwY19z4jfVoaOdlDPQPKuJrY79RLd
	QCvQib29btg/NKg5MIUM6tGRuRfbKPZJf5WdNclYSZ4XrJ9xDHxUTLptrXm16z458OCC2VLCl4z
	bUs6Vcxh/PmIpl+9YbGaUzGukVE07HwHw+aNYs75MW1IL1T1//g6keUdUb23pU4lWe4yrN9NtWP
	60cAObrpM+51w9TYoVncOoBSkNbt2dZAYW518spcnF8RKGGNsXFeAlo3MnuiuVNfNYITzKwkxKv
	16gg3rCoN/2PpGUhN+wAAVY7iKg47hXAMxKM/bgC8ncG/Lw09lrJ7b83CO8nsUH/PWT04JJYN+a
	M4k2V/gVrhsV8896WL6t5QUMvPU/nc/GTK5k+VrHQXWkjRMp+lSilBycWdpi1PxQc2lY7gLuESG
	YuN5ALNE0dzi+KdvL8ND5bFkoXlI7N6iWfh1raT4E6A6nvAqGm4DbEA89+CqA1OsxMrF9fpsHai
	g/+r1fAqnCwq28SELzbxiDTlQLXWKKSN8SuXUDZmE0i1w7jnCOSvbccvQaIFqDpxQOX+STGqybP
	CD1I+faZntUQ29IDI4Uo9MDB0eNG3fokNfD2Vxu6uXmzEOx5FA/XgkSqC9d9DfntFPpdJ8OLwhc
	LfyjVC4Jzsg==
X-Received: by 2002:a05:6820:1505:b0:703:27e0:354 with SMTP id 006d021491bc7-713efb14bd8mr3282860eaf.66.1793293961512;
        Thu, 29 Oct 2026 10:12:41 -0700 (PDT)
Received: from [192.168.2.38] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a9049af7d1sm463fac.12.2026.10.29.10.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 10:12:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
Cc: ebiggers@kernel.org, linux-fscrypt@vger.kernel.org, hch@lst.de, 
 dm-devel@lists.linux.dev, mpatocka@redhat.com, sweettea-kernel@dorminy.me, 
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
In-Reply-To: <20261023081908.3505413-1-libaokun@linux.alibaba.com>
References: <20261023081908.3505413-1-libaokun@linux.alibaba.com>
Subject: Re: [PATCH v3] blk-crypto: fix NULL deref and UAF in
 __blk_crypto_evict_key()
Message-Id: <179329395926.1528866.6542405425751626681.b4-ty@b4>
Date: Thu, 29 Oct 2026 11:12:39 -0600
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15.2


On Fri, 23 Oct 2026 16:19:08 +0800, Baokun Li wrote:
> Sashiko reported a possible NULL pointer dereference, triggered by the
> following flow:
> 
>   dm-inlinecrypt ctor            # first use of the fallback
>    ├─ blk_crypto_init_key()      # succeeds, ctx->key.size != 0
>    ├─ blk_crypto_start_using_key()
>    │   ├─ hw-wrapped key: -EOPNOTSUPP
>    │   │    # profile never allocated (NULL)
>    │   └─ raw key: fallback_start_using_mode()
>    │      └─ blk_crypto_fallback_init() fails
>    │         └─ kfree(profile)   # not NULLed
>    ├─ goto bad
>    └─ inlinecrypt_dtr()          # evicts whenever key.size is set
>       └─ blk_crypto_evict_key()
>          └─ blk_crypto_config_supported_natively() = false
>             └─ blk_crypto_fallback_evict_key()
>                └─ __blk_crypto_evict_key(blk_crypto_fallback_profile)
>                   └─ profile->num_slots # BOOM!!!
> 
> [...]

Applied, thanks!

[1/1] blk-crypto: fix NULL deref and UAF in __blk_crypto_evict_key()
      commit: c8c53d669d4e45b3a804013251a34387d7e11bfb

Best regards,
-- 
Jens Axboe



