Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B7A22A4F9
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619391; cv=none; b=W//JuQswN9AGJDsvG93yYGTtiCMC5wALdKdZmxKBF9BtbfhAbMmSaG8VUGCkf1hW1MZjQSzPxTitc4VL6FAN+yLishRgCqE6mqAZrY8t5R88OEUs9qq6OVo71qCAAtO9vX9K/LXaNzic/wWRZmu7P3yuNy8S5V8k9LvLf6bpqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619391; c=relaxed/simple;
	bh=iowIpSsW+tkPUcbv1VFnghP9iHLjNa+/CjmVxD1OMDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJB4y9UlLY3B/vWVzv21CU1F2Nn9Zw/CiNtGgt9Hknhwcx5WkAoidBZlJkCDXedX+aVam3ZnApMG6S6nDLTH8quJ2/ZVV9A/4pM6NsL4GjzokeigSeUGAeaiDvTERQrd9H5Sxn2eWKwV/f29C474we+4uDil54OOMC8xnp3tszA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQRFyqHz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQRFyqHz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741619388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLAw42LifKAagZTOAxuuyPqHbggBm/WLwWsxZBibQ1c=;
	b=VQRFyqHzM/pA0lLnizW+oQ/e2bm3f4q+GtXKKXnDRZxfJbrN0uiW11zZmXhQkcbXP05eaC
	gimYn2fvTWFYqnqOvVbEfJ69gxkU/rqnkyaD1/h0Wwmaeqc0e5tFKM1uEy7XBGduCsX65u
	bRybLAelSmqWThhLJ0FnX2TaYg6/+Rc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-Ix6OJRh-PF6XmreE_pHNNQ-1; Mon, 10 Mar 2025 11:09:47 -0400
X-MC-Unique: Ix6OJRh-PF6XmreE_pHNNQ-1
X-Mimecast-MFC-AGG-ID: Ix6OJRh-PF6XmreE_pHNNQ_1741619387
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6feeba593dbso18445667b3.1
        for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 08:09:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619387; x=1742224187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLAw42LifKAagZTOAxuuyPqHbggBm/WLwWsxZBibQ1c=;
        b=LkmBReVDxO/z14owl/c7TLA6Rq1y5WvHqcIDVWzX8WTCyXZvTVuotjhY0fIRKOKXqg
         M0ZdvZM73qKeOC+BLptHeQWkmZ7Cnaq92Vl1zMI4xu6NkaN3+ShMlu1L4/zGveKXx2/S
         AQ3QMln9vngD3mR964WXe5oXtgYsi9KiYHhHK2wsoXZY0Nsy837bLfKYA6CeQmYkkJ+Y
         6mNvJbrpikF3irBC2EFYQ2sG1Slcyd8yBeu3y8dkZveJ12epAbzEIXWY21Dq08sd3D/i
         yNOEcd30gepXC9wHJvDoPGlAMMBLypedYf8sipOTA9klHbMwCSYLAkPRTSqHhaGa+wHt
         XXUA==
X-Forwarded-Encrypted: i=1; AJvYcCVuF7zsJBlvxYHHHdpoCpsLyClfm47DVasK25AnvczHGyidcYWb0P3NqOrerH+ZKulid4yICFD9Mw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzki8NQt/pmBZC6t5pbIbbQYO39jVPwUYiHrWZ+0RUnILAFARqD
	xlB/LW8D+rWtex1+BGyroLjeK6GHFmps/JK/zK5S3N2tCMVN8CCdIRQ4g+Au8XP5d3BIpHDMGwK
	T5GaWhk32NcRYzgyw0jCpk9WaWb3WedvXUyxiKuuAG3jZ2cr6W1Wx/oIyZRMlWAF69dB/EiVPnl
	lqi+is01hhPM+DNkXf+rgu4K1dy1DlRybVr1ifTQZqPA==
X-Gm-Gg: ASbGncuZZUWjoLX0iRlyWq62pj3MyT+tVat8IMmHIRDNNiBzBbyZsJ41HyXzgeCXWj1
	SYNMXMzUv3P4Gjq6ytBPPq38E3ppPTwk1mM7ybbevvMBBljRI3rhljst+es0LyhSOf5Spc1+vHD
	Rjb9/ie1uqmYUfoUcovMEMLfTFuHnVcDs=
X-Received: by 2002:a05:690c:6e0a:b0:6fd:390d:5a9c with SMTP id 00721157ae682-6febf2e503fmr206389477b3.10.1741619386346;
        Mon, 10 Mar 2025 08:09:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGyLQAjNOgqE1CYoq+lDcfzuH82TmqwgUJ/ZPSGQZDq/un0ldV1vpoTs0OXrDkqGOvtjiIPSHuRkiZkjCi0Ow=
X-Received: by 2002:a05:690c:6e0a:b0:6fd:390d:5a9c with SMTP id
 00721157ae682-6febf2e503fmr206389217b3.10.1741619386078; Mon, 10 Mar 2025
 08:09:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com> <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
In-Reply-To: <4dd35799-f43b-461a-a3c4-5cec8ff22006@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Mon, 10 Mar 2025 15:09:35 +0000
X-Gm-Features: AQ5f1JrHl-iBjp-aSsBecnekUfUkFTA8cuGlQFmAxEcgOIfN2Q6gktWDdoib_wI
Message-ID: <CAJ0trDZRg=DPPDa0LMiFw0T9uT+B_53K4=aXc=njr=j_VYOarw@mail.gmail.com>
Subject: Re: Allowed characters in strings passed to/from device-mapper APIs
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Zack Weinberg <zack@owlfolio.org>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OCD5agdHgDwO_841avI4BR1I1j3er0josiM0IEkfldE_1741619387
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is the Rust library developed by the Stratis project, and I use
it in a couple of my projects (blk-archive and
thin-provisioning-tools).

https://github.com/stratis-storage/devicemapper-rs

- Joe

On Mon, Mar 10, 2025 at 2:43=E2=80=AFPM Zdenek Kabelac <zdenek.kabelac@gmai=
l.com> wrote:
>
> Dne 09. 03. 25 v 17:00 Zack Weinberg napsal(a):
> > I am developing a device-mapper client library in Rust.  The language i=
s
> > relevant here because Rust's standard library makes a strong distinctio=
n
> > between strings that are known to be encoded in UTF-8 and strings whose
> > encoding is not known (`str` vs `OsStr`), with the latter being awkward
> > to use compared to the former.
> >
> > The device-mapper ioctls use a lot of strings, and it's not clear
> > to me from either the documentation or the kernel's source code
> > what expectations the *kernel* has of the character encoding of these
> > strings.  I don't expect the kernel to care about UTF-8 versus
> > ISO-8859-n or whatever, but it is plausible to me that at least some
> > of the strings used in device-mapper ioctls can be expected always to
> > be ASCII, in which case I can safely use `str` for them on the library
> > side and it'll be more ergonomic for end users.
>
> Hi
>
> While you could surely interface kernel directly through ioctl(),
> you should probably base your tool around libdevmapper as this library
> is there to solve version differences or possible kernel or udev
> issue that pops up here and there -  if you will go your own path,
> you will need to reimplement these things within Rust - which
> might potentially be problematic - as we are solving i.e. udev trouble
> to be working only within our 'small world' across different version of k=
ernel
> and udev version installed on the system.
>
> >
> > There are, I think, four different kinds of strings used in device-
> > mapper ioctls: target names, device names and UUIDs, table parameters,
> > and target messages.  For each of these, I would like to ask:
>
> Device name and UUID are always plain 7bit ASCII.
> But there is a catch in udev process - as udev has even further limited c=
har
> subset usable for device names - libdevmapper uses name mangling for thos=
e.
>
> Again - you are free to reimplement your Rust version - but eventually th=
is
> may lead to a completely different set of udev rules needed for managemen=
t of
> Rust devices -  as libdevmapper is free to 'change' DM udev rules as long=
 as
> we are 'internally' consistent - as these rules are seen as 'internal'
> property for DM world.
>
> Regards
>
> Zdenek
>
>

