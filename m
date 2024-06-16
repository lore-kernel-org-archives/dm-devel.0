Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3116B758
	for <dm-devel@lists.linux.dev>; Sun, 16 Jun 2024 02:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718505836; cv=none; b=IYNXKXNJP0QEezmTNI8nH+3eMnH3avvMPTUnndybgWBa34BHtfGb3ot7pMlJjcg63MH14pDtNLwUf7N9rjjTjV/IwaNb262vCrH6ezMOJ+t+HPGo+9G8k2cQ6JXeT+pFxOZu6G37NHzIiiXOwZe3oRcgk4WzQEOOUwpNP4KuE24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718505836; c=relaxed/simple;
	bh=JrEOKQsZpx/43K9L0BGq2i0RXpBV5EJVJt92kSSy7a8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=H5grP+9t8aXQpXMpXt0VEzZ6UVS0QUrNttLXC4YF5Do1jxjsvd8mg226dvwGEzDefPKXxDvCL8pfnGq9eW4hCKF1nh0NftNWPQ7OItBkaDrMyZV9d9hlk9DR5TSDKP5B6bSKSJgR/RxGJPaPlch3qcdMm4JC/byTx4bGqfdVHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C+UBagpR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C+UBagpR"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70434e71e20so100935b3a.2
        for <dm-devel@lists.linux.dev>; Sat, 15 Jun 2024 19:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718505834; x=1719110634; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR+Kktv2CqIfMF5pjxxJeGplqIvq6qtrGLHRMhsS3jE=;
        b=C+UBagpRwUWsfRfJ0bVq5U5zQdL0jJ311fQm1l/cQH31sM63wGYgxQzDEYUOFWn8yn
         MObCEyJJKxmOZJ7TW5kcfD1s3cMFebnENdB22ooVa0X1vSV/orZeZG58sd2XEQqT8dvb
         H+oiiQZGzn5ReQcd3mka5vZ+yIPKzgzubhRd5sAYRSkwYKaNMjvvX0muKdCZtFUTtLWZ
         vGldvsjgtlCLuxFiT6IuVxBEOdduX0uDSsCXcc7fIcmwura1Ehughw7H2Ckf+tcWkdUT
         a0wQjl70m6MJUbu8TndFQy2xfSmuhnZJbBh4s2qDBV6nVV13jGPCrKVZLay9RxVUvJPV
         fN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718505834; x=1719110634;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rR+Kktv2CqIfMF5pjxxJeGplqIvq6qtrGLHRMhsS3jE=;
        b=TC9i6LfiYzTLhrtk4HHdau1qcHgIGdsZ6VyT+8nq6tbYpi+1H2+dQ2vZ8pFbl27eSJ
         SuHAg0tulgCg6z6NyHPoKWmQpVWLmL4zx5Gi5xMDrukmPnSl/e9/y9u8si57ESdyUzpl
         8pvufI0gIgV8osHHByV6n39qerEI30g2q1bpTTuq4Hia6UqRveLf80OLpDwWcANGrVQP
         +xNuZHHcFdofXeHP4FtX9ME7yrUqMkkRkoTwIbakqhw818F1oSFCExP10ijUPjLvvhbt
         AYyPZxdOeht+1/ujEKRKBqwaD10vDcsuaTOyfvWsyKTW0BmbNDzBmtlRAyk89RENrkX6
         17/A==
X-Forwarded-Encrypted: i=1; AJvYcCW68/y8dk7vl5fvzsH6U18NvvbP17T8GZG068MZqusumIsge22HFxtbCbLetCezNJgW9Cn8jjkZ6+lTDRUxBaM6IwOghUvMERQ=
X-Gm-Message-State: AOJu0YwwzGrU84a2ACpnLy6RAgTEdlIfP0qFJQpMrJUQutW7GAGGaWHW
	NupdLzgUG0NOh0WNru8leg6Atf6fbxizCITWK/0nwV5PIFhlQ+fng/UnLKXkOwA=
X-Google-Smtp-Source: AGHT+IG1i5cgwJVA8vh9SbkwE5581/PsKNj+PYwV5FvPNqF/jZtOgojMNgqOAycYGJO5VXIAErcOGQ==
X-Received: by 2002:a05:6a00:310d:b0:704:23c3:5f8a with SMTP id d2e1a72fcca58-705d711f80emr7239744b3a.1.1718505834411;
        Sat, 15 Jun 2024 19:43:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6b9b3sm5283246b3a.166.2024.06.15.19.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jun 2024 19:43:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
 Benjamin Marzinski <bmarzins@redhat.com>
In-Reply-To: <20240611023639.89277-1-dlemoal@kernel.org>
References: <20240611023639.89277-1-dlemoal@kernel.org>
Subject: Re: [PATCH v8 0/4] Fix DM zone resource limits stacking
Message-Id: <171850583327.9871.12800424447881124530.b4-ty@kernel.dk>
Date: Sat, 15 Jun 2024 20:43:53 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0-rc0


On Tue, 11 Jun 2024 11:36:35 +0900, Damien Le Moal wrote:
> This is the updated patch 4/4 of the series "Zone write plugging and DM
> zone fixes". This patch fixes DM zone resource limits stacking (max open
> zones and max active zones limits). Patch 1 is new and is added to help
> catch problems and eventual regressions of the handling of these limits.
> 
> Changes from v7:
>  - Moved v7 changes mistakenly added to patch 4 to patch 3 where they
>    belong.
> 
> [...]

Applied, thanks!

[1/4] block: Improve checks on zone resource limits
      commit: e21d12c7cd5cef8a6c5367f96aaab01249216ded
[2/4] dm: Call dm_revalidate_zones() after setting the queue limits
      commit: 7f91ccd8a608dbe39b97a6e43d635378d493f77e
[3/4] dm: Improve zone resource limits handling
      commit: 73a74af0c72b7cfd843cbd93e088fc5c51471a84
[4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
      commit: eaa3706fedc6a4142c251b2d4005d850caeabe50

Best regards,
-- 
Jens Axboe



