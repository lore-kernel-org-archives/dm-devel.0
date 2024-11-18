Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE2B19413C
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 11:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731928706; cv=none; b=ofjzp+CeUafFctaLkF7Lbp8wojjq6zqoX7mfeLSj7c/ShOi/bpQLXQ0gEF7oF1Yr8XAx+TE4up6KYLgoYb30Lq81Y5gmWlCyqRbutkY2RYk6DvhrkFvMeAtA3vvxsTD2c+/oeVGO/8Y83JflwcGyGvOEfd41mlTv6HW3Nivrdcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731928706; c=relaxed/simple;
	bh=R+cVxgcIiN1I/d8c1XJqlTNiHkM+vRbPN20zzCbzyes=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JSr4KXCIUoHzuijX+hkiGUa9TQ4M1BxwFQaUtsCP+Y2geMIssLB8Ti+vQbQwFvvRc5EQUKtdrZZWL2kcHwC17ZZLpLkgczfcSTfuQPioS+IKKncmp0q5EUpkb1aZ5DMIcN9+62cEY8+J5ABXzoP+M7ZhELTKKNfqKFJIntpWjnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UEfZJ/03; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UEfZJ/03"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43163667f0eso15678465e9.0
        for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 03:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731928702; x=1732533502; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R+cVxgcIiN1I/d8c1XJqlTNiHkM+vRbPN20zzCbzyes=;
        b=UEfZJ/03ic/jBh/Z5e2eTExMxi19onimJQ7gMdVwJH7IE2R7cUaAO62ydIdfMloIjG
         W//YjVu6z0KDZcrHaxrU94LzjsREJeepkzRO1yoJy4L4fIIWba0BMxFvi4RqZbBUSpUA
         5pkpEhE3euDwU3kVfnAD4U4k39TsFvdiM/kU8oNm5i7ygyWaovm1+Zm0gR+o5Rdt7AcP
         jTjigaQyhJm37r23F1vqqbjqPyKDhbfGNhEYq+k5EJ0QQGyrHU7QcEWaEVf4btNu2u8c
         SxO3qwVNPpA8zouvyplwIyjepXf7OprRt4C3LfwgEYY/6PMdFP85h0yKje9hUK8q5a4u
         YVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731928702; x=1732533502;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+cVxgcIiN1I/d8c1XJqlTNiHkM+vRbPN20zzCbzyes=;
        b=dCNXtHUdU8uRhBtFKkF5W6K9ZpO8sAG6KxCljNmuGYEJA2PDDG+H4k0FgpST/c2cs+
         wGQUg7bBGv42gCCErr2Pm3Y95HRCeJ6WsjVIC6bax6WaSVFoGPlFIljLmbpY4xINx7DL
         APHTcl65l3Y1zxLIKZnGJHP+CuUQp8YcS0FS51XDdKOp5XezUwJeyUg7iQvOqABT/h2J
         HLlhCRxeRrDUQPQYzUGupRHAoXm/Fii8+kRLzfZEa/utTEa7DgnD4ffrck1T74yKaIff
         kGG7U7ohWDGIy2u1FPxlKP7fsRvEPo6cozXGDwko7kX8bfWaeK5asulaQ8cLxGax2NXk
         kYqg==
X-Gm-Message-State: AOJu0Yz96eGkv2p6zOpNXkuK2A54xFKfaC2/YkaClmtGTy/aZUhtUYKi
	yTyT59OYxzv71VpXunDig34dtEleS1Jv1wbWYQH+4Z4eyEhQcjcvrl0VJ/1T3Zu3duQ6xN0JkCV
	E
X-Google-Smtp-Source: AGHT+IG5aXljXyLtwPnwK7trmGdAxN4v5Gri7EInk3NBSJfF1bZ7CYKX8SY4hio1saD8xZUTjJbcyw==
X-Received: by 2002:a05:6000:697:b0:382:4aeb:91c7 with SMTP id ffacd0b85a97d-3824aeb965emr451978f8f.18.1731928702105;
        Mon, 18 Nov 2024 03:18:22 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38245e95925sm3275860f8f.111.2024.11.18.03.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 03:18:21 -0800 (PST)
Message-ID: <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 18 Nov 2024 12:18:20 +0100
In-Reply-To: <20241115232256.627933-1-bmarzins@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
>=20
> I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
> alternative would be to run a second libmp_mapinfo() call without
> MAPINFO_MPATH_ONLY to grab the name, if the first failed with
> DMP_EMPTY.
> If people think that's a better way to solve this, I can rework those
> patches.

We could simply choose to always fill in this information if the
the caller has requested it, without an additional input flag. It's not
an expensive operation.=C2=A0Is there a reason not to do this?

Thanks
Martin

