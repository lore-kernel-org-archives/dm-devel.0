Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9A3E493
	for <dm-devel@lists.linux.dev>; Sat, 24 Feb 2024 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708790759; cv=none; b=fqCEjYkz/kz/LAq2RgqOaba5z/k8sMfL3tLdyZRPNMWx2wm4qsZYhXvsUnfjrLzT5SHuVFOTSkD8ArvrJ6zdHWjXFgQZas9aa00AWrwoVK4Lt+UCeO+VIv7uiYvOCZhJEFwQsO7PA5Ijz97g/co6oNC18Ac8dC8nqnsKs8vCYlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708790759; c=relaxed/simple;
	bh=E59Ge2iof5touRWs6VPVO6mhrKT3Lkb/h6XiZDAiOCo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rpKd2dlr3JrRptSfh58CBhrbUwB00McUnWfu2ak/Co+720h/o7ngMYTUd8hsIPUlnHXbBzlQ6bxBgvlnvI2ReNiC+Fc2u9G+kCxeCdpt7co9eEb93uyjcV/t90+l+Qews5eFXbuTz4o1zHViUJI4IZXfIsIL25XGpaX8qFqobQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7872614af89so98131285a.0
        for <dm-devel@lists.linux.dev>; Sat, 24 Feb 2024 08:05:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708790756; x=1709395556;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1xgfDfdFhOROV3arv9/Dp8sUl3kpSHJJYA7cwc0URRY=;
        b=u4HxfWYzPTSPl4n7EwckAfpt+CWgPW3gJzW7+Y/kj+L0DEaDnNeNO+pDFvLuygdiil
         bsiNn+xVFeOajtsdVdG7AKHQpAu/GOW1iroyNn7MAJyc9RvWk04QTv7WtOHv1CBITnSe
         WdT7LfEQ4xg42cIQfCgjD2JAu59DwDy0pRq4KG6b+0c/aBE0bO6LR3Pcpc21E8v/Vrfc
         ny88oy6CIsRIYCmNvHOug22Mx/t19iHobLLbjE6DR0UOGkpGFcjZAWsPhchtBKVGnbxr
         Dd8hieHNWOpBYBXRp8ouXZpwjydiXs5uByjq7NtIardacD2ewKvr7fR6ojAe4OrKagCj
         LA2w==
X-Gm-Message-State: AOJu0YwiJz3jNhrrr5y7KRZmd3TA0MjiM9ldrj0m/cDRrl2/83odPvV1
	G/ZU4FvIwLAA/x5qVYJmv27ex3BoxTaQFWVfzVmxb6p8XfO70C3V1n/WTZyPfQ==
X-Google-Smtp-Source: AGHT+IFlY3V9dD4ZOCgndCWM7fAJphAAD9qoawkqEXjWLsdnhS2+O0oxz9RzLRekhSvnxdcKqsxjqQ==
X-Received: by 2002:a05:620a:2086:b0:787:b5c2:6aa8 with SMTP id e6-20020a05620a208600b00787b5c26aa8mr4069839qka.30.1708790756453;
        Sat, 24 Feb 2024 08:05:56 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id c20-20020a37e114000000b007872affb7d9sm709203qkm.45.2024.02.24.08.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 08:05:55 -0800 (PST)
Date: Sat, 24 Feb 2024 11:05:54 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [git pull] device mapper fix for 6.8-rc6
Message-ID: <ZdoT4rC0f5MkY6NQ@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

A fix for changes from yesterday's DM pull request.

The following changes since commit 0e0c50e85a364bb7f1c52c84affe7f9e88c57da7:

  dm-crypt, dm-integrity, dm-verity: bump target version (2024-02-20 13:35:47 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fix-3

for you to fetch changes up to 66ad2fbcdbeab0edfd40c5d94f32f053b98c2320:

  dm-integrity, dm-verity: reduce stack usage for recheck (2024-02-24 10:53:57 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix DM integrity and verity targets to not use excessive stack when
  they recheck in the error path.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmXaEswACgkQxSPxCi2d
A1oT2Qf/c1opgjRUe+yY/v7nWf4paufSj2O4LYAy/qQBU7IS9CcXQPzi/pKlfEo8
60OZfa5gfrCAla79se7hHI/mxReq7CI5nFvYDyqQ1JZQ/djG/4cN/oWf5fQ12pon
/ET1IzaZ+Mom+5wDBeQBLoQwXTA1ru5Bi1OiUe9Ed3wzadZQQks5s65fPnc0emGJ
ClyaXiiCt4Dy36E5GmuPpmPB4ZJ57SwcnFWDFIeCHEbIQk36APkZ22z7lqGObjw2
ANO1l59k6ojzmaXLi9pw/J/o/qyfNR0MpeI7SpmtJzhSZKeGKsUX2GlJ9QBhViJp
XL/+7MbSRJ43IY1lomoHZm1vxe0aPg==
=sQPX
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Arnd Bergmann (1):
      dm-integrity, dm-verity: reduce stack usage for recheck

 drivers/md/dm-integrity.c     | 10 ++++------
 drivers/md/dm-verity-target.c |  4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)
