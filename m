Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C616D1BC
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706631670; cv=none; b=Ya6z2gAEdwuHvRUD2B2z/3eDkyALHyf87FwEq1hKxo/3ckaqK9Y3a4VCOXRr7736dFQtgzUeLVyXlr3sR1TA4J76XbdKyqtCmyIBI1V4Fw7yFQGZR7ElN4eSb5MAFv8jNrKNpDu8RnFFhXyTVFxM/jMFZhvTKjRSshGPQVk8Emo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706631670; c=relaxed/simple;
	bh=+bcm4mychQh8JqSAZW/4Ww5vO3vpIuICXknjo9wUp14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i28OmQnTfoLoZczOwptWpweR1jW/5T7y85b6onCptPTR+Gpww9JMqARuE30sTncu00Jetl2zjkUjrKjoIWm2nVW315nWKUGpI2hIlDPdklnPf1HUkXEz6Qiad/j8XTUg2XwrBgt6gfv8pxS1QeiLvWBAzRxGYCz51WMzWOq4A90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=JPwgbUqK; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="JPwgbUqK"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-295c8b795e2so290057a91.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 08:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1706631668; x=1707236468; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bcm4mychQh8JqSAZW/4Ww5vO3vpIuICXknjo9wUp14=;
        b=JPwgbUqK3DDbJU3ccZLkf75dOCqb8rAJqwDkQSCpQh6OGGAZRZxMT4EnKne91+KysW
         EHIhPW4krMl4SZk5efQFUuHNsBpZdkydQkvahsl9eX7FqU29ap7EnuiNjU+F5bS0tov3
         tRYFVTQi5RRt011MxQj6pkeH9dV+BjPkJDEvJpvOqqOwqWeUZEZx83dMcc4lcti+vQBW
         TzMsLI/PJ4SaqcsrZ3aMGLkltOejqJnMzlun6YKOr3ZfE5r0drDXB0zv09Bdk6hFnKqA
         vdALOEBfYFkLQke53RCeFDUiO0/SxXgxl5S2HzpGt8Ji+40iwxG9x1oAUnSAaOq+kr5X
         B7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706631668; x=1707236468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+bcm4mychQh8JqSAZW/4Ww5vO3vpIuICXknjo9wUp14=;
        b=wwvIZ7X+CRPvuMxx6kNBxAQd9x9sogM9FsiLSru5KRJCce2yQIyAMIghQgyKvR292d
         FdoAn+pIel5A0dd93OmxIzqYQy87OqAfzF3RfNTsG2yKuNv3eLTVXJNQUJk3WwaPWZI8
         AScdoTxCyxTmygYhMT1g+TUdfbiiKpf17wWSOwvaDWLduSdQ879EK+rtH9Iwaj23CMaU
         glfmXg9DsE1Vg6XNKwkmAe6JPvHLSWGoPLWk0uX6Z4/usE7ZbqRSk2IuKTnl9gSPkViD
         j2rX0DAmFTQvtNKerZUwFf7N/zwsectvqUsbUktMBWTpYeyK2mehudS4iL25jqM1Lzme
         BJ7w==
X-Gm-Message-State: AOJu0Yykd/UmO/izzqTF/StaD5IZquTbmyxNd27/HTp+cXwWxx0D3rVK
	3QtxO5syj1TldXx1QM0HBCLbIUm4TI4JvcE2xyODEo/BvSfSyy/QfUBfy9keZ6l4IIjH4rWPOJn
	7hLRFVsR0V0VOcfdMAOFwfyni0YYajcvkbqHGDbgWCpb8Ve1u
X-Google-Smtp-Source: AGHT+IFHGNQsDogochWRUHOAlsYjKLtlud+1hWWCm80MaNTPfAdixZHqvGdVUEG5tbh0pJGwKGwg+mCCVrkrmAjNVLo=
X-Received: by 2002:a17:90a:5891:b0:290:c0a:fccc with SMTP id
 j17-20020a17090a589100b002900c0afcccmr4613239pji.36.1706631667981; Tue, 30
 Jan 2024 08:21:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8213bdcd-2b2f-48c9-86da-ce3feeb37774@gmail.com>
 <CALrw=nG1y50LZUr_v4HfojmnzOOAMNycZ6xPkX-q+_cFkT8G4Q@mail.gmail.com> <13d33c62-35c5-465d-b5e5-dffecac6f4da@gmail.com>
In-Reply-To: <13d33c62-35c5-465d-b5e5-dffecac6f4da@gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 30 Jan 2024 16:20:56 +0000
Message-ID: <CALrw=nEpRc7m=bLmn6TsWzPo+gHR5uFwn85EOqAzsoCf73FpHg@mail.gmail.com>
Subject: Re: dm-crypt: Automatically enable no_{read,write}_workqueue on SSDs
To: Adrian Vovk <adrianvovk@gmail.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 4:10=E2=80=AFPM Adrian Vovk <adrianvovk@gmail.com> =
wrote:
>
> On 1/30/24 03:07, Ignat Korchagin wrote:
> > On Tue, Jan 30, 2024 at 2:14=E2=80=AFAM Adrian Vovk <adrianvovk@gmail.c=
om> wrote:
> >> Hello all,
> >>
> >> I am working as a contractor for the GNOME Foundation to integrate
> >> systemd-homed into the GNOME desktop and related components, as part o=
f
> >> a grant by the Sovereign Tech Fund[1]. systemd-homed is a component of
> >> systemd that, among other things, puts each user's home directory into=
 a
> >> separate LUKS volume so that each user can have their data encrypted
> >> independently.
> > Seems filesystem encryption is better suited here, but I see it
> > already supports this option.
>
> Filesystem encryption does not protect metadata so we consider it weaker
> encryption for the purposes of homed. Thus we prefer LUKS, which is
> definitely more complicated but it protects all user data.
>
> It's also easier to move a loopback file between devices, which is
> another goal of homed
>
> >> I have recently come across a blog post from Cloudflare[2] that detail=
s
> >> a significant (~2x) improvement to throughput and latency that they we=
re
> >> able to achieve on dm-crypt devices by implementing[3] and using the
> >> no_read_workqueue and no_write_workqueue performance flags. These flag=
s
> >> bypass queuing that was in place to optimize for access patterns of
> >> spinning media and work around limitations of kernel subsystems at the=
 time.
> >>
> >> Thus, to me it looks like these flags should default to on for SSDs
> >> (i.e. /sys/block/<name>/queue/rotational is 0). Such a distinction bas=
ed
> >> on the type of storage media has precedent (i.e. selecting the `none` =
IO
> >> scheduler for SSDs to improve throughput). So, I was going to change
> > This is a different layer IMO. The IO scheduler is more "tightly
> > coupled" with underlying storage vs device mapper framework, which is
> > a higher level abstraction. Does it even have this capability to look
> > into the underlying storage device? What if there are several layers
> > of device mapper (dm-crypt->lvm->dm-raid->device)?
>
> I don't know if you have convenient access on the kernel side, but from
> the userspace side we can fairly easily resolve what is backing a
> dm-crypt device by probing sysfs a little
>
> As for several layers: I don't know. My use-case isn't that complicated.
> I suppose if you have dm-crypt on LVM, then it's not on an SSD and thus
> we don't turn on the flags (i.e. we don't walk the layers until we reach
> an actual physical disk; we just check the immediate parent)
>
> > I'm mentally comparing device mapper to a network OSI model: should
> > the TCP protocol tune itself based on what data link layer it runs on
> > (ethernet vs token ring vs serial port)?
>
> In theory I suppose not. But I _really_ wouldn't be surprised if in
> practice people do this.
>
> But also, TCP does make an effort to tune itself based on the
> bandwith/etc it finds available. I do not think dm-crypt can do this so
> easily.
> >> systemd to turn these flags on when it detected an SSD, but I spoke to
> >> the maintainers first and they suggested that I try to implement this =
in
> >> cryptsetup instead. So I reached out there[4], and they suggested that=
 I
> >> should write to you, and that the kernel should set optimal defaults i=
n
> >> cases like this. They also mentioned recalling some hardware
> >> configurations where these flags shouldn't be on.
> > At least within our testing it is not as straightforward as "if you
> > run on SSDs - you always get performance benefits". Some of
> > Cloudflare's workloads chose not to enable these flags to this day.
> > With all the external feedback I received for these flags - most
> > people reported improvements, but there were also a small number of
> > reports of regressions.
>
> Are these workloads more complicated than dm-crypt running directly on a
> drive? In other words, are these workloads involving many device-mapper
> layers?

No. No layers, but for us it is some database/storage workloads. We
generally see that performance benefit comes from workloads generating
"many small bios" (closer to sector size) vs "large bios" (big chunks
of data attached to a single bio).

> Is this feedback public anywhere or internal to Cloudflare?I would like
> to know in which situations the regressions can happen, and in which we
> get improvements.

It's in the mailing lists and (unfortunately) some off-list replies to
my patches.

> > So ultimately it is more than just a type of storage, which goes into
> > the decision whether to enable these flags, which in turn creates a
> > "policy", which the kernel should not dictate. I can see a world where
> > spinning media would not be used anymore at all, so the kernel
> > probably can flip these for everything to "default on", but more
> > "complex decision trees" would be better off somewhere in userspace
> > (systemd, cryptsetup, users themselves).
>
> Sure, complicated policy probably starts to belong in userspace,
> especially if someone will need to tune it later for a given workload.

Exactly

> I'd hesitate to make it default on. This would mean someone running
> spinning media + a new kernel + an old userspace or config will suddenly
> see performance regressions. If userspace is dictating the policy, it
> will be deciding when to turn the flags on anyway.
>
> >> Is there some reason these two flags aren't on by default for SSDs?
> >>
> >> Thanks,
> >> Adrian
> > Ignat
> >
> >> [1]:
> >> https://foundation.gnome.org/2023/11/09/gnome-recognized-as-public-int=
erest-infrastructure/
> >>
> >> [2]: https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
> >> [3]:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/drivers/md/dm-crypt.c?id=3D39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877
> >>
> >> [4]: https://gitlab.com/cryptsetup/cryptsetup/-/issues/862
> Adrian
