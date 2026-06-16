Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0F930DECB
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612957; cv=none; b=XshdkRMolnwB6C0h9uL6Db9STy9Lpc1g2DInP/tSVy6OtaAue7TBTYm3mW5ASqUrRagJd+nslUNf64N7w6s1ltjnmZb7xwPMRX1vsxVRa8Rsg7bNjHdbbnlsDMYTsqPzE+VbQZ287m09EthJlDUhve0Po1oaRdNQCVL1CARNbjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612957; c=relaxed/simple;
	bh=JvPIhywkrnpFnvg/d9gciu8LtYX+3Eu5sSW3KO5yxjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DgSFE5ZX2vryo1DyDn/Jx1oKeS/jQgYvqB+hFcMdjIM/2vbleazBAn8ei9HYRU8j5WxXpdjsVj7JiWDUEiKCoJ9TX7m2+z80V8XlpiN+t7lXALG5jDIXJQDws+FNPVIzzKaE3AhgxZlvV/kcw3ZWRIdveUIwX0sSdkcINlLSOxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jo8m0PcA; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jo8m0PcA"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ee224f5fdso388575f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612955; x=1782217755; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=givaA5TOwyh5cq0nMQg1O4xbX73XnH6TeL/MrC8AKkM=;
        b=Jo8m0PcAmwKmGjQmvrQyDeTSBK8mui8SS24tqz36ckkFyLxOR5B+WlDXHhyoqi52bR
         U6998RRzlPSvz4lQLf4nrr0G4xx4IVT2/V4SfVUpU+I+oLiJz815NayqZIruYObfgLic
         xzwRzoGqJhX6P7Wsoyga3cVO/2rqoRCetEmYsTLpk5EUB7UXevgh5nvV2Z33E6aIOdOB
         VfpWFqDMGRwREM6MrI4LZBkg8vVP6ViDHM9iHMTcuhRZ1Mof/UYoDKLQl8I38EkwMPVp
         vwDRllTCc96EKK1jBzf9JCKjPEXxbXyKJTHwYHtjVqCdpUWiPPwa2jqaCqDNj9sEuUAO
         pOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612955; x=1782217755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=givaA5TOwyh5cq0nMQg1O4xbX73XnH6TeL/MrC8AKkM=;
        b=VEX2+sZD2YvGPCb3gf+V5jZ457ttgJm9l9CCZQn7d5jvuLrVDg+LyVkiDk8TYFmyGB
         /rZh0ocIWoz+1CamplavUqPrqSv8zTfTRRyza1C3/QX2dVFhZZ4F1rLjTXtnjdD+RDms
         3PEO8nzfJjDNOd9O+lDVAVbrrxTIM4ufobBY1giHSq27/fBMDaokEp4tx3dTk6YEpCTR
         RqnsrNjMA6wdnz41qj7Nx5EaoKWST44qwAi408YSiVD1vbY/rmNGC7o48du5H07ougyM
         UwN1yJQc/1ETdBCs1xg7DExOFSYbtctArSDUATJkBVd/t5sn7egA2WXppDpHQP1HF0qR
         3CmA==
X-Forwarded-Encrypted: i=1; AFNElJ9+9XXBs+0B745jinisNNsWvi4ORkKPGEufxSaekHGiSWsW3gjGwsisOWtOLejm6x83xqCo9pz/cg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwtgG7AMU7sEh+8smbykRtKh1IZ2116Kvy4JJDcUA1M1LzBJlKN
	TjZfEOaIzdlmLE0niMDbNwidgeXVJ/gkkFnx+8eZSS77/W8dlhVKNYk=
X-Gm-Gg: Acq92OG3QvlFUnJOPQaKE5qEY6nT0VXQ26arGgPr7vrRkvvhhlVXpsy7eICHFjxRD/v
	fv+d70PQHXBqR/GSYjJHVfpjtl1lOBaxsw6owKWf9wzFwYkIODr/fsJPJaoRDMSJyKYqjih5h8i
	tSj4+cCIJnzvBWRljPcls23oiGl7YCmyyQpED9ipumSz7OnfxpgnOFjXntTAx+oHzwrIOZI38rs
	xqybsjX2AcMV3jlSx1jC57Y0mYQhF6pqLoYqmq227bgaRl4EbS0HwdoLU/Naztoc96MNScIgr8l
	MztBESKVkXYiL58li3J20bU+uRbx2sJdfUra3HTnUw1SfyYiTMPHbECKdIiKP3iQFyZr7g6yQEu
	nB7xPc5jOn+JR5TBKLOl0E9mDn/QHXSMtNYhgnA1rC4Zbxw+wxVubWZ24d6tNdyHpywVokgqxU5
	kN5tiGdd6Lh7MFGspP9ohhqWIj4lMFw1IookPCpWF2ePTe/0/kXJgPUUcpjz67oHYu
X-Received: by 2002:a05:6000:29d1:b0:45e:894b:49eb with SMTP id ffacd0b85a97d-4606dbad63emr8054560f8f.7.1781612954484;
        Tue, 16 Jun 2026 05:29:14 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3fcfsm39311840f8f.26.2026.06.16.05.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:13 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 0/8] multipath-tools: clean up man pages
Date: Tue, 16 Jun 2026 14:28:56 +0200
Message-ID: <20260616122909.244619-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It performs general cleanups, updates, and formatting fixes
across the man pages, incorporating feedback from Martin and Ben.

Please let me know if further adjustments are needed.


v2:
   - Merge "clean up man pages" and "clean up man pages II" series into
      one batch (requested by Martin).

   - (5/8) fix typo, s/group/groups (spotted by Martin).

   - (7/8) fix copy-paste typo and delete <n>, changing "\IBmpath<n>\fR"
      to "\fImpath\fR" (spotted by Martin).


Xose Vazquez Perez (8):
  multipath-tools: delete obsolete information from multipath.conf.5
  multipath-tools: remove explicit width from .TP macros in multipath.conf.5
  multipath-tools: remove explicit widths from macros in the remaining man pages
  multipath-tools: remove syntax check comments from man pages
  multipath-tools: clarify path selector descriptions in multipath.conf.5
  multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
  multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
  multipath-tools: fix mandoc errors/warnings in man pages

 kpartx/kpartx.8                               |   4 -
 libmpathpersist/mpath_persistent_reserve_in.3 |   9 +-
 .../mpath_persistent_reserve_out.3            |   9 +-
 mpathpersist/mpathpersist.8.in                |   8 +-
 multipath/multipath.8.in                      |  10 +-
 multipath/multipath.conf.5.in                 | 216 ++++++++----------
 multipathd/multipathc.8                       |   6 +-
 multipathd/multipathd.8.in                    |  14 +-
 8 files changed, 102 insertions(+), 174 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.54.0

