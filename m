Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A763268FE9
	for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 22:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312493; cv=none; b=lk8xuMl7PjczqSjgnD+UZrJKkMbWNWkOR8IBPa1q2ky66T4TQ1Q7xmfj9S3/qIkiYDIcI6Y/u1bPRR6PQkUOEeG+oL9RzwfyoSTubah9D/oVi9s+e897CQsCl6dY2/3S/oFc50/SWGgICSAjr5hDO3CgWesosxJm+s/HKcgNQkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312493; c=relaxed/simple;
	bh=ZRAmAVifhH8uOBwmaTebpweMs/YVTi6DikR5Z8LUfYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZslQ+2EzoLdBSRtfoSRNKHGSJ+CLCyfja1NsV3QNnS/Srarm6nCrHm0PrwTJ3VEJ09dSFCQwF2H1PmSmBw9yZ9WTh24pNpA7rPMjqKE4pKs5+9LTgCHVaapc/xgLiKeDv1BDrE+28jUlfmMgfaitn763uTqOODmg9FfZ/X8SnVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dd9+a7yI; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dd9+a7yI"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4395560cc13so10930025e9.3
        for <dm-devel@lists.linux.dev>; Tue, 11 Feb 2025 14:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739312489; x=1739917289; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PTCEsHbrExsrcbVTLcTp5+FwkYkBgkdJUPvpbGVHURk=;
        b=dd9+a7yI629E0oKkwRuWr/RcOYxsnggycx7dq5Q1HMlGUVslRskoU/CVy2q4feMfCr
         cSoTHJIMBOV9VIMr7OtxIiYNw9CtP/qOriz5SglTyQZoGnpug6VVKERR0UuH2XXtK0RX
         8zjz5/H/k2LzKjZVoaqiLKux+xLW1ukFvgRrfTxzD1Rvvjd4zE5YgllJBAm5F5i54jUz
         KF5DqdrITbTjygLiTPqpnr7CDPzCtr9UmGukwxkXF7sUON5t6QxUHFybolP5+bbub24+
         5H9GbdjnG+2Rf4nf7zSmbWpwFk8RA0zJVioGXmJKhvGW4IJXj0xz5uvDsio+bMKQPGVH
         X/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739312489; x=1739917289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTCEsHbrExsrcbVTLcTp5+FwkYkBgkdJUPvpbGVHURk=;
        b=dieG0PJCcmLX/RvXhdV9P8mTpu2VNLNkJ1vSHSwVS1bK8PeHasBVJr5rHVhfd7Ow4m
         bBuJe4+ySijHvHHrgYVDB79WIU3V5PyCX6IxirPkMYfwCyhy0DE6Z5Cv7BQIlMtzChMK
         zLGgPGayRLioKE2ptBhx5s3VQvN4fWaq4f0y4xOt90FLvGxjPvHBRQRCQDN8zSSVz54T
         uFa1TIB2Ufu0O6kN3CApAQALa1jKpZU3u2Hl2tRzhaUYNTI7+OvT6CG4C/0DgDuGOwCE
         BI9sqwuMh8GPM/GH9iUUFifzU5OyO+txfAu4+eNSgbcqI7YycWkdkMSzgKDhYpm04Epc
         LkNw==
X-Gm-Message-State: AOJu0Yx0iNOnk5FeISnD5uGUQqtfgEJfwnu1thLW1+k4bLrp7m+fRhx9
	srVGHYBWYgjB2mOO6k5uZ+puU3a6SYayYtRMwwd52wAeD87HuECdVZHCtEu5xWY=
X-Gm-Gg: ASbGncu8BSGiUPj/U2SG94HhIMqoQjrg6BerXucCi90K4PiG2iOqetZna9j0L7jNtT9
	p2GDK4VaWGAEZvYXMsY0USxzPZdbkhgeMRm4WFBPIZyXVpE3BdbnskF04fq8Z3WHIbngvZNahpA
	Iabaf/iwrBzOLi35rj863ZkhKeRcfL3qUZygiIUiIMnIosjmo6YpxU6SoGaL1Ut1YSr8oqfQTmb
	RcVdiXw9U9hiskEQ4i7Q1SPSYdaXB08C1lNrkUGJa3FgtapR64akXsERL+IPZvcfrOlYRQlesJw
	75G+4mCoyr6wL5j5L6j2na7oBc58Hj+05GVGt6/3v2Q=
X-Google-Smtp-Source: AGHT+IGu2kDH1X3sky6cdDQPv3KlRw25xYKSQlLKR50sHNmJWGuEcwUs/ryQm310f3iJswUicg953w==
X-Received: by 2002:a05:6000:1546:b0:38d:cb6b:d5b with SMTP id ffacd0b85a97d-38dea2f99dbmr548057f8f.46.1739312489134;
        Tue, 11 Feb 2025 14:21:29 -0800 (PST)
Received: from localhost (p5ddd307c.dip0.t-ipconnect.de. [93.221.48.124])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38dd6080926sm9723318f8f.83.2025.02.11.14.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 14:21:28 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	afrosi@redhat.com
Subject: [PATCH v2 0/2] multipath-tools: allow using a regular Unix socket
Date: Tue, 11 Feb 2025 23:21:24 +0100
Message-ID: <20250211222126.182370-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set is an attempt to fix https://github.com/opensvc/multipath-tools/issues/111

Changes v1 -> v2:

- Introduced the mpath_fill_sockaddr() helper to cleanup struct sockaddr_un handling,
in response to comments from Ben Marzinski on GitHub.
- Fixed double remove of multipathd.socket during "make clean" (Ben).

Martin Wilck (2):
  multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
  multipath-tools: allow using a regular Unix socket for multipathd

 .gitignore                                    |  1 +
 Makefile.inc                                  | 11 +++++++-
 README.md                                     |  4 +++
 libmpathcmd/libmpathcmd.version               |  5 ++++
 libmpathcmd/mpath_cmd.c                       | 27 +++++++++++++------
 libmpathcmd/mpath_cmd.h                       |  7 ++++-
 libmpathutil/uxsock.c                         | 24 ++++++++++-------
 libmultipath/defaults.h                       |  1 -
 multipathd/Makefile                           |  7 +++--
 ...multipathd.socket => multipathd.socket.in} |  2 +-
 10 files changed, 64 insertions(+), 25 deletions(-)
 rename multipathd/{multipathd.socket => multipathd.socket.in} (87%)

-- 
2.48.1

