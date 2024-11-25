Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D029518E37D
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545159; cv=none; b=SskXj+DGCU6ehpXI9m2I0vKcFeYFLRTMWe9jwFcm0fzQ+D1DHGBgD55mLREqpKQgIiBXsrD56hfCjflg7h1Et61ifsZtTdCDSLNhH2c326hD4QuqaL9DSLId/TqWd5zBBIoG7VnutpYS2fWAjszYb3j54urAQzbfIVrwJkdyojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545159; c=relaxed/simple;
	bh=/IXnZBc1vfc0Tbt5r1B4gVAet7HOD0p40iqv2xyKUDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o4eT48h4egwRASmPEziPrW2TXrZkP98U/BHEVlQxRFRY8b+QLmzwN9x9ItGKp4sh6SWUaD8RAYgR6nCU+87+Xk4juOWbj+9ilnaQZmBWnluBaAjC7Y/xyXR9zHQEkY0fZTLgq6pECYgOWeXz0601NLA0nVluhHgvxVcZGG0/ioI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=chaNHfOk; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="chaNHfOk"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aa520699becso442472466b.1
        for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732545156; x=1733149956; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o4+3Ev8toaN3dW5HMu13OoSsV8j8CCY5WLczamKnOCE=;
        b=chaNHfOkCOlQWxjxY59FsmYRm6LDmXnGOG/9rNFVvH8HPw5CAKNYD4aWt6LRljToNZ
         sddMRBnc5Bny/C3HnXH20poLPgoM5Ham4+WiEW2DNPaa4q7wdL9KJKUqIi8GHUT3hywt
         nFA3LD5DG8T2qScA9fDFFXBR/tMfDOTKsPb0iWxGernwF1Xx3hFrsQVFi4/9NKiUf9fP
         OcVkKEgxbxS7+bAhp21YUrYbrRKOsFz70xX6/LrbuM+0bS7JqH9J13h0sYgtLrIajbP3
         DlKeBYAod6PRHlHbtM5o25VkN7H7XBreM7pWptvWhK7OixBwtX8R3aLaGKN+AAzCaRVA
         6I8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545156; x=1733149956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4+3Ev8toaN3dW5HMu13OoSsV8j8CCY5WLczamKnOCE=;
        b=KrvFzBeRGxBJZInXkTwVyFFcHJsMDztDsIYyX0ZK0he7LV8Ff1tuKoxBMeG4eC0zBj
         BVkKA8wIKiKjFUuE1YsH1SIDF8IBTbuxlPpwgNLTG6AFjwNjaocj0oJiUobzt0sSJXGu
         KofL2cDgP2OM5yHG3+lvMeUtBL2EEx+G/xzMC0vMnh9k6As+NLUDWOQX0YH7A8HeEDNi
         wLRfhGcC3l4d9j1aP1jOxpTEY65S1WfNPrwKQedvjDRqj5HbWRdtTw9NTHCdm9fUSJXv
         QrLnwJgZwDO3FT0TT28oeI6nG5F8Xny0gSyqhYH2Keh+1UY/5gkkkwp+AkLxj3mWa9l1
         CTdg==
X-Gm-Message-State: AOJu0YxOsixDVGKChcMIAunVtNgwUPnBxAU9bxtfX54F+IjJp2zS/imu
	imZlZL+pKfahRD+fxMUIjV7mjqQmTuSaU3/jYUkCkvemROT6OThcvKEOQ2hr2Xk=
X-Gm-Gg: ASbGncsWxIXdrDWUcMnT+7jLCVTSbBfDUSNboNvbKB5x8/q+ZVqTDAdn4/2SF5LNVxn
	YhT0VB0FZ7f0v3PV5ZrCTqEW2I46ZbqgYFHCz3DISYvgPyYo5Xriw5BvD3uD2mOoylHHltrVpz3
	CvAlRFMmXX0ZqUdpt9i9gcfbS1XUMKiKc/p0ha9xGHdzyAgIX99SK8hwenMqxszdTJ1dd8NFZjR
	PgsEPnDqH3YfKRlqlKgfJZEGGB11nWl8f3Y/GbNPvth/O8+ouay1PBKOA5oif3FxZnZeeieB577
	ctPfT8zq2BdZBk1KgZhWjpWcXcF5ta3iGt5g
X-Google-Smtp-Source: AGHT+IHS3LzuuArIBjG7lGLBA65jStEzI231j8w0ZXaJUHViM27i7cRKi2+zkk/bTtrMQyqmv7jCSw==
X-Received: by 2002:a17:906:3cb2:b0:aa5:11be:5703 with SMTP id a640c23a62f3a-aa511be598emr842633966b.35.1732545155701;
        Mon, 25 Nov 2024 06:32:35 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa50b28fd44sm475967166b.26.2024.11.25.06.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:32:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] multipath-tools fixes
Date: Mon, 25 Nov 2024 15:32:21 +0100
Message-ID: <20241125143224.51934-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch is an attempt to fix
https://github.com/opensvc/multipath-tools/issues/105.
The second fixes an issue that occured to me while working on the first one.
The third is a minor cleanup.

Martin Wilck (3):
  libmultipath: fix handling of pp->pgindex
  libmultipath: pgcmp(): compare number of paths
  libmultipath: move pathcmp() to configure.c

 libmultipath/configure.c   | 20 ++++++++++++++++++++
 libmultipath/pgpolicies.c  |  6 ++++++
 libmultipath/structs.c     | 31 +++++++++++--------------------
 libmultipath/structs.h     |  1 -
 libmultipath/structs_vec.c |  8 ++++++++
 5 files changed, 45 insertions(+), 21 deletions(-)

-- 
2.47.0

