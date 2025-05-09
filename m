Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EAE290DBC
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746795291; cv=none; b=Ssr28A3zBCc9X9dqqAQnbm+LzUn1gVgYLFxl908/5EW0hJNMnmWoH6Pvt4BIb2jA9fwLZDLp6CA7F/DDN66K1YdUNnUxWBUNY+ry0A0AS3vNOAfkMNO2uVIpBy9Nl5Gi6+vQmEaHYSS2KoHA4HYdcS3dRMqJDMVagkpHIMPsJaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746795291; c=relaxed/simple;
	bh=EIDwlwB8BbirWkoEOwDlT4hsu1AszD6FgafhNlbiJKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IccR1aUP8Stkec1AnIo0fsZoWJpnRjMn1xFiaU1Ugs4ilcxs7h5vP2TD+9+uQ1FzfKhdu43qghW6j7el9ujx3CA0vY9yRKrqrQXwTXoYeHvtb+rl8nhYQXZRyJuXu0w/ceoKcGq12SI8+8vi/Zq2BtTGE/vVjFa/bBfSZYzs4P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MgIVWoJB; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MgIVWoJB"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43f106a3591so875915e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 May 2025 05:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746795288; x=1747400088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/tGjj8ZeGr1Cv51iwhjbLC9HmiHRePv4yo+G6hIn2T4=;
        b=MgIVWoJBf86f3brrdgpe5LTsSY8VbTLtluIv1p/IjMUke+aZXHgpQXJX+GUqMfEf/J
         ghXMI01v2LcP81ig1WOTLJYe8/Wh8WaDqHSv1tmWPUIwQnjDS8hn3jV2xS2mDV5a4y+X
         YgarrnpcXo9Ads7g3j5TTq0TvNi+x39Vf+X8ZnkKt8ALJDp7yB8mHlIi+5dQ8uoBIo8G
         59PKn0GMg1kwmZj7DYltQKrfDpLh3TMkuzE8m6fIl8iWVS90LgiGFYWDifVcStc1vOkp
         gPB5ML+zdolifzr1G2nIBX0tND5yqBsutqvuWJ4+iEGLKx0mZ+D0pkeiDH/ZWYuvPMec
         FoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746795288; x=1747400088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tGjj8ZeGr1Cv51iwhjbLC9HmiHRePv4yo+G6hIn2T4=;
        b=PL3GbWqTbXQX07e273xJIqtdxZaJABSStrkiv3ftom8xlBUyL97gJm5ga4LEfn8ALd
         1y/pZyXfIkCCdKh7QDbGpOQOhfdXBdtY8MqMMYIW+V6zV+dItzwmqtFAzNAWJgi6yAS4
         /sQYsf/1fZLbVsAIiKz9y2yW6l5jolahNkhByA2yvyjUCWTawuNXLCYE8xKELIpykcfu
         W6hbhNtP7CBHEMVDuIgUL9oXdG54c2V+Tz26ql2nP+DrAmgetLtaqpdu/WZ95RAyfdAM
         OKSptg8VVT22z84ld1CcPLK33ZlXRvcqw1rePIWr6UWEiVIqRTJv/i/Jrrv7wUsgonbT
         BEUw==
X-Forwarded-Encrypted: i=1; AJvYcCUDbsJfhRyhmmXmMl+WfaO7KOqGTbz9j76Mu2hjFZLVKNIxXGOOZUOpAcOO/Tv9nqc8FEnINCeQGg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzfvJGcw8j29B/bNkuZXC7dhswTlHg/JLGhQX530UU3OyfnFJ8/
	fJWYAq8ZPUeRagHugK4KwDNgU0aRwKIvXnZBoyodFQm4OsJu1e8=
X-Gm-Gg: ASbGncs8Un0mTnQ7bEu+9qI6sruBf0TSkVDz32eD5BCEi4lHbq+Jwt8TzOjXz3VQFfj
	95Br0rlPuhCi0VL0FpDL5lbn6gRmg9Wzul/Kmor5ZQOxlcnV1I+bLTNVhIQRDYdjnO+dWcz6qx0
	4FcMl36U0DL/mTI5Qg/V/AmYYAo7E07VS9W0GxSvYDl8GOVsF6RB9naZUrVcLdPrT2MKIjtGdpu
	FttGibJdXR2uh3cOGKPtZb9LyC9NnTR5c3XFMPMfqhqUhmtyuUUCyl2GM6EV5sDLA4TjYHq0NVr
	pxCANWHPHlzUHl+Cvu+Ns3XJQaiOc7/N5j8NxZtYWuRiAnafhYjP2fV3slYkLe6xNofHqIw/7cj
	n7dm7Xvek
X-Google-Smtp-Source: AGHT+IHLsC+7MwFKdAvQxT7RvV1j6LftNsR6KpQ1ZM7MGyIa5Jyx8ABiEbyxhfsQVjppc+lcXDiJQw==
X-Received: by 2002:a05:600c:a016:b0:441:c1ae:3340 with SMTP id 5b1f17b1804b1-442d6d12042mr10932195e9.1.1746795287430;
        Fri, 09 May 2025 05:54:47 -0700 (PDT)
Received: from localhost (236.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.236])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67ebee9sm28594335e9.17.2025.05.09.05.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 05:54:46 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: fix misspellings
Date: Fri,  9 May 2025 14:54:44 +0200
Message-ID: <20250509125444.222611-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

codespell:
./tests/mapinfo.c:964: ouput ==> output
./libmultipath/devmapper.h:118: paramters ==> parameters
./libmpathutil/uxsock.c:69: everone ==> everyone

===============
SUMMARY:
everone       1
ouput         1
paramters     1

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathutil/uxsock.c    | 2 +-
 libmultipath/devmapper.h | 2 +-
 tests/mapinfo.c          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 59c47170..02b387d0 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -66,7 +66,7 @@ int ux_socket_listen(const char *name)
 	}
 
 	/*
-	 * Socket needs to have rw permissions for everone.
+	 * Socket needs to have rw permissions for everyone.
 	 * SO_PEERCRED makes sure that only root can modify things.
 	 */
 	if (name[0] != '@' &&
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 4aeefad1..c0f7aa0d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -115,7 +115,7 @@ typedef struct libmp_map_info {
  *
  * This function obtains the requested information for the device-mapper map
  * identified by the input parameters.
- * If non-NULL, the name, uuid, and dmi output paramters may be filled in for
+ * If non-NULL, the name, uuid, and dmi output parameters may be filled in for
  * any return value besides DMP_NOT_FOUND and will always be filled in for
  * return values other than DMP_NOT_FOUND and DMP_ERR.
  * The other parameters are only filled in if the return value is DMP_OK.
diff --git a/tests/mapinfo.c b/tests/mapinfo.c
index 36511607..399e16e7 100644
--- a/tests/mapinfo.c
+++ b/tests/mapinfo.c
@@ -961,7 +961,7 @@ static void test_mapinfo_bad_target_type_03(void **state)
 			   (mapid_t) { .str = "foo", },
 			   (mapinfo_t) { .dmi = &dmi, .name = name, .uuid = uuid });
 	assert_int_equal(rc, DMP_NO_MATCH);
-	/* make sure that the ouput was filled in */
+	/* make sure that the output was filled in */
 	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
 	assert_true(!strcmp(name, MPATH_NAME_01));
 	assert_true(!strcmp(uuid, MPATH_UUID_01));
-- 
2.49.0

