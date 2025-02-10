Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBD9256C8E
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206715; cv=none; b=EabeR1dcw8u1T1ka6k62AnFK3cLzxCJfv1h+GMbjXEeP1Z6W4+4eRTUL1mm8ZGuWM9Btidv/9n+x/jzjclNPLiF39PHy21aRSyhA++xPTaYgtd974xkClUPjP6OO2vwYuAfWuRdwHHvdZQvjGjj+Wi49GTijqT/8ThW/wFH87Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206715; c=relaxed/simple;
	bh=+EYxoO/4eaTKKnUK7wm1jcos/P6WRb0f5cS36rove7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJ7czAoK7dv3PdWm9b+f1KAdqXXRktNIGlCzh/JGEAr1Qp33au1OHUcFsTVCwSczQ8tyfiSRyJ8QVRGf0GjNez921Sr736Wg2RR8WZV6cuiwZ4tXX4tTyLZQgjXAGvXJTbQ+zd7ZPeAiF2uvJuGW++DGmT7D6u3u6NiB9BxOW+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OHMhQgyb; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OHMhQgyb"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dbfc122b82so14247a12.0
        for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 08:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739206712; x=1739811512; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cm57wNvbQ2vdjEciVDp1te7Id5gFdsUL8knVkzn6Sqk=;
        b=OHMhQgybnEEK3k8qs/e6RVWSSywMBc9LL+IC2QeVOkZj0V2YvOCb9OfrLPGgQBpPTp
         OJF0nS1XdkvpCF67WCLIcOSAP0dBMGH0Xd62s52R0uXzhNn4IisOZiblNv2O16VJlmAW
         t/7KaU06l4CtWxfYWN8CYInIWDzL+zRASLPI4e5uBRkTP3IlKRDjpcjyqIvCwKGlSTWR
         7tUH8AqzB4zj3I5vzh0a797l2/AscKklledfayEr1HI7+ErJUjH0Y/OIJVvbtA3ZZnR5
         v0dTWOUUtzW56T2ZmDxKrNnY8hPxq5WHXA3GgUWZL6UskOJTMy8ZMXD0ANF7az5lqvaf
         NH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206712; x=1739811512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cm57wNvbQ2vdjEciVDp1te7Id5gFdsUL8knVkzn6Sqk=;
        b=rFzi/bLFC3Ncx3pcN0HxyqN3+u729azEQJA5xWzP5mqrakuHE7cMwYDwsszx3rRXZs
         jMDC/qkhRZAfpDME3rc2RjVvB/2ITBI6w75rkY9r/O4tQqBTEDxZD5bg5PDdOfrkAhEz
         +IiSZKB68lUMOarSA0FZG3iqBbarKuhHw7UKmbrkqjSwCuEt6mm2tADicLkT0fkJgEZw
         01imODtjjjtxHZTeXb0Tg8BMRip0pvfc5VjjA/YU87URA73QCyNHjNyoH/vDS6i4U4Wd
         o6Hom8vqqm6czOvgayG13OMW8qZhoifehd9vVaY4UBBonxqkjvgtyqD1xktIVUAIthuz
         GLoA==
X-Forwarded-Encrypted: i=1; AJvYcCU6Upo4lxCj/22nK8DEH2GyQSNI6d+/HtnyA5mie5uHUOUqcF3FSzWBGA2kOS9zMO/JOz+i1v5v6w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzU1IGxaIPRilbWXgOnBMsbv5xSYMK8qe644JzhRrzPHs3q4Ptg
	KENln29Nv+BTY3OA2WTeWS6C8gHNzdjzi/D97gqCFiWVCt8khiXzHw4MCFAEQZqoAODBTaGzwRO
	Ve/Zsc6PAkI91Zn9Nm6jwwfwLM3Ei/stkEMma
X-Gm-Gg: ASbGncvshu3wVwM6sfVPaj39V+hS26L7QZIrsJMgc/y0qDpFQmuNOBxq/sSYKfyv0rm
	AGJVUaunmvTwQOloMt2x7ehv1vBUP2v9idTnW/OgKuyvkar/xyinSesttp1GJ5ey0GgY9XQ==
X-Google-Smtp-Source: AGHT+IFnw841MFqZMe6UVhOR0RXEyOzas0we/b8udxrzoxTVjI3QHNpgdB6s5ClL8XfbUoDdeSPb0JGGXaFyvlKzHfw=
X-Received: by 2002:a05:6402:2054:b0:5dc:e09f:d069 with SMTP id
 4fb4d7f45d1cf-5de5bf43e67mr177841a12.6.1739206712123; Mon, 10 Feb 2025
 08:58:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
In-Reply-To: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 10 Feb 2025 08:57:55 -0800
X-Gm-Features: AWEUYZmZq810A2nkZIkAKPj4stps_q_lRKH-4FpQTq4FT9GxN7r_QaAqRE1hH8U
Message-ID: <CABCJKucmOTVF1jY3vM7VKHuLkDeUxK1EU7YK=C+vgfWvgZFWPQ@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: do forward error correction on metadata I/O errors
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Akilesh Kailash <akailash@google.com>, kernel-team@android.com, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Mon, Feb 10, 2025 at 7:04=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Do forward error correction if metadata I/O fails.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/dm-verity-target.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-verity-target.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-verity-target.c        2025-02-04 13:52:=
45.000000000 +0100
> +++ linux-2.6/drivers/md/dm-verity-target.c     2025-02-10 15:55:42.00000=
0000 +0100
> @@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
>                                                 &buf, bio->bi_ioprio);
>         }
>
> -       if (IS_ERR(data))
> -               return PTR_ERR(data);
> +       if (IS_ERR(data)) {
> +               r =3D PTR_ERR(data);
> +               data =3D dm_bufio_new(v->bufio, hash_block, &buf);
> +               if (IS_ERR(data))
> +                       return r;
> +               if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADAT=
A,
> +                                     hash_block, data) =3D=3D 0) {
> +                       aux =3D dm_bufio_get_aux_data(buf);
> +                       aux->hash_verified =3D 1;
> +                       goto release_ok;
> +               } else {
> +                       dm_bufio_release(buf);
> +                       dm_bufio_forget(v->bufio, hash_block);
> +                       return r;
> +               }
> +       }

Don't we still have to check for io->in_bh before trying to correct the err=
or?

Overall, it would be nice not to duplicate code here. Should the
metadata error correction / handling be moved to a separate function
similar to verity_handle_data_hash_mismatch?

Sami
