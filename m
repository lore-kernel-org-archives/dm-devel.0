Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E602E7365
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766543; cv=pass; b=DRpt1qPpefcj0gZqg1XMPuZcvBi0rEi7FhVFqfz078++v10sBvjW77w0fNXxYsGtFzG22Z92LvRDS4ga8T3gKtDD+b+21RKWGe5HujqTA5rEDYRMim3XfyhTuAuY7tz9+UO+n6OWhRfn6NQdPrsvb7NSFHqD/G/4cZgrd/jejdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766543; c=relaxed/simple;
	bh=rjo1VW8Sl0qkUPaQwyatnDK19KCCtqGcfXbwHZZGhK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ikJ492tgECpRqCvYpTmB7j2d84yYb53LMzFrfIV76zeHIzbz6KFpgfT8x1cxyTJkTKidoVdM6qRLMQ+LBOk1pPE5o75gshUpXW838kh6+K/UdeNVsLwzGxGvI72e7O0uLCCIyAKBIBRA2zqkGE9lROZyc1Vw9XRgkTBfIBm3d20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=TC0JGL7a; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="TC0JGL7a"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39ca300db70so34350051fa.2
        for <dm-devel@lists.linux.dev>; Mon, 03 Aug 2026 07:15:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785766540; cv=none;
        d=google.com; s=arc-20260327;
        b=bbo/Op80lJRqNi8kAI7RWSNPpLm6WMPJVrT6jV0Hn4oEMY5pSlsySeKlNJoXQnaVtN
         fbOiYfzGssiIoA0AcCehZVYH7up0aLxoyi7CrmmwtZpqhgqb8c/MKUuhnHV1s503iNw0
         XOB4ogtqcIXJgdG7kQbxncS3MgpRDAUVBEOMXNeNG9o32MeYcqwhETWNkEE9LlYz0h2Q
         R6Lbd1XBLDzgvtpsQVD8/oV+cqymK3EsQVdC7Dnv+XXrXMdWgURLTwBx2WAmJvqQPPCk
         vPz/Jzp5xaGGHP0HikBrkkMub5+lpUqymqEquiuD50QnFxHSivmQxyRtckiPW08jp/rx
         K3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MXa/Y7MP23dJyDErrkeG4aruHU4VSyYgwg+VKcWRHt8=;
        fh=2MCJ5b1IHqZf0xQ5hSO8/PdEaXhb676skykr9rkpfK8=;
        b=oyq71kUUNe0Pml+jwOxbU8Zpl5LtGpNw/EobhANKd9GexPbn/P5xMkAC8nKN/dpU56
         qkENdnsG2v6Zr4gElXuGrYdo4MIcf3jdqd1pPmFUIH9zSX6IU6hNSA1u+ri7CUCRbKpP
         yaap3iGs55hbbmQfxGq7Jyfz0o6N9QAJN4KiPb7rSRPdjjv9CeFGDz3u6OufAQD9Q7sl
         iRoabpwxGg8UtTYcDUFPfYBhcfGgbrzgzVpJb1W0syadggajfDun6GNxSYG2CarIP/8h
         BbBkOMuGuzya58h/WduPPxqBQWACYUrS5E4depuOwKccKVhQzAd9K2UAMsBKU2InodJm
         7JZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785766540; x=1786371340; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MXa/Y7MP23dJyDErrkeG4aruHU4VSyYgwg+VKcWRHt8=;
        b=TC0JGL7aE+D3iVhnfwbEVyWnbl3Srwdud78DBu9pNCiD0OLyvupxgqAfne7yDWKsAM
         sL39P/LPHz0vqOb9Njk06R98M/8PADOANf9sw+YVS07slRO7QCwBUb112OMxSfcrZF01
         STMbZ7GhXfVB5X6YEH9H1obQ3Nxp9lUCXqZhXlS0/w2zKPV/KJDq9pQ0pWBof/o6UTJD
         vquUhLKwyTeMHjr9pNCW4vL/zgxRA+UVwrCSAwBmAkn6p1BN2pRCTTjeJxpKteFdVyq2
         gJ2gRuULCCsYPZtnxIOOalRneLt+fKy3o8hJQf4xSa8urvI4UJoLdogYlGbAbUQSVz0v
         fOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785766540; x=1786371340;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXa/Y7MP23dJyDErrkeG4aruHU4VSyYgwg+VKcWRHt8=;
        b=q22Erx3dlqSCKwyfZPgNK/KXL3mKnk0FIzvzEc42zJe3K5/vnSzxdLk2WSAcRAlByf
         hc19vTmeHdCukdR53m6gkw9ZgvUYenUEfbHNg2AgTOYGU/l2CDzkOF81ln7aftJqOp63
         5XmLKTQZnPx9TRHhF5eOe45uG9spqUB2hxkEqzShAOtlb1ePDH+9M7eK0lAwXmmq/99M
         exQX1YpV68ZPwzJStAg0cVTAnXFnxiLFsmOgalEZtolm1L1ae6CZPgTtODGktt4Ia20S
         VtTA2h8GfRL9rzzuTlUkMDB0jDq86p09QhlCOlV6BpbZzwK0zsX+x7jzF+fQE/m2w0Pc
         +JOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNv6wvMepC8S29/HRmvpOdltH0F1qlW01snrwOxa347ZliH8gBPdatySUdGmR0/JFddOzd9nfB3Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YywOumEyErjFd8TUxW6n+4qVG0Y9jiC5B4Z1n+4FqIj0lXjH6um
	lCLRdvD183phXADYdDO07TZNpegIkOsncRWa+roH26+h3Kfd7YYIzuH1Hwb/9u+SMEnFUCx9p40
	X3YslC8XKlJQWS1xkCNEiQb2v8egDezv56eBYeLfnqA==
X-Gm-Gg: AR+sD10HCrmD08JIwhxja2qg7QhuwbJz4NQo9HsOb6ewFmXEBmMVk6BBvSGipeGmAJk
	L9RvvbaAdRFed261n5RKFc9PnqAarrhirJRe3HBoKuKHV1ajuWBcUmHPVwyt+nabH/TQ4keEGPK
	A+VZ/up+GXdfMW7a7VChF4pAqMStsCor/omyZqYdrzfYawdUw6til2X80MFgoKxdbyCnpUET6SY
	5lLF70Lm85KuJRFkyEIYF3R2IAVkXumx7Ph1m1eNpKDhDEz9kLo8JZzaK6tsz71rReO9hH/vATI
	KfSFF/dfnK/Tyk7z8O7F4pzjUxOU1jKCJHEV3J9hIQQ=
X-Received: by 2002:a05:6512:10c3:b0:5b2:907c:e8b1 with SMTP id
 2adb3069b0e04-5b2e4f96dddmr1884741e87.62.1785766539804; Mon, 03 Aug 2026
 07:15:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609002231.1236115.614213f87db6.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
 <amEymCRxwtpZoR-2@redhat.com>
In-Reply-To: <amEymCRxwtpZoR-2@redhat.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Mon, 3 Aug 2026 10:15:27 -0400
X-Gm-Features: AUfX_mz6f9b4eTt9Y1096jHwcGbI76WXcrgk9NWoAEELTkb-7bZqLWuoyBoX9wE
Message-ID: <CAE+C+DZ29iU3i+HrTShnGHNeOtbWjwnSt=t1xu=VLTsLdSuRuQ@mail.gmail.com>
Subject: Re: [PATCH] dm dust: use target-relative sectors in badblock messages
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:14=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Tue, Jun 09, 2026 at 12:23:45AM +0000, Samuel Moelius wrote:
> > dm-dust stores bad blocks in target-relative sectors, but some messages
> > report or compare values in a different coordinate space. A table with =
a
> > non-zero target offset can therefore describe one sector while reportin=
g
> > another.
> >
> > This makes diagnostics misleading and can make scripted validation look
> > at the wrong logical block.
> >
> > Keep the badblock control path in target-relative coordinates when
> > reporting and matching stored bad blocks.
> >
> > Assisted-by: Codex:gpt-5.5-cyber-preview
> > Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
>
> I agree that the block number is misleading to the point of being wrong.
> However I don't think that dm-dust is inconsistent. dust_message()
> checks if the bad block fits in the underlying device size. It doesn't
> check if it fits in the target size. When dust_map() is called, it
> checks for the block relative to the underlying device. So it
> consitently treats the block number as referring to a block on the
> underlying device, not referring to a block relative to the start of the
> dm-dust target. This is weird. It means that dm-dust allows you to mark
> bad blocks that aren't actually part of the dm-dust device, or mark bad
> blocks that aren't aligned with the dm-dust target. That seems wrong,
> and the code setting up max_block_sectors sure makes it look like the
> blocks are supposed to be relative to the target.  The question is, "Do
> existing dm-dust users expect this current behavior?"
> Documentation/admin-guide/device-mapper/dm-dust.rst doesn't mention what
> a bad block is relative to.
>
> Overall, I think that dm-dust is not a heavily used target, and quite
> possibly you are the first person to try using it will a non-zero offset
> on the underlying device, so I think it's probably o.k. to change the
> behavior here to something sensible. But the commit message should be
> clearer that it is changing what a badblock refers to (from a block on
> the underlying device to a block relative to the start of the dm-dust
> target).
>
> Also if you wouldn't mind removing the sector_div() line from
> __dust_map_write(), that would also be a welcome change. thisblock
> already points to the block, and dividing it by sect_per_block again
> just makes __dust_map_write() report the wrong block got removed from
> the badblocklist.

Sorry for the delay. I just sent an updated patch.
