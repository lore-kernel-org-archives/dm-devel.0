Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F9192B89
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720619042; cv=none; b=W4jwYasayZ4SJhXn2/LFy5CGfkh9QkndoKWdoErYk69k3pjVuZwAODJAYjIUV5PbLwXpQSrLFL10mVap0fVVE6a9MdKvfnah9rbmScPB08zDrJuG9W7sL81NHO0fPAQuV98pA9863eomHDHOlYKUWiwjwN3BX6AcvMTgqko9Mrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720619042; c=relaxed/simple;
	bh=VzjKYiC3TRUVmEeY4cruQ/i9VL72Y+56Uze1Zz3LcRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEUlrAH5WdGqhNS+XKLAwZuDPwLQ8P79n2JV29kgRk/wjXlk8d2czk+KcSL7hcbd21cV0q0NJ5PgBpfChKlBwRzV3uIyiNJLd1Q/uRTxPQ2rzIcEaV6EcAk/UW71faIm3XdaPgsMnb59uGtZn5oKfDC61AsIgW8UkUnq63k7f6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=INtTRkgV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="INtTRkgV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720619039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1UbC6sYG8EyHF93wDqXaOQ84FYoZKixSqTX2HRZz/I=;
	b=INtTRkgViOnr8Dstlr/Jaz+jEeK8KIk5ONpVCY/Ni+DLmWEgb1It18HylDA30Ncx6R+jc7
	ok4fn5fdykyJufrSbpxFI3N8Bda/gf7Bs/bC1HElREcvJucDxA7MvQcC39fn1tgT+1+ld7
	1QkdVkq8PPk1qNgh0Gw/SAtSYdVdAwk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-A7ohKlyrOkSNbOf4pvBZdQ-1; Wed, 10 Jul 2024 09:43:57 -0400
X-MC-Unique: A7ohKlyrOkSNbOf4pvBZdQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-426654e244dso25591745e9.3
        for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 06:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720619036; x=1721223836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1UbC6sYG8EyHF93wDqXaOQ84FYoZKixSqTX2HRZz/I=;
        b=g6msUiOeiMZbF6MGDpE41r0SvlhJmM2dis4nngxXOWxc7LdqXDJxI6xnj068isTf9Q
         hZ2wcmGKPy1S/k9Rt8CL5TBcNkaHfc/IzkLJk8ITLyl4sE/FLMdnxkRthnZF3TdN8Lyl
         x7z5pQSpGd+0sqHHKcX9uJ3sIZw5LILHewYzL/HViFkd/A5wroe9cKCspj5Xc9Y7nWMS
         WhQ3UxuDe+fZZH7SSqS1q8GW898V8HP/y3sI6MkLSiVjvhdaU/8wXVutCEkuvxXO0mfF
         V5/rrql1sif8fhYJvpcOd/gSd8KroffDGOIwFDakOLTayAauVroX+3F0nhhNsHC5zYgw
         14lQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7nXE8XbYYu+onB2HH0T2PmlRFxPXNG9z7KUt4bjQwDw14D04Ix5pgqgbJ9xjoG22ICpZdlXlirmapT1BqLkxzwfZ5LHGN4gE=
X-Gm-Message-State: AOJu0YxcB9w2MHlfsKSiCnSbtI4uhr0B86/8feTcVNQcJ9zcRR8NS+jE
	ZUtWrTV5Ma0eW/6eLJkmVV1qTDV1gbZVw9QAhkib1KIkuqDhjLAdmaenQduR4PQE6CMvmcbhgRh
	YLnE2jzYS//JvO+zRh5B5R742zMyTck4OKQVyID8azIOa0Je1dwFdPpGpfG8iOcHpQZ9tHpsggv
	CWhlGmGcvR5mfHB38GYfDj2zhhQ1DK0QU=
X-Received: by 2002:a05:600c:2284:b0:426:6416:aa73 with SMTP id 5b1f17b1804b1-426707d89d9mr34785355e9.12.1720619036772;
        Wed, 10 Jul 2024 06:43:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvC1hvx7V5bnT3xH71scnBh6oWIrG3mzuiuTXE7uXCAsFFgNd/Eb/h8kwSAwP0ae++izLV337A3NwkIwYO4LA=
X-Received: by 2002:a05:600c:2284:b0:426:6416:aa73 with SMTP id
 5b1f17b1804b1-426707d89d9mr34785105e9.12.1720619036136; Wed, 10 Jul 2024
 06:43:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709124441.139769-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240709124441.139769-1-shinichiro.kawasaki@wdc.com>
From: Bryan Gurney <bgurney@redhat.com>
Date: Wed, 10 Jul 2024 09:43:43 -0400
Message-ID: <CAHhmqcT6F_b8ZJMbm9jbL0Zg-vv6zq9oxfMttzf1K4GH-zz=NQ@mail.gmail.com>
Subject: Re: [PATCH blktests] dm/002: repeat dmsetup remove command on failure
 with EBUSY
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, snitzer@kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 9, 2024 at 8:44=E2=80=AFAM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> The test case dm/002 rarely fails with the message below:
>
> dm/002 =3D> nvme0n1 (dm-dust general functionality test)       [failed]
>     runtime  0.204s  ...  0.174s
>     --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
>     +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad     2=
024-06-14 21:38:18.588976499 +0900
>     @@ -7,4 +7,6 @@
>      countbadblocks: 0 badblock(s) found
>      countbadblocks: 3 badblock(s) found
>      countbadblocks: 0 badblock(s) found
>     +device-mapper: remove ioctl on dust1  failed: Device or resource bus=
y
>     +Command failed.
>      Test complete
> modprobe: FATAL: Module dm_dust is in use.
>
> This failure happens at "dmsetup remove" command, when the previous
> operation on the dm device is still ongoing. In this case,
> dm_open_count() is non-zero, then IOCTL for device remove fails and
> EBUSY is returned.
>
> To avoid the failure, retry the "dmsetup remove" command when it fails
> with EBUSY. Introduce the helper function _dm_remove for this purpose.
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

I think this looks good, and I tested it on my system:

Reviewed-by: Bryan Gurney <bgurney@redhat.com>


I want to cc dm-devel and the device-mapper maintainers, in case there
are any questions on this test.  (It's probably a good idea to cc
dm-devel for any "dm" blktests.)


Thanks,

Bryan

