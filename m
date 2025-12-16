Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D80E3314AE
	for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765927749; cv=none; b=sEz485H7if26DB/FuVza3VBktfJ6DfRvq76MC/r2BGVVtkxaZ+mayvdaXX+NZkQY5XUBs9nh1ZycJI2zNsYYeJukE2wtHXya1cC7o9QWy7Smf9us6EUzm/XIgOJyvynYpuDS8FR4BQUnoxdQjEUc3r25PqDZFocDcdwTqDCtPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765927749; c=relaxed/simple;
	bh=MNqx/is4AzUDjVk7L2SJgdiKvF3YRpFxAxooqW8iQII=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ju/3nhW5Ji5f2X6zYsq8hRG20STzj7LxYIpPKF0BM5gAONfCM/8pjIWAQGB5tbvH9/8OFOcYuScNdASdNWUY+6OcRCgfIegHQANnurK359PHnXgLHfBBfBAMiRZcSIXsg1Wf6LNUoxb4Gp6aAaRBcE06JQc04cV2XzYC10FGA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LALMBc75; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LALMBc75"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47774d3536dso269725e9.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Dec 2025 15:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765927744; x=1766532544; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MNqx/is4AzUDjVk7L2SJgdiKvF3YRpFxAxooqW8iQII=;
        b=LALMBc75FEHflQ2ghL2qV3pinNpH2feVj1B3ReZT51/qNo7bL8ooi8mB7ZRYq4dszL
         7cV1FEvk7VYUYdREN/jzXdvBkkeQlMCREU01CqnEUZrtj4ebs1mte+wfJBa7q3IOuwdU
         YKctJuGgGg8ms0KwPaRoVK/+lot9xteR2Yxh7b5MgtLhZ7cS5rlarOqSxprJn9cg2hp5
         EaY/Z+2Cia4hSOIIAD4mpi2SIP3chZWOPrh23y2u6qeBA2MnBkusph4Ged+M803D0tZd
         IWBfeNHbG8pAJXr03goKpQ/QVwnaQB6+JctOKDHBl1pvQRtH7aLg5DVk4utl8/gkbWiB
         NfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765927744; x=1766532544;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNqx/is4AzUDjVk7L2SJgdiKvF3YRpFxAxooqW8iQII=;
        b=xCWBNCP6LM2ww3a4IwKpTadbYjWqAy63lPwXZ0PVuKveUaMxMiqGUb1Jk0ZkMM+ttJ
         7EQpt099WLT2S0O4dQCRoTG//hRZ5YGCQSkhYMKo4/a8CKMXj08YQLEv9IrsE2ffpSN8
         jwkPXyujiFyTCtB3QePDkitWDqYrxT5nQ2zMoutu+0+N7aeqJ+59U8QYHzTIqSSB6q1U
         8P5vlkmtadEf+fDUn2ssOG62tDmZssLSAMPgcbXAV37ddLPzDYdN5QCCqhC80jA4za2p
         EZOr8MvEtU52Um51njpZ5ULdAFAjx2WGkjRiIu4g4htxQZdHE13JliQLc3Aidyr/rwKh
         Bdog==
X-Gm-Message-State: AOJu0YzBf4RudCuDA+/sGQPJYdPdqLPq5lcLUBJPyxHee1+wWq/GOt8B
	I09SILVhSimXJ9iUBh8yKe2MOM8S494TbKzzGstOpm6fxuWws0uBHGt+ayu1hg83mNvojLrosep
	AoYcb
X-Gm-Gg: AY/fxX6lekO5r0SHUVLNPfxKnuDCwxBANWuGO/29YJ8l47sBdJsYESa+Ugh+Jo+NdMV
	7mKkFpseAloKe2TK0FK8VCuVrc7K1CZ+jlvnqNxP219/+Dm3KNKgORlXdTS/UIC0XgFB5g2RZ/2
	XmBMh9KmPhqoSLzShoesN/q++7AMckzve10gyAdON4p062NR1xkOPNoZ5c1Qjvei30qRcWkFtIu
	8CEvI0cpZsE5vKsoBpej7HiBWSI4mPzOiUyXq/y+yLVZtzgVUQ5i4PhTnQ2ZGPO08iMu1roZlYL
	tCq2mRyIJ0tMhokImO80Uv7S6ufnEeWeu9a6jn4luqqruwez4qobiGaDYPHOT/nx2sP7mSipIIm
	GLbG2Ro7+rGWbLW9qWHrmLrYlPnOOuHV/8LRqpmvONAGbZLGTh/O4t+fICBRPiyP9Dw9wg8QJY+
	JFD+MRgpkDZgKdVW8qcfgt1CN3IDse+OIw20bkabv8XefGVMixCh+bdROKoMIIhDmR/nTIBv0Ti
	NOiKis724NRUy7RjYYBWL91ks15yJt7HHMiWaoSNvWIPlF6nMLjF6VySg==
X-Google-Smtp-Source: AGHT+IGETgZKXztkUhsbbNcHCv7TFxgV0dgD1foI7Um/QuINOkqTCGVAnyfkeg74e9/a3MRhu69c5Q==
X-Received: by 2002:a05:600c:6208:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-47a8f2c9fa3mr177448615e9.16.1765927743668;
        Tue, 16 Dec 2025 15:29:03 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bd9154168sm18568805e9.7.2025.12.16.15.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 15:29:03 -0800 (PST)
Message-ID: <1664f321b49bd159c6c45f457fe436b65d4e38aa.camel@suse.com>
Subject: Re: [PATCH v3] libmpathpersist: fix code for skipping multipathd
 path registration
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 17 Dec 2025 00:29:02 +0100
In-Reply-To: <20251215202958.1995896-1-bmarzins@redhat.com>
References: <20251215202958.1995896-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-12-15 at 15:29 -0500, Benjamin Marzinski wrote:
> When libmpathpersist notifies multipathd that a key has been
> registered,
> cli_setprstatus() calls pr_register_active_paths() with a flag to let
> it
> know that the paths are likely already registered, and it can skip
> re-registering them, as long as the number of active paths matches
> the
> number of registered keys. This shortcut can fail, causing multipathd
> to
> not register needed paths, if either a path becomes usable and
> another
> becomes unusable while libmpathpersist is running or if there already
> were registered keys for I_T Nexus's that don't correspond to path
> devices.
>=20
> To make this shortcut work in cases like that, this commit adds a new
> multipathd command "setprstatus map <map> pathlist <pathlist>", where
> <pathlist> is a quoted, whitespace separated list of scsi path
> devices.
> libmpathpersist will send out the list of paths it registered the key
> on. pr_register_active_paths() will skip calling
> mpath_pr_event_handle()
> for paths on that list.
>=20
> In order to deal with the possiblity of a preempt occuring while
> libmpathpersist was running, the code still needs to check that it
> has
> the expected number of keys.
>=20
> Fixes: f7d6cd17 ("multipathd: Fix race while registering PR key")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Git clang-format applied a few minor changes, and I needed to add
a spelling exception. I'll apply to my queue branch with these changes.
