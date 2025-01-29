Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380CC2E40B
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738155547; cv=none; b=SBU8aAW2Q2+LSpbWKGsb9MJ1m22StiKp0KnAbdlC8ZIIPglSo6tD294+UoLpcQLukRweMoqY+M9e5+jdl7fI4JSv7qHlVT2uxjwB8h/YcJlujBhSkhI89q3qJN9lMy9TMX94y7l8guJourrIdfNc92wrGz1O+3eib4UKjcctr+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738155547; c=relaxed/simple;
	bh=TXRSvUsu/J8dndeS/fB+dvNxR5/6tkXFDwpKmWgjH78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rz930dAYZscSjsDLrUAueNOafWyvfiz9ooASyUq3cYBA9HGohA6Q28lUotAuiQjlk7iNzdMVX3bNLELhZALxaXmTo4vDM31kIi86cDxmd9SmohaWiZY7g1/LJPAj73A4R1SqFaea8/9yRWAl7NqPbgKYfJ9HsO7KqzYA+FkRgIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwV3/amQ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwV3/amQ"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dc59303334so2390367a12.2
        for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 04:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738155544; x=1738760344; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4czCed/mOts1YqzeI7jcTAk/O3TM9fvff4OPJ+gxFoI=;
        b=iwV3/amQWSJrEAVlpph3KC2NHM755MHDWZFuulSDBkeBavZHRFd4L6cFayzVXW4C59
         G/+JCAMfdqbIyzgHOuh05QkHzvjcF3xNVEWS/xNdcdERxETY/EnpY9lGfcJsbDgZVI2t
         USpuJal6RL2JkWBm1PskDt7kbYmbDfjS4wg5jVDMJZbA1tBLi2nqE55cOHtzSF4nNZkJ
         On96Z0tuZG3M+t3Kkbb4Lh/agz2QgUXfcnj/vzGgrbH2Mp2CfdUdGfnyYsnS0ihWP2U3
         rJ9Dbgxzpcpo8oVDUwlDq/qBPeYZ5LvAAX7sIgv4kUkDjYUzJzJm6iBZNb/ieb511G74
         Zcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738155544; x=1738760344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4czCed/mOts1YqzeI7jcTAk/O3TM9fvff4OPJ+gxFoI=;
        b=Lipa8LHi8rs076XJbBvcRG7bTeC2HGxLE2t+vSdWiOQuzstbYWVaSZub6rdtXcrWlh
         2gvSCLk+Zmt72RmKrg+ZfYhU+bYojQhj7Yv7+aWNQjWD9g97SfIKiUFO42CfRWPlxX/x
         i5h7HyuVwQLllwFNRsf7a1J48iJnoKhGp4xVcX2zoLuLT8AxsRbldBnaMI6gdiXcYQ1N
         RHZrXNepDVnvXuzS7urUzOLJFjnJF/isODv8Ov0La83ZfUsJ+FB4PuHZZbg9YgQpmMIC
         p22pqSDjY3Lp7axxk4e7cJjqvh8HwZdr7vXc1uxXuXGZ9YCnQS2wV4onWl1vGbMaoZIm
         BC+Q==
X-Gm-Message-State: AOJu0Yx0e3REzbn/hss0TaAq7x+l5xGQ25apsrUlzJn2COceYnZnIJg4
	LGYwL5Re9ZJZ4wq9an99zxFVZ784KjIKEhuWA8Grvtv8RTdPnD9BtbB68g==
X-Gm-Gg: ASbGncukv7hhFl3fp2N7D+PL+0fQya0/111HNV4OqV5A3s/cXAiuydsYNQMZcqx01lK
	0op2OH9aDD4Fsux57dx9pdVAmS8+Ze6rM8vzvm265JKQqUq2Eu9CP52gyBIfXwIabcMl/tHV6Me
	ySvUa6EgCLdqSH5TM3Hzn8BiHQzTZXaoI4q4BB6uzGvfuwYPIjfLuXHvTu+wMa/sb1u1Yhd+NI4
	mUVBwqnT6MC+rbkYar3DR0d1uC1V3OZH5DPakdU4DIVQggWyTIPfK1yfiAK5ZkPIyXNVZYF/w72
	2W/B0sVo7kqzNA97XMxjrQ==
X-Google-Smtp-Source: AGHT+IHRcAG6AWwN+xDdFJBYVY/wc4vfXGJqJWVuagx1Woau+0kAukJ8xBrgzUIM+e4B7DUg+8HqZw==
X-Received: by 2002:a17:906:40c7:b0:ab6:d660:c845 with SMTP id a640c23a62f3a-ab6d660cb02mr160863866b.50.1738155544151;
        Wed, 29 Jan 2025 04:59:04 -0800 (PST)
Received: from syrah.fi.muni.cz ([2001:718:801:22c:1369:c402:50e6:7236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186c9115sm8537417a12.54.2025.01.29.04.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 04:59:03 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/3] dm-verity: Document restart_on_error and panic_on_error options
Date: Wed, 29 Jan 2025 13:58:55 +0100
Message-ID: <20250129125857.252448-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds documentation for options introduced in commit
f811b83879fb ("dm-verity: introduce the options restart_on_error and panic_on_error").

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/device-mapper/verity.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index a65c1602cb23..fb3a045d0c72 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -87,6 +87,15 @@ panic_on_corruption
     Panic the device when a corrupted block is discovered. This option is
     not compatible with ignore_corruption and restart_on_corruption.
 
+restart_on_error
+    Restart the system when an I/O error is detected.
+    This option can be combined with the restart_on_corruption option.
+
+panic_on_error
+    Panic the device when an I/O error is detected. This option is
+    not compatible with the restart_on_error option but can be combined
+    with the panic_on_corruption option.
+
 ignore_zero_blocks
     Do not verify blocks that are expected to contain zeroes and always return
     zeroes instead. This may be useful if the partition contains unused blocks
-- 
2.47.2

