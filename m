Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7121CB321
	for <dm-devel@lists.linux.dev>; Tue,  1 Oct 2024 18:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727807613; cv=none; b=UaTgXngMiaZsi39IZMv8VuT7GQ0T922b567aGSk6crEopGEmmnsgZcmVRTUkQ/6O6Qtqj3NtrQxzpbnnTF9LaNc3uh4RqrZkhK9oiGKLARCDFqGsgk1NOhK+lBRUx8HjtnVNSkzloXdjTp8qwxGvooyfDKcUZ0yhyTMRItUwJuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727807613; c=relaxed/simple;
	bh=f5EWmyoHZ+S8fj0owUKHtkKPZPVuffgssNi+7STNS6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RnkSmPOF5aupw9J0gG0QNIXh1HM4pRybKTZB4jSaP8C3AauNDYTn9Ti92gg/XVD7N1fpkYuj6qC0X739bsaNNS0MXRySgW777cb4wyToy5LbSjB4cu0n0a0P9QUxEH8Z6ySU0JKe5LXIKx6SPTvQxVMLem3xSvSQJJDtWRF3TPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0XaDfKy9; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0XaDfKy9"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-45b4e638a9aso43611cf.1
        for <dm-devel@lists.linux.dev>; Tue, 01 Oct 2024 11:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727807611; x=1728412411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5EWmyoHZ+S8fj0owUKHtkKPZPVuffgssNi+7STNS6w=;
        b=0XaDfKy9zSqKmNc7lPMSXGHzpcqVOk/9IfNBjhRRMXmnFu2Cys5wYfURnfTc8/I18O
         PN06ktKh+AZYEshg7WoVJQNu+QE4oDrFRaJ697cKbZX1Q6KcRWztDYwd8pVBPZnw2cNV
         JDQgv8sWiZVkUT1BE7JTK0pPmYRe9UJ/nT5uVMmgUxqlHW7BCHiaG4FVFGGKL5olu74N
         asEYA9JbIM6SCXd3q5ycMitp4HVD9zzwEgnpg9hjFMz3xkpnn1sHON8sQwDo/YXaOvhS
         s51ofTHYmovb6zCb6QlOlItfAfeP4RO/PR+xQ3YW/m3FANZC+NBdNYcRIdl7FM58EVtR
         YJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727807611; x=1728412411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f5EWmyoHZ+S8fj0owUKHtkKPZPVuffgssNi+7STNS6w=;
        b=uVY3834l/ATnVgP/q6NBf2ieW0XBzxJeKVg3n2JMeo3gm09Dx644jDlq+2YnkYRLii
         lGWKXVl5W1tb6oeoS4uYnpAfJdbrS7pQzSRY7HriuPEw0+I9zSefvLM3/H43TngekpTa
         3DMzsEXYaoz/vFq/03YOzVrjkAxxnDLWZkq0yOvW/IaYD4dm1JBIsYc/DVDB8aoiG240
         PvhC0a6RQMxQRmbvrCbN9q3W/Z3YRNgVKzyg7U0sB1T4HQROiMtIIQqb6ixMnEUUfuqU
         07iSiKt7QRjsZpHMwQphspWTBK7+jkls8kZh8SzUiGHgo/4lw7mIoeaKz7KPAmH/sFQ8
         /9Mg==
X-Forwarded-Encrypted: i=1; AJvYcCXbuymOEdGWhEnOpw9y/EkWNAEgi5uisb/n6HMzg7ewBbudx4d9NtOkSbsxyIhalkGfKsn8UN0/CQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw7hOB7j5CYXerq6RkMaZ2/2O+E/jnhnuFRISWemVX+U0DPd7v
	aAQEjJUHv7AhhTJyzBhKohr7SZCekna2/rVnWpG1/V2XjWTdWFO7GWXZY5ZIOJNCGLdW2u+m40P
	9Zt3LQkhqFsaf/2Dol7CzBQWbIAPH8jlwmPKr
X-Google-Smtp-Source: AGHT+IEnlu57wPDgTxnGEveVw99UE8l+5Ist3RtzV4dSx4UHzRYhF5uh5chyGKaBxaKjXUuH/2JsSStdVGT10dnKUuM=
X-Received: by 2002:ac8:7fc1:0:b0:44f:e12e:3015 with SMTP id
 d75a77b69052e-45d8206e760mr244471cf.25.1727807610903; Tue, 01 Oct 2024
 11:33:30 -0700 (PDT)
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
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
 <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com> <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com>
 <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com> <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
 <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com> <CAAFS_9HyeD795N4RFKWYcP5VCFBCxmoXgGg9UbGy80Bxz7j1mg@mail.gmail.com>
 <CABCJKuedOj+E15YLZrC4nePx4g4YLO-3dzc3tyyx1S1_6HysJg@mail.gmail.com>
 <CAAFS_9FuSb7PZwQ2itUh_H7ZdhvAEiiX7fhxJ4kmmv9JCaHmkA@mail.gmail.com> <dfc65621-bb43-1ab7-82a7-3ab15fb9f95f@redhat.com>
In-Reply-To: <dfc65621-bb43-1ab7-82a7-3ab15fb9f95f@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 1 Oct 2024 11:32:52 -0700
Message-ID: <CABCJKucBT_7rOygoq4gMRyOPpgy+KTMG4ut4S40sBizX8QcF1Q@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Milan Broz <gmazyland@gmail.com>, 
	Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 1, 2024 at 2:12=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.com=
> wrote:
>
> On Mon, 30 Sep 2024, Will Drewry wrote:
>
> > On Mon, Sep 30, 2024 at 1:07=E2=80=AFPM Sami Tolvanen <samitolvanen@goo=
gle.com> wrote:
> > >
> > > While I agree that this sounds good in principle, devices that use th=
e
> > > restart feature typically need to pass the reboot reason to a PMU, fo=
r
> > > example, and it looks like Android devices depend on reboot notifiers
> > > for this. Here's a recent Pixel implementation that checks for the
> > > "dm-verity device corrupted" command as an example:
> > >
> > > https://android.googlesource.com/kernel/google-modules/power/reset/+/=
refs/heads/android-gs-comet-6.1-android15/pixel-zuma-reboot.c#81
> >
> > Good catch! (It's a shame it's using text as the API!) I totally
> > spaced on that, and depending on where the corruption is, you mind end
> > up in a boot loop.
>
> If I add that 'reboot-on-eio' flag, should it also restart the kernel wit=
h
> kernel_restart("dm-verity device corrupted")? Or, should it use a
> different string?

I think it could be a different string since there are no existing
users of this flag and the restart isn't actually caused by
corruption, but I don't have strong feelings about this.

Sami
