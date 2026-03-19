Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263F3343216
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 08:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773910113; cv=none; b=cZ8O3lSipWLH6OlhQ5la6ZerYhaYHnKURK9PBAzGrPI+hWVDr+u5OhGILWaCaUD4J/zFxQBUH8r0P2psU+XlQNcMIQsdrsWwsbgV3tcwyCk5xJE5L+zGrYG/iOdBxZCLku5nOfgXy7Pci4gwJtpGWyjoUYzy6OpC/LuokEfvXh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773910113; c=relaxed/simple;
	bh=04drrZazr9pwZk19Edvo1HCnMIqv9Cbt4O1of/HV45Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=c4qx0CP8J3FKv6o2OA5Ulgun8IqPHADYI6/ADfQVqwN/NfeA19cL3VVgk5L9jynoQH4NPiF+P7ivIPkzkOBiqxnw0U6akfZ0wKnekHLWto4ycc1BvOFOV8ZXHgk0fzwlfefTA/wlvrQc0DjBjTGkDYQNcciZ+CRp5Y7aF9YeN3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDotFaTe; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDotFaTe"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4327790c4e9so249166f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 01:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773910110; x=1774514910; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yd/tafXGar8KLjaFL5qqMH0k5OVBqTpW3bKT/2gQAcY=;
        b=TDotFaTejpciP7YKfVYBG1fwwEOpvfOWMxnYI/NJY4vd4yV1NDUueRNWYsA1yPJXd+
         yCBlcIGIQKxDeAh9pnunN1QccAsuLOSs9mCxYEUnNSfm0Ibti4Q4ABgBSHB0ijsYXa92
         K9nGUbFFZsT5yoXiT9KPUdQ+FMXosCNhzHNBvBaak5F+Vz+Zfssxoneo10tuk8RwIfwC
         7VCCarmjoJ7MtBj3YB2oZiP1Vyab/fb9A6ZTsMxeZiSPB6f6JEUJXJOzmv77RF8+1VvV
         yKTmuhNoIHdSBRxGvxS4gA+P0BHP4rxXG0NLgYr6eo1XMd6gmr3GEoyMMKOrfH8nZSwb
         TXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773910110; x=1774514910;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yd/tafXGar8KLjaFL5qqMH0k5OVBqTpW3bKT/2gQAcY=;
        b=Zn5gesNPeWhRsqK13yaxa4u/sS2UTOnC9FLmQEpmc2HdFohOVgs3gYr7+Zpv9vwWjH
         FcxYoukF2idxgPUWmv9qo4Gr019izR7n7TxCPfprCw11pXxJdHX0vKB8VM0Elt0ZkVK4
         fjNJjZ15queSHIGzNplIPhYsTGmA4jMvv5t4Nt2Je98GOP8Eqs61CX8H/KcFTOpnl21L
         AdDTHZm95tcZnhAbKRkvJkvpkkmCkff5GzcDV0i7SnX5a0GzNaX60msNfiiehaYTNyvl
         hPRZgYw5BToX92qLxEuyu0PVQDZQO3VHHAQpo95/btfCpBvm/3uqT1r5Yca0xXRfZjBq
         Xy7w==
X-Forwarded-Encrypted: i=1; AJvYcCXgRwta6epsAYvYNrtmihANWWOEFbkMqV8Vd8dfDMNEzqb+kAMCSLC76L+BKlI2ZeRCSOhGjIPdhg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0EktnpPtkMSt92/N2FkiJhcWv391TdXeiI6LyczCRzqgu1vCQ
	3JxbHqcYXIPds5bfOrO+wD0FHG3BzJWzIm1q4UtxSPOEb+q9woIw1unjaPIdJdAv
X-Gm-Gg: ATEYQzwaVHLg1kbgr6l2KR0oHW7+3nodEvTljDhqauBt2xcwmWVB/4VoSPibzzslby0
	zD8uEoImq6Nq0nkFO3gwVV2ziz9/fmDQwXDyFHHkQyMNEtqGkx5kolePos8GD3EH9MmHBZ3Gtgl
	bNikLyuyPFf0+2TyjP9okNqjqWUemDFWjkvUOc7DB3w4iNJfStOTzK/BAZRVHHtbbdZ/s40Noue
	KYoKsJabDCl7X8FEZUfNRvOWTNpfMszyT6K6vgkeoGIA7FCuF/3LTVhLv/rCTD8mICHPwiCND90
	ZaExqEQLKRJIzl3T91symj8BZi6uKIgeQpXCdpb6JyfWxSBSK7EX7VPETB42TxK9J/31elw0xog
	g8JUtwn0GAUGPbaAlML4WywnkSorV0XsAJW6l45Xe9x2Kg3Zmhi9Qdl2ZBFls/pOK1/nh15iIdK
	A0nmmXqVGsZtXyuRvXrSHVQvLwQ/GB
X-Received: by 2002:a5d:5d13:0:b0:43b:3e40:222d with SMTP id ffacd0b85a97d-43b527a5382mr10940805f8f.19.1773910110188;
        Thu, 19 Mar 2026 01:48:30 -0700 (PDT)
Received: from localhost ([2a01:cb16:3025:e833:3eb9:2e3d:e287:f728])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518a3d78sm15773363f8f.34.2026.03.19.01.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 01:48:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Mar 2026 09:47:47 +0100
Message-Id: <DH6MMYX3TX5Y.R3N3IX6370ED@gmail.com>
Cc: "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>,
 "Benjamin Marzinski" <bmarzins@redhat.com>, <dm-devel@schwermer.no>,
 <chanho.min@lge.com>, <jaeyuel.im@lge.com>, <dm-devel@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
From: "Guillaume Gonnet" <ggonnet.linux@gmail.com>
To: "Peter Korsgaard" <peter@korsgaard.com>, "Mikulas Patocka"
 <mpatocka@redhat.com>
X-Mailer: aerc 0.20.1-8-g985ce7a92be4-dirty
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
 <46a69472-84a8-c02b-1879-af30da13523c@redhat.com>
 <87y0jpf2ar.fsf@dell.be.48ers.dk>
In-Reply-To: <87y0jpf2ar.fsf@dell.be.48ers.dk>

Hello Peter,
Here are my answers to your questions.

> But how does it work?

Ok I will try to give you more clues.

The issue occurs when partitions scanning has not finished yet. That's
my analysis but also the analysis from other people (see links I added
in the PATCH comment).

I will explain two cases: MMC and NVMe devices.

For MMC devices:

  Here is the simplified call stack for partition scan:

  mmc_rescan()  // delayed work
    mmc_add_card()
      device_add()
        driver_probe_device()  // enter "probing" state
          mmc_blk_probe()
            add_disk_fwnode()

  While executing the mmc_blk_probe() function, the device is in probing
  state, ie. probe_count is non-zero. This function first creates the
  disk device then scans partitions with disk_scan_partitions(). Thus,
  waiting for probing to end is enough to fix the issue for MMC devices.

For NVMe devices:

  Here is the simplified call stack for partition scan:

  nvme_scan_work()   // delayed work
    nvme_scan_ns_async()  // via async_schedule_domain()
      nvme_alloc_ns()
        device_add_disk()
          add_disk_fwnode()

  Here, NVMe device isn't in "probing" state but uses the asynchronous
  execution framework. Thus, you also have to synchronize all
  asynchronous function calls to make sure partition scan has finished,
  using async_synchronize_full() function.

That's exactly what wait_for_device_probe() does: it waits for probing to b=
e
done and calls async_synchronize_full(). If you are still not convinced
this does work, look at the wait_for_root() function. You will find these
two actions in the code (probing wait and async_synchronize_full). I
didn't find anyone complaining about this issue with rootwait=3D argument.

> Do we still need the other wait_for_device_probe() call?

Technically, I think it still works without the first call (if you move
the second one out of the if block). But I preferred keeping it for the
following two reaons:

 1. That's what is done in rootwait=3D, which does not have the issue.
    I prefer copying what is working, especially when there is no problem
    keeping the first wait_for_device_probe() call.

 2. Removing it may degrade boot performances for devices that the first
    wait_for_device_probe() actually waits for. In this case, wait is
    made by the while loop with its arbitrary 5ms sleep. When
    wait_for_device_probe() is kept, it only waits for the right
    amount of time and the while loop does not wait at all.

> This looks nontrivial, a comment would be helpful.

I think the commit message contains enough information to understand why
the second wait_for_device_probe() call is required, a comment would
contain less information so I prefer letting the code like that.

Guillaume
