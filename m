Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB627096C
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="WBaGNm4w"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-db5e5647c24so1252068276.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1701899573; x=1702504373; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ad4QKqllEurVWf/Pv2WnyL7sj04ktRUEA1KwimHLGBw=;
        b=WBaGNm4wfsHMV3ctCr5WUIywVacaJnU56ryyv4A6wa/HwtaoxAmpsFuIkPLmgxUypc
         YYQ3sYp4EBwoaecNan/OPJM8CIyj1xziS9YUqCcGlU6oBuFySBsEboejm/akXbC9IsIv
         1bjHZSAeJ3yDJnA2uwgJbVfoLQXxyYSIM9NF63SvCIF+JBlEr7MNcUQ0DNNUi+49n0Cx
         ch9dqtcmbMk2OvILKL3tcHwtVh4LIlAxRctUeb4DPKDrbYvLNwb3/ekCSgVp8YqmcjnQ
         JkdwqPf3NvAk5mKP872boMkaPZ4Zgfp5tVdrQKzWURrY/t9CFAuVTX/8jJoYUHhg38n3
         gziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701899573; x=1702504373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ad4QKqllEurVWf/Pv2WnyL7sj04ktRUEA1KwimHLGBw=;
        b=QhlgtF3BUVDQfzJCnRept23df7h1BOUIfa9vXkeTE9w0cESeVsWOYo1oHmEqMZ6fNG
         ggzr068RwMJuV2dH+Ux5dqbcfFLyglISI8uUtB4Jt8t3V2JF7N0N7qtQOK9fUbXuMFhB
         zQ0oO3KtojBYqZycYYLgty4FTcN1Ju4EwpA/kw6iMfEJSQdJlMKb80hB8BMEpVGRX+pg
         WuGJ7VJuUHmb5SZlj4G+OhrpFMm6uonCLa2zF/VuCq0ctyuNMkqEjcSc2UHVc3g6RlA/
         3SHUJTQsJQUZSur8v8451qTbPX47G64fAhYS/NScRYgMnDUSvJxaQCA2giJoUB8ZPiB0
         pHtA==
X-Gm-Message-State: AOJu0Yz0eNAyartA1ZUXSgQqoZzFVap7iygo6pGCgMLNafI6VdpGsE8g
	Rt5OKyI8PplJP7wwMYO5eeQboaNH32n8Za6Fwxy+
X-Google-Smtp-Source: AGHT+IEj7nPBQx69pTJuIU/DScLOgVaCvMx3IAuTkYQQJ5vMAh2Hehp1yFZ/6ct0anbgpUrLprVHp8nDNRkJVZqoN6c=
X-Received: by 2002:a25:ab66:0:b0:db7:98ba:2468 with SMTP id
 u93-20020a25ab66000000b00db798ba2468mr1505130ybi.28.1701899573074; Wed, 06
 Dec 2023 13:52:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206060629.2827226-1-david@fromorbit.com> <20231206060629.2827226-6-david@fromorbit.com>
In-Reply-To: <20231206060629.2827226-6-david@fromorbit.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 6 Dec 2023 16:52:42 -0500
Message-ID: <CAHC9VhTP3hRAkmp7wOKGrEzY5OXXJpnuofTG_+KdXDku18vkeA@mail.gmail.com>
Subject: Re: [PATCH 05/11] selinux: use dlist for isec inode list
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev, 
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 1:07=E2=80=AFAM Dave Chinner <david@fromorbit.com> w=
rote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Because it's a horrible point of lock contention under heavily
> concurrent directory traversals...
>
>   - 12.14% d_instantiate
>      - 12.06% security_d_instantiate
>         - 12.13% selinux_d_instantiate
>            - 12.16% inode_doinit_with_dentry
>               - 15.45% _raw_spin_lock
>                  - do_raw_spin_lock
>                       14.68% __pv_queued_spin_lock_slowpath
>
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/linux/dlock-list.h        |  9 ++++
>  security/selinux/hooks.c          | 72 +++++++++++++++----------------
>  security/selinux/include/objsec.h |  6 +--
>  3 files changed, 47 insertions(+), 40 deletions(-)

In the cover letter you talk about testing, but I didn't see any
mention of testing with SELinux enabled.  Given the lock contention
stats in the description above I'm going to assume you did test this
and pass along my ACK, but if you haven't tested the changes below
please do before sending this anywhere important.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
