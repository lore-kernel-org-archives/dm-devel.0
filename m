Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26491F4707
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729787042; cv=none; b=OvIJE7WbXC1Md3jPF6Gh9ks7FSfdEaUq8Rz0LKbnI/aCyfkKgqJgu8ZPrlHYupRtJC8sfHrS+4Efikti/DaF8NeiD2w/bTe0MucitgKq8FWlVsuVERMTVKeQ6pjKYeQNxkX2ktKwRHmv6f9zHSrjGhCz+1aYpfSBO61V7rP8yV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729787042; c=relaxed/simple;
	bh=f18gmjvDDOpzp1FkWkb7PHbYJOLjERviv7qoUyayLKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oe4d1iZJEE/LAaCVkvJS7oQ/emryfjDHh3YawjWtgSpAhU97EvNyn7Pq6oVaZ8BHul/P/Vxd+R+alL7Cidon9Fme4RnJTnDrZHJ8DKW+mExfVlTHigzvOLVD9dTLcN4NN7R0FqFlcNM6x+7YkuSMcaTj6objzCiSa2py7QmONIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6791QgT; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6791QgT"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e34fa656a2so11695057b3.1
        for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 09:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729787040; x=1730391840; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9NK7Z+Ngm315TPPgtg78S7xRTYOPCuLS/UsgPBTsds=;
        b=E6791QgTddpX8Nh2LvY8U7gy1ZbYvO8suRMX36VkM9uiQxhc2CD3zTbRc/CMxg4IGs
         h0hhbcOuwaQQWdTQOg58soA3THEgP/E9Fv0rsH8UtXUDwFHqpJiygqE/qq4MedrShSd8
         VQfKgQ9iD8S4iDXZP08t/7l6lHftyNBVUkKA8H2b1l9QwLEZkMEdWacpCyyNBhPzLrQ4
         JEDUimkormkoB4xbPdKAXDgaZw3eSon3NIaixuHExO84hYqIMLMdpka6LnVhNKIlURJr
         4RyJY7K6cDMYscS8Vgyro2VK9BPXAUHoZqYbBaZGCN7JcpIAmea49Nsc0I6SD9aYC13a
         kqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729787040; x=1730391840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9NK7Z+Ngm315TPPgtg78S7xRTYOPCuLS/UsgPBTsds=;
        b=eIxPuVIz+HaSuz1gHjeBLzuGMblplQJkPhwmFZrI0nkSYhCI86WmPltWQQq1K5am0S
         /N3+cP6ErVDj+CcxkRswskXY7k8nkjbxOuTSlOFNnAaqX3C0MPIjMEy7oKk/MgTJyfG8
         bbRPgd+0HRqjQq535d+M2YuEB+l0KKD78dpWSHtgY+SpdADTbPXx45VOk0HOPcxihdcL
         6/IAbVIQhG5usJoXnwftiQ8Ynu/nnTlnozVP3b04dofAfDbzSOLw6fjmWYp5Zc+VWjWP
         cRXmdboataHC/6MSNTxHHMC8e8WWurGYYfs0M5ultSeHu7mCzlTaBsWKm8mxJv0KxZci
         ZjXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvCj8Exr/LNP3FmtMoo0oJULEqWX4SQEYGudirBYVYpt4U8sJqD3jLlj4jn8hu+I91G5DSzQymcA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwsihZGCmYa4+kMLseWM/IE9xaWETkloePRDTK5uWOje4cNbHw
	ke/hLkuXgdcIQpOmUI5Gy3/YFMO9KOpu3QpjqdbNUDXeLE/eAOBdwFkJRK9JIEgQIP9ELIqWLpp
	qREb8cUd6ondWGJe+qJt62EgWgvY=
X-Google-Smtp-Source: AGHT+IEiSnw3xc3o0GD+aCII4uuqttpRYCWli0c8mbnI6vmERD9GFMgMpU//iIU/A2qv4SMpA2Y1PA+3QtY5X2wHU3w=
X-Received: by 2002:a05:690c:9987:b0:6e3:16da:e74 with SMTP id
 00721157ae682-6e7f0e05389mr77322977b3.16.1729787039682; Thu, 24 Oct 2024
 09:23:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZxHwgsm2iP2Z_3at@infradead.org> <CAAdYy_mVy3uXPqWbjPzK_i8w7Okq73wKBQyc95TbnonE36rPgQ@mail.gmail.com>
 <ZxH4lnkQNhTP5fe6@infradead.org> <D96294E2-F17A-4E58-90FB-1D17747048E5@gmail.com>
 <ZxieZPlH-S9pakYW@infradead.org> <CAAdYy_ms=VmvxZy9QiMkwcNk21a2kVy73c8-NxUh4dNJuLefCg@mail.gmail.com>
 <Zxnl4VnD6K6No4UQ@infradead.org> <14126375-5F6F-484A-B34B-F0C011F3A9C5@gmail.com>
 <ZxoNgmwFVCXivbd3@infradead.org> <CAAdYy_kKHx-91hWxETu_4TJKr+h=-Q0WdoyQwXjRZiwiXCOOYQ@mail.gmail.com>
 <Zxpuzbjtq0eNP49Z@infradead.org>
In-Reply-To: <Zxpuzbjtq0eNP49Z@infradead.org>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Thu, 24 Oct 2024 12:23:48 -0400
Message-ID: <CAAdYy_n7GC6VHjiVN2DLxx4VGFi16RENC96tgkt-284xdOdNzg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dm-inlinecrypt: Add inline encryption support
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Md Sadre Alam <quic_mdalam@quicinc.com>, axboe@kernel.dk, 
	song@kernel.org, yukuai3@huawei.com, agk@redhat.com, snitzer@kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, adrian.hunter@intel.com, quic_asutoshd@quicinc.com, 
	ritesh.list@gmail.com, ulf.hansson@linaro.org, andersson@kernel.org, 
	konradybcio@kernel.org, kees@kernel.org, gustavoars@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, quic_srichara@quicinc.com, 
	quic_varada@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 11:59=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Thu, Oct 24, 2024 at 11:32:58AM -0400, Adrian Vovk wrote:
> > >> I'm not assuming. That's the behavior of dm-crypt without passthroug=
h.
> > >> It just encrypts everything that moves through it. If I stack two
> > >> layers of dm-crypt on top of each other my data is encrypted twice.
> > >
> > >Sure.  But why would you do that?
> >
> > As mentioned earlier in the thread: I don't have a usecase
> > specifically for this and it was an example of a situation where
> > passthrough is necessary and no filesystem is involved at all. Though,
> > as I also pointed out, a usecase where you're putting encrypted
> > virtual partitions on an encrypted LVM setup isn't all that absurd.
>
> It's a little odd but not entirely absurd indeed.  But it can also
> be easily handled by setting up a dm-crypt table just for the
> partition table.

That doesn't cover it. Not all of the virtual partitions necessarily
need to have their own dm-crypt, so they should be encrypted by the
underlying dm-crypt.

So the dm-crypt doesn't just need to cover the partition table, but
also arbitrary ranges within the whole partition

> > In my real-world case, I'm putting encrypted loop devices on top of a
> > filesystem that holds its own sensitive data. Each loop device has
> > dm-crypt inside and uses a unique key, but the filesystem needs to be
> > encrypted too (because, again, it has its own sensitive data outside
> > of the loop devices). The loop devices cannot be put onto their own
> > separate partition because there's no good way to know ahead of time
> > how much space either of the partitions would need: sometimes the loop
> > devices need to take up loads of space on the partition, and other
> > times the non-loop-device data needs to take up that space. And to top
> > it all off, the distribution of allocated space needs to change
> > dynamically.
>
> And that's exactly the case I worry about.  The file system can't
> trust a layer entirely above it.  If we want to be able to have a
> space pool between a file systems with one encryption policy and
> images with another we'll need to replace the loop driver with a
> block driver taking blocks from the file system space pool.  Which
> might be a good idea for various other reasons.

I don't quite understand the difference between a loopback file, and a
block driver that uses space from a filesystem space pool. Isn't that
what a loopback file is?

>
> > Ultimately, I'm unsure what the concern is here.
> >
> > It's a glaringly loud opt-in marker that encryption was already
> > performed or is otherwise intentionally unnecessary. The flag existing
> > isn't what punches through the security model. It's the use of the
> > flag that does. I can't imagine anything setting the flag by accident.
> > So what are you actually concerned about? How are you expecting this
> > flag to actually be misused?
> >
> > As for third party modules that might punch holes, so what? 3rd party
> > modules aren't the kernel's responsibility or problem
>
> On the one hand they are not.  On the other if you have a file system
> encryption scheme that is bypassed by a random other loadable code
> setting a single flag I would not consider it very trust worth or in
> fact actively dangerous.

I'd expect that the lower encryption layer has an opt-in flag to turn
on and off passthrough functionality. I think I neglected to mention
that before; it was discussed in other threads and I just kinda
assumed that it would be there.

So, with that in mind: the loadable code could set the flag, but the
underlying dm-inlinecrypt would need to opt into the weaker security
too. If the system administrator has opted the lower layer into
passthrough, then they've considered the risks of what could happen if
an upper layer sets the flag and decided that it's OK. If the
administrator didn't opt in, then the flag has no effect. Does that
sound more acceptable?

>
> > In my loopback file scenario, what would be the one layer that could
> > handle the encryption?
>
> But getting rid of loopback devices.

I can't get rid of the loopback devices. They're an essential part of
this. I should be able to take the encrypted loopback file, send it to
a different machine, and have it keep working the same as it always
has.

Without the loopback device, I'm stuck with fscrypt. Which isn't
supported by all filesystems, and encrypts much less data than we
require.

- Adrian
