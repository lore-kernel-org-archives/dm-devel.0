Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574568;
	b=awxV+4Uz3H6GVW3wE02rmJ8KgX1Z3PbUxv/B39NdrwvmyftmCkEBVSeXv7r9bwIbH1xj
	 7tNaQeqV5IQvHZfnVXyg+YrEkbk5o6pIibcdByiXPKBH9C7f93hX/YW0rotCqqMkRpZOT
	 PI4TAUGey1pjjbjp+OKo96kVUOyEpuTLSyjdTFgGuK+qb+ho9osr5TPuaRyXu2SaSRNEC
	 a0sru99p7ZHTD7GcIy0YNKjc3P8mt3H/8cgjtBNBQspdO6TfMNGj7ea2kD8Nh49Kb0hf4
	 35HY4vIXr4QWrpbq13+98k0XGRMf58V/CGXXLuD6RLVoolOaMj5jd/S4K/idUjPOJwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574568;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=A2biGHlptkjAPqO5OGtpgPI6OF3LlhRXEaVmgSu7GwE=;
	b=JfZXxfcZIzcCrK9azTFhmGadp9AsKAhbySEH3Ip/zS0VYWhmM71yoa6Czsp0+G02kZmt
	 hdXiNAvhqsbWxKR9V/nDHccHqn3NoF3t3+7QD+6V6rqZWl7yqdGzqMZEKXn5McYHERFIC
	 TzWhEBRizGnYtgx4a72ZCCAvZCdXC7XEt0kAJfP1ZuQk9SPCkilkU4Ah5uOxFxqQIzMes
	 3/7sI8oBhPFreiJjZpzei6Za/8R2ohTh7YYhTUGkYe2rkX5cCuBMS4qrx7/yjQeMZSD4z
	 stO7ROO6vxYPJMLLAjnGocq+3gJZySIKr0L65X58aNsmgnZrvZiByaEIwuJu2x8ptSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xai40u7u;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944F7606A884
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 944F7606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xai40u7u
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4913db60638so72381f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574566; x=1795179366; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=A2biGHlptkjAPqO5OGtpgPI6OF3LlhRXEaVmgSu7GwE=;
        b=xai40u7uAJ8tiGhPOYFoQgaHjafEWhx+PwZz9cJ7R8emkqSzYFhHmpwNPeVSCRlnRr
         ay9fCHoLmOg0R4F62TV4+FNIfVvi0uyLyBmwHBr6yL+Wu2xW0EYd61tlVQgkF3Sh2EDW
         ceMgGr1cLJvqeK7L0J1NwBjuUxlW7ZCTnIHnd+gt+4hnUl7Q/lS7bxQovkBzrriBJBjF
         /sxge2yZ4wVN56BaHCrzSw9kifBfknpQFqVSaJW9JpNCjy4+Aucyfh+kX7Zir9o7XWAx
         AzzzC7+s2E+8ar7NKYpmK2oqoJI5ZeUFaLZPdXsGi2Hr7rlZZhx92xAoVjSFUIzNJvY4
         Up9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574566; x=1795179366;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A2biGHlptkjAPqO5OGtpgPI6OF3LlhRXEaVmgSu7GwE=;
        b=NMg2HlDrVzxo7+dxlY+a+OiQXtNYw0qSiWApUXobszmzpJ2bAtWle1vGksjV4AjZWc
         S2Bwbgsl/lujnIoe4BOiCLNmT55LT0pf8Vn3Zy3pTO4gSYdXVrtRktNTTT9ABqDBNGUT
         lLeBEEK5BLsFJx3+N7cAUsZvdH2lYSsbtaK0fiKKCC/8c7lfrSkObvqF2R00LEPmRKIN
         5MLVr9FpD47z9ubH/z0djy2OdHjyk3VYDLA7LcSpFbPtvkCkqptXg3UQY2eB6DrFukj0
         tZBvAWASrIoTY3uauymqj7JVltyHX+G1MlFs5JbI2F/TORyxjIa5Un+oCzpvrgvc6dRO
         4V6A==
X-Forwarded-Encrypted: i=1; AL+hErG5a6DjDD91nigsrm8Ts7t5lzv9L+r5yuvM78e1Yx6R+7W+MLYON+sNLvASt3CpBiGvtVjX+HYybA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/9FeCSqNKJEM/Xp8PpoKWKOApPa9Orok5x9bS7xCeEg0FYws8w
	9VFv2D5qKk7CuiSkYx29IkHL2hjuhfKNk/HhQh56O2M9UVwtNi+C0yk=
X-Gm-Gg: AYBFou1EJzFFRGvWtxJ7iNd5LNAxsbD7KKs7hOxQK3Kc8jZrYgSKqpJlr2txQg6hisW
	Azsozqpp6bg3Gw3+pqkQSujQBoFgATthv7vy9sZH6FxRQG1h7M2rE3xWxmboi5Drzq1jRPwGX+R
	2SIILwIOuAGzOGUIYPCr+oJatjnpzDyYxE4KyTTBKcwOzRmhZ2rhEhLE5zjg8IgM2RoDOmsAJLc
	DOyCbqYrwJEY8eA1YQAOsoHaazC4pBzjJOwP0doqKTb07IjFkoVDxYHUoddcKt6ZzUK3rnBEYVi
	ELdDKG32LdAk77rTGsCnQbq9KqnG4T1NklGtqZK3umQ+Jm14Tof/MS/zaTlEE+AupUfC9/knKDe
	v7F9NVzTeu1pJUAev6v15471PWKWNYVPX3SoLESL0j49HmgCzGVXIg81q1EepqzuU6xM0VnuLl/
	PKb8tdzjqtq9/YQXcvYXV0F/X1ybBSScBhph9VnsgZjSfhNjKmRYLii3n6/HZm68IiGWv/ydpo1
	MAPK4wveuuLzqlXVlfnGEbpPtdXMxA9s0aOToDkKoaGLRaarfWw0299xxfFfwrbCJo72lca6+X/
	9EXmSKk9n+SLRUURl6xB8uLx2mS5ozx+lpsQnexyzzT+2Qu2f6H+YmNg/X63mEsv5g==
X-Received: by 2002:a05:6000:26cb:b0:49d:2e96:4d55 with SMTP id ffacd0b85a97d-49d2e9650a3mr2655363f8f.6.1794574565626;
        Fri, 13 Nov 2026 04:56:05 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d223a29sm5339609f8f.8.2026.11.13.04.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:04 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 00/13] multipath-tools: hwtable updates and minor cleanups
Date: Fri, 13 Nov 2026 13:55:32 +0100
Message-ID: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Xose Vazquez Perez (13):
  multipath-tools: multipathd.8.in: fix mandoc WARNINGs
  multipath-tools: hwtable: make no_path_retry independent of
                            DEFAULT_CHECKINT
  multipath-tools: hwtable: add FUJITSU ETERNUS VX710/VX740
  multipath-tools: add EMC VNXe info
  multipath-tools: hwtable: update Intel Multi-Flex comment
  multipath-tools: hwtable: update Pivot3 maintainer email address
  multipath-tools: hwtable: update template instructions
  multipath-tools: hwtable: add EMC/Celerra
  multipath-tools: hwtable: update IBM arrays entries and comments
  multipath-tools: hwtable: add Dell PowerFlex NVMe (formerly
                            iScaleIO/VxFlex OS)
  multipath-tools: hwtable: add Western Digital OpenFlex NVMe
  multipath-tools: add repology table to README.md
  multipath-tools: move SPDX-License-Identifier to the top of
                   create-config.mk and rules.mk

 README.md                     |  2 ++
 create-config.mk              |  2 +-
 libmultipath/hwtable.c        | 58 ++++++++++++++++++++++++++---------
 multipath/multipath.conf.5.in |  2 +-
 multipathd/multipathd.8.in    |  8 ++---
 rules.mk                      |  2 +-
 6 files changed, 53 insertions(+), 21 deletions(-)

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.56.1

