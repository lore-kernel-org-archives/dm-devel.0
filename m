Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62E0126F08
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716556955; cv=none; b=XzBl3J3Tgp4pegvsOQCsCNqZ5XONgxzuj6QSWi9U+7sapcYj9CZxxjs1KXgjGeb1VQ5C2obBdz7PabPYkE7DtVoC599giH4K0wPWrbV9mIHyPiGAeAmDWbc+qAtQbh4byzQr+m52QXpk326p5tiht5GgE6OztBXQBEaLTeIQbeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716556955; c=relaxed/simple;
	bh=4TbyJt2HVLTMgTWkXjx9cwcgBvM7TtW2IYNWv81DpaU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nIO21jTP8bqHupoP1KuzzVR5zwlFsPof0jyRY9KCv9mCnDg9nq3+so0AOIs5yf1MB3mHFSSs0Ly/bqHUVqT+XOLgKOggy9Kv8vG7IbC1oHYTWRIgu7++oTQNyXemZwHxXZa++8jo/R8V+2QGHKEncZp7m+SK9GpUr9ptUqpGyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YPdu9+x4; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YPdu9+x4"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a5a2d0d8644so1151327866b.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 06:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1716556951; x=1717161751; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4TbyJt2HVLTMgTWkXjx9cwcgBvM7TtW2IYNWv81DpaU=;
        b=YPdu9+x4GTNO/VEcfn3ehkeL5LCIwXBXhQi9idJFVdwrHSLLWxxRUCmaWviE1gyIqO
         nlRyk+2JCD6dDYA84uMcrtGeqNqKfTlX+R1mbOOfSxI7n7VqC7L4Nx+fIBrHKxUPieUI
         bTC3nKh/E9hXLwd8uW6tkbZecxeJFrA52J4vdUZWsyr0KCl1RIz/39Iq7SsThApS5iOa
         4unERtMuXEovpBRIaDZD+y8rRunB42UxRLkwiyCczO2KpSlqEnlKymqn09TnGX60g8R7
         pHzcEGsQsZzvMYo2w/a+MEdO0k8TyEVWY7hhf9szMXyBfSZqn3bqtyH1PW267pcTJZ3E
         DUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716556951; x=1717161751;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4TbyJt2HVLTMgTWkXjx9cwcgBvM7TtW2IYNWv81DpaU=;
        b=I936fbFZrPqettS6LmyIjZGNguMI3O9ILz3tEzoUOg7EcXGryXFV8n6Bsvm6HhcAxw
         +oVJpetLgPkk08pnKJ9lVN8N2xWj54fEUlFxIS4+HHcibkbdDnn4WgZ5T2oz77LAcgj5
         85XIvsdra5ztXMXdkAboP7m59/BK8+C8QtW528U00Z/9LLf5OYV16vQ6lKqIW4AYPTBC
         luDB+viligT7bZrWrEdkNGvZ6FJKwE5/8zpvpYKIP3NhYGPkHHkjCKyv3G/rhR42zu+N
         4DRlC6LXLO55zwoQKI5h8DNHhOdxZWGZj3kSMhD4XPs9GuxlUwBRabJAGc1iQ7Gnpx1l
         QgYw==
X-Gm-Message-State: AOJu0YwkRRPcW8Rmn6AssYLKp5hTI09dX8mdzxfWwIHTTbYgkciOwRrr
	nxh5NKvLPL5mNnaZ0ZXRiI6gsLK0CQ9Fwzv2BG4KkqMQWhWGbKJ0d63cOb5wbiUAaTWRtC0sxUw
	t
X-Google-Smtp-Source: AGHT+IH+cd7uYyVnrMvnvu1LH8dPJqXX0UDGQ7AjynAphL7HW06H3zEmR2DwO75at1+uTFziYB/S4w==
X-Received: by 2002:a17:907:36ca:b0:a59:aa69:9791 with SMTP id a640c23a62f3a-a62642daa62mr205082866b.34.1716556951064;
        Fri, 24 May 2024 06:22:31 -0700 (PDT)
Received: from ?IPv6:2003:de:371a:a400:e6fd:936f:426b:4ff8? (p200300de371aa400e6fd936f426b4ff8.dip0.t-ipconnect.de. [2003:de:371a:a400:e6fd:936f:426b:4ff8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626c93a81dsm132116066b.87.2024.05.24.06.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 06:22:30 -0700 (PDT)
Message-ID: <40b3d21cb4fd39b02b66a709724d15507dc749b9.camel@suse.com>
Subject: Re: [PATCH 0/2] multipathd: accept more multipath device names
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 24 May 2024 15:22:29 +0200
In-Reply-To: <20240520233803.190793-1-bmarzins@redhat.com>
References: <20240520233803.190793-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-05-20 at 19:38 -0400, Benjamin Marzinski wrote:
> The multipathd commands with a $map argument will only accept
> dm-<number> and aliases for $map. Make them accept WWIDs as well.
> Also,
> change find_mp_by_str() to not skip devices with aliases of the form
> dm-<something_that_starts_with_a_number>, which are horrible names,
> but
> still valid.
>=20
> Benjamin Marzinski (2):
> =C2=A0 libmultipath: accept poorly chosen aliases in find_mp_by_str
> =C2=A0 libmultipath: accept wwids in find_mp_by_str
>=20
> =C2=A0libmultipath/structs.c | 11 +++++++----
> =C2=A01 file changed, 7 insertions(+), 4 deletions(-)
>=20

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>

