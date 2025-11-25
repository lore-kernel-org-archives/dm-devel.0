Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8522F12C1
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 23:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113618; cv=none; b=uE+LYGH4uuMKJ1umXUAmgEGO7czabhrvs56u0KveRFrK1qu+u5CSIUZzU6XxyoPvryUZmMzk4HLDbf9OMItZ3yJhoeENSkJipvuoLoxkxsF5hFyMDTR12RBIvXrCGOfisHS1V8kxzVU6niJyQB55QsxiTrr5eqnTMQ0BXrT+GbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113618; c=relaxed/simple;
	bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aWPqc4kc3b0VXKcfF/gyx58B6V+21dSWd+wQ+C9wfWtSA70kDwLqBxqscCSDO9xLmn+XugWbW4XujR131iWQUYp6zexaFUi1D2rbvfomozzXAK5bhTctbDtLe2IkX6xtvF5mDBq3Ka1HiTMtolsz0M0/PS9h+byWJ7ZMmJLIgz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5cctdu9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5cctdu9"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3438231df5fso7943890a91.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 15:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764113616; x=1764718416; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=g5cctdu9h00N1VuR7nG1fAW2PmM/K4Od6LGBe5aQl7rPJuGzlqKMPNJjWlU4BOfgSb
         8wC9RlkDMCRynhhiS7JKoBgytrEIhs/ALwAcU2erb/9r7Afggq2V8Mf+cYeR0ItLGsxU
         eL0juYuQngEsexYjb4gIU479aiX4I1SsLx9up2twMhBLQTBMDHlhjozeSUVUjokMcTZI
         J0KaTBgZV0LMkj8lTRiMh3DcB3FNw9Bu56n0aFiqQSVlsCEG5fnLMUl71jiUSdXZD0Mm
         mTMMQwi4NUhtHuaAyoxssFCwHNglveTaXvtwH/6EEDpCyLO2h/vB3HCVlUo/HVUAuYBk
         qHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113616; x=1764718416;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=AntnRnFzf+pgW/ZIaplvvR32YV+tC4z7cWZDF8K1lpe8n3L16bnYouKp7YwUHSIjdO
         uiIKTKsDQZLz+NXeGpfCDMl+XPZVF0Mw3ahGRAPTIcPGv1uBa9eNtnW5VvxmPjXDDydX
         6OWBiAGWYtx0C7woer980Quq91quRcEaJpUJIrxgehS6+xyeiEvOKfJDrt/tlDBkyHwK
         1WJYi9DfKDLufDvCW7AA09aXPubXl2uKBABEhkYiZGjd1G4mFM2RLJr+NreRkXqdos1B
         TmftZsEmqIQP/E3fACWuu+Q6Fc/z2r35to0YcQ3oEPN9Hgm99kbZDUnByEStBG5FQxEv
         fdiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc07KEDl9LZkd9vYFdGHkTojsJb9upEKRtlm3wVm9Rr6SRm1Zd95bCkNXo9V1cTE+YwdVZ9WNsMg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzdHMJVX1iOUyIW/qrZDgbMsdPD+lA6Ump5N3debfYYd/HGrN/n
	eA/zsfIEQPxAm+zg91vmLCVsjSgiHXOQHlyuMI6eDitJRiC7/xXpMc4L
X-Gm-Gg: ASbGncu4IgGP1StBehmeZJikoP9PrZbbOjK8dtZka8CSZjO2PFKuAce6N6vBc+9QmgH
	sxs8XbDCUGdV1+PQH3RG4aODFQwBSOND/sIRv0cibavMOs7ukFLv7QrHVgUg3GMvrgw0KoN4NVS
	VwhHZnQectCXNYbdi6SujIPR/eMFZ50WpQZwFtK0NXYS95JxojEvwI9sUQrAGlD1VvZq5Bi1lAa
	jDv8Ur31vXXDAj+4WXOySKGepQc59fcEaTNCft+861S7KhyF5Yhxo2PtD5pElY595mPp7EXWn0h
	W9uydagCTabI5OJd2FnF/MiJHFHofRSRbMVddV/fIfmpYUTrY8RCX9Ic1gg+UuLkoYvp6EqXEaU
	NqNjByFK7eEr/xh8hbgjgw6W8HkyuF/aFbh7XRfbcwjE+ovVmzeagWa2UAw6fYOG99X1vVFjd3d
	h5yF4pOsA+19XGGrwyzBNdifoaxuU=
X-Google-Smtp-Source: AGHT+IGN2yQvKPDnQSI+rfi8GFgwmIi2Dp/WjRDvh8wa+7M3RBmYm0POoYwrQhejduq1ue9sQHFv6Q==
X-Received: by 2002:a17:90b:3a4e:b0:33f:ebc2:645 with SMTP id 98e67ed59e1d1-3475ed448a0mr4374100a91.20.1764113616140;
        Tue, 25 Nov 2025 15:33:36 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475ff0eae4sm1654152a91.4.2025.11.25.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:33:35 -0800 (PST)
Message-ID: <2146e663be965ee0d7ef446c7c716d1c77a8a416.camel@gmail.com>
Subject: Re: [PATCH V2 1/5] block: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:33:26 +1000
In-Reply-To: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
