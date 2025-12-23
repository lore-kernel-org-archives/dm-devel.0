Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024B2DF707
	for <dm-devel@lists.linux.dev>; Tue, 23 Dec 2025 05:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766467808; cv=none; b=rRuSEAgrMpXISQ8Mq2zMeZLFHqkvL9TNC3GvmSyGyhGFdVeKwyw5zOSftSHitdywXTybWValeFlSgc3ZiMJ4eogD+YOgev9axAhfW3zASSnEq9YntlWhhFKHYoDgnIi4pKl/vMvf3xZZ51AKeX7ap3s3emoenoJFLT1lH7yaMVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766467808; c=relaxed/simple;
	bh=LeHgaTCg3sZgaNtwPEbjvh+7JlJOUXsNXjaOCgEgLN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G53605u6J6atp9FjhpdhoeMUqQBAnw+mdp3RBo7zqlMIypjkRIcTv8k8Wy+SYES2WL7GderHq8++SnydmEzcI7ZDMhHM8OvYSHuBmmWo9XV1JaxTSx0FfMbFeKiAa26kKLPd/R+q5lU9DSXfIbbnVs71blhlfPaRVT3JWcu9mkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XCMiUbuG; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XCMiUbuG"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5943d20f352so5093865e87.0
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 21:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766467804; x=1767072604; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjrVs5qAijx5UEiplGDR4bSOktnBgAEK/U0XoVs0/GM=;
        b=XCMiUbuGoig+6ARL14x6zTOkC2vTVaIKR4of892zwJU3py5CQ89QSzezCw+Mlin9Kz
         k9exm0eiosfnwXwg7a2cTLB3Djsa3klvPmct/vi+U0ylKR5BiQGC95ZQNNy7MvnotSMX
         QeByiLCOo6dc1zYRJnZQJusObAQPbNtkU2ivB2FTQ5PSMGuvvmuBQpXHUxGaIzIt1tNE
         NXuyHDaacGTQiAFNoMJG7IshbJ//iusJonl7P7nR9boCI5W0v3wrSYCZzqlYJdmxnrRC
         WwXXYIXEC9ffAyE7pJaBXMsbZITJ2j32C2T87v+goexhpFsiMWth9uEirUg0JLsXqMFi
         w4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766467804; x=1767072604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CjrVs5qAijx5UEiplGDR4bSOktnBgAEK/U0XoVs0/GM=;
        b=kkwu8WfcUdBcv91xrZOwbgSDEuaELrTA9uneBnDVogdit9JmvHugGruO3XVts9oE/f
         Vd63blozIpa//Jrmoy6VeqPCUrENEvteYV0uudMFb0yhGBwst5cfmeubp0YblXZyUdEQ
         x2iSx34YSP0Ep2MLIWx1PPJQMRNpwk6rdhPOvPXRFyp2pMuTYMFTqxO4pShfaOtpsNyu
         Dd7yQdd4u6fsFdO91CxZUahamPaQUd2UG609ELdBUwt9fWuY8qDbIJcQ/UhCEpC9Ntl4
         DfWOxTnePV2Sg8iuMRO6+hx3pCUIF7aWo1s8KD6Jl51Fo97Fh1+y8a4s43GvIT2dJ/Sl
         8mJw==
X-Forwarded-Encrypted: i=1; AJvYcCVnhAPNrNsRMlMUF65dWBfMUa5FUlk0JlFzhVZMACSPZIcBUi3Lo4pjJHeo6ZzAj370jlBU//8teg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy32QtqRhITQ4Hrmffq6LXeU8fpdgO1j5Jii6I2Wo5U/Gc0R4dp
	L4oww6etY6dUV1I5bXl3AkAyM9FxpTHY46cOKsBLEapPdAkIwp3szD/+
X-Gm-Gg: AY/fxX7jBP7kttryB2l9QoP/rQFPnaXaorI5xvjNfbovQWtsraDknPrdDbSmQ53sg/p
	uKtPHp471k4fo91ac0busfux9mnRJ2PsHv1Xt62yM6TydXHpxLqADqQWBoLqd5OaPe43RWR7YFU
	6ic4PjiptEcc8AQrOkE2xtNBLyXrsFsuAJTyhGoQq8deFEgpCfopJRhPbt86lF19aPFp9BlUrGt
	TTycL6nHdMGRRNgAIXvixycKFPSPzEsSO74gf7/Mq2pm5aZJR0J2FPiGaX1/j/FjhGGE1BoWjlX
	2PXsx9KhtQlLfwO6DiJKa/SRXZI3lXlk+Ri2rBhxmwBDpI4UYrMMtcFVBv1SY8vzJJGFKoty/NS
	KJx5I9lYrfmg7Tn37wSP059jg8NQ1/BlBCV9ACkKyHMnHTFBcWRLYVzOx1oMvnfEwczOaHOC4ZF
	krubQXZMbp
X-Google-Smtp-Source: AGHT+IFBJ4czf5dy7NoHG6Z5fLR0sF8QwzLoI7Shb3fIF5XKnuFbQtFm8MSKsqZe2birAQ3bGk4BUg==
X-Received: by 2002:a05:6512:3a85:b0:598:8f90:eff5 with SMTP id 2adb3069b0e04-59a17df6969mr4474213e87.53.1766467803957;
        Mon, 22 Dec 2025 21:30:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-59a18618ce8sm3818747e87.54.2025.12.22.21.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:30:02 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 08:29:52 +0300
Message-ID: <20251223052952.2623971-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

I used journal mode so far, but, as well as I understand, direct mode is
okay for my use case.

Okay, I spent some time carefully reading dm-integrity source code.

I have read v6.12.48, because this is kernel I use.

And I conclude that dm-integrity code never allocate (not even from mempool)...
...in main code paths (as opposed to initialization code paths)...
...in direct ('D') mode...
...if I/O doesn't fail and checksums match.

(As I said in previous letter, mempools are bad, too, as well as I understand.)

I found exactly one place, where we seem to allocate in main code path:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1789
(i. e. these two kmalloc's).

But I think this okay, because:
- we pass GFP_NOIO, so, as well as I understand, this should not lead to
recursion
- we pass __GFP_NORETRY, so, as well as I understand, we will not block in
this kmalloc for too much time
- we gracefully handle possible failure

Other strange place I found is this:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1704 .

But I think this is okay, because:
- integrity_recheck is only ever called from here:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1857
- that integrity_recheck call is only ever happens if dm_integrity_rw_tag failed
- as well as I understand, dm_integrity_rw_tag can only fail if we got actual
I/O error or checksum mismatch

So, this mempool_alloc call is okay for my use case.

So: in 'D' mode everything should be okay for my use case.

Another note: I used very stupid way to search functions, which allocate:
if function has "alloc" in its name, then I consider it allocating. :)

And final note: there is an elephant in a room: bufio.

As well as I understand, when pages are swapped in my use case, they first
will get to dm-integrity bufio cache, and only after that, they will
actually hit disk.

This, of course, defeats whole purpose of swap.

And possibly can lead to deadlocks.

Is there a way to disable bufio?

Or maybe bufio is used for checksums and metadata only?

-- 
Askar Safin
