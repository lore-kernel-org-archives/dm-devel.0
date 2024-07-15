Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9160318F2D2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721056482; cv=none; b=RLOw+Hs0LFkHqkj0rEkf+91Hw5qbNADOhL3GGMKtVv/lC+ZLIZrP2vW1C6EXuA3v9/akoVsHGHssxTDCWL0rI4MIbLUfwtyr4Y+9pvWPjn7jIN5ifrpGrH7NNm899lbd7NqbhirJ9ZbaS+U4PST2BYM1kxr53ziQySK4n/EqniM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721056482; c=relaxed/simple;
	bh=q7uBL9loXkZ4nzG7TyQNfQiP4l6G47SVp3wo1y++fyw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LMwcnstZebbLzY1MmqNFjI+4lSMy8nq0yyKTQbXkV07j2E8ZHfszu/v0ayqOw+o+gS9rl6JTu2x6V6dWSpJ3nWW8Y4/gVBk0QS1rv8EeqemOxqAYlzPcZ7jM/kJIqb+wZ2ZaRWUi8kMg7a3iMjKtw2ALW+lyPCAmB+JQD08tY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GC5IWYAM; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GC5IWYAM"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-427ad8bd88eso8192435e9.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721056478; x=1721661278; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q7uBL9loXkZ4nzG7TyQNfQiP4l6G47SVp3wo1y++fyw=;
        b=GC5IWYAMwSJMt7i2p9La2jgPVa7uY4ayJUusysRKpBWScFRPImnE7rJ2BcI9LZC1/l
         uzc9SO/sDkEtRsK8RTxpBNuLQ/WRdjdyUWfZzmELWOf/28tdZUZzqH1L+0Z+byb9ijhi
         +b+pE4DGp3+NmH4DsP7TP3HAZt3GzeUQk8OhrJbIuXvGcgsqrcIPEHMmEo8X7HWKamFp
         nJEUjH5/fh4bJdcoaK14NyuCn2xni5IL6YMfXA4+X58jX6/P8VhSF1EC/puwzNb4FZur
         1rhgwZpQZ8SHX8vFsKJDKw12C9QV1L5/ybtARKRyToug7gWSIcV9QNA39j+jyQWIGSYp
         20KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721056478; x=1721661278;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7uBL9loXkZ4nzG7TyQNfQiP4l6G47SVp3wo1y++fyw=;
        b=JilZrQ4KON2feda+U5lIGpD7tT4lMirSKynV5jONOcJAZXpQiho3UeVSEsfYOUUaNl
         cuMMECDnW32XDuzjEw8fp3A0y6Q4qKz6ffTV0a2ziQZIqijv9jEt8eGtxnUCNNlVbklj
         FJMq2qmGnD2cVUduye+ASyLsBwjQfnZapnV3s8M9nAzbiMkMrzI+jkB3RecgTmT5R+e0
         Lnk2s831xVGZIVAZCFJWR0EzxO2ITjiAaHdWZtDYh+pmvFRNKReTJmvqwdf+wbPBH/9+
         dagx0B6d8GAMwHKYuKQIxWNjRYNu6DYNdUuDEsCE/Mso6bV0Q/pbl/r6nAJP+i/5CC2E
         ugKQ==
X-Gm-Message-State: AOJu0YxenyHZasmAUGiFLH/O/CSWEuyHBh89IKrKVk5KT2acA+EQyR5H
	GrRuKMWT4ppS1Hna3gQubGFsrkZzlg1K0ReZOhXnkMqO8fGEAyimlbGRz7ICqclfLSq+bPug0nu
	s
X-Google-Smtp-Source: AGHT+IEySpwvPITFadi/ws61xD/a1wQH3S6jQjn32gPy7hpEIrXwE51mXiNncsJZDm9NeJnbxgF/VQ==
X-Received: by 2002:a05:600c:33a4:b0:426:6551:3174 with SMTP id 5b1f17b1804b1-426707f7e3amr147215745e9.29.1721056477684;
        Mon, 15 Jul 2024 08:14:37 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2d6ef8sm124505895e9.39.2024.07.15.08.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:14:37 -0700 (PDT)
Message-ID: <b4d185692c0f968926e158bbfd547aeeecf56b62.camel@suse.com>
Subject: Re: [PATCH 01/22] libmultipath: rename dm_map_present_by_wwid() and
 add outputs
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:14:36 +0200
In-Reply-To: <20240713060506.2015463-2-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> add arguments to dm_map_present_by_wwid() to allow optionally
> fetching
> the device name and minor number for the devices found by WWID.=C2=A0
> These
> will be used by a later patch. Since it can now also be used to get
> the
> name and minor number of a device from its WWID, rename it to
> dm_find_map_by_wwid()
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/devmapper.c | 16 ++++++++++++----
> =C2=A0libmultipath/devmapper.h |=C2=A0 2 +-
> =C2=A0libmultipath/valid.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0tests/valid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 12 ++++++------
> =C2=A04 files changed, 20 insertions(+), 12 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index c28991fb..1de694c9 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -132,7 +132,7 @@ int dm_simplecmd_flush (int task, const char
> *name, uint16_t udev_flags);
> =C2=A0int dm_simplecmd_noflush (int task, const char *name, uint16_t
> udev_flags);
> =C2=A0int dm_addmap_create (struct multipath *mpp, char *params);
> =C2=A0int dm_addmap_reload (struct multipath *mpp, char *params, int
> flush);
> -int dm_map_present_by_wwid(const char *uuid);
> +int dm_find_map_by_wwid(const char *wwid, char *name, int *minor);
>=20

Nitpick: According to my personal taste, it would be cleaner to pass in
the entire dm_info structure rather than just the minor number. One day
we may need other fields as well.

Martin

