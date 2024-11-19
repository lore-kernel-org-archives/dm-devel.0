Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C914A639
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732034424; cv=none; b=Apy5mXC2hPegDpR/YuSRCbXrKRjx03wp+5glZYprzdmI0rpnlCxLAko+AM1X7EeBfFg3LofpZ60OhdBjP3twmqFLc62p3+GU0LboAWyTBlN3mB8TnRlayf0x5RE3ZjBhA4SynA68n3aFZOzEWwu1gDicnw6f2+eNKd1GqJ+rqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732034424; c=relaxed/simple;
	bh=9f84cj2BK31kRw7DQbzHDCArT0fY1EmZZEmJG53Bylw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CivnFM1sIpp5BEjWZM9CWKO7FrvFW+8LHu+BlULCzA8glrOSUc7RxmeaTHvIrTfB5916A7u11n7qDTs0eVX7y2LXjhabISMsFDeUR4K8c1yXUJzW1TloJz2K3V/OUxqoupD/D+LIhVDOTj+EKB17pcpe4qqbyr6/tnAyYrjynM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MMz3v2kr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MMz3v2kr"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4316a44d1bbso38314655e9.3
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 08:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732034420; x=1732639220; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9f84cj2BK31kRw7DQbzHDCArT0fY1EmZZEmJG53Bylw=;
        b=MMz3v2krYVBgmLWcASle+36Ug4UvywG9ZTJ2Ia1QYDHxswm5C6P17WqPNmgqZ43iUR
         4TghFRq0bLSACl+Bna7tK8UXpnFy+D/eiYkCEoNpJPZEHh2Sy6tymNieuAO0ORjVTdLb
         s3jPr1ABTMlAHt0pQLUxKVoLXZIBTimm/Gxnjb5U8jlLuQfaQt3TidieJsHuJxtsuyGm
         eJ/Z8d3ghTvyH5UEcUx4MpzFLyWNgWs6Jpk+iCa3Ml/Ua1jwk2hT6ucuprc1dKuX39lb
         FiKz8hclXwzRsLlPPUgLPm+6YJ1FyGdfXNzuKhp9TGNbpGbJpZ1qZhoatuPyCSldD6hE
         LMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732034420; x=1732639220;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9f84cj2BK31kRw7DQbzHDCArT0fY1EmZZEmJG53Bylw=;
        b=HWIz1bI9S8GQz6MaE44BeVbpDf3xnLQi3oGRKqRP57SELfQPhQklhb6OEgXHkhWESb
         411TW2YiAJmelGY61X49k8sGYs+kcOgXae4Ut/iXNbpwv0WglupqGjvdkbdNU8OaAyOz
         udIfzP4oDwWK1PzU4lss/yy3R5K4JRGV07n/cnGx6rNu3PVvrxCxdE33rKSQql218jed
         0rbAwoCcIynUw5oi4iHSjduoVLanAAXoVFHj/olxtcY05p5HeOoKuaCc/3CbRuCOg8JS
         OClLAraOnRaeYJ2oEjLFO6e6iIPhXVr8abrOnzAzsxSd2eBL4jJ+N9bgtJNK4YclXW0l
         abGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW25e2eUEqPFwErBDFOfI63UThRh0zi0U/gYBuBcFL1t2O6D9eFihNpHyvyrxWM06Awu0dMgQhxFQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDI3J2pnuOAwPELXlMEE619UFjIusv3Z8Jg68d5oymB7cASDvx
	ALiz0PgIGyltMWgy1I/V15CiwduyXqXfqM3UP8dkez7UlMkuXl9T2b+MHseS8es=
X-Google-Smtp-Source: AGHT+IHXbXOCbV8BTOoXmvN8iDTi7kCmlHUitquGk8QjlhfQrqIFtXu743hrFgFBeZrEVQhItPQsRA==
X-Received: by 2002:a05:600c:511b:b0:431:1d0a:38e2 with SMTP id 5b1f17b1804b1-432df78e1a9mr126934525e9.21.1732034420316;
        Tue, 19 Nov 2024 08:40:20 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da28bc11sm199941485e9.31.2024.11.19.08.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 08:40:20 -0800 (PST)
Message-ID: <1a516ff0aaf34d88da065a1f504606450eb871bc.camel@suse.com>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 19 Nov 2024 17:40:19 +0100
In-Reply-To: <23860ac02355acab86798e2ce3d582ebed61a0d6.camel@suse.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
		 <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
		 <ZzuuUTMJgFPWV16s@redhat.com>
	 <23860ac02355acab86798e2ce3d582ebed61a0d6.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-11-19 at 13:20 +0100, Martin Wilck wrote:
> On Mon, 2024-11-18 at 16:14 -0500, Benjamin Marzinski wrote:
> > On Mon, Nov 18, 2024 at 12:18:20PM +0100, Martin Wilck wrote:
> > > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > >=20
> > > > I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
> > > > alternative would be to run a second libmp_mapinfo() call
> > > > without
> > > > MAPINFO_MPATH_ONLY to grab the name, if the first failed with
> > > > DMP_EMPTY.
> > > > If people think that's a better way to solve this, I can rework
> > > > those
> > > > patches.
> > >=20
> > > We could simply choose to always fill in this information if the
> > > the caller has requested it, without an additional input flag.
> > > It's
> > > not
> > > an expensive operation.=C2=A0Is there a reason not to do this?
> >=20
> > Your comments in the code said that libmp_mapinfo() will not touch
> > any
> > of the output parameters if it doesn't succeed. I didn't audit the
> > code,
> > but I can certainly imagine a situation where you passed in
> > pointers
> > to
> > some varaibles that already had values and you didn't want those
> > values
> > overwritten unless libmp_mapinfo() returned DMP_OK.
> >=20
> > But I can go look and see if any callers would get messed up if
> > name
> > or
> > uuid got set, even when the found device didn't match.
>=20
> I am pretty sure that that shouldn't happen. The memory must be
> allocated anyway, and callers can't ignore the return value. But
> double-checking is a good idea, of course, and we should adapt the
> documentation.

I just looked through the code. Except for the unit tests, I only found
one call where this matters:

dm_find_map_by_wwid() fills in the name if non-NULL. This is only used
by cli_add_map(), where it doesn't cause an issue.

Martin





>=20
> Martin
>=20

