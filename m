Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EE7168C20
	for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 23:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724368194; cv=none; b=pVJ0C49wuKPkmCpbcB31b0gRkxcCIP5EL6efkWSv/ldZMwaGFQ1KKzQWDw3OSDkggUlkYU8M9H8H6weQg0pOKJK1rHP4wKjylbobIVgQKVMypdjuCWx2Pxi+DOgrrFu/zLyoLP+stbDicSmwEjYamqv0L+k/EOgdbBi5cjzT9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724368194; c=relaxed/simple;
	bh=/FAGryAUh17PRxw5ivw+fa+hnFHaPve79zoeIE9qGVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DKLgGJ9AHn/Pw/qs8CfDAs3eMF2vTT7KMXoCOSDAYV5l3xhWOnoIqJ6L7sErB6oD2SbteFQgEjvguIUyudcGjX5C1hvqHp7dN5rXe9HWadm0rqylB2B83XV6hQDJrjbsu1FWEV30LOYA0+jgOhVtXgIFWeZplhSOug3LF88Ai8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=kC2d+l3Q; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="kC2d+l3Q"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso1644885e87.2
        for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1724368190; x=1724972990; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FAGryAUh17PRxw5ivw+fa+hnFHaPve79zoeIE9qGVY=;
        b=kC2d+l3QHdEBy5f2cVWQ/vGBLoTeXVrKUlShmPrdxr4bQMDEPGf6ae8P/0C3yHvO6g
         Z8g2IMtIgiVyheLvJhMu1Xskn9BOU79i/ZgvmRwkgIpSgp1QIMweLO/Jisx7EecSeBz3
         2XcrKP2Stb8jZsxxqXkrFXDHvdQFvbkKxvqMgUJqITk1HFRDErC9h4xvy26TCC/GYPKn
         Mj9wbfA4+RABX2K8IKKW8dO7MgpI7JCxgeT1CjcxWdQ9mQwsumHV8yxHukJ87jqQUvwu
         lLwa0VNwvtnEuRtcrvkTyX+bffhrcQldZr+JdTd2IO9XIPzMRHTI/bwLKSaBznYzrrIC
         WG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724368190; x=1724972990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FAGryAUh17PRxw5ivw+fa+hnFHaPve79zoeIE9qGVY=;
        b=w78WOVfTTT6zzC3n8Vzo9UdHRCiMd9Ts5W88QPk+A61EPlGN7rwecZhqbzES1CuxYK
         m1qhBdg81ViAqlxeZUojC4eq3mWxjSH8MpcQI2Qhv6TB9O2nNbQSXVMr3QWC0Gs277Es
         gkkF20NzQtdXR+zn7xukPg3HDOL919+R54771T9UyOilIyG4OrPedTdaC61u/R8wmU0R
         Ff16ObCLDUuUZL9f76x78Nqsc4KXRTTZ9BmYgB9FUqlHi12IdW6j4TuLnomQoF3R9j0X
         lmEn58WUGXKWSoWUR/i91JY+HlUKG+B4L2XMRpqO4rWOWLpWQL6QiwZhmAtuxIZt3ICE
         pWvQ==
X-Gm-Message-State: AOJu0Yw3o79nDrGmQ93mWDHlAWIcQbhIVh2X2/z4cRV3HzRb+grktJ3e
	bYW6Jdltyl6OCohGBq+QAizeTAYctoKJiUSbu5jj6niZni/Df31lg5m128t6v1dEyJg0uS53n6o
	RwG1nQXoUtQXiK68L5WwNnH1l7UIUuZrJaaX2
X-Google-Smtp-Source: AGHT+IFn9Uzh74dpNQWqI0lY8WFgkXlOMZO14NTEQ74k1kER0GjgVS/DAaQRU2D2YKRrJjC7wEnz7taA9GOjC9Iw1T8=
X-Received: by 2002:a05:6512:3e0d:b0:533:4638:df40 with SMTP id
 2adb3069b0e04-5343883b116mr190886e87.27.1724368189753; Thu, 22 Aug 2024
 16:09:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
 <219dcade-3d6b-b5ac-c11b-efb8dcd3bc63@redhat.com> <66c00dfe-ac48-db3e-713e-9541468b9879@redhat.com>
In-Reply-To: <66c00dfe-ac48-db3e-713e-9541468b9879@redhat.com>
From: David Chu <thedavidchu@berkeley.edu>
Date: Thu, 22 Aug 2024 16:09:38 -0700
Message-ID: <CAHge_02ieUXoqDD-AzToj1XTrc+J=tNnmdDe6sSoG9miQUjH1Q@mail.gmail.com>
Subject: Re: dm-integrity and write reordering
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Thu, Aug 22, 2024 at 10:33=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
> Regarding disk-reordering - the disk may reorder I/Os, but if there is no
> crash, the disk must appear to be coherent. Therefore, if we write A, get
> A's endio and then write B, the disk must read B from this location, it
> can't read A.
>
> The reordering only becomes a problem, if the system crashes (in that
> case, it is unknown if the disk will read A or B after a crash). I think
> that the SCSI standard even allows reading garbage after a crash.

This is the detail that I was looking for. Thank you!

David
