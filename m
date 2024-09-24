Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B6C1DFFB
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727199843; cv=none; b=tKyvt+nn6Xt6qDzCcSX6CMm2cSZqrRMWlZWIrhbam5w2lsI8fPCVn50posWW9DwfJQT10ZoVoxTV9wDZ26DQpvf7RzoxHBd7QUfIcEjbkzLhueUfM0HAmYWsHKkyw8kPGGHLY05SiZAsaaS5UMsb2CCvdSZki8GNHaLJe9Lahfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727199843; c=relaxed/simple;
	bh=h8tJ3ilMw7uyYMt3nB7rKVUMfYkV2YkfPWZ76EEYScc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpgOMzmcgRQdjzHXIH7BFUA3alC7vocECnmRVM/CJooVBtjYkA/JLyYXxRmLwuahgMTHEUEHY1GEZ4KSA6vpLg55F1UHwxBJFyqDp2y8vhtTmHkSIn4uUV/QW/oaVwx4oVO8pt+A2HPNRfOa0Qn2r0FUhQX9Q3NjvFhWch/EuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6LsmoI6; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6LsmoI6"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4581cec6079so24551cf.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 10:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727199840; x=1727804640; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yI2pZJcKEpz6X5PCvwvhcv8WI8uwOBp6YQJ41qjGigA=;
        b=I6LsmoI6j/u+J1+hncec1T3fwwIyogFXeRqTnJ5ptyeCL3xAUQiuG1wFSx/K7INco9
         9rMLEsLPAEpKXw1x6vx3ujD5RHCtp3ZZogM19a5SHQO5UwP+euZEZPPNok9wUHXzXvHU
         yYq3pURlQP63OD+8g2VMtbBI4Dk0StCf4hPehxzVxkhnI7QestvfNgrXzzynzAhQOxcr
         PqVL7eCmPbF5wz46OfyS5acUJgEz1VqkqpsTupF4Ky01DlgcLk9TCSBCLG0kAnGFpBZO
         qO1R9Zlk+d/dA27sNFKCjDyQQY92vCzVQGDsosea2avwVAQnrNBEzfOcnGEnpD48o94s
         MTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727199840; x=1727804640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yI2pZJcKEpz6X5PCvwvhcv8WI8uwOBp6YQJ41qjGigA=;
        b=NyC6/8qJLZM2ONUBNuXE5zYtAcvctdocI6o4uKEs0XtGMSfvBMJKCTF0oL7619+kzt
         XjHZUjYS+f/6402y5RslCFBckm/KtXjIWhDBZ/bVvaB0qOnxrE5v8qAqjhF/KinHIEeY
         fvCMtUyd+UyJ2acNKv2L3MElRRLeQ4EThRDRAs0IJyxwnVwDkmclgTTGJGBjZRoL7bUp
         jOFfldJwHmnOJyLpgfTnhztbynJ/n2lGpbDDesi/nKyKgpv9aFpRaXpmnzfreUaWj+2O
         Pi+MO90LxFHPLf3cBF2UZ2/1MxX2n7/N6y+2xH8x8z/H1LTPtwlia5fdIOnTXDSg25Qv
         sC6A==
X-Forwarded-Encrypted: i=1; AJvYcCUHKssfuNd6Aas/dezTFIh1Jht9PmSbXm3gwBEDYv6aQG5171eXszjcmWNJBIniaw2NkA/tBOHRwQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz2HFIzBJonsQAnoUcgkj2nPnAVH+G9TQfLbDrwbSNuV2txSKz
	35zfcshXzrlv45YOi9XITu6iU5uce/RVsK0lypAw86gohnOL34Wk63yirTGSzMXrZdAnfaWCWiJ
	6gmttwGmN7SViP5D9jo3LE7YTjvYwpMvQbuOh
X-Google-Smtp-Source: AGHT+IEwtoAYjSnTirdfdUMoP6m5CjBVSN2sz5eY2jvuHm0cpBIgY83rWHfVrHeZnLTnIDlfQLH+rgFwf0Mpxk3MLKs=
X-Received: by 2002:a05:622a:4d4:b0:458:14dd:108b with SMTP id
 d75a77b69052e-45b5233364fmr3143661cf.13.1727199840265; Tue, 24 Sep 2024
 10:44:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
In-Reply-To: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 24 Sep 2024 10:43:21 -0700
Message-ID: <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>, Akilesh Kailash <akailash@google.com>
Cc: Maxim Suhanov <dfirblog@gmail.com>, Alasdair G Kergon <agk@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
	dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mikulas,

On Tue, Sep 24, 2024 at 6:18=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> happens. In theory, this could be used to subvert security, because an
> attacker can create sectors that return error with the Write Uncorrectabl=
e
> command. Some programs may misbehave if they have to deal with EIO.

I seem to recall that this was intentional. We used to restart/panic
on I/O errors with FEC enabled, but the behavior was changed in commit
2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
errors"). Akilesh, do you remember what exactly was the issue here?

> This commit fixes dm-verity, so that if "panic_on_corruption" or
> "restart_on_corruption" was specified and an I/O error happens, the
> machine will panic or restart.
>
> This commit also changes kernel_restart to emergency_restart -
> kernel_restart calls reboot notifiers and these reboot notifiers may wait
> for the bio that failed. emergency_restart doesn't call the notifiers.
>
> Reported-by: Maxim Suhanov <dfirblog@gmail.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/md/dm-verity-target.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-verity-target.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-verity-target.c        2024-09-23 17:48:=
08.000000000 +0200
> +++ linux-2.6/drivers/md/dm-verity-target.c     2024-09-24 11:34:08.00000=
0000 +0200
> @@ -273,7 +273,7 @@ out:
>                 return 0;
>
>         if (v->mode =3D=3D DM_VERITY_MODE_RESTART)
> -               kernel_restart("dm-verity device corrupted");
> +               emergency_restart();

Can we still log the reason for the restart? I remember some folks
used to rely on the "dm-verity device corrupted" message in the kernel
log.

Sami
