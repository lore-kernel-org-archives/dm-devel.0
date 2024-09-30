Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9B192D7F
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727719664; cv=none; b=T08ILkkUztVI49cBHHe4YlUpL4kGAIPcyvZu+05kBYWu4mOVE4fbFc3RN3hcSan0eNpjCwgbSjtSeOana6c2p7qlvT5LMDb/TWLpo3kIfvuArFbsH9JjE3m4x1e5oKa1dIRVWFfp9bE+zFAa6iuMWZOZpVUqt+s5euDMCVCt8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727719664; c=relaxed/simple;
	bh=+61FL0eDHPDCWM4p3kZnmtVTP8YbKp70HFNMNhjtQGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VV0uSr75w3eAyUzDBeKyW48WHj9DM8giDUVvMCb+H3jM/wyy1axtL8j0P/VvuGEtLtjh96L/kVG6NO/2Ezls563o2w4BmwlKwW1VoYDYxQdh0hTDQlBhJpVpBtEPvRVL+V4R5IkLGazANuksc3DrdB2yenqMh7dDC800n5oLCcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dg/iQokq; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dg/iQokq"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4581cec6079so31771cf.0
        for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 11:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727719662; x=1728324462; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdgBKRRFTIhV3/+gI2+7e/zynUWPLTRRF1v5Z74BOPI=;
        b=dg/iQokq4TM0+y5oIqGTB9+M2mvMl+iYhbDcIiagm8bsqld9kcVabN3U0RDZA7xPfg
         oFfaUiLJMUV6H4tlHA6wuyMJUwEWTUlHkVjwI1lnLYkzEltj1+f2XlPorSNGhcSpE+k5
         UH73Y4/xqEfZ1fa7fri6tSvEbzKdxr2iy/JB7rFxahkJghOXoDV0A9wxUnIfV3l6x7z4
         0gw2pRu+zUvBaSVhuqmjh5rE25DoMvGSS+hnpMwlP6hq4sH6KmBlZsCwHDdvh+uuapQs
         xf5g0Ac0rEec4bzOWXhgD+sB1sWupPzBt1U9Pc55FF4Rar/p9McyGBQL4qtSiw87dPyl
         YS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727719662; x=1728324462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdgBKRRFTIhV3/+gI2+7e/zynUWPLTRRF1v5Z74BOPI=;
        b=XhrdNp+F7rby8YG0SuV/9eC+TQ0g+r2x/F0jQWpPz47W5zYOenSnCfJtkW7kcteczE
         L4xY0OYZU9Y0rgM9WrRCnOEF1kCrpVbbYvZFpUr1unNpEEF4PDgmNpB8VVhlyEBMFgDn
         w2/HLOHsKhZXLtS7iQ9JdzOu3yuyzrcJIJqcoTRwDvdNppZST4juzoCbYz8qrEDKaqMJ
         QfD4XU7D9DfijajLdyhrrpupZ0lsB5XmhwP+05SHYCoycxzssT1Trx+uAvBSLLun5mSc
         vBJ+IUIRQT8TIzOZ4OJCnZ1TSl71RaBxiXcy9Y5Xx2oPhjINw9uTpuc/ZdxrP0KwdtUg
         o5cg==
X-Forwarded-Encrypted: i=1; AJvYcCXWd4aMGhwEI0JANpxIBywmbTO406CtxA37D15aoINHq2wn1hThSECA5gT4BtIuROVeuoWzjUcD6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyUhZNJeO3r6L7zzAvWWAGlHGwPU7fpMCVR9E/oldj0UqpFaYlh
	kcfLaZSsWT2+3xS7nwkDomTLn45w+JjNLvLEGgoy0/P6CdIw9W35picfv0eCl2jIz6XPu8hbivj
	G4bMGujyxO4HcVfGD9GtcARMUi4QHbRwgRhQ+
X-Google-Smtp-Source: AGHT+IE2rSzmteNz+1chMprwqlsIUrGKff79KxZWzZLHcA4Wyw3xLw3L0Le929eVI8EWqlRM7QvYDvBgZcvRLF+0cAQ=
X-Received: by 2002:ac8:628f:0:b0:458:1eeb:4b33 with SMTP id
 d75a77b69052e-45d74a1ecd9mr214371cf.20.1727719661705; Mon, 30 Sep 2024
 11:07:41 -0700 (PDT)
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
In-Reply-To: <CAAFS_9HyeD795N4RFKWYcP5VCFBCxmoXgGg9UbGy80Bxz7j1mg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 30 Sep 2024 11:07:02 -0700
Message-ID: <CABCJKuedOj+E15YLZrC4nePx4g4YLO-3dzc3tyyx1S1_6HysJg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Will Drewry <wad@chromium.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
	Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 10:10=E2=80=AFAM Will Drewry <wad@chromium.org> wro=
te:
>
> On Mon, Sep 30, 2024 at 11:27=E2=80=AFAM Mikulas Patocka <mpatocka@redhat=
.com> wrote:
> >
> >
> >
> > On Mon, 30 Sep 2024, Will Drewry wrote:
> >
> > > > The dm-verity behavior was reported as a security bug, so by defaul=
t, it
> > > > should behave in the secure way - i.e. restart or panic on I/O erro=
r.
> > > >
> > > > Do you intend to use dm-verity in Android and ChromeOS in the less-=
secure
> > > > way where it returns -EIO? Have you audited the Android and ChromeO=
S
> > > > codebase so that -EIO can't cause security breach? If yes, I can ma=
ke a
> > > > configuration switch for you that will enable the old behavior.
> > >
> > > tl;dr don't change the default behavior, but adding a reboot-on-eio i=
s nice.
> >
> > OK, so I can revert it if you want it.
>
> That or an argument so the old behavior can remain for those who are usin=
g it
> (I can send a patch for that if it's easier too).

Thanks for chiming in on this, Will! I still think that adding a
separate restart_on_eio (or similar) flag would be the best solution.

> > I'd like to ask - there is another change in that patch - I changed
> >         kernel_restart("dm-verity device corrupted");
> > to
> >         pr_emerg("dm-verity device corrupted\n");
> >         emergency_restart();
> >
> > Because kernel_restart calls reboot notifiers and they may in theory wa=
it
> > for the bio that caused the restart, resulting in deadlock.
> >
> > Do you want to have this part of the patch reverted too?
>
> IMHO, that's a good change!  If the policy is to restart on corruption, t=
hen
> it makes sense to avoid the reboot notifiers.

While I agree that this sounds good in principle, devices that use the
restart feature typically need to pass the reboot reason to a PMU, for
example, and it looks like Android devices depend on reboot notifiers
for this. Here's a recent Pixel implementation that checks for the
"dm-verity device corrupted" command as an example:

https://android.googlesource.com/kernel/google-modules/power/reset/+/refs/h=
eads/android-gs-comet-6.1-android15/pixel-zuma-reboot.c#81

Sami
