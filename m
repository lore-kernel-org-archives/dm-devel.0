Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB57A45C18
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595360; cv=none; b=pNTZmVOO/HDuPs4Unm5K32myZZ0s48wbLMZ60EFU8D7lgc5PPIMAeGOTbD8yAtrrAMepKz/qzqdE/31j449OPRSukdQygDckbLOftBloqe6vzeIv/+C1lCEmvAy0CtmaisCuk6FlGJp8/X5XZAVwfE4/BvZaBoOskQqxG18wdtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595360; c=relaxed/simple;
	bh=yAG0qv2d+Qh5uxg2NvNXw/tDnsPDLMNVVvf1KmsFESU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV3piuuyF8rJrSdt7Ev4GSNRYbpSE3wG6SGtYjmmzAct4aGdqB0P8+VYggXnNmZVdgTn6ys6Hi3zjiId4KMTt8mdocN8LSGRhGj54jSjCx71rkdTp2PavhViLXvaVBqxLcvxFV5LwtqeUB2I/K/bEsBstCT4cdAADOHA4xDq+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ea58ZNnl; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ea58ZNnl"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38221c82827so182301f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 06:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731595357; x=1732200157; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mm0Xwgp4FKHGchaHdgV2QumoU9iC5QKjm4n5CZvhvfo=;
        b=ea58ZNnljZ7Bpsd9OxIKDghpeQMY832KboHvZNUOGDjvxYr2nxQs89WvfsTa3OvBZM
         d4h5+KmjMHC5jKUhfZB/jFBrG0eTeiiR1sqsvTd2v3CfKTa7JNBkCJQfyG1XRikoL58d
         h0I9w3Ewbxv4PkqI6wabIiyyAlJwIhPfsWdWT7m4C7YVSCcetbPoNdIHVupH7QQGaP7K
         gRpMBX1HorbJ4EiOJaaWmyrR0WSmGRfhkvqezRksPL+LV5h0FeVgSkZ6w9fl1ouVAave
         88ay4gR9V3h+AWgs9gr72BTtyqAplcr8GfSexcSBl38yzIDNOcXrrphVtRQnpCTwwj6v
         C5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731595357; x=1732200157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mm0Xwgp4FKHGchaHdgV2QumoU9iC5QKjm4n5CZvhvfo=;
        b=fr5U+VwUpjfiiku6rEA7ZNQGN/2mYhUw17l+d5SIWzR5z2Lk0cNojYNta/MYqg+woC
         dNqCXNaJIFK69sdJNvXqm9itnzW2gmCPErYLzxfYm3v2Wbm5s3ACfafssdWOzbyPECwC
         7TjLqhEHy7Z+WdD28scWUvDx+qz3JPLZVaY5RmSrPtO+SGsXnWhLQwsp6S32ffkq2CXE
         J8QBmAVlYM+JuksXSOdy5hAxIPQKZsRe+WK7Ro123yvxawdRjdbYap5oO/4kArKaoyv5
         uYBaOoahHzkGWJz+2yCQwE/zSgz7VvHppHiRT5nlZZvJmtL8kTV+HBrrBnETFYLubzAs
         uyqA==
X-Forwarded-Encrypted: i=1; AJvYcCV+kCvGid4kKB9gzZ3iNzgDzIKTyFJ/NUoOsqlh3WQhHuqyPxRMU5eLgoyD2aVLFB8JvkRKMKGtag==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3G25kJkrEoIny2PUBCJQDp0YDQjD6sZjGGud7pYWC0ltpAtGG
	yeFSpxAtik+unZJCKAeFOI84hMsMpe5Fni7kDfObh0VnRAKVWcLV43ALvv2nl9A=
X-Google-Smtp-Source: AGHT+IE/YS2IhCCpzmSlY0AVqYuDQz70z6yFBA9/Ts3pEY7oXOclbiV4x/+LUBmSvAiUx3cAQ5PmRQ==
X-Received: by 2002:a5d:6481:0:b0:37d:525d:5a60 with SMTP id ffacd0b85a97d-381f18672e4mr17343674f8f.8.1731595356856;
        Thu, 14 Nov 2024 06:42:36 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3821ada408dsm1634385f8f.10.2024.11.14.06.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 06:42:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/3] libmultipath: honor WATCHDOG_PID setting
Date: Thu, 14 Nov 2024 15:42:23 +0100
Message-ID: <20241114144224.248606-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114144224.248606-1-mwilck@suse.com>
References: <20241114144224.248606-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WATCHDOG_USEC should only be evaluated if WATCHDOG_PID is either
unset (systemd <= 208) or set to the main daemon's pid [1].

Passing the daemon's PID to set_max_checkint_from_watchdog() requires
a mechanism similar to what we've been using for get_multipath_config().

[1] https://www.freedesktop.org/software/systemd/man/latest/sd_watchdog_enabled.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c             | 11 ++++++++++-
 libmultipath/config.h             |  2 ++
 libmultipath/libmultipath.version |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 226ddec..bd199fa 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -858,12 +858,21 @@ process_config_dir(struct config *conf, char *dir)
 	pthread_cleanup_pop(1);
 }
 
+__attribute__((weak)) pid_t daemon_pid = -1;
+
 #ifdef USE_SYSTEMD
 static void set_max_checkint_from_watchdog(struct config *conf)
 {
-	char *envp = getenv("WATCHDOG_USEC");
+	const char *envp;
 	unsigned long checkint;
+	long pid;
 
+	envp = getenv("WATCHDOG_PID");
+	/* See sd_watchdog_enabled(3) */
+	if (envp && sscanf(envp, "%lu", &pid) == 1 && pid != daemon_pid)
+		return;
+
+	envp = getenv("WATCHDOG_USEC");
 	if (envp && sscanf(envp, "%lu", &checkint) == 1) {
 		if (checkint == 0)
 			/* watchdog disabled */
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 94cdf25..d12f63e 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -315,4 +315,6 @@ int parse_uid_attrs(char *uid_attrs, struct config *conf);
 const char *get_uid_attribute_by_attrs(const struct config *conf,
 				       const char *path_dev);
 
+/* Weak dummy function, meant to be overridden by multipathd */
+extern pid_t daemon_pid;
 #endif
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 6bdf694..a898f7a 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -70,6 +70,7 @@ global:
 	cleanup_multipath_and_paths;
 	coalesce_paths;
 	count_active_paths;
+	daemon_pid;
 	delete_all_foreign;
 	delete_foreign;
 	dm_cancel_deferred_remove;
-- 
2.47.0

