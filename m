Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D125628
	for <dm-devel@lists.linux.dev>; Thu,  8 Feb 2024 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707419242; cv=none; b=JJzZjazVzX0aqF/qXUs963vp9NbpdCvnC/GvMiESksMoGujEuEjmoE039mOZ3LFAo5VtBmhGOJPbGeyaTVcA+HV6p9ZhJj86dQfX4fB+vHEGoadeaZS4r/qRDlU9ZKjOXa+NEAbU8SeJtPA3BnUtT3m3J7HVkmLSvhEOuRmsxuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707419242; c=relaxed/simple;
	bh=AZ6nQb+M1vD/2zX5upW9ouxqeYE6QGKcCE/8DY0UebQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wst6HFgdfQKja+5yM+pEqcU4pN9446gke8AYKiCpQiEUmYMRF8GAJfMjecXX7J2Q1RoN/c9WI5nAFtVVM8ZROsSPovZdopksDQTO5uTlx0ZmbyzzVhBrHMiQXp1yX/aW56HgiQ2Kzoidhrou8yqeG91v3CmJkYU7Gnm/2XeJyJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8UJjf2k; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8UJjf2k"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3beb504c985so45716b6e.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Feb 2024 11:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707419240; x=1708024040; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=202GKaA8C1i5cx4LlHBZXcPKNf6nXe/ES82zbqrpd+0=;
        b=X8UJjf2kOHt1/pz//iseSqcaJeMn2Rx2l/+whbfgKw1oLo0ex1USqXftnJbqe5SJEJ
         UBjQzUa1Rq/Mm7l3txQjREMVSfUumo2w4vJxYZ3O4xrP6NWlyXAcG4ECstkwDyDygvXF
         FxIbK+969OQmGx/VU4Cfs3PPZRxXOfaya99I7+EMZuS9oWcMvOk98Ipktc92BVa7sIvF
         bTFkz3SiuWxgERK5QI3oQ73vjfbgNnKtzEBwWq7dsJ4LRGZetfRXosrOceAN78bWO6ND
         nrPgKipovr3q0Qjv+QFB0QwKupNIMFdcP4UJA4yQ9Ad9NqeNeYULg7gOlkGOf+v1+oY0
         o5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707419240; x=1708024040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=202GKaA8C1i5cx4LlHBZXcPKNf6nXe/ES82zbqrpd+0=;
        b=QNEMYj4RMxYx/S1UFgy1oJ2B2HqbYfsQPrEZEr8KS7pkzjxeAqnxjhR6zMPN29PlLo
         4FVYvdsR8F1aSm1X0dUexpB2EwolDwzFK7Ey3zcDbDCmKXdNyfjME+J+iJ3d+t4C9sSx
         c2RqAdoQEgQIPhrqQgWlUF6CK2OVP8Lmi+gL/Wx78MiI7VUCuIbqGKSQSwVakaNpeHLp
         1kk8O9OUJQ28UpIBnc0Qbq5Io9EkTBYNiXVvXM0i6+sSW0i9GdO8O//+v7lsvWckHN1Z
         VhQpx3q9Ko+/vc0Z0z8fjl/UuefdH7AUmQyFGiyl0h28o0z9TOOZGNVkRXkDOhobtlS6
         DERA==
X-Gm-Message-State: AOJu0Yx7NKDiGBrBJNB0aEgdJCJ24Mg/KbgLOgMtLljRJZ3rtG/o/c4p
	Hq2h8ta/eHIDvlbv+a40n1Y6Pu/0jHjitH0lDZVO/WGNQsReTWcprbbNnfzG2sEl8EEVndPPiUu
	LK5Pf3jLC1GkguaaV60/48yK1a3w=
X-Google-Smtp-Source: AGHT+IF9hg109QvfX/FVAlSXVFZcAMD4vHPe8lrRCgMgpJ1NJrDk5BP2mYMHYbEPaTJSq92jJEG9nWdXOHPoWqKh+5s=
X-Received: by 2002:a05:6808:1524:b0:3bf:f3a2:cd8f with SMTP id
 u36-20020a056808152400b003bff3a2cd8fmr279809oiw.41.1707419240598; Thu, 08 Feb
 2024 11:07:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <ZcACvVz83QFuSLR6@slm.duckdns.org>
 <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com>
 <ZcFPKaWwxJhgy8HQ@slm.duckdns.org> <CAOMdWSKQC4UWXp57qubcSOHmPj0E7wHZWWbCz+yCZqROhoPSGw@mail.gmail.com>
 <CAOMdWSLF9AaQF0ux03-tonw-Jy+4rXdKEZGzPrp_v+fnas6SnQ@mail.gmail.com> <ZcUHsHzlLpE7meaW@slm.duckdns.org>
In-Reply-To: <ZcUHsHzlLpE7meaW@slm.duckdns.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 8 Feb 2024 11:07:09 -0800
Message-ID: <CAOMdWSLP1HxnD9JsQMk7ZU6fvLfUmWz1CywqY5ZkyiUFUTALoQ@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 8:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Feb 07, 2024 at 11:02:37AM -0800, Allen wrote:
> > https://github.com/allenpais/for-6.9-bh-conversions
> >
> >  I am holding on to the patch that converts drivers/media/*, as I haven=
't found
> > a right way to replace tasklet_[disable/enable] api's. The rest should =
be ready
> > in a day or two.
>
> Yeah, we'll need to add something to workqueue to support that. As for th=
e
> rest, looking at the code, I think tasklet_kill() should be converted to
> cancel_work_sync(), not flush_work().
>

  Ah, Thanks for pointing that out. I will update it and get that fixed.

Thanks for the review.

--=20
       - Allen
