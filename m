Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEE32EB844
	for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 13:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757768553; cv=none; b=eQQqfdQkyB00ldNLn4w8/eReSBMSDKNqb6GslnYlj2kGUEZbGeaWaiQHVINA8SihRg76zxVg60kyQ6Xak3kT3gZ8qF4S9tKcR9vA+oRH78z4KcwXcl4ztbsgi+A14znK0LvjAGgJYfAZ4lXGwuCfwZumBpd9qvNMLp3rUKK5tg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757768553; c=relaxed/simple;
	bh=XU0EI8oagnZJE6wPXpuJaU8l+IXHBC8OQv1e1K2S6Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivHoMtNQDt1EKeG8g/9l/8pCgHPXCgUqQlP7BDZT52E2R648qGinUWBh8/Lf5/f1XGW0C9LfhUtRBrMeAZ8wZ6gVl9YL2rvqRzSlyMPPZ97WcCigqAPZDMI+1sS4q863DbEOYG6ZgZIpO/G7hHT85V8VhtJBXI+iHTCpNzV4qX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+Bt0mk0; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+Bt0mk0"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ce208c7505so453188f8f.2
        for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 06:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757768550; x=1758373350; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cn7FddPEqSsjiB+JjmKxJKNohyvsuwB4BsJ7EQNnwDQ=;
        b=k+Bt0mk0FshJDwLo2OYJmDVI+4jh6gKK8hbp2BhxK4woMfA1dpqCuK8l3MSyCN9ZFB
         dHj+s6C988vIl/TvMu5u7AROlUggZzcf9oG/LqwDyqDzrFxPYe1CeUdSvZnFINMvr7Nk
         E7VGtIvaI/r1+yrKRGzZNu3RPDXNSArUvNJOSvvwTKkK80F+uiy6K4Cr8B+pb2HQXFtW
         QMucEonKBHvYe6Tkjj2fLuhJIrySU/xOIIlH6b4Vipko/k/A4v3tga/h/EVjO/tYbcW1
         fA3iLsTHAcrT77sKSv9He2SgDu/sWjkNTKa3227Nv0hxelKIbCE6bcv+/y9QKZShtwWj
         sG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757768550; x=1758373350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cn7FddPEqSsjiB+JjmKxJKNohyvsuwB4BsJ7EQNnwDQ=;
        b=ZBSQAlbGjrkuIrgDFiSMoE+VcRI193Qf3CsimYETWG1nXzqpEinmogqujCJnMAwiLu
         pMsobkeoiWzFwAwbhWFVQnG6KccgFFX0wV8ZSDQ2JYjtXy8sucMB8lABQNrc+MMibriT
         HFP5RPlf5QrK0OioA5qNXP4+j7TQDkN/xoNY8+Q6HHOFeK4aHZaR3xNxlReCS/i7PApP
         wnI6Wsm5ayE7Qe5MjNl4Vd1EcZRexqto7m/1NAUs54uR/nRF7YGBYlES7Q3Q+7zImDCR
         DW6ClQvp/ltymcP5J+zsi7lJhqUWZMEJhFHngQHKUYoTRIvCikL4Gk1pR8ILABNNagwt
         Hjlg==
X-Forwarded-Encrypted: i=1; AJvYcCU/7FlsSbw3YTSg8JxM5WdKrPuQqeuykIMkhQ553qXSDP3CWJuFDOxjxyZf/10znkF/bHHLqfCEuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8YS2R4cptViwSniifHXozQ209tMiIBBl78FP+ySunUFk6e4Lc
	ZrC3/2/l3FsOrAwDouEHy+kAbp92X3XHIhjerO4hS42Fuig3upj5wkE=
X-Gm-Gg: ASbGncv4k78SEIpheFjqKTYUmt5uT2E4MMjen6nHF/JMbxLgNevtnWZTvAZ52cO9Uaq
	dj/kooNwDdvZpKMsFWOtusCAHMGJ+3KH2WBYbSznHK0/5Cz92QK6R5zBYOXDdP45RZP7kC0yyQp
	UusW053UVFsD+iBZLyP1NrGHfA4ZS5Yp6zYLwWNqliz1pF37040zklvCHiK2x34PFCqIDEwqYiZ
	YkTYntDJVRgM6qDh+SSAwGWPOTsS8fc5T5z2nSeyA4tK46oCpbR21xkO3VfgAKXG5TwW1FO5hqJ
	/KUAn3OUCYPirA90Xknmw32xLhM4oqE4L6TRBIleSbMhN2l3NuIJnyRDbNPRt6YHrQUp+13CeVd
	tIXyjcSuVSeLfzPg2tTLQxAuFS+yftWrYUPX9cqbrLTGTxdql0hvtbtC3HcQQ
X-Google-Smtp-Source: AGHT+IHIGkQ5Qcji12O5HzBskXzDACIR3biZZqHljTgc4oEpXtQtgAatKEmDmAsWViDZuuDL6a4+8w==
X-Received: by 2002:a05:6000:186a:b0:3e7:52fe:80af with SMTP id ffacd0b85a97d-3e765a25841mr2627583f8f.11.1757768549940;
        Sat, 13 Sep 2025 06:02:29 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760775880sm10385971f8f.2.2025.09.13.06.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 06:02:29 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/4] multipath-tools: add HITACHI VSP NVMe to hwtable
Date: Sat, 13 Sep 2025 15:02:14 +0200
Message-ID: <20250913130221.35073-3-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250913130221.35073-1-xose.vazquez@gmail.com>
References: <20250913130221.35073-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 399545ae..fb446856 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -510,6 +510,12 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.detect_checker = DETECT_CHECKER_OFF,
 	},
+	{
+		// VSP NVMe
+		.vendor        = "NVME",
+		.product       = "HITACHI SVOS-RF-System",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * IBM
 	 */
-- 
2.51.0

