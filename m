Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CAB2673B0
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 09:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088138; cv=none; b=T0KBM1Vkimt75BWmqxjs9YsZR4mMMZGTI8ekx+PPUx3fa6Ugm1AIDYwESr/Y3s3hRJ7QoNIXrZhr9yAo2qnHJEt4J3g1+zbf3yI8HUblU/m6s/YdxhAU5IxPS9/MkYVxBha0yWcOGpcL16xlubE+NAk4Z6p5pDuREKzjm08SbUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088138; c=relaxed/simple;
	bh=hpCycCTh/HJ3uTrrYDxDgwbK6io7B+6ovUZqwgI3LSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufW1KYkXFD2diaNz6bll0ach23HUbGCzhFBBj2Hn3ucoTv/hqvm9RpEOfoG4S5XjklhtZAAPeQ5XaTttZffMyg3wm8bZ/arhNOZhQ+G92LgOTg2Sj4LO+WlNJG/M4oEU700S3Tx3u90Ki0jlE0l29w50zFtbYjBaOR0ubHF7IEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJ5x/Uxt; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJ5x/Uxt"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-40d0c517f90so83145f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 02:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760088134; x=1760692934; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hlkF4SD1tQIcLrsY2scOLvso+PaT9x3Qpq/1c1+GU8=;
        b=nJ5x/UxtawMUuzI+Zp0TqSk+47uEo1QjPyVqyhMEYGhcjnBcvTWh0vqXHaLGc2xTEX
         yCXpMQPcvTVnV2h6xuXpimaiL7bDS4bRBF0aMaaeksfTIq4idemNTnyWHNx+mf9OOYU8
         FtLkpFWZ1BXpRkVTvga7HVgmk3nJmZixvC/Yz3mwUpPnH/+3n6eWKMao/+XkKXMnZSv+
         s9NoK++UC5+2Hw4ZNGnBrEVHq1Zzr/hIwxZTy19asPrdvfqkKHeW6p8kcwPgF3IDlzCG
         d5LMVTuNHwOSGKS/+HdeYh5sbhr2A5BOJeqzy32xvzeEldoVTklfJHyIt4RUSPdP42js
         t8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760088134; x=1760692934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/hlkF4SD1tQIcLrsY2scOLvso+PaT9x3Qpq/1c1+GU8=;
        b=uwrixz8cX9YOPkQxKpcI/23rl/sQ/z3NRR7QgC6MRfKTvlVhZwLImss069FOj+/q2K
         uOK8u2UZF4sPSoppPUOqY6HV4IxDWN5fF0k80yVUfUjnBtV3hgawDfAH0+nJOXk34mIS
         eH4uryVdjC5SiS7wma6Zekx2tAWo7gu1b7z5n48AcbYnVDaFxYrEi/qGXqQSjy0NetMN
         ISDXjgOrSeoIfyxofsEqIXQgNUt/yZI2QDKkJrpaJCOPBQc0+EgOwdqvyLysLvcK4DXD
         uxcJCumEUIc6BvIgngFTSuIS00XxQDWBZy85L3iRmzk2luGvi8trVoEwmEyCWpMM+FP4
         hR/A==
X-Forwarded-Encrypted: i=1; AJvYcCXUlg2o2OX++0/6z6VIXdr2OYVl2Ecwr7F8Elu17BShXxTtd0kRuMmhVUsKokXLvmYx2qxPqxXDPg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMLPuT5m9eDD0QArX8nBGd+/LkRIAcUIyXMYdO45A+s01SLj6Y
	Fvvyc0fY7Hsi9KxWit9q4x5HBg4UHZFcebo84z8FymoAV2qNuk7vSXs=
X-Gm-Gg: ASbGncsNoI+t1Jy7jF4QoSE1BGBnp7tBLTnCUavrvXLKiTmOX9LVnVck0aGInu5/PcA
	ZepDfbSi7yvJkeNfVeG+Yj6Hv9eQS9kiZ32xuFO8dBOZEwEnNVkvy7AaO6B4Tau7iHyA8MClz1R
	+cdT93JjYjm5eTcrpSjQXj8+bI9URKGTpnlEzWVUjgxgCwe/TEKYdzTordX8N/AmrZ6gkeOcixv
	LMceycSsv+QBWEpFkc2PPL++UkXeQaRpr5p/zfBPf+ze/OPShpbD6rXUsVrWNi3j4kVkd+V6ox2
	skoTxw6uS1UbXH7Mo25wSvQPWvVkacKWpPRwhYPt3fdb+0Dg6jj/SB3IkSKenbX3KkNtr7H4UsG
	1pKdmUEJMwqBlw4dj22AZHBNkevDDwsY42azY2cTFA41Ltq9g1zxXfXKMHh+YWHxHFrcqTuSfzy
	6GLIBAQdOVy30MlZ8K2LHqWz3YltXJ7KA=
X-Google-Smtp-Source: AGHT+IE0HotC97id4QqF0ZgNTNFiay0Rjc0qL9xZcId88vW7ypvNSVvgjwKuKU58IAUqF5nzRncUcw==
X-Received: by 2002:a05:600c:1993:b0:46e:32d8:3f4f with SMTP id 5b1f17b1804b1-46fa9b19669mr38332015e9.8.1760088133934;
        Fri, 10 Oct 2025 02:22:13 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e0987sm3174032f8f.38.2025.10.10.02.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:22:13 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/2] multipath-tools: add mandoc check to man pages
Date: Fri, 10 Oct 2025 11:22:08 +0200
Message-ID: <20251010092211.57426-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010092211.57426-1-xose.vazquez@gmail.com>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
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
 kpartx/kpartx.8                                | 1 +
 libmpathpersist/mpath_persistent_reserve_in.3  | 1 +
 libmpathpersist/mpath_persistent_reserve_out.3 | 1 +
 mpathpersist/mpathpersist.8.in                 | 5 +++--
 multipath/multipath.8.in                       | 5 +++--
 multipath/multipath.conf.5.in                  | 5 +++--
 multipathd/multipathc.8                        | 1 +
 multipathd/multipathd.8.in                     | 5 +++--
 8 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index ef8051a5..2a55c96b 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -2,6 +2,7 @@
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t kpartx/kpartx.8
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z  kpartx/kpartx.8 > /dev/null
+.\" mandoc -W all -T lint kpartx/kpartx.8
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 6d7fe129..ef6bd1d8 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -2,6 +2,7 @@
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_in.3
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_in.3 > /dev/null
+.\" mandoc -W all -T lint libmpathpersist/mpath_persistent_reserve_in.3
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index f49bf444..80c80d41 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -2,6 +2,7 @@
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_out.3
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_out.3 > /dev/null
+.\" mandoc -W all -T lint libmpathpersist/mpath_persistent_reserve_out.3
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/mpathpersist/mpathpersist.8.in b/mpathpersist/mpathpersist.8.in
index 62f3c5b0..cb56253f 100644
--- a/mpathpersist/mpathpersist.8.in
+++ b/mpathpersist/mpathpersist.8.in
@@ -1,7 +1,8 @@
 .\" ----------------------------------------------------------------------------
 .\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t mpathpersist/mpathpersist.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z mpathpersist/mpathpersist.8 > /dev/null
+.\" groff -z -wall -b -e -t mpathpersist/mpathpersist.8.in
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z mpathpersist/mpathpersist.8.in > /dev/null
+.\" mandoc -W all -T lint mpathpersist/mpathpersist.8.in
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.8.in b/multipath/multipath.8.in
index b88e9a4c..52e45df2 100644
--- a/multipath/multipath.8.in
+++ b/multipath/multipath.8.in
@@ -1,7 +1,8 @@
 .\" ----------------------------------------------------------------------------
 .\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.8 > /dev/null
+.\" groff -z -wall -b -e -t multipath/multipath.8.in
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.8.in > /dev/null
+.\" mandoc -W all -T lint multipath/multipath.8.in
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
index c7e944c0..67cc2e54 100644
--- a/multipath/multipath.conf.5.in
+++ b/multipath/multipath.conf.5.in
@@ -1,7 +1,8 @@
 .\" ----------------------------------------------------------------------------
 .\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipath/multipath.conf.5
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 > /dev/null
+.\" groff -z -wall -b -e -t multipath/multipath.conf.5.in
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5.in > /dev/null
+.\" mandoc -W all -T lint multipath/multipath.conf.5.in
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index 3396576b..7444027e 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -2,6 +2,7 @@
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipathd/multipathc.8
 .\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathc.8 > /dev/null
+.\" mandoc -W all -T lint multipathd/multipathc.8
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 2aaec2f2..2db200d5 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -1,7 +1,8 @@
 .\" ----------------------------------------------------------------------------
 .\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathd.8
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathd.8 > /dev/null
+.\" groff -z -wall -b -e -t multipathd/multipathd.8.in
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathd.8.in > /dev/null
+.\" mandoc -W all -T lint multipathd/multipathd.8.in
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
-- 
2.51.0

