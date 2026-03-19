Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A91D3BF67E
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773958442; cv=none; b=jftUkBLESReeTG1Kwa2kLq6wyD+gFqLjf9Bj2KnpGIbvIlyfE2U+bZvNi9It0C/cmWhdWotE2CXxlf7houwSdW7hm224XZXk5VVGcnHpAC8FSPFHTVV9zh/Qrw6nnlzeT+oAEz3JqKscDi4QuaigLK39So6lyRhe3nRt+wK193U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773958442; c=relaxed/simple;
	bh=nfsNPPuyxyiCuCKrcNKTdv1urkRDdSamaHZUXBK8fm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+hKDYnAP7CMh/ToJUsBHlGg/Xyx9xks5A1++jqI4SB++TWwGEHNVwD4I2n3EDqNuaGX5otJUCT5GYbm4TGPkOVS1QlMXOmq/ZpmHxlTseasbtkFua+ibNQxNwJ/6PgTNriKPQUPEaTuHTHZJdGhBH7Rq1dNydA4X10zyp3Hc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A2ArJQ1j; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A2ArJQ1j"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso8807995e9.3
        for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 15:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773958439; x=1774563239; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHb+HwYN7ARmp40OncKh82TYxxb8Wdh2WRTCIzGCiqA=;
        b=A2ArJQ1jlqsJGp0F8A0lFAyA+vej5jNqqNGyOKlPE1mhOCMchZcsHrq7TEux3675AT
         P2dWEf+fHeLHFDb7WvbjsMLywTrGisAHQ5umMvqbQP8qND7JIaOZg1pL5F2hJjTzqcoP
         xJ7uJ2mI+xbWt2uQAU1MMH0JXsx5UdzFUu/9wJwMeXJi+p0upWjXMNx+MgcSSZvAC76D
         Mor8onzbOMOh1Za+3pYnIXKSi59Exk6eilxK304aDUeZwJ6zniL4gnt4wcTC247005av
         obHkLx/BrtDI6rd7HohBLHjyxjP6RSdA+r9jYHX1C/EmTbSxOi8JZMVLPDi1urt+kBGr
         QwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773958439; x=1774563239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHb+HwYN7ARmp40OncKh82TYxxb8Wdh2WRTCIzGCiqA=;
        b=Wq6zGOTI4en7XKGV3x1LiIyiRo2rj7/tcOoUXImUjU3oqouEIIZDJOobQljyw7nj6z
         F+u+mnK58nQqt0WyJqSm7yqkAjzDca/gwQuyGKP7wa276Yh302IlXSVL/ZRRdCN5am63
         URR6SD4n87D9AUf3jQXJ3gw65Hz+ZgqH9ddjE9FvWrbV3j2hlg/0/09mKJ6bMBHokF/S
         1DrW9TosJnSsE+Ef9HR3Ist/3o1S7bn9hxVTzoiQEKedZpRZBD3au2eSs0L3TYCa34k4
         4+JSy6sRCoZYxGhJ3PwjpIea6fSSzMFwFrYvYqxbPpxE8W9PwEiGW+Y6gI6mmiQeUhXX
         Iz+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0VjX+s6gUM8HEuw8yZ1N6XGpGyCdMJkwxxSsIEXgLSk2vRVXn9YQgBt45MEPJUuVRYusAC8G6ag==@lists.linux.dev
X-Gm-Message-State: AOJu0YwekO0aWQ4bnxZ+XdX6NhGZXpqUh3kgS2H3p5OHG52/J9+DAeGc
	mb18SQogHM4tPdZZBFlmNEc8qlzTRfT1BHX1qIzP2g2lrNTu5U3VXUNo9R43FUIFHTs=
X-Gm-Gg: ATEYQzyikbwwWbE4/upqUwRrG6PIRiWg9Yg86NCWr1RTmidfOALm51mgsEmdcSnVDGm
	WQn3QbBQzLFCfQCPrrUwPbNvErIEhB5QAedVDrKP1jJBYarQw7/c3ZFGo0lKL9mrm0b9sX1AUS+
	CzfNSiNUsZOBUikLnzvFye4SqhsXQXzeWxwiyMbLrJbHYeWBOvBw2o3WS+de8/D73dhRBq6daCr
	HOWc66h5vy5FvJDZHdM0LZ9EQ7d9owmu6Ux2TrFjR5nw6eK2EqUqdJ2V9Xu/0paX4OpVTmS2eiD
	tkNe+oET27m/YOk/L1f6X67fBCcqZ65B6mh6i/1TN8HkGvhiCtMrUcQLQE6heMww/VAEspdayLR
	BR4zieTMF7CuMN6GYO3rv+gYJtkTSGE/QAkmFwM/cfopXny8M9+2v+6wT7uqgWontf+GTodGn5I
	HiWNZ8Nm1cX0W1aJNPXURvSXe9gHfiwYr7CW2U9LG0OIY3EPzgxrH9prfWHeKS+bDJ1SW8TNzid
	UnpISgbX9jqbA==
X-Received: by 2002:a05:600c:450b:b0:47a:7fd0:9eea with SMTP id 5b1f17b1804b1-486fede7341mr11384735e9.3.1773958439416;
        Thu, 19 Mar 2026 15:13:59 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-486ff1b04acsm2861765e9.22.2026.03.19.15.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2026 15:13:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] multipathd: get_new_state: map PATH_TIMEOUT to PATH_DOWN
Date: Thu, 19 Mar 2026 23:13:41 +0100
Message-ID: <20260319221344.753790-2-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319221344.753790-1-mwilck@suse.com>
References: <20260319221344.753790-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We map PATH_TIMEOUT to PATH_DOWN in pathinfo(), but not in get_new_state().
Do it there, too, to treat the states consistently.
This avoids logging "checker timed out" twice in update_path_state(), even
if log_checker_err is set to "once".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d87c7b1..9bce4d6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2503,8 +2503,10 @@ get_new_state(struct path *pp)
 	 * Wait for uevent for removed paths;
 	 * some LLDDs like zfcp keep paths unavailable
 	 * without sending uevents.
+	 * Also, map PATH_TIMEOUT to PATH_DOWN here, like we do in
+	 * pathinfo().
 	 */
-	if (newstate == PATH_REMOVED)
+	if (newstate == PATH_REMOVED || newstate == PATH_TIMEOUT)
 		newstate = PATH_DOWN;
 
 	/*
-- 
2.53.0

