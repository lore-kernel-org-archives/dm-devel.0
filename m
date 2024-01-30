Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C9457864
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602075; cv=none; b=WWq3UeuaAuW+gN7IaNGRiFWQUbi3COBieSZHt8eluuw9TImxbagAJSOOOGBgcJrITf62tNMw92MDzX5XOCW60O6dsUWz0hCwdYtddm931eisNta4ekh2S6jATOstSbrkeda+x9xmeYSr960EunTyqBNWwFanEp+ykh/s1PJHH7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602075; c=relaxed/simple;
	bh=LS6u4xlhfc/imdG9R2klrvCplnPPmmgsCXRohZ7k9BM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCUsGeUEP1YMisJs7xv8Ku7vsb7vEIq1ACJbukJiUx8VQw2YGVlnUcAkYVKs+vsi+uXZQQe8MTXXWEfrvRJTT4/Hv+ckDo0ODD4WGAq195edIk0/1dv98Dq+ydCgIH09WqIkW1w48zvbSbxt9NRt3rZODXiiq9CeEoRHZb4g4n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=CpCIJaIN; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="CpCIJaIN"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ddc1fad6ddso2998151b3a.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 00:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1706602070; x=1707206870; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LS6u4xlhfc/imdG9R2klrvCplnPPmmgsCXRohZ7k9BM=;
        b=CpCIJaIN8vL8Z0N2IxyJQ84Har6EKBLWckOl9jt56gSdLlLMdQ6TAlLy8jRSoe0OPI
         NfSN4gNBhTlnYaWQ9fpSWfkOfxO6a5mC6RJpzotm1lROBjhtUtMitSdUCsc3alicyGJV
         DBcM4TExt5vfxaLtIvxjLet6qdoxLtSorYTxP0DBr6KtX6z7aUEvfis4c9LIGurxiH8N
         pxkJq6n7bQZ3kR8unGx6vqftA0PHEpRSh+X5pEnkSw2GacXMNKxFze1+Hh4iekA48DbS
         nYeWxoefR/Kd7dnm19xSRa/y6o2CJPZHUDA6QsaL6Fr3tId3Ac+oBdmENeDMgLdeOwqS
         Rgug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706602070; x=1707206870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LS6u4xlhfc/imdG9R2klrvCplnPPmmgsCXRohZ7k9BM=;
        b=xEoKtBxb8EDbFDYjTvpclXWP5jrkfAImD3RL0h7j/xSt1tmju5rmtSmQl6RyQ0n5aI
         pulk5wt53V/HzxR4+jRXxS8b5J4BsFKF1bos7Rx1Sj3Xha5XZvy2otexGsBMim859se0
         ZIXWZOLdjCZm+XBQWOdGpPFTdGhPsvx/iKzkaQMbTnnaf68+rkswZ4Osb4HX2TLX5sxn
         LuKAUDxozlG9MGhCtg6uK3pci26klSOBgZfeaVRNr0ySTkXtZSSh/GuVs9b4S5Jr5m4p
         Icgyh7qpORRAacTiqFvDJXwQkEzeaBZmMYQcR0BZo2w/dIDClH3uIE9WJvx0yuAwcLpq
         9Alg==
X-Gm-Message-State: AOJu0YwuF3wVrM+N1/jWx/dq/2hoGiPFkob5jl6f7N9JS3mKRI+pXypR
	5hUm2kN8EgRFnAofj5sGi1U5jptqPKRJjqX7pDc6knqwoolScUTNYBLSVG2L45tNDnZ7hW6yCg2
	MkyQ4+hgKn7zlnt22xi+MU50XgNFGqqnHaMOW6A==
X-Google-Smtp-Source: AGHT+IHsI4jVxobGxsz2oLYacm9zgXyTSDWNoky7xsdYkbCaT3t12qj8UJ4uv+gZXYxS3zDOHAz8tja58Jk6r/Zp7hw=
X-Received: by 2002:a05:6a00:4fcb:b0:6de:40e:65a3 with SMTP id
 le11-20020a056a004fcb00b006de040e65a3mr6516997pfb.16.1706602070516; Tue, 30
 Jan 2024 00:07:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8213bdcd-2b2f-48c9-86da-ce3feeb37774@gmail.com>
In-Reply-To: <8213bdcd-2b2f-48c9-86da-ce3feeb37774@gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 30 Jan 2024 08:07:39 +0000
Message-ID: <CALrw=nG1y50LZUr_v4HfojmnzOOAMNycZ6xPkX-q+_cFkT8G4Q@mail.gmail.com>
Subject: Re: dm-crypt: Automatically enable no_{read,write}_workqueue on SSDs
To: Adrian Vovk <adrianvovk@gmail.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 2:14=E2=80=AFAM Adrian Vovk <adrianvovk@gmail.com> =
wrote:
>
> Hello all,
>
> I am working as a contractor for the GNOME Foundation to integrate
> systemd-homed into the GNOME desktop and related components, as part of
> a grant by the Sovereign Tech Fund[1]. systemd-homed is a component of
> systemd that, among other things, puts each user's home directory into a
> separate LUKS volume so that each user can have their data encrypted
> independently.

Seems filesystem encryption is better suited here, but I see it
already supports this option.

> I have recently come across a blog post from Cloudflare[2] that details
> a significant (~2x) improvement to throughput and latency that they were
> able to achieve on dm-crypt devices by implementing[3] and using the
> no_read_workqueue and no_write_workqueue performance flags. These flags
> bypass queuing that was in place to optimize for access patterns of
> spinning media and work around limitations of kernel subsystems at the ti=
me.
>
> Thus, to me it looks like these flags should default to on for SSDs
> (i.e. /sys/block/<name>/queue/rotational is 0). Such a distinction based
> on the type of storage media has precedent (i.e. selecting the `none` IO
> scheduler for SSDs to improve throughput). So, I was going to change

This is a different layer IMO. The IO scheduler is more "tightly
coupled" with underlying storage vs device mapper framework, which is
a higher level abstraction. Does it even have this capability to look
into the underlying storage device? What if there are several layers
of device mapper (dm-crypt->lvm->dm-raid->device)?

I'm mentally comparing device mapper to a network OSI model: should
the TCP protocol tune itself based on what data link layer it runs on
(ethernet vs token ring vs serial port)?

> systemd to turn these flags on when it detected an SSD, but I spoke to
> the maintainers first and they suggested that I try to implement this in
> cryptsetup instead. So I reached out there[4], and they suggested that I
> should write to you, and that the kernel should set optimal defaults in
> cases like this. They also mentioned recalling some hardware
> configurations where these flags shouldn't be on.

At least within our testing it is not as straightforward as "if you
run on SSDs - you always get performance benefits". Some of
Cloudflare's workloads chose not to enable these flags to this day.
With all the external feedback I received for these flags - most
people reported improvements, but there were also a small number of
reports of regressions.

So ultimately it is more than just a type of storage, which goes into
the decision whether to enable these flags, which in turn creates a
"policy", which the kernel should not dictate. I can see a world where
spinning media would not be used anymore at all, so the kernel
probably can flip these for everything to "default on", but more
"complex decision trees" would be better off somewhere in userspace
(systemd, cryptsetup, users themselves).

> Is there some reason these two flags aren't on by default for SSDs?
>
> Thanks,
> Adrian

Ignat

> [1]:
> https://foundation.gnome.org/2023/11/09/gnome-recognized-as-public-intere=
st-infrastructure/
>
> [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
> [3]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/drivers/md/dm-crypt.c?id=3D39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877
>
> [4]: https://gitlab.com/cryptsetup/cryptsetup/-/issues/862
