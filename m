Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3C194C6A
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727716242; cv=none; b=WCjDKkAafDVLm/0UMuGGj8Di+ff8lwMdRKfJHyG2KDBay9qonolkzdjof2eOvw3YdZYAM72T+b7pPaaQR8bYJgXCzApX6sRJmgOj7fvhAjWVdeB4ltHzH5SrDBzK6hoHVMDtqZnvDNPNLIcx5gpBFfhT2GP/VXfYhLwCG6lz18M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727716242; c=relaxed/simple;
	bh=+fo7pQdRrIn2jrxh4pYOCDpFPp89SvoXDvUmlS5S3HI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9s7OvLA7sOY06UGi1Nu5QSC2C5xTYQyqr3GKDZ0YIMo03FlZfOsJTI9zlMq2FPDkkBBxjar7ZUg+ge8wH+usrQGE76PfVmAzT4WSFrXp8uOn/gQGc5x31SNaQCL2Gb7iQyKt5PoQVwUS60/T56wA95nuK9JbvTVinrlf+sOeoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=google.com; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jiIp+Zvu; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jiIp+Zvu"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7db4c1a54easo2886600a12.1
        for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1727716240; x=1728321040; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xIsaW5VgBwxTjPu2I3yiLEbo0c5h0rbV157nxlkvHes=;
        b=jiIp+ZvuL6MwEcNGVZY+vonkWpABomjqdE/lWQSbDmqMqvSdOMLkyq79PPktEf7FYe
         K5WLy0AElLVjhYYGhMt4i5h1UEkLh2b4WAru9Me7btSrdx987N6gPWrL1aDhgRGO6C1T
         TNhOFcGQUZJ2OEqE7RaRH0QXP39cqi92IWISE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727716240; x=1728321040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xIsaW5VgBwxTjPu2I3yiLEbo0c5h0rbV157nxlkvHes=;
        b=WyTV2sA2D/ix8NLJYMP+pGjMfvLtqqcY9/PWZKp6d4LxOUthVsNyIRB0ow3eNsLadg
         oZW0v7zAySjolAOCUkJG7aFziM5nK1T81h+cZL8vhZrxs9J+rvxU8bBa4UciEMpMkLXl
         nVNRTsxn3r10pmxnqLS99fhlRl3vvpg63ZTIqUGISm5pJe/Q+f6QVCZyKOVJfu/nX9eS
         rz7K9ikyHego/4mk9Ls10K4nvh0GV68F/BM+YvKNnCnIekoN3H8M12mDwDEOwvc6F+S1
         PWGnbUc133dAenyZnAz8l56TsfxXQn82OW9VxJKrh867MUKFArHc9JJYzHfG5RtVVABS
         /ToA==
X-Forwarded-Encrypted: i=1; AJvYcCXNadDQiwP0d7UyEjybKldM2h2frgvHiRIU46ceHJZk/AF+fhjd+ayuEuEfQr/hdAgD7bkEgQTpmw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyflOt+MPFETFHTjSbazRLqeucs56rWVVucNpG8b1xDvicOkpn8
	vr7pO/rCECkBE7HOtoOOG3KHFx187/hf+023fl95UEcEaaTRT9bm/ptvhvfJbY1Uwru+LWuaq9s
	04IzB6BuI4Id9FwQOqd1uC5LdKV7IfjgB8JjH
X-Google-Smtp-Source: AGHT+IGo9Exzj1TYZvMGSEVajdds50rRZArhviai5ygDXe/dB/CmOLHM+fr0niYY6lY4p76Fc0QNCbq8tMjBJKpBgTM=
X-Received: by 2002:a05:6a21:3511:b0:1c8:92ed:7c5e with SMTP id
 adf61e73a8af0-1d4fa6cdf6dmr20605901637.23.1727716240179; Mon, 30 Sep 2024
 10:10:40 -0700 (PDT)
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
 <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com>
In-Reply-To: <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com>
From: Will Drewry <wad@chromium.org>
Date: Mon, 30 Sep 2024 12:10:23 -0500
Message-ID: <CAAFS_9HyeD795N4RFKWYcP5VCFBCxmoXgGg9UbGy80Bxz7j1mg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>, 
	Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 11:27=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
>
>
> On Mon, 30 Sep 2024, Will Drewry wrote:
>
> > > The dm-verity behavior was reported as a security bug, so by default,=
 it
> > > should behave in the secure way - i.e. restart or panic on I/O error.
> > >
> > > Do you intend to use dm-verity in Android and ChromeOS in the less-se=
cure
> > > way where it returns -EIO? Have you audited the Android and ChromeOS
> > > codebase so that -EIO can't cause security breach? If yes, I can make=
 a
> > > configuration switch for you that will enable the old behavior.
> >
> > tl;dr don't change the default behavior, but adding a reboot-on-eio is =
nice.
>
> OK, so I can revert it if you want it.

That or an argument so the old behavior can remain for those who are using =
it
(I can send a patch for that if it's easier too).

> I'd like to ask - there is another change in that patch - I changed
>         kernel_restart("dm-verity device corrupted");
> to
>         pr_emerg("dm-verity device corrupted\n");
>         emergency_restart();
>
> Because kernel_restart calls reboot notifiers and they may in theory wait
> for the bio that caused the restart, resulting in deadlock.
>
> Do you want to have this part of the patch reverted too?

IMHO, that's a good change!  If the policy is to restart on corruption, the=
n
it makes sense to avoid the reboot notifiers.

Thanks!
will
