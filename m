Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B6142188A
	for <dm-devel@lists.linux.dev>; Thu,  5 Feb 2026 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308235; cv=none; b=HSbQGOLiwVPyQDCl16uzS5I5FGYQfcZstdUzT6kJwOxn8IvtGHeZ6vvVd8YeQFTW4DbqKiKixfsHRkrskNzdpUXi6ZCYEgGPFRLn/Gi9ndN/rt9cvvFaNvuQaS4K8+DgA2XjDNvpfSMZvWGkzTkmY0XsBMyjAhwjBsNguOWDsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308235; c=relaxed/simple;
	bh=NZXg15+ZBLJP+cl1Cn1xv3POXS9ES8G5CeKxGHvb2BY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IHfPoQ0hqjwTacpVNakwiq2xPGc2+c10AO4HxQxgb+yLl6m78ddo19/OGIry0iaFQ4hqPlQZq7bGCloomc6kbgi+YREedyYEd+gbbGB+HubQo6yYEJulEgyJuC/8nESAODT9fdlg6/YlTfAJ4CUp/d8+ePqdmC7rlBpXwUQ/j1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gbT2VG+D; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gbT2VG+D"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48068ed1eccso12021245e9.2
        for <dm-devel@lists.linux.dev>; Thu, 05 Feb 2026 08:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770308233; x=1770913033; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NZXg15+ZBLJP+cl1Cn1xv3POXS9ES8G5CeKxGHvb2BY=;
        b=gbT2VG+DntH/gNVWJVjjpjd1iLislpMKoxfyQuQBCtw4ojShEOpXtMa3S8rYqnY1LM
         ZEFCiDeDpD+V57REB3QIkhOZSeTHd2I69Dgyn186m4tfGh0kOhDMv7re0HXmhyk+YqAk
         hS+xSRgQx2tZgjSvmMfvemyeTraVdP0jlOrqYhPRkf3p3SFSABGlBnARjy2jRgdwZTFg
         pSVzaDuePgAFvtSUmfQsDHRp7GSmAqrndkq4rP66EooJyz5BV3l3rmLCyXVS6cQU4NDr
         DbJTNf9rkPRnCjkAB9y+IkQJ+guKOVTd0BH+79IQHa4KZiUzMplN/AUoY8Vmsa9MWmct
         zbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770308233; x=1770913033;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZXg15+ZBLJP+cl1Cn1xv3POXS9ES8G5CeKxGHvb2BY=;
        b=uujfa8IZtAYguF7xHq0QQKptMK4SmG8CoUAFz+dWs6VB8F+KeZrkFLa1KjE0tiLTx6
         JX4uxO0pkZWbLP9OCZTjS9VSwho7Tzn9n48Obb/7uqiKjUu3/ZzKWdv+Nn7VZK4wWTBW
         CERi3sV1PVlyeIdGTpBbuhF8CHu+xXeMYhu/9Im1t3OgzLG7ud4xPOHx+2PPNxe+cQXF
         sgCGm/w/ntrSo4Pr6wyDh7rUlj8CQPpmAEvXlMecKnYGca9gToJc+i7XozWoRwii7Yp/
         XxwW13kSi0EktdQkfu+J10GZ3jQ24fS4Rdxr7HfYkeScWVTJ2XXKUsbtPXmmG9ncUDkE
         MGtw==
X-Gm-Message-State: AOJu0YzEBwcpwpFQpqrLpXJloR92Bue2hztqqG4SrvQjErF1JKw+gdol
	RUt2doPSyrxgFQDrbgYC6Vfy9Wd6ttPk+UrvJVepbstFrAc8mdoljbB7bJYZOL+7HCCuoLHj9ft
	FD271
X-Gm-Gg: AZuq6aK1TvRWHULm8sajPqSfmy6wdrrOdutiIzw+dj+bG9KbIlYctlqxfLfaoQ3PV7V
	dsVmoWhwPKlTTwtLZmbUss2n6ao0DvgQnP/dlIGVu0qv7ROm7bkE0MwzKhMVMprqEfIPfmiWTpm
	XoH5Uo4mHQ3DiM/EAdp2pEJlkjhbMBI0U/ScRHIMpxcyr3cBN+fXvmE+Qy0btj7VdMCM7d1G1QZ
	8bI955pi6KRe9f+/Sq0M0y/tcx3kkBApTz7PL+TupUKnGAp8nJ6VWq59ITDEZDrjvUtMH4rakjO
	9Uxj4HNiD2csKP3B7qVWDxkqkd/USwP4++vStVy4Q8XjQbjKQS7FtB/29ka8spAj31beCzNfbJj
	1dufIlW5su69UAB+hU3VaFCsj+mdZcgTdSoe7M09h2uhpDNXCD5VwD+iy2jhgLAbNyPeD2cp1bv
	3GoQ5IOnhRDm0+AkoRZN0l8JzeZzxKaoYSMaYsNu/6ZjJLSZ1cK2tVqyNLyRzefgkUMvpvNKEMm
	aGDkHZXP0E0DFVFvw3bI+tm337oGXb7MrBZyqWCtBLf++k=
X-Received: by 2002:a05:600c:8712:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-4830e994beemr104564265e9.36.1770308232847;
        Thu, 05 Feb 2026 08:17:12 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43617e38e38sm15299988f8f.11.2026.02.05.08.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 08:17:12 -0800 (PST)
Message-ID: <6ebf6700eac86853950901e6bc376c691ac37358.camel@suse.com>
Subject: multipath-tools 0.14.3
From: Martin Wilck <martin.wilck@suse.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Date: Thu, 05 Feb 2026 17:17:11 +0100
In-Reply-To: <938bceda7592f9257ccee0533027ca6c2f861d31.camel@suse.com>
References: <938bceda7592f9257ccee0533027ca6c2f861d31.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hello all,

we've had bad luck with the multipath-tools 0.14.x submissions, as bugs
have crept in late.

If you are working with 0.14.x, please update to 0.14.3, which I've
released today.

Martin


On Mon, 2026-01-26 at 17:56 +0100, Martin Wilck wrote:
> Hello all,
>=20
> multipath-tools 0.14.1 has been released today after a nasty bug was
> reported for 0.14.0. *If you have installed 0.14.0, please update
> asap*.
>=20
> New stable releases 0.13.1, 0.12.2, 0.11.4, and 0.10.6 have also been
> created.
>=20
> Please see=C2=A0https://github.com/opensvc/multipath-tools/releases=C2=A0=
for
> details.
>=20
> Regards,
> Martin
