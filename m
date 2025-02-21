Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDCE1FBEB0
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 06:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740118103; cv=none; b=STbTJ4LYUm6vBZlAXxbTvJX2hHinbqlCVUp3ZE90M49bDacHsM2kxv00eD6xh8ou7KDBFvNP823QBxaLHVFkdXpXBYX8G++uPT3yLCwToomV+CbsBYbRgOqdx1T8kY3am/4ftSUc1UAcDrLqowtoTb+dAhY+L181imzI51MWCzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740118103; c=relaxed/simple;
	bh=EEUMHT+MXWjcUhxvJADFxvqGCYi33zuKXrJ0i9XJBVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EGtVA9jYXN2lPw7pvXutT7cOmlazPgz6hKqYLcNyIP8Ph+bsM5TJT62VtgRCFixIO0oUlgN7JCZAl4yo/YqHEvDJhg4cBzci5REVmGHmNqoqxNI7l6CO9KsuAxhM0c7l9y8Q/fmDKOtU5okFBXuhOxxlEY/ilW+imYeeTmtz3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iF3qHUmr; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iF3qHUmr"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso2817704a12.2
        for <dm-devel@lists.linux.dev>; Thu, 20 Feb 2025 22:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740118100; x=1740722900; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rXIAsbh7aHz7zxtPXm+IGu5FLVtJIRSaOQX3D3d9lVk=;
        b=iF3qHUmrT5vXtrX7gmfJ7AfGQjmmJZkOKVB8iognW/idKyrt5SlD/3WPTZ52ZGTfI2
         IFHc9sOh+vV+LjVgjNgd7JPxJ3v9KvJT3+MHbx9BSw1wSZKkOjh3mNQ/zAVxpZhMqKAi
         C0I/3IocVydWnZV39nOEWwQ+qUw7mJEGOBrONoKdS13seBtbctwnc1waFJGhSwT5NaQe
         CW6WmgVFQVvfTSp7USm8XmcFMzb4BiI5CJvrO6uv8Bkdz7s0KmieaNue9njM7rOMsLo1
         BYykmE/i8+AWas0QDNzf/8dCaMX9S70NfrtL5gEOJPucNs0Yvmif36R1jn2hAbOgHQKZ
         s6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740118100; x=1740722900;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXIAsbh7aHz7zxtPXm+IGu5FLVtJIRSaOQX3D3d9lVk=;
        b=D+WDsZtZBISgSRd8uoNKNRx2DuNiKTPIu0kyRtkhymsnD8sPqApeGB1ysqBxGB3wf+
         sQCSo9MlURP+m8jei0qCKqvQE3rgTwbx9YVlO6xfrkkZWFKiCVwgaUZpyN/Jb4XS/Qyw
         N6Vz01XykEYrNZeTIMLQQ667KcmRPchp+ZNIAu0Yk9qNEpe50HV2I4ysAT/zZvaFhyd+
         CjJZHGUoE93RzMIguiiQP1+E3gbeKQVLOhZUO1fISeTOc6hdY1nQJmqap0FVuS06Q/bG
         Z7ATiJJcBRSO/A8/ZEGNv5oweVuGE32rmLAleB+jjIlG7mnLDTIV2tjOZYw5Z0qtr8lL
         lbtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSUXqGBz2mnHBpCF71eXtrk6JsO23yqcdWJOBaySPKHcediumCMLstyNeiV+4Mj7QIzDR2w8H4NA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzta3Vw/pRjQAWn6nN+7xH6/wYjewDrRmsRxAxDPvlr6vrSrJA3
	JRmgZVt5udPcbsVqDHPtHowMl/qMnKMcU7tBY36bkUaQX3AdowXPisrzJknQG05E4ngV/rm6GnX
	CldM2FIjT/8gKzQ2ZoNO6q9X02g==
X-Gm-Gg: ASbGncusyTZe00yGS1VTLBs0Z9ZYRK60Ml4f2oLq1Qp/iTE8n62DuLd1RQwP7/0pyYk
	LAETezkjGI08orCo53zHinZdv2zLGwf7kxg3X/O/btcOu6ldOE1wyCmkFgD235+3AbhQw+hwCdk
	2KlajC7C5PyPduFeVChsJkEoNE
X-Google-Smtp-Source: AGHT+IGSAJUMw9Sp7hFY2WSXAN+Y4fq4PMpBrLP5G4AqJ4vrGshfCGfm1O5FpHInDxMpuH2GdwnOkP66SmpgZvdDGeQ=
X-Received: by 2002:a05:6402:5109:b0:5e0:82a0:50e6 with SMTP id
 4fb4d7f45d1cf-5e0b722e6d9mr1358230a12.20.1740118099837; Thu, 20 Feb 2025
 22:08:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-4-hch@lst.de>
In-Reply-To: <20250218182207.3982214-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:37:43 +0530
X-Gm-Features: AWEUYZnDTwkGMWyCUgvudiybYOkTa2ek7SZeupMzTfedY5-h6_e7HuSEjs9i1cY
Message-ID: <CACzX3AsGgjJOtOo-y-oJ9K+PKm+EgSxTjOJ+UyozYguzhxpe9Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_data
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Many of the fields in struct bio_integrity_data are only needed for
> the default integrity buffer in the block layer, and the variable
> sized array at the end of the structure makes it very hard to embed
> into caller allocated structures.
>
> Reduce struct bio_integrity_data to the minimal structure needed in
> common code, and create containing structures for the payload + bvec
> allocation for submitter provided buffers, and the default integrity
> code.  Stop using mempools for the submitter buffers as they don't sit
> below the I/O stack, and instead always use the mempool for automatic
> integrity metadata instead of depending on bio_set that is submitter
> controlled and thus often doesn't have the mempool initialized.
>
Like Kanchan already pointed out, it seems you are referring to
bio_integrity_payload instead of bio_integrity data in patch title and
commit description.
