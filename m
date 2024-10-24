Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33819156F20
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 03:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739853; cv=none; b=hjL+cL4w3fqumVPeZEHrF82+U7PSzBGKDcigXFobp3wk1jgS/BMjWFF9kN9MVWqIs/CrLJ/C5QJ9Sy0ge3imSZbZ/Op6SYpH1pEdzI6miKyknDnVrW3z0lYp5dlDIu1J8f+AnsU+AGOnbyDfnLJUjtWMgyKJDg97jHK9Qm4VZC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739853; c=relaxed/simple;
	bh=6EkibdRfD0hNLJmrqUMgqeBGkxUubBTZYbGiT9el38Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2394KYDppmujjfjjVz+U2fVRZJPWC7pZq8qKSlLmmrsvrNGB6p8ZlYp4NI/mOZk8Cp4qubtWRIdeEmSHgvW3MfW+my5pNLTbOG3md7lN6gIwVcD95RYFmiYf/eLVMi2jvTOb1138K5oYNBJ5V1toS4UlYTSYONURVJAyqLDBSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJLT/svJ; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJLT/svJ"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e29687f4cc6so523231276.2
        for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 20:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729739850; x=1730344650; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6EkibdRfD0hNLJmrqUMgqeBGkxUubBTZYbGiT9el38Y=;
        b=RJLT/svJJEmZ+69wDyMEZzQ6EfKTQN2vhlI6Gm8ZfdGTSjE3drJkS6F8EBLgKpyNjz
         BK/cfeSu546oF0HeQZXp3tKxXQ1aqK8pJ/bzo0WatmyHQ0PP1uCRdthDSKoaLeVLkvFI
         MDLK9d9j/eiELMJikofk3joBus6KPCzTsImbpNXIJtNIPtCN9IBwCKpYiUmi7JEOwhrJ
         NWSXDaKikb8Bn01JJZ7A/xvmIPGIwERVMx2FZNaPtHP+bkUItiB1NHhqer3C9tLKeH35
         83uXQ8W0BRVJpwsm+pjyd7UHgVZ4BIX4y2mXm0t62eSQoGeu1aYnJ8sVKOQOxyTy/17j
         x1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729739850; x=1730344650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6EkibdRfD0hNLJmrqUMgqeBGkxUubBTZYbGiT9el38Y=;
        b=fjbLqbIG1+ueHACztEYKnJKIRI+9CYuYaRGHsrZQJCZB/WuQtPPmz+SAYo6ESPdKel
         a+R1G8RWD+2VzyetGsg18+DRU6qjWo8H4lCy+sb+yPGBsURWI+ZsP5NzdODKK2z5fmv0
         Y2BOrwKuzkCOFcnm/hZ9FfCu5UpYXUINN/q1/JaSdg/BsOQB7KmvXPIiA5i4obmbxnrH
         RPz9Kuj8RrtTLZRP7xvez8+OHg6VPaNnF/AWmOCP8/3wC5VcGs+80xV+L5/CD0ZiY2By
         x65XfTz7q6Jq40N55TINYRmCjJ4CVVA5Qdm1Z88nUaljsTZ5prBnwIjGjFrtAQ247f8e
         1HoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCj0TQURAPgl3iBWlkWo3mDjmaq4KALcC5843nBJ29CegHqi7UvuSkgugHCAuYB7DOtsgYi5DmWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwT81K9W810XIbrNRire7dG1umZWh607Fgy9MAwkS8yQ6vOZ2n
	a8WZLWCefWE62Un/0bbBmZFK7prcy8aDGEgu9iOMTHjnja1beARy8r/VLU4IcIjXX5n6A7amEkK
	XJ+dqFSRrxYZK8tMbtEebHGma7jQ=
X-Google-Smtp-Source: AGHT+IFbJRa/Zgamr72R9VITjkZe2117OmIiEsBf2XL35era4TpGsQlA3Fea0E1AgytMQ4ljKeiFfFFWD+DTKuda1TM=
X-Received: by 2002:a05:690c:6609:b0:6d5:90f:d497 with SMTP id
 00721157ae682-6e7f0e302a3mr52827977b3.19.1729739850149; Wed, 23 Oct 2024
 20:17:30 -0700 (PDT)
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
 <ZxieZPlH-S9pakYW@infradead.org> <CAAdYy_ms=VmvxZy9QiMkwcNk21a2kVy73c8-NxUh4dNJuLefCg@mail.gmail.com>
In-Reply-To: <CAAdYy_ms=VmvxZy9QiMkwcNk21a2kVy73c8-NxUh4dNJuLefCg@mail.gmail.com>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Wed, 23 Oct 2024 23:17:19 -0400
Message-ID: <CAAdYy_=OT27UvZ4cNWPLLiEaMo5wkwS+BUv=+=x7-6oE4TsnWQ@mail.gmail.com>
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

> Alternatively, if I recall correctly it should be possible to just
> check if the bio has an attached encryption context. If it has one,
> then just pass-through. If it doesn't, then attach your own. No flag
> required this way, and dm-default-key would only add encryption iff
> the data isn't already encrypted.

This piqued my interest, so I went and did some git archeology to see
why this isn't the case and there's a flag now. Apparently fscrypt
will sometimes rearrange blocks without the key present. This is fine,
because if there's no key, blk-crypto doesn't need to do anything and
we can just shuffle the encrypted data around. We definitely don't
want to re-encrypt the data in that scenario.

Also, thinking about it a bit more: what should happen if we stack
dm-crypt on top of dm-default-key. I see no point in double-encrypting
even in this situation. So, dm-crypt would set the flag to skip
dm-default-key, even though it's not actually attaching an encryption
context to the bio.

So it seems like the flag is the better solution. It would just be
impermissible to set the flag on a request that will write plaintext
data to disk.

- Adrian
