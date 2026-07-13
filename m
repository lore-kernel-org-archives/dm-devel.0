Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92433396EE
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783961421; cv=none; b=d9IwCRUhwGAyG/EWT9NNrjXV74mp6YzPFr7Hb8hTw4Iiq6BG8NzEXiLrshIgG8JL+WiJWAOgdWODH9o8ucpQBbidfna3ImMPi9lELtEWHRpC9icmw78EnV8iO6E2FaLqDjBcPIlE88uwm1vYBuGBOqFjeQGy5FaHHidrAdNSWkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783961421; c=relaxed/simple;
	bh=eX6VLYfgxhRr+s5jTumiuPcnhMPx2tMSLzSkjs0SDhI=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=rNsEezT9dr5WWBVGtXsGejNmlq8oO9Ft7k5Um30JqcYYvGQ/mGMCx9A1nSrocR4NMOhcxVM/NOQVngpXqbwKrUkjzbOkZ/kfmoxNZXKH1ptq7bjjHdNsBl1W7GsMkeXz2cphe8WjnQWtamKnQkBFVt4NjeK/xiRHYtDYN4xELPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PF2J95If; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PF2J95If"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-475881b9a4bso39094f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 09:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783961418; x=1784566218; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eX6VLYfgxhRr+s5jTumiuPcnhMPx2tMSLzSkjs0SDhI=;
        b=PF2J95If430MjnKvmGrHUeycrzA1KLE43mS2Tmw5LPf8cIreqifXmsj4diZv4u3aC+
         0P4bh0UZWSpskN5LgQIO2B1U3OEbPeUZxN9MZqFDkVeQZW9XFI+eO2vRy54Dpegwf2yY
         TP0EgCpl27eQisvmM1V3ppTxfEWVtuP6m4Y4ivpxI5mevGDQaEjf3VoeB3JKV56jpL9y
         Ha8E0dfSaGaFjlOoxvSarsUFwrF4z3R9s/VenXP2lDoo+TpLk7kjJqf3Qkk7MqyFHaIw
         L13upCWaizHX0m0B6CGF2FfV+JDw0JaiVLoRlouY8Si3FWWExs+Uy0Win8KvU/0AQf5E
         UcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783961418; x=1784566218;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eX6VLYfgxhRr+s5jTumiuPcnhMPx2tMSLzSkjs0SDhI=;
        b=BLeW7Qkj8/wWBlyjuUitZqCMaFbclmQTPgwylnhhCSVLZCUdbGcOum5Kk3qM/9Ek2s
         IunaCrFd2HXabn/HycAXU3PP4svAZ2QAyItR0rt8y66mHwWBSgQZ8UvgNYMpNSrszT1U
         459JonCJbrsViJTNTvuw7ruW8L+NHBmHt4nROatvzfVi4jXrQ5OE3leEsX2C+N9Jb5FH
         77PrFeIW93F7Op7cMCTZzeKnfCheIWItR2yYj25PlrBqU/AET6Ij0YUbAjWP8W5Fxk0Z
         EotLOwwP0JiitwXNQcO/WN/u0aXCIPlTk+AxT+ux4EZ5hY4i1nyfj3G6PSo5B/ZO6b/e
         l2yA==
X-Gm-Message-State: AOJu0Ywq1EyOpX4tNMxRvzekqHQMttJnQB+ylULt8iBzr/fSUDM3A6U+
	SA0avVBWDwottRCsrksJQv1A+K6zrJwPNeTZyG/0I6tcobUUk+jPKj4sm70oppSHw1rMvYSsEne
	MT6bZhWQ=
X-Gm-Gg: AfdE7cnDkHVBoDQ6ssh5PZRjWANcfMkGiLpm3oFeh9IEneUoLbOhtik+oSPwQV2reds
	xGvsDZi6Jv6jbLoD4zTZy4hTOyzB1TRWSZmwbfWqVwyZeYBoiBtPkEQaRLeBfUNNIrjmjDvd+iI
	4HUsvjGcgFVk8ZMpxj3GjgKm+jWpapKqrzWWOAKp54rfDs6fLqDHXXmV84Z1ZJkC/7VW12gLoZC
	O1kSKQz6WQj/JidDLhqAQvsSmYmsks3eHbN5Lmz0fQWbZtmPNfSBtqsWFBfRohTlGlzvPfG1oaN
	qp4cKHwCv3tP+NKg3+wqeKLiGvsv44KKH3ap4Efr7zk/bJzh05PLa2jwVV5XFsyLCncCsh5VaJS
	zbygEuskWczhYOQGO3Wew3JRoTly6bVwopxoY/Kirdav/qiUvOeWSOv2SZDfYODFBjMue+VvUSp
	TY9/BxOAPIcco3IbugjtOkIsrGvyAocBQwVS4Zn7IXA/65Jel+voNnKI9fc3xX0FIBv7lUk0XtJ
	HBYrbfxTbVMYUzpe/vO7QXtryHzQ/TcC9RAvokTkOIedA8vh6c=
X-Received: by 2002:a05:6000:1ac7:b0:470:2fb1:3db5 with SMTP id ffacd0b85a97d-47f2dd20824mr10514633f8f.30.1783961418139;
        Mon, 13 Jul 2026 09:50:18 -0700 (PDT)
Received: from ?IPv6:2003:de:3746:1100:f390:c52e:1c24:9082? (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c9cc3sm539263f8f.35.2026.07.13.09.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:50:17 -0700 (PDT)
Message-ID: <708ab008e4c320c5b9ce55fdec30053a6d1f0e85.camel@suse.com>
Subject: CALLl FOR TESTING: multipath-tools 0.15.0 with RDAC or Clariion
From: Martin Wilck <martin.wilck@suse.com>
To: device-mapper development <dm-devel@lists.linux.dev>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Mon, 13 Jul 2026 18:50:16 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Dear all,

multipath-tools 0.15.0 is about to be released soon.

This release contains a refactoring of the path checkers in multipathd.
All path checkers run asynchronously now, unless explicitly told not to
do so by setting the force_sync parameter in multipath.conf. Until
0.14.y, this was only the case for the "tur" and "directio" path
checkers.

This means that we have modified, among others, the "rdac" (for NetApp
E-Series and derivatives) and "emc_clariion" path checkers.
Unfortunately, this hardware is difficult to come by these days, and we
(the multipath-tools maintainers) don't have such hardware easily
accessible for testing.

It would be appreciated if community members who still have such
hardware could give multipath-tools 0.15.0 a quick test. It should be
sufficient to start multipathd with "verbosity 3" and verify that the
path checkers are correctly started and yield correct results. It would
be even better if path failure could be simulated, but that isn't
strictly necessary to verify the correctness of the 0.15.0 changes.

The code for multipath-tools 0.15.0 can be obtained from the current PR
on GitHub:

https://github.com/opensvc/multipath-tools/pull/146

Regards and thanks in advance,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
