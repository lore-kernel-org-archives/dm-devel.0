Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D252218DF76
	for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727701155; cv=none; b=PBR42LBwmFgzWMDpGz56daw682Zrp5owW3v/X9adqGiGgRUwYeqUN4vK9Msn1xDDYqbMmMLr56TPw9A0ILL/sc6MN/WFKYw/iDX2wiCK1jFVJxVYrSAA5Tv9WG5PV+wQ3aZKDmXNgD8vD5UGJugwYUqNt2qgDVWbGqeFVXkxfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727701155; c=relaxed/simple;
	bh=bfT9sL/KqAY1FAIuxZCyplLJWWyGlSDK1OGXcYkZG7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXmFoBRc5xBINK0fNHciIqdK3PYTcFE6EWgdn3y63CKUFDstH4uZfrRU94EXqwkyJhKlxQEO8my6DvzxGZWfnx2z6zZ/EU7ojknfr2gyYPVjZk/c4+C116mki8zIRzf0Z0LKorF0Fi5UI+IZm4NQwAJnwLMGNKmfGBkJcNAr9Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=google.com; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=TbZKKJx7; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TbZKKJx7"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3e0402a98caso1915682b6e.3
        for <dm-devel@lists.linux.dev>; Mon, 30 Sep 2024 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1727701153; x=1728305953; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejnxT0ydklCr9nYbTNmFLrnebwDgWchfDZ6GUsGYtkM=;
        b=TbZKKJx749jgFY5C9xH/ETdjxtFaVPn8eDk7WgAq4P189OaH7xKftKAwB7tEIjRZOK
         wb+Z/Pyy92ZOLTmDZMvJYc1sO3cFtafJRz+bRaDTbbESO9eWIUpdh1JgGrwE/hGa593U
         n+mzSHscbO2+5gnnfLMnyef8+7v+BTgADVreg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727701153; x=1728305953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejnxT0ydklCr9nYbTNmFLrnebwDgWchfDZ6GUsGYtkM=;
        b=V/i+PsPkbDY/u2PpIVdo9q16VJJQY62+2UN5TjKof6Qfuf1VU638CJEWBL/pEBaeO0
         RdBoFtI05nFW+blAakbh5NIW1LaUmUjb+jRACvrwAQ8hRRMLLK55wciX/LUD7j0Ys8Au
         2p8ddWbFXoIc+QW9amMd78dfR0fU92DsmQUoF5vkObgeXlSc6wLETH/9sJzDbmAfa2DE
         lAtnH3CjkleM2G5IXkLjjzJ83dCO5/EPt17mS2CbaIA/PGo9Eo7rl2f/ibcHfKEo4dnN
         YPYFSBc21YomUswh0lwRT6TyBgKhKydhVFw9W4SeVtJ8r31rjoES5RWE6OejcoEVvhva
         Zz0A==
X-Forwarded-Encrypted: i=1; AJvYcCVPIPo0XjJCOUsSmVji63xJfWzQPAIQakeSK8BC7Z6O/e699x63DmihYv5eBiqMl9k0+DVjd4o5fw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHOutb88SG61lmReh4O2CHHQUrsQKmPhBbd8hKRsTLkKPpcapd
	0QIYGPkxvTuX4Wdxh0Ru5FKz862HddlaqoyHouMe5eypRM5NEu5ubkOU1Y0UV3M4GYZeLtjLsdh
	KaQaly8bJ5N8Zaa/1l6HvXip4d6vEOz1aIXK3
X-Google-Smtp-Source: AGHT+IG7nlWC53jJ0Omnll2zK6+FiN4z4Vi9CiXyx2fD4HmTIwjoWv6ZfYwuyucp5wtWkyOzT77LpmAQFV9jByUCCjg=
X-Received: by 2002:a05:6808:3195:b0:3e0:3ab7:d7ad with SMTP id
 5614622812f47-3e39397ff9bmr7481164b6e.22.1727701152672; Mon, 30 Sep 2024
 05:59:12 -0700 (PDT)
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
 <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com>
In-Reply-To: <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com>
From: Will Drewry <wad@chromium.org>
Date: Mon, 30 Sep 2024 07:58:53 -0500
Message-ID: <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Milan Broz <gmazyland@gmail.com>, 
	Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 6:00=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Fri, 27 Sep 2024, Sami Tolvanen wrote:
>
> > > See for example openssh, the function read_config_file_depth. There i=
s:
> > >
> > > while (getline(&line, &linesize, f) !=3D -1) {
> > >         ... process_config_line_depth
> > > }
> > > free(line);
> > > fclose(f)
> > > if (bad_options > 0)
> > >         fatal("%s: terminating, %d bad configuration options",
> > >                 filename, bad_options);A
> > > return 1;
> > >
> > > So, the function doesn't distinguish between error and eof. If readin=
g the
> > > config file returns -EIO, the function exits with 1 as if the file wa=
s
> > > empty.
> >
> > Sounds like OpenSSH's threat model doesn't include an attacker who can
> > trigger arbitrary I/O errors. If you want dm-verity to protect against
> > this, why not add a new restart_on_errors flag instead of changing the
> > semantics of the restart_on_corruption flag and risk breaking existing
> > users?
> >
> > Sami
>
> The dm-verity behavior was reported as a security bug, so by default, it
> should behave in the secure way - i.e. restart or panic on I/O error.
>
> Do you intend to use dm-verity in Android and ChromeOS in the less-secure
> way where it returns -EIO? Have you audited the Android and ChromeOS
> codebase so that -EIO can't cause security breach? If yes, I can make a
> configuration switch for you that will enable the old behavior.

tl;dr don't change the default behavior, but adding a reboot-on-eio is nice=
.


I'll dig through the archives, but I think this was discussed back when we
first worked on upstreaming (and at linux plumbers).

IO errors are _outside_ dm-verity's threat model. dm-verity verifies that a
block that is read in matches (or can be rebuilt via FEC to) the integrity =
hash
that it can safely authenticate back to its root hash. Historically, system=
s
running on raw nand often had to deal with -EIOs in the field that were
transient or could be worked around in other layers of the system.

However, even if a block is read and cannot be authenticated, dm-verity is
not violating any security invariants by not rebooting -- it just must not =
pass
along invalid data as valid data.  Rebooting on invalid data and rebooting =
on
EIO are system-wide policies which may or may not relate to the security
stance of the system.

wrt this thread, a flag which enables reboot-on-eio seems like a nice featu=
re,
but it shouldn't be conflated with a global security stance or improvement.
Just because someone reports something as a security bug doesn't make it
a security bug -- it just means the behavior didn't match their expectation=
s
and may have a security impact on _their_ deployment.

Both CrOS and Android deploy dm-verity with awarness that the underlying
block device stack is attack surface regardless of whether the device
mapper layer reboots on EIO or not.  Unless there is a specific security
problem in the EIO handling code paths or subsequent dm/dm-verity
behavior, then at best it's a late symptom of a problem.

If this behavior change does happen, please make sure dm-verity is still
useful without forced reboots on EIO.

thanks and hth!
will
