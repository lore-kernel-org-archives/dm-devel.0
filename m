Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431F81E6321
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 19:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479045; cv=none; b=ZmnV8EcIYOTEvkpfMipYxHKt2jS+JfMIMwUwh0Ehbu+9r8cvTy8wuNz75Kwh10KtocT9yc6hn5cdEhvzMJHdBoz6TRJiMVeNLHgB2MLGqIuU7am4mWtLdHMHVSg3Ed3IWudGOfmStV2932BSh17Yku3Ut5Qmoyy+RpKF+4IYY74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479045; c=relaxed/simple;
	bh=h/bSLjSwp5Jqr0FDtli8wY/4FDHl+vKW1eEM/z8Asfk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xbmxkvt4aTpTRFEokbeTnlV31xAex0k+GJf9zGWQOwFSmx2Kh6h2qCIL9q8XL/5co97DTpuLYw9+ydU3qMF7NYlY3C+U+h+z09SyQLm/3d4RI6h63XTc5WqmpVulVR/OJjy18t0Ac6gUcYf4K0MuvkGk+EQz0WoWg6Lb+YV0StU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ego1pM1a; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ego1pM1a"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a83597ce5beso194827266b.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 12:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725479041; x=1726083841; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h/bSLjSwp5Jqr0FDtli8wY/4FDHl+vKW1eEM/z8Asfk=;
        b=Ego1pM1abw3WLPMWhIjSU8HDzLxi/Ody+hTkUveUz/Kmi4q1HlGjgrDkCq6pVADMAI
         ZJNi+h4cbVQJ8rivlquK8bXcZXzDDSq8+K0ADxtgaMbODdpdDAfzW9OjOKR2zaTrYjY+
         vKjcAS+8RnjaBnwDeBWgH271fumZOyS9sbi5arxpKV4x1+I2PeBvZZ336nAOslgDBjxW
         ySV7y3IJgwfMYN7k/bJDqC6o7KCS5/Kuk2UQsxEP0cbKSqAJ04bQQtiApdm0tcntO42C
         zO+v1WoelrYzujLrll+HKWIWxyCMckThJiDbDHpE3iWQn/97679qO3eXaaQbWqEbuirN
         27qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725479041; x=1726083841;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h/bSLjSwp5Jqr0FDtli8wY/4FDHl+vKW1eEM/z8Asfk=;
        b=TM1+xAhHBuH+GYBhGrsIyVkBgZqxc7+5SCnHlvXWok9G6mFa5MN6oR1ochi3T3TxLg
         iewFBKUtxo55XtE06d6OWrjOJFPI52asUlGvVemfh8WYZapG6wAI13lGc07RjPn9MIZ3
         can992H0P/JQMGW8L9socShLifjnOanX60MBljmnaoWd8f0BysmCnE1TpQNGtanjFl4K
         LqmmMiPwgaqf5aAGbJ2aUeoi5tNnb6GZClB0m9lLsMYlRvcaCw5bo+sZpfH+CssC95YF
         1YQD527NDwlCtPR8Kic3BPs6Sz7OTxGsXwlQTHLDsnB1FPEOfBC/dZM91TbgGe+A7xxj
         SBNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy/W3wAAZD70eGo/1uVlrxKo2Ug0aUdvIw8CRxaUDR1CSxYErrnuwwoW5axh+1nPyvX6u861uHog==@lists.linux.dev
X-Gm-Message-State: AOJu0YzOb5AwtqzLIfltMoDtKX3sG+P91kdGmp2Wbk7LOU3V/ksDX91a
	oHvAi7hJl4EcIum/vcFEefyGkgWW8NXkLy12F5XzBsfLwbfTD9hLS/TVecmfp4I=
X-Google-Smtp-Source: AGHT+IFXTQwJ4IbBvl3h81L3siq2tdI9AiPHuwyf/T1hMiqxNmQ0sCuyTyPxbEZWBvmrCHeq2kaaGw==
X-Received: by 2002:a17:907:d15:b0:a86:a948:7063 with SMTP id a640c23a62f3a-a8a431c71femr357350366b.20.1725479041013;
        Wed, 04 Sep 2024 12:44:01 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fbaf5bsm29748466b.23.2024.09.04.12.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 12:44:00 -0700 (PDT)
Message-ID: <7a08873cbc34964f97fce214c4906568c1b86c77.camel@suse.com>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 21:43:59 +0200
In-Reply-To: <d0f8e48a5ac7e42d1643c07dd6b08a601aef8f07.camel@suse.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-6-bmarzins@redhat.com>
	 <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
	 <ZtinIZY2jMe0ZDNX@redhat.com>
	 <d0f8e48a5ac7e42d1643c07dd6b08a601aef8f07.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 21:36 +0200, Martin Wilck wrote:
> On Wed, 2024-09-04 at 14:29 -0400, Benjamin Marzinski wrote:
> > On Wed, Sep 04, 2024 at 06:12:37PM +0200, Martin Wilck wrote:
> > > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > > Make the directio tests work with libcheck_pending() being
> > > > separate
> > > > from
> > > > libcheck_check
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > >=20
> > > There's still something wrong with this test. I'm seeing lots of
> > > CI
> > > errors with your complete series applied.
> > >=20
> > > https://github.com/openSUSE/multipath-tools/actions?query=3Dbranch%3A=
tip
> > > https://github.com/openSUSE/multipath-tools/actions/runs/10704501258/=
job/29677643779
> >=20
> > It looks like your "tip" brach is missing:
> > [PATCH 04/15] libmultipath: remove pending wait code from
> > libcheck_check calls
>=20
> Yeah. That patch ended up in a different mail folder, and I didn't
> notice. Weird. CI looks much better now.

But some issues remain, e.g.

https://github.com/openSUSE/multipath-tools/actions/runs/10708349169/job/29=
690448105

Martin

