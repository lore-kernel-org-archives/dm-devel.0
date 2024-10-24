Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D081F584D
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783993; cv=none; b=PF0FBKpNmWK+dT3l1W1ell5//6yvHreJGUSq9SQUsHPmW+2vxnqw/kij7tg6Kmnw2Ii1IM4yjJza+TRUV3CbQH7Foo0S6HEPE9CVvLJHrI6IaO98/hk/54r8ETYC6X+0Ek/zHy+JsF+2UD5D4tG7VYx/0BGmtgEgz6r7k6sjCyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783993; c=relaxed/simple;
	bh=NCg1o6OpWYkJPiZA+Ur5bkr5FQC3PkjJbvvaK/OJVNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FDbJ0HgKHIO1GOaS6efRsQro2wXfjPqjmpFm0m9ILxYjiYrhYHWFHpK+bOe4YVjoIEKitlXrJXXgQcX1b1G4G8lpSGl2J2ci6Y9YTLz8XWnRHWjPIf/MwWE8cc2kwMxY+eKjDIiVlK6OYjo24knDXF1b0YajZubsliVHuqic0zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BBHGdNZe; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBHGdNZe"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e330b7752cso16616067b3.1
        for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 08:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729783990; x=1730388790; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=255JavdIhiHitgdJpoK+CQc2yCTaCHPw3f2BcHPjhtQ=;
        b=BBHGdNZeGqLRjEHhM8/D7uq3I78Vtdzs09Awpm4ZePS/Kiz+jbElkic85AVuDXgmm0
         8rnNaQD/oQbSDQJ4gKdEewB2uk8YP1NfJTIzpstw51eQVOCFrTajyQwogsewbnlNCRO4
         jTDycuCfXFoUDB4fc4nGYo8+quHHdBI2TnGh/d2qnAZJkj/QXNEbJrqeo0jFixkg8dcW
         iUB+aCpx/zllV5j+uRIKo8pMwu8OLEJTcRaiXTlusm2tvOTYyiSTyJOJqcYS/OSCoN3H
         gcbRZr876cDzzYSXyGeFUsssvfRHu7YzQedb//qmIYt3qfXk5+yEWksK/oAAyB5a5Lzz
         KhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729783990; x=1730388790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=255JavdIhiHitgdJpoK+CQc2yCTaCHPw3f2BcHPjhtQ=;
        b=TpNBBpiHd5cVvlOiFzU9qaYgD2VMRxvA2eVyE9+DLUU1IsbNWPcStAphUz2ZPUhD4M
         fHD6Inw1Ef7Ox3jHggFl0W+3gqUbnjnCSXSbvolBZvnm78v0+DHf9CbU9BntmmjMyLng
         DTEP0rhvGSM22hZ1HyhQ0CIeVYQ3Rglu94IITkhHgNgoHsgO630sZOGSUn5sLbruu1Nv
         t5KTLL8DGvoQEm/Erd94zWBajDcqIu0UFCsjoGqfo07dkibJsHcoJ1KcjAh+aDqfYQrK
         IWoVLKXgckprl8Jq84S3CKNCsHcqIfOyC/g4Q0ULw+0iNQTpzT2SP0RQonzCjSbKh3H+
         mA4A==
X-Forwarded-Encrypted: i=1; AJvYcCU4SgCmy+9k2EIVAPp5i3wdD2KA8SDu4bqxaHu7fbTUY9sZ5wz5JtZpbd52I2OjyFG/KcpUUxx3BQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz01iil10aYksbmXnMclZTC0hSdBi3MiDIX+74W8z3bcppe61tY
	XcHIUvY+ORpUcjW4zkDVpC6zbkwajmaPIsxfQ8wsp3D0C74zv2FKA0wpSfOT00IXlPjgHbVYstn
	gS5aZxNsZVPo6xckwFDJPGqLHRJU=
X-Google-Smtp-Source: AGHT+IFlI2Maf6zerVv8bOWQVJCeTLDZyr7OVil6rs4loriH4b4mwTUIeeW5mPcHv6fbgHGiwIjTlw6UcY1i5PgXC10=
X-Received: by 2002:a05:690c:2c8c:b0:6e5:2adf:d584 with SMTP id
 00721157ae682-6e84df79fc6mr16708287b3.14.1729783989838; Thu, 24 Oct 2024
 08:33:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZvJt9ceeL18XKrTc@infradead.org> <ef3c9a17-79f3-4937-965e-52e2b9e66ac2@gmail.com>
 <ZxHwgsm2iP2Z_3at@infradead.org> <CAAdYy_mVy3uXPqWbjPzK_i8w7Okq73wKBQyc95TbnonE36rPgQ@mail.gmail.com>
 <ZxH4lnkQNhTP5fe6@infradead.org> <D96294E2-F17A-4E58-90FB-1D17747048E5@gmail.com>
 <ZxieZPlH-S9pakYW@infradead.org> <CAAdYy_ms=VmvxZy9QiMkwcNk21a2kVy73c8-NxUh4dNJuLefCg@mail.gmail.com>
 <Zxnl4VnD6K6No4UQ@infradead.org> <14126375-5F6F-484A-B34B-F0C011F3A9C5@gmail.com>
 <ZxoNgmwFVCXivbd3@infradead.org>
In-Reply-To: <ZxoNgmwFVCXivbd3@infradead.org>
From: Adrian Vovk <adrianvovk@gmail.com>
Date: Thu, 24 Oct 2024 11:32:58 -0400
Message-ID: <CAAdYy_kKHx-91hWxETu_4TJKr+h=-Q0WdoyQwXjRZiwiXCOOYQ@mail.gmail.com>
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

On Thu, Oct 24, 2024 at 5:04=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
> Can you please fix your mailer?  It's creating crazy long lines
> that are completely unreadable.

Sorry about that. Apparently that happens when I send from mobile, and
I couldn't find a setting to change it. I'll stick to replying from
the computer from now on. I've re-attached the message below, so that
it gets wrapped properly

On October 24, 2024 2:14:57 AM EDT, Christoph Hellwig <hch@infradead.org> w=
rote:
>On Wed, Oct 23, 2024 at 10:52:06PM -0400, Adrian Vovk wrote:
>> > Why do you assume the encryption would happen twice?
>>
>> I'm not assuming. That's the behavior of dm-crypt without passthrough.
>> It just encrypts everything that moves through it. If I stack two
>> layers of dm-crypt on top of each other my data is encrypted twice.
>
>Sure.  But why would you do that?

As mentioned earlier in the thread: I don't have a usecase
specifically for this and it was an example of a situation where
passthrough is necessary and no filesystem is involved at all. Though,
as I also pointed out, a usecase where you're putting encrypted
virtual partitions on an encrypted LVM setup isn't all that absurd.

In my real-world case, I'm putting encrypted loop devices on top of a
filesystem that holds its own sensitive data. Each loop device has
dm-crypt inside and uses a unique key, but the filesystem needs to be
encrypted too (because, again, it has its own sensitive data outside
of the loop devices). The loop devices cannot be put onto their own
separate partition because there's no good way to know ahead of time
how much space either of the partitions would need: sometimes the loop
devices need to take up loads of space on the partition, and other
times the non-loop-device data needs to take up that space. And to top
it all off, the distribution of allocated space needs to change
dynamically.

The current Linux kernel does not support this use-case without double
encryption. The loop devices are encrypted once with their own
dm-crypt instance. Then that same data is encrypted a second time over
by the partition.

Actually this scenario is simplified. We actually want to use fscrypt
inside of the loopback file too. So actually, without the passthrough
mechanism some data would be encrypted three distinct times.

>> > No one knows that it actually is encryped.  The lower layer just knows
>> > the skip encryption flag was set, but it has zero assurance data
>> > actually was encrypted.
>>
>> I think it makes sense to require that the data is actually encrypted
>> whenever the flag is set. Of course there's no way to enforce that
>> programmatically, but code that sets the flag without making sure the
>> data gets encrypted some other way wouldn't pass review.
>
>You have a lot of trusted in reviers. But even that doesn't help as
>the kernel can load code that never passed review.

Ultimately, I'm unsure what the concern is here.

It's a glaringly loud opt-in marker that encryption was already
performed or is otherwise intentionally unnecessary. The flag existing
isn't what punches through the security model. It's the use of the
flag that does. I can't imagine anything setting the flag by accident.
So what are you actually concerned about? How are you expecting this
flag to actually be misused?

As for third party modules that might punch holes, so what? 3rd party
modules aren't the kernel's responsibility or problem

>> Alternatively, if I recall correctly it should be possible to just
>> check if the bio has an attached encryption context. If it has one,
>> then just pass-through. If it doesn't, then attach your own. No flag
>> required this way, and dm-default-key would only add encryption iff
>> the data isn't already encrypted.
>
>That at least sounds a little better.

Please see my follow up. This is actually not feasible because it
doesn't work. Sometimes, fscrypt will just ask to move encrypted
blocks around without providing an encryption context; the data
doesn't need to be decrypted to be reshuffled on disk. This flag-less
approach I describe would actually just break: it it would
unintentionally encrypt that data during shuffling.

> But it still doesn't answer
>why we need this hack instead always encrypting at one layer instead
>of splitting it up.

In my loopback file scenario, what would be the one layer that could
handle the encryption?

- the loopback files are just regular files that happen to have
encrypted data inside of them. Doing it a different way changes the
semantics: with a loopback file, I'm able to move it into a basic FAT
filesystem and back without losing the encryption on the data

- the filesystem is completely unaware of any encryption. The loopback
files are just files with random content inside. The filesystem itself
is encrypted from below by the block layer. So, there's nothing for it
to do.

- the underlying instance of dm-crypt is encrypting a single opaque
blob of data, and so without explicit communication from above it
cannot possibly know how to handle this.

Thus, I don't see a single layer that can handle this. The only
solution is for upper layers to communicate downward.

Best,
Adrian

On Thu, Oct 24, 2024 at 5:04=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Thu, Oct 24, 2024 at 03:52:24AM -0400, Adrian Vovk wrote:
> > >
> > >Sure.  But why would you do that?
> >
> > As mentioned earlier in the thread: I don't have a usecase specifically=
 for this and it was an example of a situation where passthrough is necessa=
ry and no filesystem is involved at all. Though, as I also pointed out, a u=
secase where you're putting encrypted virtual partitions on an encrypted LV=
M setup isn't all that absurd.
>
> Can you please fix your mailer?  It's creating crazy long lines
> that are completely unreadable.
>
