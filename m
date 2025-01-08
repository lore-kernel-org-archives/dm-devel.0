Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A71F239A
	for <dm-devel@lists.linux.dev>; Wed,  8 Jan 2025 09:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736329341; cv=none; b=MAnRduKP2IG3Qpt8Xj1Dud1vu7/UZZsSNqQboq2x8spibIqicOkAYkNyJd2qDOGCILpM5V152QRYwaLDeelMQHnAmrTu/hijiMIEK5ioG9m/+3haSJahDAtfNZWDuMNtfrPD7WTsvTmJ3NxxPSAvY9uBHbRaJVj3QyBOya3RTxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736329341; c=relaxed/simple;
	bh=v+3Qj2dqP5w0z8w/UN5maUL50BegfyzxgYxplSesaXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4LVXE1cDxiW2tBTsftk3oMt7TstDPb3oCEPjWskiAletczrebjPaMhl61vVBr9EL62TkC+qDdOQwxqKJAFM+IBIlZbG11uZeznmCotJOvg9pNbY1QT/Ftbyy3JHFXik4sVNNzrWLlkHHpHWdeTZxxbUsmbI9Q/UcdZEWitOd7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEXUVCyb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEXUVCyb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736329338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aa0nAvG3TWkHM+fMkevvKFV+durCMFFktIc5f+x0GfQ=;
	b=eEXUVCybLFHsyaMSG9FBViLUtrDTJxAo58fBkQPW0gcJSXfiYtTbH6Mc/vqQmjlqBG9l8Y
	llbYVxoe0V2+BYkOtNyvJT5iei6qPjxrwI0STeRfA6elZnOz6YcYZ2mKqBTpqN1Mh2QYqK
	0hD+dYH9Vgch9MlQEkDVVmSrfZbSDiM=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-b3RkKsGjObK5TstDr-e5Yg-1; Wed, 08 Jan 2025 04:42:17 -0500
X-MC-Unique: b3RkKsGjObK5TstDr-e5Yg-1
X-Mimecast-MFC-AGG-ID: b3RkKsGjObK5TstDr-e5Yg
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-71e17fbb9dbso945042a34.0
        for <dm-devel@lists.linux.dev>; Wed, 08 Jan 2025 01:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736329336; x=1736934136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aa0nAvG3TWkHM+fMkevvKFV+durCMFFktIc5f+x0GfQ=;
        b=KATAjAEpoD6MuPMhv5bZ8GZuJ3nsr3pdVw+43AKDDiujBMfg7oqw+OU7+EBqryYthf
         GaIQnPmLUl3Gnmw5My0M3qI0dZQ6NiXJLxJ2bjxYBE262e1yYwcuhKMkKMq0+1f02rqy
         ZS7oEtV5K+LTisAUYaNqKFWdSxbSm71opzDQSm03vWsS+60mx8r5w9OV97ULKJicQrTc
         3bPt/c5lNT+pFE5Zl0oNHy/Dbul01jx5v4gVnIdIV5JjvkODOd47kJd0V6pKKHOPQW1N
         Xy1Gb5jY4mwv8XNtek2xJdk/PgOrlijY7h6tZtQKFK1JIBWlpNDJmSqEuc3FfQcn2oEz
         kX9w==
X-Forwarded-Encrypted: i=1; AJvYcCVvZDyo4Y96BQYRk1M0lNwaAxYSNGsV+dUlEoyqmgrGoXhocSlHVSPqytL3wKa2Q8V0LLPty8UPrQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwkGEsj9/gi8Gc8j168KEDanaPJQMIlhgR0ohsi+a34rzZi0LYm
	swQ0EfffPVwVRo538Z1zUjZnuv49td7dc47dF5mM3/DAXtP3bUKzoAhsvmC5Z29nBr1QlPZbdNK
	smEEU5/ENbEEdacaUeEn7GEXo9wx5ZoxQNkjAruPx1oh98BtRLlaUKzBsfKf289YnAPWt9FrAsG
	Euqi1mOi3l/xdsPDAOVAmnNDbgUtjazw==
X-Gm-Gg: ASbGncvUbQxYb7YOZrScwHcnJeYCC8uTdz8vGPqQJ1rbGpC+QDjfSAsoeNzxHOyamcV
	nfovMJXZrA+YdOvtFqLMnCMYd5+SJsGoz9YAhxL4=
X-Received: by 2002:a05:6830:6c84:b0:71e:f1:3e6 with SMTP id 46e09a7af769-721e2e583e2mr1197570a34.14.1736329336537;
        Wed, 08 Jan 2025 01:42:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqzdIh6uupaQt7lC2a8bNkwTK+XGMXIb06APFw5YnMqXCFE2zeV1RETHbbGhrpDmmJ77PAarUuYeZvJRez5OQ=
X-Received: by 2002:a05:6830:6c84:b0:71e:f1:3e6 with SMTP id
 46e09a7af769-721e2e583e2mr1197546a34.14.1736329335410; Wed, 08 Jan 2025
 01:42:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250107232458.GA1860@templeofstupid.com>
In-Reply-To: <20250107232458.GA1860@templeofstupid.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Wed, 8 Jan 2025 17:42:03 +0800
X-Gm-Features: AbW1kvZsb93QmJbYrFqYmKA8bI7lHcpUW7uDg8Ojmxn5qxFVORAdeFdX5o3VQoE
Message-ID: <CALjSBEtMxj59rDGz3NdonXiSCwfRSYn_q=FbirRYr8a6o-1Ucw@mail.gmail.com>
Subject: Re: [PATCH] dm thin: make get_first_thin use rcu-safe list first function
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>, David Reaver <me@davidreaver.com>, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NeQur-O84D1Ib3WNpz5BTKeuaee9WACeWHwR_zvNI_M_1736329336
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 7:52=E2=80=AFAM Krister Johansen <kjlx@templeofstupi=
d.com> wrote:
>
> The documentation in rculist.h explains the absence of list_empty_rcu()
> and cautions programmers against relying on a list_empty() ->
> list_first() sequence in RCU safe code.  This is because each of these
> functions performs its own READ_ONCE() of the list head.  This can lead
> to a situation where the list_empty() sees a valid list entry, but the
> subsequent list_first() sees a different view of list head state after a
> modification.
>
> In the case of dm-thin, this author had a production box crash from a GP
> fault in the process_deferred_bios path.  This function saw a valid list
> head in get_first_thin() but when it subsequently dereferenced that and
> turned it into a thin_c, it got the inside of the struct pool, since the
> list was now empty and referring to itself.  The kernel on which this
> occurred printed both a warning about a refcount_t being saturated, and
> a UBSAN error for an out-of-bounds cpuid access in the queued spinlock,
> prior to the fault itself.  When the resulting kdump was examined, it
> was possible to see another thread patiently waiting in thin_dtr's
> synchronize_rcu.
>
> The thin_dtr call managed to pull the thin_c out of the active thins
> list (and have it be the last entry in the active_thins list) at just
> the wrong moment which lead to this crash.
>
> Fortunately, the fix here is straight forward.  Switch get_first_thin()
> function to use list_first_or_null_rcu() which performs just a single
> READ_ONCE() and returns NULL if the list is already empty.
>
> This was run against the devicemapper test suite's thin-provisioning
> suites for delete and suspend and no regressions were observed.
>
> Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> Fixes: b10ebd34ccca ("dm thin: fix rcu_read_lock being held in code that =
can sleep")
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-thin.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index bf0f9dddd146..05cf4e3f2bbe 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -2332,10 +2332,9 @@ static struct thin_c *get_first_thin(struct pool *=
pool)
>         struct thin_c *tc =3D NULL;
>
>         rcu_read_lock();
> -       if (!list_empty(&pool->active_thins)) {
> -               tc =3D list_entry_rcu(pool->active_thins.next, struct thi=
n_c, list);
> +       tc =3D list_first_or_null_rcu(&pool->active_thins, struct thin_c,=
 list);
> +       if (tc)
>                 thin_get(tc);
> -       }
>         rcu_read_unlock();
>
>         return tc;
> --
> 2.25.1
>
>

Acked-by: Ming-Hung Tsai <mtsai@redhat.com>

