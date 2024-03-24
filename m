Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD62D53F
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314798; cv=none; b=icMvMMFCA5RtPZsDtqUnhIVEt7veUFHuxo13lLCbBiTWH9nJN/FW4p83qXt9cGu0ySn59ycVJM3nl3k1oi9ZuCeTbDAb6/lNgacRydjdSkoJdi+g7XBzxOqYTrcpFiEMUBW8D3euhQSL5YF7LfYsqUSgpm7Pyf+2OzCnF/SfnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314798; c=relaxed/simple;
	bh=Jpp/nNaaXF8Uyw6qKtyfAJ1djeBx8XF3SemDFGydHgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YtNmhR5JqahT9VEWfHUf39PE/qIJZiiYG+HnSLAgix+U2VZxwZkvOTkWohpbPb3poaA7fLUQ3WCyQQuvhJIOq9vblJbkc3nQauGhFZvdYIbZUmqFob3+H0teRrAHXL4+gmMEejUUrdv2hZYWnneKpLigz3xk+ummxP0NKTLmPHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AwXpQKiY; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AwXpQKiY"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56890b533aaso4400622a12.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314794; x=1711919594; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b4cHYx5sSThIpoJ/WEBPm1QAvFKmx8KK6A25MgnZTKE=;
        b=AwXpQKiYkr5Pa7tcoTJsaAuynRw5coKrwcgzlE4EDcjhdAN1NxXjpIMtutd8Faf2cr
         vKl5WcJUN0BysRiYSzK5nCwucf33Wkt3Vn8LoTuU2zKoYNFvC+Uz++fDpUXQiJPZRo/J
         fRMatmAAocAjfV5sWBKUaLcwidJVHfzectzJGp/a/wHQjCrlO70CurCWjJy0MtIkWq2u
         QwZNt56dBHxzEYd5RUfZlePtm5bOHQpoxBqKC4B6EXKkZq5e1gIYfoAvBL/dlkyeRgt0
         FBJlXvvTvoBa5dvXmmAh4VOHY0zL9utXonI658ikuNdyur4lWg+H/jiozfy+okB4ziOR
         dr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314794; x=1711919594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4cHYx5sSThIpoJ/WEBPm1QAvFKmx8KK6A25MgnZTKE=;
        b=sOsk1Zp1jjf6isW5B1KS668IH7rkvReDzqCFSznOZLmkKkDZk7TJmZmBe1gP2IhO2G
         GVs1UPn+a96gVBERn/H+DQ5l7qa5ButqwvFl77ewRKjNQ9KqagwiQVxkIIaCqjlHwsbM
         BmXdFiLX7IGfyAQjOvWb1et52ceH/4uGl3MwqtFN6cYL9xYPAIBbIgqc23s+g276Cn2a
         BiagrqB1BHOtAOOgspCO+kTlx6hfKs9zX/CC0x3w9QT4mG9kogLWqhfYQqxTBD+SC91Z
         U0Ypy7l2aEuGNfH/wEZXmzSyjECZoxmlgOOudj63HRjeYbW8/w6CfjqJy4SDmvmyo9wU
         7PNQ==
X-Gm-Message-State: AOJu0YwCWvI89Fg+TFT4ec6Awur+vDLT56haEhQ46iTQfblXbYtYqC6t
	z8v6UceUmpoazxuambmi0pZM/qYuHToIOLGyolnuSWseyrXSUJo9vrHgF9QUvMI=
X-Google-Smtp-Source: AGHT+IGLdJOSX/A6hVE6LkgMHLEDYydOP4IZWGfN0XnShkHzFyDkqocX1F9Gr7juNZKBumKH4QXYDw==
X-Received: by 2002:a50:9ecc:0:b0:566:ab45:e6c5 with SMTP id a70-20020a509ecc000000b00566ab45e6c5mr3600643edf.28.1711314794431;
        Sun, 24 Mar 2024 14:13:14 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id b23-20020a056402139700b0056c0d96e099sm462192edv.89.2024.03.24.14.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:14 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/11] multipath udev rules changes for dm rules V3
Date: Sun, 24 Mar 2024 22:12:50 +0100
Message-ID: <20240324211301.7200-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adapts the multipath rules to the pending changes
for device mapper rules that update DM_UDEV_RULES_VSN to 3, and
applies some additional clean-ups to the rules files.

Comments welcome.

Martin Wilck (11):
  11-dm-mpath.rules: don't set MPATH_DEVICE_READY=0 for suspended
    devices
  11-dm-mpath.rules: don't import DM_NOSCAN from udev db
  11-dm-mpath.rules: don't import ID_FS_VERSION from udev db
  11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0 logic to 10-dm.rules
    update
  11-dm-mpath.rules: adapt coldplug event handling ro 10-dm.rules update
  11-dm-mpath.rules: don't import properties with new 13-dm-disk.rules
  11-dm-mpath.rules: replace DM_SUSPENDED by .DM_SUSPENDED
  11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
  11-dm-mpath.rules: simplify PATH_FAILED case
  11-dm-mpath.rules: make label names more intuitive
  kpartx.rules: ignore DM_SUSPENDED

 kpartx/kpartx.rules            |  2 +-
 multipath/11-dm-mpath.rules.in | 84 ++++++++++++++++++++--------------
 2 files changed, 50 insertions(+), 36 deletions(-)

-- 
2.43.2

