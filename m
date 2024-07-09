Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03CC182A62
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561192; cv=none; b=sMZ0QxQr/dqqYXsCQc8XuTkIY7MLwoizsXsY/BHQ4aXJH5hXSgu2jMtqM+OZvfOVwQg0Xkw2sjMRRkhObFn0acNqRId2/giDt+PyBYYVIGztssJcDQuDJ330toMDbkjwv7VeFU7YF4G3oRamWmg2cBWUnSIm8is8yilz5qc8py4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561192; c=relaxed/simple;
	bh=98RJUg6RALMHNnjaH+Wwaq/CmysC7G/SUnRyzMFF/QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKspb7LQuK1hNVjGz4ir8t5xzcEo/f0SrignXYCuv179Te73bhxRwKl9KzonetzvOZ/pnnKSKYaxr+IfzNk96iCyzH+MCrQKO0Dw/EDaVdvS+hXIE5Pk0JhP9I3afPppZx1UQ157KV/OBSPyYdve88aJ9ksOw6sT31bciazhOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OcVO7UmD; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OcVO7UmD"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-58bac81f3f9so7432847a12.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561188; x=1721165988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0aDf0zHLMivaEgNNhVaRC5STQ/gEL1xdQciCK9cWy1c=;
        b=OcVO7UmDOMZUy7nP/DNWaPtH0bdjB2OE1SAJMe6gbm2t05JLCraj7FnroreQND/qNp
         uqHbkZknSDcv2cE6LXSPm7Idfo4XVVJc7NkLo/NMj3zu/jK8+mqf7MD/y6GDMdvn9N1x
         Hl06DIuJz3XBjP5Ljwwm22yKFvF84y5ctPHgIjRgqyKO8GHiDdlX+myW+2lzhAuygBvQ
         b5g6e5SSqbmSDegLGHkS+wRbq/nvW7CzGKKhUXfcj+V6k4au84Xko14nUSwsE9ddh1qX
         d1FVBcnXoXqaJWx22AdaUyHNRPkVv+utIP1Y23KDDCgk7q8pgX3QHgbfCDm+eMQTpsXP
         jeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561188; x=1721165988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0aDf0zHLMivaEgNNhVaRC5STQ/gEL1xdQciCK9cWy1c=;
        b=RIdt62inRhqXCTGbWGakwA6ui3qN/GdEliBd9w7rHulYbwQ1Mfe8Z7+aUg8jqKWoMr
         7+9djbBLXwsYdcH8GsD9OaGwKf8SmCZpLOzjASad341Te+p2IoozgVhOCXsHU0Sv8WLd
         r9SFVJA3AVlWbpZpLF80CmZNtG9xGYI0lvlyXQfGC2P6sGGAK4gPEjl2GkgzEQDBsb/t
         6CsgBIjAATZHW3aHjsknUn2da7EdCry6dsglWZ4wZRWQuXPGDh3pFrMpc18SjHs3fKOn
         RY8gIiKlYK5ZBKPK/uWntYOI0quUDYaUK97PR5f50EOz7mrJc3MOFlXhsW9ZqefjzY3L
         Uzng==
X-Gm-Message-State: AOJu0Ywf7yEeEZtLHdHjlFRti9KC8PmhbutcyRiuRWUBLPz2rfXmMpd1
	iihEUMrG9YsZQpEk+9QD1SWQg7DT+7F+Le4PU5+se5l1DTVT6zDPs0qmLxjyZ4k=
X-Google-Smtp-Source: AGHT+IFXC4wYHzT8OKzpO6g4X6QIuY8+FkzYzLKdt3un9BcHy5TpvFpHKzpX4q/8NTWi8jvO2XK6Sw==
X-Received: by 2002:a05:6402:28a5:b0:58c:804a:6f0a with SMTP id 4fb4d7f45d1cf-594ba59f87emr2031408a12.19.1720561187716;
        Tue, 09 Jul 2024 14:39:47 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594b8d6cdffsm1497067a12.0.2024.07.09.14.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:47 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 02/44] multipath-tools CI: fix dmevents test for Debian Sid, arm/v7
Date: Tue,  9 Jul 2024 23:38:53 +0200
Message-ID: <20240709213935.177028-3-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
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

