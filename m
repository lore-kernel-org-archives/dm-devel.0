Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2845519D06E
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847463; cv=none; b=N6HPuWjjJXCyTiEhCzNNRYOLh9O85dCWVbACS1tczV7ECCDeQw5bXQvLOk24MituY6a79GGhT7oPYQovVsjQMZW3qx41bYYw9xc3AAJBl9y5pjJ49Y3Tl5kv3a2kxx2W4rU3ZFKZx7sXoSP33Ho6c2IFF8HqkFRQ75OillT7vHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847463; c=relaxed/simple;
	bh=MRSf3q/DqEAzzo+S/0wFTN6Zq8rXGpEMjbE8BS7GxxU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OGIOqgJZOPfSv4SSoRkP7FVCjGWIt5+hBAQLe9Ht+jgC6qlTEpw3y6LFHnSy853Y/zzw74jt3fzLrKtB/D9Xzr/1L44ixt4C9T91dUlVHg+k1f7zMgngCmR/cKQE/wKlyC9FmQo6Y2l5y0R1UexEmIJyvqcrhW3LBW2d/8zwBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yY846/6z; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yY846/6z"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-71e1728c307so19003a34.2
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 08:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733847460; x=1734452260; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc4ZR0GV0ZI1cVG2KT+gdfOjvtpXJx+W8WqkDzEwQPM=;
        b=yY846/6z/GeltVODKmw0JJByjK/Z5+qy6a4I1yjTawyTDspZ8c1QyYCuBl8jhGbiph
         6TytJemViOOi7jx5nflC5CWn7wUmIYKoCLCuxQHBcH5X7MxzrgnWzXWKNzS10mdGSppR
         Og7/Rkoe56DUemvh3JaKyEsRU9iMSoeir+4WZXc8UFehuV67BIfUNsivZc+ZS0N9M010
         tWkqFzVdF8SARdu+irweAIwTIUHE3BebQXzIZXx8d7Fcd4r8c2/e8RNv7zcJF7mIV/DJ
         k3s4KKoTZoVJAG3dVigK37vJQoDxnYb4uTuGSzFXkIbG/sUynt5LPI3/0VD1QSzbQzDz
         g4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733847460; x=1734452260;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc4ZR0GV0ZI1cVG2KT+gdfOjvtpXJx+W8WqkDzEwQPM=;
        b=fovQBdo33PrOs06Z7Mz4gS7bEdetHcwIUvtGs18pfnzDwXrbZZUXKYorbEGJXJzx9T
         O7UEkQ/JMZ01lzciXDj8Ez5+F4+vuyzJaG5JKYdL6CSF71Yj5mCOAh3Q6eLtNU4P8vdq
         bwE3vBoU4SbIRpF0BEm8+91xsTOSJj4876g+grMQzUVmvWl5obm3D2Vt9qNR3wg7yASs
         qRjUKFKdHThZpIXTt6ABgChifHwtqWGFAFHc7JfLrqJ84rKyjKWaQ71OGn+dWRR/BPKo
         pPqiaSXjlMsUWAXj5ns37QpxcHVbmLWmls5IxlKg3rxYBWFPAURmIXKrOTuNmjiAMyhh
         Yaww==
X-Forwarded-Encrypted: i=1; AJvYcCW6vgr+7DYiF2NmBT+xUE1GHz7XsxKcvR1U/t+9bJaFYoEq5s2n3aC0IGl8wuw0+bjVO3soGpZzMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmP59YGIxiHKJCMxC+9ls5HBQmJymgVKy5uzB8l9+IUVEId03W
	P0o78qOgYDD2sunxroJpLXs0DicBGpp+8AvhSAsWYZjqtQKlyk3G0eLFi80raY8=
X-Gm-Gg: ASbGnctoRZWGeEswn+hqGPfyp2o/FzPOpgY0+dvheL1NtsKy5Em6t7hKqyS+MU9148Z
	e0pdynE7HW3/IkzdbFC9Iw5dp/jWymcA9G2vFCYOlmmau2gb4+HmFjZJhgjsnsYwoCS7YttnQPX
	SqBgm4vjhkSiG00yRrCftu08V23mCB0+RMO96IWLe60J+dbNc4AkqS+a2z0Y8UIfpqnRUd6rK7S
	3xJ9Nj7kfwGJXiUb0aS50Z3Awt9mxtqbx2DGGqNYMA5
X-Google-Smtp-Source: AGHT+IHxAAZ3D0uWncPjOqMAUcGsBGp2f+JTbeiTZtPMweHPAYze11QhDriq1RsA/ElgKqMrIzIOxQ==
X-Received: by 2002:a05:6830:700f:b0:71d:fdce:79eb with SMTP id 46e09a7af769-71dfdce85c3mr4105336a34.30.1733847460244;
        Tue, 10 Dec 2024 08:17:40 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f279324914sm2639115eaf.36.2024.12.10.08.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 08:17:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
 Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241209122357.47838-1-dlemoal@kernel.org>
References: <20241209122357.47838-1-dlemoal@kernel.org>
Subject: Re: [PATCH v3 0/4] Zone write plugging fixes
Message-Id: <173384745884.444526.13752069755945614497.b4-ty@kernel.dk>
Date: Tue, 10 Dec 2024 09:17:38 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 09 Dec 2024 21:23:53 +0900, Damien Le Moal wrote:
> Jens,
> 
> These patches address potential issues with zone write plugging.
> The first 2 patches fix handling of REQ_NOWAIT BIOs as these can be
> "failed" after going through the zone write plugging and changing the
> target zone plug zone write pointer offset.
> 
> [...]

Applied, thanks!

[1/4] block: Use a zone write plug BIO work for REQ_NOWAIT BIOs
      commit: cae005670887cb07ceafc25bb32e221e56286488
[2/4] block: Ignore REQ_NOWAIT for zone reset and zone finish operations
      commit: 5eb3317aa5a2ffe4574ab1a12cf9bc9447ca26c0
[3/4] dm: Fix dm-zoned-reclaim zone write pointer alignment
      commit: b76b840fd93374240b59825f1ab8e2f5c9907acb
[4/4] block: Prevent potential deadlocks in zone write plug error recovery
      commit: fe0418eb9bd69a19a948b297c8de815e05f3cde1

Best regards,
-- 
Jens Axboe



