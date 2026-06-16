Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A839135CBD7
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 12:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781612962; cv=none; b=gv7BNQYicZnfPuPxwNAAhxHHdUKkDD5EYjjDlnNgVVL5tTSPBdn74zFR0+eZToKNeL5jMKjN9egsVoNLEhhj2g6aKSMiwieXu4qf+7CKerXH3p255YBqFCxxs6E2W8PQx8lczFsYQCWOUgtT5BV+Dm4wjDrgxiuH/Fx0AzJFSW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781612962; c=relaxed/simple;
	bh=EPo9MqFwd3g8QBcrSKo0kHhaYSdqqcbRcr1BKYDKhis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCI4af1XmuMCr9Mo0p9digMenslyJOFmPLifPmxYfVbC5oHX3lqZtKhF1MoMvtWlez7zA2SxNaukktwJu2nN9+91PnHG6LLGeBjBZZC9qQQnHTt7HDCLe4NCYbLnze/deuE5EzV3GVSGnZqhr5nssd1QnKC8icTE9p1UDV/LRGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=La0Zlwh/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="La0Zlwh/"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef4332d89so231688f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 05:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781612959; x=1782217759; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27Ya0B/cyv9jJ0xkkollEps9gbMrbAPucLjqgxhCC9k=;
        b=La0Zlwh/iJs+DkvtlJTbEs1/9jmzSF6j2Fz3oczDgXsqOTvQb8yEMv/yP8kWgpui8R
         dPsg/R2T+WKpn06CjnErKBi6+231DSHf2PDGYiLKmnJaVIPUBBGhPCCoOAjP4P7wThm2
         qGwUAgO3CsOKw9i6UwiiLVDiJKySzgcOexzEkSp2HUMFRazbQj7pkoy4pZAYOgTPzAWY
         hyLeeHQM6OgnawqwG0exExApSZlUTmsOD88hqCNlDCbHlI5mI7nCBXKQPReOuqVKUqgo
         qM+4MZYA0e/63nxGB4olIwtWhGBE9lHReM8V2HKdUInOmlWjb5eFGV+FbuHnrdpuSyib
         10Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781612959; x=1782217759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=27Ya0B/cyv9jJ0xkkollEps9gbMrbAPucLjqgxhCC9k=;
        b=mL4BnpHW+Igdqah+BH/qOwZPq5fxstCzetn6XcVQa4KaaICoUgtVmpP+e21Q4R+JWg
         MhAhoZXDZPRSLZXw6QYYr8y8iBO4Xp5naOD/P3qWH+6JCeOMlJMc+GKmy41un/cGs41s
         XGDEtUen/FrGd19DXKJEwds8f76ZFKOZX/XMILk4D0+X7UQ7sAjSaYGHmBCHMPEwOXpC
         3/lh/h5hZ2VG1YjqHsP5/XFn0bUQwDDE6qzm0JME90weSgA7gAI27dMbwagg6rXJ75BW
         DDE+CgCYHQzLz6uHdIiYfMcmHWxGgkUFfrZWVLGtr7NXfgY5AMTf6CbI9KWo/7HmogS1
         OIPw==
X-Forwarded-Encrypted: i=1; AFNElJ+QWd4yxJCk6sA7Gy+uVicMmcpyxep76HJX1bPRXgkzOva2/eu7L79Bri2p1tbHF0t4Lx4ji1vS3A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx55HteWdFsNuwzhUP1BDJZaikOnnM7rT7i8o/nJSdypfgyKbdx
	GbSI9MiunOXymTpd1ysOtsJHh0j+C/PcpxOHzbXD1Inn+CyOyViqHkw=
X-Gm-Gg: Acq92OGkFCp6FJOlnsKgFHJsTUWqoLzIeT1ExVDdYwQzDuGkLI6eTLkxy9sSFg8C9yx
	lnGB6DrNqYKp8AFPB8IJZyW5QP3fOVz2azFGl1YXx+r0eDj4GJe7+xv12d3kKYxFUNfI4e0MgzX
	lPduZ6jGtawbqVmXf8BYWiEISLchzd/wURRMOyM5a4jY+KkhKXBGmefWBTExFA6XuZZ0EwrGRnZ
	adnKBQ1LIdAN1R3qS5M2OwaXnpE2Zfd+nd+jHQnLi0zeM/6ewriXu+zQKZ8Ig7e03+RUrFMybR/
	0LAFYG9ldT0lJq2LLeaatgK3Uq5hEBo97im4EfC/60asRkGktiwJ2fP2H9L1DNfLr0/4fRI8veh
	M3jdrbOB32308sk+wOVmDDcZZBnkXA6Eu6d+/NTguZiBToxpSDElbMmC6FjuX/JGTuqO/uH1Ef5
	xQo4tU6ElCPx1JJA2VPplc7L0V7Qd0yRqoNcFi3QfLBqkxxOK2403jCwc4TZkAhoC2
X-Received: by 2002:a05:600c:3b9f:b0:490:e919:7bba with SMTP id 5b1f17b1804b1-490ec50affemr157853045e9.8.1781612958968;
        Tue, 16 Jun 2026 05:29:18 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f263945sm45328824f8f.8.2026.06.16.05.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 05:29:18 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 4/8] multipath-tools: remove syntax check comments from man pages
Date: Tue, 16 Jun 2026 14:29:00 +0200
Message-ID: <20260616122909.244619-5-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616122909.244619-1-xose.vazquez@gmail.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Remove the embedded groff/man command lines from the header comments
of all man pages.

Suggested-by: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 kpartx/kpartx.8                                | 4 ----
 libmpathpersist/mpath_persistent_reserve_in.3  | 4 ----
 libmpathpersist/mpath_persistent_reserve_out.3 | 4 ----
 mpathpersist/mpathpersist.8.in                 | 4 ----
 multipath/multipath.8.in                       | 4 ----
 multipath/multipath.conf.5.in                  | 4 ----
 multipathd/multipathc.8                        | 4 ----
 multipathd/multipathd.8.in                     | 4 ----
 8 files changed, 32 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index ef8051a5..fbc8f726 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t kpartx/kpartx.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z  kpartx/kpartx.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 871242d5..5109fb03 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_in.3
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_in.3 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index bf44777c..09708b93 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_out.3
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_out.3 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index 9a5a716b..d5f5a452 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t mpathpersist/mpathpersist.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z mpathpersist/mpathpersist.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipath/multipath.8.in b/multipath/multipath.8.in
index 0b170101..da5effb0 100644
--- a/multipath/multipath.8.in
+++ b/multipath/multipath.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index 6990d2bf..422ab120 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.conf.5
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index cf7ae5be..5e97fb81 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathc.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathc.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index d766dc65..93625a90 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -1,8 +1,4 @@
 .\" ----------------------------------------------------------------------------
-.\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathd.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathd.8 > /dev/null
-.\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-- 
2.54.0

