Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D11A2C0B
	for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 22:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208345; cv=pass; b=HEckbkDDRRZlGb6QGrtJrTqsS2mSWabWdPbAASFba744s+pZHmcLK5fZvHba3RwLXj7wFaqK8v5N9WQrdbIZy5lK6eMc+vsoUJwpcX+Iish0Fsd0/XM86vhAXFgwHZoyVmaBN9zLOLXwNVXnKEepBUk1jJs7Aar39FiMS0nL7j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208345; c=relaxed/simple;
	bh=Y67GBtXDVaAOQ8LhyEmeOykoFjVr4U/jCQoNXM2zraM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OJwauSRrDRdN4gcaRu6TtwZQpAzNeJLSawZA42MOpBvemQSt0KOBYvVsQewZrhmwkgWDwnG6UMB66SlWVM0eR3CTXA9HKN5Zzeqd5vnWJLrGa0o5YLSV0ZuiUSovfBw42gk/RGPVsZrXz90uhvHicEpxSnv2D7V15opnexaQLfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H1L9nwdw; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H1L9nwdw"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so3341a12.0
        for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 14:45:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769208342; cv=none;
        d=google.com; s=arc-20240605;
        b=LUDsE4k5uF2hUcJBzsAQIbemc+r3d7ypQyMbDk7W+yLMsbp4hTLuIws/qIo59F9ypV
         FSDav8r7U8fZaj5TgFtisNdQeYx0INr88wyv+9Hsam5DafIgxA/u+JhOsEq710H2ytB9
         Gv/vYe048cwicSQ5Hsp94aRXn8zn/MPtYJyf4f72Olk/mekk2SV4pBFq+Kfet3zSaDBv
         jIpbvWhlX8zFHe4FMAjUDwzlm+8OCVGKW//QHurYSxIJWXEWA4FQLfZnz9Z6icRc2eAA
         8xyhUrHWCQS0kl/ZWfpZcrXCKZ1lZHXdDxVeU/1san1ICTlEGHNCNdw9F/TGBHWJsika
         gxwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bz3aHhjSbSNSlznz3JK7SLtphGO9MrlffKZeacdwsA8=;
        fh=dTAHK+0abp6vtiCw8MzE2mrS5eqwMiO7Tz4d9qqUk/4=;
        b=DUvxI2cOASOVMglIEkyo/LmuB00HUvTwexz9Vc/TC8ZYHn4F/DGJIEZggrJAz/U1s8
         sB8Zu3pMy5cYvWEjfeqTDTilURYGX6pMmaQtuaC+hMtidOKs4U33zVp9dlX4OEO7r2CB
         IV37sdM/pINrdGWOo+NnUZwg2XAD3FlYiijkIWh2uBNjhqgebLhYZFXpvoj1vXHG4Opz
         o3rlnnwqJYDDBMYcMFIrE8OiHk5rNZb6o2Dvc1nEE3Jyqkkbubp+hD89LrKhEEXGmA/H
         ZSF3eyPMJJ/3FXWQLRn/uoB8WJzOVY9md9kzmvgQHQMjfWRGFnTgxblSl8li+kjYsdPt
         O07A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208342; x=1769813142; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bz3aHhjSbSNSlznz3JK7SLtphGO9MrlffKZeacdwsA8=;
        b=H1L9nwdwKipPyVi7vNhPioSdtqOFSdUc2IA9m87Lo4ciCLpBsh8AOLAF/bpBV/O+Vq
         hSG7G0i0NsfZc8QLJmAafVz8KGhVYkvMv2mJAEfsA9TOkerf4tuntiee1FDjI46vzBDB
         WKA6FG5d4hwPXQ4V522Hx5dfLoSVx7+abjHY1TrH8++cmmLsgS6DV4wQz75GZVlYvLm1
         sS0onxDjWyx/qNvP82g7ylgeYdHi+FpVwHxSjz7mx88bsnPybok0JKgbaHLYTPC7HkBo
         jQc1OnQmpiXeooUCISTKR8XK0j3v1gmzl7fcwqXaJ0UXPThxnsnOxOxZ5wdWUyuYdNti
         rfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208342; x=1769813142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bz3aHhjSbSNSlznz3JK7SLtphGO9MrlffKZeacdwsA8=;
        b=SlUHL2DdCk8gyU+aFPmCtsPhMCIomkCwMu7dEiyX12nYzH89w7y43r6tJs18Ahgt2d
         r76ggu2OrU0Tg7/4fXNp84RaFu9nUqbfaxNW5LYqr77ceHiELk3ofKmSMF4CTXIqq177
         we/O1d643+2kcjPQoOe/otRyjVCH11WEj16mvL+ZSMgvWcgqvU39nh8e2UqrBt1TlJ4X
         bAagEVbI9F5OHc9SeAZnBMZryyybvD6rq/uaFfdqTivcPqDer5C7hFsx3krVP/39dNEM
         BVkLJSVelLO6hRVKJyBADxyD5zFkj1GqoaQSV8pJemD2hEUS8WvV1JARGTkusXbz+ke9
         8oyQ==
X-Gm-Message-State: AOJu0Yzs9Lp/5IQwFBmeeULgMtybrmWs0CoZ3kgnzaIEN2vCanPt62jm
	o3DZff6fhV6I9N29tBPD+tNq9KeCCHV/NtAi1rQN5HFn5R/7J0VEezGmHRIPo65mhvBEysivjEt
	Sq7OKK4zp+FcBbM4kwgzLsJrlQ+LC7fnkORRmjPQ9
X-Gm-Gg: AZuq6aIpWv2ZKklq/26S4HOC8FQP56eMxAq17E3o/ienRdJr3BtYPDe5TF+raN8tpis
	HeE8jOfW35TgCr106YkPcJqJOVbrCLnRMObpqyx1cYv0mUuE8ZER1rU+tNj8DZrUEIwRDaG2aTZ
	OCTHUSl1PUmfNNEwwm9xOmUBRgqaKIJ0X1R4RhY8w3uptQEoZoNCHoEl6rEPlUE1x2m+U4pJoVn
	WxH40zR/0gMoFMJQbX6BR/XOgDsHdzEpUjVwCT2TsxcP8RIbJSmtrBo+Qqlfy8mgygX
X-Received: by 2002:aa7:ca4b:0:b0:658:909:511 with SMTP id 4fb4d7f45d1cf-6585f13501bmr3915a12.3.1769208341999;
 Fri, 23 Jan 2026 14:45:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260111202530.52665-1-ebiggers@kernel.org>
In-Reply-To: <20260111202530.52665-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 23 Jan 2026 14:45:05 -0800
X-Gm-Features: AZwV_QjB8Pr7SnumueW5YqKzz4lIyDGh4SZWb0xXJej3upe8esO7OhYNX9jmV9o
Message-ID: <CABCJKudwzZ1BWaKTAHa0dmnOnRFAugaon0gYqFbRHve1841eDA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: consolidate the BH and normal work structs
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 12:26=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Since each dm_verity_io is never on both the BH and normal workqueues at
> the same time, there's no need for two different work_structs.  Replace
> the 'bh_work' and 'work' fields with just 'work'.
>
> Note: this is correct even though it means 'work' may be reused while
> verity_bh_work() is running.  The workqueue API allows work functions to
> reuse or free their work_struct, and many workqueue users rely on that.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
