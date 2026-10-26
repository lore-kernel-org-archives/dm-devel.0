Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053393;
	b=X/COuuWkTHLcr70IMDDxAUtcB9uxSvCJf1DCLAqHrcajc+wjF40Rr6WOBAG5HprgrLIr
	 V01X0yTgRV1gb5eBAEPjdHLfAh+9ssJoHWxafNW3MRY3AQ3fzb4kUDBWgBMFjyz48w69s
	 SGOa8KmMGrEDJmKaGYCgmLrV5gLmzBk4y9O0cp6orteaclzy7kDAgHgSLOFRMoA5mZtfF
	 gn7LvaRQQ5x5AAT6YoklUb6pXBXnvYFrSPY620KRkgXsrJNJc6eV5b/FgeZeJfEBNmOfm
	 tU6u0lQdguay0d8wG+fVFQA16hiJ4GDi/h1fgbW9UqQfKvTwFJc7UlnmVy7s1dIhYlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Gu2/BPW/2cFQhoP8EXrWwsfOKhNWeMgwHBYmIZmCB4I=;
	b=Swu899xCVyaljH4Y4a1WHffoc1LG4eJceVaHu35HZIzARM59sTFxnKTtdlVZTYJUaLYF
	 ieWC36P4VzG3v5ME2E8LaDvFUal9mzI8aviFZaUibeZoCxU4qRr/Vs1GbLF2f4lps28Hb
	 34g9P/IcEUIZ6SUVCWTfpSUk4rs9SAeXjatP8OmSyElP7wB1BCYJnv5JSnVps85TRD6oo
	 5kMFqiII7gojFqnIhb0mH7WTw43doKjHmxiYHFT47eq+Xj0kbOynerR5zorNa18kA8UN+
	 zxjMfT+5hae1KstvQc4KgYAmjul2RO777xreROoaQ+GkyyD7VMMXZfyWHDqTjGTQTPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=e0F+IShZ;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0486D606A31B
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 22:23:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0486D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=e0F+IShZ
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48df8fe8513so3263996f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 15:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793053391; x=1793658191; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Gu2/BPW/2cFQhoP8EXrWwsfOKhNWeMgwHBYmIZmCB4I=;
        b=e0F+IShZQHXl7G6JX31SJjUgLPvEbNJc0Smwdyh1aJX6qcSOa0/to9gVkySGZwJ1O/
         exEwbef3lkzt+yYfk8ieSsyi+aMphlqqEKYDAbS+EwT2/sg2Br7VxVtX6rxN6rHrq3Vw
         lKSPxuN5e/vAfz2YkmVTG1UBBaC8daRt1rNnYaPzL9wF2TqwECKWDplEY25joAEsjZpb
         0ODdhwgsNvZ9AzA4qZcmyict6tadlzu6H7qsGVlhXZHhfOJf4RoDLVWVOvSndeugwg2n
         AXIWcz8pCVyXjwLnixS/sZ5zZdW6kRaLKZKpBUY/N7f00fRTFPIEI78qYX7K60TioBwx
         plBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053391; x=1793658191;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gu2/BPW/2cFQhoP8EXrWwsfOKhNWeMgwHBYmIZmCB4I=;
        b=zFB0dYoS3OOrq2MudqErOLVgf5Q7/tuoQSOG4zmL08l2m3TRiwgh7mhqxA6iXugtf/
         iTljWUjpMp9od//KBINat9t99hhw2IPW0ZhYkkZEGZJENac4Gvkk+QpU8qt9Zv1Xtl52
         FNnjxuTqnRykn3E2OHH9FtvdnnF6wMDv3hZxEjUfkbden0IhHWY/W0aovD64UpsN3n9f
         ZcVadGLhtJ4VIEKJZNTSipp2xU9o5YVB2s4Gm5JmCmAx/BpMl2fMTKepieOlJTYiMmtk
         Rnh1I3YKtUXfO16rrKIpsfNoJmzgtRFMXv96qwqft+zql4fW8a6s/pabwRidw9gUlx4l
         Hsmg==
X-Gm-Message-State: AFq9FYK1Gf/3E5xAyNXCgsZB9ZDW4inqTShGjX4Mk6JVirGh2yj1vJlg
	WgE/0J9Hhw+fSi6/djCEXLOvARNfMJlVnmiEckuX8FgaSR845RB5KBAh74ZdHUildjc=
X-Gm-Gg: AYBFou05sG3mqBVEx/kfwapyEkG4QuIkHGFF33BrxS+fWzXK5fQhpjxQlHua4ZAoG6h
	aUrZXpcKAjIIydUOQRT1wbQvg0F5qIJRnyT68d3tSX4jMNqoJ1tYOBYYOUcqP+4j1ded1hNnjBP
	m9ZfIGncGLraH8rc9jtU+qzyyS6EW7Vl54uLH+94qTuwCC28h8FPcWVyZcGuScProvmRaX/8ZzV
	XpEmHmJKJj6LjKGfjnq/rd5luIGvufKcjx735eMZrPrAvTtDpb6VQ4Qe5kgUTtqb1Xql/TcYuci
	6QeJvrlkeEyDWfWfXmjuHPQ69JtAu3IOh48FalUn628wi8R8oDOFamqJ/qdwM1IO/X+EX3Kv2W3
	0WUfYuArAQFGRPFAbulTNSPvfHdFWnmOf2yvn1Ors4dwR0lv8PDFg/OQELM5SB9ryVZQbPXQkN5
	9TBIWNjcE2pnEZyXv73EYEyUx3M1uuX6Y825dhA0vVPKn2CuJ/3opbZ4sKAXuafBGVgljqmsPU6
	k4xrXz0NjIHdR5tD+Kg12EjE7Jv3dRy1RF/ywYeXwAfxzD97DvkI9BcppodeR7qbkOdS90RnV9A
	MYjiXqLw+2R69YMCpt5LZ+AN2WNfmX3XSQdTrk8MmuD98HuPFZQ1CTlLkwPuvS4FUtSa8IPjmud
	/SnWtPjTTBDGkoGxQqGtG6zPGsw==
X-Received: by 2002:adf:d02f:0:b0:48c:414f:cc12 with SMTP id ffacd0b85a97d-48e3eb9261dmr10639790f8f.40.1793053391228;
        Mon, 26 Oct 2026 15:23:11 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdd5b3sm18698813f8f.53.2026.10.26.15.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:23:10 -0700 (PDT)
Message-ID: <ef9e022a6ca2ed35a2a3239dc019cc5860c20986.camel@suse.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
From: Martin Wilck <martin.wilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Mon, 26 Oct 2026 23:23:09 +0100
In-Reply-To: <20261026180444.31357-1-brian@purestorage.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
	 <20261021231959.69270-1-brian@purestorage.com>
	 <20261021231959.69270-2-brian@purestorage.com>
	 <179270025923.152861.15521453184442767016.b4-review@b4>
	 <atqpOBViqKWLZ7Q3@redhat.com>
	 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
	 <atvweCfhjWkT9i-U@redhat.com>
	 <c52f077ad82585f1f02d5b9cc9c3f640e9fcc031.camel@suse.com>
	 <20261026180444.31357-1-brian@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-10-26 at 11:04 -0700, Brian Bunker wrote:
> On Mon, 2026-10-26 at 10:26 +0100, Martin Wilck wrote:
> > On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
> > >=20
> > > I do still waver a bit on whether or not we could leave
> > > force_readonly
> > > set on failed reloads. Once a device turns read-only, it should
> > > stay
> > > that way until we get another uevent, at which point we will call
> > > needs_ro_update() again. Perhaps we just need to make sure that
> > > we
> > > clear
> > > force_readonly when needs_ro_update() returns false.
> >=20
> > AFAICS, this is exactly what Brian's v4 patch does. No?
>=20
> Mostly, yes. v4 sets force_readonly back in dm_addmap_reload() when a
> reload fails, so the next reload tries read-only again.
>=20
> needs_ro_update() doesn't clear it on every false return, though. It
> clears it in the dmi.read_only =3D=3D ro case only when both the map and
> the uevent are read-write and none of the map's paths is read-only.
> If
> a path is still read-only, the flag stays set, so a map whose read-
> only
> reload failed keeps retrying instead of staying read-write.

Which is correct. If the map is read-write but there are ro paths, we
need to retry.

There are two other cases where needs_ro_update() returns false:

1. ro =3D=3D 1 && dmi.read_only =3D=3D 1
   I don't see how force_readonly could be one in this case.
   But maybe we should just reset it anyway, just to be sure.
2. ro =3D=3D 0 && dmi.read_only =3D=3D 1 && map_has_ro_path()
   Same here, read_only is already set, no need to force it,
   but resetting force_read_only wouldn't hurt.

> About dm_addmap_create(): agreed that the flag isn't needed for
> correctness there, since a new map opens all paths fresh and a
> read-write create fails with EROFS anyway. It only saves that first
> attempt. Create still clears the flag, so that a value set by
> ev_add_path() can't carry over to a later reload. I can drop the
> read-only shortcut in create if you'd prefer.

I am uncertain about this. If we know in advance that trying to set up
the map read-write will fail, how much sense does it make to try? It's
just a minimal simplification of our code.

> Uday Shankar, who did 430f8f89, also suggested dropping
> force_readonly
> altogether,=C2=A0
> and tracking the ro state per path in sysfs_pathinfo()
> sounds like the right direction to me. But it changes behavior: every
> reload, not just the one done for a DISK_RO uevent, would follow the
> paths' ro state, and so would "multipath -r", since
> dm_addmap_reload()
> is in libmultipath. So I'd rather do it as a separate series on top
> of
> this fix, and keep this one small enough to backport.

Sounds good to me, even if it may mean that this particular patch
will be short-lived.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
