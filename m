Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D40145A19
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721330071; cv=none; b=K/qDUa96+B0/xsK49tghoWJKYC9hWRGEZcSlY++5SJWPhJph3OjAgs9qweIMcoRxS5aht+hTxOWO4k7QwmZ1CA92BKbXRmimVmivrQBZRTyjABrfmbYJvW4jHxBFwgQaTbzFWERSYvMEaRt7WYbzqh+ku+6+FOQSlUmSLWKFsEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721330071; c=relaxed/simple;
	bh=9QQxOAw+n25rBXISDTmgxfYJc1cAC7AQgR/RM+R4aMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIrjfbaA9BUPngOnqFhj5i0Sd5Aj0/JeG62NRN79DFtqNKLeSMPZZ0sPpAFxB4Wjtdc2b5ctKERGTqNjIIyIYc4Kgl8r4l05Pklv1BaQ9XSfurXz8QDoIH3j7kWv0RIZjmVHoYpZbfDw0NQinzupNROawxQ6nQT11+OsRF3Z7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dYE599EZ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dYE599EZ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a797c62565aso109505866b.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721330067; x=1721934867; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4a9A3z0g26oo6z860dEh5Y67eH0jzn3fNhDi+LhVgU=;
        b=dYE599EZcEfham87hXcSV0W2jv3Skp/0mbaHJyUlVU3gY3e6Pe4Or8LjxKk2k5ufN7
         EHohdQ4r1YHBYqmERwzDZS5tew1CmgHcr52LrZn+0lS0W4DE7NknhnydVzeSQ9KwXeDB
         EO0udyLg/yW6e7KStm7AZm7V8Ll/AfxpOO4pJS74j6o9m1sZAius5GxXhePIlCRw8dov
         OEkAq4DqqiS2Ipnu5mJAocQbK8kifqEhROrCDll1TNAOmbwsUbajEY+2rxDM+5H+zu4Y
         2dF8Ov+AduBo6QFhX3fi6fR9HcjQt2L9zK5GQgVHs9M4HMTNB3TmfD4WBIhOxLB21Uq1
         g1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721330067; x=1721934867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4a9A3z0g26oo6z860dEh5Y67eH0jzn3fNhDi+LhVgU=;
        b=CCJYQ1UF+spzi80OUwwH/5rbcgbShqpziE4H07foBDeUe5svuGJo0TF+zqbpwTLnnp
         vS2FQRpvxA9aajCJzqrlFa9Upalwr8TDk3IIMHVct9hGjKlYUZCl5GLkILJuC/u++Dqq
         h/mYXwR5nExQVhubAchWxz6smSa/fmxa/4/pfYEb76OT1pHpwptzyMQNHsGtK5CmlMm+
         s15qZZbyx8l24onaHxVdPfRte4mtlk6MDUI3Dv91Agx63YY7z50iP9dqYneqJzk9t9qY
         O2Ha5RWhrsxGgMyVtHP6RlkT+Vcp5OF1cJQcuc12aHsM/k5ZrD9vZ5KAQXAFrp1wMDg4
         Jqrw==
X-Gm-Message-State: AOJu0YycHXesZs4nRocEuOyLMzhkAXDoTtMLGu0nt6Vu7URAA0jvnieT
	yx/n3ZkL4WL2kV861TJJpIqyKYzYwI/c1HyKuScqQk9BaBEFj02dzZnS6gsw4xk=
X-Google-Smtp-Source: AGHT+IGAUnKL2WdUkJZKwZoRTSsadocq8Y09cAdt5Ufi4QdBlIXuVbyhg2E1S1qiioP/cdYlBBxi0Q==
X-Received: by 2002:a17:906:3858:b0:a75:25b8:ffc with SMTP id a640c23a62f3a-a7a013369d6mr398378866b.57.1721330067028;
        Thu, 18 Jul 2024 12:14:27 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc5d1a95sm591396766b.79.2024.07.18.12.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jul 2024 12:14:26 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/4] libmpathutil: avoid size_t underflow in strchop()
Date: Thu, 18 Jul 2024 21:14:20 +0200
Message-ID: <20240718191421.110487-4-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240718191421.110487-1-mwilck@suse.com>
References: <20240718191421.110487-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by coverity.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 67db3c8..9c422f1 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -27,8 +27,8 @@ strchop(char *str)
 {
 	size_t i;
 
-	for (i = strlen(str) - 1; i != (size_t) -1 && isspace(str[i]); i--) ;
-	str[++i] = '\0';
+	for (i = strlen(str); i != 0 && isspace(str[i - 1]); i--) ;
+	str[i] = '\0';
 	return i;
 }
 
-- 
2.45.2

