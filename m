Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4921B1BF
	for <dm-devel@lists.linux.dev>; Thu,  5 Mar 2026 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772706304; cv=pass; b=SGsMAWLnq6pQH0Ogx3LJl4ZNvPf9m5hPp68pUVIHKOw2xop3pQuE7mLgItMRGvWh2AF1Bv2GmoRkEHSkf0VBz9QydKmogSHfSzuHtiZWF/t0P2C1PPmGVTWJUi1e0L+ksxisnoXpYzI1okY5wncv89VwpLrpsbb/bRKBOf1fIPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772706304; c=relaxed/simple;
	bh=kX+X3pU0KuZixQsRS2nI923ETwGCM9jGQxJKmm+9WzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r98sED7LMQ1/8Jcc9f+RSTl25ZVFeeorU7ByDzT9EK2G+y4K0QYtV+IvWLDGe1FefxO35qdnUMA7C2Wh/ODoXMVm0pTBiONJbbz4Y+0w8pg40rosfm/h/9fgsAsqfNfhzBtLx5TGAmUe/ouRAZXyMcV7y1Q9dyxNrEy7M1I9CTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KjIYdwXY; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KjIYdwXY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a12c19affeso689381e87.1
        for <dm-devel@lists.linux.dev>; Thu, 05 Mar 2026 02:25:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772706301; cv=none;
        d=google.com; s=arc-20240605;
        b=fuAIFS+78CfZIPjCVJj/5tLehkRmdDQ/lVYH7C3QFkTcHq6xhzn/AWaVxB07Z8SFE4
         etSrXIe2HBRuDrcAcSXF+wl1u50liQwE/7MAFS6Wr+NkU4BSbHxWFcTOv1DOz2e5k1a0
         cD9Dh0sjYoWqxB7RiZH1xz8SfmtKx/JHzNOJQZv6winJsXgOqyaxWVlwZC7JzbGu1eBa
         pVeh1rB1rw6j3YsFZApGN2vzVah2oEk2snjgyyOW+kroZOc2YD2LoqtRA1fL2N8DHC0u
         3K3sj+4K7OUsOcg1pewVOVMKFDs+SabjQ94zGjuhzI3VdGFv8zh9P2NciI0v1mQQAgJx
         2slg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ooSyTHRmJdnXM6pr2cWeSjvS6+UkbHKiEdk1HSkcVOs=;
        fh=eHQBUwedtgLVZKzuYb6Pdxe5VDxQoqgwuOU2O49KDe8=;
        b=BCqgNkCzCiqi54io/aRlTjYe4q7dY4zFzFRItL2sXzYS22OHrddo7BmwGTY/RxviXB
         LIsrKaHs4W04Gtfs+Dt2Hs4gSiBYHFO+dgaVrT02Mh1IceiRgqwZb1umyuR/5uQAQzJd
         6BYLD3LIAFOoE9a24fFgN04nD4GWOYg3cyeiNavf8rDL2MdLEtJw0E+kBKYa+lR6FByI
         zQMXTwQK7Gnurv7gGTQPa1AAc+aRmDYBcIffQhU1UCIc7clrmKB0jsGzjzM60NufOxc4
         4G9tAG9Uhb5jxe1UOajMu1r4JPJdDnWhL1kPBTxbKSQZc3YlaD38NHTFYSfz1WrFtFuq
         iBjQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772706301; x=1773311101; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ooSyTHRmJdnXM6pr2cWeSjvS6+UkbHKiEdk1HSkcVOs=;
        b=KjIYdwXYxuubU0B21NdYyvLL1dcbeqlaMOLmH4Bq3uclHYFoDuqlEK5tyqJ8me4bqF
         taUFe+84ii1jsxDNP50lzAucyTXVmonOkCCtxTDSGCCQcSQ7u0FtuhIs5vxmHaK647j9
         C8h7p+Ango0vgNzT3h5VO2r6OCNfHDE5+Xb6DU5q7U9YkkcJl4TDTZWvvuptfIhGXTiY
         DhePneimevFVH0BYr8pUG+u192HfVLw6qfN6BmYezjU4xlIxjp7p9FogAIiImal6gacz
         8D+AMMm3oiuXbbq39tBo/s2HQC1R4cX/mFTKJrCDRdjXkmwGAHH4fUCYsggoNt3OcR8S
         c+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772706301; x=1773311101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ooSyTHRmJdnXM6pr2cWeSjvS6+UkbHKiEdk1HSkcVOs=;
        b=dxmJBQIuEuX1mnD7w1XR13FzA4R55/gZ/IBJFr4N5rsis3MDoUnQ4GBuODdyuq3S/7
         MeA0td193Vf1jzdw1MxtOCqTl/HjXZvGzN8YJLsYQrtd1cfLr/DHRfIHwOLPQ1afD41r
         qUPT6GPTEPjbRRfTH90HDMA4bgpdf/0axfJVA8sTLqZj2hQT/LJxGH/YP/ZmSu9wX4Ad
         TAn44hQmb+dewNQ23J5CADwzAnuPIIEnTVCP0MgdIM7lcY7ePHCbJ4TRjEZ/ELG23uHH
         XD2gfI2j0B+I9c+RiXCNxE5pZudwWxgLqQWwyXRi0DuSQY0oIIzNXqh6iC/gRUB1xrIT
         egqA==
X-Forwarded-Encrypted: i=1; AJvYcCV6cXDcIrt8WERVU9dvciGc9yp75HwCg2IXxEjIfGsTrzXgoqaf4e7Ac/o8Qs8G3xYzgW+Nm4qNuw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzwBrQQ0aztv1SNqkxfoEDAB5/mGcSOrHdEl3aQ4E0hLoizHhb8
	a6nQATh0Z8/4Ax3jnE+Rna4yKzKkvt5SSyklBI/WlKzaEshoyWFQbhFDhX8W65geG1gOR1fRH8m
	kTGB3ypmFF/8MmouN2vhKwJZgGqqBnTtnKZhlYVMJFg==
X-Gm-Gg: ATEYQzw1gFOjrSq5XfVIgkdcwtq3MklLb9SnSyCK1HnGBK478zMvjFhU6MlZNXrx9Zd
	+kLvyuTL4+2kC4ysKReKMPe7Yr0xErAARJ1gGacNW20VSrlXuyD4OBQa/Aey54s+LYqMt05dYpY
	6/ZGN76w8hdQ97IM+g+8e3RpWydajlaoID7inEuiEYlLzUdAFGJu8uNW4IuUbBccYwM5xJI2Bv8
	a2E0o4x3y6Mcn07yx1Dv5oxVfnoYRWAtJH6imvqJQJH09CL+j/B5BWXGPbb3PaA9a907cS7VkQE
	KmzM0WP1xSEhviH7OpiAtRAWJvgPhoIF5Utdvcr6
X-Received: by 2002:a05:6512:31cb:b0:5a1:b82:ec5 with SMTP id
 2adb3069b0e04-5a131f1b43cmr608041e87.14.1772706300809; Thu, 05 Mar 2026
 02:25:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251107114318.163015-1-marco.crivellari@suse.com>
In-Reply-To: <20251107114318.163015-1-marco.crivellari@suse.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 5 Mar 2026 11:24:50 +0100
X-Gm-Features: AaiRm51lxRZvvCCpPvj-fRciZr8QkXpgPWco6f8DpX3B3nFfL0OA8NzSGyQsinA
Message-ID: <CAAofZF4QpGZadf2rApu6mve6c2NYA02WkQ+brw8_R5Wxi0H4NA@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: anx7625: add WQ_PERCPU add to alloc_workqueue users
To: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Andrzej Hajda <andrzej.hajda@intel.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 12:43=E2=80=AFPM Marco Crivellari
<marco.crivellari@suse.com> wrote:
>  drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Gentle ping!

Thanks!

--=20

Marco Crivellari

L3 Support Engineer
