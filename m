Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB171386C6
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480755; cv=none; b=Ulfe4t0lmDWmTgiC+vU0IOKebcIsmie+yGIHA1e1wSTSU9Mp6306/0Jj02B5NZTfPGPElDrWzNwiOx1iHFfMxagdykVt1C86JcjyijPrys2Mk9D2izuCghehVePnLu7LOTwUf2BnUp9kY5MDoDTCSu+S7Cra2mg/alV4INCajZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480755; c=relaxed/simple;
	bh=6qWsDdf2aD/1zbkLKsROs36YwmaYTqL0WAI5jrSJilY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s68ZtETQJCQlJS3r5CShXbf/E/S+nOrW9tsPA5OhXSWRfmrndaiNKlaOE+xdmA/l1U9szMK8Lzu7Z88NVqWn4hL3/XMhcHNGYA+Lh0ySjagL0jCX6/Yc/JItBfnRgqTe9EDDcZl0oStiwYvO9B3HgNEX17SkwxFg8QR/tOsudZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=acHlJwpk; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="acHlJwpk"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ebe785b234so84790321fa.1
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480751; x=1720085551; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6qWsDdf2aD/1zbkLKsROs36YwmaYTqL0WAI5jrSJilY=;
        b=acHlJwpkD3XtVnAw0ZtHX17xF6itET0xewMNMFiOszecC+iw6eVTVjsqR3Pqh/imSZ
         kymvsPvYya5Dii+yIvtGmmnV95NtfDGXOJDHW6HMa5qDyPlh8BxopiIJsp0ql+05Cc6u
         HWmxDjr76elGqBr8//rzjGY68xK9GZWWxgqmqGpVjnrMERqVMNtHqddunROpRQFBSqMc
         dHFRR9SXkz93AkqRw9y+zpZk/bpIr0dSQjwF7bBAZ20jQHxB4J6lbRHSvv0JJBa8QnVs
         6lrnVfv9uzGUc0YZ3l2ZLQQiOrD70dZUBjWehqg0h7gA9cgs5wvS7XeUEWJd1QvA0gRR
         XTMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480751; x=1720085551;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6qWsDdf2aD/1zbkLKsROs36YwmaYTqL0WAI5jrSJilY=;
        b=mPFmyjQuVi8ntuhWFfNuCpMf5s1suU0sZsDh0GwVUvjAFObjwTljSfDJ7XXwoGy8ac
         cMiES4qXcFLlGJFvk4M/2bEcQRuCTN4crpCUchVDEtVvUmqA8NaPjkFEMBo5hWdpY0kg
         K1pO9y+1qiNAlxiKs0lkuu4fnSlc1fYl/g2v6rYFT/QHknVkjXWYHJGhPlyAXfJFnZ+D
         6Uq2tCxZhdXaGGeFjsmedTbhlNoBNYJgz1oVNYTAeyrhKkG372PMNcb66PR1ajFpynWU
         lcrkT2pYibPu3LbvRnmVarp3jPMCViRBuYkKPUy22JC8XLEgUzcGsJLQY1ya26Ds4KJY
         qf6g==
X-Gm-Message-State: AOJu0YyIgAhIeqODAylI1l6YWcMf3cwaA5tfjh3+hAe2V+OOucDbu9o9
	xomnWnlf5xwyY4kF5bi0nc2dP8+5dxUunQL5E4uKOjc8YR16wSrzog/KLyJm6q8=
X-Google-Smtp-Source: AGHT+IGDQa08GCPb7mKw3jnscIS7Ry4/TXhXs5mFyGRpgX5cEcSFkfILVRWyF2iDowBFlyFnV6X4uA==
X-Received: by 2002:a2e:a801:0:b0:2ee:4c2e:3d3b with SMTP id 38308e7fff4ca-2ee4c2e3ec8mr6282801fa.4.1719480751243;
        Thu, 27 Jun 2024 02:32:31 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3674369ed18sm1229808f8f.113.2024.06.27.02.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:32:31 -0700 (PDT)
Message-ID: <511cfee98b64f50c792fe2096df80d95c67b38a2.camel@suse.com>
Subject: Re: [PATCH 6/7] multipathd: free alias if cli_add_map() is cancelled
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:32:30 +0200
In-Reply-To: <20240605232254.623290-7-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-7-bmarzins@redhat.com>
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
> Use the cleanup attribute to make sure that alias is freed if
> cli_add_map() is cancelled.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
> =C2=A0

