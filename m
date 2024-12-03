Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28C91F12FF
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 13:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233336; cv=none; b=goEm5ucCuKVRmdeQIzfkABWRSkP99iKuKCRzUb+bSgRIo+iCgiU8Cts8DVol3jSuwLHXJ+kQAt/1EtEGOmrzD+EZ0ngAPTaZr6Tp/eRIw14nQQipV4i2y/qZnXJ9VY+tfWVhoaGAIFS6sg09i3zfINngFXVblC97Kj9AOrq0R20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233336; c=relaxed/simple;
	bh=BPqo/+vJ9OA99wMkdAF6vWPVOkXo/UQOziFQPIlW/1E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P9NsK3qzrJ/I6iqvSdjcmc0NXHRWouELVBq3vCfgWEzYGnBi7pIWl63QvfIxXDlFxfVdanWDSlXr/Y2ooE+vAJg7OUG6n90ZtoH22es0CD6td2jtPrEtbbzT3rpQR7V03rLuZLOZ1tDMNe/m3UO71yF9Hf/tZqtNjqz/O3wm4ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w9Ja1XYu; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w9Ja1XYu"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5f1d1068451so1906765eaf.1
        for <dm-devel@lists.linux.dev>; Tue, 03 Dec 2024 05:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733233333; x=1733838133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=w9Ja1XYuNiYfaXB8uRMXrHnDFr1QPMuLzRtJMz7xt4yuSmEjyw4Zq6ImU/hvo168tt
         KlzVNA20Xg5lXc46u53+lunSFTACeF+96mfTOi5bNnrXqZhpxBOyTtCZR1cIXQoPExW0
         b+/Aj9H/XcPotYhhMi66j+790/70qm4trtNf1SozoAa0gp42JSVSeNOMEsHyl3s7posE
         B8ogjkxSbrR+AlE73c9G0qPzFGJvnudZ5jUHinMlNwbIdo9agTsDo+EL/S7U3ZUUggqb
         bjaaGBzt+reP6HumwqzxD33seFM0KIaW3yEpVTBiJuiFS2a2hRjcetMgZKo2uutlk8cO
         mgAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233333; x=1733838133;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPziSiz6FIPz1llFZL4/mtv70ocOZmo18hfdyDsh/VQ=;
        b=pARznDmt8tQ0NVn0/xEi9IY5gC7OMYUIyc8q4PIilYf1/ewfbR2rMa1JM7lcTucoFg
         VQwmvv+pURM+xOhsOIaX9S+20cASQ5CuIQrhheLoUyBoev1cZ9LOLYapYGFWhw1i90x6
         ht4i5E2aTz1vNza/du9bmEeLfVS/dvwxM1YR5lPD0r+yDr2QxFZQpd61Ly24O4TrtdCr
         lKU/hFAqdlHXUd12i6wmkX68HJ6gHex6P639REsfyTSXaQM9lwkO5XgL3lcoWojr6JCo
         BW4aN/jPRNbjkIXxZFc+BmIoBPl1jGtJpqT0QZ9E6GQU3XlDwtLrKxBvQm+qATXE+2/F
         dQjA==
X-Forwarded-Encrypted: i=1; AJvYcCVqq6a9UNzPYpdoFeYxbLAONqNJUofxc/Ybo459Gc4jv/uOQYMikoMqYZEuqCo3viydu619uVKgWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzlYciCTp4gdu+Y4VVHabvOymKu6e/Zl62v+oaQJ45J1MqX/G9n
	nRNSv7w75U/azmZiWGSueFj9UBLBbgN4ZnT6lO05SF8iwPCGfrAmtF4YDqsm8Rn9gLO/EiZjfdK
	l
X-Gm-Gg: ASbGncsXXIkUcrwYtAr5afFDWaYXOYV15PGN/mQsRa6gVb/03Bi0NaS2fgrHSXgnrz9
	l9yrZl5TWzOArsvgSDS2Ni9StAaH3r6UJjsO0jtXZdee5KbVjH8T6YbfNkufLXyg9xJ6g9SbpIj
	YCNpDLAgGEKiCoN09iJvs2yv75VRuTT6Oc4kpB6HuIMMtcqwKLD2sGijvhVRaoiDMCvypWdir9s
	/dfu065VO5ANhhEXFEmj+rqQjorHZTy+thx+EPhjLqHsA==
X-Google-Smtp-Source: AGHT+IF3JxViCcZr46UetkoBs9MyylLeqwOA8mylprKsogFh27HKGMF5642pWucfOY8iKk1uqQ4f1w==
X-Received: by 2002:a05:6820:50c:b0:5ee:d89f:1d2c with SMTP id 006d021491bc7-5f25ad40e71mr1942008eaf.1.1733233333038;
        Tue, 03 Dec 2024 05:42:13 -0800 (PST)
Received: from [127.0.0.1] ([130.250.255.163])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f21a4cd86bsm2782124eaf.29.2024.12.03.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 05:42:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: John Garry <john.g.garry@oracle.com>
Cc: haris.iqbal@ionos.com, jinpu.wang@ionos.com, colyli@suse.de, 
 kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org, 
 mpatocka@redhat.com, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de
In-Reply-To: <20241202111957.2311683-1-john.g.garry@oracle.com>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
Subject: Re: [PATCH 0/2] block: Delete bio_set_prio() and bio_prio()
Message-Id: <173323333147.59116.15700360793401292347.b4-ty@kernel.dk>
Date: Tue, 03 Dec 2024 06:42:11 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 02 Dec 2024 11:19:55 +0000, John Garry wrote:
> Macros bio_set_prio() and bio_prio() do nothing special in terms of
> setting and getting the bio io prio member, so just delete them.
> 
> Prior to commit 43b62ce3ff0a, they would actually encode and decode the
> prio in the now-deleted bi_rw member.
> 
> John Garry (2):
>   block: Delete bio_prio()
>   block: Delete bio_set_prio()
> 
> [...]

Applied, thanks!

[1/2] block: Delete bio_prio()
      commit: 099d214fc7abc3fec0f38d10bec31ac7acce8d13
[2/2] block: Delete bio_set_prio()
      commit: 77cfdf838d8467d3ca44058caff7c1727080efb2

Best regards,
-- 
Jens Axboe



