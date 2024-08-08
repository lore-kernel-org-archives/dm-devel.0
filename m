Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17550190682
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130836; cv=none; b=TRJAbcnRxSjdYf3djfIvVQMLdZILxGyf/jcd0OPDx5HgH8s/IE0R0LWuh7TB6CzaYiWWtt/LELHv6Qqn7dw0wtV02TgDSJrCLMT6miZBA2aPcRDcCcSJYjjX3UBtGwX8iL89v3dxcUbQH/i/SidfB6LE0O7Z9roovd/Ah/YYhBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130836; c=relaxed/simple;
	bh=UITF0GK3x0gHdrxw7aZ9RsS1odLlv/9Km/ahjukiO+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jedAFHg8MgxF2yCA4iYmd6LZCf4mWKJaOXf37LtIv9VWaR7BVxrtPchOpzeFMHqzqszCKPQq7zJQ1+2CP4Q96VRFW9OwE3ElsnVHqfepMnmoBr/9qhOZkgtZ2O/drW9QP2Z/Vz7yG4T+ho9BZOxT22I9nHktaxifRfwgCqeiLOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eZUyyz6E; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eZUyyz6E"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a843bef98so123077866b.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130832; x=1723735632; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lx2Ry9m27Y+YF0+rvsvzW+CFu1I6ZWccCIgkqAnmUFQ=;
        b=eZUyyz6EQEtXHLY3ZBTLT1dJP4BnkR4HTpZSRsP+yI6rh8OBEOoNaWlHXYNU59pV4D
         5Fqqa2FzWOjgjS0Vf+18rJEFk2H4LZo8+PvUQw/6MP7oECAvXgAYa9xKYMsrzdSjQ3d2
         zhFVIPa6iKVvEr0bABSUg8uYy05vEu3bYv8zDLNaA5DHPZzo1PGgi4IXVWHsLtJKvRf2
         tLYJ/LWqUvtW5YcHmegUOk3/K1/DNtOYGZoZ4cYRuOqBDZcD2ebe41eqUWlR56UCBfBG
         vLVl6dVZKcxOJMHfbWyTOXQ/Ij3ZDIyK2XpvF3JVxVICo15fN7/sSs/6m9MkFRVwf5/2
         Ycew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130832; x=1723735632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lx2Ry9m27Y+YF0+rvsvzW+CFu1I6ZWccCIgkqAnmUFQ=;
        b=e09aIGQX85BsdMNA+rYwfFtbo6GOnfM7G3DTy353LRosqzGG+AL60mJ4ckq36wiQMI
         gKK0oM4ktI0Ei7QfcDZr+TrvZTxa5dI0mn+HAQnsa+pAKsov0Q6gYJmUdjSzfFFu4S8L
         TdH/uYWqED38zHeQUwliy9NU+BU8PCbiE7fhePS58MtAQhs66Qf1YizvFTQ3Mb/UYzr5
         X7nUlBKRR+i5tjncfjpJIPmBrOPIFYrSkLSWd/D5TnansE94x/IbK1sfRA2sPSvmlrB+
         Fff0DaNEmcjA3RrqtLuTfFtKLvNgPcjzqyQd7x9XszAwQaqDX4xCUy0eci4f38HPpkXG
         56Pw==
X-Gm-Message-State: AOJu0YxHIWpV/vPBeFJA676K4+VvktS+uM78VzICGoz7JPgs6k9veCkW
	qsD0oT+z/fVKYUvEeM7hhYvpN0MRF1Thsdr/XTaHXDS/F6yMHyuMy/nFwpFjuz0=
X-Google-Smtp-Source: AGHT+IG/KZ5qGeZpUtX1G1lRk9npFMgzRRBqz1Y9GkNTiTUYOct0lS0q+fBENto/4/srgyr+CkCIWw==
X-Received: by 2002:a17:906:cae8:b0:a7a:8bf9:a6e8 with SMTP id a640c23a62f3a-a8090d94773mr162492966b.35.1723130832102;
        Thu, 08 Aug 2024 08:27:12 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ecad3esm748882566b.206.2024.08.08.08.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:11 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 37/41] multipathd: rename symbols with double leading underscore
Date: Thu,  8 Aug 2024 17:26:16 +0200
Message-ID: <20240808152620.93965-38-mwilck@suse.com>
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

Also remove last mentions of __setup_multipath(), which has been removed in
e5debe0 ("multipathd: don't modify the multipath device on show commands").

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c      |  2 +-
 multipathd/cli.h      |  6 +++---
 multipathd/dmevents.c |  2 +-
 multipathd/main.c     | 30 +++++++++++++++---------------
 multipathd/waiter.c   |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 0c89b7c..139a4c4 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -114,7 +114,7 @@ find_handler (uint32_t fp)
 }
 
 int
-__set_handler_callback (uint32_t fp, cli_handler *fn, bool locked)
+set_handler_callback__ (uint32_t fp, cli_handler *fn, bool locked)
 {
 	struct handler *h;
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 2940832..dd26a2c 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -137,9 +137,9 @@ struct handler {
 };
 
 int alloc_handlers (void);
-int __set_handler_callback (uint32_t fp, cli_handler *fn, bool locked);
-#define set_handler_callback(fp, fn) __set_handler_callback(fp, fn, true)
-#define set_unlocked_handler_callback(fp, fn) __set_handler_callback(fp, fn, false)
+int set_handler_callback__ (uint32_t fp, cli_handler *fn, bool locked);
+#define set_handler_callback(fp, fn) set_handler_callback__(fp, fn, true)
+#define set_unlocked_handler_callback(fp, fn) set_handler_callback__(fp, fn, false)
 
 int get_cmdvec (char *cmd, vector *v, bool allow_incomplete);
 struct handler *find_handler_for_cmdvec(const struct _vector *v);
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index af1e12e..7a78b8f 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -202,7 +202,7 @@ fail:
 	return -1;
 }
 
-/* You must call __setup_multipath() after calling this function, to
+/* You must call setup_multipath() after calling this function, to
  * deal with any events that came in before the device was added */
 int watch_dmevents(char *name)
 {
diff --git a/multipathd/main.c b/multipathd/main.c
index bb19c97..229b516 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -131,7 +131,7 @@ static int poll_dmevents = 1;
 /* Don't access this variable without holding config_lock */
 static enum daemon_status running_state = DAEMON_INIT;
 /* Don't access this variable without holding config_lock */
-static bool __delayed_reconfig;
+static bool delayed_reconfig;
 /* Don't access this variable without holding config_lock */
 static enum force_reload_types reconfigure_pending = FORCE_RELOAD_NONE;
 pid_t daemon_pid;
@@ -243,7 +243,7 @@ static void config_cleanup(__attribute__((unused)) void *arg)
 	pthread_mutex_unlock(&config_lock);
 }
 
-#define __wait_for_state_change(condition, ms)				\
+#define wait_for_state_change__(condition, ms)				\
 	({								\
 		struct timespec tmo;					\
 		int rc = 0;						\
@@ -275,14 +275,14 @@ enum daemon_status wait_for_state_change_if(enum daemon_status oldstate,
 
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
-	__wait_for_state_change(running_state == oldstate, ms);
+	wait_for_state_change__(running_state == oldstate, ms);
 	st = running_state;
 	pthread_cleanup_pop(1);
 	return st;
 }
 
 /* must be called with config_lock held */
-static void __post_config_state(enum daemon_status state)
+static void post_config_state__(enum daemon_status state)
 {
 	if (state != running_state && running_state != DAEMON_SHUTDOWN) {
 		enum daemon_status old_state = running_state;
@@ -299,7 +299,7 @@ void post_config_state(enum daemon_status state)
 {
 	pthread_mutex_lock(&config_lock);
 	pthread_cleanup_push(config_cleanup, NULL);
-	__post_config_state(state);
+	post_config_state__(state);
 	pthread_cleanup_pop(1);
 }
 
@@ -308,15 +308,15 @@ static bool unblock_reconfigure(void)
 	bool was_delayed;
 
 	pthread_mutex_lock(&config_lock);
-	was_delayed = __delayed_reconfig;
+	was_delayed = delayed_reconfig;
 	if (was_delayed) {
-		__delayed_reconfig = false;
+		delayed_reconfig = false;
 		/*
 		 * In IDLE state, make sure child() is woken up
 		 * Otherwise it will wake up when state switches to IDLE
 		 */
 		if (running_state == DAEMON_IDLE)
-			__post_config_state(DAEMON_CONFIGURE);
+			post_config_state__(DAEMON_CONFIGURE);
 	}
 	pthread_mutex_unlock(&config_lock);
 	if (was_delayed)
@@ -350,7 +350,7 @@ void schedule_reconfigure(enum force_reload_types requested_type)
 		break;
 	case DAEMON_IDLE:
 		reconfigure_pending = type;
-		__post_config_state(DAEMON_CONFIGURE);
+		post_config_state__(DAEMON_CONFIGURE);
 		break;
 	case DAEMON_CONFIGURE:
 	case DAEMON_RUNNING:
@@ -378,7 +378,7 @@ static enum daemon_status set_config_state(enum daemon_status state)
 	}
 
 	if (rc == 0 && running_state == DAEMON_IDLE && state != DAEMON_IDLE)
-		__post_config_state(state);
+		post_config_state__(state);
 	st = running_state;
 
 	pthread_cleanup_pop(1);
@@ -3749,17 +3749,17 @@ child (__attribute__((unused)) void *param)
 		       /*
 			* Check if another reconfigure request was scheduled
 			* while we last ran reconfigure().
-			* We have to test __delayed_reconfig here
+			* We have to test delayed_reconfig here
 			* to avoid a busy loop
 			*/
 		       (reconfigure_pending == FORCE_RELOAD_NONE
-			 || __delayed_reconfig))
+			 || delayed_reconfig))
 			pthread_cond_wait(&config_cond, &config_lock);
 
 		if (running_state != DAEMON_CONFIGURE &&
 		    running_state != DAEMON_SHUTDOWN)
 			/* This sets running_state to DAEMON_CONFIGURE */
-			__post_config_state(DAEMON_CONFIGURE);
+			post_config_state__(DAEMON_CONFIGURE);
 		state = running_state;
 		pthread_cleanup_pop(1);
 		if (state == DAEMON_SHUTDOWN)
@@ -3776,13 +3776,13 @@ child (__attribute__((unused)) void *param)
 			reload_type = reconfigure_pending == FORCE_RELOAD_YES ?
 				FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
 			reconfigure_pending = FORCE_RELOAD_NONE;
-			__delayed_reconfig = false;
+			delayed_reconfig = false;
 			pthread_mutex_unlock(&config_lock);
 
 			rc = reconfigure(vecs, reload_type);
 		} else {
 			pthread_mutex_lock(&config_lock);
-			__delayed_reconfig = true;
+			delayed_reconfig = true;
 			pthread_mutex_unlock(&config_lock);
 			condlog(3, "delaying reconfigure()");
 		}
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 1dd93c5..f251c50 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -56,7 +56,7 @@ void stop_waiter_thread (struct multipath *mpp)
 			mpp->alias);
 		return;
 	}
-	/* Don't cancel yourself. __setup_multipath is called by
+	/* Don't cancel yourself. setup_multipath is called by
 	   by the waiter thread, and may remove a multipath device */
 	if (pthread_equal(mpp->waiter, pthread_self()))
 		return;
-- 
2.46.0

