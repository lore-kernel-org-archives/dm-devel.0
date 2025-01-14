Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D2D213246
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736891106; cv=none; b=GdTzCY/vMTKGJfb5WNh5GdNbddZDG2wKEAQMvm0ZGTGxhDaWwoRir61gCeKyn4QLS9U9VZKZXYj1nXBQFS7gU6122FDITq50oPd4h6s9umslO3mfScgkA9pMPF/UHshFqkI5koSMeSJ3XvOhtexaSgElgJQaDpdZ5y5I+EKlJvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736891106; c=relaxed/simple;
	bh=zGXnw+i1i7TKU3wgniRuqaVSkfXsQxGAs0xvFF6Zyxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YO+oBOn3BIWTe+MtVLWTV3esiOoICzYbucavInQ9HEKrNsV3tpjfCcKFima6bpIgu0VWF7pgQ4n0RutpWhwyuWd+lRDK5qXsQ/toL0csanPeYz9sb6UbgMEvdZmPJ/a9QsU/oxu5KInhukNRdy4AeOacFHiC1CNMHq07sXdyHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nz5K1zFV; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nz5K1zFV"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385d7f19f20so3084272f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 13:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736891102; x=1737495902; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zGXnw+i1i7TKU3wgniRuqaVSkfXsQxGAs0xvFF6Zyxg=;
        b=Nz5K1zFVMTA+e1CQ71J0Zbikrsq2krRmlNlkTwZed11CH50B/sA3il2soeY+UpUltm
         am0vq8PqGAAKU/UzVICCTKwX6FZ1KYs2OnkLM/WcGrQeTaXpC+9KxWhhhmihwZNsd981
         J7OtEoHb9e2II54DWtBAy0f31mfgXG7GLGCVicivQid2yGjr3hOFXcBXhU/cK160IGsI
         PZdzYtWKocehQ1SXriSceQvUZfDRhlDDolJNJ0+aVUMB8004o+uDqHe0yBbOxBuo8adV
         M8d5hrz3M+x04K7XHZk/3YoDbchFUSXVZPS8U+qymcemAL7S9KY7PZoFFpCWKwCMGW6d
         vhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736891102; x=1737495902;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGXnw+i1i7TKU3wgniRuqaVSkfXsQxGAs0xvFF6Zyxg=;
        b=rivRgmHrQe1CTHIX6IQbJbbnBGHbTnxB+radieHm+FL2nETpMM5o8FWur0P+coDiN9
         1RjmE8wiie/bZydBjaSANlSUWIqAGrRsTUiCMFCRBZY8bGt5htkbV/WrCK/guSSUYnqU
         lJ4pA7QISyacgD59PGzaXThGv1UHuAb/js3rMaWd5MSW3jDSd6JoMMsfTDolOCJZN/w+
         xjOxKTq9rQJoalkWPG9TAEeFbdszfygDN0I9fz8zXcFhFdt6xdmtmvr9a38Nqhn64KCf
         50npBXWm6G65OBAcGeWumQ8sCV73jkZ3B+JzmPa/t1EfpS4PQGF2FpZblv/L1gZ2PZI+
         01zQ==
X-Gm-Message-State: AOJu0Yx5PrXKT2egd3jOEXzcgyWEMIdkBYr2XnIy4V1p1qAPSR74z1E0
	pBW7v2Ngv3YtaQM5rcYL/DIfYoVkC19YA6HMOh873HFM4dNTdZ2AWmeSK/UEayY=
X-Gm-Gg: ASbGncuUStlZ7LmR84V3UQ4fRktnlUsclPY9B+ozMjQ2CYpc2fqpdg33x4igMz5/NbF
	PEWZVXP5rN8pFJ9LPg+Fg/W/6nqK2I66WGlPmmJtDxmrJHhrn/6g6pgZ+FGycnVBmKZnFVY1Lf8
	IMY1pwW2n5EA7XTlh77PwXsDi0mmkIZGB8xt/f9ElHxG9BPnkXX5GZlP3NQvtJ7OttjX80JwQlE
	9l6VeynOAAnCw9RUjezAPZJwMwG1vLB7+2G50BURlOZQ8B8E96fRSZTNCdNcGdKg/EuyjGDtqVR
	FFzapkoRF/14hvct3NkwJNGr1vJFs2JmliiMp7uYRyeq4BU6N0FISCicqmOP7/1eyMybGQYI2ya
	FybcY15rY9C6V
X-Google-Smtp-Source: AGHT+IENJTPFrtUtd6VJdXkDkgrq22aps6TJzTD2cxIzyhjUNb9bqGYfAJF8QfDWlw0yczjQtprszg==
X-Received: by 2002:a05:6000:4020:b0:386:3213:5b9d with SMTP id ffacd0b85a97d-38a8733a1e3mr24689914f8f.41.1736891102495;
        Tue, 14 Jan 2025 13:45:02 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4b81d7sm15932501f8f.73.2025.01.14.13.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 13:45:01 -0800 (PST)
Message-ID: <dc1c3b7755ba4e438ff7ee580c91bc9b5890b6da.camel@suse.com>
Subject: Re: [PATCH] libmultipath/foreign: fix memory leak in nvme foreign
 handler
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 14 Jan 2025 22:45:01 +0100
In-Reply-To: <20250109000653.2469651-1-bmarzins@redhat.com>
References: <20250109000653.2469651-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-01-08 at 19:06 -0500, Benjamin Marzinski wrote:
> _find_controllers() needs to free the udev device if it doesn't get
> added to a path. Otherwise it can leak memory whenever
> check_foreign()
> is called, causing multipathd's memory usage to continually grow.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

