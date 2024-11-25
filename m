Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60981B0F1F
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545162; cv=none; b=BbA/85gtbzgbXyiSU3TGFiFUhSKCeGc/VLKVFDYWbV8Htz7N7+mjWx8AsWLZ+HMINMCNwzD8WaZoq9JnaFObtI2OkAPJa6DWilZuyLJXiQng6gMfiMWYz6YEsSZ/dWoDrSMGfuoeYXUeP76H+b2XGZRGv+uucMD1OjQ6LdXnC+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545162; c=relaxed/simple;
	bh=X6WF3C+sKubs7eXRB7P8XQYktmSOPIvvL0j2EQJ+9gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbi8SyMm2aAi+WTEC7M7r7peFHcwrgOha7cXECM3TrOrZOjHh/I78TmOHypQgHNFdZKcHGkWljhx/2YgMDvRXhKDhm+p5aF49RFEVzLU87OXx/x6Pn0M5gS3W6o3DMsWsjb6HwVmHjOzAhZ3j+7RAlAtkNjx2HA1YYkTPEXyNTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JAi2fWKs; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JAi2fWKs"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa5500f7a75so177263366b.0
        for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732545159; x=1733149959; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4mZuSscAilrbAaeYlUTldnht2aXSmKXbBabplDcNPU=;
        b=JAi2fWKsuGsTDFBHMKpxzfYgD5OjzgygCDLgneEWXXAOuy3dBLozqkDVbkXaemCcRd
         9ylJ4e2ANBCXcxexXh3LxabsgyWCLPomL6pUSMwswe1XNREAfVNsy2kcwXWxFeHS7qIw
         MfnIZEPwOaLB3ZFyeGj4K3jZs21d6lSWKA5NjSlE/4JryFKbqbqKfzwuB9pK/bwpDC8L
         QuyWKpv4xSTlWXBjhnl9Cv4Nm4c/f06sgtF4OYIGHc9RTqsvtXfpmLg2iooBCwQ7Sh9u
         eBbEOUgjOuwwCU8sJMOmZOxTGwAc71xkug8i11GM9o47e0GsRAW0LzafIlt/Q9OFDBkh
         nfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545159; x=1733149959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n4mZuSscAilrbAaeYlUTldnht2aXSmKXbBabplDcNPU=;
        b=B83GQBvUWc2Pc19b1UCX/rv1vWHxl37I1cqJEqXyrNSHr71XD3k9MIrv8k6mbas1yX
         BhwxDwZqCXTDiLGurPbEQmNzsf3u0mPnfYyUrMlVyUTv+MVFdNaZSssuvCmdUaJVk3yg
         wG4aax/hAu4l/d0HFHBHFjvXUyWOtHiT2VBndkF/eeJF65QSThNyVOcKFol8smhVUx7u
         NXjUQxKs9WNKloMKuX2Iolyub8pNOYmbEM+kjHBX2K4s+BsffYDhefme08G1Alo4fDNF
         bWAqp1nrfaiAQ9RzrqcVV+J2YfXQP/buJs7/KawndwMH2zk+uuIycpN8mT3lHvvFNteQ
         9VfA==
X-Gm-Message-State: AOJu0YxM9T/2FKMT4KkUzSZwt5T+9lICWk7aXyAbJRuv2/3Xv6NvCr81
	GfEP97x9ZbtVq12l2y/M0iztngaEovO1jFYNF7NSQZJ1Qdp7ifpGpt0apeZfuNM=
X-Gm-Gg: ASbGncucPvO1hiRWL7I0zUpZtW4IG53eqRTyKG7xPPjiM6b1lMv1TZmp+syJtOS0A+/
	43vVTbMp051oLhJcMWzr1L2ly9KkxzLHx8BKBy/nXzXoE75eRJHp69IJqgqW7lXF+M0jiLzAWK4
	BafQs6ntA4k4mtadqznsTHpjvVczstdxM83T6HDeMj7kEUROFRCOS21mvhV2KS6inMEY9wDtbBp
	eGHhFrvy8/PfVqAjaZcRSPCT0/R5yzt20+X09H36PJ25CtmNSjtM500xxeWQryfHw26lKd9ZClP
	H5qXC6Hs5NuznJj42/T+V9bG7J86IG3a3/tq
X-Google-Smtp-Source: AGHT+IE0MaIqqx9xUXZuVYBXwWZDgm06Xob0hEDdV+cKTCwCeac8a9Snn6MtNxdsIMdpKrseFp0fYQ==
X-Received: by 2002:a17:906:3101:b0:a9e:b287:2813 with SMTP id a640c23a62f3a-aa509906366mr1196372266b.5.1732545158946;
        Mon, 25 Nov 2024 06:32:38 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa535bd5bb1sm317526566b.48.2024.11.25.06.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:32:38 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] libmultipath: move pathcmp() to configure.c
Date: Mon, 25 Nov 2024 15:32:24 +0100
Message-ID: <20241125143224.51934-4-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241125143224.51934-1-mwilck@suse.com>
References: <20241125143224.51934-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... as it has only one caller, and make it static. No functional changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 19 +++++++++++++++++++
 libmultipath/structs.c   | 19 -------------------
 libmultipath/structs.h   |  1 -
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 55140d0..6f79a4f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -426,6 +426,25 @@ compute_pgid(struct pathgroup * pgp)
 		pgp->id ^= (long)pp;
 }
 
+static int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
+{
+	int i, j;
+	struct path *pp, *cpp;
+	int pnum = 0, found = 0;
+
+	vector_foreach_slot(pgp->paths, pp, i) {
+		pnum++;
+		vector_foreach_slot(cpgp->paths, cpp, j) {
+			if ((long)pp == (long)cpp) {
+				found++;
+				break;
+			}
+		}
+	}
+
+	return pnum - found;
+}
+
 static int
 pgcmp (struct multipath * mpp, struct multipath * cmpp)
 {
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 4851725..dfa547b 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -627,25 +627,6 @@ int count_active_pending_paths(const struct multipath *mpp)
 	return do_pathcount(mpp, states, 3);
 }
 
-int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
-{
-	int i, j;
-	struct path *pp, *cpp;
-	int pnum = 0, found = 0;
-
-	vector_foreach_slot(pgp->paths, pp, i) {
-		pnum++;
-		vector_foreach_slot(cpgp->paths, cpp, j) {
-			if ((long)pp == (long)cpp) {
-				found++;
-				break;
-			}
-		}
-	}
-
-	return pnum - found;
-}
-
 struct path *
 first_path (const struct multipath * mpp)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4821f19..49d9a2f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -598,7 +598,6 @@ struct path *mp_find_path_by_devt(const struct multipath *mpp, const char *devt)
 int pathcount (const struct multipath *, int);
 int count_active_paths(const struct multipath *);
 int count_active_pending_paths(const struct multipath *);
-int pathcmp (const struct pathgroup *, const struct pathgroup *);
 int add_feature (char **, const char *);
 int remove_feature (char **, const char *);
 
-- 
2.47.0

