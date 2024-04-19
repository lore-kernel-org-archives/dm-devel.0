Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2475B128387
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713536387; cv=none; b=N6i4FQ40FO7Otyd6+qW0WARfDzOGbM9VMUhYZLwFHBX7/P9z5ubEbwx8qdghjh3brbt9KX8WjvfDsRDT4L5Mc8xsRd4iLEIRWIxXwxR3lV/icSl6KWAAqZ7Mo+nOqo4RvYqzPi1/V1nQOgbcAAkWEqeR5L1S9fZ0XjgO87Vgj84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713536387; c=relaxed/simple;
	bh=pb519J5zNRflhlPLtsK62v30aMto9JJb+pAQHjSfZp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hR07JQDctyYFrk9iQlT1+QmBqqDFuXeCM0LGDKqdshiL7OBQk6HMuF5EUqArrqX7Q82+iJxen75umcCQjvO6HvgysDJYrJoKLs6pi9wk6yhS/Bjue9/4d5yZ9YKiZBaItuLHO0AMaCc76d43zzcwMuchwU8sKhqqdaNUcFa6iX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSAIHMGN; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSAIHMGN"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc742543119so2268613276.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713536385; x=1714141185; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pb519J5zNRflhlPLtsK62v30aMto9JJb+pAQHjSfZp8=;
        b=bSAIHMGNYWLTOHkJBYqOGK664YzmkIzwHNkgurpK6tJjvmAcI1bCUBfOBVeMFZLSBP
         4FnYlAHeNj2BkTkICHw2tUn91MGjij4VPQCDhGoM2bC7a8oUI4ZWquFZlMwn/3pNAE18
         2tmTw7Y08u+LYhKSxL8jZBvgFgJTqLE+qwG3JYr1X7c0FvswtkSVcYiVJ1dzp9o/1JW5
         71iGNkYBt+wYCD2XuOi9fRb4392uKN8Ke1Y6F+thLHcAI1+Tm+dQ33evH/mYb83/w+92
         2eN7OQ6QgpjuR7CYUx6RE+bKqFvsbqZJS/M4ELai2ttIU9d77B7W2Px4+XR1leMBBEpJ
         5EBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713536385; x=1714141185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pb519J5zNRflhlPLtsK62v30aMto9JJb+pAQHjSfZp8=;
        b=xGfN4tNauV34H+l4NdEoEU+diFQozuR6cJemEWC6ykZM/ioV8/qy5gr3aT46tzR0pG
         hdh5tJRQgesX9RZ3Kn+jcamrwBuym72qrp3XgWjP9X7ceKfvygepo1v79jkuzb22ToHp
         fQhcy6D3Mtd4m0rcn98gp50Ty+7vJ4GiFefJVRzk1E5xB+FACmcdfV28XQx5WSwwHyzX
         gudRoF3KuskxgiiM5y/UO+d4Dfh5EQwFOki4b1v4bWYASSigC7xOWjWCDDDV5pB6hOZV
         ywfR63ppnH5W/54mj9w1JXy2R3L1y6hOlh8wpTx8nzztLEzP8hqqL5dRbrKkStsDKGJR
         Z1EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcIZsAN5OGbLr+aRSjTuhmFSvqb2Pk+ELU+jXe77btTAiTYnhMb71P6Nq8qMTuxUcYlSRWHn4X6IZjjJrYUIF/5x4PzzBupOY=
X-Gm-Message-State: AOJu0Yw5DzqxanHoEMZgPt8i8Hv/8QNijGIswCDTdvSoLZbm3ibgRD0X
	NYQWHTfuAqRmWXEbB0zBeUIXA5fdhXD2RNeTypxLLBaHFgzO5uKmtX9PfXS9vJXsK8kLZnCCIxi
	Tk8SulJPRvSBWkR6FPwU8n7Eclcw615f9
X-Google-Smtp-Source: AGHT+IHxNcp1hjaHfZAjTo3wVnuZTJ23MYZ8SX7UGJyDyngoklUX8aM+BRPXFrZGvWF4JA9Y13opxEVLN7Sn8k8KkAA=
X-Received: by 2002:a05:6902:e09:b0:dcc:9aed:6282 with SMTP id
 df9-20020a0569020e0900b00dcc9aed6282mr2144990ybb.65.1713536385165; Fri, 19
 Apr 2024 07:19:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
In-Reply-To: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Fri, 19 Apr 2024 07:19:09 -0700
Message-ID: <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: libc-alpha@sourceware.org, Zdenek Kabelac <zkabelac@redhat.com>, 
	Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 7:08=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
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
>
> When we perform dynamic symbol lookup, the ZMM registers are spilled on
> the stack and they remain there forever - this is the reason why the core
> file contains the encryption key and the test fails.
>
> I'd like to ask what to do with it? We could use LD_BIND_NOW=3D1 (or
> -Wl,-z,now) - it mostly works, but not entirely - the key may still be
> present on the stack even if we use LD_BIND_NOW=3D1.

Since vector registers are saved on stack only during symbol lookup,
shouldn't disabling lazy binding solve this issue?

> When I hack the file glibc/sysdeps/x86_64/multiarch/ifunc-memmove.h so
> that it always selects the ERMS variant of memcpy, the problem goes away.
>
> Could it be possible to add some switch to glibc, that could be turned on
> by security-sensitive programs and that would prevent glibc from using th=
e
> vector registers? Or, do you suggest another solution?
>
> Mikulas
>


--=20
H.J.
