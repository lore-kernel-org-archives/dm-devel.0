Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04EA334683
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098410; cv=none; b=NoGdC+IbDVUsGd/OBQUvPURZeG2YVSjYmDBKiHPNztA3XPNdAF4bOG1NsDKJipQ1hjgUy5tHg6sfvBx4cqsn5GxvdezIn2TtjJeYpsXWSp3Tb3yuKsYr4vykWn0wo6vFXX8UcjNX8ICdnY/aNGnvvYzHlJNwPRW2sb0ax4zysHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098410; c=relaxed/simple;
	bh=weoF253YS0RDYDNFjzSDJ5tIChF4WqxAAq+yZqEKh9c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TEOPIJS/3vXRhwjrfoEtXSZR4KmI+P/fYVm99EQtNsfOC9GO0R4Ymuy0Mf7xe+48zoKAy5sjY15uirAUgqWwTibyZmS/X0aCHtHm8ZwHVyL7f4BgCOhSUJ9A1Ogs1tegj3ojNJzFjFisRvvfrXPhYuO6uGfup1tjZuVv35ulV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NNomLfmS; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NNomLfmS"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-948c58fe8c2so232406039f.1
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 11:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764098406; x=1764703206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=NNomLfmSHuzfFEn5ydgbWddq5pdpsSyCbHaSwsYx88XuJYFCvPzTghmvbjfdiLkZ3g
         fj++igJxXwv41aAOO7wIzqo39WT4G1pGKRnEvMp2aVrTq1dG/0lxeZBNppkCYjSgthid
         nLCkAVDr+jkzMa0Xd7cjgxSa8JKmjcdkXRFMgj+wcWRPHS4PkLEcvm5tuQZIc07S9p9x
         LKa09oTqpFxZY1nTGZk+Xk5Yxt7m1ewgHTYQzTBLDDiZNrCI29KX4iG99GBhvh8ZcVy2
         vxQGigIPPX7XkVxL16ZLfmaOuc2n2dx7jbGw1m5w1QarYVwodf+magc2hw2jXrCfad6u
         FyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098406; x=1764703206;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=tsFtJGUTqzOcP/mcKthZNGW9JDiaPllahJPn3yAQWPy8Lezqp/Tqohq8aUVQsaHee7
         sP1qEvuuAjOEn3LHsA3UeXCvwkylM+O8jp9Pk6v/ijaRoml6V4INn815GtxlMBOwWk1F
         ty5Acr33nOnZiekoy3GBsVoHqyJ0bJGKv+M+VUj19XHiI6ICE868ME3NYct+vZgeoXeF
         svQvImEOs3BGequRJg81mz2NYDwa1tUZW3OU8gZQ2eHl9U2dehOtAwbM02oEtGrEAbF7
         EgEmBntIsxMW+zN3FRVXDtopjtg3MV1xZWxfDk6W9F8ytCjTL6uYyXrFXlYBCYc4yweQ
         QN5g==
X-Forwarded-Encrypted: i=1; AJvYcCX0R7FONl9jyC4gBPPqdGBPJ9dBd76fuBLDI19GODfW828JjAajiDg+08X51Ikk/SAsBnUyDw4PJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwNCgwmzo+DrNvXx2NOpbbiJrwKXGog3kqJ76U7FDGjjO8rwU2X
	y9b0FNXslCsfYIQxLrZnmZzVih2/kk76/Yfo67Ky6oK1J1CpPwWUc4ow6s//Wac0RG5j+OIVQrB
	u+wB3xHo=
X-Gm-Gg: ASbGncvnZhXyAEZuLHQ+KTNe23kATNkGn/WB7681Pk5F6zovEwDmHM94PsbrcrN87ME
	Pbe2DDNcLQnqw8m8Y9KCVwBdKxZU8n2Xw6zHI34xbebX7cQhqwdvIfEM8z4xAeBrfQzjFFeE/Yz
	UcESwLQqiXwj8nRG7xesGM9xyi9BambqfLm0VIH9LDD6VhnPPvU9Jd8S5zQumaMhd+vyN/i/pp7
	Aj8bmmwS7CGqm1mQUaLfyWZHYEI76CiG15B0Y3olWYXFG+vKzSaSafDZCbbqSDFMKPCZC+PTKPN
	3chGihjYiHgHqd6dk8qwDq3on29uIARp+rZqEH6byCfEQzPpOH83pGoZY04cUKxHvcv0UywApj4
	qean+K+A4ZHzJ5aSeq4OQiJXh7ybrx2DnHVPa4IxrXpeWDh0NSMGz9yTONWdgKor28eaCLrFgke
	4MoA==
X-Google-Smtp-Source: AGHT+IEoSNUPWsr6TkiMj1VyTgtSM+H2mYKN8PQqct0sy21hTM0OQb7u5ZARk6n0QLi/CE7kBBB/xg==
X-Received: by 2002:a05:6602:690d:b0:948:a32b:b6c4 with SMTP id ca18e2360f4ac-949473eb047mr1023076839f.3.1764098406436;
        Tue, 25 Nov 2025 11:20:06 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-949385c2405sm668551239f.6.2025.11.25.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:20:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
 kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Subject: Re: (subset) [PATCH V3 0/6] block: ignore __blkdev_issue_discard()
 ret value
Message-Id: <176409840493.40095.8097031483064544929.b4-ty@kernel.dk>
Date: Tue, 25 Nov 2025 12:20:04 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 24 Nov 2025 15:48:00 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() only returns value 0, that makes post call
> error checking code dead. This patch series revmoes this dead code at
> all the call sites and adjust the callers.
> 
> Please note that it doesn't change the return type of the function from
> int to void in this series, it will be done once this series gets merged
> smoothly.
> 
> [...]

Applied, thanks!

[1/6] block: ignore discard return value
      (no commit info)

Best regards,
-- 
Jens Axboe



