Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584342D8DDB
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817146; cv=none; b=JrrSXltO0q2U/TB09D9DyjggyG++LkMYsCiyJaCv595ObrHUdFKJYQ2VQ0VdeGaQqN7KRie6pWDAUpaX9xkjvy1gyNinmHeDftqenFZlvvRIh9b9Vc3oPUCIg3tyNSLQSTTHmFiVOI5GRKKZ5U2T0bnxfNfBRMhItBNut2DrJPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817146; c=relaxed/simple;
	bh=qsX3lDwwxdkwojdAreZpOAUvJ2bh6L4zEH3X55aBnag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/RjmdSDYxz8P64YUQ5dPfbj0/kTa1cBqk1oIzGWwQZ9NIK0JKTm3d7Wx0VESGlYVcbSU9p+JE6L4yJDzsWd2bPdIb7EiOqCpEeSy9PZINWbnYk8NgkOf2cgiEb6VZIOg83NJqctpwlzAXMgwXcAJVqUfJiyPc046+BhE7R58II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YabzbWcH; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YabzbWcH"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6505cbe47d8so3985614a12.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817141; x=1768421941; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OCXNmIuU/rXQScWnk+KRkZAXzGxXs65iGCpsakMS0M=;
        b=YabzbWcHXZOKxD45I2hE5/Y+kD1J4y4Qg30m0f8uc2UaVrCttB3jDQN6sQtrKy83GQ
         wf39SH1NZjRZsHWxwN1+sATq1EZ91299MYSyUi8cHfhniXB3sqOIHMWTRTcmSy2oUp7T
         UCiwTswhgLrtQAWd5ufL7agpbQWxlfMhstLfmrybuFXrG1aHrYEWOaOuBmneic588zer
         macE20AtSw5J1mKpzvEbQv2iCWWpqxJRL0R/DOUjzxaQ9+JL9cYRfdcDyEuZ8fZTIRbL
         SyAA3f3Vnz50oYEuvgLD5GFd65+RYgBGtA1n94jxGkPdRtwzmOzAG7AvT4Vd72y8D97M
         b3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817141; x=1768421941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2OCXNmIuU/rXQScWnk+KRkZAXzGxXs65iGCpsakMS0M=;
        b=dweURqZMbm8ihhpaXPRF7EjOpSygK24xlLSgl/28bhE7ryyMx2V3dAe/O0RYTlNT1q
         NFSioaTYdNYSzygXJfGou0XJzTpOehHTejhSv66adSWWgNjcFIBk6yUrhdSwjsnt4Ed3
         dp/t5ggKLQ/+/08J7qUdvSnw3aOwqAqLHtoaT8U5Tg3OIweeUWsfAqh1SA2cxzWK/F58
         LUJfC0r3S23h3Ad/HiTv0R0yTcIYyv0PxMWhXNy9B89w7ghd3yOzKxcj9bgfBWeY8ji+
         5+Hjv4c0PO8BS3OrGOEW8SVZvBXEB1Sd3iehrwUhP0IZykxso1Gt/usJDe7Jtef/C5yo
         VAYg==
X-Gm-Message-State: AOJu0Yw6zA83Njfo7FytjKCWxBqLFIF+cJ7Bpe9KarIwe61Tzyi/mi5s
	YB5ey7FDFMbqAbRvbdqWspytrXK9xscsVuPwCHTjabBsnIHut28eu7TffSEnAJ3Y/sI=
X-Gm-Gg: AY/fxX78LamnAxkhA+1spaCt1AFvV7WDbYZwxh9tbCHnMVsKOtDEmpck4rB/T/7p9wi
	n+tSWV1xpErAegMZ451fNDtHjGC1/hMw2xn6nTFJn3fkT/avZ6HZyheFfwrDZ4IjTUIyxfa3zI/
	Urfdm70WT2awU8R4oJ0LXXVwdIGpKQh5sj4RrrRn/zVt4VMJ8MzjgU5/mO6UxH3M57edgzE2Od8
	fn4lHh6DlI5ZDjUlj0kozjK9InqaRd5VIpS5J8akScXIEiCYgluhePKbSKHXrOF43oaoCxsZRqE
	MfN8jwhAwPf1irljwgKao2CaIK1oxk28rhsv8EkX9kfxxsfUDzOoZindxkhjRcx82aZhoY8X5HM
	731jXpHERVlytBl9mwtZe9HP7v2/jycjh8hUlZoVZj35dvGMk1eFTDsmDzAbhlDGoasYF3aL6Lr
	CftmxqsO9eVpktKA8emaAipco15VmO0rh+GJei8ZDrVGE/Htx/mHO7zhdGns8l9DfAfzo7pAmui
	Q==
X-Google-Smtp-Source: AGHT+IHJox2AMMTRbvDs7EUL9saFbdSDEstqf7X7kHPY5+zz1ZXfdPVWB8LoLFKMwBX6MNBJlc1Cuw==
X-Received: by 2002:a17:907:841:b0:b84:40d3:43e7 with SMTP id a640c23a62f3a-b844502c5abmr331795566b.6.1767817141286;
        Wed, 07 Jan 2026 12:19:01 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b844e46ee63sm205003366b.15.2026.01.07.12.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:00 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 20/26] multipathd: join the init_unwinder dummy thread
Date: Wed,  7 Jan 2026 21:18:20 +0100
Message-ID: <20260107201826.323977-21-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This closes a minor memory leak (thread-local storage of the
dummy thread is never freed).

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/init_unwinder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/init_unwinder.c b/multipathd/init_unwinder.c
index b1cd283..d39e428 100644
--- a/multipathd/init_unwinder.c
+++ b/multipathd/init_unwinder.c
@@ -34,5 +34,7 @@ int init_unwinder(void)
 
 	pthread_mutex_unlock(&dummy_mtx);
 
-	return pthread_cancel(dummy);
+	rc = pthread_cancel(dummy);
+	pthread_join(dummy, NULL);
+	return rc;
 }
-- 
2.52.0

