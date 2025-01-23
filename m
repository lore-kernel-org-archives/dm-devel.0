Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B7F1CDA3F
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737670345; cv=none; b=QLGN9i1EihH6z2LBWwoWAaxwOghmBpTh+QF5CrprrozIdkQ4W6TmElTPUAf7NMZrUNanu1mihtZXWqCNosZRE9I2mNRd6Ie9BNG04t7cO6OlGd/6loZg/bgUOxdvnltdag/HilC8rcI3iO0q2eIAsDtfSMD053oj+unXU8rYQt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737670345; c=relaxed/simple;
	bh=6V6FTwbs2/OI58f8/GmMv6XG1SkBQSDKWU8UE3P76bw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OaoJO0rulmusC1j9IhiX2AQHoTQ/UIOiv/gy1M+KXcdnfxslBgDpK6AvcdEfVOAkXewTSAg6EjCKt0MnFT39A3cyPuhg2b7IajenJH+j7Qsv38ge4AILIgOoLPcWBVrCM46pnzKNGiIoVKP1kL4FU+Wl7xgLrQ8zTh4HhpmwUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BD88LtPg; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BD88LtPg"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385de9f789cso1133559f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 14:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737670341; x=1738275141; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=crVIgoH21JoZ7BNlOvPeD+cW+R3XGV+stmlGB6daMuw=;
        b=BD88LtPgU9q5h1JIDJJO0A8IruA0ajlCm6pDIgJjFhDZOsnB1+XfukKTbE7pnkqZqJ
         1snMR3x0e7mmkOCqQb5mRk5V8csJTHExYToCNmNwlPnnvbZDOQP0Tel70r9B+EMvjHdq
         IpxoJUjtf/8bpXEJoaXSoRbbrn/pyUWh1X8aJn+l29YpxcLTIe6WWZbt5b1gBVm5fx/a
         67zypbVMlllfCHJAz4nBsb6ZW86Do8bQSuMqeBmr6vtE4I7ygMn6uLBQ/uH7NHlMWRFM
         Hh8xj5AVb/4eg6Fa6XSyl6F7VRBxBhaTQDI9WiVcamDEPyp+NfRlA0SoqpxezxrhR4rw
         OR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737670341; x=1738275141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crVIgoH21JoZ7BNlOvPeD+cW+R3XGV+stmlGB6daMuw=;
        b=gj/0n9s2w8DMItEIEEMenyDFGvdwbMQ1c7kBgCZ9jdoSp5lZqI3LcAT+FgAD+9K8Vr
         RZpGLu30dBax1iT5nG6UwW8/zhZsog9skUC8zvO96HrNzl63uiJNH+gVEnyxzT499IQD
         4zQjzht1vuZvdXxDcus877fLsoQRUHdpL2lvw4VGkWrgpzAvviiGD6qYyrJDz6N6Iodc
         sJUyTsPyGXCfuroW9ghBn2PiWC1Q53vnc9KhD7D4OxBF3KSAHlfmzwwcj4WYDa7yzm0q
         ZD4xdNd86ipAxBuaJiAk31mI9UBo4FWwgdjfoR7a1RS46L5wWpTbTd0u1d32MMIkCgMA
         W+wg==
X-Gm-Message-State: AOJu0Yysc35bpv9RyLBW4oudLiw4HI9Az+JBWgnObHQ8IwNuxL68aSfN
	sMiTbQoZfNWL9ZK6F1cEgACJW/rJ30uItFEoqz2ux0JtWPKZxxDobQpf+s/vURK9ADSIH+LwG6u
	F
X-Gm-Gg: ASbGncutFnZKceS+Nu+3eMYRpNQzHuzJFfxpsQLjFQznMBC9farfmqBPiZziHFpQEEM
	4v36U5rT1AP4JSmZKpSR34xlvoZhKz9yGeVeMsHQck312Nq4AlnDX0bTc2JKRiNVasXb5/JNBq9
	UsB+NOd1V1yYJT1TSl9v806DkPXtoFzcY9MFpfcRX0T/kzxF6ngxIXbiTIIu0x8AWAJ9JKJ1BYP
	KCl/VOhkTZCFaYog8B+f1GJzvI/IR8GODsH458o0lAy3rEncH2nzgNrv0mNv/y+wh8fHy0UwV4f
	1qVJScScdeQbSoo5PwciTgaHMbMUKbRnWjINlqi73r0eh0O2FWKa3yeho7+AD8j5p9U=
X-Google-Smtp-Source: AGHT+IFgj1H7trSSlHwfzyYEXHC2OCJZYejgbyhOfXQNmnCdnkkUDtgwOA0L8nWpYuU+YER2o01Udw==
X-Received: by 2002:a05:6000:1aca:b0:385:fb8d:8658 with SMTP id ffacd0b85a97d-38bf57b7fbdmr28375589f8f.40.1737670340631;
        Thu, 23 Jan 2025 14:12:20 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-438bd507fe8sm4791695e9.24.2025.01.23.14.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 14:12:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: trigger uevents for blacklisted paths in reconfigure
Date: Thu, 23 Jan 2025 23:12:12 +0100
Message-ID: <20250123221212.123833-1-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If multipathd has already configured maps, and the user changes the
blacklist or other parameters that cause currently multipathed
devices to be skipped, and then runs "multipathd reconfigure"
or restarts multipathd, multipathd flushes the maps in question,
but doesn't trigger uevents for the now-blacklisted paths.

This is because the blacklisted paths are removed from the discovered
maps internally when update_pathvec_from_dm() is called through
map_discovery() and update_multipath_table(); when later
trigger_paths_udev_change() is called from coalesce_maps(), the
map contains no paths for which an uevent could be triggered.

The map_discovery() code flow is special, because we will call
coalesce_paths() afterwards anyway and reconstruct the mpvec. Unlike the
regular code flow, we don't want the maps to be "corrected" in this
case, because the maps discovered here aren't going to be reloaded.
We just want update_pathvec_from_dm() to populate the pathvec.

Therefore add a new flag DI_DISCOVERY, which is only set when
update_multipath_table() is called from map_discovery(), and if
this flag is set, keep PATHINFO_SKIPPED paths in the map's table in
update_pathvec_from_dm(). Later on, the paths will still be visible
in the old mpp (ompp) in coalesce_maps(), and uevents will be
triggered for them to release them to systemd.

We can't always do this for PATHINFO_SKIPPED, because in some cases
paths may be accepted in a map first and SKIPPED later (for example if
the WWID wasn't yet available at startup). Therefore the special
case for DI_DISCOVERY is necessary.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.h   | 2 ++
 libmultipath/structs_vec.c | 6 +++++-
 multipathd/main.c          | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index c4a8dd9..2b39eb0 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -74,6 +74,7 @@ enum discovery_mode {
 	DI_BLACKLIST__,
 	DI_NOIO__,
 	DI_NOFALLBACK__,
+	DI_DISCOVERY__,
 };
 
 #define DI_SYSFS	(1 << DI_SYSFS__)
@@ -84,6 +85,7 @@ enum discovery_mode {
 #define DI_BLACKLIST	(1 << DI_BLACKLIST__)
 #define DI_NOIO		(1 << DI_NOIO__) /* Avoid IO on the device */
 #define DI_NOFALLBACK	(1 << DI_NOFALLBACK__) /* do not allow wwid fallback */
+#define DI_DISCOVERY	(1 << DI_DISCOVERY__) /* set only during map discovery */
 
 #define DI_ALL		(DI_SYSFS  | DI_IOCTL | DI_CHECKER | DI_PRIO | DI_WWID)
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index b2bb47c..7d53aa3 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -107,6 +107,9 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 	bool mpp_has_wwid;
 	bool must_reload = false;
 	bool pg_deleted = false;
+	bool map_discovery = !!(pathinfo_flags & DI_DISCOVERY);
+
+	pathinfo_flags &= ~DI_DISCOVERY;
 
 	if (!mpp->pg)
 		return;
@@ -193,7 +196,8 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 					rc = pathinfo(pp, conf,
 						      DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
 					pthread_cleanup_pop(1);
-					if (rc != PATHINFO_OK) {
+					if (rc == PATHINFO_FAILED ||
+					    (rc == PATHINFO_SKIPPED && !map_discovery)) {
 						condlog(1, "%s: error %d in pathinfo, discarding path",
 							pp->dev, rc);
 						vector_del_slot(pgp->paths, j--);
diff --git a/multipathd/main.c b/multipathd/main.c
index b4a366e..43a0240 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1758,7 +1758,7 @@ map_discovery (struct vectors * vecs)
 		return 1;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
-		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK) {
+		if (update_multipath_table(mpp, vecs->pathvec, DI_DISCOVERY) != DMP_OK) {
 			vector_del_slot(vecs->mpvec, i--);
 			remove_map(mpp, vecs->pathvec);
 		}
-- 
2.48.1

