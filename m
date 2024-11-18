Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FDD19DF99
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 13:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731935101; cv=none; b=ey+rPz8Imm71dA/w9CUymJAJ6gub/hc4dQiCWT2cRg1LxopEJ7OAwHLQH7l9jLvZQhnbIUWTjHOUiek55+nPD0HE/CuxONPHdKu2ievaBPL2mlr7W0IWgb2hsi7JoPIBP3uw9nBW7OFgWPM1UmtAVwQsLBodR9tF34rQeU55Hwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731935101; c=relaxed/simple;
	bh=+zYj7r1vRR+79IBbPUeDpY64yeE6BfT1vMHZ836ddrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dexPEV+XI7Z0IHHk6JqUHnej+1lZ5BDBWSKfIUVuv+hXea6HZC46mqImE/e20LPSBWBO5tdSAXHaFOAoJO6LDvQmo8ukGGb1pFJH43ivFcd8Q3xokARNwPMIrNR47gaQgTeqFuXnP7X+VucIynrRzt0SZ82e3wrM/EkVLb4WMnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KuKaAP9c; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KuKaAP9c"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43152b79d25so25063635e9.1
        for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 05:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731935097; x=1732539897; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6EO5PR9eLjVIjamApS3s1tgsOsmkFqKE7XnBOd+x3o=;
        b=KuKaAP9c4QcUtd6YuxkwEGdDbxv/1zoqboRG5jVJSEIJXUioeyofyn7omzZxLJO+dw
         06+PMVC12KVgGkbGZNdPU1hpxfkNlMeiIXP1Qc097S35AN2kJkyBwDiS2pEDU0NVEuus
         9/1fPy0oqGnsB2WcNbvZ1tMzF5d+ecAq4ey2qB9C8AorYJimeruEVqxMRchnMEx+Zf3d
         J7BQGcbrNDIYhDmJ2x8E0xpOEe9iBCWpTufCNimvESgC8FWjCi+K6qIC8Byt+yoTEXlA
         Y8Kn5jxcgJ3yvpX9GHtAPYhk0WHGIBfd25JPuQHAWoJso5IqL+OTE+H2UZKtiRHHe2lr
         ocgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731935097; x=1732539897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6EO5PR9eLjVIjamApS3s1tgsOsmkFqKE7XnBOd+x3o=;
        b=dBnLD9HHduIRZhpnxRitu3TxYPaeEDgRSf9mGZpaOXl7U+/9WDk9DK4XwhJ7TIuoIN
         bZZajwBNh2j90iP73Y/8y6HUjIeljyjAr8fgRYBDG6c25ssrc9sjzlKUAXcYDzNnULJR
         dJT4kDZQoHfR74kZp3sm6WsYdWfcpxT05KBYamA7ohElJVyScJs61jF85tsIZRk/5W6N
         1F7cHZoWJ8wZXdUAZoOy8BPloTWc6EBsCbAJ++3vi0DJyeDZRw8mbR9zKYaFwrZiY8VK
         V7fMaI9Qhuisp2sWJE1Xbk69+l4tbxY4119Wm9qyJ9ih3/vg47PuaWNryJSc/YRSQi4t
         tSHA==
X-Gm-Message-State: AOJu0Ywgtu6Z6y0aeF7FN1fpBqnfz0NsF75INm4eXVo9M6Afxb3Uqg+F
	od07CVBeEIBAT5zRLJ4Ff91Ld0GpaJtsC4NDXOrF3UAHp6e4ega3qr6+IDlEYxA=
X-Google-Smtp-Source: AGHT+IEH61Uamr2CZdBDWOuI6zOMIvWPaYf0hPmFUspZZ2086oVDW0LGUbzNQ3XYMm0ZwPdpIQ47fw==
X-Received: by 2002:a05:6000:2108:b0:382:27ab:7b9 with SMTP id ffacd0b85a97d-38227ab0856mr8043268f8f.54.1731935097228;
        Mon, 18 Nov 2024 05:04:57 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38249ed88d8sm1890629f8f.48.2024.11.18.05.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 05:04:56 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/1] multipathd: move systemd watchdog handling into daemon
Date: Mon, 18 Nov 2024 14:04:47 +0100
Message-ID: <20241118130447.554773-2-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241118130447.554773-1-mwilck@suse.com>
References: <20241118130447.554773-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 25 ----------------
 libmultipath/config.h |  1 -
 multipathd/main.c     | 67 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 53 insertions(+), 40 deletions(-)

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
index a99da81..1f0d02c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2153,6 +2153,58 @@ partial_retrigger_tick(vector pathvec)
 	}
 }
 
+#ifdef USE_SYSTEMD
+static int get_watchdog_interval(void)
+{
+	char *envp;
+	long checkint;
+	long pid;
+
+	envp = getenv("WATCHDOG_PID");
+	/* See sd_watchdog_enabled(3) */
+	if (envp && sscanf(envp, "%lu", &pid) == 1 && pid != daemon_pid)
+		return -1;
+
+	envp = getenv("WATCHDOG_USEC");
+	if (!envp || sscanf(envp, "%lu", &checkint) != 1 || checkint == 0)
+		return -1;
+
+	/*
+	 * Value is in microseconds, and the watchdog should be triggered
+	 * twice per interval.
+	 */
+	checkint /= 2000000;
+	if (checkint > INT_MAX / 2) {
+		condlog(1, "WatchdogSec=%ld is too high, assuming %d",
+			checkint * 2, INT_MAX);
+			checkint = INT_MAX / 2;
+	} else if (checkint < 1) {
+		condlog(1, "WatchdogSec=1 is too low, daemon will be killed by systemd!");
+		checkint = 1;
+	}
+
+	condlog(3, "enabling watchdog, interval %lds", checkint);
+	return checkint;
+}
+
+static void watchdog_tick(void) {
+	static int watchdog_interval, watchdog_tick;
+
+	if (watchdog_interval == 0)
+		watchdog_interval = get_watchdog_interval();
+	if (watchdog_interval < 0)
+		return;
+
+	if (--watchdog_tick < 0) {
+		condlog(4, "%s: sending watchdog message", __func__);
+		sd_notify(0, "WATCHDOG=1");
+		watchdog_tick = watchdog_interval;
+	}
+}
+#else
+static void watchdog_tick(void) {}
+#endif
+
 static bool update_prio(struct multipath *mpp, bool refresh_all)
 {
 	int oldpriority;
@@ -2931,9 +2983,6 @@ checkerloop (void *ap)
 	struct timespec last_time;
 	struct config *conf;
 	int foreign_tick = 0;
-#ifdef USE_SYSTEMD
-	bool use_watchdog;
-#endif
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
@@ -2944,13 +2993,6 @@ checkerloop (void *ap)
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
@@ -2967,10 +3009,7 @@ checkerloop (void *ap)
 			(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
 		last_time = start_time;
 		ticks = diff_time.tv_sec;
-#ifdef USE_SYSTEMD
-		if (use_watchdog)
-			sd_notify(0, "WATCHDOG=1");
-#endif
+		watchdog_tick();
 		while (checker_state != CHECKER_FINISHED) {
 			struct multipath *mpp;
 			int i;
-- 
2.47.0

