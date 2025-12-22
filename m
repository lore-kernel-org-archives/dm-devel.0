Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF7E283FCF
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766404672; cv=none; b=gdvMUcB258eR7m2dScF+2mtfhcFgiOiKdEWk1PqhtcOfZR36/mCeWm+/q2IYRoQ1lxbX5sU0kvtpDWmtAOIyhaBuDDKdINPNDguJtqIR0uOhGYRfyDMo7JanZuNOpFikmXDxiBJ6NH9aCmO6NgqtDxdDY8J0RAQMS5EagiHy11s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766404672; c=relaxed/simple;
	bh=Y52y9WLSOOAVNhlS/J3Caa+6kRYTXCCa1VUj1+H2Ci4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aXO5hSMjbVYcvHWRWf9FCYRfPPT0aouahTaxGIHR3Vb5wLVafS772dcC/55e6ZkupeoTPvfKnVPKWdPgvwp3KXzu/6vJSkYpSHX5fZ8F/rChve2M0c8Im9t1NwbhsZke4hNuA4KGS8XJZBOjZJLrsjklorfwp5GLNj1FWpZ0g6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fr24.com; spf=pass smtp.mailfrom=fr24.com; dkim=pass (2048-bit key) header.d=fr24.com header.i=@fr24.com header.b=XHgV/m3O; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fr24.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fr24.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fr24.com header.i=@fr24.com header.b="XHgV/m3O"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso3446945a12.0
        for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 03:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fr24.com; s=google; t=1766404669; x=1767009469; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y52y9WLSOOAVNhlS/J3Caa+6kRYTXCCa1VUj1+H2Ci4=;
        b=XHgV/m3OIlfNgKseMtMpfZIQ9a5LV8cw+1HUh1Jd1DPz5myHb49lkzIo7j7utzp1Dz
         OCtHZhCXr1EHlUEGLrl7OsarcnpyB+iNSFPKjNpT13G0EDRYDLPlxwEXguwiUE95VEsq
         mcpYK3htMaV1TsiW+W6JGoL3oh36/QcuX2gFLz1ScBh48onD5NXavS39DWRaTgKhWMzM
         EkdPIBqsYMEEIMhki88/N6cNHwzFzEBvrw1MzrSvD8sfeBuch8WEEWN5u78CqWUgtr0P
         hGgkL5Y8qUKYzLXULe7U05cM/jkHBua126cL8MDclPnLG3LX0fSkbGh0GfMyZPnVc/cT
         wNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766404669; x=1767009469;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y52y9WLSOOAVNhlS/J3Caa+6kRYTXCCa1VUj1+H2Ci4=;
        b=McMiCGJUuFlEgtGh9p5Q3A/BsyO+fAG7eFewBtajHC30vIz0UNUpeiFF3+CWq3JOsK
         iDnh+oI7UkusJ0mDRUb8qsnpOz6LfmqsYmCC3S3XjOWTcNr+w9oxH20IPgl/rRSB1f/w
         UhwttORAVyBUncM7e768x0ysdtunu8cDDPgcSW7qDFHw59spM9UfFPn+mllGpaDZjw5Z
         APgldne+QeKSp3NZgdUemIKFzbFdVKCSnH1XK7HdFcgnLpgYVKGxGaglAzsSSQA+6/NX
         rcA+1V2EseGjJX5UESHUJc5rrGCojD10q0lvzHRstNCUi9x9YuVmRIQ64mntCLuZRQNa
         GVQQ==
X-Gm-Message-State: AOJu0YxmLVYSF5H9//8PykddIP/SEbv8mHvGP7oCFBLXPD0wKvbrUurU
	Bl/u0AdXYsO6OGrHXdJVJgQdIQUr15uJ+i48yHQvWfp5nJnaXq/R+mw18ZVn7q61hcJNQ9+BPf/
	RLTRW+Aut+LXBLtuft1by9jPuUGAH22/ul5QuJvhmhqklh25VJdw++hE=
X-Gm-Gg: AY/fxX7SqUb26kWqxhfi+WvkMdD+2e9Kxl8HJdEeejKuFJ7QPgkvOYCWu4DO5ElNWBQ
	KgDby+4M0QXFluqn5nNkfjnMn/dCdcs1hCV3vNEfqNczvR7N0D5YW3wEMsKGfgxPZwr03b6Xx+X
	bWrx7tT7w6xG2dKaJjFptWPEP8XtQ+2/2dmNjiB7bGJQpZHu92vRAgacyN/0P2gmaGusHmTbl5b
	lD8Tyy9TZbxZ3NKApsGg1oaDwD7fihOguH4K492XPMhKnJgJe2hzw2mSRbhYCPTyAPTzsgZdGuh
	KPezLQnL1mg4epglvsb9juP08Uf26CXlCDEnCxk=
X-Google-Smtp-Source: AGHT+IHdcTF2bmwHICWtsRQhspGcxKk35pcvxZujl7si5XyshuZqNPeq961+2cFaRSrT+BG+bL1clx6OqV6Glo1ywSk=
X-Received: by 2002:a05:6402:2889:b0:649:19bf:bba1 with SMTP id
 4fb4d7f45d1cf-64b584fd82amr10023924a12.17.1766404668679; Mon, 22 Dec 2025
 03:57:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: =?UTF-8?Q?Nuno_Gon=C3=A7alves?= <nunog@fr24.com>
Date: Mon, 22 Dec 2025 11:57:37 +0000
X-Gm-Features: AQt7F2o_RXmJjiS8LvL0sFaDUl5c0tMiTE8vNqMH7p7AiiN852cshE_--5dE0BU
Message-ID: <CA+mKM5kAB0_CWDU41v8=8mLp3cd6qwhuSFenjw-17wcjvshHbQ@mail.gmail.com>
Subject: dm-verity issue on 6.19
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

Since 6.19-rc1 I can't use RAUC.

I know nothing about DM, but the issue happens when doing a ioctl
DM_TABLE_STATUS with params:

1 /dev/loop0 /dev/loop0 4096 4096 9 9 sha256
48048ef2c63d1c69a817508db0d3ff387ce33b10ec8fd0972bd29268836014a0
46c92f189b2036f93ec5805fb956adc134f8c17513bb51502f5cf92cf64fefe7

And after calling it params was expected to be empty (\0), and now it is "V -".

Thanks,
Nuno
