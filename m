Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB11990AF
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397618; cv=none; b=Jwvr9gR/qE9qYXX3kyIUM5OjkYME891IYmDxLfGXWj+q9MRWXHLpJ6/vjVIzJE/f2/PI3Zh7KnD4LvfMEOkLWBYTaHiLz/toeZDnXNkFXix29lewJQJog9+R/La+Rr9bEOltmsBVMyALLaG8d2r49IaRlAs45BoOACVmqApNo5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397618; c=relaxed/simple;
	bh=EW90kHgVCP6Jo+hxB5U4/0NlUkmkECYqO7KOnrXpKxk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pG47BEL8RSH0irQW9u5I/wfea0/C5fcifyOCHnzyit615OHm9EBbTADHlwjiRuosGzJZIPc4x1Gm5YOSKpAWxwKdkCfn6UEioh3CDludBF1hb91s5ZdURQdWMsLnggrpdFxL2ngvEmNGBx3v4VuWmVhh1V884Tw3JQtlRp6ZNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xlnxxde0; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xlnxxde0"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d5aedd177so3132979f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 23:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731397615; x=1732002415; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EW90kHgVCP6Jo+hxB5U4/0NlUkmkECYqO7KOnrXpKxk=;
        b=Xlnxxde0UMvHVxoFV6BwXJrHMyyKb8VD/8LDkHU4R3nQeT4MV/JaSV2FG4xj2RSAaB
         gowh+H3jubkzJ2jmS/jcGHda8tJR6n/LU1rx5Nj7nqD7ArfdVAl8pVgsj+8CkFdviz5H
         Rkr+B6fjsmy67d8GFfM7tCR2pBYyLFZxcl1Z9SoydW2n1V4thav1bXwvkanxtl13EGCF
         B7HacrKunzZZGvg5aWHGLaeiDuf2+uHf09ujhqE69veuxb5kOKP3/k0dH01Fkw0NRGCn
         PhxPhGFqzkIGW5U8unMPzQVZtKTuAaepeaQ3XRhClJF8EaHjQY5NEyPicZVXSHHG3nFe
         YEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731397615; x=1732002415;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EW90kHgVCP6Jo+hxB5U4/0NlUkmkECYqO7KOnrXpKxk=;
        b=QQ/kJroDCt5GWT6ad7jbHz2NCtBya4sdFPani1iuIkW1xk3GV7q3pSRE+TgIUzD3VI
         kUl2LiBDbv9M9lU0eH27RbwBQKMvr/de9EtQcy6FLDX9lk1v9Xpd2y8cnPCLzIR5r9A+
         coJKcNR3IKeCXq0Qt9t35N3v9A/vCKd2JMsm6+6/ZX+Mp+f0GDBCeGPlQM9B4EC42ksW
         VM9GjG8b+LStEdDeCvC5Eq7j/6EQTR6SQQvTU/UxwTSthaCYvONookxC+7lbl6+XLLYm
         FFtYZsMqdt8/gLDkXY3J4OUl2PIRyZsBs2av+DDY5GbjR3WGModXvp/zOjxbuZITKpTp
         wAcA==
X-Forwarded-Encrypted: i=1; AJvYcCVZmoIJ1/l7sUkzuAIVhP2nGO4indZ7bwkvSWjbbitLS5FP2suJktkK3KotlvHvd+GNWGTO2NP9nA==@lists.linux.dev
X-Gm-Message-State: AOJu0YylVsZaHTkGeiDob/iORIVTWKyEyefCPFM+0IMQHV++EO0KafRd
	4wFbbopg61WPPf1Claj+1TvitvPO+bZ+IckzhXDWvEWkaFc/oeuHTKpH/wAI30Q=
X-Google-Smtp-Source: AGHT+IGB75uY9rAt/SZ2CXrSP/6MeCkK/kVxEXMSBlcBd8w3Lz3x6RAwJ/0nUkhWAZ8SuDFH/wvDkA==
X-Received: by 2002:a5d:6c69:0:b0:37d:94d6:5e20 with SMTP id ffacd0b85a97d-381f17261d6mr14078062f8f.4.1731397614380;
        Mon, 11 Nov 2024 23:46:54 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed970d10sm14500889f8f.20.2024.11.11.23.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 23:46:54 -0800 (PST)
Message-ID: <b46184d0ccf8f0c1f492a53313fe88ea33a0269e.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 12 Nov 2024 08:46:52 +0100
In-Reply-To: <ZzI8HbwgmBQSLbLk@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
	 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
	 <Zyz8SFDAkIggpuND@redhat.com>
	 <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
	 <Zy6Lz1y0-dVXvodH@redhat.com>
	 <a7b6076cc759383e407ac9e46ff39be14f5a1b6d.camel@suse.com>
	 <ZzI8HbwgmBQSLbLk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-11-11 at 12:17 -0500, Benjamin Marzinski wrote:
> On Sat, Nov 09, 2024 at 12:03:33AM +0100, Martin Wilck wrote:
> > On Fri, 2024-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> > >=20
> > > Given that the code already does the right thing without needing
> > > any
> > > changes to handle tableless maps makes me feel like just removing
> > > the
> > > final patch is the best idea.
> >=20
> > If we do this, do we still need the special case for DMP_BAD_DEV?
> > IMO
> > we just need to make sure that dm_get_maps() doesn't return an
> > error if
> > it encounters an empty map.
>=20
> Depends. If we fail attempting to create a device, we could have
> raced
> with something else attempting to create it.=C2=A0 Just checking for
> dm_map_present() before we remove the device won't distinguish
> between
> these two cases at all.

I would like to keep things as simple as possible.=20

The main mistake that I made in bf3a4ad ("libmultipath: simplify
dm_get_maps()") was that I'd changed dm_get_maps() such that returned
error if anything went wrong for a single map. That was wrong, it
should just skip the map in question (IMO that even includes the
DMP_ERR case, but that's up to discussion). Just changing the behavior
of dm_get_maps() would fix the regressions reported on GitHub (correct
me if I'm wrong).

Wrt libmp_mapinfo:

From my PoV, there's no difference between "has no table" and "has no
targets".=C2=A0There _is_ a difference between "no targets" and "multiple
targets" though, as the former can be reloaded as a proper multipath
table whereas the latter cannot. So these two cases must be treated
differently.

I think we should actually introduce a new return code.

 - DMP_NOT_FOUND should actually mean that the given map does not exist
at all
 - DMP_NO_MATCH should mean that it has targets that don't match
(either multiple targets, or something non-multipath), or that the UUID
doesn't match (if MAPINFO_CHECK_UUID is set).
 - We should have another rc code for "exists but is empty", but that
should be called DMP_EMPTY rather than DMP_BAD_DEV.

> On the other hand, there is still a window where the program that we
> raced with is in the middle of creating the device, but it doesn't
> have
> a live table yet. In this case, even the DMP_BAD_DEV code won't be
> able
> to distinguish between a map that didn't get created correctly and
> one
> that is in the process of getting created. It would reduce the window
> where we could accidentally delete a working device, however.

I wouldn't bother about this kind of race too much. If multipathd just
ignores this kind of maps as it used to, it won't do any harm AFAICT.
We shouldn't alter this behavior, IOW multipathd should neither remove
these maps nor add them to its internal tables unless they become
populated with paths.

If anything, we should finally get down to delegating map creation from
multipath to multipathd.

> Since it doesn't add much complexity, I lean towards keeping it, but
> it
> is one more state we need to handle on returns from libmp_mapinfo(),
> so
> I'm open to an argument that it's not worth it.

I agree, comments above.

> > > The only issue with the current code is that if you have a device
> > > with
> > > no table with the UUID of a multipath device but a different name
> > > than
> > > that multipath device should have, multipath will try to create a
> > > new
> > > device instead of reload it, and this fails, since the UUID is
> > > already
> > > in use.
> >=20
> > That should be handled in coalesce_paths(). It's basically the
> > scenario
> > that occurs if we enable or disable user_friendly names.
>=20
> Except that we have a mpp for the other device if it has a table. If
> the
> device doesn't have a table, then a mpp isn't created, so
> coalesce_paths() doesn't track it. We could add code to create mpps
> for
> these tableless devices, but it's another trade off of added
> complexity
> to handle a rare corner case, and I'm not sure this one is worth it.

What I meant is that if there are matching path devices,
coalesce_paths() will create an mpp and reload the table. Otherwise,
the table will continue lurking around without being tracked, which
doesn't do harm even if it may not seem optimal. If a matching path is
added, again, uev_add_path() should reload the map (to be tested).

I think that behavior is sane enough for a corner case like this.

Martin

