Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C51D88D0
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740117914; cv=none; b=KojdHUyb0jiMDzTsrj6lLVhN/iucGJxuPV1hrJO4FX82IJMnKHb442C+ujEHuMk6hUJJdR6JrJ+7IPZmTN8AHjOC1LAGfO4ih236021iwI0tsbghAhZ0F88461tiFSyFXUV9LH9Ak/G6n9Phikd/U2Tu1rzLal/Si1PUQBZaN7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740117914; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzWkoeeQwAOKhap8VKLiKF00Jn97GwVeZDsQoJfusnlaglsriAPm0V8rzWT9fM1jLw66hMDrnhbzmBOTDt4XGzcl59NRoNYY/0Hl0MX7yX4UwHttFa3jx7Fw0x8gbWGJXY3eomCMtoRtTJ5XNIgDd1La1qaZLyUx0RLOlzGI5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHmIR9Qu; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHmIR9Qu"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abb999658fbso226018366b.3
        for <dm-devel@lists.linux.dev>; Thu, 20 Feb 2025 22:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740117911; x=1740722711; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HHmIR9QuhEvrlA/ulCqyBgSNtdiESIOz0ipYV00OU+ljaqXmqcWxusUqhH2gt25cyx
         am5clJ8jl5C3qIpss4M0LN5Fn1dL87fiwoWpQA/O8w3oiuTG1qXAWF5utH5XNBlJkeng
         8ezVGWOxnUEoJrHElhVgJXLTbM4baDZw/1t5YB616iSk/7cRAJSotqbNpt1IQytSXEnJ
         3HbSMn/ZExJdtKnY/2qeaH3qLzWVayC8QdGKA+H+8KHiqYUFqqlDmqMXa429VUxcT1nZ
         SBXFrE7gQfJnMkWGtEs4nm2s4ERu7ufbHRgFfBJKtcBsu7PN3XEkncrBdmkwm6kUdi/o
         mTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740117911; x=1740722711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=THE/9dC+L+XGiFWQyTNU2VdX+GIu/6Vz0mGH0pdlfjRD79Nj101mVVz+Et5HLZU1hf
         OMRQ1vVyuv+duwsTU6NLiCO3pqyHGLjtW9Ld2S22ZQZeNYYvnG/3BIBLCT5u0YUjaUyY
         /P7bf752rM6ljRl0tH0tSJDeG6TKD9XMJnakE8PfvKfDmpBKJdOg4+k7P/n2KIpB1Iv4
         BEDrk4dX/d01CETHvvH7jDvj7/yF2t5x9hsedy9CVe3WL8gDYUL19LrlVuBfrioIaiyY
         vmnxjg/CJ4oxDUnfFzlaSaMslc6qKOCsBO/lvzdeeVcAErLE0o5F2I9JpYUcHvlHGuO4
         HL/g==
X-Forwarded-Encrypted: i=1; AJvYcCU2x+EkI0P4myvxdtG4K1iO0tScDgJdX76WsIQuXpKxncHPSfLcf9M8Cj9wB9USXV2tvlyIiTOLPw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx30D5EEenuoOloSkYSZLuDjp+OpBmaczQK8ScG8fvehlBuZspW
	bDwsLWxUGZ4QNEn6C3B/p/dU6/sqLysdkL57Jj46jXeonsvPeo2dgKfoi+u/54lto8Quwf5/r2M
	MHivjMygpY7eEb5q/NvmrjDtkYw==
X-Gm-Gg: ASbGnct67mKkBwpJ/NHdP/xeb0XhieXHdF8ClHdimXjnH695p2tNeK/n4rNgbKf6dUv
	0mWY7qWmBeBb1M58xIcJfRSs/DF13o9OaMAdD9EXW03HRUR86ZgSweerTGWD53HGsyNnwBhq6nA
	2ESxouP+P9dvTGrKe2JoiTxKbB
X-Google-Smtp-Source: AGHT+IFqsqLmxocQugIbK9vjPZU3nLOPCvJu1kzDH1vvkFxoyZXwF1pH6DjSYYeOAnii7MMypyKnceinr2h+ryT68v8=
X-Received: by 2002:a05:6402:3815:b0:5de:b438:1fdb with SMTP id
 4fb4d7f45d1cf-5e0b7266b9amr3458312a12.30.1740117910650; Thu, 20 Feb 2025
 22:05:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-3-hch@lst.de>
In-Reply-To: <20250218182207.3982214-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:34:33 +0530
X-Gm-Features: AWEUYZnkH4bG6S-2IdwNrETUoshkkeTOmDbjml1QjZGKr8spA9_vriFJNjo0jaw
Message-ID: <CACzX3Av7H8NOT=J1uae4u9VYVw72BBmDaNENK1uXz=pfBMrkVA@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code into
 a new file
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
