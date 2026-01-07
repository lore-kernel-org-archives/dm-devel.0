Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B618338939
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817138; cv=none; b=M9xq+cj+VtDEG9Zfn1IeVz6yJ4x4mMmPFA/u7ns7V8m+BT1vhE8hIrzPeFVkfXZ5Bs59j2gdfnl6iC4u+xLmpiZekh96+Eyzy30gajolz0Qgbuk1tvM7b2o1qIu7cyKNrnaZxS6vyn4bzs/vcSLQEVs5/pev2IxUhrPIO1bGLkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817138; c=relaxed/simple;
	bh=Pp2Ov9lI5Q4i0BCkiJzBigUH1nhaxj200wCEfwCGFBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/uQeL6k3V3LPPh5Rww0LhbZ2ydSMjwowiO+/T+9gHQvuxTpYZMAmhk6YDGeSX/9zpDy4+mdj97fL5W6PFBO3NTb91elGWXdvqN+ZB6XygCpTjJfCYRdQK704fP1td12wvJ03pvMHi+EFUWn8LN88k2NyDUOzXBkcpUmRz4GnxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JR3JNrXd; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JR3JNrXd"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b83122f9d78so411513066b.0
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817132; x=1768421932; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZEVt317TIPV76PUIvKw2fSPAmywXgByAsXdcHrw3jY=;
        b=JR3JNrXdh9bRuIeYIYJu7vtkQH8y+Iky2pXZZ4XLrv144uDrwk7ZAxSCmv0xL1/5lS
         IQOavZ5BEPHQAsfReLujQiV/SyMFna9tOpftHTY73p9uMUI1reNFxGHVkl27E8k/6zW9
         hOHMMHWhYxEU1WFR28/PO5xkXyi0/D/B1lby4jXOlqsiID8XHWM+BO79FLBXp6MaBqQl
         QvqroMgiuOp5vzLtpUbqS+zdWGroLA7liaSUnmdvu7BJ5RIxosxLgzqVmzerMIlDluWD
         W55vf6MkCIkhPs4dGKKSii2c7RW7CnE866jnO74xfTEKKqfaY79Idef6czpY5T2AZAUw
         jOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817132; x=1768421932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ZEVt317TIPV76PUIvKw2fSPAmywXgByAsXdcHrw3jY=;
        b=RtlAqtOq9VkTMkDB5iD1urzvh6fV3vuAGA5VSl8k94zDT408hnK2VlG+WpLGGNlGAa
         526irZihdHevZ599nsKXgfoSruuFscZkPwcQ6pR9XfBt2Y4YTXASqcxfAIWpvAfxJs7v
         9YGHs/jeYVjX+y66U3XIe7Y2K8puevBbrxdLt412OmwaT41DpQ8yEJQAX/3eBvPOpx7w
         WS/dvEEsnTLxCEQb4mDaWjFl9N/UgvQeC8WBcS1ZP+XTb4m6nB9fSA0v8d9mqGtGz1q2
         MnapNIF1WyftdQ5gTbOBZJIf03qSty/HHh7w254vOXBZxPqOe+lEZugG7jOMIETFjn+v
         qIog==
X-Gm-Message-State: AOJu0Yw8658/xuPCL3mA52Ok8tQbs6B2StUyFiqIxqq+bStYphP9PUf6
	JcUJ0lS/T1D/PkIu8pEg8Z/a5LFRFt9vCimimk3ZRJ3pzK1/XT4Nm5WTpDwkQ8nd6E5JWBrhQSz
	bCp/E
X-Gm-Gg: AY/fxX4PyOS259gbqxqRsJv9DlN0kI7HjdSmzqiFipVtSrxfg3GA9EFc6vv7l6x4QAL
	nTVVV9SB5/VSunFq3fO4INwG2bu3eOMBa4ZgnS0FRuTAGdyoIIDHyKJuGTsSuf+BdPPkoy/n1wp
	UP0+vXqk0/XKVAC0QsEIM6R5BfUptLEG0KXEHquIkco8FVsgH12Yhb9FnxZCZzsz/gO91OGA0gZ
	gmc1/SZLaKiPZyHJ7DErjkNDnHK3gySBF9H5aCy8G5ZqUo/YUpur2NFfG7Ii0qehG7WmonkxG7z
	9E8HMw7DZ+GodvHw8OG504UWhi3n1N3yIw0SvrSAxPYLxgHyvcPvtm5Kiz8rQDL+G7qoexZF0MO
	ezE09289JXqkXwRmtjrUhxsfAiIFT/RxZ4ztK0WTCyWg2IgFItX6tyRObKb5qq0yPC86boTDdJ0
	0+EqMHYy+2+pUGx4+blw2fqpFvpEe6W7FHLy9HrwEOpPaTnQjyMH5Df81Kd3wxjgte64yhrnfJX
	w==
X-Google-Smtp-Source: AGHT+IF2MKGWku1wgMG4tXeUvVNPmuAVGxq6sO2J+D2j0qwDK0HYoC4jRtb74do1dm6yZUAgDzgEBg==
X-Received: by 2002:a17:906:ef0d:b0:b80:3fb3:bdf6 with SMTP id a640c23a62f3a-b8445336254mr359432766b.40.1767817131519;
        Wed, 07 Jan 2026 12:18:51 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a56c552sm616606866b.68.2026.01.07.12.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:51 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 11/26] libmultipath: remove free_paths argument from free_multipathvec()
Date: Wed,  7 Jan 2026 21:18:11 +0100
Message-ID: <20260107201826.323977-12-mwilck@suse.com>
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

free_multipathvec() is always called with KEEP_PATHS=free_paths.
Remove the argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/structs.c          | 5 ++---
 libmultipath/structs.h          | 2 +-
 multipath/main.c                | 6 +++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index f5267eb..e786e91 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -76,7 +76,7 @@ static vector pathvec;
 
 static void mpath_persistent_reserve_free_vecs__(vector curmp, vector pathvec)
 {
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	free_pathvec(pathvec, FREE_PATHS);
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 511173d..ec8779c 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -346,8 +346,7 @@ void cleanup_multipath_and_paths(struct multipath **pmpp)
 		free_multipath(*pmpp, FREE_PATHS);
 }
 
-void
-free_multipathvec (vector mpvec, enum free_path_mode free_paths)
+void free_multipathvec(vector mpvec)
 {
 	int i;
 	struct multipath * mpp;
@@ -356,7 +355,7 @@ free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 		return;
 
 	vector_foreach_slot (mpvec, mpp, i)
-		free_multipath(mpp, free_paths);
+		free_multipath(mpp, KEEP_PATHS);
 
 	vector_free(mpvec);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 064a76b..b16bd9e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -584,7 +584,7 @@ void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes(struct multipath *);
-void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
+void free_multipathvec(vector mpvec);
 
 struct adapter_group * alloc_adaptergroup(void);
 struct host_group * alloc_hostgroup(void);
diff --git a/multipath/main.c b/multipath/main.c
index 58db288..4b8d7dd 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -436,7 +436,7 @@ static bool released_to_systemd(void)
 static struct vectors vecs;
 static void cleanup_vecs(void)
 {
-	free_multipathvec(vecs.mpvec, KEEP_PATHS);
+	free_multipathvec(vecs.mpvec);
 	free_pathvec(vecs.pathvec, FREE_PATHS);
 }
 
@@ -580,9 +580,9 @@ out:
 	if (refwwid)
 		free(refwwid);
 
-	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(curmp);
 	vecs.mpvec = NULL;
-	free_multipathvec(newmp, KEEP_PATHS);
+	free_multipathvec(newmp);
 	free_pathvec(pathvec, FREE_PATHS);
 	vecs.pathvec = NULL;
 
-- 
2.52.0

