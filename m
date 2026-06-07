Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9125D32B11A
	for <dm-devel@lists.linux.dev>; Sun,  7 Jun 2026 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828850; cv=none; b=GOebxn2k5TgQcahoZGj6754ut0r9rO/1qo2mByk+JjGOpohxXN7ywEHHdnzKpOE3Kr1gmAGdY7F8f5e74L4awVsq1YYy827z9aQabshueNTZEpP+BtOWeuF/UUoOM4NUVhxydemc2HHQ3yJ+dudjyHUv+B+cQd7ZcmooR8SKCtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828850; c=relaxed/simple;
	bh=NVEXmJLTqCM/mjlR5vTvthbtqnw4LcbnrCfeC6B80w0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L2/BvEL8WI6avSNPOLi5WNEn1nv5hOqHgfexZNe/9ta3dXdKN4npxOwQzIlakn4tqw4ecZHP4CIcPuiWCbw65/3jlMMWaqXsfL09YLOubcYhIhKdjouLmxeLYUoSlyp0xxClFXmFDIAUgGBGNX1Qx0WFFz/BoIN3VsnHdAp/fAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r16DVd3K; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r16DVd3K"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490c28f84fdso4313155e9.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Jun 2026 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780828846; x=1781433646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5vtmSLGL/Z36/DvdZ2EgZ5rWAV9fl4VFoW9MVdwb0Ic=;
        b=r16DVd3Kda1ZhgleySooCvnXsw9A58lctF3VVpZ/H90ijTjtOQHUm1cVDPbkHjpVHj
         M2xGY6AkaEfBg5R5U7Z0NovG0PCDECE4pUvKaRGjnH8F6/ocDWdBaHhejuh4FRWyh16R
         bk0dLAMdoh62i3h3AnjGBj65zEI0fgiSpvg7bobEkioru8i6U7tcmSA7DTlKwwMWS7FY
         h3suqOxefZHWJjRWKRk9vbfCJ8gkwbwps4P3wLQttTwsox3O5tqoEAlF8VKtRE/eYTQI
         P3XSCAHuic8eeGaoA49dIyZfvsLY1IivKz7OhgX3dO2FW+Eov2jt26myc25iJJIkfi7n
         LkJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780828846; x=1781433646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5vtmSLGL/Z36/DvdZ2EgZ5rWAV9fl4VFoW9MVdwb0Ic=;
        b=BP2siwXMlyeapo77Cy4vyLpahhDh4hzB50HPGL9C1fca+oUbcwzopp5ro79JeGr/Lc
         IYk/jeDxYI3xrkyvmiEf+OtVr0/bbDxW5qoqxhFWa2u8p7oJMVOlmYV0ZlVLza7411mk
         aoiVILdx7S/m+aHl4HVPzelsifpQ8Vz2AKq6CStOz/2+ratMDh4oWD4kjHFH2/q7GgKL
         ACWDyqFYw1VfUyHIemwFHUkCl/Y9G3Zr0w2HeJAT+diCBABsSRhm3sdaTgujunl5V5ZQ
         b1n7DtcEUaV6mxHuneBqfWqwfAiN4Y/pxMXY3SJ+qpG16XEbdLJ8bYvmp1vj/pXKjzrf
         BhUg==
X-Forwarded-Encrypted: i=1; AFNElJ8VwBAUaA148FhAQuEGekAIfvgZq8Vfkz6LfIQG1qOJcO9gCmCz2aEXULc53P1IgMCUmvWFNyn02g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzTA8KBLUThLtlvnKmaCD2myKw9MJmD+4f5FSerGgTGcSEEU/PC
	Fpg/4CYTY7GkgAueeIZwom4wTkvrssbSNytc9mgqdwWK0sstO5Na9Js=
X-Gm-Gg: Acq92OHo7MPgni2CT+slCVEXTLZ61iv0KeaVqPqHXu7s2eNjjhGTQpU3EzuuzTNg6+l
	dq7lm3+l25jmtgM5r56pJTZTS6NGivZiTbwJJgjbYZ4OJKvMoxU7iM2FuYFNsc6cx+dqnp3hoVX
	jEj9EuMEoqCA5XMDXFNXTYZ0DsPqU4D0gbWLF1fGWD/FBZUT7aipOh4yjzxxZpdHOPwIZ1tXtI/
	33iaQspNwmDGAd1iuCnDF3aTYF3f/DBMQf/sSgcrIfB83lyt94qIRkNlpHOXThyTqtchYu2m6Sd
	J7DkCnwiXdvOx9Ifs2JZjjLW0VH8JWgDpYzd735sByXz84WVsL8jmywzpjZQu+ft3ZYl8WFKb9f
	v0fnmFIZdEJRSOQBdQTyKsUWFrvG6Mk4sUYo3d/f2nMSZWTMLQCyKsK/ChVlVEg4Y1+HbG2shks
	VvBgcoEohItUaRQD5GzNpz1Fur45CtMxAl0pteZ5RuwDRTBDyyjrTWE1u1OaqeH5pIKTWyf5I=
X-Received: by 2002:adf:f685:0:b0:451:51d6:5e24 with SMTP id ffacd0b85a97d-4603061c70amr5173231f8f.6.1780828845718;
        Sun, 07 Jun 2026 03:40:45 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344541sm39654603f8f.22.2026.06.07.03.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 03:40:45 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 0/3] multipath-tools: clean up man pages
Date: Sun,  7 Jun 2026 12:40:43 +0200
Message-ID: <20260607104044.337236-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Xose Vazquez Perez (3):
  multipath-tools: delete obsolete information from multipath.conf.5
  multipath-tools: remove explicit width from .TP macros in multipath.conf.5
  multipath-tools: remove explicit widths from macros in the remaining man pages

 libmpathpersist/mpath_persistent_reserve_in.3 |   4 +-
 .../mpath_persistent_reserve_out.3            |   4 +-
 mpathpersist/mpathpersist.8.in                |   2 +-
 multipath/multipath.8.in                      |   6 +-
 multipath/multipath.conf.5.in                 | 135 +++++-------------
 multipathd/multipathd.8.in                    |   9 +-
 6 files changed, 51 insertions(+), 109 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.54.0

