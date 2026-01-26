Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCBD335094
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429618; cv=none; b=LK2Y6yBFhB0cDVJ4ixBpA0T4c45riF7xWTHZ37/BcIVP+n9Nlwu5uTCJTY+/c7TszlBJkyuAVR5etrT3zLJRTneN1XTl54g7Zw+ou8Q2fubonzb2vHfqWLQQYKufIO9XkgmzfANdPIV/c03gdc5gwqflahlxvcddi7hLHYLpbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429618; c=relaxed/simple;
	bh=PRqSoiRNmo/oGibpN2auWoS4GtaLRMlJbPV+0wPbuIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RhdAbEW/sIrqUwaFipkOz3jUylySPpkjybUH/Pr9P4sJolUbQcUDKIQoSV7p4cIx5+NpvYoE4KrDQoYuD8+fMbiiTY1x77BcMzFu/th67n4yk02V0qJ4dAGM7FP+6UI/nWoSVVTqckEeg68PXtwoVUcMBcaPcPw+lrCYRKx+VhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e48gqsyP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e48gqsyP"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47ee301a06aso51306225e9.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 04:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769429615; x=1770034415; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=euNPhpJbBqy7FGShIuikf6pVpsrbMy/Y95LZ8PISAeM=;
        b=e48gqsyPP4RMTBPE2VBOO91moyfN6bZVj/tCxiabWFMSTRoBYLIIqbEt0h2RCw//ZR
         2yKiH3A7ngnmbhR5CyUviiu61x8D7JHM5cpEm026lY0pU30LwcuLLYwhuMk9iOVOWSt9
         iVcz6OOVD9tamAUYgNgAcsFrSt1ad4Va+PK/qBwlicVAAkpFCgBY/v3KZdyTVztfP3/1
         yaY0mOuhSvRnl7ZPC+/iP95HC0G1oQtgg8ClnGQh3J2gXau0tk5i2CN+0T+3aY0F84tL
         p3sYw+RlbcUv5RUtqQPUGzOn/r04WwNJeJFuzO2y97r6RBcfsRmIzqZ41Wz+FWZI6xcB
         QAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769429615; x=1770034415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euNPhpJbBqy7FGShIuikf6pVpsrbMy/Y95LZ8PISAeM=;
        b=Vvz0Rzv+kxLAgm+qP0zByGiujRyRmah299nu+YLrpZfEPiLXmeEEZ1BeMX64H72c++
         1yZI1HU45tkSll9XmVe5S9QbGJtL/gCiPe36eKUZfnleS6RAQkFhqeLaZZtAu/oIeiia
         b/aoyK2eaLsZAPT7SuENQVNyRTSFXtnrj3x4J5K065OYIKjzjqBxLsY5EyZsMjIPkYUW
         gjUVQEwCyHXnRiCjlI4fvhMDFfEmLAuYGsEoA3WuBY96KDagpQqt0HJ4AUxXNTIOQxCw
         ec8qWtZmONh7kkz8cRAyisqVz4kP0RAeINBMMJLJ+1NBo0x2AqRP/4G4Jrqu+TjC4Ayv
         fFyA==
X-Forwarded-Encrypted: i=1; AJvYcCVRzPwrTp22E7Kqq+beIdqEYbyYPMCbL5Fy7RZ4mFlAVpTL2RYjzg8HDMMozT1NTFN5HpqQyJ7kNg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMG3gtd2U0wrW+vUbjFqOzH3lq7t18pRcbx2fdMu0s/uy7mh/d
	xbNmfymb0shmW9GevqwWuX8m2WhuE7nPCxogsiaO1vxzB0RUUHDUEZgaxhxdImvZkmY=
X-Gm-Gg: AZuq6aKBZf50xyPNS1iJgmVp2CQejzN0jIj5GeDP3Idn2ZEPUx6R3y5PYIa0snPmG3l
	rTSzVbRS9b9IF9suepmwruhRi8V8FXpsG/+fGQ5puNX45L/YOnx/YBQgWg/OcXoPaR+H8mSD/dP
	MxoAKhxkjaPVE0psQULGiSGEgfhhQNrijj1Apdxg4uLhoYdkdWJO1WMbq8vckkFAcZQuoi5U0kq
	fBEOWSD2rgJ5c8QP381umLf9bJMHYEuBEYv4hFgKVLi8TEPIJnXv5mWRfV7TUekG2NLCyJoO9MS
	KKfMkAop45putselnvBiFFR9Cllu4fH8aEh8FEHAccyxPlyeGDa7l3qwO7HThQ4f+BXC9KDzetm
	b8U7KXYYSI7+K4H0w1DHaAx9ILXFu0YMoUUhP1GUkfOLKd5y2eZ1q5dEJUROc9f4s/RiGBGfDZt
	YlnUQKuWihx7kKn19VXF5dP5ViMRfWeQDmwTzHLtC/hbGvdHxcTyHnonjXSR3VZnVK4VUcqElqG
	Q==
X-Received: by 2002:a05:6000:2501:b0:431:4c6:724d with SMTP id ffacd0b85a97d-435ca1ad9f3mr7717459f8f.29.1769429614726;
        Mon, 26 Jan 2026 04:13:34 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-435b1c0179bsm29603552f8f.1.2026.01.26.04.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 04:13:34 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] kpartx: fix segfault when operating on regular files
Date: Mon, 26 Jan 2026 13:13:25 +0100
Message-ID: <20260126121325.208908-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following problem has been introduced in multipath-tools 0.14.0:

> truncate -s1G /tmp/img
> kpartx -a /tmp/img
double free or corruption (out)
Aborted                    (core dumped) kpartx -a /tmp/img

Fix it by always allocating "uuid" on the heap, rather than
using a static char array.

Fixes: 8c39e60 ("kpartx: fix some memory leaks")
Fixes: https://github.com/opensvc/multipath-tools/issues/139
---

Note: This issue also affects the pending github PRs for the
stable branches 0.13.y, 0.12.y, 0.11.y, and 0.10.y.

A fix will be pushed to these PRs ASAP.

---
 kpartx/devmapper.c | 16 ++++++++--------
 kpartx/kpartx.c    |  5 ++++-
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index d49c680..45dac58 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -699,14 +700,13 @@ out:
 
 char *nondm_create_uuid(dev_t devt)
 {
-#define NONDM_UUID_BUFLEN (34 + sizeof(NONDM_UUID_PREFIX) + \
-			   sizeof(NONDM_UUID_SUFFIX))
-	static char uuid_buf[NONDM_UUID_BUFLEN];
-	snprintf(uuid_buf, sizeof(uuid_buf), "%s_%u:%u_%s",
-		 NONDM_UUID_PREFIX, major(devt), minor(devt),
-		 NONDM_UUID_SUFFIX);
-	uuid_buf[NONDM_UUID_BUFLEN-1] = '\0';
-	return uuid_buf;
+	char *uuid;
+
+	if (asprintf(&uuid, "%s_%u:%u_%s", NONDM_UUID_PREFIX, major(devt),
+		     minor(devt), NONDM_UUID_SUFFIX) >= 0)
+		return uuid;
+	else
+		return NULL;
 }
 
 int nondm_parse_uuid(const char *uuid, unsigned int *major, unsigned int *minor)
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 9bdd204..cfd8212 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -334,8 +334,11 @@ main(int argc, char **argv){
 	 * This allows deletion of partitions created with older kpartx
 	 * versions which didn't use the fake UUID during creation.
 	 */
-	if (!uuid && !(what == DELETE && force_devmap))
+	if (!uuid && !(what == DELETE && force_devmap)) {
 		uuid = nondm_create_uuid(buf.st_rdev);
+		if (!uuid)
+			exit(1);
+	}
 
 	if (delim == NULL) {
 		delim = xmalloc(DELIM_SIZE);
-- 
2.52.0

