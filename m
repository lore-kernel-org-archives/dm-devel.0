Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E37185623
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561193; cv=none; b=SffX0TkixSKZZMeDBMe3Z0rBonnxVp9M3Ed0BoCB2pULkcIb0LEfXpp1Z+owO/ZStTiP4GZmB7cGad8I+cQsiVNNA8/WZ3ezsp3v5oqHPuJ1x5cVkn6IzlAem1kNODZCBTIV4MZuz5O6lWDMr3J7jOYsCSJc96PRYExJlqcpQZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561193; c=relaxed/simple;
	bh=Hw5JJ1TXNEfdnTdUN9EFk7iUIaGZnO8yFZAXEqASdiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZE6iw0mqgQjZfu0o+FxwJnbqX/BSZFapfK3WvxFL91ULxRCa/0Ee28BWpTzO+hH2bKodtq1h4ey4klKSCpH1NlfQEc872edHhkS6F18t33VHbJE+Cs5HXdN182zeUKDJ1GySuevWg0SrjMRBzqf65iF5sLD6yCXCZYgRAe4HpdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QIHsgnVG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QIHsgnVG"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77e392f59fso418487266b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561190; x=1721165990; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrHXXV8VLJpJ9eIxh5MIvTS6KDKkL9E5B0nBHXrnN2w=;
        b=QIHsgnVGFzBoMUxpjwt3B0NmMarpTBzciDn6STVN71VXRdEysCTAGT44/msCJ4Mg3r
         Zil5JxCv6fOEVoSDA1kAXGwL9FoGqUcrSyaPN0ih8fIRQPvR0mxhvGKaLq5+M6DS+pTN
         1sxhTdHSg7bBiTTKUeWj4EC1YnRBh2elp6ZcyRg65HuaGHwl2l83u7kdvg86L4jP90P7
         e+24Nfud/wk2YjDAwUJYbxHvOJ0IvkakANK7s7RsbQeV4yN67D4wrAnc7wZYrjbq1F/P
         b0flv0HqbAM8j90LicLeb+/RO94kwwbDsraLPQtx3igbdAE13SZrGcFgvtjh1amPCWKu
         1Wrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561190; x=1721165990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrHXXV8VLJpJ9eIxh5MIvTS6KDKkL9E5B0nBHXrnN2w=;
        b=qxweDswV401n4M3peEfp19OpdmgTC9ewr+A922WGJK+0mMXtaMQpNlQQXd84prrfCB
         vXLSfjQoj9jPLAUXb1zm28YoxDlIPdNgWn54D8JhvRY7FGEFdz/WY1ctv2GQPzA1g+cX
         wWdw+AkJzXit3hKAZJmReUlJB9lzLaQRx2Rmqgv/K7kab2EIl6ReJ5F7U+nSl2lzUBU2
         /ud51s3gYgiL3KQZkyUsDLXCDmM4obqg2sNCcWAPCO+IIQYk5Svj0sj0zYVZROCR1yLw
         3jCeIKOpaYoi0Jb7E+KMtLt6w8x/rGf+Wgdr/lcho+wCG31YoqeIEg6aR5Hb02byEGFz
         np2w==
X-Gm-Message-State: AOJu0YwCorefFhvtMycXqnY521WTiEGkvyfNENEG9QHeWmScBRH4Hmyn
	Lvar8WYP2TIMlvQ5omYVSlbBT8K9I0T9BJHwfxBeoQyrYoKFHdze65t4cvGocJ4=
X-Google-Smtp-Source: AGHT+IEeQqvGA5rIXPU5iu2ORUd4aywGoHdMtzkGZMYxdBSKRb8E+NY10yY/CgtCC52MeEWqEoBMXA==
X-Received: by 2002:a17:907:94d2:b0:a77:d1ea:ab3b with SMTP id a640c23a62f3a-a780b6b2f2dmr254648366b.25.1720561189519;
        Tue, 09 Jul 2024 14:39:49 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a85603fsm109878066b.176.2024.07.09.14.39.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:49 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 04/44] multipathd.service.in: use @BINDIR@ instead of /sbin
Date: Tue,  9 Jul 2024 23:38:55 +0200
Message-ID: <20240709213935.177028-5-mwilck@suse.com>
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

The path in the unit file should match the actual installation path.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.service.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
index a63ddd9..646001e 100644
--- a/multipathd/multipathd.service.in
+++ b/multipathd/multipathd.service.in
@@ -16,8 +16,8 @@ ConditionVirtualization=!container
 [Service]
 Type=notify
 NotifyAccess=main
-ExecStart=/sbin/multipathd -d -s
-ExecReload=/sbin/multipathd reconfigure
+ExecStart=@BINDIR@/multipathd -d -s
+ExecReload=@BINDIR@/multipathd reconfigure
 TasksMax=infinity
 LimitRTPRIO=10
 CPUWeight=1000
-- 
2.45.2

