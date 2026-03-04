Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B34E3D75A2
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772647797; cv=pass; b=iZfgsXucIUtBlOJPELkLbNQnTEkaH4HAWDYR0Ck6NPNjd1oghOTOmmzj4I8pI7iRpQ1Ic1axG/n2e8jQKheHaVXa8ty9SyxoPIULvVv1EXHMq4v1VTMZzLlnyHXHbhcu96UVwCQQouzKT84Ws39/QxjpGK+2Sh+EQDpPFYCsbM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772647797; c=relaxed/simple;
	bh=RalLVkkry4FncaXhIQ16HmZaENLn1C4uOsOfiZ6OFOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9Y6dCHB/ZGjbsLIdiiohC2B29Zwn1h2WSGcwlcKNEjpdRyhDQpciuo8Vzux/Lbwp9jiawRwMIGLdAxy/C09Vn6wFn90dUnXbMGwxTcyfx7A+CJAcfI+XPNNNKFBaU6QQrmhGptyyj48MC25X0yTlCoY2CQMDj13dOPii1OoUgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xkc/p3si; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xkc/p3si"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64ad46a44easo6264414d50.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 10:09:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772647795; cv=none;
        d=google.com; s=arc-20240605;
        b=TUQ1WPucqfUTyuudaP40Zt+9LUGP+dfa4CT3Flrarg3p65K4/wH1bee3ON/BwRu90z
         e3PPpxfXi5+iWzWK8wqhAuMLnKFlb9FED5J+JEW6S4plbiZi0Zbia+ltCRIy3LYef1RV
         +QPoGOgk7x3hLyxt9c0h/gUuFv324C+v6SawEYVsOPeHtHgSmkNbdRhgBkDLLpZ5DSyF
         mwHpvDrjIOWGp8GhksDKgYCM11LmdtVTGbD5QMENniJNBbf/1UTkkDZJ3mfKN9xYczoO
         MMji8UgrVDxPpWUVMheYkc+hwo9yedc38oA4W/ekUyz7bkRnxsrmRC3ZMF5454w+nQY8
         RepQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/AAP6xDZoNmpLXND/XB3hSZCf89V94pBMhQ2bbUGJDk=;
        fh=+48Fw9sarV/ANWcd59TPW/qDwlSZxnLL6kSUFygf85c=;
        b=DX+7sVUt0mvYDAQx/ZkNk/1MygXr3M+NnwBDlwTKVTrxjPkan0neAnI2ugWu4lzYBq
         7iId9catjKhOnuE7/82S6bv1xHTPpJ9lS/PxMB3AMk6Xtm+16M21OWs5RYA+AxdS49TN
         X1VALlReyXHzahVbbRzOUX+qs15oNGhkhh5TwnvXAL+qegtAqvPoCQmkBeG02tuBUb5y
         6driqVJOxZ6jtuAfJYim5Nb3cjYOnP1A/kKQcHIUax/7ThClQmPijIlQ39wwY7XXxwIW
         lWfErV33MEKpaR4CXU6YDSXrN9Mtf1nVrljZc3cVqaEDdj4QvSiIU1NwsUUcKL9nsiM3
         U0fg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772647795; x=1773252595; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AAP6xDZoNmpLXND/XB3hSZCf89V94pBMhQ2bbUGJDk=;
        b=Xkc/p3si1cP5DhxC+Cvh/OJUgmdTq1zJ8MMkihPBqH4Y+ygboFR07tisFPux4mg/wS
         lEA0WO8dTcl8eHHnnd7ur6kfd9m5xZthUJEi3yeCmn0jEogCobHviDeq/6c8430ypLE/
         htoP71uRa+SPGUzwuc7PtMKfUVQJ7sSX3bwOEqlWOXMEFjtU8Q9g8f1yUlMPyUWEyQrY
         lFmEQEyQwgp79SJ51DYqPkp3hztZMYD2SNjJAewImGPfxz9LiMeHa4DVFT06SzYKLm9Q
         klLPgbjPBYbrv/lwVhgvyQSbZ2h+/fBWGyQTHxqVaPo/PCxmI+aBdR3m/pNGDnOWDZxN
         ByBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772647795; x=1773252595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/AAP6xDZoNmpLXND/XB3hSZCf89V94pBMhQ2bbUGJDk=;
        b=bYpEpwFXqjdtzS7b6OehRdjDLdQWtQ3ZanFUXjTxYhziJ7xuNgQMd0JN2LODAi88Zk
         hrl49gCE8yXapM5sjYdPCDuW/T9vmI5PIrEeqpuIa1O7WxNWQnDVhoUdoYYkVUmdgsNv
         2LwVAIjsA8gPZ3Eo6dIA84QX5Wx1/t6qUdLaxmmFw91nq9kUFeiwT1akUzeH+esqcVJa
         Zw/W/4huxqWdNxGv1pwHmRZcXtDqVR2a0hEKRCWw6F5yX0l4eYsgpleMn7cMsIyWCW2h
         4IIh85Crn8xK1ZW+fSXb/QRL0GNXe+UJwLQ8xg76IjyD0uykEPTDNq7+KKZ3PN4efXAM
         GTbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiuVxLTZ4aiQ/MVoaPt9ll4yBnNBIFDwrlRPGnwBj33R5XsUYiXtwlTGkbkjOlENGwIAH5L8Crig==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMiwt1SnrARA55b39tN9b19Yf5339FSU3wFL9f9f2xZqQyux7x
	41VBy7V2WPcbACy9isVLo42B1GRZ6CSRD/PBbLfg4UaJisqJHkmIxlbbParPJzn9UCxr6vFR5YI
	Lh5Waa7eWMMdN52/A8aoPIMEpQ1/5YaM=
X-Gm-Gg: ATEYQzwp57+rPR+SGNONJ98kAtzDaZ5ZE8UT7jt+sEX7Rm4aB9zsOjRGvNz4rYTXYCP
	7AAejqBBnhdrLqj4a0hfTAuZPMWVZJEAvfnHeRW3FWydtLUPMLXpQnhQwHDd538VpUcmevkUBcr
	St0SRtoL5xW0Qur46UOI49YdwTQRBpwpvX3BPCUw7z9YDlqWbJr3Mf2QZO5ys8y+Qi90WdANlCa
	SURcK5rZIVTJjOM2Ftx+Pz6VN5JpHFisW96s/wVPw3xoO3ace1xNBSV8Ja+S/XRaVtVvrYS4vpk
	YSILaDNsqcud9DWbq94vG3kraI2FBF5nrOqnfWiwqtB0OpebzgYVvzJpb/IWp1jAuWP8rEEunk9
	UcvMntk4ruA==
X-Received: by 2002:a05:690e:dcf:b0:640:dd02:a777 with SMTP id
 956f58d0204a3-64cf9bbde6dmr2328620d50.69.1772647795104; Wed, 04 Mar 2026
 10:09:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com> <aaguW3p3_LOeM_Dz@infradead.org>
In-Reply-To: <aaguW3p3_LOeM_Dz@infradead.org>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Wed, 4 Mar 2026 13:09:44 -0500
X-Gm-Features: AaiRm53qIrqqlwryq6-vL-KMtUUaiHvUVdrssaMtyjIxU1gScjYF_6wvmEHxIl8
Message-ID: <CAAdYy_nRbYMsiysC66nrMqFEtEdjjBTdpLcVZBak-M9QL7BK3g@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] dm-inlinecrypt: add target for inline block device encryption
To: Christoph Hellwig <hch@infradead.org>
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, linux-block@vger.kernel.org, 
	ebiggers@kernel.org, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com, 
	mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Christoph,

On Wed, Mar 4, 2026 at 8:06=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> What is the use case for this?  I'd much rather add fscrypt support
> to file systems that are missing it than forcing another stacking
> layer.

Maybe I am misunderstanding something, but this seems orthogonal to
fscrypt? Userspace would use this to do LUKS full-disk encryption, but
with the hardware acceleration provided by the inline encryption
hardware.

Best,
Adrian
