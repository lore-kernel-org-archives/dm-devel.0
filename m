Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE431E5B65
	for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 08:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742547286; cv=none; b=Wz/iUKFy7paabEnzS6jsqABmo5ILV6x6iWIVpADABJL7KznLy6T1+0rJ84U3K08Ol3RkKI7xSneyUgJKwsXEbF4cNW3wB5wNk4d2/3oErqJLe7ifCKolMfBE/+JnQVSo5A4fLbGnKESUDrz/XrNBGM6m1dQUbOonpgzNiBkeNgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742547286; c=relaxed/simple;
	bh=uQf5EoukEtEGKDhHUwjn3a0GRIZk67OhXB2rpMWksXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K1pGHJ0zdjs2XpUQ4sUiayd+UkSlkfyaUhQrJam9FgT6awYuDlt3lQ4+tQzDqLA5eFAVqLc5RerS2uUedaXsIu2AV5S0PHDNORE92Rw6rD/0ppbWeugv5AQFq2sA83fqsDkpd0RRohk+lnJOYAW1RjWQEbj+6L1yXAqY910xvaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhJcYxrQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhJcYxrQ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43938828d02so2528315e9.1
        for <dm-devel@lists.linux.dev>; Fri, 21 Mar 2025 01:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742547283; x=1743152083; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+V8lQnDtSecfg0tB5n6s12bgZBiw3lhOeY7V7DU8gds=;
        b=LhJcYxrQlIz9m0/SYl/r5AqZkpps4n7dGlracHqSI9sGEM7M5FWn3ZfcH/TE/EQqZI
         R43MDMkv/8wSd4D+ngP3nIhfFtrhHcbEPgudICJwKWVDaQ4Y9grVII4M6wItWxAN4F1C
         dtEKFIu+GuywWR71VwxruX81fuvEuJjscY31hlSSnk6opxEo5AqnEAfOlsq+9R5eG0NY
         LuT1gLdYUVmhb11hXFfTdYJTXcHiMIsE2eAIfzKLBGNrsgj5oQcD1y8bfNM9PfG/eNHv
         HbG9lF9pR2AOB6i8f6gVhiE4Oo15GDCS1tkK02gtFkktvch6o7ELMBrUgONqs+wj0u7t
         DCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742547283; x=1743152083;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+V8lQnDtSecfg0tB5n6s12bgZBiw3lhOeY7V7DU8gds=;
        b=AFE/n+zgWV8KA1FtfitGoDffJN6yoD7Rb9BIlpMJQLdvaDcJXi69rSPCBHa06LT8ha
         Jptv2ikPGspY5TW6q5JkFRQnHeSzW22wYrpVNAm1q+Crl5AH0kV4Nob89BoGA9eLsqaJ
         gEaoFElciY8s+wlfJ7jdjzH2bCtU+i4DegWB8v8CvoHU46CcXCsY5LJWwCU0/u5XitMO
         mc/zHbSW5QnZItKdbokUnHK4uJpIdxUAw/ECnLOfkTvsaUIpM23KEEqJ8L8a6hyiKeFJ
         bnn0Kf0XMtVAygWtGXEfOGaYJCi6IKS4bEZ9H33OzcTUQMkO/KkSEJkR+Ml1m0gPbnZ9
         qeWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6kaoEL7mlkG2gZZQLxRk9kHCWjAuLP2eyKKd7mMPiFBV2bLkQdEkIz6LTlIUTWgWIb2ZpQEYdBA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxhRmZaY248ss4AyCtqID6/hB7vf3DfomGlsuwDs7QmKob687g0
	o4Cn1kVm+J04gy2N93Rtbk0BUvVSLnThB1J13UIx08KrMGw7QiE=
X-Gm-Gg: ASbGncss+GPfYK4TYs54CnE6BedBmijPs5QSeKu7g1iz/Xjfze1WMzwS7wKXy2ONjxV
	wQSOJE6CRqhVnc3B3lDNqgn2DbaTxHgeQJvQWhiYuFjZPj2JTXpVljQyEESUm780WUkPBAkyWPh
	wWtMb3BjEzYGYkqMqkDE6CqRf4WE1WFdoDwTixSrfskd7KCmng3JeDv8p8Z4yaJ2aE8VcseGz5e
	o21hl9LjLaIbgobJZpF5qnhmd2nipQyMXUQD9r+N2rES4X+hAkzsz4qGeU25m4qvmIazJ0clQEW
	+XfRPYC8rS1s+bycbTyXRNZnmxqFEoLs+3Ie7pYHxMtRazmgVrsmJQtcrsRo0n/E6T12IWCxknk
	o9aV7YLwSwDctqsBII5rFdgU=
X-Google-Smtp-Source: AGHT+IFFwegEIAk+m2LlkXPBjix+1tCPwljl4xcjSPmwvsChFZmuzLtAr0t0BxEwxAa1xt9l443dOQ==
X-Received: by 2002:a05:6000:156e:b0:38a:8784:9137 with SMTP id ffacd0b85a97d-3997f9368b0mr1035743f8f.9.1742547282530;
        Fri, 21 Mar 2025 01:54:42 -0700 (PDT)
Received: from localhost (242.red-80-39-144.dynamicip.rima-tde.net. [80.39.144.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9ef16csm1750748f8f.86.2025.03.21.01.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 01:54:42 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: add .b4-config
Date: Fri, 21 Mar 2025 09:54:40 +0100
Message-ID: <20250321085441.16968-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

docs: https://b4.docs.kernel.org

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 .b4-config | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 .b4-config

diff --git a/.b4-config b/.b4-config
new file mode 100644
index 00000000..cd440059
--- /dev/null
+++ b/.b4-config
@@ -0,0 +1,5 @@
+# Configuration for the `b4` tool
+# See https://git.kernel.org/pub/scm/utils/b4/b4.git/about/
+[b4]
+	send-series-to = Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
+	send-series-cc = DM-DEVEL ML <dm-devel@lists.linux.dev>, Christophe Varoqui <christophe.varoqui@opensvc.com>
-- 
2.49.0

