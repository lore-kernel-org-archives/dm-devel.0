Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900788121B
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721072510; cv=none; b=JN+igbY+lt+CLV9cR/ADLLpMaFy68PHMduDffOJ6ZOrGTN/sRVRQB6yq7QfyItPhl/S3keYJ7Q6GdFr0ZNdl94klUPo72vo8/FdTKrffJpU3aRZNCOxPHs/eWfXkV3/GrujRQFX0YLj1Bl8Vpg04YXmHCs68/ZX0LWjrCmk0p+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721072510; c=relaxed/simple;
	bh=HkOI8aoCuZ3/Cj3FkZ/7Z2Fij/A/R/+VXHVlaQSodFU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EIwfRozxOf5pyolc45WocYGD8s7qURZk+ERLXRROaXxcUkh0hO0rDOm8I3ON0FCygywEWjXWKp1M+urtGSxMcdUQoxQGGlNizkOiJPxHSI0PnQ+AwcxIAjPnS/Le38Yf3Cvb5CAcHutduRgjyLj5Ryafs4n7BG2ck+P7j1isRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ieu2h2Hv; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ieu2h2Hv"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42793fc0a6dso31943685e9.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 12:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721072505; x=1721677305; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HkOI8aoCuZ3/Cj3FkZ/7Z2Fij/A/R/+VXHVlaQSodFU=;
        b=Ieu2h2Hv/SqkQKm8PkRUlOydR+Ua/AIoQfZjzbDNtPC/HBwXT2AjpcHE4d2l6HjpsC
         VRb6hwiLsLP9AVTZpojQNttHa4DjT7EaNr09LCUHbybkQxbL6M9PK4GE44GTt+2Gcz2P
         NEEESDFiHLyUSiC0vEyZXPayXHP76GfSvs/fiwX14X3JePoOTYQvg8YSFtODjEbazQ3u
         c7/vPPmeLi9QzkzsfdPElMunCvy55V/PsYD3RUUime3U4c6tXbOF7cIsBrxVRi0cgu0q
         n2rIuS1i6Y3Xu8smxTZPOeP56e48jlu/VR3F1zeqVmON58NiRqo2HQ7fppLUeLQRLbDf
         PEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721072505; x=1721677305;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HkOI8aoCuZ3/Cj3FkZ/7Z2Fij/A/R/+VXHVlaQSodFU=;
        b=YRiS1ht3duHkABXZJECJme0gWfxM0a25Ng/mDZf1wiA2yp23/1KVJSTKkUPqsrKjjg
         SoCXDNdw7457fcFFfXNzzSKN9qRL0xX3Vl/hn25FazjtNhW3dSvhyHHR5nYAnBP2v8Kd
         7rQdG9Ux4meNdytT0KusEjUSG9jx5ARuRp4EsqLRm3kkScbcDH+hSNkz09x6amFYJZoZ
         f/zurmtWZfJ4M2zEQV1az6CXIR3gr4YnABfuwnnKdkdRFgNOEXKA+jtU3GbC0og3ndtF
         CL+BNH6ASfGk/0Bf4iUrN8R/Kd8ibaBZibEDPOHnkNl5IdxgRQyEl4zlI8p30WLgLsi+
         KdoA==
X-Gm-Message-State: AOJu0YwhvNokaNAcZG5ZyzaSoOTeSgqwynhOfN/J6Rx+yXwW/nG0m02l
	d9O39dKZp8MWL1USQ1r1+BhiYjJnLsFlA9Uw94Zmb7hNIrw2b2P4aU2Pt8b9zu0=
X-Google-Smtp-Source: AGHT+IHgCTASijLbydSY1/0xa3dCb3E6L0oLzhlYPR41n348rBHg92yLtJH/KChdiq4OxxFRk/WWyA==
X-Received: by 2002:a05:600c:524b:b0:426:61fc:fc22 with SMTP id 5b1f17b1804b1-427b88910fbmr4011065e9.3.1721072504694;
        Mon, 15 Jul 2024 12:41:44 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f23984fsm133049315e9.7.2024.07.15.12.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 12:41:44 -0700 (PDT)
Message-ID: <7d3a10c8157b4740060d720a13e932e37fdf43f6.camel@suse.com>
Subject: Re: [PATCH 18/22] multipathd: don't read conf->checkint twice in
 check_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 21:41:43 +0200
In-Reply-To: <20240713060506.2015463-19-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-19-bmarzins@redhat.com>
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
> check_path() already has saved the value of conf->checkint in the
> local
> variable checkint, so there's no reason to read it again.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>


Reviewed-by: Martin Wilck <mwilck@suse.com>

