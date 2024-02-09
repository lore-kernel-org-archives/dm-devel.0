Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6E374D2
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 13:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707483973; cv=none; b=ZEGReuDSaRe60b1xhT4BbJJ5ASpLnlhFp7LcNoKu/McKPr19HoJBLJzpJOKjR7F11VzcAHiCtZr+CuTBDqy8XZDS8cg8W8vcFMwuT1WHZ3LHJg5vsBGKXSvkAX/WIrnWeJrMxGBCe1Yp2BJ79zy6orGL/gVTaWgl4Lb7JXL8WDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707483973; c=relaxed/simple;
	bh=D1I9C82K27EKrdSDWRrP1udXuSzgZmJRqnn1NoTF8yI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ieVJBu2RPvPVvd4QOwDCEP8wrWCNhzhuNdfgQaNDVOy/YJINcUwnS1jgffKf4WEeNwk6Y/tuHbLxjobguMu1AWhIfRjkdkZy1rx4MBC/y+V4Xx/uCfUquyfpR2MDz3IvKXU/sWcJ2h5C7d9YoUB6ShGT//6ksZUly+2cNAVdgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hMKtqv7F; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hMKtqv7F"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a39e31e1aa9so113462766b.0
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 05:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707483969; x=1708088769; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tLtEo1OKqwUWvTBgCakfkTG09kqUPK7D3C3/KQylNEw=;
        b=hMKtqv7FJZhshaBv8neC8Fl8iLO2pwewGebe2y3oMoekBHwoIfi3agXTu8M77BhYcw
         zh7NriwGrbxGDCt+n0ZRMFmPK5og96dILwwDOJLoy6SGM0pFb8XLTZx138v+bpsW1zbv
         IEuBDeQm21tCifIzfV9KwzR6gEdgQH3GKzB76hUgE/rMEGxiun+BWsU5WY01T7G3sS4I
         Nj+ApNDXYjIeqSI0Sv72hYqApLoIEgUt8zIpfEgUAfz/1Yoos9kFnhuFC0B080dKtOWX
         dYHUIfg0dpycTc+J9rNAPfETM8tF/lalZlHaBzRbY19r4u/M1EVy3HtG4ujrvD87oAY+
         2f/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707483969; x=1708088769;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tLtEo1OKqwUWvTBgCakfkTG09kqUPK7D3C3/KQylNEw=;
        b=EewtIhcPwOT99i6tL9JemsPymRxBJsDOnL37ZhYVfe4e765Podr0GtEyGN9e5ciVfn
         tetPMbNW5FtLEmurplkNZz+1n0/Kinlu3lrw1lNY/DaeGZqDBJABUeSlxRuvx3gyigkM
         68cbGZZBPyfsjBYLQ2lSPbqLsZ+DrADFEwz8fXbHVBfPfESWy7v14aQVDTjoeLqgnU2e
         SFT96KUidwZ/nqE2L8nu7JQT0g6QCEkohrO+CCKz0pfC2Mu132wXlAlOP825EIE8BzDO
         4F3+reZLHyrWr/6vaA1/DfmLJrzAvL6NddYf98X+o3BJVQrqoG58OEOCpVjJtVm/xqRS
         xTFw==
X-Gm-Message-State: AOJu0YxZbpqX94mJWH69IbUKq1i8XuFU8ueYRQmZX/aNiZjRtjGYU9Mo
	8w/h+elU2+zfmNQJopepT0G4VF7nqR0Bp961Ifqv+HeCN+gJS7h1xfywvpYzEYLC9zalg47CLV9
	e
X-Google-Smtp-Source: AGHT+IEN5edzSFeEvjz3iI2J36XXz45v/QQzi6sVUlIxDFtjifYo68zTTErxjbxGObFqhdBgYmlXBQ==
X-Received: by 2002:a17:906:b354:b0:a3c:e45:4f3d with SMTP id cd20-20020a170906b35400b00a3c0e454f3dmr45052ejb.30.1707483969465;
        Fri, 09 Feb 2024 05:06:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVmo+XQH+yrKac0XvIJqSlYVt9IIw1L+e7oFiTQgBGyl2mgIawunfVwRGwmw6/ipGW0YVjrQCPOK7+Tk0byAhSayncFaCNXgt5IAzyXNEcJTShLznj/7Hrl5mQWbVOXxtJXdokNuaY+5Z2k1CVZJ7B7V3WOAzm1GFKUWi82vm1arx/ksFuOz1Q=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id st11-20020a170907c08b00b00a3843b13729sm743753ejc.35.2024.02.09.05.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 05:06:09 -0800 (PST)
Date: Fri, 9 Feb 2024 16:06:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] dm vdo slab-depot: delete unnecessary check
Message-ID: <16ffd614-48a9-42b8-961d-2dc8a69c48d6@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This is a duplicate check so it can't be true.  Delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/md/dm-vdo/slab-depot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 42126bd60242..2f4a2ae5e082 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -4100,9 +4100,6 @@ static int allocate_components(struct slab_depot *depot,
 		};
 	}
 
-	if (result != VDO_SUCCESS)
-		return result;
-
 	slab_count = vdo_compute_slab_count(depot->first_block, depot->last_block,
 					    depot->slab_size_shift);
 	if (thread_config->physical_zone_count > slab_count) {
-- 
2.43.0

