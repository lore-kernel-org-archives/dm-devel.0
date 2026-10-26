Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006771;
	b=r60qYJdfik/ueU/uGx/tAtx10QmKsz3/tVTKmXkgq5VktG6lmq60HQAIN97/6yvN1MsP
	 1wEK6FT06EPBqdGJxo5LcNrE3Oe44tMKPb3M+YNmm9NlXNLKw+tgJ6Ng94bnQAtYtrxP/
	 kISG1lSPzp+v/FqDRlpNpjFxWIEYj1T6aZmItosTkvFr4RZmDlawLc9lF/7mK5bIXsYYt
	 eygObvOD3oEBTH5EaOSRKxiEP4o2PWv8eCWZt9v24/MxGvtVdElIg90Bfmx1KFjPV0G7F
	 RD53HVgVf//Z+wkT1qLEK70+QFdIKNWM7QfAf80ZT1gjqncw3ONT/qLTyt73OghkHOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=mZnSBuWBaj9PwFWXvkEfOfP0P7NKmqZXRs1w6NnH/EQ=;
	b=T+qpDoBD+kO5lNREQoz+wiJlj8pz5MySqTwmh2iVnwnqbyitPxok5OE1dqRY0epUl01s
	 GhMgEROv8aIrK3srpXIkVKcZc57ax8lJSY2FAhTlnp5k/oDEDLCkxHimgxXkZYi3UeMkx
	 rDSp1eithZ5k3l6ce4vVd3EjEGXhZDwRKrUzZOLliEYAN8kudCNAorY3qjz/cdu+Hi2Q7
	 vE3z5e0p1ifjYueTT61eKRLcdGADMexoFLZ07GQxF02dwUAeCnJzT7mI3gW1fGgo+PhU3
	 X1OaGiNc+ziRUlOrM83Get95V15Dhv2/GDqvrvTyXbUlx8KnrO/5pYNdDGDwi3gJahg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=eTGWIwgU;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4759606A31A
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 09:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4759606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=eTGWIwgU
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so7636005e9.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 02:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793006769; x=1793611569; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=mZnSBuWBaj9PwFWXvkEfOfP0P7NKmqZXRs1w6NnH/EQ=;
        b=eTGWIwgU0OPHAkHSzx//C22imjUkNjOuFBCMslknvnEhpfJprBG565FJjvplA8nmbi
         r4JiMEdOvjtt+NPIsUgshljEXwxqQ5cHkufF3Jp6U1vA0jRLASb6nsRlKPVHYvxloOdF
         KmtnmQTIg9ZPZIaL78G1aeYcL0Wlzhf6ElaTBdK1dGcNK4FJN7FqSkYpSxwnhePX8j7q
         zgb+yOIBwT3k9uR9unqs+HnlcEX9m3+Lw1Uc4u0x7ODQWceL/05CB5sAGpcXUMz7ECIs
         Ngt1/SoUeOfLfmp2i80kmBOF6XJ3WqZyS4bfJGZ8pfAiHWsUOwomXYM02a5PcnzAUULU
         eFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793006769; x=1793611569;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mZnSBuWBaj9PwFWXvkEfOfP0P7NKmqZXRs1w6NnH/EQ=;
        b=D8BrqWlecRp2wfrERGRvPCUMkU8la4j7B/n1CI5XA4CFA3tPE1KCrJbwpIM1P7+koG
         LwM0/ZxQHaaLK8WSMfdf49MDrc4zPPmfTozJmiHsuLSl65EwFf4E/DvetGLAaciby2LZ
         pe4FhIyoKNYqspH4UJ+6QAPX3DYtT/Ksu1z922Dp0DjOBi5cBMj4vrlkTMxXFCx6cIrQ
         kySCLfUnoddIplMnSEfToUuF8pwmZa43lf6r894L/pLxziKPBjq1n7whDy06rq5QkK/1
         Tn6TlFu5LTJeYKyHS9nMhbs2FyLhIg3xoAa501Jq+CJVQuAO312BqPxbjdkxuE7Gk+vq
         gKdA==
X-Gm-Message-State: AFq9FYIso8EZgrvWsRIY6TIbhez6qm0AZnDJqpJXDWsyxxgKqy4gZbdy
	L9FMWZ/Efs+GPjV8URF7745ohiGAOT4Ck72HiP50yk2ohX+Uu/r5JlR3CU/q8nYZu6s=
X-Gm-Gg: AYBFou1o7hoZ7SyDaXtK+kAcbSguq1aURtFCwZR87Oh1OXxXmaYXid7tN5s90IPlRxJ
	LBlCK1uA1i4efWCMnfzVvxO5wPYLx17aIQJZxcPYoR/ppqHP1pMgetLeKXnXvVP3/2XCjTo1mac
	CLiLqLzTz/tq4sRiMcqFM2k9CCAQ3bmZb4BNjG+bkYwH/QTyLFFlsxZaqSIcMnrld9o/id/CEQv
	aFbn0mav+Fefz7tQj8xoONg0F8E2QsUgS2VAx9COOHN0IUS6X8axM8V2FKlUA0svCP+YlejiZyv
	VrcVcP3k8ZEQHMs8EmjG8wHTwChEvEJmiSoId/77uL36cl87v+Tshj6QsKUC6U/gCgmSyecx6wZ
	LH46YwOWZ6LzEr2GAcsk1+tI1L/hEvDbKX1+0/1cjTAtG3ke+Xt9Qykp32hEsoQ7AS19Zm104xv
	lTuHNqABEZT7EBDKy8gxwAhB39FT+Lz8ebbSs4quvD1DuhT/QBM3TB1A1tHulkyOduVjCWMEs4q
	24GoKtbQHK7AhpLs+uPPTvx9OSd24Hr9phA9cW/Fnm25jwxVwhlQNgZx3RdnX+/iCgPVzQhUgUt
	YYf0FncRU0gFifO+nFAr8Ww9i0x5dtscPOvCwq7C8Xdgbac0qv0uIPt1UeiEBREXKg225AN8Y+g
	UKrKcjMMb2XM1lO2FGL39IhmojHdSFWMfyeyNnNcSklcuofEw
X-Received: by 2002:a05:600c:3541:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4a35acc76eemr105162735e9.34.1793006768826;
        Mon, 26 Oct 2026 02:26:08 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd39a9sm15523163f8f.46.2026.10.26.02.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:26:08 -0700 (PDT)
Message-ID: <c52f077ad82585f1f02d5b9cc9c3f640e9fcc031.camel@suse.com>
Subject: Re: [PATCH v3 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Mon, 26 Oct 2026 10:26:07 +0100
In-Reply-To: <atvweCfhjWkT9i-U@redhat.com>
References: <179261848556.617150.17378002460197797656.b4-review@b4>
	 <20261021231959.69270-1-brian@purestorage.com>
	 <20261021231959.69270-2-brian@purestorage.com>
	 <179270025923.152861.15521453184442767016.b4-review@b4>
	 <atqpOBViqKWLZ7Q3@redhat.com>
	 <b018626bed433a84fbfa66c0c334cdb7bbbb53cd.camel@suse.com>
	 <atvweCfhjWkT9i-U@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-23 at 19:40 -0400, Benjamin Marzinski wrote:
>=20
> I do still waver a bit on whether or not we could leave
> force_readonly
> set on failed reloads. Once a device turns read-only, it should stay
> that way until we get another uevent, at which point we will call
> needs_ro_update() again. Perhaps we just need to make sure that we
> clear
> force_readonly when needs_ro_update() returns false.

AFAICS, this is exactly what Brian's v4 patch does. No?

Martin


--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
