Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A140877
	for <dm-devel@lists.linux.dev>; Sun,  7 Apr 2024 21:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712526658; cv=none; b=G5O4K9RCFnv/A4L9bQt6Y4VoAjny+P/8iHyHh5CeEjcIdNkYt9IdltHrEpVTX6ktKOb9Sy7kIVn7QCB8HOvVa5XF4uI8rDLp0j8nNA51UclzDM0zb+KCcD7B0Cgpi/LJZTIT1fEQQHtgyn7UA9vTeXSDJLE/vzyuz800KB5mY40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712526658; c=relaxed/simple;
	bh=q9bB34yrTrN7+26ZiIknUHb6xnKLyvfXa80njLwq+dY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UC/6KUOZzepK1RpDILAeF4oZcQDojvaGeNrIiiE6WL/EXM5k+/7sGiKxxAQzn0/R6WEgl3x4QBoa78VqFdqI/jU/Q/bUcUo12tVHwuS82NBBhGUVyP/+RNW+BSaeLsp6Eaxb2ovWktxTJVGtXiqjBEUp+lU9syKarwFS8ixW1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XY9DsBd4; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XY9DsBd4"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7c86e6f649aso37023439f.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Apr 2024 14:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712526656; x=1713131456; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFhGDEXqIbtR+UAjGGiVYjOWq205kUX/iLnpNybBY6E=;
        b=XY9DsBd4YrPNHBJHZqQ0OdhsQl9z042x+4mOGnlEL4maPghCsJTO7iaIxModDK9EKo
         itz6ePXD4MjMfPsPo6cqj0s/Fdj9PNmceSEQusPuf2n5fM/txuOBrIG6hsRc1UCeTCmf
         FltMoOKiykpZ0C8F1CR2MIeDFioH59MkL2z7oSi7mzIGhhaaUjGxMZsh5qU7jfD/k+Pf
         dDBYAAWmu/tgfYPVH6ePkeRLbQ0wltdD1iSvWV9S4/23WFr8fqaMOjM2H8dk8iTc6Fi5
         ys9J0nGuV9WhYXOpmvA2HXYz4EvIgoTIKWyuHmVl4t8ZS/vmLY3gm/eeLFlcdYuKlh1r
         ng2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712526656; x=1713131456;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IFhGDEXqIbtR+UAjGGiVYjOWq205kUX/iLnpNybBY6E=;
        b=gemxK1OSinAgKs7tdBq4DowDjMrV66sKmN49a8jD3Zjht1jr2dsY9jwarB9HBJ19Ke
         RYx7desEdf3XSBmMJrG2vxUBbUjbaOFxB/WkmEBa2JDERf7Xg9H1WU95T+V7leo9hVnf
         0oq3Vb0SApSLvV+OmallkzNZzn94IfG7BWH0LLu6w+Fyd4nvjUVhv4Hs/IlXxXDcKaCM
         2ALpNh3xH4d4YisZnJUY+MN4G+TgT1EThKnFsz2AOwIayfAW/Fcg1UXR073KpiXZVlQn
         aDfyuuGSy86FPxXJUiOiqLlDXreDnIGWh963nZuDzPGoVFsXQD4GUfkSlEsSs9HCN920
         t11g==
X-Forwarded-Encrypted: i=1; AJvYcCWGz4GZOc5LmtgFxqqw7ByHFQtgRxWO2h4IheJOkv07dUP0Q0ajM4rDKiFbVCqglDoH99kf/PsiflcvEUKxdc0v/d1U4+8Zkjo=
X-Gm-Message-State: AOJu0YzHsqHj1+/le3IoPNuxx29tS0Vt0t0y7iaxpn/hee1seXYQfC9c
	C+691yGgVBCReqwaIADN28DIySkGCYP1OnizOzIFRpWWwgMdQ418IKPhdFT/3N0=
X-Google-Smtp-Source: AGHT+IGeQLkiyNOEpEcA0eZIatdoZcDvnlZBaLWFYUJxiaD4EhRF1lLJaYaGiFa9TdaHA1ylA8nh+g==
X-Received: by 2002:a05:6602:1644:b0:7d5:cc9e:9d96 with SMTP id y4-20020a056602164400b007d5cc9e9d96mr4771043iow.1.1712526656251;
        Sun, 07 Apr 2024 14:50:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a05660213c800b007d5d40a4910sm993714iov.5.2024.04.07.14.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 14:50:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>, 
 Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
In-Reply-To: <20240407131931.4055231-1-ming.lei@redhat.com>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask
 and max segment size
Message-Id: <171252665540.2536278.16554247338004438050.b4-ty@kernel.dk>
Date: Sun, 07 Apr 2024 15:50:55 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Sun, 07 Apr 2024 21:19:31 +0800, Ming Lei wrote:
> When one stacking device is over one device with virt_boundary_mask and
> another one with max segment size, the stacking device have both limits
> set. This way is allowed before d690cb8ae14b ("block: add an API to
> atomically update queue limits").
> 
> Relax the limit so that we won't break such kind of stacking setting.
> 
> [...]

Applied, thanks!

[1/1] block: allow device to have both virt_boundary_mask and max segment size
      commit: b561ea56a26415bf44ce8ca6a8e625c7c390f1ea

Best regards,
-- 
Jens Axboe



