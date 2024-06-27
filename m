Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504A2E3F2
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480703; cv=none; b=lzGdtRkmbYULcse2MygVwoHL/kUJEwUsqQ45CbMm87dXTvg2V4SMb17EGvZ/0tvpS5VV27bELNiawf1S8lZ0B0XjtW/zMA974teN/NRECcYTqOn/bsC8/byjawtEushQccNVexxu8ZkPdH+JHDSfBp9s+mIQ3WK/08/PMswageQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480703; c=relaxed/simple;
	bh=pug2oit183Jpf6fqGTo/4iSolV655as3BDwybKEDOtg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KrqIbkAe2kx8KJ0jSbiR1Lqe4SAOdVUQYz3Vfj/y4n9esTIYLN8fKUjB1HqvueYjTvrMZHmij/YiZbs7hwUbO0GiN+U8gNR14vytMDcutYtrWmzP8cR2aeBtb/pOberGeODzvOezJ5DdeNawvSg9pPo0a164pSiBl/1IPKUn3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZeOkylX7; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZeOkylX7"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-421b9068274so65543885e9.1
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480699; x=1720085499; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pug2oit183Jpf6fqGTo/4iSolV655as3BDwybKEDOtg=;
        b=ZeOkylX7Kw7yXY7AGAKdB7sc4HmrgTcXp2pUHMovtu05c0x8/1bQx/NUFf8aHehXj+
         OrCouTs7DHDnV8LD9uZJf+8tTNqhXdnhN1Mf0+tkRDMTVY4H9x36UPYrSKK+Shvx4HAw
         sm5TjFLppQBIZrzC7QNkhmkKHO4RMmJlGPDSOllxz7BLrFxdYEMY1gL91//P0cMY1h6C
         lgLUKrn2lPtGUjXv+UVfG+YC2dMR50yO28D0LigaiabSMUYKruta5q0exkaBptUkOkR8
         g9qO+z7g9YOKPmLvxfVA6p0bPS9Wf1R7c1RFvqY43KeUttyXXh3YJI7u9H8ulon5fwgT
         wxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480699; x=1720085499;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pug2oit183Jpf6fqGTo/4iSolV655as3BDwybKEDOtg=;
        b=WHtmmtKxNVcakxb13kwhb3jUAtiae0Z3BabqyUfGoBKYg6Ua5VjVH6Mezbsklya0rO
         f7nZWqZJ0DSBAw+Xrb9AMyuMomHzkiFLgJ3gMJNgKAcRR0sViC1Bz6mLuy2u8aJLWKGB
         /jH7Ww7GAKWXCae4tWqPq0r5nasoM/HyX5MOpOdSrU/4g0l70jC3Mm63owU6To7DdZSV
         AgixLfG0dNN9HbBp/rEILLf9Dj7Ix3LkNOpy+m0NExZSzQKKSdZYc5AZW3QMVhD5BcKG
         TydL1LJMHTG8j+V3kd19KZecI3/yO3D/tI4ddWKDLSb+UVkYDLvRzynOznUDJb0nCWY5
         18zA==
X-Gm-Message-State: AOJu0Yz0Ue2JeSwBe2A8RWAjNE04mivCLCUdSsZAG7/6qSZBlBUwor9Z
	tmG5hOxc/EfDmRhTEMyjw+xXfzRare6tnySaCppbooFI5wG+07tpy4uC4P76VcU=
X-Google-Smtp-Source: AGHT+IF4z0TDPVePlZPorsosiTslPcs2vERw4fDGB1swaqZyi0wQiD02YCcOmC9dSFrVPXSVq0w7Hw==
X-Received: by 2002:a05:600c:1c90:b0:424:eeca:6bd0 with SMTP id 5b1f17b1804b1-424eeca6c69mr27421405e9.13.1719480699160;
        Thu, 27 Jun 2024 02:31:39 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-424c8266ae7sm55499245e9.20.2024.06.27.02.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:31:39 -0700 (PDT)
Message-ID: <93c0785391ff13ca580b40f6fcadffb7e6366cd1.camel@suse.com>
Subject: Re: [PATCH 2/7] libmultipath: check for not PATH_UP in detect_alua
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:31:38 +0200
In-Reply-To: <20240605232254.623290-3-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-3-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> Previously detect_alua was setting pp->tpgs if the path state was
> either
> PATH_UP or PATH_REMOVED. Setting pp->tpgs for PATH_REMOVED makes no
> sense.=C2=A0 PATH_UP is the only state that path_offline() returns where
> we
> should set pp->tpgs, so just check for that, instead of checking for
> all
> the states where we shouldn't set pp->tpgs.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
