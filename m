Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B371A1EF09C
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783710; cv=none; b=OFq9KS3edJ5esCZOvV4OwyERJgCBDLH1o0xOoOVI+9WRGJdt7Yzc5qco9MNiDiDXKWHOoKn2U8ReL24gjuy+PQpjWlb7BveJp9X9HjbZXIxaqE/H7hGkUAmjrahbgoM4/h3GUUXa/QXM78aZhjj8MFijJwpsYSW88t0Ss42QeRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783710; c=relaxed/simple;
	bh=Fs2tc1WwAR2PY2tTefPbWYTpSMFv2nPyy55SErMhtP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WZQ29Gojrz9ZMhTlEWq9pPYsVV75D6jo72NrSTV0VZALsOKQfvlPypnQC7NJ57uR/hGB1LHPEGvGOZb3JQz0TNhSLMw0ntlsNGz20C3WArsc+LtQ3d9FpumCFYW5oSpC0Ds+XyP28DqijpBR8ItsQ1cuYZuDH0aWMt1WGkIjRJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QD7TCi8V; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD7TCi8V"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6e5a5a59094so9710057b3.3
        for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 08:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729783708; x=1730388508; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrA+PE9QFVQSWd15h41v5TtusoT9a0SkYDwQrFOXSR4=;
        b=QD7TCi8VqQTscBF7l3MpsebUWs07ugZtVhBkgin5LADY3p/27iU4z+G80eF4Uq9XsG
         finAKdAAjwJoQdXa7Ebgq/Yoq5X+vqMJnIiHlr2EgRuKAcG7o2b3d/qIUEnCu5q0tWow
         qfw94yHf1sAUWRbxCUtdnsaXA7E9ks3YmGnuRHJwVg1N1A8tVnxglZTR+pGOTEHnqS+W
         nq32MP6SgBxKcRTswgY+TYyxO4dQ+WkPDwl/FS8ntaBOr0VEUmlCzYUVRwCuJEDWPdjp
         zMZcdYjwJ+pl8PX2vgPl/3NTk+9a2JXo3ukCpGJh/UqAk7etDk1qXIJDZ/kxG8MgcQMN
         6GJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729783708; x=1730388508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrA+PE9QFVQSWd15h41v5TtusoT9a0SkYDwQrFOXSR4=;
        b=W41ZVNHDP4Dqmoa+VrN5lV3JBuw8ls3UKgqMdlv9JUEDcfVbpZoDgk1l8dofqZsB03
         c9qWh3qXdGHfa2uDF5WE63as/5qkyxMwm5FzRqC3j93B5WEwWmM1LoSXiiE9xanKn7LO
         2hEB7lRg7P7sM5tjap8fREmX/VGkDfp16NwS6QRaigW3v8r3u0ntDxFb32xs/W9c6JHn
         vlN6cmJvjMIbnrURDnI7gC/NvaVBOMQUz8Od9/RIzn+sB2395wKZA0Nv/EAyL7VLqQM2
         lZEUazyWsneehLiycfwb0kgAbwITujLsfPzzpB31Q/JffHBAr6yWSm1Q8arZuwoUFsYX
         wFsA==
X-Forwarded-Encrypted: i=1; AJvYcCXRygGvfOTgEJIFhYXORA0Iz+Va/YY/AagM79HM/lhxkaBa9+03jxWZ3vLdSdwZzO1evf/CLeC57g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWTNeAWjNY4bE15DpaIC8i8RgrgdxUnhtoaQX4P4c01p/pFZfQ
	a1KuAAmCrGXET4If58dpcGuEQ40h8GA2AjlBlVGT/ve3vruIOVRzn8HL+2xUp71ggk00AtscLGG
	7sbQgBeAa9LuD9AdM7dkxjDq+9Kw=
X-Google-Smtp-Source: AGHT+IFRyXW0hYO2Swz9RLGo1csIv7IsSIQzzTKkoxMY8+2S6NZhcmqrrYbuG7/FRn1ItAKRcQRE+umN/jZ8cxvEJOI=
X-Received: by 2002:a05:690c:fd5:b0:6dd:ce14:a245 with SMTP id
 00721157ae682-6e7f0dc1121mr77233267b3.6.1729783707713; Thu, 24 Oct 2024
 08:28:27 -0700 (PDT)
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
 <dfe48df3-5527-4aed-889a-224221cbd190@demonlair.co.uk>
In-Reply-To: <dfe48df3-5527-4aed-889a-224221cbd190@demonlair.co.uk>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Thu, 24 Oct 2024 11:28:16 -0400
Message-ID: <CAAdYy_=n19fT2U1KUcF+etvbLGiOgdVZ7DceBQiHqEtXcOa-Ow@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dm-inlinecrypt: Add inline encryption support
To: Geoff Back <geoff@demonlair.co.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	Md Sadre Alam <quic_mdalam@quicinc.com>, axboe@kernel.dk, song@kernel.org, 
	yukuai3@huawei.com, agk@redhat.com, snitzer@kernel.org, 
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

On Thu, Oct 24, 2024 at 4:11=E2=80=AFAM Geoff Back <geoff@demonlair.co.uk> =
wrote:
>
>
> On 24/10/2024 03:52, Adrian Vovk wrote:
> > On Wed, Oct 23, 2024 at 2:57=E2=80=AFAM Christoph Hellwig <hch@infradea=
d.org> wrote:
> >> On Fri, Oct 18, 2024 at 11:03:50AM -0400, Adrian Vovk wrote:
> >>> Sure, but then this way you're encrypting each partition twice. Once =
by the dm-crypt inside of the partition, and again by the dm-crypt that's u=
nder the partition table. This double encryption is ruinous for performance=
, so it's just not a feasible solution and thus people don't do this. Would=
 be nice if we had the flexibility though.
>
> As an encrypted-systems administrator, I would actively expect and
> require that stacked encryption layers WOULD each encrypt.  If I have
> set up full disk encryption, then as an administrator I expect that to
> be obeyed without exception, regardless of whether some higher level
> file system has done encryption already.
>
> Anything that allows a higher level to bypass the full disk encryption
> layer is, in my opinion, a bug and a serious security hole.

Sure I'm sure there's usecases where passthrough doesn't make sense.
It should absolutely be an opt-in flag on the dm target, so you the
administrator at setup time can choose whether or not you perform
double-encryption (and it defaults to doing so). Because there are
usecases where it doesn't matter, and for those usecases we'd set the
flag and allow passthrough for performance reasons.

- Adrian
