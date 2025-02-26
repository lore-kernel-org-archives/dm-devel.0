Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BE7221DAA
	for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571848; cv=none; b=DUQgfvYTkrC2sdizI6cjsGt2qB6tDNpJfYNbLf0CdznmXWZF/oakfnlwwwx33YOSIvyTq7FnInIhDozVOSL45fFQiWo5Jyulyp53D3NAapYg2nwG58FUfBZbpr1QrrcnE9lVQIVrOykZfakwmIH4GvfGwaOvc75+sQl/QYuGBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571848; c=relaxed/simple;
	bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAh6jeIMsWFdhZlA+6Ewi/tHPV2fAPOjO+Zn1UEiMoRzjqQmHNL/1tQ4zmt115Ef3lpAj9y78s5mZXAZWQq2GdpvBktkTdJ9Wq0vOnSnKbUnjXJBEMS4fnO80ViYsvUpLA2mEulYzcREItSxDyUWS8F9fbO+iNYj/Lr7Jv9BT7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ishsq1oP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ishsq1oP"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e0373c7f55so10291946a12.0
        for <dm-devel@lists.linux.dev>; Wed, 26 Feb 2025 04:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740571845; x=1741176645; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
        b=ishsq1oPKS2nnk9vPbHbkcVflhtDAVm0g5HFrovJUMjwF0EP7KrFYAoajOrTYb+/QV
         0W2Nmg+9mW3WlqqrOKB9yoTPPekypaj6Qg7atnjcOw3XzMJU0QQwl7MB8vdBcJ2pA8Kb
         nb24ZnoSF9uWygwtBSzXFzPJL+Tu7Soi6iaq2WwclbXLzRVz7P9pzuZkBEPcQu5z9/2E
         zh1UBBIy95EHZRWSQcMEdUQFrRee2gNcT7E1BQBgKWRXDM2ZovgGTS34GcnZ3C207r9P
         fmOGrz8YQfRJTLouZeluYWf4PH+m/tH/SrCxAaL/lwdJ6qFRyqVXgUhfK82wjlpIvRGN
         g2hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740571845; x=1741176645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
        b=IDdoIo6Jw5wA7a19ASCjMQt+6AnJvFZccvvDn5SSGh5aTIMhtqJ4TBDRzEHtpEfJh9
         5ctgSklbj19oMffxepT5D9b25QjZkmu3USMAZCPGe49z8D+0cLBJpvj66PO1W3i24Tmm
         8yh4RMCazdl54hD7HAJ5RJD166oWjesjSc/aAplb2GCxVOxVv24HgvhJnSE/OWku0+PR
         rkfYgTEQYj+f4ZZVHKQku1XlFSa0MXRT2oeStjtsk1DQJHpsccOtrJa03e2ASg5L3WBA
         zGS243f+d/7W0YEG04NmWk7irzhG9uNhccGN7l1oBxKR6cpiCx/bChaP4EcLjcH7tvWE
         /p0A==
X-Forwarded-Encrypted: i=1; AJvYcCU0iO8ggJaib1NreG26mtCL6NWcITmTOrZZTXj7G5csHH644l7EXfWUOqRox9vGOXvjNhISP+8EQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCGL+/ikXTOQwjVxKfbXBljHASUdvRdqzUgqli2G6buIu2+aS4
	ulKjnocQuCp59JpxzlFEe9C772bTuQrOkU0qLqaCgcfMmL36YBPf/WdeKUtMHAgSjALVVLzChEK
	W+wJGLIjTFDB6KRFZUjKlbCrSwA==
X-Gm-Gg: ASbGnctH/0xaL+YJeTbDfrc7HADNbeUudXEorUD9XT9Je0qNEFpI1IIVz7NyCThq38z
	9tmWAUbJV12wzBYwv3Iga4Q76Mtu7Mps0DJ7htgGWYgvct5FBU0iWXm3Kx4p80TEgJ73+/dHggf
	Y8PeCE+aY=
X-Google-Smtp-Source: AGHT+IHS9F8DlHa7K4yiHRckEu2zP4JjVIGRYLXSIkjDC4JMBWupeCSjJPkj7sbydkOYnkvniICQtsy9U0hKiLbYKCw=
X-Received: by 2002:a05:6402:248c:b0:5da:d76:7b2e with SMTP id
 4fb4d7f45d1cf-5e4a0bf28cemr4160664a12.0.1740571845232; Wed, 26 Feb 2025
 04:10:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225154449.422989-1-hch@lst.de> <20250225154449.422989-4-hch@lst.de>
In-Reply-To: <20250225154449.422989-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 26 Feb 2025 17:40:06 +0530
X-Gm-Features: AQ5f1JrUAunE97qcBFzsGJ8UeHsmDYeNRHuc2DNDRpHEkUPXoJiDcNi2r1VbuQI
Message-ID: <CACzX3AtVtC11+DWuxQf97p8hDAJw_f_LxgBDSydfE0enr-KaFA@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_payload
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org, 
	Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"

Tested in-kernel block integrity path and io_uring PI interface path
using fio workloads with this new in-kernel plumbing.

Tested-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
