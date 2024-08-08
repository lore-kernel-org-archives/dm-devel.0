Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6928818F2C1
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130798; cv=none; b=hg8bXA2isHAE5YqVsSWGrEi+AaxPD+2tCCVKsf5BKqvyGah4qS5SnkHUqUw4sqPEZ46ieeXNB6LpYJhe526CS7lRhJLo+uKhenvg1AOGJbpCJIvK4fDwrXEvaJC9kXoo70GUbIrsPm1mPxmfdwN+TCB30RNa6W5amQrihP5LwWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130798; c=relaxed/simple;
	bh=d4l6Zdrj2dAxZ55hbewueGl6NyCfMz4ZAAq3qegHoBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVP5BXYLBcW+cueK6Zot3s05KWM5eZBrRWWXI4XUMp6tkKFVhcKkrefXOWDt7BVmho3G6iWcT3E0p2UxFMD83NEK+ji6McVKvvTVPRdIB2KW4dkT0fvJED6l4xS/h2UO4MmhMnkajPbrJ5CU6AaOU2CfRBGzhiQL5ldttv8MJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YiFyYsAl; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YiFyYsAl"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a7ad02501c3so135716766b.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130795; x=1723735595; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alGp66DNaPrmoJFpQJ5nlyEFIQ7NpArivQ1RgTLtD/g=;
        b=YiFyYsAlcCq8+KKrwePO8wjUIgsFSHqLlE01R7lQOHufCgqOvKqwI0dbR/F3KFsC/s
         KvlPd68NV2hJxUs8FfviXdBPLdtTgZdnpTNXNZ1NLUt4IfA9bOVF0FPcbcHwS6bcvUoM
         fl14XkwScT12c1EQpigNBabicus4oXDg2hbTbL+02Kqk8sGxiM4Oae0O1DRcIZq5qxRU
         sdjn8eeTOpZxSnz/nthXCn9XEbxVNtQPHdn2R2RLGISH+YMbC5cTQwEnxELE1BKNCbA9
         ZenmAKOqx1+5r8Fvuj+4128CDAZmAlecQ1lqD1xzF74bMIBkdks4JyM+TEiuAfxXSrf4
         dcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130795; x=1723735595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alGp66DNaPrmoJFpQJ5nlyEFIQ7NpArivQ1RgTLtD/g=;
        b=T2xDt/6rc6Rcj5Vcw+qPSk6scV7U9b+OHPWjpBgFrZFJFh1Teas1GS+k3j7qbLaHF1
         V5DXnmwAbFbH+KR2vV3k/59CGY08atUOYgEblZdALQDnwHOt89FmPO8KbukJ5Wu12arn
         5swk8MZy/YT24rpmN0MkNsqnQYEF39f8anv0RKzYvfWYMkXTI11pcHt3APu6Kq8sahVt
         0Bt8DYCm+ro1ivPDKGrrscZQURU5Gj72tfsuXwdiQjTB7XNlVLwQCNGZNt2RRmlO0+mw
         bvKNk3ueVyUG7mse/W3uQgYDMTB8ao0IokSRQagayzaP00oeE+toc5YSHg7YDs+cZPxO
         +8tQ==
X-Gm-Message-State: AOJu0YzMuxVZrrzaR3NKiGIieYqoDe5XYz5Y+owITxz5Jh4WXqvD2G1f
	QKESmUn2xii24v+btN5w20hTz7Dw4ZLeUrUX+/nDM86FNbknb1aRxHy9ZtMuQz0XNRP+MZyhtm8
	j1OE=
X-Google-Smtp-Source: AGHT+IEZQz/Ge/sJdTGwXocZ/Iyzs0FRv8kt4z43ZjNpOK5OTwZ7xGLF1UwXrDme4f3TootD7puWWA==
X-Received: by 2002:a17:907:6d2a:b0:a72:aeff:dfed with SMTP id a640c23a62f3a-a8090e62cdemr154759666b.53.1723130794489;
        Thu, 08 Aug 2024 08:26:34 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c12ad3sm753356466b.88.2024.08.08.08.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:34 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 01/41] multipath-tools tests: make alias.test succeed with increased verbosity
Date: Thu,  8 Aug 2024 17:25:40 +0200
Message-ID: <20240808152620.93965-2-mwilck@suse.com>
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

With MPATHTEST_VERBOSITY > 3, the alias test fails because of an unexpected
message at verbosity level 4. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tests/alias.c b/tests/alias.c
index a95b308..4f23cf9 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -1438,6 +1438,7 @@ static void gufa_empty_new_rw(void **state) {
 
 	mock_bindings_file("");
 	mock_unused_alias("MPATHa");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 
 	mock_allocate_binding("MPATHa", "WWID0");
@@ -1451,6 +1452,7 @@ static void gufa_empty_new_ro_1(void **state) {
 
 	mock_bindings_file("");
 	mock_unused_alias("MPATHa");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	mock_allocate_binding_err("MPATHa", "WWID0", -EROFS, "Read-only file system");
 
@@ -1462,6 +1464,7 @@ static void gufa_empty_new_ro_2(void **state) {
 	char *alias;
 
 	mock_bindings_file("");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	mock_unused_alias("MPATHa");
 
@@ -1473,6 +1476,7 @@ static void gufa_match_a_unused(void **state) {
 	char *alias;
 
 	mock_bindings_file("MPATHa WWID0");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	mock_unused_alias("MPATHa");
 	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
@@ -1486,6 +1490,7 @@ static void gufa_match_a_self(void **state) {
 	char *alias;
 
 	mock_bindings_file("MPATHa WWID0");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	mock_self_alias("MPATHa", "WWID0");
 	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
@@ -1500,6 +1505,7 @@ static void gufa_match_a_used(void **state) {
 
 
 	mock_bindings_file("MPATHa WWID0");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	mock_used_alias("MPATHa", "WWID0");
 
@@ -1514,6 +1520,7 @@ static void gufa_nomatch_a_c(void **state) {
 
 	mock_bindings_file(bindings);
 	mock_unused_alias("MPATHb");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 
 	mock_allocate_binding_len("MPATHb", "WWID1", strlen(bindings));
@@ -1530,6 +1537,7 @@ static void gufa_nomatch_c_a(void **state) {
 
 	mock_bindings_file(bindings);
 	mock_unused_alias("MPATHb");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
 
 	mock_allocate_binding_len("MPATHb", "WWID1", sizeof(bindings) - 1);
@@ -1545,6 +1553,7 @@ static void gufa_nomatch_c_b(void **state) {
 				 "MPATHb WWID1\n");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 	mock_unused_alias("MPATHa");
 
@@ -1561,6 +1570,7 @@ static void gufa_nomatch_c_b_used(void **state) {
 				 "MPATHb WWID1\n");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID4"));
 	mock_used_alias("MPATHa", "WWID4");
 	mock_unused_alias("MPATHd");
@@ -1579,6 +1589,7 @@ static void gufa_nomatch_b_f_a(void **state) {
 				 "MPATHa WWID0\n");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
 	mock_unused_alias("MPATHc");
 
@@ -1595,6 +1606,7 @@ static void gufa_nomatch_b_aa_a(void **state) {
 
 	fill_bindings(&buf, 0, 26);
 	mock_bindings_file(get_strbuf_str(&buf));
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID28"));
 	mock_unused_alias("MPATHab");
 	mock_allocate_binding_len("MPATHab", "WWID28", get_strbuf_len(&buf));
@@ -1611,6 +1623,7 @@ static void gufa_nomatch_b_f_a_sorted(void **state) {
 				 "MPATHa WWID0\n");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
 	mock_unused_alias("MPATHc");
 
@@ -1626,6 +1639,7 @@ static void gufa_old_empty(void **state) {
 
 	/* rlookup_binding for ALIAS */
 	mock_bindings_file("");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_STR("MPATHz"));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 
@@ -1642,6 +1656,7 @@ static void gufa_old_match(void **state) {
 
 	mock_bindings_file("MPATHb WWID1\n"
 			   "MPATHz WWID0");
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID0"));
 
 	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
@@ -1654,6 +1669,7 @@ static void gufa_old_match_other(void **state) {
 	static const char bindings[] = "MPATHz WWID9\n";
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
 	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
@@ -1671,6 +1687,7 @@ static void gufa_old_match_other_used(void **state) {
 	static const char bindings[] = "MPATHz WWID9\n";
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
 	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
@@ -1689,6 +1706,7 @@ static void gufa_old_match_other_wwidmatch(void **state) {
 					"MPATHc WWID2");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
 	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
 	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
@@ -1706,6 +1724,7 @@ static void gufa_old_match_other_wwidmatch_used(void **state) {
 					"MPATHc WWID2");
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
 	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
 	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
@@ -1720,6 +1739,7 @@ static void gufa_old_nomatch_wwidmatch(void **state) {
 	static const char bindings[] = "MPATHa WWID0";
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_STR("MPATHz"));
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	mock_unused_alias("MPATHa");
@@ -1735,6 +1755,7 @@ static void gufa_old_nomatch_wwidmatch_used(void **state) {
 	static const char bindings[] = "MPATHa WWID0";
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_STR("MPATHz"));
 	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
 	mock_used_alias("MPATHa", "WWID0");
@@ -1748,6 +1769,7 @@ static void gufa_old_nomatch_nowwidmatch(void **state) {
 	static const char bindings[] = "MPATHb WWID1\n";
 
 	mock_bindings_file(bindings);
+	expect_condlog(4, "_read_bindings_file: bindings are unchanged");
 	expect_condlog(3, NOMATCH_STR("MPATHz"));
 	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
 
-- 
2.46.0

