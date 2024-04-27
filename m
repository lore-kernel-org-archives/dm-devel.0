Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F03027721
	for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 23:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714261551; cv=none; b=d8eUBKks+nYUfcREf/d/HC6vplyx1EU4Et8NB6J0aSMKpTAuMzZPj6Pi+dsv2P/Qr3Nr7J82FytKbfgAz7BUyVqkn72kUe2Tulj5XfIRijWwaDYIPYX7uVLNbgCcK9KGpxt4COrigHwIlv8xpM7K+7les9VT7kcc46zWwAPuYgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714261551; c=relaxed/simple;
	bh=HOKVj62CDiMfTNFRET4qv0sWHqktGXS8ddPZw9B5jUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSmTgrbECS3vi4tBNF7s1qWuwK2CjCXMXbzAJvZ05eBoD0TO71Q4qi3zNDGulFuQV/5GH0y3IpRNlM4+6PdBOjDPFriUaa2ceNN7cox7e43BLFloUu9mWWGWGLwR2K6CbJ47/JKO+NJa+dmgDcJpxoLl2hvrzCVhSRFS8BwYNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MyyukDem; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MyyukDem"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41bab13ca80so10850825e9.0
        for <dm-devel@lists.linux.dev>; Sat, 27 Apr 2024 16:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714261548; x=1714866348; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ifISdLef/z0S0ngYZC/RyxGqJbtDs45RURvdpb1x2s=;
        b=MyyukDem/93wM6LOaFcadfXYZML1atV/cH9NrIt+tscZzb15Dsv6PTUQXBRueRz1/5
         VcUo2xORLN9V8B+t0Qqvc+sZYT8q5MVxvKdF9uRq7xTXRKI/3GFL2zB7QbB+AcVUHFNt
         KrFuCOjzsLuC4QPxAkQ0j0xSmB5YxnGWsxw6TNqoGTEixV5nc56+HvGE0ErYrzsr/Djz
         oW/oLM989BkWOtgqFpbJAdglWqbYN7SqpalpcPzO8oAPlp3F+Re7kPOGYtZTDR7wC3gQ
         +vLDjwas5MtZrtj6ZJJwX2YSh5mc5EZ38/PbPvopTzvfHhRGpvNxw9l+d9pZ1QYsd6LA
         63kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714261548; x=1714866348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ifISdLef/z0S0ngYZC/RyxGqJbtDs45RURvdpb1x2s=;
        b=VfoG8M5/TDtOHRteVb64jcs/L0laLg7CkZ/Dc/rwbZD9e73tEm2mmssKJ2YtC9RHeG
         K2xprWGtt2rdlFVPYeeCCuU9AqBck4zhHQ/EFzPZn3+Vft4q4NS6PVuJuHfREZ4zv3tW
         Razw4ENG2icAptrqH6Ie2QkOEq0TdKTEO0icFC7y7XRJ20aJwbPmbp5ChG5vCbXzx26m
         E5vHOAGL4e3yha+imCXo0dsY+LkPAqyGZlgk0By4NhxubKTVx/tlKpW6uDrk7GibXuqe
         K+ThXVvPGlFx2W/IxuyVJhkD5VpXJLM/XKZKUIs4kN1W7HDyrypzRVotO95M2+g6fNc/
         yEJg==
X-Forwarded-Encrypted: i=1; AJvYcCWNMywkOq2QEHU2KRY5cgg5iad1VeLcAHfOv2QiFWSw08jXRp0FrymtjY+O5msMXv1GtC+Qqsyeb5eJxB+KHjUhmEqnlPDvKfU=
X-Gm-Message-State: AOJu0YycUGYTEDd7R3IoW0SD2rl15tdeqIm20Dq+fCAN3KM7WooDvKAw
	zbgBJWziZOdo1/Fa91UVfce/U0sMFfaAgioRdnP/7wV+PMEQnho=
X-Google-Smtp-Source: AGHT+IEOKBTv7VTD/iNnhxVe2/xYOvmw23Z956PoJBV38wyLaUevaLS0/5x28w9GGA/YxKBvap3GqQ==
X-Received: by 2002:a05:600c:19d2:b0:41b:fea6:6526 with SMTP id u18-20020a05600c19d200b0041bfea66526mr938814wmq.33.1714261548162;
        Sat, 27 Apr 2024 16:45:48 -0700 (PDT)
Received: from localhost (11.red-81-44-148.dynamicip.rima-tde.net. [81.44.148.11])
        by smtp.gmail.com with ESMTPSA id fc19-20020a05600c525300b00418981b59d4sm40053551wmb.10.2024.04.27.16.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 16:45:47 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH 3/3] multipath-tools: update man pages dates
Date: Sun, 28 Apr 2024 01:45:37 +0200
Message-ID: <20240427234538.8025-4-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240427234538.8025-1-xose.vazquez@gmail.com>
References: <20240427234538.8025-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  | 2 +-
 libmpathpersist/mpath_persistent_reserve_out.3 | 2 +-
 multipath/multipath.8.in                       | 2 +-
 multipath/multipath.conf.5.in                  | 2 +-
 multipathd/multipathd.8.in                     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 6cc35349..4ac43fa3 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_IN 3 2018-06-15 Linux
+.TH MPATH_PERSISTENT_RESERVE_IN 3 2024-02-09 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 70e26028..3dbeae1f 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_OUT 3 2018-06-15 Linux
+.TH MPATH_PERSISTENT_RESERVE_OUT 3 2024-02-09 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.8.in b/multipath/multipath.8.in
index 348eb220..b88e9a4c 100644
--- a/multipath/multipath.8.in
+++ b/multipath/multipath.8.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH 8 2021-11-12 Linux
+.TH MULTIPATH 8 2023-09-08 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c1a19ebb..46d3685a 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2023-06-15 Linux
+.TH MULTIPATH.CONF 5 2024-04-17 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index f1cab3ff..12b77156 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATHD 8 2022-09-03 Linux
+.TH MULTIPATHD 8 2023-12-19 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.44.0

