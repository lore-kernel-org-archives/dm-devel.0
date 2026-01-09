Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E241262FC0
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983973; cv=none; b=n4t4K4g8SHGqml1KdUoc/0NeFNsqM+bPvRduxFnFPU0cEGX+xkfLdekcKVIXEDeopRh2mvx4Oi1zcAORN5RbDJJXgm1aekJq5mtlA62Enjov48K71j+VjGDjpa05H+RfBJGbmg9hHqazx1/Yq7tjdxW3CywPsUOWq1FMAcBc0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983973; c=relaxed/simple;
	bh=5ulvlEWuoGAFuXkuPSlmUk1BbNfR14W+4CqHQ9OFM6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLWI6FR9hXtuYpgUhuyHzNVcSDRUhx1ZqSXnPzSisClHMmTvCepEAc6RQoJzXZmIJufSzPpWSAKLCF8i2BsDeHjS4ZVrnfVGUIz10gt05xQmnjFrmBq+UxgrZRNwgNxBVruOjRPU6ayVj8tYTGtsySNrSrzdiHGrWh6QM0381oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WQk7YOs0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WQk7YOs0"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-430f9ffd4e8so1643367f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983970; x=1768588770; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UrFrMBs/bdgWRb+Sb+1gnF0EorY6ZRpOLo3prbf3HtQ=;
        b=WQk7YOs00+j0bsZJEF8EIdMEb26O85Gq8IUeWD3PEk0EHv1HNS4t9PMSeaptrOaw08
         zc6oXDr0u60nxx/xg5ODViOyX3pvJ5NnONJ2xLvUbo1XE8Ib4zWQ8rXasmc6T+6hJrX2
         97soW6NFkVVEfcjmIVvA0zpYtiNiQgAcxvJituvFXXmPT4bYy0Zoqp7DITqugn0zwI39
         QR7FbAneH6Y+/r6hmfk3OlyFjNmZFC1I4I0ZbLShAUPiEWeMqED2ekga1mguFynO1eAi
         +AdXut62G3PiHWV8wdKWKeD73sMh0XMBCHcE3MsgxpI3d2Y7IlVkOi7M05OIKAIj8KTj
         9tNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983970; x=1768588770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UrFrMBs/bdgWRb+Sb+1gnF0EorY6ZRpOLo3prbf3HtQ=;
        b=D1PsBoWBTfy+JZuCUSSkTTRCzqqzT9MTANuAOlxfiPQCZRKWgwfL92eaFGOLHWGpjV
         bYRYYuPzo4o9u01GWZq1HGDUzXChNTx5yG2xkYsUNYgfaf9WVgVt7pr5kTQ55Zpe6fTC
         ec7JupczEdhhVlaIHMlQzMdMs8RVTXwFxp+4lUj5KkVHnQEBS3y1BWaSm9Yzv3TodSOn
         krorpxlpasCvIFDjw1lowvBFaLanJl2Wxb6ve7xHRzaETRYsE8LP/zbj8YdX8v8u4Z9Y
         d87l5ISBE+/JIHqBXPUx83Oy3kZ3Wf4x5Wa/Ke5h0YchzvohI3OCi+bEzKHgOSvbO8Te
         wnhA==
X-Forwarded-Encrypted: i=1; AJvYcCXN3aYW+SkZ/FkqYWmJSG1M0YJiz10nyfYSngrMyu5C0+yFLNO3VI23ButPUbgMIrw/BiUC4Rieng==@lists.linux.dev
X-Gm-Message-State: AOJu0YzceidlnyoJz/O2mdCZVUxrYnWlQLE4877RizzEmFN6nClMSp8i
	o/k+KZ8KZfWmCFwBL92SC4eGYUJaJHqDKu0Vjx9Kdo4+MdVYwWdGiBByrb8SRarUZ04=
X-Gm-Gg: AY/fxX7vH1WG1eqnc+xUmJmgeQhKhG4zJf9Y7GeQArA3riZPesbu81qjGON4qv2uqMI
	VL4wCMOkcBj4CSvAaMve/uFc1DJoGl17Hv6ruhMoT7jVIE1V3gDJJLt3awyUt1ALJvn7vmH5A4M
	g90QLd/kybgMcZH2JXzmwy+zLTCPofnF/3M0Tz344UTvb62g4ZnrX45WBv4Zl+y8863iLUdOraQ
	BzO86gj6km83kVVbnlFPxYVa9UWEshWwFAnR9Y4SMriIUp6zTgJq59oZOK0EUw+N753jR40cWrT
	bOATwtvZjsZqeduRPwsIA6Jsg/RVrlfPb8/SliVSaHDAYwNjrQBqr1Rfq1EUGccXNoM3rk1QTuh
	lBJVjrl1e+jZmru7HSu3Eoj0zdr6k8q9bn5E3anDlW68ZgRj8wIPGybp+Qp3kKc7bzv0SrCgfsZ
	mRsSC9yKQOvKh2cjMJQbnJGYpp15Ttqb57beh+Y1Fym1BG41obzXam9zYzLG/aagZdpXknFoxs/
	qCUsmYZDR32
X-Google-Smtp-Source: AGHT+IGWThjhj/8mXlY0nGd334wsEQwgiPR2N5HUFuTCLPog8GXmCcVyNS9G2TKtHWemjC1XbWqjtQ==
X-Received: by 2002:a5d:5887:0:b0:42f:b555:5274 with SMTP id ffacd0b85a97d-432bcfde7efmr16522564f8f.20.1767983970254;
        Fri, 09 Jan 2026 10:39:30 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0e16ffsm24650720f8f.12.2026.01.09.10.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 2/9] libmultipath: clarify code in set_path_removed()
Date: Fri,  9 Jan 2026 19:39:00 +0100
Message-ID: <20260109183907.201250-3-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of remembering pp->mpp and setting it back after orphan_path(),
create a variant orphan_path__() that keeps pp->mpp set. The name
of this function is kind of misleading, but keep it as the main caller
is still orphan_path(), and we want to keep the well-known message.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 434b57c..8d4fc69 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -369,13 +369,18 @@ err:
 	return 1;
 }
 
-void orphan_path(struct path *pp, const char *reason)
+static void orphan_path__(struct path *pp, const char *reason)
 {
 	condlog(3, "%s: orphan path, %s", pp->dev, reason);
-	pp->mpp = NULL;
 	uninitialize_path(pp);
 }
 
+void orphan_path(struct path *pp, const char *reason)
+{
+	pp->mpp = NULL;
+	orphan_path__(pp, reason);
+}
+
 static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 {
 	int i;
@@ -393,16 +398,13 @@ static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reas
 
 void set_path_removed(struct path *pp)
 {
-	struct multipath *mpp = pp->mpp;
-
-	orphan_path(pp, "removed");
 	/*
 	 * Keep link to mpp. It will be removed when the path
 	 * is successfully removed from the map.
 	 */
-	if (!mpp)
+	if (!pp->mpp)
 		condlog(0, "%s: internal error: mpp == NULL", pp->dev);
-	pp->mpp = mpp;
+	orphan_path__(pp, "removed");
 	pp->initialized = INIT_REMOVED;
 }
 
-- 
2.52.0

