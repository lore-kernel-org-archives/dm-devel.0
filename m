Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA20E190468
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130820; cv=none; b=VdHlhC4XN0YfBL1X6C14q4E9tFA15ZlsTLdhECpz9L1kdKrcyByfSL3IYvfOL+mkv3WF/a+H0gNucRe8/umVL8Xg+SiM28BSc88FwwvcDMLrGSdES236atJFJzKu8H5TcJnA6/ni5GAlRSSzgs0b8CMC0nmHaIERbQpixfOPdV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130820; c=relaxed/simple;
	bh=9NDJb86pvCINZo73KdVCa640PlVd0wOamDKwb4U1LqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj164OzakKBop+884nu43qoqc18vCFmBSYr3msgJh+jpY3aR3/AqEjEw8NkUL8yhpGzckOXhwginE1WSBOEK3w35DwttKwklxMJAoLYk5UzOQjwl5TGzARzQP18yXNuQbSMf3HSZIxz0OJVNCqm5SCGFjK+ctYjY2TldT7NGFiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EjmyKakv; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EjmyKakv"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5b01af9b0c9so1192485a12.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130817; x=1723735617; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiyIz3ejGgt7sPKinx/mWchTJwGbSJpTPnR53Xsk+QU=;
        b=EjmyKakvYxVDqn0lhBNun2IBbsdmGF/2JBjsv1ZHT90Aauswjhj2O0Lh8T9XiKygbz
         eg198ng68JjXBsKAomT2dNN6Aca332aCIK4Ya+yguZFf1no5ij2SZ/pB+SR/i6harAb0
         cdl/14vglPNI00NTwGzg66JF48M6fkgtlqBUvVeZT0z3uFuIX1TfF1vlN1OrerQuOk5T
         PI8SmLoUvWhRnfuQTP7YOeRfry6bCt/5y8NXB/emRZBEX/sl2Or3gf8TYHLHUisKnfna
         YQAB32U1zlCMgTTMBr+tjQ0+mHLEZ2XVcaMZRA0NzKeEg18Sf3CsYlVhkL3Cbt+DkT9h
         csTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130817; x=1723735617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hiyIz3ejGgt7sPKinx/mWchTJwGbSJpTPnR53Xsk+QU=;
        b=Vip0rWI1ckYeIS8D+bruk0F4CGWftNod1pXGBAOJO5FUg4XcK5pP3RrLYkcIdmOAt0
         9jdSK6jrOSDHlAWeag3CnvuFuzMgHuMKE/1AM2irzwz1RDG1sn0aFGj9OVkuytDRT/fT
         kqhm5m/hHQxSjYqe4Evx5bweYsxwiGMGIy3RZuy6AU07FNoCt+myZm3defrccmHbKUxu
         s5y88cvI6cWECYOBHG7EzcS/N6qVxYdNvwNPcBRNU9Qq9P2YfAq6cWq+xtTTx7sNUJ17
         M9RxPcBOONQwZYHkG+agW6CJLkmzL+JHIo3S3O1d27WTzeY2vZpgOGGfhaZc7Hs0dtmV
         M5IA==
X-Gm-Message-State: AOJu0Yz9DlGk7RSC2fqJOw6ydLrrketvX+9kSyvQYjdP98AVwly+9iLq
	6Tr/+aZMJ2ZCBIDut9LEVOKcTRwyCoKWBSm33D1egjaPjAcuzY4RnJGJjhUch6Y=
X-Google-Smtp-Source: AGHT+IH45lcwIxZjgzC2/r8U7k8yjawQJgD+vStVv8RnrswmGDKs9TtbSiciWjXWL1VXQYpKZ+zT7A==
X-Received: by 2002:a05:6402:50cd:b0:5a1:b42f:c93 with SMTP id 4fb4d7f45d1cf-5bbb221c324mr1788498a12.13.1723130816952;
        Thu, 08 Aug 2024 08:26:56 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2bf8e78sm729878a12.3.2024.08.08.08.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 23/41] libmultipath: rename enum values with double underscores in structs.h
Date: Thu,  8 Aug 2024 17:26:02 +0200
Message-ID: <20240808152620.93965-24-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c    | 4 ++--
 libmultipath/print.c   | 2 +-
 libmultipath/structs.h | 4 ++--
 libmultipath/valid.c   | 2 +-
 tests/mpathvalid.c     | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 546103f..a06a613 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -568,7 +568,7 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 	if (!buff)
 		return 1;
 
-	for (i = FIND_MULTIPATHS_OFF; i < __FIND_MULTIPATHS_LAST; i++) {
+	for (i = FIND_MULTIPATHS_OFF; i < FIND_MULTIPATHS_LAST__; i++) {
 		if (find_multipaths_optvals[i] != NULL &&
 		    !strcmp(buff, find_multipaths_optvals[i])) {
 			conf->find_multipaths = i;
@@ -576,7 +576,7 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 		}
 	}
 
-	if (i >= __FIND_MULTIPATHS_LAST) {
+	if (i >= FIND_MULTIPATHS_LAST__) {
 		if (strcmp(buff, "no") == 0 || strcmp(buff, "0") == 0)
 			conf->find_multipaths = FIND_MULTIPATHS_OFF;
 		else if (strcmp(buff, "yes") == 0 || strcmp(buff, "1") == 0)
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b911802..b8868ea 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -575,7 +575,7 @@ static int snprint_initialized(struct strbuf *buff, const struct path * pp)
 	};
 	const char *str;
 
-	if (pp->initialized < INIT_NEW || pp->initialized >= __INIT_LAST)
+	if (pp->initialized < INIT_NEW || pp->initialized >= INIT_LAST__)
 		str = "undef";
 	else
 		str = init_state_name[pp->initialized];
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 6b5de7a..56fb74b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -99,7 +99,7 @@ enum find_multipaths_states {
 	FIND_MULTIPATHS_GREEDY,
 	FIND_MULTIPATHS_SMART,
 	FIND_MULTIPATHS_STRICT,
-	__FIND_MULTIPATHS_LAST,
+	FIND_MULTIPATHS_LAST__,
 };
 
 enum marginal_pathgroups_mode {
@@ -258,7 +258,7 @@ enum initialized_states {
 	 * change uevent is received.
 	 */
 	INIT_PARTIAL,
-	__INIT_LAST,
+	INIT_LAST__,
 };
 
 enum prkey_sources {
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index d751780..5df9b02 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -302,7 +302,7 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 		return PATH_IS_ERROR;
 
 	if (conf->find_multipaths <= FIND_MULTIPATHS_UNDEF ||
-	    conf->find_multipaths >= __FIND_MULTIPATHS_LAST)
+	    conf->find_multipaths >= FIND_MULTIPATHS_LAST__)
 		return PATH_IS_ERROR;
 
 	if (safe_sprintf(pp->dev, "%s", name))
diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
index df66ed6..134dfc9 100644
--- a/tests/mpathvalid.c
+++ b/tests/mpathvalid.c
@@ -130,7 +130,7 @@ void make_config_file(int findmp)
 	char buf[64];
 
 	assert_true(findmp > FIND_MULTIPATHS_UNDEF &&
-		    findmp < __FIND_MULTIPATHS_LAST);
+		    findmp < FIND_MULTIPATHS_LAST__);
 
 	r = snprintf(buf, sizeof(buf), "defaults {\nfind_multipaths %s\n}\n",
 		     find_multipaths_optvals[findmp]);
-- 
2.46.0

