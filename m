Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF26402436
	for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786543457; cv=pass; b=q1aj+JZYpzCQN5oJT91quBx0Xyv+2t402R1rT4vi4xtsD+q8SZooFY2kgIb3L6d5dx333t7mcIByh6Agag7MtoKPhZIKVeN5WnvUfubaB5b2I1EV8C3OMU8UlhgzGxdpeED/4TgLf58emIABk/JCyzLYl5u7bffTfUtSWMYa4sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786543457; c=relaxed/simple;
	bh=uNGk7ZxjYHhTmNWwWlqCan9dAmpT5eiXVdRxHE2MTng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ErAAZamCv6GZDUs1+/KsPkrAqDaFgQLiU4ken2pDhj4zhukXrvN1V1u9ls0EkzZsMvrd+XiVipmnlTq74tf3nHAWYtI1RZ7mw01/sHo/UBagpM7RautHra3RRrb5O7YUl7CgYfi3XtqUv0VZ+wvaV8oztnARoyUP69UZpTSIdaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cristianrodriguez.net; spf=pass smtp.mailfrom=cristianrodriguez.net; dkim=pass (1024-bit key) header.d=cristianrodriguez.net header.i=@cristianrodriguez.net header.b=bvCQeKjP; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cristianrodriguez.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cristianrodriguez.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cristianrodriguez.net header.i=@cristianrodriguez.net header.b="bvCQeKjP"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-527e352a167so4761301cf.1
        for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 07:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786543454; cv=none;
        d=google.com; s=arc-20260327;
        b=FnN4l69+Evc/k/oMwbSI0AX4JfxdoMJxPJen1AYi99ffMATQSSr0B0BU94JlI7rrjw
         w+kuCOa+cKeRqVHD+IyaD+1qHRoyU+p+Qfh4W1fuYE/R4qXA/e1KY1M9yqd8wQN+xsNX
         3YmhwW81DklO64M97C9tkrdBSKcmxHIsHWajCT+K61OBLSvBGmPyJL7yfCbWikLP+VoY
         IhmB7r2DRjcea78LmuYYjvMwhn4XbmKvryvyV5tueo8Mzc8FOXiApVzcgAKy8a5MWlJq
         nKYQG01j5/nMcpd4c0ladpnU/LS8aPn0Le69Rf3Ox7aye49+lEN6zCQWc40tDuGJ5ZHZ
         ANIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h7Xm3XXzfEZW9ea1AxF6nJF1SjRbOJ6ykOf9v2DhZdw=;
        fh=eg/oXZ5tK3m62/FoLhxC9TtJbLn8WlwGKq6TDAaSqXM=;
        b=oFAGziOhmZi2UgDx2lJ3OUxgKMW+8I8vqoQFyXDD2jgNAYwjOGcHNtSldEipDhrmX0
         xmaY/fXR8A4avjxe7cT/NzVH0OFHJmeYyaCBzBrJgrOdwzoIArtDaR2jd6FIwOjdduJ1
         ptFgrt1xwMzdd/BUeo+PMp4qdbGPUZJF3ICfiBDqZQ5VrZk3F+fDF1ANIHRcSc5r2rNP
         BPssTK37Na8MKggdTMJbAMyCAjs/fk/slTFB2iUUC1fi1orZ1xHPG6YAQzKxLj9QZLkT
         UZXACyAgHoHMFrW2iYUCzoyg73d7hYDEDO5oYGWOyMjMUjO2CjZJ/2d92qS/Sl5eFAK7
         LObw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cristianrodriguez.net; s=google; t=1786543454; x=1787148254; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h7Xm3XXzfEZW9ea1AxF6nJF1SjRbOJ6ykOf9v2DhZdw=;
        b=bvCQeKjPCG+zUp2eLfTsPlqp35cEhGxm5OxWhlcMv7eoBhhVddw0dBQSdzknEWZ919
         XOi2crJMZ7/TW6vOT+zCwul5sQ4tCzfaYiCKx4NVf8vxUgqXY218N3UVz8AvBBTAVIBS
         szlhJ+IsmHcVVRDupeRzMKzaOIU0HolAEro1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543454; x=1787148254;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h7Xm3XXzfEZW9ea1AxF6nJF1SjRbOJ6ykOf9v2DhZdw=;
        b=tFdwrxgnlUwyvkHn0kkp2y5EW9qnlpqYXVW1c32ZlkFV+TsKT6Cm+EAiMdiLrC+c+G
         NCRRdihSR1fOgBdz2eLvsD7ifhoGvaY+1iqtd7bPCAvLJhMTeA8gJ1TFdRLZV222gLcI
         /9SgWqkILRFtX8inRegirKRHHbmbMHPHgAMPVyyQIxjTXVWwAqZP9ahriugu58JbwP8t
         RWrVDfa1g3zSIhartl+U/jor9IsNYMLaSW5zIfg/d7oYQYoLoG5LU2M0xcO03IVcvKCn
         jclibQiTcOSgtjXQOnPixMxPxFJ9NaRZbpKdKk5Ak9AB6eoLhGHlGQU3D9sM0Mf+8FRC
         /E6Q==
X-Forwarded-Encrypted: i=1; AHgh+RouuQHEh+MYdHj5QoD38E4dH+jpEMfVjJ9foygOEuCXBzql70fykno6rhUCmTjEd9O7rUY1E5rGyw==@lists.linux.dev
X-Gm-Message-State: AOJu0YytaOyOrFruUPpegWn8f7M2NACRRR7/6ivjipH9rgMEOG7NgwDx
	qwHfWgswgnE2HceXDs+KfVNAZN7t/a+HTPLDHOnITdw0jpfI1r3Qag0wOVEFIQzROrCATPmTMSC
	HB10qqDJnI4vfLEnqRPgm1jYhf72ZoA8JgqUhMTg7
X-Gm-Gg: AR+sD11axcNPrSd7pjIphS4SEGn9e2GhCX2clvPUExgooXOBeET5Y5ZgKGDg+X7U7tN
	PqUWqg3ryG1ypFSURHzayqsO//nEAwwg8/XExnShzHum5kLppN/8eJmGJbeCn2tqUp5CY4lVU4N
	QX3EwfBWMpVmQye5PfO6s+4uLkyZbbfAR77AtJPPX1tx6jdAu8IwdfIiab46OrTi6OUYMhMPIFl
	bkjlnP+D6cXWiTkYBPl70pVzd8wDYOfpaPJMUuW+bh1eKJGWFl78uATzW6IP6oiF3nCcoPt8Yl2
	lkNDV7UWcypE2cW+bQkNjQd2DWmu5YQU+uWXYwg8/mTB4A==
X-Received: by 2002:ac8:7f47:0:b0:516:dbf6:f8e7 with SMTP id
 d75a77b69052e-52d646fa46bmr43103151cf.17.1786543453135; Wed, 12 Aug 2026
 07:04:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
In-Reply-To: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
From: Cristian Rodriguez <yo@cristianrodriguez.net>
Date: Wed, 12 Aug 2026 10:04:02 -0400
X-Gm-Features: AUfX_mwxoUWca62H68cGuU8zgJDtcYt9PMAEvMLHLzW6jn4_gipRFc0vEVc8sIA
Message-ID: <CAPBLoAdgefcQ=otsy4GMsCCAgzY=7E1bDBtZsKMFy+Af0nPVfQ@mail.gmail.com>
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>, 
	Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

c

On Fri, Apr 19, 2024 at 10:08=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> Hi
>
> As a part of LVM2, we are developing the libdevmapper library. The librar=
y
> may be used to load cryptographic keys to the kernel, so it avoids leakin=
g
> the data to kernel memory and to the swap partition.
>
> After the use of cryptographic data, the libdevmapper library clears them
> with memset and frees them afterwards. It executes __asm__ volatile("" ::=
:
> "memory") to thwart some compiler optimization regarding writing to
> to-be-freed memory.
>
> We have a test "dmsecuretest.sh" that loads cryptographic keys into the
> kernel, dumps a core, the core file is analyzed and if it contains the
> key, the test fails.
>
> This test fails on AMD Zen 4 - the reason for the failure is that the
> "memcpy" function uses ZMM registers for data copying. When memcpy exits,
> the encryption key is present in the ZMM registers and the key remains
> there even after both source and destination buffers of memcpy were
> cleared.

Isn't this what  -fzero-call-used-regs thing is all about? can-t you
just apply the same technique in the memcpy implementation and zero
them out on return?
vector registers are volatile after all.
