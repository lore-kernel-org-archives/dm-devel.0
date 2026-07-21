Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375C2D839C
	for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649615; cv=none; b=Jxo3onFo+vsC9Wspk7BHFUNoGtIBTR9P3k7w1ceJT3zYPdCsaWwkngNjDpNlLKe3QHqgsG9flGfwj75R1fssH3i6CE6AcQpAJ053h2AxiuFLhf4/ccueAP1org32xaeJA3QnSbXMFQ4TG/ED73ZMCP409LnKxxz63pPWtoSjbGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649615; c=relaxed/simple;
	bh=5IA8IzcSvlHOMJ/YI8Pw/9w5Ruo/stdoPzq4bao58sw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hY6rXKra2vyL6QTRc24wpzUnsyBYjUiU9MPEkDq1C85PIxxZaMwWz6Rh7BTl8GL1DFBmIMOpk3XsWL50d+tZlxQgwCsBcSaa+3kWN6A3H1DdL5zpJk0zKJaOwla7utL1ia+zQ/CKjC6ksp7yK/57ZPw0RwxIYVvftLe5YrTMIpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OKtxrMq1; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OKtxrMq1"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47df43bfb07so3171315f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 21 Jul 2026 09:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784649611; x=1785254411; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=j+Ic8TSbrBl9M4WCD38NLqavxfW6lTRefujkUjz/ZDg=;
        b=OKtxrMq1lRiJ5uxkFFEnaEsokhuVN8btIUboaYEaqtn4DgiBEkJWvWdCp1NcCoeW54
         POQXuCMXsm+8HnqOJ0dD7mDMdoVPccxaeAMOhTYUT/cDtubVIZx36gNYSGeGjVi68vH5
         qxs4HlnT2Yw7d2c0kArfXD4vBMkIuejWoNIAQzhYKTB4cnwGSx2zM7tHyussPvGHxuos
         WgMZeZusQHo/s7IA38goY9tXBPeqmOhcDgMFEM9d3vE1urSqKGTVx3AZfZ5UYoxxvcpq
         2j0HzbL2fMoKfTDlt39Gp/SZua0b5F5B31UL840Kxqi1gg1pZhRKgN8KlzRfVOOpf8Kq
         lIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784649611; x=1785254411;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j+Ic8TSbrBl9M4WCD38NLqavxfW6lTRefujkUjz/ZDg=;
        b=ZRzW724Z6mH5wCr904xcBGEUCZVRkFg5WyAwKjOcBnkACMAM89kAVxJzXllj5UTHfg
         xVXuSJwiIOh7triZ3q3AXRg+gMGKBpEMVdaxbdtAqOZYvljJRptBi613P2rXZ4UHhBDW
         YqW+QDuVpjom3YtxCf4wIQmwzU6bkcWh1XY12wIGrJNe5MN8yv+nKUyhauvoqDBlLlwH
         h4dhRdhn2bdS+NvBe/t55KYSvjdFjPh5stvE2FMpOegekJyXud3l3yJZd5OwmYZxbxKI
         6GhL3t3KMrSwJv42FOF2xnje7KrebiuNq0kb/JJEI0SmWJZXLRqA+bbTMPpo8D3d05HI
         0F9A==
X-Forwarded-Encrypted: i=1; AHgh+Ror6CrOpb689Y2RJtwHK4fGzVRmP4R18Ky0gvu80JeyO4vowGYa6HUCVm0VUSCcAhm1h3CBu1ulSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxInsz8zQQv8bRzsdbbNxVLrK0O1bPmj8qsYJ23I+mTOAapxXMx
	vYNMX+qCsuHdhfE71z9eL0lC8/brdEfNItngntoTUn0jL8QZdfUrxXX+YlSrXPXM2OA=
X-Gm-Gg: AR+sD12V61LKRVsQOsxSZ86oFCeUtevVzUYPWCG+jt4KtyGOk3GJq49c0OrGZkkXQU5
	GGxLQc0Mz0p6XjSEp5xsDBdW++HhsP/b90EyIWILQyL7QReF1eMJJxVBogK84mhLBOrFvhxvSRM
	2KvY4FKDP2fbcDwww6MNj9Dt2LqhrKCHsooeoU7qBI9RcTR1aQ+f9xfEHB+tDhZIGjYZ5u6FFXM
	gAdF65GkUg76vQHFgm6K2NuFolVTAI2VK0iZRrqTpayLmZLLDOkM39vQINF2/hXuA7xzPa4MhSj
	SDtRmaHVMPJt8M4eamqB+Sul1tGpH9EqFFwmoAmyyc8GKVI0X9IJuj6tt4zKjoAsNhzsDWSIMEb
	K3qwlPBRixVUnghvQTPk9Uaabyl9jUQCdfwonI+mQVQGrQGZ4Wj5w7opAzekumN/noiNV1zxqkp
	Kgn75wdCNBJEYute3zOekrqFMw/FNEQ4uGaDB8za8KPNLG/QmGAxUDJO0jYKv8ceWl3XqWSBk/+
	iM6jst1pTdOtfb7OH8/iICsOzUGWZE1ydGIzkge
X-Received: by 2002:a5d:64e3:0:b0:47f:70f3:451d with SMTP id ffacd0b85a97d-47f70f3455cmr15117529f8f.8.1784649611425;
        Tue, 21 Jul 2026 09:00:11 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ed1911sm42902962f8f.22.2026.07.21.09.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 09:00:11 -0700 (PDT)
Message-ID: <8a35db0f1f174ecd0db863da5f3481c46d15041b.camel@suse.com>
Subject: Re: [PATCH] libmpathpersist: fix self-preemption when key has no
 active reservation
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>, Cykang <cykang4830@gmail.com>
Date: Tue, 21 Jul 2026 18:00:10 +0200
In-Reply-To: <al-QxPjUZVgUdvjI@redhat.com>
References: <20260720215200.2464152-1-bmarzins@redhat.com>
	 <7ff8a06cebaeea6d49c27044be2b3e4c66b9eda1.camel@suse.com>
	 <al-QxPjUZVgUdvjI@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2026-07-21 at 11:31 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 21, 2026 at 09:43:44AM +0200, Martin Wilck wrote:
> >=20
> > key and sa_key are just parameters entered by the caller. How do
> > you
> > know, without calling check_holding_reservation(), whether or not
> > we
> > currently hold a reservation?
>=20
> In the "if" statement for this "else", we call
> reservation_key_matches(), so we know that nobody is holding a
> reservation with "sa_key". Well... no, actually we don't.

My bad, I should have re-read the function reservation_key_matches().

> reservation_key_matches() could return YNU_UNDEF. In that case who
> knows
> what's going on with the reservation. Perhaps in that case, we check
> if
> we need to do any self preemption (sa_key equals 0 or key). If so, we
> just fail, since a failure seems better than silently doing the wrong
> thing (either re-registering when we're not supposed to, or not
> re-registering when we are supposed to). The most likely reason why
> reservation_key_matches() returns YNU_UNDEF is that there are no
> usable
> paths, so we would fail sending the PREEMPT command anyways.
>=20
> If we don't need to do any self-preemption work, we might as well
> attempt to send the command, since it can't hurt.=C2=A0

It's quite likely to fail if the PRIN command failed beforehand.

> But I'm open to being
> convinced that the correct answer is just to always fail if
> reservation_key_matches() returns YNU_UNDEF, on the grounds that this
> code is complex enough without adding yet another special case
> workaround, that is itself likely to fail, since the paths are likely
> all down.

I agree.=C2=A0

If this was just a single path and the path was down, the command would
fail, and nothing would happen on the storage side.  So this is what we
should do here. There's a minimal chance that the PROUT would succeed
even after the PRIN had failed, but in that case we wouldn't know what
to do with our registered keys, as you described correctly.

So we should just fail.

Regards
Martin
