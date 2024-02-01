Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C584FAD
	for <dm-devel@lists.linux.dev>; Thu,  1 Feb 2024 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706810424; cv=none; b=gKZO95xay35IJGLOKkoxsUpBSNGan70birresa6nO0Xn/secC5yIzOYXJFY/DgPL4D7rxt7LnKv82EfO7iIsvHovsrCQozmhuFLMRU/WxSPmCx+Ut+9ADdr+EgTjWVKPmFKh9gwyhaWbxEEwLez28/TjeDz9ZrZWljEskzKlCUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706810424; c=relaxed/simple;
	bh=tggWUAivVyJhHb3WLH9fYfPCLVXtiXbZt06E4ruadzg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=GGOQ92V1QAPm6DyyB0xBKbEkStrKAGp2pkSnRsdFeJ17TvF/fAFbeS8i5Zq6L6yrRKngC35Um/C/hn1yfmsApacXzEixzutMyjUzAa46XIF+NvLmXh7Rmhi25WfVuOtsxzyeVvOnFzSsfkLKIsDPjoClVon7O7PZYBmBV3lVd6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FwZMNfvf; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FwZMNfvf"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-35d374bebe3so502835ab.1
        for <dm-devel@lists.linux.dev>; Thu, 01 Feb 2024 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706810421; x=1707415221; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuXs00SouWU+bfUEvdSrCjdAuWK9g2pMKfreEo+/SA8=;
        b=FwZMNfvf5sovexP/Rfdvx1zQdvKAauAx5mMUUfIFz+wvG2afG6+53v8gAikuE82uFL
         ORyBCBxLzY6W/Pc9i0C/KDGCYeTFDBBLv3+aKP7OrJcTYzK6pEZITfFv3p11xekpoCLH
         b6HowxiEIX/rgZ10o9MVWI5d2JCeMKOZ+S+Ya82MWH8DEBFNYf8Ne0cxfU79/f6rv+8n
         EnsZ3Ueuqxm+HwgpIWqEuQBf41ff7hcFDwHvmvxMoOqWIihHjxa82wpYoI54YVZeasgy
         f6Qd1nQAXuqMJj3sWK1wwLGpL7SF7J2zvUaagGbRzIQb+v0ukPJecP11Q/csYtuCBOD+
         MBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706810421; x=1707415221;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuXs00SouWU+bfUEvdSrCjdAuWK9g2pMKfreEo+/SA8=;
        b=ICE6GynM3CZ2Uy9WDU7oA7B+FBa1CtbfCj+moeHYzmczxrAUqF0eItJGKRgkZDDN7j
         pEvCAf6XKplU+q4tcVH+fwXlHltC361Fph5/P5yJqgvR9Au4Kea7cZ/P4ckbD7ufPF6t
         DAUkY+E1q9cEQTJ8w/0JAUjqqIXtQGJj/Zr49gBdkay4VIOoHby0Of/XmKM2CxDCMwQr
         5ou36QqG4tTqd2+JUHs/AKbWceWKoOvMNueeHbQP4b/hMS6hXfREms5hgNc8i5gL3ft9
         FpH32yjwoc5TWU6p7cd2/G5L9D6Fy/0QAStzeNaSb8s4qDB1TURDJQo3jTv3MBzbMjrJ
         rnBw==
X-Gm-Message-State: AOJu0YzXCBnkkOZrQPQD5CjrJrk3z6JNoKCX3pjA4v5HTJ2HufSmMjRI
	EMVrWn2VFa+2hGBx72dZ/HTdBKfbx8pnSKUMLVOSmotL3dA9Xz4Vq4s3t+P4oJM=
X-Google-Smtp-Source: AGHT+IHFGMCDx/rCwfIbzWpWJzB8ZT69Ezk9RJWEnazXn7AI05wsEpCY8hFKJqRYkJQrNa2d8Dd6RA==
X-Received: by 2002:a6b:ef13:0:b0:7c0:374a:dbd2 with SMTP id k19-20020a6bef13000000b007c0374adbd2mr609538ioh.1.1706810420863;
        Thu, 01 Feb 2024 10:00:20 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVEu2AcV1cc6clQ9bxFiZCjuSibYqUr+oawrqsuMmBSYqbKtSam92vJM+1k6MJ+Gvz0gP2RclcgsuqZ6fOvH0SdoZUS3BQeY4ZgSDKRwaGxbS8SdfPTZwEnrnwFWSMHL037IRAfootBfFt0ZwE7rP+SEKjC4VP++RUT
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x1-20020a02ac81000000b0046f3f0622b9sm14729jan.84.2024.02.01.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 10:00:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: hongyu.jin.cn@gmail.com, Mike Snitzer <snitzer@kernel.org>
Cc: ebiggers@kernel.org, dm-devel@lists.linux.dev, 
 linux-block@vger.kernel.org
In-Reply-To: <20240130202638.62600-1-snitzer@kernel.org>
References: <20240130202638.62600-1-snitzer@kernel.org>
Subject: Re: (subset) [PATCH v9 0/5] Fix I/O priority lost in device-mapper
Message-Id: <170681041965.31162.2641020095015336621.b4-ty@kernel.dk>
Date: Thu, 01 Feb 2024 11:00:19 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Tue, 30 Jan 2024 15:26:33 -0500, Mike Snitzer wrote:
> I've revised the patch headers a bit (patch 1 more so than others).
> 
> Jens, please let me know how you'd like to see patch 1 land
> upstream. I feel like it should probably go as a fix for 6.8-rcX; I
> have some DM fixes I will be sending Linus this week and can include
> it (with your Ack of course). But you're welcome to pick it up just
> like any other block fix.
> 
> [...]

Applied, thanks!

[1/5] block: Fix where bio IO priority gets set
      commit: f3c89983cb4fc00be64eb0d5cbcfcdf2cacb965e

Best regards,
-- 
Jens Axboe



