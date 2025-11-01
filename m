Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6DF60B8A
	for <dm-devel@lists.linux.dev>; Sat,  1 Nov 2025 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762011239; cv=none; b=Ct/VYd1rxQqMa85kFcNUlwDphOA8erJDr6XkdBg094RpgTc7QQSQdeSeA7raO3mWfezqQPUuzkjqvCoGslbW42cpBJaORc3JHHD6iN5IiOsEs+1scRvw/RuScJHxBWAuKweg1j8nV8V7gpd6DSoaz7bcFYdG4Zo9q5GIZGLLxdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762011239; c=relaxed/simple;
	bh=+qDeg/grd6f3mMeqKZ77ukzzVRAvPUKB7aqicgPMiu0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BmfImo06CUTY7N45OC0k/k06GG+7plWu8ZSfINbSWjmyvE1n3yBrzJi1vF/N9aIYjV5PdRHuP6Y+M//zwpBU7lmES8sEAhcO3msUHb1rrKq7hhF5PITo+KbPQWoHPQjqBieIIX8romW5g1hgsiAueMxIrwcIVKsVeKeuqk69d8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2EdtWr3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2EdtWr3"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-429c84bf326so54776f8f.3
        for <dm-devel@lists.linux.dev>; Sat, 01 Nov 2025 08:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762011235; x=1762616035; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B3CCLi+mgbeIW2+9w/aSlwnWJwkjqx24f2m4dKtb/TM=;
        b=A2EdtWr3EhMIQDrsG6Raqkzj5o94lCUz65zKAMPiyZRm3KzWi1YQRYCYskTvkykHav
         BEEK+FYluCFbgT4R9st0iC2aex1ZpNzvPwHEO1uQOSo9OxdBv+aHcyeFUIteoRjfOu/R
         nGY+m3hJqLdzISBOzJKJ438JZz5VHqobWmrcHuthMKtoeXllUB3EthghCMyRNO0i5kmk
         31KpgcCvcE15WZjNFBUzWYLTEXOxc5j08iLom4ejF7inIjogjAIZ+uYFKgwSWoUBb1Mf
         R2jMRNBkJbFW8KOnphj5MiqgVMPEjcaicSvTtFUmbSaPqoOD9xhqqMOqTJEchiujX/Dr
         OQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762011235; x=1762616035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B3CCLi+mgbeIW2+9w/aSlwnWJwkjqx24f2m4dKtb/TM=;
        b=HaCMRIalgecCn73fCxujtjLtpWpRi0tpytqabRJ7P/XQ7fB4+L2P7s/P5mWDW0DA2r
         afjgIhzvVSzOTMzdfBPR/Ciw3NZMLzRdAGziS2erbWmT0PeuDDODvsvcxMDDz5L3kFPK
         /+TXAOctIwdxgrU+SjuoaZHjk3mQZmft6uaO6Y1ExUisrfcd01pV7cdSF0TWAGlElBfX
         UK6ZUGQrInwC1fHAKjvpLpx9JrHjqhzMID3CV0YO2LsOfuwGB4tS0FDXzFYWo6ta0P/i
         Hajn24MRRDCCeJNN4QJ1/q5UokLeIcS/V2Cy7L0SZHNf0udsrkn21QqnvKZBQTWllk2e
         +fdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB7lz8PXGzQqbnjvbLxO4MrSEYt1Oleb65lFgWCdoW+D9TtsCbSRvVSMkDrEnPxYMe+7TYEBrw3w==@lists.linux.dev
X-Gm-Message-State: AOJu0YwF5Q4WALPcQepDgj1IEwtbNMGOXlDSLQRyUeF12QImvQI7woYo
	O5jPs7z4sW0VNOXIuxpTGTjshE+ddUyTEwfwRg30woQPI+IFrVAW6eI=
X-Gm-Gg: ASbGncvlTHmpHhq9W5ve1qQ7iy9RIwDIPeCkS8sIX8ROYIheeyaENgeh3Z/ZGz3W85m
	kdCigGAKk7K9I1Ym2uz3NwyrP3ttrIE+5id6x7Y2xUqP0+4qrH+nZEvh1KlOBn6K0gc0t3gOK0e
	B31JNJ5Kxia3ZuwIk5W+dgp1a11FXPohayLCFZBn9xhPt9/oT5boySAAmJmsaO7iRK00P4WMRIv
	0cJfRvIrHzbc37P+uRUnikgEqgKvF2BXFjcos7TXgWb/uauP7eM7IiemA4dqezeBus274CCa53q
	Mn1RutQbWoJFLT5fZkvVIW3ujYjwzhUom4glD1i5pgI2sfiibCIlkFyFqvafh6qFZ9jr3vciOyQ
	/HhkQgztikdUk6xAq/ltIOkHeFeJWG/tqULEzHHpo08alkjeqdGdVi8uLWiIHmKxgqNh2B7Jakg
	+Wo+JYbCwTpF/3ux0s1bEpiekuO/WII/Nte3vFEuo4tVFrRqXPV8J7
X-Google-Smtp-Source: AGHT+IHRCOs6qqG0p2YAt3lngP2f74whvDGtMAE4YUsP/QuqMyXeXNpVivHHNl5Dz27CvJSG7UMy3w==
X-Received: by 2002:a05:600c:1c93:b0:475:d7fe:87a5 with SMTP id 5b1f17b1804b1-4773090dccamr34625225e9.6.1762011235117;
        Sat, 01 Nov 2025 08:33:55 -0700 (PDT)
Received: from localhost (22.red-80-39-146.dynamicip.rima-tde.net. [80.39.146.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fd280fbsm44650715e9.5.2025.11.01.08.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 08:33:54 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add repology table to README.md
Date: Sat,  1 Nov 2025 16:33:52 +0100
Message-ID: <20251101153353.289617-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/README.md b/README.md
index 530caed7..e272f899 100644
--- a/README.md
+++ b/README.md
@@ -5,6 +5,10 @@ multipath-tools for Linux
 
 https://github.com/opensvc/multipath-tools
 
+<a href="https://repology.org/project/multipath-tools">
+ <img src="https://repology.org/badge/vertical-allrepos/multipath-tools.svg" align="right">
+</a>
+
 This package provides the following binaries to drive the Device Mapper multipathing driver:
 
 * multipath - Device mapper target autoconfig.
-- 
2.51.1

