Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79648A2D2
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995837; cv=none; b=ty98mc6iP3dyjlTqjS6EDk4kxdYRyv5NswfS8v3ROR2V/6M6nHJUMAoJcKG/cnd8kK/nEBp7+MP7O0wdwAZWDp+3mKYXbAgJ+wx2vXBYiwObFEg23hP+wiOsEpokfTLEdY6CEP4/iAYaTnDp/JY8QMXoreBKcvlcRK2U6kdtd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995837; c=relaxed/simple;
	bh=5E1ZUXukf54jTTfNp6ddTaL/I2AzTDwhopxl3o5cesQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwvdYYC3D5Y5mJpxqe/IlCQ3Qwt+XYregwbEovgqZhHmPozb6sFBmsOsBPTJiMYV6DG8EArfNit8dco4PaWS6Ou9PEn73Faf/msSHgUZaoo+wH+MGTfArHDlkW4A9Gqltg/yznyKi8x4cAkQHRRzASIhxwLnAeu7v+oGLnk5U7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H4LPX2yC; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H4LPX2yC"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso39462795e9.1
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995834; x=1778600634; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toqiXTmOUSgQmhkF4zPVeBgT/SsAl+VaybMOQZj+b2Q=;
        b=H4LPX2yCnCRUhDrQEbPhgYCpM1nmhUh6dSz3R5m8AZNXAQ9+lHWQ6KCHeGeeJPzuqL
         bZ4+Z8D67CsjNN9gGcYuplRhD7xKRE1PUx0lJqsQAJUSi01gXOcgbXYUTSMnlfuWHIQx
         LHKeqAEi3K4tDxuQ0xJVj7gDKUns5cQ8wjf2rArQEkveKDiaqJK05rTcmkemFoqwABHl
         HVt5Tz+GNu+4FulbreA8Lc2+foMkJjXmSBpU92uGK/sitob3lOrSMSsN/LMwVfrHfw1d
         ORImuzzyq4BZgAwYyFHuL15FMZU2jTm3CbvyDiH5iAjC01KWKndhkGLwhanmpnRa2Wfu
         WLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995834; x=1778600634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=toqiXTmOUSgQmhkF4zPVeBgT/SsAl+VaybMOQZj+b2Q=;
        b=Yn04efCwa0g/TCtfQLe2nPwW7bPEbD1SpgvW3jbtPxGkIXi8LSurPkkUcDcpJ8dlEm
         p3lziM/GRKYb1j4wuygUw3giKXBTAViqt8FYzhznCrScVS3lNxo6y71gj7RH88/c7zX8
         uTfdc/yYmi4//X4xjZxah6pdoR7PfH1xm2CM5Pb23T0g4edgGiYrplyV9QRK5pHX6NR2
         Ny8+3C3IS3JFckrHaCCDLVHwwzVIAxuN1TGdwxn51OLlxoMRMbDV/EM92naLTlIAfV4R
         7k2j1MgIGiMW0ci7sUcL5cliXwFlVLQsf20jIBBNwsEWsIlfyWW7zAV3EF8BETC99h3+
         0d0A==
X-Forwarded-Encrypted: i=1; AFNElJ+xYCtd+81ow7JW8Wel5+ohFWsIkWRVdLeqnkvq0o8I1QxigErKTemnAONfnSVGrqveQY+UrqIqmg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyjXRJnOCV630pAEDQ61uSqKGuhHq2YV0p+yn69GqW0CPrVGTTb
	bEZpMe2MzDl4eQYQob79feOj1L0BiNxgwFauaZl880WeFNyjPInJMRWptrqSu4hmv30=
X-Gm-Gg: AeBDievp93PiYFEzRIk71JwY4SBFZVk078hi6huCwD78LBYc2knepWspMHUX3CY4l+V
	VMPppn4jRO0ZdUJKvznXHPNCnNGKIiVJcFzVKFaZUayj2Vppp/pwQ/4RvyfOvsi3vQgLMINbK4q
	9HSySue0Wt8Zc96pQckVDZX0WACsO4Cjboxl5cIcM1Su2hzJWJ1eJVwAzUskOfnlu4OQWPF2GtV
	h2M1Cjtba57JEEZM9nUa8RGbcM38a2K9DlMsk0uYA9Gz5Rqs2M9xmVNr/cp8iVTA3SZamnoIRX6
	c6FnAtAQ9zqx3ARXvlexFpCyBGoj1J6gxteEZ0EePvJ+yKOB9ulwP75BKBbbrcoDm+Syzqy5eyS
	g0b05Yyr8B7XTtD0n+Px4gVLPhMVTbua3shzMOMFA8VHI5ohjffsmx0GQzfDrxE/ObK5g9Kx4rC
	lAG4GwhESGQ10gSEuzhEGM2uUgPQciFNTiCrE0bhCwUZBVTv15v8mccnfvNngYX5IOuXT8yARL1
	jt5/COlvRVuVlwYuyiiYUa6
X-Received: by 2002:a05:600c:621b:b0:486:f634:ef1 with SMTP id 5b1f17b1804b1-48a988a264emr256304135e9.17.1777995833625;
        Tue, 05 May 2026 08:43:53 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a81ed69fasm480661785e9.3.2026.05.05.08.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:52 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/18] libmultipath: use shared_ptr for prioritizers
Date: Tue,  5 May 2026 17:43:21 +0200
Message-ID: <20260505154332.448054-8-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the hardcoded refcount handling in prio.c with shared_ptr.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prio.c | 47 +++++++++++++++++++--------------------------
 libmultipath/prio.h |  1 -
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 24f825b..bf388e9 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -53,28 +53,11 @@ int init_prio(void)
 	return 0;
 }
 
-static struct prio * alloc_prio (void)
-{
-	struct prio *p;
-
-	p = calloc(1, sizeof(struct prio));
-	if (p) {
-		INIT_LIST_HEAD(&p->node);
-		p->refcount = 1;
-	}
-	return p;
-}
-
-void free_prio (struct prio * p)
+void free_prio(void *ptr)
 {
+	struct prio *p = ptr;
 	if (!p)
 		return;
-	p->refcount--;
-	if (p->refcount) {
-		condlog(4, "%s prioritizer refcount %d",
-			p->name, p->refcount);
-		return;
-	}
 	condlog(3, "unloading %s prioritizer", p->name);
 	list_del(&p->node);
 	if (p->handle) {
@@ -83,7 +66,18 @@ void free_prio (struct prio * p)
 				p->name, dlerror());
 		}
 	}
-	free(p);
+}
+
+static struct prio *alloc_prio(void)
+{
+	struct prio *p;
+
+	p = alloc_shared_ptr(sizeof(*p), free_prio);
+	if (p) {
+		memset(p, 0, sizeof(*p));
+		INIT_LIST_HEAD(&p->node);
+	}
+	return p;
 }
 
 void cleanup_prio(void)
@@ -91,9 +85,8 @@ void cleanup_prio(void)
 	struct prio * prio_loop;
 	struct prio * prio_temp;
 
-	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node) {
-		free_prio(prio_loop);
-	}
+	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node)
+		put_shared_ptr(prio_loop);
 }
 
 static struct prio *prio_lookup(const char *name)
@@ -150,7 +143,7 @@ struct prio *add_prio (const char *name)
 	list_add(&p->node, &prioritizers);
 	return p;
 out:
-	free_prio(p);
+	put_shared_ptr(p);
 	return NULL;
 }
 
@@ -199,17 +192,17 @@ void prio_get(struct prio *dst, const char *name, const char *args)
 	dst->getprio = src->getprio;
 	dst->handle = NULL;
 
-	src->refcount++;
+	get_shared_ptr(src);
 }
 
 void prio_put (struct prio * dst)
 {
-	struct prio * src;
+	struct prio *src;
 
 	if (!dst || !dst->getprio)
 		return;
 
 	src = prio_lookup(dst->name);
 	memset(dst, 0x0, sizeof(struct prio));
-	free_prio(src);
+	put_shared_ptr(src);
 }
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 119b75f..7ff1a24 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -45,7 +45,6 @@ struct path;
 
 struct prio {
 	void *handle;
-	int refcount;
 	struct list_head node;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
-- 
2.54.0

