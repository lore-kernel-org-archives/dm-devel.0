Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605013093AE
	for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 20:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763412816; cv=none; b=eawzyq8hD81TSCPzG0xth8DmzGYSIi1fvzIw/7iWatwImBT62A5TD8TEYjAZfvqi0s6dzra6AnifjMM/1Yi95/JqTH2lr/yY3ZxkChg4F+tb8qP2wnvjl1o5Aqv2AsM53RL+KenRPsWh5ClADkOCg8k1bIgOdvaoXVRf6VLDAwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763412816; c=relaxed/simple;
	bh=l809oBG5mQYDMyVhjlDcpwfxbwo2RhRDxHgp7AJ5AyQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZzLhFoH9UcIDTPhKhctbF6ipw21r427PTgbKLzykPKZFBJjoG0YBAyb60cxE9pDDNkPOBgZT4St9oVgL4bHfOWp4ozz9YmYMLasUaFP7pFF7HqPRiUNx0en8w7nEDMvEX3q5Wcg8s5ezxlXNvRfIjkDtYScy/K/UuGmkOlL/CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8G8JJZ2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8G8JJZ2"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2980343d9d1so9375ad.1
        for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 12:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763412815; x=1764017615; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l809oBG5mQYDMyVhjlDcpwfxbwo2RhRDxHgp7AJ5AyQ=;
        b=N8G8JJZ2gWm+En7kQPgLnjfF+gf4UuguBTe1dGcgifWNY09814b/BpwEt5giaNVu8k
         l0FO3xm6VvNXN8pvKfrcusVRcQshLiqpLufL03ie2obrgasfH+DWp9caglqikadvouv2
         4+fsI53wdrMWPiyaEo3cCDU4pGM3SmP42FM6Q5C8Q7dgdGqAf4NHGUP9Mbc584ANpefX
         on7g5MJNoGvitLNgMcKCOJJ7vpGXRI/+XGVZ0dgninflmVbxWv0wcm2uWNIjpG/sK/sr
         z7awz4s65CBtfu7p+WHSlHhCcNA9bFaSlaBXYma4lPE/UvOoqRzMwIRp3/oaazNsxRei
         vGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763412815; x=1764017615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l809oBG5mQYDMyVhjlDcpwfxbwo2RhRDxHgp7AJ5AyQ=;
        b=aV0yOm5USWooneTF6KLa7ArPUlA9rA/G9RqVACyYQKlm2I+Ki3Mzre2muxZd8FwVJt
         SQDGtuh2pUi1HfShDg5DXnbx1KOSf4sfD1fuNvXM4zVlmBES5ma54OrXEtrD8J1SbCa0
         n2WuBEGtBQ6x0HINW56q2Uan/pVBnxPXCCkxByrtLiATKza0EIJOdmfziLSLeemGrla+
         NirDNHlvkHNUEcF5iMk/ePnP+EEWSfQk/A1PF4/cyIm3p8r2k3/dFFRfhWtPb0UD45Pz
         5ag7A+N7oo/KJeAmuoOK6dRZXkJ3dIrEBNrFOAZxFhvnt+2dxqYafPPGOJccXXTuq6Oc
         Dv9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV4lbonJPy8YJ4zDuJdNpCggX28PD7QeXDDRskifWK3Tw6tfxyfHP1WsdOxG+c+GUQeQ8rMCppm3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNB2KpbmleCRMAzViu/sxOOfd+u/atqYgvpyz8kq8AIv/hu9Yy
	2YBcFNLI0f5qmT/X7uA1O/zPYfJk3KUC3oKIB/KAtokN5mHbvhfdBYl9PJbi4p/uy4yaKuO69nS
	RHpjCLT+atN4OCZkKDX6r8gdf6aovGjvxKqm2rS26
X-Gm-Gg: ASbGncvvYfnEY0GOfuR5BG3LGYeTcqxLAmYojER0bKlh+W1k7v5aXjvth80SOF3nEri
	7dU9yzqeiyRPX/2JfvCt8VZAnLBvPgjHd3wiZNBEo0bFSaSkU11XMxWYiLVs79dk2U8x9Cn5TDa
	4IUUShQfvnEDmPw2z1M8y8ni3NGIMEsB6xxkVzJsy5kHmuLkLQbwvqB+lkxYNJLVD17Gnjpv8rf
	isEvl7ZE27IHSDamiPPlGlFxYGn4a9emz9jk0vWZGV9AYPkIcIIhIGPRE9vdh+YZoBoADgNoQNh
	xGU=
X-Google-Smtp-Source: AGHT+IGd89d9r2C7LyZGmpiBeJYOBCyZ6Rup9J4+WEvwGpqEFC0Aq6RUWWQLXJYU8QwpBv5v7mRymz1JPpz6m/t04a8=
X-Received: by 2002:a05:7022:6b8b:b0:119:e56b:c1d9 with SMTP id
 a92af1059eb24-11c766bab92mr22330c88.4.1763412814221; Mon, 17 Nov 2025
 12:53:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com>
In-Reply-To: <75ef45cb-4c00-4b27-87cd-3c2914f5dbcc@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 17 Nov 2025 12:52:57 -0800
X-Gm-Features: AWmQ_bl7UGdFPytPbPup-TaWyJPN2qNOlIruor8H-VJToEg1fiuqkL9AVdLke04
Message-ID: <CABCJKuf=8svp8WbE7SOKJhFaWh_8iCXYc41tgu_1po7_AVz0qQ@mail.gmail.com>
Subject: Re: [RFC PATCH] dm-verity: disable recursive forward error correction
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
	Guangwu Zhang <guazhang@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
	Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Fri, Nov 14, 2025 at 7:54=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> What do you think about this patch?
>
> There are two problems with the recursive correction:
>
> 1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
> has 253 iterations. For each iteration, we may call verity_hash_for_block
> recursively. There is a limit of 4 nested recursions - that means that
> there may be at most 253^4 (4 billion) iterations. Red Hat QE team
> actually created an image that that pushes dm-verity to this limit - and
> this image just makes the udev-worker process get stuck in the 'D' state.
>
> 2. It probably doesn't work. In fec_read_bufs we store data into the
> variable "fio->bufs", but fio bufs is shared between recursive
> invocations, if "verity_hash_for_block" invoked correction recursively, i=
t
> would overwrite partially filled fio->bufs.
>
> So, I'm suggesting to remove recursive correction at all. This patch
> passed the cryptsetup testsuite. Does it pass your tests too?
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Guangwu Zhang <guazhang@redhat.com>

This looks reasonable to me. I only remember seeing recursive error
correction trigger in a real system when someone attempts to use the
wrong root hash, which is obviously not recoverable.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
