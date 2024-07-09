Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF8718785C
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561197; cv=none; b=uvMkWM4SxI05qxok+RCjEprg1ttNvTTaR9kBapt5hnA+k51+nZ5uhnni81zms9XEpPiXbq9aURQn9zFLuUy4QiO1ERBy3n7RLYyRol0hS2xLR/PGlyNcVDMpCFdEUwNTgDQgppwQk998ttxnEEMbcF9OhsTpJQqJJiB2iO7zu3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561197; c=relaxed/simple;
	bh=bZWRm9ba+0PfCGLRAJ8oD3GqVYO9+LyBpLpBjVBaGQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLmZdbao3pMkN3QPnMA8MnSouNhUaTNF9orWTnGUa7pQ8OjaqZydHFgLf1U0IxcJ0e3hGqD6FUnuaUBP57McIV5fuZNgUebBNofVoRyx5NegQm2Rfghdo4py/Jn4wMZ081cxmlf6HQETVdADrdzhtvQclmJ2DCxi7aJ/QVu+Rds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F8aF8HVK; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F8aF8HVK"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58ba3e38028so7195744a12.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561194; x=1721165994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3AzsR6ratvA9Qi0X/GRrLKtSe5ajtWe3GLHdoy2TjQ=;
        b=F8aF8HVKM7+fFhcA2LktjaX2MELX9LCCQ9R3/GkRdG1Y1cqjjfml55XjoVjMfBc31u
         1SfR0aJAraqS0Cxq9w/JS5AUdF/mG/wEqkaL2SM1W60qpwjbV46UAb5jtq0IkVVpBf0/
         /j3+OZTaLxCJskm8YM+y+smuhuGLWWt6LnBquT/hbIVZ1XUeHCnLY0c4LQMrNdz2aK45
         NHzLeU3FbOK6VsWbiwL9YCkQxvxMTQ8FH1wknH94/XV7lblEJqrjqfd9Qpo2EDwWhtd8
         m6Aswtr1Yx+GNTuPJddmx+U9tzo8/Zf5zb8yTE1KYLr/Iw3gpGmo5kV6ftSAZP119DxO
         JlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561194; x=1721165994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3AzsR6ratvA9Qi0X/GRrLKtSe5ajtWe3GLHdoy2TjQ=;
        b=YvVtK1+9BCaXTli0r6X1v0fqXPWxiOA9l9a3Uhe224obV+h6N+zqJ+OFMfHr2jAmwI
         o359Km4ZgproKR+tNfpp2lEbqCRgRXiitwmoDGUZNrpTVb3mlpjyG41sLnMcbU/qIU9P
         t6/tzztA7Z7vLptx8nGfnFkR8ml66o7WYqauRMhd10biah59f+866P/UwbTmnLYGz/Fu
         zUvRmjm+KoBJDkpJ8y0UNKHoPsvZ1fT3/RpYyHpvF4Ov7L+iOL9Buh3bwqCdzZGRrGH8
         wI2kO3SnAesumlmD3+I8QabjsEcFb+vqtzgH7X91cjl/o7QR0pyXoZdsrVaJkLJZbRRJ
         Anew==
X-Gm-Message-State: AOJu0Ywg6nJlyFoAmyP2RKuqDjt7YbRKUpzB6IRIwbWhsEbZYwA6XGhD
	r0O8cvqE2BcEJVGszW/CqcUrBT15WxU0m9ltwCnnpUDc9vGznJO8sWTbmxZD8yU=
X-Google-Smtp-Source: AGHT+IH0u5IXP9HcnXOz2QeM8fcmIZ2YIrn4B6EtqJxc/pwfBAlJhC1EbIO/UanMKGj1Wui/5iD64Q==
X-Received: by 2002:a17:906:8412:b0:a69:13a2:4f6e with SMTP id a640c23a62f3a-a780b89f6a9mr199145566b.74.1720561193862;
        Tue, 09 Jul 2024 14:39:53 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bc57csm107555066b.1.2024.07.09.14.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 09/44] multipath-tools: .gitignore: ignore o.wrap files for CI helpers
Date: Tue,  9 Jul 2024 23:39:00 +0200
Message-ID: <20240709213935.177028-10-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlike the .o.wrap files for the CI tests themselves, these are
not automatically deleted by "make" as intermediate files. Ignore them.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index efdbd8a..4548cfb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -42,6 +42,8 @@ libdmmp/test/libdmmp_speed_test
 tests/*-test
 tests/*.out
 tests/*.vgr
+tests/test-lib.o.wrap
+tests/test-log.o.wrap
 libmultipath/nvme-ioctl.c
 libmultipath/nvme-ioctl.h
 libmultipath/autoconfig.h
-- 
2.45.2

