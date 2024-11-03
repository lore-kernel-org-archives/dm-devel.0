Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBA313CA81
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 20:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730666173; cv=none; b=D41H4362XL8Sdnt/ZD/dl0Spbdps86cLqcFL863WdiG9l1cJADVjKfRv7mqdCHtxXzj7Rw51DWy2Dmw93FYU2yFXsNj6VNzDwAhXDd/6HzZOgCRreUIRrrWvv8rBbjxd/GUleD9q9W3F2IGNo3PSbWNi8O46M3yULSUBBpSuaDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730666173; c=relaxed/simple;
	bh=Eb9EiVyGV57RKiChebKVS5y1dvgEERwvrfAolbenTRM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kdd7FvGHHQY5P78yKW6ec51hGMf4gf/aTeSfvrZNBhi4EIJvwfyQljrB4WnPrJweWLRnHXDfoQqurq+spP9e44+Kf2bVq561uselfrIfg+m9s9XpYGO6VXt4pR6MJWj6E2ZvKm8uuBJf3DAc9EdSju8yJMf/zMnV67qNlfPbxng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YageLDrl; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YageLDrl"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9e44654ae3so456714466b.1
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 12:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730666168; x=1731270968; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Eb9EiVyGV57RKiChebKVS5y1dvgEERwvrfAolbenTRM=;
        b=YageLDrlnklN7BFdNRGASVXzP5d/+gUCKsvwvB4111Yg6zbsTsddIRD2PZbDYAXN/v
         03s3aiP2Z56udkhX+mi+8K9+DO213HNbvwJ0ZHa0Ye7wcU0U8cGs1Bv8lYV3saKzSOVN
         nXi9uiNGmn1iRddOzdZHfPaEL5UZs8WZ4A4wnHCUcegv3r9boO1fPmCFLhobYgxkmIqQ
         wcSCh+Cfl5F5uuqwZ9dCbWrnKNVQoHbXyciasBowmlz+VPHXqntl95k43pHHvHLhjri+
         Tl8z0Y/HdPXCuBo8zo01kEJNIs+cH3xstASLLhar2VDs5316KzC9QiupRIl6kIkOmabc
         JnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730666168; x=1731270968;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eb9EiVyGV57RKiChebKVS5y1dvgEERwvrfAolbenTRM=;
        b=s7FWWfOpkb1h/+o8CnVIuE9N0sqc0i2oNgoOsdnvu6uzNr8gUxjn46E7XjWAKmwh0J
         ATIuZQA6YMxVS5gCOP0fx8nyhwkDACUZjPPt6Z36G//EtKWModYk4w1RjOwvvdnA6Ln7
         urfa6oheJPpHpsPr2kyxJsF3JK/whJOPrHg6HEDbpWzpUIv3hYwfXfhj/wova/i6wGqS
         q26UHWKr6CD/uvLQpyi5pHxm0NOa9+I5nz7o81k3CXfDQh75GGDdE8x3ScEOFDTMfkx0
         +3Cu/6gmziVzZcEYWGLTgs6rhB8q+hn4srjv7vvOlLsDq4YmIyft4dBHK2hzWEmTc5Be
         /v8g==
X-Gm-Message-State: AOJu0YxYtbl470zlt29z8Q1XD6lEn+jNyID46MFfuhtFF+Ljx4y9hdKj
	deT1zV7JygL4KG7ptIPGaYDaSIVXhdoylQJkdjIHoEg4Vy4YrxfUQt1X1hlPBC4=
X-Google-Smtp-Source: AGHT+IEsjB+YTLjGpIdqRml0IrEXXAMAvh5FBnL2XnHd6n3rOmxZTAVo+moKhateaKBoPQQ6El/44A==
X-Received: by 2002:a17:907:7286:b0:a9a:3cf:cdb8 with SMTP id a640c23a62f3a-a9e50954d12mr1375101266b.36.1730666168044;
        Sun, 03 Nov 2024 12:36:08 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e5664350esm462231866b.159.2024.11.03.12.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 12:36:07 -0800 (PST)
Message-ID: <cdbb02535b5cde488cd13fbef0776094436a8d98.camel@suse.com>
Subject: Re: [PATCH v5 14/23] multipathd: update priority once after
 updating all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Sun, 03 Nov 2024 21:36:06 +0100
In-Reply-To: <20241015032835.2693247-15-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
	 <20241015032835.2693247-15-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-10-14 at 23:28 -0400, Benjamin Marzinski wrote:
> Instead of updating the path priorities and possibly reloading the
> multipath device when each path is updated, wait till all paths
> have been updated, and then go through the multipath devices updating
> the priorities once, reloading if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

