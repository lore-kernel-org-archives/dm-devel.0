Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB98B2E718B
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563183; cv=none; b=fXt2eo8s46dKpan9GgONQr3TF1JG8NCvfGTmycu5VYt3pQQjJoUmqyhNf0e/4Em3DMOVxO6xd46W7K6sP9cuVVfpG3N2uBR4dlrOuvUjpdidojXYGdCQTMKacFHM2Zx1DB5Dbg7QaZ3eSvNIP6gr0tKhx7HXDQfQXRBWUmPWQBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563183; c=relaxed/simple;
	bh=74emLXp/+J+E10JcvFCb9XdwkaK2Xb1aJ33Ft+lgl/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+1z2xk7dafstTKlT4o78QATHS3+JxL2GNhpSFR9+AHu4gZcs0ljYJw7O0sJ4boAxqZ3eKeLaRMUmWn5/0rjbKSxQPvwZvyaWfnHAvXN0GQcSWVxU2+qIiDJGVq9npkAC1WLIhWt/op82XnnHOv6w1Tqrt7pwIzriS3rV/Gyfv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nd4OFfxM; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nd4OFfxM"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-432d2c96215so1614320f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563180; x=1769167980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SwlLpE2jsc3V4vniU50ENwYEylQ17t4SOkAhM9WbmI=;
        b=Nd4OFfxM2FjJCnaFbo8yJxk8wGZkFcSiu5wOSnunpNh5vllnzJsmWnNyuGaXC7vFtR
         +TfaFx/a54RAJTxpwIjJgw/DZ962/rRRuNCcZprAIqeYVDBkFyfWIag/P3vP2H4Wj1CB
         in68cnCFspuFsQOqEXqpbqxV/BBKKdUNBkyTsNmQxIN+XbyGHnx+8YeeuUxChhMm8LbS
         hirQnl3VlUnkLbCXzfWc1pZ9NjTnJ5DQFXSCThSdBTZYqZsGKNolIxmvo83kumeijmaH
         2TDrZNNVmH4OPxWQv0HpufeDMY55v/enNzn+ReVMw4DNef8pVdg3bm+o2VOmL4dsOdbd
         zn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563180; x=1769167980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3SwlLpE2jsc3V4vniU50ENwYEylQ17t4SOkAhM9WbmI=;
        b=auXfQB3AsKo0a0XV6GGSDaSyy6FtgAOLb+SALhLaAw0NJBytoBrM+e1T02Gcqx+C3F
         zwm1u/VV3wgm5BJQpa6Xytm8Rhw6eL02968/DR9bbQ94/YyNEc0Svv1prP7l0fHiNGhf
         MDOo2UNWO77X/rAPEq+M6PYmqPS/+AS2f+UHYsfC5bigJAtlsQoZRJqiSPWkuFT1YeIN
         sXBslZl3xMzoU7xS/D4m3YRrYAH4ObTJ3i+gg6hdgtx08OA1kG9GSA0uyhMzWJt/JqRX
         VvgpIrN8P2x5+HgjOiTANrbulH+bSisrStn8WzZB1OsLIILZr7hDlfJntc/wJLYfolNs
         ufJA==
X-Forwarded-Encrypted: i=1; AJvYcCUxB6YoqT6TwV0PY+V1iPwT2slxC3RNVGFu/gtq87WKCL9MkuQaCYc6ydcIFfbD0PKBO7vVlTfctg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxI/13Kz1fE1EG6cU5fvRK8FWtRgHakvUMBxz1VOLSxuxnJ4L8Q
	pPCzdiQxXLKo0EUS/Is4BMLk46VV+swGrmINeo6N8x4IRueKLrTMyiqhIPwf0+GJB4VW800VLKP
	uhw3R
X-Gm-Gg: AY/fxX6508mO5xrfPcijRrYxlHm8lbDNRi3klFscM1WopMmm3Yi9lUyiHK6fD9VCajL
	mRAt91LnGyqkjr6fbkhe1z/tDstvRzYkg7I+liFQd64JyKcfzGJCRekLpdUFASkenka8LADO52w
	1jze6Pa79Y19YKXVb1DPBeGw61FLJSiKK/2UadgL8qkPA2Igkyx30rWqxmjBEuDZEIAOLiUE0vE
	BaEOQwNan9o9yfZKU+ILYVELfCPDjlgWsl8uWZ98oE3D7c01Oj7tbvH+HECfuoaH61PbBGtdMO7
	nciYXBz98UknjDPjqQMWGf+gnXIEwUVkee2wPAeN/xFzYUpsvRHJqk8uNG2MtB+8CraRCDYOcvG
	Qhrss83c1bpnF1kLu1pxpWpO0i6G9YRRGtNX3qwhCwbtFd9sUChCqIw/0bjiEC2VdCWjhlN7jOh
	d8BqOOjgG3BOJqir36tbxkBetL8JJybMg+f7Yujn4PRs69oh+dBezOt3u9SP+AVbls/xi33ylnc
	UG3lblW6DrF
X-Received: by 2002:a05:6000:2512:b0:431:32f:314d with SMTP id ffacd0b85a97d-4356999982dmr3342457f8f.25.1768563180255;
        Fri, 16 Jan 2026 03:33:00 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4356996dadbsm4677655f8f.21.2026.01.16.03.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:32:59 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 1/5] kpartx: avoid double-free of mapname
Date: Fri, 16 Jan 2026 12:30:38 +0100
Message-ID: <20260116113042.140719-2-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116113042.140719-1-mwilck@suse.com>
References: <20260116113042.140719-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable mapname is sometimes allocated and sometimes not.
To avoid double-free and still free allocated memory cleanly,
introduce a helper pointer for storing possibly allocated memory.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 7ec89b4..6f2ec4e 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -245,7 +245,8 @@ main(int argc, char **argv){
 	char *loopdev __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *delim __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *uuid __attribute__((cleanup(cleanup_charp))) = NULL;
-	char *mapname __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *_mapname __attribute__((cleanup(cleanup_charp))) = NULL;
+	char *mapname;
 	int hotplug = 0;
 	int loopcreated = 0;
 	struct stat buf;
@@ -388,11 +389,15 @@ main(int argc, char **argv){
 	off = find_devname_offset(device);
 
 	if (!loopdev) {
-		mapname = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
-		if (mapname)
-			uuid = dm_mapuuid(mapname);
+		_mapname = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
+		if (_mapname)
+			uuid = dm_mapuuid(_mapname);
 	}
 
+	mapname = _mapname;
+	if (!mapname)
+		mapname = device + off;
+
 	/*
 	 * We are called for a non-DM device.
 	 * Make up a fake UUID for the device, unless "-d -f" is given.
@@ -402,9 +407,6 @@ main(int argc, char **argv){
 	if (!uuid && !(what == DELETE && force_devmap))
 		uuid = nondm_create_uuid(buf.st_rdev);
 
-	if (!mapname)
-		mapname = device + off;
-
 	if (delim == NULL) {
 		delim = xmalloc(DELIM_SIZE);
 		memset(delim, 0, DELIM_SIZE);
-- 
2.52.0

