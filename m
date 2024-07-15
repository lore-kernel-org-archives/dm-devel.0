Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DC61804F
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721078532; cv=none; b=LWxy7NYZaPGKbx5cLk875PlQ68R+6GKCwvgO3p0vbPwUVAbTM3Vt7hZUOIw52c/60xyR8AWkMW8zzMJFuPQDggu3DOzIdG3X9S6CVJityftiE9vly2fEGfgpKRt2lIsCxZhWIiy2ufC5EfSEI77nM12MqYCh+FUbtR5TbmDl/t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721078532; c=relaxed/simple;
	bh=E8e+HZvo/DKtjDmf1dNKxOTgrWWZuF1f2hW9g9IIAzc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X2cnQLJ1n6Jw43yvXHb9nEuiUIQ+SWzN7XP7YSNuhtBy60xeXHOOWWifPBmYpwE6SDCwYwGY751lH4tUsqwC6x2r3GG/fH5TbTKx/FcwIaKGRcrXjuARh8iIEoFc2bbP7DdKaCYjJOUNlqGW7j9EXE3Zf3Ie7EPg5wxoTGI6+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kxj8GJq/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kxj8GJq/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52ea5dc3c66so7697585e87.3
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 14:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721078528; x=1721683328; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E8e+HZvo/DKtjDmf1dNKxOTgrWWZuF1f2hW9g9IIAzc=;
        b=Kxj8GJq/cbI4B6UJF8Lzxnm9h2vXgWMFrl+KYuP0QvbA2FThPVmOPV9aY2AMoBE8DJ
         /N9EiRSunVxQ5sO4j8dPogtUPQ+lmnhlACBv2VvQ6fUAssREWsrBcJGX/F3Ia23/nKMQ
         FuQ2tXMtA0T9Kk9v9G/sU25EfEWiEPg87mTN7EaxGFstcPzMcNM3th4L5G2oV1Ml20Zh
         mKjkiJeofh3Rvmgm+7BHis/fIvUMt7PiANMzKMVTtNLZsbRS0+hkkiM7nct5soLv57DU
         fqFKnePPZeZkIwxSIqzTPLD6yJic0m6KHIAFY9jB72MJyubVGfWFqsXw72zGv8Ppp4Ou
         KqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721078528; x=1721683328;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E8e+HZvo/DKtjDmf1dNKxOTgrWWZuF1f2hW9g9IIAzc=;
        b=pHz/KbctJCXTX48c0JoXeJYHjlGtwax+/3tJaTA6PlW8W59p15ChmT4kROOeMB9FXM
         ebr6Cqv01NVs2uVgUvPran6F8VaX+7hGYUDJdZwxgdT2fGbFvNpMC9neqTi2kWr4cwlm
         K8WnrP6cJcf3+7j8ZAXsAsJ/VtHgyQXa8Mrga4zv2zcPvGf6f2+HhAlEoX1rcdMhIRGF
         wpS2D24tpVHc69f4WlVf2+SOUQ4jinLD31ukYrTA82XfUK8gn8MPt8nrVb7degXpOPzI
         eCfmXVLWRy5gRnN5dPhvQYjMHjv9xomy5HMQ1R/2B4f+HHaGtK6UJeirI1/LWbYqknBI
         HvmA==
X-Gm-Message-State: AOJu0YyeexBeh28r0XmHwzkI8oeHs8yeVPaWBiubORbWqK50B33N73Ro
	RORjbspm+ubP9IX0F4BESlqAAxKihMg9cvqNyNib2mvvmlKR32sGySWOR+Y1JPA=
X-Google-Smtp-Source: AGHT+IE3ikCgnDpBM583HuLnYdTiCNAW6YF8XDD1NJtKeoC1fz6UWxrtzNalMe4NjZL+h9puZbAa9g==
X-Received: by 2002:a05:6512:acb:b0:52e:8071:e89d with SMTP id 2adb3069b0e04-52edf02dd19mr138061e87.40.1721078527658;
        Mon, 15 Jul 2024 14:22:07 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc7f1d06sm244445166b.142.2024.07.15.14.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 14:22:07 -0700 (PDT)
Message-ID: <fab74ceeb25ded98f57fbfa59b6afbb9731b8502.camel@suse.com>
Subject: Re: [PATCH 22/22] multipathd: clean up the correct wwid in
 check_path_wwid_change
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 23:22:06 +0200
In-Reply-To: <20240713060506.2015463-23-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-23-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> After check_path_wwid_change() grabbed a new copy of the wwid, it was
> stripping trailing whitespace off of pp->wwid, instead of the copy it
> just got.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

I'd suggest adding:
4660cff ("multipathd: add recheck_wwid option to verify the path wwid")


