Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD320198E93
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727722520; cv=none; b=LFWYR9XBGOuz1eY9/eUGB2j0fAwPtP9C/OwfPTI042XpqV0uS1pd1T6KH4N6YrHsPJxEBGz6gFhkScB2Zm2H08GaEVk/pz/7lgU7ndj0/uVom1EnRifsxu5Tlq/ouqWXjgVxzWtFx7HUcm3DZGb4T8YZ4Vv0+2grK5FJuXGLtaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727722520; c=relaxed/simple;
	bh=XYJ38HN0XvB53lwIMnpD2gj/FT926vssk2uUMx/801M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQcQWD/DO6SObacJAMbHmz0u/e1ho5Yq4Lsjeu+ofkH340tsO6EbTFDsIICI23pCHImhXS8i576TUPUBnouLUioQAXMqgcc/A2HEDp6lsL7TqO9KpFQCpNZKEbyc5d1irDxtFHR7thz005QPPRZ+EG44hSaufHzQl2NxK5lH1y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=google.com; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=gTvK10Eb; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gTvK10Eb"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71798a15ce5so4370655b3a.0
        for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 11:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1727722518; x=1728327318; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crDafQRcxuWTEp0KI6GX2vzz+s+nrD2oCqNchhi7JD8=;
        b=gTvK10EbOtPuXnQ1IDWBsx9VHC5M9maOnU9TEzgrK43PLbwalshYVVrnYK4cPW/Bbl
         1fSA+gHJ8eaSAD7ct0Guq/qojJ8mdoQstNFCBhAgchVQoKoONANGqjE6UzYodkC1liAF
         YKKbpK2UpTaZkm3gga3Ai39ddzZjD5ubVT42g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727722518; x=1728327318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crDafQRcxuWTEp0KI6GX2vzz+s+nrD2oCqNchhi7JD8=;
        b=Ho8rN35YzcppUlNAGewX59/IrZzVptdOmNeb8fhE+OpunBChWWS4vZ3vsUcEF3eXPR
         XopaqCREDKJY0DvH1+0MsYl8npq9uuPIBE7DSL6A5mZvZuAfIHlOiYJtdeS9VZ220ngM
         glMWzwl/wmLgGXmRc1eHiAOgHuUtNOhGG0wzvwdDNC2f9ZgBrZHMCCqrWDh5HudBYq4/
         yNkwiPoa1ZMs7qPALJXNX7RhjQl+r9xFvfy2g9/pbs0N41tqUI7i8ZhRpwDCfbs3/He6
         lNxQH7fv51cwIR5Qg6t3Aansqn1lpnO4ZKYVl3nlWecpIQ9l7B0MC9KJ5fJdf1OGLYn+
         S76Q==
X-Forwarded-Encrypted: i=1; AJvYcCXPWjUB7U19CmV6C9DWsMNnCzY2zETSziB6ae68Bp7sld0N1RCptDzKPNkBzxUO4bcZM9WHpKeJZw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBSbGomooeg5x+xDrNx6k19abg/tai2KuvI6MIYplFn4C7DzX1
	DAUrmRLGlN0W7TZcvT++/XUhfsLxckkWjj4cXFgLYpvzpntfCdXdVkgqQCZtvmNbhJHdfRdAGGt
	2GLdLEo3RU1ewX+BhoeZfNeKfJg6Zqvvmey/c
X-Google-Smtp-Source: AGHT+IHqm3JCcp0eScs8D5oITUUz5N3aUkse0BKIwmP0WSQYVK7EInkxnk7vCHfqPkAaZaebrds0GqRrN6CzUJUgjRI=
X-Received: by 2002:a05:6a20:9f05:b0:1d3:1fea:27d8 with SMTP id
 adf61e73a8af0-1d52d0c293cmr1093498637.5.1727722517345; Mon, 30 Sep 2024
 11:55:17 -0700 (PDT)
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
In-Reply-To: <CABCJKuedOj+E15YLZrC4nePx4g4YLO-3dzc3tyyx1S1_6HysJg@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Date: Mon, 30 Sep 2024 13:55:01 -0500
Message-ID: <CAAFS_9FuSb7PZwQ2itUh_H7ZdhvAEiiX7fhxJ4kmmv9JCaHmkA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
	Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 1:07=E2=80=AFPM Sami Tolvanen <samitolvanen@google.=
com> wrote:
>
> On Mon, Sep 30, 2024 at 10:10=E2=80=AFAM Will Drewry <wad@chromium.org> w=
rote:
> >
> > On Mon, Sep 30, 2024 at 11:27=E2=80=AFAM Mikulas Patocka <mpatocka@redh=
at.com> wrote:
> > >
> > >
> > >
> > > On Mon, 30 Sep 2024, Will Drewry wrote:
> > >
> > > > > The dm-verity behavior was reported as a security bug, so by defa=
ult, it
> > > > > should behave in the secure way - i.e. restart or panic on I/O er=
ror.
> > > > >
> > > > > Do you intend to use dm-verity in Android and ChromeOS in the les=
s-secure
> > > > > way where it returns -EIO? Have you audited the Android and Chrom=
eOS
> > > > > codebase so that -EIO can't cause security breach? If yes, I can =
make a
> > > > > configuration switch for you that will enable the old behavior.
> > > >
> > > > tl;dr don't change the default behavior, but adding a reboot-on-eio=
 is nice.
> > >
> > > OK, so I can revert it if you want it.
> >
> > That or an argument so the old behavior can remain for those who are us=
ing it
> > (I can send a patch for that if it's easier too).
>
> Thanks for chiming in on this, Will! I still think that adding a
> separate restart_on_eio (or similar) flag would be the best solution.
>
> > > I'd like to ask - there is another change in that patch - I changed
> > >         kernel_restart("dm-verity device corrupted");
> > > to
> > >         pr_emerg("dm-verity device corrupted\n");
> > >         emergency_restart();
> > >
> > > Because kernel_restart calls reboot notifiers and they may in theory =
wait
> > > for the bio that caused the restart, resulting in deadlock.
> > >
> > > Do you want to have this part of the patch reverted too?
> >
> > IMHO, that's a good change!  If the policy is to restart on corruption,=
 then
> > it makes sense to avoid the reboot notifiers.
>
> While I agree that this sounds good in principle, devices that use the
> restart feature typically need to pass the reboot reason to a PMU, for
> example, and it looks like Android devices depend on reboot notifiers
> for this. Here's a recent Pixel implementation that checks for the
> "dm-verity device corrupted" command as an example:
>
> https://android.googlesource.com/kernel/google-modules/power/reset/+/refs=
/heads/android-gs-comet-6.1-android15/pixel-zuma-reboot.c#81

Good catch! (It's a shame it's using text as the API!) I totally
spaced on that, and depending on where the corruption is, you mind end
up in a boot loop.
