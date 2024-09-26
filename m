Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BCB4C79
	for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 17:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727372009; cv=none; b=qzIaSIPScc3EYQj06OVGZ23+Lj2P75WNaMUuKu5lT8TlEqHfkAWr1VZu9ryILLu+MroQdqgLuAqsKKnhAoifg9o05/G0Up0VdoHjlto1DBQhpmLfDoIAd0JcRQpNmGMyszq1lPBzS3VOY2fh2Z3lOW9iISnvCFtwlgzhxS2der4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727372009; c=relaxed/simple;
	bh=7VwmsGwAeM/A1Xn3ZFro157WcN0f/ds1QV5/vjaATMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TP9KF9Yt7Ls7XMOUsYHOFk2Mgj/mgq1WkqonJyAsmQDnpzGjnmp4xzHhrtT+uOPyOfVrQG8DollOoT0Oq9XVh2m2+/XZZ8Q5kpFlp+gDjBMXGbarHZkSFasDq9xQMUcpuGNqktj+Zxxll7ME+eC5jKH/dNEWBtrRF38txlSvdog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N23wEyNq; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N23wEyNq"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4581cec6079so24441cf.0
        for <dm-devel@lists.linux.dev>; Thu, 26 Sep 2024 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727372005; x=1727976805; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hae4euGWnjPjR9P9BzRKKkm3YyHnHipu8YNwS4JGpd0=;
        b=N23wEyNqCdgtdz4SxeonIDZvFTeDrAJ2IVta1wQgla3xrXkwzpBFkFW72lCUw9FZHe
         UpTTVUrwP0UYataCuksEMfFpbj7ppECQusqTpJy7aWL6bqgT4F+TIe8zSGtU+yvYJFZe
         2iXUbrNMdoTnM8SVawRGHS2b+5am2cyr5qAPxEbXii1FnG4ik+Sj3UVqf1xru1r6AluK
         jCLqbMQ9LQdGE5Zjj1jUaipo60l30VuQ3PjbWBZfQnchADgzO6BWtrnro9/m298u39Ni
         ADs+iw1UlI2oJ4EdcFLHqWRUL1GblfNd4LVZgWrZ5aETW8PiyfGt9NZtgcrQLnN6X9dS
         pHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727372005; x=1727976805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hae4euGWnjPjR9P9BzRKKkm3YyHnHipu8YNwS4JGpd0=;
        b=oCjcy6lB6C2ycYGPVxxXd8PE9tF2MrW4yy31uBgUaViTq5w7J2bD1JIDOPogypQzA+
         SM4FYZf1IPNjyVG7+WVFafo57pz7R4N3x8QExiq0tWGpElpws6iSwDDBUXymeIktZIyN
         yEdCrI+4itfAHXttmO293EvOgl4Ey+CKlQBDjtjCg0i0MD/VTrifPU6a59XN88OAqc5m
         saryf8jGqMa4YqwNKg2ofRbPN9L/QcSWC3QbQNed3BeOugBSmDuHbY8HYZvcURN5I97y
         HgY05bE+5yc+96UzgRAWXi9ayJdYsCNRC1Xd2IsLiGm4tSjX/qoOAbUwdGGdq46g/WxW
         K7mg==
X-Forwarded-Encrypted: i=1; AJvYcCWhSMEAzrR8QWkMXp1yWiJCR3Lozq//7zmuVzLhyMv8yTiQA/NDLNLSFTX9T0hby5ZJ6BZwkclHbA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmD8WiMa/wNQ4q5g6/ujwhvhexBPnp7aLzj8UmB0ZU/g+Y11j2
	DyY6rSQ6yVBgvFU4etRH2vBmn+gbWc7uXc3Twvlf3eTlWk3JlF9XtQiax/lweEOC3YkAJxB4Nt9
	OWgnmjK5RrEfk0s9MbdMpUKGlY7Htcbjfg768
X-Google-Smtp-Source: AGHT+IGUxbIA4dGmFSAkrfjI7jHtGxl3yYXPxLoc1PE9R1tGyBEfemdr2Qb1DX7N16U9EzNkr4jY5STCNh5NdJ/XHmM=
X-Received: by 2002:a05:622a:a110:b0:447:dd54:2cd4 with SMTP id
 d75a77b69052e-45ca025fc88mr17041cf.22.1727372005013; Thu, 26 Sep 2024
 10:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com> <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com> <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com>
In-Reply-To: <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 26 Sep 2024 10:32:47 -0700
Message-ID: <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Milan Broz <gmazyland@gmail.com>
Cc: Maxim Suhanov <dfirblog@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
	dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 11:35=E2=80=AFPM Milan Broz <gmazyland@gmail.com> w=
rote:
>
> On 9/25/24 8:09 AM, Maxim Suhanov wrote:
> > Hello.
> >
> >> This is a very strange reasoning. I can say that restarting on an IO e=
rror
> >> (that can happen in normal situations) could cause another security is=
sue,
> >> such as DoS. EIO is not a data integrity error; it can happen even hig=
her
> >> in the storage stack... and the application should handle it anyway.
> >
> > In the default mode of operation, there should be no panic/reboot on
> > an I/O error.
> >
> > The issue and the proposed patch affect the non-default modes:
> > panic_on_corruption and restart_on_corruption.
> > Users relying on one of those two modes expect the system to crash if
> > something goes wrong [1]. So, DoS is expected here. Returning I/O
> > errors to the reader isn't something that is expected here (see [1]).
> >
> > The issue allows the attacker to "downgrade" the "panic_on_corruption"
> > and "restart_on_corruption" modes to the default one by creating
> > unreadable sectors on the underlying media (e.g., through the Write
> > Uncorrectable command).
>
> Sorry, but I do agree with this.
>
> Panic/Restart should happen on data corruption (or failed Reed-Solomon
> FEC data recovery fail). IO error (and other errors that basically transl=
ates
> to this) can mean something else and userspace application must process
> it in error path (think about network failure).
>
> This is how is the dm-verity flag is documented:
>
> restart_on_corruption
>      Restart the system when a corrupted block is discovered. This option=
 is
>      not compatible with ignore_corruption and requires user space suppor=
t to
>      avoid restart loops.
>
> It says nothing about restart on other error, that can come from crypto, =
network
> or whatever. You are redefining the policy here.

I thought about this a bit more, and I agree with Milan. I/O errors
can be temporary and applications should be expected to handle them.
IMO we should trigger a restart/panic only if the underlying device
has corrupted data. If there's a use case for restarting on I/O errors
too, there should be a separate flag for that.

Android devices, which I assume are the largest users of this
functionality, are expected to switch dm-verity partitions back to
normal mode after the first restart is triggered, and userspace is
therefore expected to handle I/O errors gracefully anyway.

https://source.android.com/docs/security/features/verifiedboot/boot-flow

Sami
