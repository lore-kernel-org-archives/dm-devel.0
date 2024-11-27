Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BD2202F71
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748685; cv=none; b=PwyHqPNKEYDcEVq3ze2CURCxp84pvSzd/7vMZPYmbuUojpE0dksT2XD7LXM50TC3BkLzEHu+kAAdFOdlosLwNrHOSg4VOuKOrzFmE36i6jMFyv9Jzphr/+CFWPxEemLJBmee15G4xGIKyboM4pCauuWtRmVY5pGVldtrwIsAcYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748685; c=relaxed/simple;
	bh=laIAL02rAfPP5OfUyKCOuf68vBzHgCuXP++Um9A+2vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwyA62BtQl9mfl40SNGUMHAGbEjcc0wK7bBHi3bif/skW91cgU1blmS9F/dvUABG7xTqXDx5cAWnwlUiGfIsOIhGIav8V7QcqGYW7Zr7Yxu575n/Zx9d1ewMpNYBuW9VJJI4bd5x53MUVX8wXaR5QUPE0PMgJ6wvGZfapy1F1Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NP/Kr/Z7; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NP/Kr/Z7"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4349f160d62so1538305e9.2
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748681; x=1733353481; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apic9H1WkfA4dBNU/A0r5l0s03zwAfvOJu3QZU6FA5Q=;
        b=NP/Kr/Z7ywiK2h5GGxfo+G5ZLHDI7vR456Dt+Df5SNp7YqF2/sfxeXSndvRvwEBRNB
         JFC7N7qR1qnTxiHCwEJED344pCRKlox0frJOmQcuAuyf2Gm320zzMcYmW7rAR7oQ8LiO
         u7y+MIFicXjFAkBY9fIOhSeLSUfN+aYnQ0rTXSmxT9wiAk4PMkXUZjrCWfSntazBGBTh
         Ge6nJmSc3lklJVOmrxms8/2isP0JLPysjh0TaNTCEBtljJ+2JdKlQXVZ86KT8BAPNfjf
         XKwG415u4n5Fx7AtWL01DikjNvObgnnP5u9SkiRl8xDD12iSRvDBPkWIIib8TEDAgXL5
         1SUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748681; x=1733353481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=apic9H1WkfA4dBNU/A0r5l0s03zwAfvOJu3QZU6FA5Q=;
        b=DGPPZ1jTbAg6TC31+L5f8gdnZqr423anm3LjVOR+Z1KoZH5TYOR0hYEYDUbc4qu+yx
         vhUa8hq0VtQ/0iJEz88ai6ef5go19dyGjW867JFCQlabVwAYUdHqCqWJlq5aHAeKoxg1
         Q8Zi5q1i4jpwDAEMFjt48z+BZBJVh1IDUTUu3W3dJA3iXTxcQ1k3Sn7aQqCLUSnJIrX9
         Q2PpIOavAY6RQnRktKssvf02ajPyeWXPJSmk4Tq/UQrWZHtclyaZKhqTaJXVqFldyAEg
         x/997kRY02qqH/JOvTuL42rZTFnAatHhNniVzJESM83lgss66cLIBHbUwC0kH9/YX70H
         YjTw==
X-Gm-Message-State: AOJu0Yz3k4o1MRjViGjFWrZMyHz1OB/pzin/KtegjR7s9r0oCF0G8ynK
	q9BFeSDc9KTBgfNnIwkkKcUa5Kw0HLGpWS9YJuUzrMHjKmCXVaZGshvCU3m2camOATnzKctJUzS
	T
X-Gm-Gg: ASbGncsaoKwK2VjOnfNDtRTANeOUISkA6ncWoCFX483FHQW6y+Zoxwn8lyBXUBbkhZL
	JHXKybEQcoa1dW2CpxYjGEAgMgY8PlVn5bpeA6TA1kZ7hMulEENzaeFAqV0dfeEtPb3jFISQv9t
	K2AyolJru2tL6H+LEWenZOuy+AJyHQA3ClQkJU3PsQuXbMXltuqQwQKtTit7yRrWfzdOE2eEq0F
	B4SctbqDdCNITfpyJNWbnXzNQvWS3l0BZdpCDq+CLlVwlT23zC1rtHsOQlEX2p/DvYdvxeAEPlw
	XgBDmceaajTbZR/7ghOmr62cmN9D1KW1gtRH
X-Google-Smtp-Source: AGHT+IFjKJaECmisjGFJeJX8VJfckDFl3aP141yDVDRywPyZBsKADjYcZrtE3k+dP301cJR9Ko8fCg==
X-Received: by 2002:a05:600c:5118:b0:431:5863:4240 with SMTP id 5b1f17b1804b1-434a9de4584mr40212035e9.24.1732748681401;
        Wed, 27 Nov 2024 15:04:41 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-434aa74f05asm33946125e9.1.2024.11.27.15.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:41 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 4/8] libmultipath: move pathcmp() to configure.c
Date: Thu, 28 Nov 2024 00:04:26 +0100
Message-ID: <20241127230430.139639-5-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
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
index d0e9c95..9ab84d5 100644
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

