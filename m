Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A83819006B
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130818; cv=none; b=Ecmq89ijkL5d8yHViieYGoiAoWFV7GQuMYh6UTTfDzfmvGTHL96sft2UToKsxksEbTIVrw0ODAmx8PjWEe/xM+co4ejR66+OcL4DRWLJqVFjmYAAHMIxRF67IvbC6dwnQEEIX6eBJbZWxH/0eRHqzdwlgMrsgdU3Hl6VmgheX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130818; c=relaxed/simple;
	bh=bBhls0mvluKoZDyonXKAW4S1PGMMr60Dtn0KVNr2lVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1EMNBJ1dSN45jdN7fzhBQxUdlddRJkQPL2aBmimaYA3VHhLbncFHgEOWGBRRoX6IY0Uj9mRdcdgJmcxuV7/Jmte2aZb7kFaO11AOn1yOqPDLBaYLf2XH3Pij8i6J8cEWc9xYRmqK4AlKp7Eg2Cw7lEZSQaxac/0HBbIOuYa8aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KBvdbI0o; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KBvdbI0o"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso1476568e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130814; x=1723735614; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMZG/B6zmS3uRMbqJnlnzqT9SeJsRdUOFJ5jlqzbgyY=;
        b=KBvdbI0oa57IiYmglw3N0gRabbxKQsCS1Jsunpo014c9ebbgUQy+LgmFTPGDFVu08K
         3FUOrydMIN6opjUTqEtblfstzmJK0ZcvHldQK75y/3tXgTi5WC6O8rQAFZmq+ecVpLlk
         TdHEc16ZYYywveu+hJnvPuxNi2GLMU+x6sC9recG1RvZcB6FvuH4IrVvulnqOck2IaSY
         KnrOfPQPdwAgCWt+CXNk0273nwQReKsvKX0m+/seei3OuF3wEwkJQSwN10zRSTSvNYsj
         fQinLLjCxwM370Pm+SFi0R1SWKD2w8N73X9yYMiqWVINAz0t8qErV4liErLaFdSr8jju
         StJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130814; x=1723735614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EMZG/B6zmS3uRMbqJnlnzqT9SeJsRdUOFJ5jlqzbgyY=;
        b=qd+Mh8w1D0M8Uj7+s8xoL7hkXACn3z22meYbi85W5ct7II/XE29oYcGI0Lu0nJ3Flv
         VJx54ia2R0BXdjCjM6tuh1W15YqfMbCIEDrsiYKcyuSVdcZCHK+VVj9twblsPfvFHNKG
         d1RMxdycrLnULOChAqjig2SuG2woJlPwz8XtJ+k9aHyD6Gh+y5chqswjhdIbuunEY8uP
         i0krgbmZiFXBqE/7Qtb2fxLFe21quxS4lVObek3TTGWpGA1jzJ1a+Obx86PYL7KwVFEx
         7+zYDkx5wUoJeVV5qTlm0LNcVRjSpsndL8MU93XqHhfP6Map6cLQxlbYT85j7+nBkyPr
         /YgQ==
X-Gm-Message-State: AOJu0Yz/DLSJW7UFBpRGGszBg82g+XCev8b3QHEsdiG7DTROFA7hnLLG
	rGa6U3jHDKdR5BSitFT3xYJIeZtvLqvHZ/LtGyVkfUNdTWf4FKtxW/s5//Aoezo=
X-Google-Smtp-Source: AGHT+IE4c6vISgnQ6X0vx0ISFrUyPTmP4aivYlms+dSKX1S0nvxs2ffjw0/JxqBR6nuMS3x/On5Xzw==
X-Received: by 2002:a05:6512:3d29:b0:52e:987f:cfc6 with SMTP id 2adb3069b0e04-530e589a324mr1789554e87.51.1723130814137;
        Thu, 08 Aug 2024 08:26:54 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0cb83sm750372766b.49.2024.08.08.08.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:53 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 20/41] libmultipath: rename __sysfs_attr_get_value()
Date: Thu,  8 Aug 2024 17:25:59 +0200
Message-ID: <20240808152620.93965-21-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c |  6 +++---
 tests/sysfs.c        | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index afe9de9..b2c1ce0 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -45,7 +45,7 @@
  * as libudev lacks the capability to update an attribute value.
  * So for modified attributes we need to implement our own function.
  */
-static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
+static ssize_t sysfs_attr_get_value__(struct udev_device *dev, const char *attr_name,
 				      char *value, size_t value_len, bool binary)
 {
 	const char *syspath;
@@ -100,13 +100,13 @@ static ssize_t __sysfs_attr_get_value(struct udev_device *dev, const char *attr_
 ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 			     char *value, size_t value_len)
 {
-	return __sysfs_attr_get_value(dev, attr_name, value, value_len, false);
+	return sysfs_attr_get_value__(dev, attr_name, value, value_len, false);
 }
 
 ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 				 unsigned char *value, size_t value_len)
 {
-	return __sysfs_attr_get_value(dev, attr_name, (char *)value,
+	return sysfs_attr_get_value__(dev, attr_name, (char *)value,
 				      value_len, true);
 }
 
diff --git a/tests/sysfs.c b/tests/sysfs.c
index c623d1b..6dfa9f3 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -90,7 +90,7 @@ static int teardown(void **state)
 
 static void expect_sagv_invalid(void)
 {
-	expect_condlog(1, "__sysfs_attr_get_value: invalid parameters");
+	expect_condlog(1, "sysfs_attr_get_value__: invalid parameters");
 }
 
 static void test_sagv_invalid(void **state)
@@ -132,12 +132,12 @@ static void test_sagv_invalid(void **state)
 static void test_sagv_bad_udev(void **state)
 {
 	will_return(__wrap_udev_device_get_syspath, NULL);
-	expect_condlog(3, "__sysfs_attr_get_value: invalid udevice");
+	expect_condlog(3, "sysfs_attr_get_value__: invalid udevice");
 	assert_int_equal(sysfs_attr_get_value((void *)state, (void *)state,
 					      (void *)state, 1), -EINVAL);
 
 	will_return(__wrap_udev_device_get_syspath, NULL);
-	expect_condlog(3, "__sysfs_attr_get_value: invalid udevice");
+	expect_condlog(3, "sysfs_attr_get_value__: invalid udevice");
 	assert_int_equal(sysfs_bin_attr_get_value((void *)state, (void *)state,
 						  (void *)state, 1), -EINVAL);
 }
@@ -151,11 +151,11 @@ static void test_sagv_bad_snprintf(void **state)
 	longstr[sizeof(longstr) - 1] = '\0';
 
 	will_return(__wrap_udev_device_get_syspath, "/foo");
-	expect_condlog(3, "__sysfs_attr_get_value: devpath overflow");
+	expect_condlog(3, "sysfs_attr_get_value__: devpath overflow");
 	assert_int_equal(sysfs_attr_get_value((void *)state, longstr,
 					      buf, sizeof(buf)), -EOVERFLOW);
 	will_return(__wrap_udev_device_get_syspath, "/foo");
-	expect_condlog(3, "__sysfs_attr_get_value: devpath overflow");
+	expect_condlog(3, "sysfs_attr_get_value__: devpath overflow");
 	assert_int_equal(sysfs_bin_attr_get_value((void *)state, longstr,
 						  (unsigned char *)buf, sizeof(buf)),
 			 -EOVERFLOW);
@@ -171,7 +171,7 @@ static void test_sagv_open_fail(void **state)
 	expect_value(WRAP_OPEN, flags, O_RDONLY);
 	errno = ENOENT;
 	wrap_will_return(WRAP_OPEN, -1);
-	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' cannot be opened");
+	expect_condlog(3, "sysfs_attr_get_value__: attribute '/foo/bar' cannot be opened");
 	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
 					      buf, sizeof(buf)), -ENOENT);
 }
@@ -190,7 +190,7 @@ static void test_sagv_read_fail(void **state)
 	errno = EISDIR;
 	will_return(__wrap_read, -1);
 	will_return(__wrap_read, NULL);
-	expect_condlog(3, "__sysfs_attr_get_value: read from /foo/bar failed:");
+	expect_condlog(3, "sysfs_attr_get_value__: read from /foo/bar failed:");
 	will_return(__wrap_close, 0);
 	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
 					      buf, sizeof(buf)), -EISDIR);
@@ -205,7 +205,7 @@ static void test_sagv_read_fail(void **state)
 	errno = EPERM;
 	will_return(__wrap_read, -1);
 	will_return(__wrap_read, NULL);
-	expect_condlog(3, "__sysfs_attr_get_value: read from /foo/baz failed:");
+	expect_condlog(3, "sysfs_attr_get_value__: read from /foo/baz failed:");
 	will_return(__wrap_close, 0);
 	assert_int_equal(sysfs_bin_attr_get_value((void *)state, "baz",
 						  (unsigned char *)buf, sizeof(buf)),
@@ -235,7 +235,7 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
 	if (bufsz <= sizeof(input) - 1) {
 		n = bufsz;
 		trunc = 1;
-		expect_condlog(3, "__sysfs_attr_get_value: overflow reading from /foo/bar");
+		expect_condlog(3, "sysfs_attr_get_value__: overflow reading from /foo/bar");
 	} else {
 		n = sizeof(input) - 1;
 		trunc = 0;
@@ -311,7 +311,7 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
 
 	if (bufsz <= sizeof(input) - 1) {
 		n = bufsz;
-		expect_condlog(3, "__sysfs_attr_get_value: overflow reading from /foo/bar");
+		expect_condlog(3, "sysfs_attr_get_value__: overflow reading from /foo/bar");
 	} else
 		n = 0;
 
-- 
2.46.0

