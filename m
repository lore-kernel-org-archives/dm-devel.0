Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3C62EAE5
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595358; cv=none; b=QcOL9D7Oqhiw9oQobN/nfeUQRDaBCke0ydnSjN92K/oiHEr7jYWZvPa/6NzqhKrTRNkRD1k1nAw3rVcAKzr1jQt04yfKmpLLFLxS78VWxrJikRzlZ3v8PadJNbgZjgZsKHPKDiLq7xgV9Te4fWXTRA2naBohF4sPsrrsOtRy7YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595358; c=relaxed/simple;
	bh=YjXAZ08kUphChUBYGnvT4LTL6iLpGtgX5huCIRry76s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l39A8aZmx3+I6rb0a2exF+K72sbvB2iqDeriwdJwACXS6LeO3aSILd1Luv9sEDCOAgI0U4oJP/Y+Jgfai0oRUBPqmEoayZb/9BYXk7IbG1fVY1kVJgiG4AvRQl/xexr4T35ZkMRJd3mc4OT/wrBjQkTmQXE7WFU31f2jTmTAAVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E1HcPlqz; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E1HcPlqz"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43169902057so6262925e9.0
        for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 06:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731595355; x=1732200155; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wp7wFc//RMkAG1NGqbZAn7i6vbByR+YGl2WBJCfAsX8=;
        b=E1HcPlqzK+I1pjDclinzxZQW0sb/xHnAAHt+YC4WaVsXx67mG8rkRbEHf2963+9y78
         +8vP4Dy5JeGqClqoYz9mWNVZh/E9sagY8VHlZaH/OdO6lxSD59uHb4hUby3Fh/cajwlu
         WSGDw2mPngk4ikF2TcELZ2Bq9BZIIm2ghGQdj0GNXAX4lLTeQfABVPcXV/CTN/LagcoY
         5Q+fOYngK1x011ggyofzNCD/t8aSZ4NbcVv1Mp1IqItIwQDlrzFDA9qVo5NBZ/xDqFhn
         kTWqWYEsn1Ehu+daqgDsMsJ8K9lkkP9mwM5hCRY2rWaFKA9H4qE63Og6UQv3YpJOdAWe
         Zi2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731595355; x=1732200155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wp7wFc//RMkAG1NGqbZAn7i6vbByR+YGl2WBJCfAsX8=;
        b=vKZIDDOUXyjjsW4LpMAaJPZv5spTdEaPsox4NajdiBr/nZpw/HfPOzmCfebesE3d6a
         6v8ZLSyMklswxBBj1SIIwgzrIVEFeEz/uTrElFxTPbmbxlrr+2hpU9ZSJq1jUYGSDg/9
         KKVJmUIb1E/8xxz6l+hAJZLFR9f8tzcgjScXe0BbHkDV3/9qlmJmJgpi4hfYjs2JbClL
         YPry8ekk/WRobQkbRnC5n6+y4GcRL66uaqUFH3viulJ0C19EVedeMjWmlSQOGGpzaq6D
         lalTtVSytXlfvs/0X3H3ZpNUdNSY9pKCTCRHwK3mdDAGX2KG5hhKQeRVD5kA8vghCydF
         OO7w==
X-Forwarded-Encrypted: i=1; AJvYcCXw6m7RwQtFyjMsOMJVy7Oh2baRXmQDqOfNn040H0IZ6K441wdIICIMn+M6AIRH69XcRgin+r2jqA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyGTjMD5TPb/Zde33bFYx1//+aw+N1rMObYSticA8ev1BY2qfq2
	gtiKRqwJBpwzbK/+bV87lD3DrqpDZqE176ze/hGIqNlan2IWGSfCP8lwwJVFkjA=
X-Google-Smtp-Source: AGHT+IGP7zjy1uhW4P/JBc0nG19NqVU4SAVRb0vqbZO4Yj45QZtd50MgLgwRZYdJ5sU6daJOBaWDQg==
X-Received: by 2002:a05:600c:4451:b0:431:5632:4497 with SMTP id 5b1f17b1804b1-432cd4748f8mr86674615e9.26.1731595354490;
        Thu, 14 Nov 2024 06:42:34 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432dab78783sm22763635e9.12.2024.11.14.06.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 06:42:34 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/3] multipath-tools: fixes for systemd watchdog
Date: Thu, 14 Nov 2024 15:42:21 +0100
Message-ID: <20241114144224.248606-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A set of small fixes to make multipathd better adhere to the conventions
for systemd's WatchdogSec= setting.

Martin Wilck (3):
  libmultipath: don't print error message if WATCHDOG_USEC is 0
  libmultipath: honor WATCHDOG_PID setting
  libmultipath: cut watchdog interval in half

 libmultipath/config.c             | 21 ++++++++++++++++++---
 libmultipath/config.h             |  2 ++
 libmultipath/libmultipath.version |  1 +
 3 files changed, 21 insertions(+), 3 deletions(-)

-- 
2.47.0

