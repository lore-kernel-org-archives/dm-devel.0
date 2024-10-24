Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAEB482EB
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738341; cv=none; b=V4foVkooVZfXX4pHWrxBx8U1i9f+PNQ9ERoxEQIhY0RQrxnja5h1X/adNgt/KashXwASSwVCyPtc4LgTfpzs/IeOSxIfYY3t8P12aBf89kMJuxIOYGanH5Gga3T2rdBW1VrHNb5PKyvwime4++Cobv4Y7+8Qua0PZL2jJzMzwFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738341; c=relaxed/simple;
	bh=e63VNaMSa5J1MM9PfLmc6REGdLxKMyEsmvWlF5WdUQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DPfOcmSTI/QTec/Nsy1nDnLbgJinps/Ku+oxT79zDIfWcYRr/OcDXUGs5DhXXYmYc8Ou4+IZNNXHS7TOznSpU8gus66nj4zXxvZhpW/Ysvg6a+Y5mwtzXgH2ZtNBCZ1lXSL2oo87EKjuwiG0xZMhpXOog+mOZmB//V4Jll88bfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E8y3LDKe; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8y3LDKe"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6e35fb3792eso4100167b3.3
        for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 19:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729738338; x=1730343138; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYASeKGsrTpRCjUsk5sbA5D7FM/sG/Zf4Yorg4QsRoE=;
        b=E8y3LDKex0kzs1jMwnofNRHJDPQuYkxgTPYUmC/WcxQD7VLhXvX78QHmGFOc8b+BT1
         xEy9063Hl2gSXCXQxAn9bHCGtl1KoU/kzvc9whkHMReZgslc6Bk84fsNH2GcmLz4AH+w
         locT6NJo4UbJPwfeeN+bSBhzs9+tnn9c/kq0AlydGSSwlS1k+EF/ka57M9GDV7V0u2Tv
         KNJtaPM+WlCLAeRl+jYL+bMVbEOSbvtq9X7n/VVrytPq9IDgRfcQMfXM06gsvlCInSpu
         ehjAyoqpSArZKNToVzkJpdUDgkCsg4Xetflt80iD5TdTdt7L+Gj6Mm4kZHHhiyPQ5Vy0
         AmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729738338; x=1730343138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rYASeKGsrTpRCjUsk5sbA5D7FM/sG/Zf4Yorg4QsRoE=;
        b=AEcx4Q8zjJG4+4nJ1UKVhPasP/TRMNEuKGXlYeql9Q1DMbuDs+TP6QE6X/OW2odKnX
         QDsByOX9zqW6J9MeJ1fKdT5MbFPEh/b8z5260VkzClX+KYcchj61mUXVjrUw+lzbJHQn
         z//M8xIG873rnELUOcgevZ4+sMn4S8HomScs+k/ed5U/42NlRTbsr3AxSKg7bcbkWgXq
         luQqRychpHzzmmLO6QL1HgNaYqWUQqzLnWWyvD7Yb6Fkr5hso534TogE+MOtuKYXfAWn
         pTuNa3pCc6jJXXsLWbBsNh0YZ5WWmIQlQT9OZgjVwJfHGp8VJdk1HRIpbcY2UptCkn5b
         vrNw==
X-Forwarded-Encrypted: i=1; AJvYcCVz5ydS5ZcpViHHQUp7pscR708GojO9mSISWZ+2BJwi1fC0Lhkgc2P9t/heSwE0ECje5awyGNWKIg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl9xya1f1dcKPNUEaTFtvs1TNOvt4qQj+9tzxq+YeX9bhHavka
	BMZ8bSzmlbEX94mX9bPwxVo2pP2boyz+IBTMCgUW26lFD4Bzwtr+g4jCnYC+dQIYA/gEDhRanEN
	cgtzCzuTIO5/byHsmiX32/gVvP48=
X-Google-Smtp-Source: AGHT+IEDx8M9M5NfSQJM7sAyVqEx9xZRtt9pauz51dGR+BiVqQQoapvIb1oapCtzf34De00rMCmJwCTHDkr7sJLMo74=
X-Received: by 2002:a05:690c:f10:b0:6e3:1259:7ef2 with SMTP id
 00721157ae682-6e7f0df5ce6mr55492627b3.3.1729738337910; Wed, 23 Oct 2024
 19:52:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240916085741.1636554-1-quic_mdalam@quicinc.com>
 <20240916085741.1636554-2-quic_mdalam@quicinc.com> <20240921185519.GA2187@quark.localdomain>
 <ZvJt9ceeL18XKrTc@infradead.org> <ef3c9a17-79f3-4937-965e-52e2b9e66ac2@gmail.com>
 <ZxHwgsm2iP2Z_3at@infradead.org> <CAAdYy_mVy3uXPqWbjPzK_i8w7Okq73wKBQyc95TbnonE36rPgQ@mail.gmail.com>
 <ZxH4lnkQNhTP5fe6@infradead.org> <D96294E2-F17A-4E58-90FB-1D17747048E5@gmail.com>
 <ZxieZPlH-S9pakYW@infradead.org>
In-Reply-To: <ZxieZPlH-S9pakYW@infradead.org>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Wed, 23 Oct 2024 22:52:06 -0400
Message-ID: <CAAdYy_ms=VmvxZy9QiMkwcNk21a2kVy73c8-NxUh4dNJuLefCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dm-inlinecrypt: Add inline encryption support
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Md Sadre Alam <quic_mdalam@quicinc.com>, axboe@kernel.dk, 
	song@kernel.org, yukuai3@huawei.com, agk@redhat.com, snitzer@kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, adrian.hunter@intel.com, quic_asutoshd@quicinc.com, 
	ritesh.list@gmail.com, ulf.hansson@linaro.org, andersson@kernel.org, 
	konradybcio@kernel.org, kees@kernel.org, gustavoars@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, quic_srichara@quicinc.com, 
	quic_varada@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2024 at 2:57=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Oct 18, 2024 at 11:03:50AM -0400, Adrian Vovk wrote:
> > Sure, but then this way you're encrypting each partition twice. Once by=
 the dm-crypt inside of the partition, and again by the dm-crypt that's und=
er the partition table. This double encryption is ruinous for performance, =
so it's just not a feasible solution and thus people don't do this. Would b=
e nice if we had the flexibility though.
>
> Why do you assume the encryption would happen twice?

I'm not assuming. That's the behavior of dm-crypt without passthrough.
It just encrypts everything that moves through it. If I stack two
layers of dm-crypt on top of each other my data is encrypted twice.

> > >Because you are now bypassing encryption for certainl LBA ranges in
> > >the file system based on hints/flags for something sitting way above
> > >in the stack.
> > >
> >
> > Well the data is still encrypted. It's just encrypted with a different =
key. If the attacker has a FDE dump of the disk, the data is still just as =
inaccessible to them.
>
> No one knows that it actually is encryped.  The lower layer just knows
> the skip encryption flag was set, but it has zero assurance data
> actually was encrypted.

I think it makes sense to require that the data is actually encrypted
whenever the flag is set. Of course there's no way to enforce that
programmatically, but code that sets the flag without making sure the
data gets encrypted some other way wouldn't pass review.

Alternatively, if I recall correctly it should be possible to just
check if the bio has an attached encryption context. If it has one,
then just pass-through. If it doesn't, then attach your own. No flag
required this way, and dm-default-key would only add encryption iff
the data isn't already encrypted.

Would either of those solutions be acceptable?

Best,
Adrian
