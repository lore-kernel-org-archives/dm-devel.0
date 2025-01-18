Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F86173
	for <dm-devel@lists.linux.dev>; Sat, 18 Jan 2025 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737222827; cv=none; b=H88IO2q/iSJCILWr7yvnOU4qDM3Bf4XPsawnWr7QstsvwBFW5sB6oJYZyoqudfP07vXfogs2OZxQEK9OZQ+KOO4hLasd+3K9zIftIdjkADMN1mgWz4REtyBW9k+Fso9GSVQDDh+xidkVbB8DjcM4HEGnD1q2g5DoA/o1s7VsIFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737222827; c=relaxed/simple;
	bh=VjwY6kBhUMlymrmcc3VyKeggpocpahVjcP4ilAqMDdI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=I5gTmh71QSBsCybYScVREGk5WoXiITT0rtZJCbG/y0HPaFEGvzUDm/6G6ZT/NaymJ8RI5esJR2AN0A0JskcckTRm5gCjP0PcFTSs/XLwtxuJ6EMBFOtNSTilSr/KipVH//NId1aKiRVHZoX5wJ9I3/nron1fF7EjjWeKq1Sv0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkxFz2Li; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkxFz2Li"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e5447fae695so5421975276.2
        for <dm-devel@lists.linux.dev>; Sat, 18 Jan 2025 09:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737222823; x=1737827623; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VjwY6kBhUMlymrmcc3VyKeggpocpahVjcP4ilAqMDdI=;
        b=YkxFz2Li2v/0rt1ODLJXRlbXeTXgxpCnE0F7UeTduQ2S9ajrbLEteTRRZuPZd000pi
         gqplp6F9tW+8UJfBk/cKEC9rhBAr2Sl5dG7qHrnBVp6eMcv8Re850qncxtw4Ec3CNDks
         wnXyUWcnj7e6/TmQEdk8VXGA+udD8Rwkahl+51JSqsd9iiy3s3RcTguJerzr5V7xvpOz
         FYAgAoM5MR1agUekXytOdmrNfbxngkQnABa+uzmvBz2eimNIPVrK8A0zPpjXrs2vKFOB
         ZMxpQd6L+OFg4H7UX3nSZeVlRbn0HVxJ+U0zNf8XbwYtoM2FDHG4aij67RQIkKVrfEAF
         3gGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737222823; x=1737827623;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VjwY6kBhUMlymrmcc3VyKeggpocpahVjcP4ilAqMDdI=;
        b=b2r3UHCPrAPoOnvZ7WTWnEqDLnZj+EnoTFTnc7wmGfZs+c7YY3ygTwNvimUlLiz6qT
         +ohHxdDvH6/AoeIXtC27TUrZr5DEcY5LvXLsxkwOn2Ka7dZILwdhuH1qQo4qKWCXKbrk
         ARMq6WzLdnGN+MUvXj24Wg+CJRYC3zOrDvKgzxUkpCvVhI3xpEfpPSRB2UGiMKfZ4hrj
         NCHQU7qS5MykakXq69vHYWsfpZIl/wCRQm7L2k10W6t22NWhRXs0vJp+Q3CsXPgHN9SQ
         Eted5PiM+HVJ7zsTw/rNRBf4Vb1L+7b121N/cUVeSM8zDfRkqi/bNj8rbkzEZi+bmztQ
         NRDg==
X-Forwarded-Encrypted: i=1; AJvYcCXR27GUQzqiQ01mK4YcKgT4twXAgf1QKNH/JtWGsvNL3K1OhaP8uaNH/B8zdFfZTbwoS8//5FaXlg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxOQ4zwJGYrHkwFRyeV9xOA20tOlVWkCUtrRhPnxHAyEJSH0Skd
	CEMDR4Bvp0GwfyR0TBluYN74XvOOFls+rwV103g56CrTnuwBUuMl1FEC2GZAqZ0gJmWHEpCYUgU
	k/Wu9hrDdQXzauKbre4D/CpC6M7V79CDh
X-Gm-Gg: ASbGnctYr656rTpHE7Sin6XV2tNT8DcuqXVMf6KJQa6Q5L7e5OpciiVF+FpyhDdhlA7
	wpugt7uOkEx6czdidy+kGSpKHKrkHvo8/LH9mI76PKhJVVKnHiA==
X-Google-Smtp-Source: AGHT+IFQ2TpwPYKHmMGXO4ICok0+h8x6OWqp9Ec+kR919zwjBOe2S37639a+LsgL62RTJoE8zASImR9AI9Z7ZTAQTHk=
X-Received: by 2002:a05:6902:228d:b0:e30:cc34:af1a with SMTP id
 3f1490d57ef6-e57b131a476mr5295526276.35.1737222823533; Sat, 18 Jan 2025
 09:53:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Sat, 18 Jan 2025 19:53:31 +0200
X-Gm-Features: AbW1kvbgH_WO6MWhxrqNEGtf_ZBIhPFEPh9jIYreqIBuv7-lmg--oDVuqCN92CM
Message-ID: <CAAiJnjoGn4Jn6O-SWAaAzwNk4DhEiCFUA0Q0X2RLdrHH7NR5qg@mail.gmail.com>
Subject: Adding zstd to VDO
To: msakai@redhat.com, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

What if zstd can be added to VDO as a compression algorithm along with lz4 ?

It could provide more flexibility for users - faster compression or
better compression ratio.

Anton
