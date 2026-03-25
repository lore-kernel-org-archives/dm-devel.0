Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE43C3453
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774451992; cv=none; b=i5RKYWRc/yYHioA8Wf/7C5mEBem4cR1clqOR+3ErdtVCeWeMY3W7Y1MfJKeoGOwpWBNYVaQleIIY20x6Msi8QBFzkbVDcCrIlHLXNnqlkfIrq4oj+SjrvZdQ9MQSR5kf8TayJrG4cWWdyPC4qxGpzqtkVxWtKXIQ4t5TdkXax98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774451992; c=relaxed/simple;
	bh=P8DUbuGdiUPDANpzfNCQsWBwbTcyXVJ5Oc4acLJkmpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccIzxEwP5wWM/1PlkgjwGf4wr/gXKnTc5h8Uq11YjmKI4DSuD2dbSoqVzGE8TfPewi2N95Vz33S9hEBUUw2pWQS96Fs7fx5vY7x/wsQRXZV8r3W3LZymAAdH2WMFljA46zuRwOYfPzTgTQkHnEecsS2dN05dFrB8w7sQfR1IUc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=TBCn/ZVI; arc=none smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="TBCn/ZVI"
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1279eced0b9so7106190c88.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1774451989; x=1775056789; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DInsSqIMqqXK2GXtza1eyTVhX7KmhJfrp/m/NVa8lDo=;
        b=TBCn/ZVIsvdXhfpIwSfpOg/Tqh3FNWalICBjjKBtuFBMV7pTy+h4vVYvzTvLyWZuu5
         lWfEvz/S3ns0LdeEmIj4YqIlrU1ejLal2LnWWQz7Gw1ckvDxbYMN1+3Mme/GTXRf4I1J
         yzr1nU+bUI/Gsi/+EaAXlyZEmomRJJLpqH7U8PYGpsF6K0LMiZG3a9vJI1rLYifXgFXk
         tANgJfWor30MJeWaMF94M/HixWsazb/EbBGZ6Hvc4k2CpCqk+iN7Ns0m01UmlStkJASX
         inChhZN1F3KVKeAMHxGQK47zu5Q+GnB+2hHQPM+4wmJJK6QxtFHjIMquvrJMgC1ErgHi
         Rlbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774451989; x=1775056789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DInsSqIMqqXK2GXtza1eyTVhX7KmhJfrp/m/NVa8lDo=;
        b=WWuOMDJt8/y5HA3kyOsvqpshxwTqSGq1k0Ay4l6HFJAej555LTWR4hnVCvqEGg0ic1
         7lX+6breEu5zSAEGdc6N0vd0OifhnvuQFAe5t6n6caQ/sfi2Q9tmYFiiqN7N0rQsjpvw
         Yvl/uoAG2NYhl1fjeOFokH6KqCS7XeHRt0ht7BboTCnq3i3zO7QxKeq/hv+8He+W1uwF
         /nDO0NY/5q4GbSzU15V0C6ln/Joh2l3tecOGgLLwJVvqd3ALBJEwfm8XO3QPhO/Tqg6J
         0hAzOqlSvEKhLsZfDAkIkoyKzq+TRefYfIExFj/W8VTPfs+Y0X7gMqb0JY5XJrOBSKUj
         Z7Dg==
X-Gm-Message-State: AOJu0YzEfrn0LMavBNtSDvpMOP0cco3Sy4cWfp0yIn5/XKV9ScOIoppZ
	uhRR9TIRJX041SpfjlaMt3hyzFnjj484+FmCrEtRuM5zskp+AZmBicmegjNq1UZ/sGtncqlxps1
	MvymwOVdgx1Qyuj4mypy6hsD77ZjPI09s/rLM7rVmyVuj42eVKG6KAsgj6f6oIXEF0NYg+x0sfw
	+xFcPlP6VMCGm1GIkPGNcVHSd2Kp1OdO2mCVwHRQdPpO/0
X-Gm-Gg: ATEYQzze/z/+H5tUZepk9lYvwu5Jt2OUij4v09FDrpeharqxtBxYG2WDZ0zGIJ9f/k8
	LUTrC+vV++q7MHsfKaZ7MzwDICB7Jy9rY1Ett9UVs2Ha1L+8n8IvDGYl7bLlmoDa1DaWmUnt2hz
	knP3Mkxi9+wkiWfhfy0ByuYWYAlJ85ZsWj79vuy4D1FkpuK5paEZnH8r5rANiaHKAH0kudzRqgE
	s683461CFMvMRk1wpTS5Z/NRIrpFvXODiVCiBVgfyoXqzV7JQ9l0rBjUyjmm2t+3wafISTEqMkH
	j92+eMLLF5GrXIugojY+dMzZZ7pYg4bc7I9IGnlLCUbwea58P9eLxNo1/BhKjqNOn1I4s6AJb3T
	9KfWDDW/vQPvI6FUBqlia777RaXqH1j+XvMWEy12pta2T9g/WZ1WVPsrwupDLpKW7yPt/C/v/Ik
	DneM660Rl4d2xqOEtFhw2W+UouN+2JoB9IQuF+opk8xAErF/kngVOsDgCfVhfchzz7cmbP4mdzm
	dacDUcze4xTGnYRIX/7A04NdyN1rkiVMAKsA4pXg5/r5PJmBH0WJQqLd8peewhEyg==
X-Received: by 2002:a05:7022:f93:b0:123:330b:3a0 with SMTP id a92af1059eb24-12a96e5e6edmr1856035c88.14.1774451988893;
        Wed, 25 Mar 2026 08:19:48 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.81])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12aa6513e9bsm167355c88.0.2026.03.25.08.19.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Mar 2026 08:19:48 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: dm-devel@lists.linux.dev
Cc: mwilck@suse.com,
	bmarzins@redhat.com,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 2/2] prioritizers: add alua_cached prioritizer
Date: Wed, 25 Mar 2026 08:19:35 -0700
Message-ID: <20260325151940.18928-3-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325151940.18928-1-brian@purestorage.com>
References: <20260325151940.18928-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Add an 'alua_cached' prioritizer that uses cached ALUA state from the
alua path checker when available. This eliminates duplicate RTPG
commands when both checker and prioritizer need ALUA state.

The prioritizer checks for cached state first, then falls back to
sysfs, then to issuing RTPG directly. This maintains backward
compatibility with other checker configurations.

When the alua checker is in use and detect_prio is enabled, the
alua_cached prioritizer is auto-selected.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 libmultipath/prio.c                     |   1 +
 libmultipath/prio.h                     |   1 +
 libmultipath/prioritizers/Makefile      |   1 +
 libmultipath/prioritizers/alua_cached.c | 195 ++++++++++++++++++++++++
 libmultipath/prioritizers/sysfs.c       |   7 +-
 libmultipath/propsel.c                  |  13 +-
 6 files changed, 214 insertions(+), 4 deletions(-)
 create mode 100644 libmultipath/prioritizers/alua_cached.c

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 24f825bd..2d59d04e 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -29,6 +29,7 @@ int init_prio(void)
 #ifdef LOAD_ALL_SHARED_LIBS
 	static const char *const all_prios[] = {
 		PRIO_ALUA,
+		PRIO_ALUA_CACHED,
 		PRIO_CONST,
 		PRIO_DATACORE,
 		PRIO_EMC,
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 119b75f2..b54ece0d 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -17,6 +17,7 @@ struct path;
  * Known prioritizers for use in hwtable.c
  */
 #define PRIO_ALUA		"alua"
+#define PRIO_ALUA_CACHED	"alua_cached"
 #define PRIO_CONST		"const"
 #define PRIO_DATACORE		"datacore"
 #define PRIO_EMC		"emc"
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index ff2524c2..201c52c0 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -13,6 +13,7 @@ LIBDEPS = -lmultipath -lmpathutil -lm -lpthread -lrt
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
 	libprioalua.so \
+	libprioalua_cached.so \
 	libprioconst.so \
 	libpriodatacore.so \
 	libprioemc.so \
diff --git a/libmultipath/prioritizers/alua_cached.c b/libmultipath/prioritizers/alua_cached.c
new file mode 100644
index 00000000..02ebc613
--- /dev/null
+++ b/libmultipath/prioritizers/alua_cached.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ALUA prioritizer that uses cached state from alua checker
+ *
+ * Based on the ALUA prioritizer (C) Copyright IBM Corp. 2004, 2005
+ *
+ * Copyright (c) 2026 Brian Bunker <brian@purestorage.com>
+ * Copyright (c) 2026 Krishna Kant <krishna.kant@purestorage.com>
+ */
+#include <stdio.h>
+#include <string.h>
+
+#include "checkers.h"
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "discovery.h"
+#include "time-util.h"
+
+#include "alua.h"
+
+/* Maximum age of cached ALUA state in seconds */
+#define ALUA_CACHE_MAX_AGE_SECS			5
+
+/*
+ * Try to get ALUA info with optimization:
+ * 1. If using alua checker: use its cached state (it just polled!)
+ * 2. Try sysfs (kernel maintains this, no I/O needed)
+ * 3. Fall back to issuing RTPG directly
+ *
+ * Rationale: The checker is our active poller. If we're using alua
+ * and its cache is fresh, we trust that data first. If the cache misses
+ * (stale or empty), we try sysfs before issuing RTPG. This provides a
+ * three-tier optimization: checker cache → sysfs → RTPG.
+ */
+/* Maximum length of sysfs access_state string */
+#define ALUA_ACCESS_STATE_SIZE 32
+
+int
+get_alua_info_cached(struct path * pp, bool *used_cache)
+{
+	int	rc;
+	int	tpg;
+	bool	diff_tpg;
+	char	buff[ALUA_ACCESS_STATE_SIZE];
+
+	*used_cache = false;
+
+	/* First: if using alua checker, use its fresh data from path structure */
+	if (checker_selected(&pp->checker)) {
+		const char *chk_name = checker_name(&pp->checker);
+
+		if (chk_name && strcmp(chk_name, "alua") == 0 &&
+		    pp->alua_state >= 0) {
+			struct timespec ts;
+			time_t age;
+
+			get_monotonic_time(&ts);
+			age = ts.tv_sec - pp->alua_timestamp;
+
+			if (pp->alua_timestamp > 0 && age <= ALUA_CACHE_MAX_AGE_SECS) {
+				condlog(4, "%s: using cached ALUA state from checker (fresh poll)", pp->dev);
+				*used_cache = true;
+				return pp->alua_state;
+			}
+			condlog(4, "%s: cached ALUA state not available or stale, trying sysfs",
+				pp->dev);
+			/* Cache miss - try sysfs before issuing RTPG */
+		}
+	}
+
+	/* Second: try sysfs (if cache missed or not using alua checker) */
+	rc = sysfs_get_asymmetric_access_state(pp, buff, sizeof(buff));
+	if (rc >= 0) {
+		/* Parse sysfs state string to ALUA state value */
+		int aas = -1;
+		int priopath = rc; /* rc contains preferred bit */
+
+		if (!strncmp(buff, "active/optimized", 16))
+			aas = AAS_OPTIMIZED;
+		else if (!strncmp(buff, "active/non-optimized", 20))
+			aas = AAS_NON_OPTIMIZED;
+		else if (!strncmp(buff, "lba-dependent", 13))
+			aas = AAS_LBA_DEPENDENT;
+		else if (!strncmp(buff, "standby", 7))
+			aas = AAS_STANDBY;
+
+		if (aas >= 0) {
+			condlog(4, "%s: using sysfs ALUA state (no I/O)", pp->dev);
+			*used_cache = true;
+			return (priopath ? 0x80 : 0) | aas;
+		}
+	}
+
+	/* Last resort: issue RTPG directly */
+	tpg = get_target_port_group(pp);
+	if (tpg < 0) {
+		rc = get_target_port_group_support(pp);
+		if (rc < 0)
+			return -ALUA_PRIO_TPGS_FAILED;
+		if (rc == TPGS_NONE)
+			return -ALUA_PRIO_NOT_SUPPORTED;
+		return -ALUA_PRIO_RTPG_FAILED;
+	}
+	diff_tpg = (pp->tpg_id != GROUP_ID_UNDEF && pp->tpg_id != tpg);
+	pp->tpg_id = tpg;
+	condlog((diff_tpg) ? 2 : 4, "%s: reported target port group is %i",
+		pp->dev, tpg);
+	rc = get_asymmetric_access_state(pp, tpg);
+	if (rc < 0) {
+		condlog(2, "%s: get_asymmetric_access_state returned %d",
+			__func__, rc);
+		return -ALUA_PRIO_GETAAS_FAILED;
+	}
+
+	condlog(3, "%s: aas = %02x [%s]%s", pp->dev, rc, aas_print_string(rc),
+		(rc & 0x80) ? " [preferred]" : "");
+	return rc;
+}
+
+int get_exclusive_pref_arg(char *args)
+{
+	char *ptr;
+
+	if (args == NULL)
+		return 0;
+	ptr = strstr(args, "exclusive_pref_bit");
+	if (!ptr)
+		return 0;
+	if (ptr[18] != '\0' && ptr[18] != ' ' && ptr[18] != '\t')
+		return 0;
+	if (ptr != args && ptr[-1] != ' ' && ptr[-1] != '\t')
+		return 0;
+	return 1;
+}
+
+int getprio (struct path * pp, char * args)
+{
+	int rc;
+	int aas;
+	int priopath;
+	int exclusive_pref;
+	bool used_cache = false;
+
+	if (pp->fd < 0)
+		return -ALUA_PRIO_NO_INFORMATION;
+
+	exclusive_pref = get_exclusive_pref_arg(args);
+	rc = get_alua_info_cached(pp, &used_cache);
+
+	if (used_cache) {
+		condlog(4, "%s: priority calculated from cached ALUA state (no RTPG issued)",
+			pp->dev);
+	}
+
+	if (rc >= 0) {
+		aas = (rc & 0x0f);
+		priopath = (rc & 0x80);
+		switch(aas) {
+		case AAS_OPTIMIZED:
+			rc = 50;
+			break;
+		case AAS_NON_OPTIMIZED:
+			rc = 10;
+			break;
+		case AAS_LBA_DEPENDENT:
+			rc = 5;
+			break;
+		case AAS_STANDBY:
+			rc = 1;
+			break;
+		default:
+			rc = 0;
+		}
+		if (priopath && (aas != AAS_OPTIMIZED || exclusive_pref))
+			rc += 80;
+	} else {
+		switch(-rc) {
+		case ALUA_PRIO_NOT_SUPPORTED:
+			condlog(0, "%s: alua not supported", pp->dev);
+			break;
+		case ALUA_PRIO_RTPG_FAILED:
+			condlog(0, "%s: couldn't get target port group", pp->dev);
+			break;
+		case ALUA_PRIO_GETAAS_FAILED:
+			condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
+			break;
+		case ALUA_PRIO_TPGS_FAILED:
+			condlog(3, "%s: couldn't get supported alua states", pp->dev);
+			break;
+		}
+	}
+	return rc;
+}
+
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
index 5e8adc05..ab058ea9 100644
--- a/libmultipath/prioritizers/sysfs.c
+++ b/libmultipath/prioritizers/sysfs.c
@@ -10,6 +10,9 @@
 #include "discovery.h"
 #include "prio.h"
 
+/* Maximum length of sysfs access_state string */
+#define ALUA_ACCESS_STATE_SIZE 32
+
 static const struct {
 	unsigned char value;
 	char *name;
@@ -39,11 +42,11 @@ int get_exclusive_pref_arg(char *args)
 int getprio (struct path * pp, char *args)
 {
 	int prio = 0, rc, i;
-	char buff[512];
+	char buff[ALUA_ACCESS_STATE_SIZE];
 	int exclusive_pref;
 
 	exclusive_pref = get_exclusive_pref_arg(args);
-	rc = sysfs_get_asymmetric_access_state(pp, buff, 512);
+	rc = sysfs_get_asymmetric_access_state(pp, buff, sizeof(buff));
 	if (rc < 0)
 		return PRIO_UNDEF;
 	prio = 0;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 020b84d7..7cd81462 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -262,6 +262,7 @@ verify_alua_prio(struct multipath *mp)
 		if (!prio_selected(&pp->prio))
 			continue;
 		if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
+		    strncmp(name, PRIO_ALUA_CACHED, PRIO_NAME_LEN) &&
 		    strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
 			 return false;
 		assume_alua = true;
@@ -775,8 +776,15 @@ void detect_prio(struct path *pp)
 		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
 		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 			default_prio = PRIO_SYSFS;
-		else
+		else {
 			default_prio = PRIO_ALUA;
+			/* If using alua checker, use cached prioritizer */
+			if (checker_selected(&pp->checker)) {
+				const char *chk_name = checker_name(&pp->checker);
+				if (chk_name && strcmp(chk_name, ALUA) == 0)
+					default_prio = PRIO_ALUA_CACHED;
+			}
+		}
 		break;
 	default:
 		return;
@@ -839,7 +847,8 @@ out:
 	/*
 	 * fetch tpgs mode for alua, if its not already obtained
 	 */
-	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
+	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN) ||
+	    !strncmp(prio_name(p), PRIO_ALUA_CACHED, PRIO_NAME_LEN)) {
 		int tpgs = path_get_tpgs(pp);
 
 		if (tpgs == TPGS_NONE) {
-- 
2.50.1 (Apple Git-155)

