Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788613;
	b=VWgp9WoYR/QZ3nHTX0jEeoAgWVPaeX72XQ/3z+CwxBDqyLGnR7XvVoBseBBIbSmvc9yh
	 H1Fu9dm7R7RfZo622t6UeVNDeS5ApV3jI5x7LqKc83sMtob9uDNjcV2sOa/Fc44otYso8
	 uWEEsjqJfP8k9bCQa5DnoENx3a6rzj6A92jIlgjzMlvzVAXq0hZY15bTlPBvzL9iin5r9
	 gDdukLZNlyLvkE3WfZ2S2aYlxkIUHRRe8e3rZg8gXzgGDUHsLO0qXQEdIHPUpmbRdZEKs
	 Y0rF2vT3tCt9wDe/wfnWn324IQG0+Cw6aY6tA4cTN86oV8zZSSOaOID2cVIN20Ik87Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788613;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=POY3PtCw6AWi52mdGeMvRvI9s8OyovbrUPaW5SRxzKk=;
	b=fmYfenMGdPAWtrokmTAYkJY11XK11cPsklNm3DwNcA1FW21um1XzhR1skzG8K+Gusm5Y
	 xwS4Fsj5zOU0JZMN+KcmDcmJOwH84nKtuifFAwZbbBtD/lbh6ESxNvgf7FSvjejM+ecO4
	 6j7cs2Ct0xfN6uGa6xj45QnuHE3AsU6H+O0R3QXFApxuFrPGyjmfpfNEs0TnZQbvTVGDG
	 Uv/lOLNh+EqeyGLXynr0HsLYY5Wa7CQaq4UMstNQ8xnILbojCtABWLFC2sjPqjH4iT4bx
	 1ssJPgDgNO9ICU7Iv1L9HAYZZw27OXzfVeMzDC7Mz9JD6ZqOCDe5XxowHJJYZbkCNbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JWu4lcCL;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACCD606A31A
	for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 20:50:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ACCD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JWu4lcCL
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1063251f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 13:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792788611; x=1793393411; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=POY3PtCw6AWi52mdGeMvRvI9s8OyovbrUPaW5SRxzKk=;
        b=JWu4lcCLRRtTEdR3McW5rjs8P8KhDM3m70Q8ReD9BRdJkG2V94rxYdzslweEfekul6
         FwvIa+k9RC+jV1tpj3fHvo19jWs6tdAhcAguy/jmtyH7xD3/tfxieTf6N0XwShA9qt2b
         9pSZN8pcBBbUxJsqCWhsbUBX8NuIeJaApL2pQT0W68QYjnCMUFsjpFSy3K9wXz4cX1F1
         tEhhwFrVZmW1cZNB+1qCRqMnoD5rCcjiMeswOACUsuD7gO1exJdFrQy8k5/KEO0347j7
         JY17pjUydH8FJqUJ8b6g84MQghm2Z/Y8wMZVWNLrNgMPOBoCtUYgjCtYIPXzL5WoQNTy
         3dmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792788611; x=1793393411;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=POY3PtCw6AWi52mdGeMvRvI9s8OyovbrUPaW5SRxzKk=;
        b=gKrKF7LBvDKiZLZhhNUHsCN1UdMTHu6It6ED3mEPKgby1+6WqvrCFy11aqQLazyKVy
         oLnDn8tZy+yPWWOIbHkFUqMkI8BJ++MlpM702GCRbj5vhS2KGR31jE3L7wMbUB9h54Ua
         DDWX1Z7As2g9JTs5/+3tKveuVWwVsX25nb4GpO5Gja9q8c6gBcwzjwfsBhs+pzE8yvTi
         8eUx/Sk+riDonAvPBM21zh8stNafAK9hAsPqEuFzocoMbyloF/4PNbrOazegFZ9K7MIK
         pML8wZn2SxIVxlKrdR5sp/yVNIlKbrpCrL7/JHZyuviyqPy/ssiEVMvvUGWsEA3T0Gtf
         JVLw==
X-Gm-Message-State: AFq9FYLdCh12KF2dO1dK+OWkFb9wfAQFfos6N7QncH76VyBViYYBngde
	LScW/Y3sFSigclkFd8iOjZ02psQRvj+YtHwUbPtHK/tYlshkMuQLdnFHG6PlYQOPTSo=
X-Gm-Gg: AYBFou0cYZWGKVD3RqhCqksJ0z/VGChrijwrVnv3wGMKjTtlahOa0sgnmPQi06tqpDi
	/SdcBIL0+pf1z4uoQ1ys/T59jMS9bZPefPAUYRUuNJA5ldrtbOG4+EeXhHAg1Ohckf9XpBdb7o4
	G6zvn8Z0L72LyviHL5NikoPQjDzcxrXSFhvEQuhgDvp2yVEFaR483FimQfxHh0MVSCKGkUDzaOF
	zS+n1pffHSOVSV9QEpbMcRUqPSqV7AxVmfV0dUo8UVAltS6nc6fbC15spBIPENF/uPaUIGbOC3S
	bi//7atTfrvJWX2qaooaXIcXJ0N74eh25pEnnyIaut9HIIRKePCJ+juNVg5D2RvGCaZTy1dTOmT
	kXU4maGIIr7iNY400ZVj2mmW1i6dovJrBVHsoNCz/QFOx0BFWSc4iGvo5xcLc/pSLaywf6GVCg1
	FkTg6JLyBHVOXRVjNiweKv3oxt8O/T8rs5gQG8zydxxlgDYqRvcAZxOo191k27oEOTYfY7cSLAJ
	lNZMLSSWGHCK+D4on9KbQQFReSdZsptbqb0ZiNvvrPdZP2B6+1sbKSzEcQx7eQKXbJeR3WMf3WF
	SsnXyIAEInTuHB7r4Ybtpg2c318NrWVsfW42qioh9vE6RPWRh/JUm592WHSF+GwDdgpp0BdzD8z
	HcsCgognU3Z5JQg4ZjKpILIeDVwZDOHE3vm9qtt5c0OGiqR8g
X-Received: by 2002:a05:6000:184e:b0:48e:b32:9d1c with SMTP id ffacd0b85a97d-48e3eb780demr229701f8f.19.1792788610475;
        Fri, 23 Oct 2026 13:50:10 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb902sm286697f8f.24.2026.10.23.13.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 13:50:09 -0700 (PDT)
Message-ID: <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Fri, 23 Oct 2026 22:50:08 +0200
In-Reply-To: <atqpOBViqKWLZ7Q3@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
	 <20261021231959.69270-1-brian@purestorage.com>
	 <20261021231959.69270-2-brian@purestorage.com>
	 <179270025923.152861.15521453184442767016.b4-review@b4>
	 <atqpOBViqKWLZ7Q3@redhat.com>
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

On Thu, 2026-10-22 at 20:24 -0400, Benjamin Marzinski wrote:
> On Thu, Oct 22, 2026 at 10:17:39PM +0200, Martin Wilck wrote:
> > > ev_add_path() sets mpp->force_readonly when a newly added path is
> > > read-only, but never clears it. If a map is created or reloaded
> > > while
> > > its storage is write protected, the flag stays set. When write
> > > protect
> > > is cleared, the reload that uev_update_path() does for the
> > > DISK_RO=3D0
> > > uevent uses the stale flag and loads the map read-only, even
> > > though all
> > > of its paths are read-write. uev_update_path() clears the flag
> > > after
> > > that reload, so the map only recovers if another DISK_RO=3D0 uevent
> > > reloads it again. If none comes, the map stays read-only, and
> > > since
> > > mpp->dmi.read_only is then 1, needs_ro_update() also ignores
> > > later
> > > DISK_RO=3D1 uevents for it.
> > >=20
> > > Fix this by setting force_readonly before each load and clearing
> > > it
> > > when the load reads it:
> > >=20
> > > - needs_ro_update() now sets force_readonly whenever it returns
> > > true:
> > > =C2=A0 to 1 for a DISK_RO=3D1 uevent, and to 0 when all of the map's
> > > paths
> > > =C2=A0 are writable. uev_update_path() no longer sets or clears it
> > > itself.
> > > =C2=A0 If the map has no dm info, needs_ro_update() now fetches it,
> > > and
> > > =C2=A0 returns false if that fails, instead of assuming a reload is
> > > needed.
> > >=20
> > > - ev_add_path() sets it from all of the map's paths rather than
> > > only
> > > =C2=A0 the path being added, and only when it is about to load the ma=
p
> > > =C2=A0 (need_do_map). mpp->paths is up to date there after
> > > adopt_paths(),
> > > =C2=A0 while mpp->pg doesn't contain the new paths yet.
> > >=20
> > > - update_map(), which does reloads that were delayed while the
> > > map was
> > > =C2=A0 waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the
> > > map's
> > > =C2=A0 paths before setting up the map.
> > >=20
> > > - dm_addmap_create() and dm_addmap_reload() clear it as soon as
> > > they
> > > =C2=A0 have read it, so it only applies to the load it was set for,
> > > even if
> > > =C2=A0 that load fails. Otherwise a failed load would leave it set,
> > > and a
> > > =C2=A0 later reload for an unrelated reason, such as a path group
> > > change,
> > > =C2=A0 would load the map read-only.
> > >=20
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> >=20
> > Almost there. One remark below.
> >=20
> > >=20
> > > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > > index e3870f5..c994715 100644
> > > --- a/libmultipath/devmapper.c
> > > +++ b/libmultipath/devmapper.c
> > > @@ -539,10 +539,15 @@ static uint16_t build_udev_flags(const
> > > struct multipath *mpp, int reload)
> > > =C2=A0
> > > =C2=A0int dm_addmap_create (struct multipath *mpp, char *params)
> > > =C2=A0{
> > > -=09int ro;
> > > +=09int ro =3D mpp->force_readonly ? 1 : 0;
> > > =C2=A0=09uint16_t udev_flags =3D build_udev_flags(mpp, 0);
> > > =C2=A0
> > > -=09for (ro =3D mpp->force_readonly ? 1 : 0; ro <=3D 1; ro++) {
> > > +=09/*
> > > +=09 * force_readonly only applies to this load. Clear it,
> > > so that it
> > > +=09 * can't affect later loads, even if this one fails.
> > > +=09 */
> > > +=09mpp->force_readonly =3D 0;
> > > +=09for (; ro <=3D 1; ro++) {
> > > =C2=A0=09=09int err;
> > > =C2=A0
> > > =C2=A0=09=09if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp,
> > > params, ro,
> > > @@ -578,19 +583,23 @@ int dm_addmap_create (struct multipath
> > > *mpp, char *params)
> > > =C2=A0int dm_addmap_reload(struct multipath *mpp, char *params, int
> > > flush)
> > > =C2=A0{
> > > =C2=A0=09int r =3D 0;
> > > +=09int force_ro =3D mpp->force_readonly;
> > > =C2=A0=09uint16_t udev_flags =3D build_udev_flags(mpp, 1);
> > > =C2=A0
> > > +=09/* As in dm_addmap_create(), force_readonly only applies
> > > to this load */
> > > +=09mpp->force_readonly =3D 0;
> > > +
> >=20
> > One minor issue here. If the reload below fails, the map is still
> > read-write
> > in the kernel. As we reset force_readonly, it will remain so, at
> > least until
> > we get another event with RO=3D1.
> >=20
> > If the RO reload fails with force_readonly=3D1, we could set
> > force_readonly to 1 again
> > after the failure. In needs_ro_update(), we'd then need to modify
> > the fast
> > return clause "if (mpp->dmi.read_only =3D=3D ro)"; if both are 0 and
> > force_readonly is
> > still set, you'd need to check the paths and see if there's still a
> > read-only path
> > around.
>=20
> I can actually see both sides of this argument. If the reload fails,
> and
> the next reload doesn't check the paths again, we really don't know
> what
> the correct setting is.
>=20
>  This may be overthinking things, but we could make
> force_readonly a three state value, somthing like:
>=20
> MP_RELOAD_RO
> MP_RELOAD_RW
> MP_RELOAD_RECHECK
>=20
> If mpp->force_readonly was MP_RELOAD_RECHECK needs_ro_update() would
> always return true, and dm_addmap_create() and dm_addmap_reload()
> would
> check the paths themselves. Again, because these could be called in
> cases where we can't trust mpp->paths to be up to date, They should
> probably loop through the mpp->pg. You can make it always correct to
> use
> mpp->pg in has_ro_path() by moving the calls to has_ro_path() to
> after
> setup_map() is called. If that succeeds, that pathgroups have to be
> set up
> correctly.
>=20
> If we don't do something complicated, it might be better to always
> unset
> mpp->force_readonly like it patch currently does. It's an unlikely
> corner case and at worst you would get a readwrite mpath device where
> writes failed, because the device really should be read-only.=C2=A0

I agree that it isn't a big issue if such writes fail. But if some
paths are still read-write, writes might actually _succeed_ on them,
Data corruption would be possible, as some writes would succeed an
others wouldn't.

Am I overlooking something, and this is actually impossible? I guess
it's highly unlikely because in practice the ro/rw is toggled on the
storage side, and happens per volume, i.e. for all paths
simultaneously.

But if that's true and writes-succeeding-although-they-shouldn't is not
an issue, I wonder why we go through the hassle of setting the read-
only attribute on our maps at all. We could just keep them read-write
and trust that the writes (which shouldn't be attempted on read-only
devices after all) will fail at lower layers.

> That seems
> better that making a read-only device that should be read-write.

If this is consensus, Brian's v3 would actually be preferred to his v4.
It isn't a religious matter to me, I agree that failing to reload read-
only is a highly unlikely thing to happen. But I'd like to clarify the
question above.

I am not so enthusastic about the idea of the 3-valued force_readonly.

If we want to do this right, we need to check on every reload. And IMO
that means that we need to track the read-only state of the paths in
multipathd. It's cheap to retrieve the "ro" attribute in
sysfs_pathinfo() and track it. If it changes, we expect an uevent,
where we check DISK_RO anyway. The logic could be similar as it is now,
but we can check on each reload whether the map should be read-only,
because the check would be just a cheap loop over the paths. And we
wouldn't need force_readonly at all any more.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
