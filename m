Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50327156677
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 21:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727299706; cv=none; b=G5SHIy7PZnPyjC3/Ddn1TkzSJ75W1m+D/Fy69s888x4kYgy9Yc+Oa0lutUZpDf7GqBq+hmkJTxbxcxI2TQOCZwCwme0yZNgjhy0stGPdYoqI5zoPYjCrC2QZEttNawTjz9AuWbI2iveNhPew+q65oKwvwfETV1ki3jXd1YhlJY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727299706; c=relaxed/simple;
	bh=TEbMdjHCrNeADAZkuopWhRQtiefadpFr7JS8kYOMbUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gj2lpcjrbgsblGJH3mG4Wnvj5q9ni4uI50J1tsoHYyT5w8LYWaISu5t1Tpugqse7xCaMLYrGzZpYk3bknWTvEifKfPnlrgfLpCLW35ywkiy8bf4U2+gxIRstECFetIrn/AYex1LI3+wJcZdSDnVVq+8BWOX2O/fQoWeTYi5tR7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ASc+Knhy; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ASc+Knhy"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e03caab48a2so307992276.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 14:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727299703; x=1727904503; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HIBeS2n7KF9/n5SkrStAMqnyNGIdf54yNApzBdxSE4s=;
        b=ASc+KnhyxN3A0FfjSS8A2VmGdml2neisp1R3rIbhg81UkujpD9EuXrzcgsgvmQtW+/
         m+acdSEI5HQYFMkVNfjD2oE0fLf6dBOgf0zAL3V7eTHVW+4K6ZZHl1S9R1ospk0c9MTJ
         PsKM6J/ednMJwgexdjAth3yaATgR1gdgLjrd/7c56vpiI8GtxcAHXhw+zsPdN+iNkh02
         nKioMJLP+SiJ99PdQj9LOBwen4/w6/TXdvQGyXSx9yv3M1qjt5b6r1bi+OFVBlnIVvzT
         uKAa9umXtJV6FCdt4PuYpmBSYUbbbgabyAQEyyROAeDXvh4apM7o+a4C9lydH+DwAI4Z
         RWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727299703; x=1727904503;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIBeS2n7KF9/n5SkrStAMqnyNGIdf54yNApzBdxSE4s=;
        b=Z/RoDSOBVm14Qs6k9hQBwpzcPRHbWu6yMQiK5GfuMrzacP5MCAkdHd8n7+PjcWumq+
         G/9eTcZ6/wHB47nBuug6WQXoDnlevKoz/NJ2pi+5p30DDXUvKs7+rXTCChL/HIquK2Zw
         /T5v01lBQyFj8lGYXrc0P7C2WoSiXI6gRtmMTRv/5QoysGm0bThABj8Y6bDM+szpKcVz
         IXaCllWESJ8JWt0T7EE7Xoi5bqE7iyyrX1LsVFQNop4iGXALi0EbbwkhmCAW2cw0j+Hu
         nrC0c+KVTbB0iC/mKpCL2J73EJU5N6lXEcea0rVXB3AyK14ucp0SlMip08N987eBUFk6
         HKiw==
X-Forwarded-Encrypted: i=1; AJvYcCVbZNGS3U7PICl0wq2VPXDELT4kZcbNp8ySVdlDsgV1o55qbaQCeSh7gBQR8jsLt8RnWqFhKW+d8w==@lists.linux.dev
X-Gm-Message-State: AOJu0YzdF+gM7Kcv69umXaC06loyFyCtA5Qxee3SMor3w/rGFKfkYeGu
	xZn+bWIwOvWHVtPC3DWLbG/CBBjBXgHJgho16GZlzUPpIjP7Oza7es3wID8Ow8J8tsp6H3Wentd
	Rcs1i6zrAJw1tuJcIFxG6G90HLIc=
X-Google-Smtp-Source: AGHT+IHqS4KyMSd5xh+DamiFRB3gg5TKfjsULrg1wZR9BYFD94MMQOq7D+dI5gqU/yU8Un4nooZ40nra4DVZapHfjD8=
X-Received: by 2002:a05:6902:2b82:b0:e22:6bd0:46a5 with SMTP id
 3f1490d57ef6-e25ca96a3fdmr817693276.21.1727299703011; Wed, 25 Sep 2024
 14:28:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922161753.244476-1-luca.boccassi@gmail.com>
 <6b3e0e45-5efe-3032-62b8-75dcd45c879c@redhat.com> <D4EMWUMBIM94.3PM88QAV6LG6B@kernel.org>
 <7c40c30a-5154-08eb-d44e-6598087c53e6@redhat.com> <D4EU6G0VR6WO.24IWJJQC997Y9@kernel.org>
 <20240924215910.GA1585@sol.localdomain> <df791a04-feae-4708-865f-193360b35fad@gmail.com>
In-Reply-To: <df791a04-feae-4708-865f-193360b35fad@gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Wed, 25 Sep 2024 23:28:12 +0200
Message-ID: <CAMw=ZnT=3n+1n6z0HE7JPNFX07fAJS+5W+SeO4pddrcUcEpjZA@mail.gmail.com>
Subject: Re: [PATCH] dm verity: fallback to platform keyring also if key in
 trusted keyring is rejected
To: Milan Broz <gmazyland@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, snitzer@kernel.org, 
	serge@hallyn.com, wufan@linux.microsoft.com, 
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Sept 2024 at 10:03, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 9/24/24 11:59 PM, Eric Biggers wrote:
> > On Wed, Sep 25, 2024 at 12:36:01AM +0300, Jarkko Sakkinen wrote:
> >> On Tue Sep 24, 2024 at 9:27 PM EEST, Mikulas Patocka wrote:
> >>>
> >>>
> >>> On Tue, 24 Sep 2024, Jarkko Sakkinen wrote:
> >>>
> >>>> On Mon Sep 23, 2024 at 5:04 PM EEST, Mikulas Patocka wrote:
> >>>>>
> >>>>>
> >>>>> On Sun, 22 Sep 2024, luca.boccassi@gmail.com wrote:
> >>>>>
> >>>>>> From: Luca Boccassi <bluca@debian.org>
> >>>>>>
> >>>>>> If enabled, we fallback to the platform keyring if the trusted keyring doesn't have
> >>>>>> the key used to sign the roothash. But if pkcs7_verify() rejects the key for other
> >>>>>> reasons, such as usage restrictions, we do not fallback. Do so.
> >>>>>>
> >>>>>> Follow-up for 6fce1f40e95182ebbfe1ee3096b8fc0b37903269
> >>>>>>
> >>>>>> Suggested-by: Serge Hallyn <serge@hallyn.com>
> >>>>>> Signed-off-by: Luca Boccassi <bluca@debian.org>
> >>>>>
> >>>>> Hi
> >>>>>
> >>>>> I'm not an expert in keyrings.
> >>>>>
> >>>>> I added keyring maintainers to the CC. Please review this patch and
> >>>>> Ack/Nack it.
> >>>>>
> >>>>> Mikulas
> >>>>>
> >>>>>> ---
> >>>>>>   drivers/md/dm-verity-verify-sig.c | 2 +-
> >>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> >>>>>> index d351d7d39c60..a9e2c6c0a33c 100644
> >>>>>> --- a/drivers/md/dm-verity-verify-sig.c
> >>>>>> +++ b/drivers/md/dm-verity-verify-sig.c
> >>>>>> @@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> >>>>>>   #endif
> >>>>>>                                  VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> >>>>>>   #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> >>>>>> -        if (ret == -ENOKEY)
> >>>>>> +        if (ret == -ENOKEY || ret == -EKEYREJECTED)
> >>>>>>                  ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
> >>>>>>                                          sig_len,
> >>>>>>                                          VERIFY_USE_PLATFORM_KEYRING,
> >>>>>> --
> >>>>>> 2.39.5
> >>>>>>
> >>>>
> >>>> I know nothing about dm-verity. What does it even do?
> >>>>
> >>>> BR, Jarkko
> >>>
> >>> dm-verity provides a read-only device with integrity checking. dm-verity
> >>> stores hash for every block on the block device and checks the hash when
> >>> reading the block. If the hash doesn't match, it can do one of these
> >>> actions (depending on configuration):
> >>> - return I/O error
> >>> - try to correct the data using forward error correction
> >>> - log the mismatch and do nothing
> >>> - restart the machine
> >>> - call panic()
> >>>
> >>> dm-verity is mostly used for the immutable system partition on Android
> >>> phones. For more info, see
> >>> Documentation/admin-guide/device-mapper/verity.rst
> >>>
> >>> The above patch changes the way that the signature of the root hash is
> >>> verified. I have no clue whether the patch can or can't subvert system
> >>> security, that's why I'd like to have some more reviews of the patch
> >>> before accepting it.
> >>
> >> I guess someone who knows all this already should review it.
> >>
> >> Doesn't dm-verity have a maintainer?
>
> (This reminds me of a nice comment from Neil about "little walled gardens" between MD & DM.
> Apparently it applies to other subsystems as well. Sorry, I couldn't resist to mention it :-)
>
> > This patch only affects dm-verity's in-kernel signature verification support,
> > which has only been present since Linux v5.4 and is not used by Android or
> > Chrome OS.  The whole feature seems weird to me, and it is prone to be misused;
> > signatures are best verified by trusted userspace code instead (e.g. initramfs).
> > But apparently there are people who use the dm-verity in-kernel signatures.  I
> > think systemd has some support for it, as does the recently-upstreamed IPE LSM.
> > I don't know what else.  The exact semantics of the "trusted" and "platform"
> > keyrings are not entirely clear to me, but given that dm-verity already trusts
> > keys from both keyrings this patch seems reasonable.  The people who actually
> > use this feature are in the best position to make that call, though.
>
> When we added support for this to veritysetup (--root-hash-signature), I think it was
> a requirement from Microsoft.
>
> Anyway, if you have a trusted key compiled-in the kernel in one keyring, I do not think
> it would cause problems if stored in another.
>
> But it scares me that we cannot easily test userspace for this in CI, as it requires compiling
> own kernel with our own keys.
>
> Do people use veritysetup (libcryptsetup) here, or does it run with its separate userspace tooling?

This is used with libcryptsetup commonly, and often with veritysetup.
It is fairly easy to test in a VM or on baremetal, it is not required
to build your own kernel - that's the reason for supporting
secondary+platform keyrings (the first one allows you to enroll keys
in MOK, the second one for UEFI DB).
We would even have a CI testing this for every PR and merge in systemd
on Github, _except_ there is currently an issue (unrelated to
dmverity) that happens when nesting KVM with UEFI secure boot enabled
on top of HyperV, which means it cannot be used reliably on Github
Actions. Once that is solved, this will be again part of the systemd
CI integration tests. But it is used regularly by developers on their
machines.

It might not be commonly used by kernel developers, I do not know as I
am not a kernel developer, but it is becoming more and more common in
userspace and among image builders. For example the mkosi image
builder, using systemd-repart, can very easily build distro images
using signed dm verity. I am at All Systems Go and just today there
were multiple talks by multiple people using dmverity images for their
distros/platforms/products, especially with systemd-sysext, which is
all about signed dm-verity.

In 6.12 we will also have IPE which allows to enable trusted code
integrity checks that cannot be trivially bypassed by other userspace
processes running with root or caps. This has been, still is and will
be for the foreseeable future, in use in the Azure infrastructure.

Hope this provides some clarity, let me know if you need more info.
