Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81BB1E1DFC
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513326; cv=none; b=LBMIQPp3cFGMSfjZQGDXPkfHtqfkc8qJiIdfAwILpdwF3nwkY9mznaN4rJBCm4X4L0Gqiv7R7wDFSmsCYMMtPQdK7bTB54A1dvcjrj3iJ8s65+OHP9PsI9HXakzYSXn25Tvq5ElYAWbVpLsTvDcDkRWMD7afn2/Hx0P5+r6hT0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513326; c=relaxed/simple;
	bh=b36lrC7NkufcyBj5zTm4SeZbQfQpNt3WiBPQWw2IUyQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YBS/HnHGIeUXX+bwMRsIE30RAMv052f2CyJ2abONb/f1hY/nRBmFVpqzh2gDSTrEn2jhLQ4upV/YCmfYQtMV74q9pTpbxkQnP0rHj33Hd13pYaeDjkRPDj2Yze7QlLtLUpwsho8sHmfV9KJ2YMoNVJ9pugwdpBcpZXEH1CvtRdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hEqmnlOH; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hEqmnlOH"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae361e8ec32so861793366b.3
        for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 10:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1752513322; x=1753118122; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b36lrC7NkufcyBj5zTm4SeZbQfQpNt3WiBPQWw2IUyQ=;
        b=hEqmnlOHj4vHpPVpy9amc4Rr4wNoyixsmIMSZ6sOdLGE+vDPc+jnx3l+V6zjdGonvd
         hsL2VGyVSFFQzV1GfUM/p3HaufZate++2cREwY9CzRdoR9CbyH+KPE90kV75iCbrbk0n
         I8BN6F1iolwOcLfL77SAavRQ4uCB7YRbVfU+JXlXEXTW/SKrjV0SBSqvG7cW9yjAxpf6
         XQgp5VRJdMcrviUdks7cxmWk/TkukKCfJd9OfGu+tI8CQM/Yi4arCBHgnzUsUuo0mWIw
         IT/u9g0ZTiYHCzPnUGbQEVQgC88wTFGD8mQmx0aB40bCLsOddCk2jA7vpRgkV1G1FR9A
         l7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752513322; x=1753118122;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b36lrC7NkufcyBj5zTm4SeZbQfQpNt3WiBPQWw2IUyQ=;
        b=OcnfZNQG0Bqh3HReAPvchNITMDvoEVdU9+iFtOON2DnT0I+5QyF+NP1KoNXd+fx538
         Y2yfTuUXMKtgc2LTw4rEvCz+a6ZLbu03IIggylWacIO0xPF4xc8WCfiPtww3gvwZ9hcB
         1Rz2v8utmnTpfxcCS5rXYy5Ww0U7/HFIzoN883VonLSe3gmMek9CUg9A7dUEAvrMKwUL
         nbHTL8GfwApYrsfH+KC7q7TY+t4V3N7Cb33PcoCFaMX3zafdcm6ntIoMymbUo8qWMBpg
         v44EcIq4JjGwcEXieM+6iKSTLBW313jYa0MEDvAO6PJi/xoLYBuQBbi3Q0WcUBrAEojT
         mdZw==
X-Forwarded-Encrypted: i=1; AJvYcCXk0VftppgJoPxV5WEZuCH6AOHH/WG7U3tehe/m2dwtDK55t/Tn2Cc1Yim1EqfZRDdJR6m5zXKpPw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzmVIKb80OscGMC5lWHyb1OvXkQzsLmwpgHoqWAw4GzTOYMosTC
	fVdNBVWkcE12634MBza+fAURGjQ3K1AYqOAF3tPBD9hlAkaSIrcEpzRUvH5AmXUivQ8XMBxr+Bu
	15HUQD1A=
X-Gm-Gg: ASbGncv10fEBTIqjpeMiAE4W6QtAtkAsax6cW5iblxZoMR1IQyHyZQjeoMS7C71famY
	qnA+0QGQ5Wk4rxB/6j8iyEZ9aGl/uN/1bXtfm8YZYEaymc86K6xu0jxR0d+G0Ht/nWr1oUoh5gL
	sP9Oz57L4/ksB78j5dZX8AsWd5yaEhpvFM/gudsXzccyYpnPSPuCwUpppQ7GIT53n5k+E9eXiqG
	Hb/BA/TqwmdapYU7J7AbZna9Xn+vWEZ8QxmYOkUMCAy0LEXx/uTViprSnt3bYv0AzE3YoiNBPIu
	tagMJCD3i+ykS5dl4LfUxvTu6QxZog2b2byiaO46XoCKgZUVnmObriLOayKz4Mi2+zkLTbjnX1p
	I2MnJhSnP8hGe8CNQ4mKv4pqp8wX6VNOeKaz3eYOolHsrpjy2qnNLfxqNufabXF79YeNhERss7X
	ycfEIJH5/mFGj54SKGGSMPUXjUmFlZgoXATIcR652BHxrC5cM3QMKlC94j
X-Google-Smtp-Source: AGHT+IEs+0P3tjjTKlaKjJieHvDieUd6SxiHuW8CKChfOMhFJ6NgnylTGLa5NhCRV8+DLGlfO6NDTQ==
X-Received: by 2002:a17:907:7ba7:b0:ae0:b7c8:d735 with SMTP id a640c23a62f3a-ae7012967b8mr1091353866b.42.1752513321957;
        Mon, 14 Jul 2025 10:15:21 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f07:4200:3210:2a7d:8c76:e57d? (p200300f97f07420032102a7d8c76e57d.dip0.t-ipconnect.de. [2003:f9:7f07:4200:3210:2a7d:8c76:e57d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e826697csm852620066b.103.2025.07.14.10.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 10:15:21 -0700 (PDT)
Message-ID: <a1ab0957b3ad44ef405468771bdf3134d2f73938.camel@suse.com>
Subject: Re: [PATCH 11/15] limpathpersist: Handle changing key corner case
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Mon, 14 Jul 2025 19:15:21 +0200
In-Reply-To: <aHU3h8I28IV4V-MY@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
	 <20250710181100.3997759-12-bmarzins@redhat.com>
	 <cd323846226f9a1dd053d77e9e8bbe35faee8af4.camel@suse.com>
	 <09e59080ff857ab63d46355e47528ea32253fdf1.camel@suse.com>
	 <aHU3h8I28IV4V-MY@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-07-14 at 12:59 -0400, Benjamin Marzinski wrote:
> On Fri, Jul 11, 2025 at 04:11:46PM +0200, Martin Wilck wrote:
> > On Fri, 2025-07-11 at 14:15 +0200, Martin Wilck wrote:
> >=20
> >=20
> > It's getting so awkward that we might as well just use memset.
>=20
> Yeah. picking a member from one of union types to set to 0 is pretty
> awkward. I can repost the patches with memsets.

Let me finish the review first. I'm working on it.

Martin
