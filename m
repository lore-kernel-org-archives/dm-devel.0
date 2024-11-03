Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE9515C14B
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730668019; cv=none; b=piQ8Jum8jvVqk7KXSeZJouJbsdPnPliFIKnPvhS+ztb8wLph1hNURwcO+cjXklkFoC5AFjCFLRRORmZTLs+Fi1GnujzENtSel4gbSarSorthwgHwwaHrR4G39Aji4/6udUk0CB5/fNJcgEPtpuIKDK4G/hFTmKGpXTg0069x6FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730668019; c=relaxed/simple;
	bh=hKeRFHclD40SH5eiNzb4uC5N1WQ+mzCAd53DX8bYSpo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mWbCC9pRZC89jqPIgKI8//Oc1Py7SsNoJ44Hx4XNPHP0O1JFRIh/b6mDE5YWokv+qczba2zfr9rdizHROx6y7eNKfDwHKAzfV7wiZyzWzKlX1uJmwxVTeLUM3mXgOxe6AEhji9rC5kc56YIDl4gbObzb1cU9d7J1+YovSkmxIKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I+WAUyM4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I+WAUyM4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9e8522c10bso191971966b.1
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 13:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730668016; x=1731272816; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hKeRFHclD40SH5eiNzb4uC5N1WQ+mzCAd53DX8bYSpo=;
        b=I+WAUyM4SG70aD3sFNQ4njM5EKAl3EyZU+5Cf3CiMu8CH6Hcv2wsCHiFifW4ZPeNos
         Fm/wafxuuwSnPDQLrUuci5/Mtq06MfufpUitUPdENCpjcHmbPrY7G9JXzb4Bd+Zx8uMl
         20WRsafuzly2C+qCQa0t5zRJtruteTaIxj3LUmZ4r6+4yWL1ZSm/qYCh0bbma7n2qNC/
         ZbmzGlQXwV+YikRvjgQYBvAFYZ+bLXsRzPdA/3wTY3vC0T3L+rAk8cx3dm8QxrrGMAMk
         RATI7gmnVEYSnDKr81ub/T5Qz0rXgkqgYizuUWv1ULiykfm1QSP3WVaxiGPpmPy8wQ71
         hmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730668016; x=1731272816;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hKeRFHclD40SH5eiNzb4uC5N1WQ+mzCAd53DX8bYSpo=;
        b=op3dW6uJUTTvW+FqMvALLYxhp3Zo+Sqt5nzRo6ga9NDcnJBWRdQ5hg7s/pMx7gsUSq
         j/NleIwo9MUXi6ojLX/ZW9HUMakfKkFWX3sl2VJhDFKDFpfkJ1Svg7WlnKgvMFPHIVXp
         UKHTCpgL4LwGbI3tojbwhKJGWS4UVMgECTRjrbW4omc4qgep6jv/Oz5CYj/gWRyilXaE
         1I+vUncppzHxAtU9X+aKIZWA1MFlKnFANptZBciuUB1GSGI6hPZtCAnjwRA5HlXAq74I
         3nchLKTlt44ffA/9RAVlYwM9xBtEstslP2CczrctvW2ojHyc+J7+fTzEnmG7l2AASE2p
         61Vg==
X-Gm-Message-State: AOJu0YygYXChQuX/bHm++NtTmtDTfUOttM/OPYqISrtpXaLv3VWrQsWY
	Fgls1ABwXpGgEc0xLr/oT1+HVuqKQimw+sqZtVelI2r6PKLafD9cGHppGRcQgfs=
X-Google-Smtp-Source: AGHT+IFb5fRlOmKwl3O9durvQJWLT/nFNx2Z9PRvjwTNohbX+8MVM8Wcrq65TrNd/plP8iCBo+2MtQ==
X-Received: by 2002:a17:907:9444:b0:a99:f722:2dde with SMTP id a640c23a62f3a-a9e652a3f1amr988021566b.1.1730668015456;
        Sun, 03 Nov 2024 13:06:55 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564c5327sm461330966b.56.2024.11.03.13.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 13:06:54 -0800 (PST)
Message-ID: <e863edf6a08f52ea1a032d2fbdd72997f4f69410.camel@suse.com>
Subject: Re: [PATCH v5 14/23] multipathd: update priority once after
 updating all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 22:06:54 +0100
In-Reply-To: <cdbb02535b5cde488cd13fbef0776094436a8d98.camel@suse.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
		 <20241015032835.2693247-15-bmarzins@redhat.com>
	 <cdbb02535b5cde488cd13fbef0776094436a8d98.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sun, 2024-11-03 at 21:36 +0100, Martin Wilck wrote:
> On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> > Instead of updating the path priorities and possibly reloading the
> > multipath device when each path is updated, wait till all paths
> > have been updated, and then go through the multipath devices
> > updating
> > the priorities once, reloading if necessary.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20

The patch contained one whitespace mistake (indentation with spaces)
which I corrected.

Martin

