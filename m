Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC61C68BE
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032753; cv=none; b=UA6YVQQVp10C4wAYTsjAPYwYLyWtgrgzG5pyHtA3t33eaBuVfG/+e1BD6KJifkStEZ/gltc4BKeWNe9a9v0EOa/X7g33JAHXmu9PrWZDPBnzv4bKO2JfkxeiCrtIxIspI0Q3XczPPXa3hkrhyrRoPqHJFRgIPmtolSMGON6g4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032753; c=relaxed/simple;
	bh=Yl+qMOdKhN3Bh33dTs7LXhiGItLLdyn+SEFJgwFayVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzIlZG/aEnl/QbCQ5UDCweLm699siqxlDulyplUbtoFHrJEq0HQqZUKJvNEbX0Ufjy3lmzYCgZAvd0ky9o0ZZnCXsjSadZYuz1FRP308TTeuorNqplEg7cZrJ+sUyAT/5a7lGxwavM6FAJ2BSvH9yN07yHfAxiu9kzuAXaUnKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UXX+kVvq; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UXX+kVvq"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-539eb97f26aso6130235e87.2
        for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 08:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732032749; x=1732637549; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bIFqYXULyPsioaTRNShPwGe775dP8pfxkKvpCFucgU=;
        b=UXX+kVvqNG1vkNBOwQirwhfTdGIsh2ePcvkD+3oDCnewXrma13C4rGUjmCUQ39wdO9
         /fACPsy9UF4pfHzfCqEnfDhb8RYlaIwH7umh21fcbVmVlOnFQWrgisYc6U7+3Jhx7iea
         mxs/vDwJV2cf11dIEARkkKRcL3HB3tnx4rnNDcWAO/nUekT6N3NDJKL/xvofXY6pywPR
         nnxU7zXeY8uCjpWYGNZHRKPbhrHivWq5IaVPJlO/kbn6HDvraiE/QRbWDqJgteDBk8HE
         8zYLT4PBSbUzFu3U9DZ1RO5fH+f2/AG0sxDVlPFJtfnLlstGLSmONngBRrS3ajz0u/qy
         VYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732032749; x=1732637549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bIFqYXULyPsioaTRNShPwGe775dP8pfxkKvpCFucgU=;
        b=BXyzrqHJU3NFbxwj1fNotjj5eKpDdcRaBMwRNZHbmgb1wu0FJ9sBMk9Ng2+BCj2oDo
         TyapLbq86yxaIE8/w0tCgi6M9xz/JdUrQ3N7B2LFSAtl3A4gKhGnlmX4i7mjsZn/T738
         56vplLSvlv8/rR9tGqr1rVA4r1sa33lgHFRuKlGpGmp8DZlLpQ9/QRVBC1OZRcxkxaGD
         h2zQjMS5nqgp9TnKBAplCbv7NRHJlNQT16y8O7tm3c4oPadGGKZEy5t6DD/wZl2zkjcB
         4mEKwRiTCx5JbD/uRyn3VyfkKJmJSKbHULrYJGVTIggQtHFOlU725x3cZ+wxPougnY5w
         +IxA==
X-Gm-Message-State: AOJu0YzQBiwg2F4ugK7zn0XuzwXx46fgvPKNXZ5QXETVewRNAk7/Bv9b
	jVj7pDFbc3fr+mg1V274s/oh0b5EjAXfJ6fnXji/6bzlss3DbHOmpXxXFbDs8kg=
X-Google-Smtp-Source: AGHT+IFi77UktGOVPj8sRvZ8HgR5OWD3aI2kgjdR+jdJuNrftgJH/Zjz1vmLb3CIIQT03kd9u//p5Q==
X-Received: by 2002:a05:6512:230f:b0:53d:a4f3:29ed with SMTP id 2adb3069b0e04-53dab2a6397mr6606529e87.27.1732032749267;
        Tue, 19 Nov 2024 08:12:29 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432dac0ae04sm195571075e9.33.2024.11.19.08.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 08:12:29 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/1] multipathd: move systemd watchdog handling into daemon
Date: Tue, 19 Nov 2024 17:12:18 +0100
Message-ID: <20241119161218.708117-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119161218.708117-1-mwilck@suse.com>
References: <20241119161218.708117-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only multipathd needs to take care of notifying systemd. There's
no need to track this information in struct config, or to limit our
checker interval to it, as checkerloop() wakes up every second anyway.

While at it, fix the watchdog enablement logic:

- the watchdog should only be active if WATCHDOG_PID is either unset,
  or matches the daemon's PID, and if WATCHDOG_USEC is not 0.
- the watchdog should trigger twice per systemd-set interval.
- if WatchdogSec= is set to an unreasonable value, make a smarter
  choice than just disabling the watchdog, and print a more meaningful
  error message.

Use timestamp comparison to make sure the watchdog is triggered even
if a checkerloop iteration takes more than a second.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 25 ----------------
 libmultipath/config.h |  1 -
 multipathd/main.c     | 70 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 0e3a5cc..8b424d1 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -858,27 +858,6 @@ process_config_dir(struct config *conf, char *dir)
 	pthread_cleanup_pop(1);
 }
 
-#ifdef USE_SYSTEMD
-static void set_max_checkint_from_watchdog(struct config *conf)
-{
-	char *envp = getenv("WATCHDOG_USEC");
-	unsigned long checkint;
-
-	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
-		/* Value is in microseconds */
-		checkint /= 1000000;
-		if (checkint < 1 || checkint > UINT_MAX) {
-			condlog(1, "invalid value for WatchdogSec: \"%s\"", envp);
-			return;
-		}
-		if (conf->max_checkint == 0 || conf->max_checkint > checkint)
-			conf->max_checkint = checkint;
-		condlog(3, "enabling watchdog, interval %ld", checkint);
-		conf->use_watchdog = true;
-	}
-}
-#endif
-
 static int init_config__ (const char *file, struct config *conf);
 
 int init_config(const char *file)
@@ -916,7 +895,6 @@ int init_config__ (const char *file, struct config *conf)
 	conf->attribute_flags = 0;
 	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
 	conf->checkint = CHECKINT_UNDEF;
-	conf->use_watchdog = false;
 	conf->max_checkint = 0;
 	conf->force_sync = DEFAULT_FORCE_SYNC;
 	conf->partition_delim = (default_partition_delim != NULL ?
@@ -967,9 +945,6 @@ int init_config__ (const char *file, struct config *conf)
 	/*
 	 * fill the voids left in the config file
 	 */
-#ifdef USE_SYSTEMD
-	set_max_checkint_from_watchdog(conf);
-#endif
 	if (conf->max_checkint == 0) {
 		if (conf->checkint == CHECKINT_UNDEF)
 			conf->checkint = DEFAULT_CHECKINT;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 94cdf25..5b4ebf8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -148,7 +148,6 @@ struct config {
 	unsigned int checkint;
 	unsigned int max_checkint;
 	unsigned int adjust_int;
-	bool use_watchdog;
 	int pgfailback;
 	int rr_weight;
 	int no_path_retry;
diff --git a/multipathd/main.c b/multipathd/main.c
index a99da81..f96d61a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2153,6 +2153,61 @@ partial_retrigger_tick(vector pathvec)
 	}
 }
 
+#ifdef USE_SYSTEMD
+static int get_watchdog_interval(void)
+{
+	const char *envp;
+	long long checkint;
+	long pid;
+
+	envp = getenv("WATCHDOG_PID");
+	/* See sd_watchdog_enabled(3) */
+	if (envp && sscanf(envp, "%lu", &pid) == 1 && pid != daemon_pid)
+		return -1;
+
+	envp = getenv("WATCHDOG_USEC");
+	if (!envp || sscanf(envp, "%llu", &checkint) != 1 || checkint == 0)
+		return -1;
+
+	/*
+	 * Value is in microseconds, and the watchdog should be triggered
+	 * twice per interval.
+	 */
+	checkint /= 2000000;
+	if (checkint > INT_MAX / 2) {
+		condlog(1, "WatchdogSec=%lld is too high, assuming %d",
+			checkint * 2, INT_MAX);
+			checkint = INT_MAX / 2;
+	} else if (checkint < 1) {
+		condlog(1, "WatchdogSec=1 is too low, daemon will be killed by systemd!");
+		checkint = 1;
+	}
+
+	condlog(3, "enabling watchdog, interval %llds", checkint);
+	return checkint;
+}
+
+static void watchdog_tick(const struct timespec *time) {
+	static int watchdog_interval;
+	static struct timespec last_time;
+	struct timespec diff_time;
+
+	if (watchdog_interval == 0)
+		watchdog_interval = get_watchdog_interval();
+	if (watchdog_interval < 0)
+		return;
+
+	timespecsub(time, &last_time, &diff_time);
+	if (diff_time.tv_sec >= watchdog_interval) {
+		condlog(4, "%s: sending watchdog message", __func__);
+		sd_notify(0, "WATCHDOG=1");
+		last_time = *time;
+	}
+}
+#else
+static void watchdog_tick(const struct timespec *time __attribute__((unused))) {}
+#endif
+
 static bool update_prio(struct multipath *mpp, bool refresh_all)
 {
 	int oldpriority;
@@ -2931,9 +2986,6 @@ checkerloop (void *ap)
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
-#ifdef USE_SYSTEMD
-	bool use_watchdog;
-#endif
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
@@ -2944,13 +2996,6 @@ checkerloop (void *ap)
 	get_monotonic_time(&last_time);
 	last_time.tv_sec -= 1;
 
-	/* use_watchdog is set from process environment and never changes */
-	conf = get_multipath_config();
-#ifdef USE_SYSTEMD
-	use_watchdog = conf->use_watchdog;
-#endif
-	put_multipath_config(conf);
-
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
 		int num_paths = 0, strict_timing;
@@ -2967,10 +3012,7 @@ checkerloop (void *ap)
 			(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
 		last_time = start_time;
 		ticks = diff_time.tv_sec;
-#ifdef USE_SYSTEMD
-		if (use_watchdog)
-			sd_notify(0, "WATCHDOG=1");
-#endif
+		watchdog_tick(&start_time);
 		while (checker_state != CHECKER_FINISHED) {
 			struct multipath *mpp;
 			int i;
-- 
2.47.0

