Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749031CD25
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725455853; cv=none; b=YJPDMLICpCuANt5sF9RRfo5oAsXJJGaS1/03yy+ooPWhNb+/vwqgOIAV1JLE9UTdGVQgYlTjMWcuzCbpmXSwXi22Q4QiNPYGexCro8a2lJiuate3zhzg4Be5NKupB/uoDDxVNWM8LF4+q5tk2O1wtgcXmWsNuN+XgihOdBwA/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725455853; c=relaxed/simple;
	bh=bRAtStrpjHf7s8fhqahQ4zdFVQ1e2mbdCQKy3TGj624=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=SNiDmoPV8amC586MLc2O4LU+IOqRE7yOLdxkbvHJXuP7vh+jKmrSFCPqwa5HO7I1AvLo1PsGvFqd8BElcWvMy0PVnFA/634i/yj7FmfIjNSNgUzzCmGeFbJVwm/YvpE4dfgcPZr7a6qqV54u0VAt3WFqfmU9vPaD9bEtuB3cT3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nMFa+6by; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nMFa+6by"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-824ee14f7bfso265573739f.1
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 06:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725455849; x=1726060649; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mz/+r1kYYto6vaE1HN5Lr4ygnqrDF3yK2sRAOefUGM0=;
        b=nMFa+6byqtmcsrHgN2j/L2RGa5heHPS+OyiWoMLHsSHOPlblWw69UE5UWM4qRO934t
         PpqoKWxUc+4dESJX+pACrJzR5arzhaKwF5Lsk0Vvn/6JPnYN4iRgP28tp8W7YmE4cjG+
         X54egj1za+U4CcnnZf7o1gpyj1eMwdj8L3wEamsdCbd5lHOJPu1Tfhf8KwRyUB1AyDvA
         SEiibupLPFrumCsKrJhUGa5mqP7K7JA1MsSy2aEfgsmxvANC0jiefmEuiwi/7M/GLf19
         Zzi9RaL1Al6faVT0uD6jzjOyMYTGH5PS4Gq/MllDAHEt8fudpDx7t4Bx/yqTxPbanR9J
         uaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725455849; x=1726060649;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mz/+r1kYYto6vaE1HN5Lr4ygnqrDF3yK2sRAOefUGM0=;
        b=sNyumgZc8ycCwmsfMVA7l8NJdIv7vo5hCMkwI6h1k+sRrAE79ap/Y8lM5fjdFj5r+v
         ndpvGFrLUqJhMh1mMd+FEKfxPKBz/WL10c8PLb/aG8GM2g4M3wBPLL4htmtAj1yl8cgR
         WSB2JPQI/Qm+C1F6fPP6dUZoxQetz1Pe+rNiPvTVUYRAdu6OP3Dgu4U5B3lYtIO+2MO5
         OnJn1KQnuvTcwVs/ISeLNf6mD7+pp1vF2ZlDp7HdgbIX+0LX2umzTzPEnvldGKvW//aH
         lOysorwC29nJn/2TzvCrscpJOM4kTTktiriL3KuHlbdo0rG1c5HqYOr72VEb/CE2Pwbh
         iN5A==
X-Forwarded-Encrypted: i=1; AJvYcCV8viWN6XtpwfIy9lZ6NMD6fwb1aoO14JhO1jwjjiYmC8ihGLji3n0Ncj8g74cHgKTZqrHK1fi15Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx1udn8X3ngwPInXN/sveEA9GCfb7fO/EDC39UbAHrOWV26MXG
	bjTMCznYUHZXDt3yarSowS8u5F5pdwCxtxNlqpUJ8vjaIv5w/MndEgMGPcgXe6o=
X-Google-Smtp-Source: AGHT+IG1USYy7tqF1IkbtzHH4ZPJtKLMXIpGPGIRPp4DSTusYeKv+BCRJq3Gax192M3qUxFdzSbxgg==
X-Received: by 2002:a05:6602:6b07:b0:82a:23b4:4c90 with SMTP id ca18e2360f4ac-82a23b44d62mr1864522239f.1.1725455849127;
        Wed, 04 Sep 2024 06:17:29 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2dcdf02sm3128987173.26.2024.09.04.06.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 06:17:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jinyoung Choi <j-young.choi@samsung.com>, 
 Christoph Hellwig <hch@lst.de>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
References: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
Subject: Re: [PATCH] bio-integrity: don't restrict the size of integrity
 metadata
Message-Id: <172545584759.61712.16420606261657015873.b4-ty@kernel.dk>
Date: Wed, 04 Sep 2024 07:17:27 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Tue, 03 Sep 2024 21:47:59 +0200, Mikulas Patocka wrote:
> I added dm-integrity inline mode in the 6.11 merge window. I've found out
> that it doesn't work with large bios - the reason is that the function
> bio_integrity_add_page refuses to add more metadata than
> queue_max_hw_sectors(q). This restriction is no longer needed, because
> big bios are split automatically. I'd like to ask you if you could send
> this commit to Linus before 6.11 comes out, so that the bug is fixed
> before the final release.
> 
> [...]

Applied, thanks!

[1/1] bio-integrity: don't restrict the size of integrity metadata
      commit: b858a36fe9a1261dfd097aec855161ad135bed60

Best regards,
-- 
Jens Axboe



