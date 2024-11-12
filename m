Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9220265A
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423756; cv=none; b=RzpjvfnJRKCmILyLwOdtFfKfOmvOzNmFrXTZW2RUqEWOAm7Tzz3bZFhI3zpQghEbK25BU4hG9h6hQJdlWSEsBi7vlJ7YdXhlvoZBTCk3banjPY3K7WEefsFzfBpFE+ZeEycaaG0SMcqbZJdl4buDm9EJw49VF4p179T4Ynve448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423756; c=relaxed/simple;
	bh=005X/SThRKH6QGzw3PAnCnE28leEUC3SPyZ05by4WDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JWYK1ZDkx0YKvjHBwUjP7hjl/aAMh5v7yCrDie7BKOQsHFA0tpmf0fo9N5zXya9Lad0d3gwdBeisRZsMIVyTXJ/BxvEtl4isGsWaSbmttS0HAx8J8Acvhl58G7cP/LxzM44TQDXTp5a2BcvK7dKLl70xKcZsTseY26tbmAFvR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MN5kOh2J; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MN5kOh2J"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d5689eea8so3404832f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423752; x=1732028552; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hm8pRoNPj/hVl7vCUgzLSff0J59ZJrVAsyQc568xEz8=;
        b=MN5kOh2Jcr5lvDCcrTm9w66TiEoxFjiBmsJ4SZx/WBFT4CoUERcGQYYkIRaDEthITa
         89dLw6goJocbxMes6spKb14iRfHYSDnmQPVNF8Hb/ImUyZ4yvBK3TUHMBaXZjeDJptOH
         5fvkZES+Y75fL8NVzOEkk4V8NMPbnXy8o7LqmZWBcU3aWjtI51ThmxDpOh6XZ1en4zRv
         0veVlVxa0OgTek//WUDITa5md0VA0hHTVSPmQUuwp+lffL2VsWg6srarZyT+65kd+O4/
         29Q852W77Vi8tDVhuGoaTipgViCdvWF0/TKKYh5M4A91usQC1Fuhf1GalbvlHZDD/8mv
         CD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423752; x=1732028552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hm8pRoNPj/hVl7vCUgzLSff0J59ZJrVAsyQc568xEz8=;
        b=vYNhTEcPzDoolzrWrp60h0g3+8Y4I50Px51heDrZPuxrXA8IwwpP+Tixbdd2WzSyOr
         78LQ/acN4FMi+lNmd6N3ZObaUk0InA+s+AINWhlgiX5AKIuF1EFIJ5xKp3jOQVCNHFYY
         4Bd/tMZCGrkjmD51A1T3d7AvczZchMdeIka0DR6Emsjb8G5Edu3R2TOA0S3IIHhclleE
         l2aps3p93gQl8XA4kUXcCE/AQ+d8AdblVXYoG82ndHwOsKPRZ1NqbAG/yF+hG/DwvZqz
         IbhHY0ezjr+IgaljYwNGFKkUee42/7WCIA3vu0GksWGzkScgshLN+PK6y//9AngRzr7T
         GFZA==
X-Gm-Message-State: AOJu0Yxv3Gm6uU2HxHc0WDeUpJXd4dcsSxRfuBCNFz/rEj0GT0mLLUpF
	FRYYwkKf9jyaBm4CrBdvE9Mc76W4fblF3HFBhIn673CaU0QKkWg56E6B77mY8CM=
X-Google-Smtp-Source: AGHT+IHovUjIvB/SFoGnaMp+A8/M0jxdtYeKERwIFx/EpTQiLoPHDbo5glDSbCA6d9buU4JKhrySCA==
X-Received: by 2002:a5d:6c69:0:b0:37d:387c:7092 with SMTP id ffacd0b85a97d-381f186537fmr14020786f8f.7.1731423751434;
        Tue, 12 Nov 2024 07:02:31 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed9ea5e4sm15968387f8f.77.2024.11.12.07.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:31 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/12] multipath fixes to tableless device handling
Date: Tue, 12 Nov 2024 16:02:03 +0100
Message-ID: <20241112150215.90182-1-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set is a re-spin of Ben's previous series by the same name [1].

Patch 1 is my take on fixing the regression with map detection
in multipath-tools 0.10.0. The basic idea is to never fail in dm_get_maps(),
even if libmp_mapinfo() fails on one or more maps. The behavior wrt "empty"
maps, or maps without table, is the same as in 0.9.9 and older, these
maps are simply ignored by multipathd.

Patch 2 improves the semantics for decting maps with multiple targets.

Patch 3-6 are from Ben's original series, with unit test fixes added in
patch 3.

Patch 7 and 8 improve the semantics of MAPINFO_CHECK_UUID for partitions.

Patch 9-11 are minor logging improvements.

Patch 12 is an independent bug fix I discovered recently.

As usual, comments and reviews welcome.

Martin

[1] https://lore.kernel.org/dm-devel/20241031183301.391416-1-bmarzins@redhat.com/

Benjamin Marzinski (4):
  libmultipath: check DM UUID earlier in libmp_mapinfo__
  libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
  multipathd: print an error when failing to connect to multipathd
  multipathd.service: restart multipathd on failure

Martin Wilck (8):
  libmultipath: dm_get_maps(): don't bail out for single-map failures
  libmultipath: libmp_mapinfo(): return DMP_NO_MATCH for multi-target
    maps
  libmultipath: make MAPINFO_CHECK_UUID work with partitions
  libmultipath: check map UUID in do_foreach_partmaps
  libmultipath: increase log level for removing partitions
  libmultipath: reduce log level of libmp_mapinfo() messages
  libmultipath: don't log boring state messages at level 3
  libmultipath: don't set dev_loss_tmo to 0 for NO_PATH_RETRY_FAIL

 libmultipath/devmapper.c         | 70 ++++++++++++++++----------------
 libmultipath/devmapper.h         |  8 +++-
 libmultipath/discovery.c         | 13 ++++--
 libmultipath/structs.h           |  1 +
 multipathd/multipathd.service.in |  3 ++
 multipathd/uxclnt.c              |  4 +-
 tests/mapinfo.c                  | 17 +++++---
 7 files changed, 71 insertions(+), 45 deletions(-)

-- 
2.47.0

