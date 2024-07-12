Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39CE176ABE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804536; cv=none; b=tjJSrXSRWkpD0G/kCbwoo5vhr7Bag3MaewWgzcd87+NUB4U3UF3s/Hd1/234yR2YtmBMgXld9JAsxwG6tq2LmGbytcI+o7pVA+Ey4A1ItixBPrX7MlPXoZ0clQxGpvQ7A6Y2iMc0yBs3Y2hYOWVsNN4BOwcTpFaqlZgrrBuiXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804536; c=relaxed/simple;
	bh=OKCYTNZZaDC20n0Cy3CqNlORaDH191ES0Cxf1QL6zy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOYp92+UwGyw9BjMBccKzUgWuszxs8QFRhVI1Tn5TYDOVuqwjpTvgpE3T3f/1oWBXqEEnse8Can5QEFEdUZjJXN7MFg/eWMD7eN0tu8kJso3BlTzHtmVuE6PeXdkUROoJ08dHhrs1soPOzchr5fcToHy+9H6MzJX+yKOSF5rhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P+jvRLUS; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P+jvRLUS"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a77d9217e6fso306964666b.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804532; x=1721409332; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqusqh2vhyGec+snCsCxQ3oDSIUwcEZnW2tcGL8ffEY=;
        b=P+jvRLUSn1k3CCWeYWg8WHWc8tbgx0ov0Abf8E3IZ4H+gx5VcdC1fuHMCPquGleuUN
         9/w6J3E1RnN6OcWFCcA0j83GGuQc3lt7R/2YKxXuX/i+jYe2ZimizswVhPyQM2BYR74o
         tW4e6j31hSZYOGD4U/tCejYkewVLC71pKvXcTaNvLuxllEpa0G/8e7ICC7NS7Nu3feVL
         rJ6l2MTeWZ+TJNYXQYKh+sH6t0kxNfmacmhimhv3LcbxaM0m2o+WLEbMEVyEm8vCuZUk
         kMXrw2VqDj8e239B+jQ9s9jKEkJTUbfG5WT8Ervi7PKBTbrgYR00chnF1AnnELXYukaQ
         Oc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804532; x=1721409332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqusqh2vhyGec+snCsCxQ3oDSIUwcEZnW2tcGL8ffEY=;
        b=HroKlGDt1sai45w2rlb44KZbCQGH0xd6Jq+INN3MUoRjMjy/QLhWWErnfpIjLEn1uS
         /E8Kr5Chmw2S6CgSagYNo3aWoqAa7NuAQy8HU6QQ8a6I5E8nOXgg93ko0EaIwEsV82mB
         jU2j4Q0sc5D5EC2My7KyAaj4XPSk1vF1xXBCgV7XiJyHRCf7ukUNbmfLvB5/4WeW/deo
         IL0vRS1anguHJFzGohlfJogoe7yD6zIMRoTmkCbT584/J7Ir0JjMKR/qJrLTwxVfj6jP
         7IHQoeJHCCeG0O+3zbByIKBUiYB+79MDgFcauR0UHnaeS+rVtRJGp7+7AZ7/hCpYxXYq
         Kd9A==
X-Gm-Message-State: AOJu0Yy2Uq27ERLufV+pJukWDb3LoEcm62nnnA+DxBTh2nPurtZhjc1L
	T6EPRZ89LsHqwijJ2s0O+wWCwzTFa+rotaPqnKxrwZj7cXZe40a/0jElKCizIxU=
X-Google-Smtp-Source: AGHT+IF0VCCjIWYLU+mCLQJFWjdrvZmf7Xmf2zTHnKXruwDhOabYEjKllYRljPtcWLqdAk6svvZIXg==
X-Received: by 2002:a17:907:7284:b0:a77:d1ea:ab36 with SMTP id a640c23a62f3a-a780b68a2d7mr1010095466b.6.1720804530683;
        Fri, 12 Jul 2024 10:15:30 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff282sm363091066b.130.2024.07.12.10.15.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:30 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/49] multipath-tools CI: fix dmevents test for Debian Sid, arm/v7
Date: Fri, 12 Jul 2024 19:14:10 +0200
Message-ID: <20240712171458.77611-3-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same fix as in 6a7524a ("multipath-tools tests: fix CI failures on arm/v7 with
glibc 2.37").

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/dmevents.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tests/dmevents.c b/tests/dmevents.c
index 395b16d..668e6d2 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -253,8 +253,9 @@ int __wrap_dm_geteventnr(const char *name)
 	return -1;
 }
 
-int __wrap_ioctl(int fd, unsigned long request, void *argp)
+int WRAP_IOCTL(int fd, unsigned long request, void *argp)
 {
+	condlog(1, "%s %ld", __func__, request);
 	assert_int_equal(fd, waiter->fd);
 	assert_int_equal(request, DM_DEV_ARM_POLL);
 	return mock_type(int);
@@ -675,7 +676,7 @@ static void test_dmevent_loop_bad1(void **state)
 		skip();
 
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, -1);
+	wrap_will_return(WRAP_IOCTL, -1);
 	assert_int_equal(dmevent_loop(), 1);
 	dev_evt = find_dmevents("foo");
 	assert_ptr_not_equal(dev_evt, NULL);
@@ -697,7 +698,7 @@ static void test_dmevent_loop_bad2(void **state)
 		skip();
 
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	will_return(__wrap_libmp_dm_task_create, NULL);
 	assert_int_equal(dmevent_loop(), 1);
 	dev_evt = find_dmevents("foo");
@@ -721,9 +722,8 @@ static void test_dmevent_loop_good0(void **state)
 	remove_all_dm_device_events();
 	unwatch_all_dmevents();
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	assert_int_equal(dmevent_loop(), 1);
@@ -757,9 +757,8 @@ static void test_dmevent_loop_good1(void **state)
 	assert_int_equal(add_dm_device_event("foo", 1, 6), 0);
 	assert_int_equal(remove_dm_device_event("xyzzy"), 0);
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	expect_string(__wrap_update_multipath, mapname, "foo");
@@ -805,9 +804,8 @@ static void test_dmevent_loop_good2(void **state)
 	assert_int_equal(watch_dmevents("baz"), 0);
 	assert_int_equal(add_dm_device_event("baz", 1, 14), 0);
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	expect_string(__wrap_update_multipath, mapname, "bar");
@@ -849,9 +847,8 @@ static void test_dmevent_loop_good3(void **state)
 	assert_int_equal(remove_dm_device_event("foo"), 0);
 	unwatch_dmevents("bar");
 	will_return(__wrap_poll, 1);
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	will_return(__wrap_libmp_dm_task_create, &data);
-	will_return(__wrap_dm_task_no_open_count, 1);
 	will_return(__wrap_dm_task_run, 1);
 	will_return(__wrap_dm_task_get_names, 1);
 	expect_string(__wrap_remove_map_by_alias, alias, "foo");
@@ -874,7 +871,7 @@ static void test_arm_poll(void **state)
 	struct test_data *datap = (struct test_data *)(*state);
 	if (datap == NULL)
 		skip();
-	will_return(__wrap_ioctl, 0);
+	wrap_will_return(WRAP_IOCTL, 0);
 	assert_int_equal(arm_dm_event_poll(waiter->fd), 0);
 }
 
-- 
2.45.2

