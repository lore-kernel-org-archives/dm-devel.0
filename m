Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6DB265635
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739303541; cv=none; b=PKsJHx78C3S4RHx6KGSRqdLLIRkwDQJrqKSvyVRGBXL0+gtGmyqjXHwofCp5uK6A9rDKPt46lzJO6sVuGuxzi/WLi8XVXozy+JKp+RUGRXQuLB+iy0uVMdb4ceenINM8V0xzkTTJCaFq9SLudk51gHRCdorFickMPFdw2hej3DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739303541; c=relaxed/simple;
	bh=Ugc0MxLqVPSm1dfvLhUY7mTSGtiLvxZqiM+p3R9Dj8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BhQzVBK3wqw1AsaEM/h8/xrc7LHh4pzPvyPXiQy8heysEa3hNpzNLMop6yhRtvWUQboA4sIMjkY5n4dgcfVZqAC6IeQROenGli9h1e5GcmYucxCfjmf2DljkwpFuCwKwHewZ05IXL/KIj6KUTKGt1pcVs3IqxNSvpCWuMA/5r/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aunZlLYy; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aunZlLYy"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38dcac27bcbso71812f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 11:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739303535; x=1739908335; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=21PovWSQd8pqg0TPKvoFS6Sf76npthKDXlXpmmqq1HQ=;
        b=aunZlLYyP5FbYWtbnmj9SDnWHXMUR9xOhQJc4eqP/U2/hU80OP8+ZGD+aOj2WQHJD9
         W+Jk/DT6A3L2nr5KfAfMrw3AnUKJ1PcFticW1/AhSbDzn/I0g0aPZEZLyyIfn1XaPPqi
         arlnGEVnId8fxf9LUP1ALRfeIAzqh8xIt3Owaux1SnU8QVeoLIez4H9yuEVLK8KJBEYI
         ZRxkLEvD3T4QYUehfhsfH794y5LtCEqSQCi/Li2TGatbDoX0aqXHMHG1DVfb7nIr7V0Z
         RJvRM2snNzL88HlmfLSguu8PlDU0dCHo0++CXLp70U8X/hUc+1gJoXsdWwoaMPG9Sa5e
         a2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739303536; x=1739908336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21PovWSQd8pqg0TPKvoFS6Sf76npthKDXlXpmmqq1HQ=;
        b=YempDNuZrod4rlL3D+D7TiG6qVs2x679tnx4iYQDWhAJz64G+9j0vkzC7Ro5JPq/ZD
         8lu0AQbdA/0LtpLhTFVBtXEKkd+e00JvNb7xQ5W9alYiqrSMJCC+DeR2xKzwZwN7TKOT
         07f4A8FqxaaI4ecFRq/XxmofhlBSoacxWnea8VPjtzsczXsP+5GuT4iP2aXM3kNQwuBB
         qhQwb9cMPVuebjyyWH515ZZLe9CEGH0yKNuavaCxKUoDZLwbWDTcyQSQG3auTlVgAqde
         2a45oJpAXLfzf6BTGGmkkQimzTN5FYIqxODAZGtsR6772dt3cDRvUPiZUc4eaoDbqO/i
         Uaig==
X-Gm-Message-State: AOJu0YyIMylYKcRzF6VEbYKf1mdYVIN3tXkxMneW4dyTKWzfL2SUj9oT
	ZfVfQzGJOdbaGYhgG/3S5jmQyB7NTubnaz7TYRV2ZdgHcG9fUAocHBnY/AhPXQI=
X-Gm-Gg: ASbGnctw2phM3h7RJddnnkZLBMoxDq9yJOF+/2kmyQNjzmQl+hGnJs2cBQ56CfjnvNu
	SEKXItk09UznVdcejRNoYspUHo4rqlRjRYVPsvtaVLuFx8SyIGwzoVTa+L1Pjy9hj8FeJVNo3EV
	5RwFbZeWXRJRCzZC4Whwel4sMBR3Wja3Ysrpehz7kbYwWMdOJTmRedtP8VSstURvr8OcsNVBPCZ
	ibznstPma0YCcl1FtX2gA6w7YGfCuAhXfZAcO2HrFG4KzJm6baQb1rMU7L9yOZNHiIlGCq86BOj
	W7A0wrnN74/LxlrLL7JGfcC6WFDlytwORNSWdkhxpnI=
X-Google-Smtp-Source: AGHT+IEaasE+eaaF0u7zcDUurLdkOOzWf1RmTdvYzm+2IMS3mcvdHC88SnehtBf3iU7l5jKKkcyRJw==
X-Received: by 2002:a5d:5f84:0:b0:385:faf5:ebb8 with SMTP id ffacd0b85a97d-38dea1e071dmr333660f8f.7.1739303535394;
        Tue, 11 Feb 2025 11:52:15 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38dcb88d5e6sm12431859f8f.1.2025.02.11.11.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 11:52:15 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH 0/2] multipath-tools: allow using a regular Unix socket
Date: Tue, 11 Feb 2025 20:52:00 +0100
Message-ID: <20250211195202.116307-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set is an attempt to fix https://github.com/opensvc/multipath-tools/issues/111

Martin Wilck (2):
  multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
  multipath-tools: allow using a regular Unix socket for multipathd

 .gitignore                                    |  1 +
 Makefile.inc                                  | 11 +++++++++-
 README.md                                     |  4 ++++
 libmpathcmd/mpath_cmd.c                       |  5 +++--
 libmpathcmd/mpath_cmd.h                       |  1 -
 libmpathutil/uxsock.c                         | 21 ++++++++++++++++---
 libmultipath/defaults.h                       |  1 -
 multipathd/Makefile                           |  6 +++---
 ...multipathd.socket => multipathd.socket.in} |  2 +-
 9 files changed, 40 insertions(+), 12 deletions(-)
 rename multipathd/{multipathd.socket => multipathd.socket.in} (87%)

-- 
2.48.1

