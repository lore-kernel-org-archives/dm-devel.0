Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4521991B4
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 13:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935100; cv=none; b=kV12zbzhpW02cw4eqZLXkxa0SHGhK7hHBQnY4g2O7MmvL8WlcTGkmDlCJt/gTavUM0HjoDx4xgEJDuKCrr3qM7QR65F/zqnAZdLhF5VwajTpFj9G3p8H1NYqKk4f6pHwMxmymxQKAdEE3w2nxd+F97CgF/tFSQLnKZw9fAeNuvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935100; c=relaxed/simple;
	bh=i40VDCtcn+B7yNQU014uB5avrlfq5hWUM7jqXTl8nRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgDDlAPOGs6MA5rGIrS/Z+YmlTGuPwdCP5njzKQ3M4dYuFjH6pXDioirsfKffcGRz4oNCnmPMyWdERtJ1M63nmf3ktO5K+LoUHRgzZyF/30I11/tZL7Oa6qHDIDvHC81n2QVcdhVob1wsMu5hqzPXJT2eatdWBCfi4QhWW/FfCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GNMTdHoR; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GNMTdHoR"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431548bd1b4so16546005e9.3
        for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 05:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731935096; x=1732539896; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aLrZZSSbj5HpfR/fXgc8MTixrtuVe3UCpVT27WbiJyc=;
        b=GNMTdHoR2Z3BN2TDlZYUzzqo3nUS53Htd7jzfVlPKh+tEdEZGVNw4PnXAidFgN9XtJ
         4fSpZqVR2lCSPEaXyzuXEjJiYDuAcQNkuZ4knuJyRGURE62UjDgwIqcgNd9i+nT+FuTB
         q5lpAzfaTtSls8BlKBnR9ma5NdQksnNnw1Mr0H3Y+1reQkbhtHYYbxU0EBp9Mu4RuuLF
         GQ3x8eOn+5pvvUHU7NO7keGvRqFw/22hcnCB3SWarwsiacpLS8oApqVvM1OlXaIkiAwX
         nSRLAjyaW7p69arKUgMMqSiFJlllcS2ayQtLt0SAOEM18PeIhRSiqRDEu4ZEgaQStHSc
         QdBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731935096; x=1732539896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aLrZZSSbj5HpfR/fXgc8MTixrtuVe3UCpVT27WbiJyc=;
        b=hursp28U/gjBC8jH0DmO+/F/PqzeK0ULzVADqkHN8ImdJyfCwZ1VPOUM9z1ZkFk8fj
         0ydr6AzZpIkdIy8sskydLeHH/KAFaiputnv2j8wogxh12xydCsIFYCNndKu1R7AJjw+V
         Vhx0qxQfIGFWt5jnSAFYayds6+BX7Hjk5WHVg14ZiAK/AMXtLF4kq5fEyn+CUV2jLfHt
         gP3o+cdP9bFNRQuzeLElU/8qCpdS9G69Kt/tbU2xt7yrtoTXMWsMUp3SGPpMpgrs+2Qu
         TCo/n4OfQ+aX6vrfOSfSTUJ9pyrqd3ohPho0kBAkATMFsNWrQBdfXcYDEdtXU4MNjyzI
         8bUA==
X-Gm-Message-State: AOJu0YznLqzfk9s+vI1ScWi+uKXpI1P8UcFqEPYstx6YYSHS60fWWDYm
	1wt9d5wtQpz4XOnaV3EVrT7ARVWa15M2E9hjusRkLhQesuriEvYJwPxi52gHPXw=
X-Google-Smtp-Source: AGHT+IFLvzA0+rzR/WR2lqtxNll1F6/ie0KBF7RDMVcsVBFdzllDgX0HbT2iwNZEqC7wpc5rvrXl6g==
X-Received: by 2002:a05:600c:a16:b0:431:5ba1:a513 with SMTP id 5b1f17b1804b1-432df72a5a6mr118625585e9.10.1731935096084;
        Mon, 18 Nov 2024 05:04:56 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432dab72141sm154714975e9.1.2024.11.18.05.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 05:04:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/1] multipath-tools: fixes for systemd watchdog
Date: Mon, 18 Nov 2024 14:04:46 +0100
Message-ID: <20241118130447.554773-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After Ben Marzinski's feedback to v1 of this series, reworked the
watchdog logic completely, and moved it in to multipathd.
The watchdog interval is now independent of the checker interval.
systemd's watchdog enablement logic is correctly followed, and
better fallbacks are used in case of unreasonable settings in the
unit file.

Martin Wilck (1):
  multipathd: move systemd watchdog handling into daemon

 libmultipath/config.c | 25 ----------------
 libmultipath/config.h |  1 -
 multipathd/main.c     | 67 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 53 insertions(+), 40 deletions(-)

-- 
2.47.0

