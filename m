Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DBE21C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155306; cv=none; b=q6rvpnTDT2SRsXSghBlM3QfB8TZKkUR8fStL4LQPD10AoLepboIYUW2/FLyuQ60OqcFH6uBL3cJMtWIyWpFDWJl2NJ/cA7bk7r/wFnfxJ48YzZXObfzxqQoaW1BOTj7zMKwvpsRzz5+E8dcu3OmpxokbZI6+MX7khErQr1Yymew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155306; c=relaxed/simple;
	bh=tgwEx2nTLvgjItY6ASGZP7s5Cxm3Hw/LugwJ2go124o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh9L4CtAQwluMzmeM1ErD6PhFIVBv9h89AWqcUJUYa5eVeKxnFIAxYLnoWgTPKnqVjb4AsXVrXCQgEtArl+NLGoUK+Xt/00KtosDnFn9q+w8BLYP4adJLRLTtkHKUPlXGzh9an9BUWWgEoBEePIeBWcqlY0JwBTr/b33dJ0tx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E9oZEsnE; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E9oZEsnE"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-649e28dccadso2730525a12.3
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155302; x=1766760102; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3z/bwD55I0fqNpTZO0HvQVssdTjjr6FXPZsgFY1l3kE=;
        b=E9oZEsnEMrdVPKvgHvR/kSHUNt1k8qjPMs6xpkk4mgP0u+8q6o7PEcQvfLofdiUwdu
         iFOWDplUix8lSnXTzWF1YDjsatYYtIBpT9ScEPUBsxub2sSYp98khkdKVhNaq4B87JIx
         TEWIagTeI6F85npnKQS1IaPkWmLPZgtDCE6pR6AaitL858wdl/zojPbl+Gnd/3jCS5Ot
         iMyra7LZmFEWffIrTC18yagAHPkgbDGwwaUVje+H0mNDnXxSG70BmhH3GI+pXdn0sdDk
         vKsB3CqQNRAw8VEuIxtFOglx5v6KidUYdVUK22jnk2OwLuPeQ4T5U5C/B1daX2Wy7HSO
         5Utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155302; x=1766760102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3z/bwD55I0fqNpTZO0HvQVssdTjjr6FXPZsgFY1l3kE=;
        b=tQ9ZmLhgRcgRyYEgZtYoKoDfRpmXmQ5jh7bHZ+hSz3bDgW3ljuprBp7ip4vpTX1UCH
         i0BlGyzYZvmGBc8h6fzz4kUOfzGDZfENhwzZfSZxv76PjNPRC0aSe6PU0ywnHZ6t2lb8
         wSimZ1nwt7a1LEb1YdFjP4mKEev2PmXSU1g3W2M80Olt6xcraDZ13Oik64jIcrxtyz/k
         97r8ZSAW3j0nKWwEXlfHapDqUB94nRdLUyAIQKHTi1OlB1vMy+B3082baRrjqqOa2F8N
         vzaUGmiFjnVR/9hItmS1+4PyoA5jNbDGrQJt2kHCUr2fUjt4dUx9Le8hNEVOrxV+irDn
         B2sA==
X-Gm-Message-State: AOJu0YwXBOlHdFijcchesjaxn3iSPRc6thFHoCE1bMxOGPFKgQgGufcM
	/C9WoLp1TnWrecYei9ViaZYtN1i7eVh92KBz0b3wNXjYf1/vKQYgHQjmQ0qNOjGdZE0sLgdnv5o
	QPrKU
X-Gm-Gg: AY/fxX4gHFRGRUq3ngNwDYHKu4Ilkv6sIlQ0yjFPPv/t9UJrBx/MFCpI4GvQksRHh+T
	5Fe3kse7jbIs2cDYa44yCEbM8OJX8nv4iFCXEgKuz9pYT3qS/swGB5HaDlQetY06g6P5Aqp7VB4
	bg4mJ+oZVpzUyKLNFVbOgi/Wu7xCMqB4Y20OcWZpCwBO/pF9MF8Xyi71AbtXWIe1BMqahhpaHG4
	npZxyVkJDXTg3p0OHBVjiDsnDFjHjrZlQ5O53G4i+NIdJlIWBhb8J8TF2ROK60x47lXJK1ACsIf
	MtrKYb902Yht1IxasnzmUUD0+nndMktqx4N2DPvDm3VA9+20GrqYMv7LEufuLlPNeZ92Komr0Hy
	JfgMk1KHsl/WfxthEsJDDXJ1L7JHJmt83s9N5Kh7Sq8sa/OXn+6ihodh0sSpzu0LduMwBqFpIPP
	GzhTz269im5GtD/zD03vC6hZ0suW/ciUhkzp7epf0pWib3RApkOs3KPjgJ6fWS/U/cpolbSyeJa
	g==
X-Google-Smtp-Source: AGHT+IF2fxSz/1EKewFM2Q3qLzaxXfgPLjqKKaypt5wx9lrbmA0uc889QRGPzhZGSZG9f2PoriN5Sw==
X-Received: by 2002:a05:6402:4311:b0:64b:7f98:c7e with SMTP id 4fb4d7f45d1cf-64b8e93bb68mr2478868a12.1.1766155301937;
        Fri, 19 Dec 2025 06:41:41 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b916b3b35sm2400391a12.30.2025.12.19.06.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:41 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 23/26] libmpathutil: add wrapper code for libudev
Date: Fri, 19 Dec 2025 15:41:05 +0100
Message-ID: <20251219144108.237928-24-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The libudev documentation [1] states that libudev is not thread-safe and
shouldn't be used from multithreaded programs. While the man page also
states that using libudev in multithreaded programs is unsafe even if
locking is used, there's not much else we can do in multipath-tools to
mitigate the problem, as we are using libudev in multiple threads all over
the place.

Add wrapper code that wraps all calls to libudev in a critical section
holding a specific mutex.

[1] https://man7.org/linux/man-pages/man3/libudev.3.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/libmpathutil.version |  62 +++
 libmpathutil/mt-libudev.c         | 776 ++++++++++++++++++++++++++++++
 libmpathutil/mt-libudev.h         | 120 +++++
 libmpathutil/mt-udev-wrap.h       |  90 ++++
 4 files changed, 1048 insertions(+)
 create mode 100644 libmpathutil/mt-libudev.c
 create mode 100644 libmpathutil/mt-libudev.h
 create mode 100644 libmpathutil/mt-udev-wrap.h

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 14aa083..8fab1a6 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -93,6 +93,68 @@ global:
 	log_thread_stop;
 	logsink;
 	msort;
+
+	mt_udev_ref;
+	mt_udev_unref;
+	mt_udev_new;
+
+	mt_udev_list_entry_get_next;
+	mt_udev_list_entry_get_by_name;
+	mt_udev_list_entry_get_name;
+	mt_udev_list_entry_get_value;
+
+	mt_udev_device_ref;
+	mt_udev_device_unref;
+
+	mt_udev_device_new_from_syspath;
+	mt_udev_device_new_from_devnum;
+	mt_udev_device_new_from_subsystem_sysname;
+	mt_udev_device_new_from_device_id;
+	mt_udev_device_new_from_environment;
+
+	mt_udev_device_get_udev;
+	mt_udev_device_get_parent;
+	mt_udev_device_get_parent_with_subsystem_devtype;
+	mt_udev_device_get_devpath;
+	mt_udev_device_get_subsystem;
+	mt_udev_device_get_devtype;
+	mt_udev_device_get_syspath;
+	mt_udev_device_get_sysname;
+	mt_udev_device_get_devnum;
+	mt_udev_device_get_is_initialized;
+	mt_udev_device_get_property_value;
+	mt_udev_device_get_seqnum;
+	mt_udev_device_set_sysattr_value;
+	mt_udev_device_get_sysattr_value;
+	mt_udev_device_get_driver;
+	mt_udev_device_get_devnode;
+
+	mt_udev_device_get_properties_list_entry;
+
+	mt_udev_monitor_new_from_netlink;
+	mt_udev_monitor_enable_receiving;
+	mt_udev_monitor_get_fd;
+	mt_udev_monitor_receive_device;
+	mt_udev_monitor_filter_add_match_subsystem_devtype;
+	mt_udev_monitor_ref;
+	mt_udev_monitor_unref;
+	mt_udev_monitor_set_receive_buffer_size;
+
+	mt_udev_enumerate_new;
+	mt_udev_enumerate_ref;
+	mt_udev_enumerate_unref;
+	mt_udev_enumerate_add_match_subsystem;
+	mt_udev_enumerate_scan_devices;
+	mt_udev_enumerate_get_list_entry;
+	mt_udev_enumerate_add_nomatch_subsystem;
+	mt_udev_enumerate_add_match_sysattr;
+	mt_udev_enumerate_add_nomatch_sysattr;
+	mt_udev_enumerate_add_match_property;
+	mt_udev_enumerate_add_match_tag;
+	mt_udev_enumerate_add_match_parent;
+	mt_udev_enumerate_add_match_is_initialized;
+	mt_udev_enumerate_add_syspath;
+
 	normalize_timespec;
 	parse_devt;
 	print_strbuf;
diff --git a/libmpathutil/mt-libudev.c b/libmpathutil/mt-libudev.c
new file mode 100644
index 0000000..2e37c7d
--- /dev/null
+++ b/libmpathutil/mt-libudev.c
@@ -0,0 +1,776 @@
+#include "mt-libudev.h"
+#include <stddef.h>
+#include <libudev.h>
+#include "util.h"
+
+static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+struct udev *mt_udev_ref(struct udev *udev)
+{
+	struct udev *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_ref(udev);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev *mt_udev_unref(struct udev *udev)
+{
+	struct udev *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_unref(udev);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev *mt_udev_new(void)
+{
+	struct udev *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_new();
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_list_entry *mt_udev_list_entry_get_next(struct udev_list_entry *list_entry)
+{
+	struct udev_list_entry *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_list_entry_get_next(list_entry);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_list_entry *
+mt_udev_list_entry_get_by_name(struct udev_list_entry *list_entry, const char *name)
+{
+	struct udev_list_entry *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_list_entry_get_by_name(list_entry, name);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_list_entry_get_name(struct udev_list_entry *list_entry)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_list_entry_get_name(list_entry);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_list_entry_get_value(struct udev_list_entry *list_entry)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_list_entry_get_value(list_entry);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *
+mt_udev_device_new_from_syspath(struct udev *udev, const char *syspath)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_new_from_syspath(udev, syspath);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *
+mt_udev_device_new_from_devnum(struct udev *udev, char type, dev_t devnum)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_new_from_devnum(udev, type, devnum);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *
+mt_udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem,
+					  const char *sysname)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_new_from_subsystem_sysname(udev, subsystem, sysname);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_new_from_device_id(struct udev *udev, char *id)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_new_from_device_id(udev, id);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_new_from_environment(struct udev *udev)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_new_from_environment(udev);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_ref(struct udev_device *udev_device)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_ref(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_unref(struct udev_device *udev_device)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_unref(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev *mt_udev_device_get_udev(struct udev_device *udev_device)
+{
+	struct udev *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_udev(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_get_parent(struct udev_device *udev_device)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_parent(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_device_get_parent_with_subsystem_devtype(
+	struct udev_device *udev_device, const char *subsystem, const char *devtype)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_parent_with_subsystem_devtype(udev_device,
+							    subsystem, devtype);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_devpath(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_devpath(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_subsystem(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_subsystem(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_devtype(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_devtype(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_syspath(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_syspath(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_sysname(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_sysname(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+dev_t mt_udev_device_get_devnum(struct udev_device *udev_device)
+{
+	dev_t ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_devnum(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+unsigned long long mt_udev_device_get_seqnum(struct udev_device *udev_device)
+{
+	unsigned long long ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_seqnum(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_driver(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_driver(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_devnode(struct udev_device *udev_device)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_devnode(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_device_get_is_initialized(struct udev_device *udev_device)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_is_initialized(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *
+mt_udev_device_get_property_value(struct udev_device *udev_device, const char *key)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_property_value(udev_device, key);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+const char *mt_udev_device_get_sysattr_value(struct udev_device *udev_device,
+					     const char *sysattr)
+{
+	const char *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_sysattr_value(udev_device, sysattr);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_device_set_sysattr_value(struct udev_device *udev_device,
+				     const char *sysattr, char *value)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_set_sysattr_value(udev_device, sysattr, value);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_list_entry *
+mt_udev_device_get_properties_list_entry(struct udev_device *udev_device)
+{
+	struct udev_list_entry *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_device_get_properties_list_entry(udev_device);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+/*
+ * multipath-tools doesn't use these, and some of them aren't available
+ * in older libudev versions. Keeping the code here in case we will
+ * need it in the future.
+
+struct udev_list_entry *mt_udev_device_get_devlinks_list_entry(struct
+udev_device *udev_device)
+{
+    struct udev_list_entry *ret;
+    pthread_mutex_lock(&libudev_mutex);
+    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+    ret = udev_device_get_devlinks_list_entry(udev_device);
+
+    pthread_cleanup_pop(1);
+    return ret;
+}
+
+struct udev_list_entry *mt_udev_device_get_tags_list_entry(struct udev_device
+*udev_device)
+{
+    struct udev_list_entry *ret;
+    pthread_mutex_lock(&libudev_mutex);
+    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+    ret = udev_device_get_tags_list_entry(udev_device);
+
+    pthread_cleanup_pop(1);
+    return ret;
+}
+
+struct udev_list_entry *mt_udev_device_get_current_tags_list_entry(struct
+udev_device *udev_device)
+{
+    struct udev_list_entry *ret;
+    pthread_mutex_lock(&libudev_mutex);
+    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+    ret = udev_device_get_current_tags_list_entry(udev_device);
+
+    pthread_cleanup_pop(1);
+    return ret;
+}
+
+struct udev_list_entry *mt_udev_device_get_sysattr_list_entry(struct
+udev_device *udev_device)
+{
+    struct udev_list_entry *ret;
+    pthread_mutex_lock(&libudev_mutex);
+    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+    ret = udev_device_get_sysattr_list_entry(udev_device);
+
+    pthread_cleanup_pop(1);
+    return ret;
+}
+*/
+
+struct udev_monitor *
+mt_udev_monitor_new_from_netlink(struct udev *udev, const char *name)
+{
+	struct udev_monitor *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_new_from_netlink(udev, name);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_monitor *mt_udev_monitor_ref(struct udev_monitor *udev_monitor)
+{
+	struct udev_monitor *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_ref(udev_monitor);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_monitor *mt_udev_monitor_unref(struct udev_monitor *udev_monitor)
+{
+	struct udev_monitor *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_unref(udev_monitor);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_monitor_enable_receiving(struct udev_monitor *udev_monitor)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_enable_receiving(udev_monitor);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_monitor_get_fd(struct udev_monitor *udev_monitor)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_get_fd(udev_monitor);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_device *mt_udev_monitor_receive_device(struct udev_monitor *udev_monitor)
+{
+	struct udev_device *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_receive_device(udev_monitor);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_monitor_filter_add_match_subsystem_devtype(
+	struct udev_monitor *udev_monitor, const char *subsystem, const char *devtype)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_filter_add_match_subsystem_devtype(udev_monitor,
+							      subsystem, devtype);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_monitor_set_receive_buffer_size(struct udev_monitor *udev_monitor, int size)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_monitor_set_receive_buffer_size(udev_monitor, size);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_enumerate *mt_udev_enumerate_new(struct udev *udev)
+{
+	struct udev_enumerate *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_new(udev);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_enumerate *mt_udev_enumerate_ref(struct udev_enumerate *udev_enumerate)
+{
+	struct udev_enumerate *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_ref(udev_enumerate);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_enumerate *mt_udev_enumerate_unref(struct udev_enumerate *udev_enumerate)
+{
+	struct udev_enumerate *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_unref(udev_enumerate);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_subsystem(struct udev_enumerate *udev_enumerate,
+					  const char *subsystem)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_subsystem(udev_enumerate, subsystem);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_nomatch_subsystem(struct udev_enumerate *udev_enumerate,
+					    const char *subsystem)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_sysattr(struct udev_enumerate *udev_enumerate,
+					const char *sysattr, const char *value)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_nomatch_sysattr(struct udev_enumerate *udev_enumerate,
+					  const char *sysattr, const char *value)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_property(struct udev_enumerate *udev_enumerate,
+					 const char *property, const char *value)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_property(udev_enumerate, property, value);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_tag(struct udev_enumerate *udev_enumerate,
+				    const char *tag)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_tag(udev_enumerate, tag);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_parent(struct udev_enumerate *udev_enumerate,
+				       struct udev_device *parent)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_parent(udev_enumerate, parent);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_match_is_initialized(struct udev_enumerate *udev_enumerate)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_match_is_initialized(udev_enumerate);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_add_syspath(struct udev_enumerate *udev_enumerate,
+				  const char *syspath)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_add_syspath(udev_enumerate, syspath);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+int mt_udev_enumerate_scan_devices(struct udev_enumerate *udev_enumerate)
+{
+	int ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_scan_devices(udev_enumerate);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
+
+struct udev_list_entry *
+mt_udev_enumerate_get_list_entry(struct udev_enumerate *udev_enumerate)
+{
+	struct udev_list_entry *ret;
+
+	pthread_mutex_lock(&libudev_mutex);
+	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
+
+	ret = udev_enumerate_get_list_entry(udev_enumerate);
+
+	pthread_cleanup_pop(1);
+	return ret;
+}
diff --git a/libmpathutil/mt-libudev.h b/libmpathutil/mt-libudev.h
new file mode 100644
index 0000000..1c1e748
--- /dev/null
+++ b/libmpathutil/mt-libudev.h
@@ -0,0 +1,120 @@
+#ifndef MT_LIBUDEV_H
+#define MT_LIBUDEV_H
+
+#include <pthread.h>
+#include <stdarg.h>    /* for va_list */
+#include <sys/types.h> /* For dev_t */
+
+struct udev;
+struct udev_list_entry;
+struct udev_device;
+struct udev_monitor;
+struct udev_enumerate;
+
+struct udev *mt_udev_ref(struct udev *udev);
+struct udev *mt_udev_unref(struct udev *udev);
+struct udev *mt_udev_new(void);
+
+struct udev_list_entry *
+mt_udev_list_entry_get_next(struct udev_list_entry *list_entry);
+struct udev_list_entry *
+mt_udev_list_entry_get_by_name(struct udev_list_entry *list_entry, const char *name);
+const char *mt_udev_list_entry_get_name(struct udev_list_entry *list_entry);
+const char *mt_udev_list_entry_get_value(struct udev_list_entry *list_entry);
+
+struct udev_device *
+mt_udev_device_new_from_syspath(struct udev *udev, const char *syspath);
+struct udev_device *
+mt_udev_device_new_from_devnum(struct udev *udev, char type, dev_t devnum);
+struct udev_device *
+mt_udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem,
+					  const char *sysname);
+/*
+ * Some older libudev versions  don't use "const" for the id argument,
+ * therefore we can't use it here, either.
+ */
+struct udev_device *mt_udev_device_new_from_device_id(struct udev *udev, char *id);
+struct udev_device *mt_udev_device_new_from_environment(struct udev *udev);
+
+struct udev_device *mt_udev_device_ref(struct udev_device *udev_device);
+struct udev_device *mt_udev_device_unref(struct udev_device *udev_device);
+struct udev *mt_udev_device_get_udev(struct udev_device *udev_device);
+struct udev_device *mt_udev_device_get_parent(struct udev_device *udev_device);
+struct udev_device *mt_udev_device_get_parent_with_subsystem_devtype(
+	struct udev_device *udev_device, const char *subsystem,
+	const char *devtype);
+const char *mt_udev_device_get_devpath(struct udev_device *udev_device);
+const char *mt_udev_device_get_subsystem(struct udev_device *udev_device);
+const char *mt_udev_device_get_devtype(struct udev_device *udev_device);
+const char *mt_udev_device_get_syspath(struct udev_device *udev_device);
+const char *mt_udev_device_get_sysname(struct udev_device *udev_device);
+int mt_udev_device_get_is_initialized(struct udev_device *udev_device);
+const char *
+mt_udev_device_get_property_value(struct udev_device *udev_device, const char *key);
+dev_t mt_udev_device_get_devnum(struct udev_device *udev_device);
+unsigned long long int mt_udev_device_get_seqnum(struct udev_device *udev_device);
+const char *mt_udev_device_get_driver(struct udev_device *udev_device);
+const char *mt_udev_device_get_devnode(struct udev_device *udev_device);
+const char *mt_udev_device_get_sysattr_value(struct udev_device *udev_device,
+					     const char *sysattr);
+/*
+ * libudev-215 (Debian jessie) doesn't use "const" for the value argument,
+ * therefore we can't use it here, either.
+ */
+int mt_udev_device_set_sysattr_value(struct udev_device *udev_device,
+				     const char *sysattr, char *value);
+
+struct udev_list_entry *
+mt_udev_device_get_properties_list_entry(struct udev_device *udev_device);
+/*
+ * multipath-tools doesn't use these, and some of them aren't available
+ * in older libudev versions.
+
+ struct udev_list_entry *mt_udev_device_get_devlinks_list_entry(struct
+ udev_device *udev_device); struct udev_list_entry
+ *mt_udev_device_get_tags_list_entry(struct udev_device *udev_device); struct
+ udev_list_entry *mt_udev_device_get_current_tags_list_entry(struct udev_device
+ *udev_device); struct udev_list_entry
+ *mt_udev_device_get_sysattr_list_entry(struct udev_device *udev_device);
+*/
+struct udev_monitor *
+mt_udev_monitor_new_from_netlink(struct udev *udev, const char *name);
+struct udev_monitor *mt_udev_monitor_ref(struct udev_monitor *udev_monitor);
+struct udev_monitor *mt_udev_monitor_unref(struct udev_monitor *udev_monitor);
+int mt_udev_monitor_enable_receiving(struct udev_monitor *udev_monitor);
+int mt_udev_monitor_get_fd(struct udev_monitor *udev_monitor);
+struct udev_device *
+mt_udev_monitor_receive_device(struct udev_monitor *udev_monitor);
+int mt_udev_monitor_filter_add_match_subsystem_devtype(
+	struct udev_monitor *udev_monitor, const char *subsystem,
+	const char *devtype);
+int mt_udev_monitor_set_receive_buffer_size(struct udev_monitor *udev_monitor,
+					    int size);
+
+struct udev_enumerate *mt_udev_enumerate_new(struct udev *udev);
+struct udev_enumerate *mt_udev_enumerate_ref(struct udev_enumerate *udev_enumerate);
+struct udev_enumerate *
+mt_udev_enumerate_unref(struct udev_enumerate *udev_enumerate);
+int mt_udev_enumerate_add_match_subsystem(struct udev_enumerate *udev_enumerate,
+					  const char *subsystem);
+int mt_udev_enumerate_add_nomatch_subsystem(struct udev_enumerate *udev_enumerate,
+					    const char *subsystem);
+int mt_udev_enumerate_add_match_sysattr(struct udev_enumerate *udev_enumerate,
+					const char *sysattr, const char *value);
+int mt_udev_enumerate_add_nomatch_sysattr(struct udev_enumerate *udev_enumerate,
+					  const char *sysattr, const char *value);
+int mt_udev_enumerate_add_match_property(struct udev_enumerate *udev_enumerate,
+					 const char *property, const char *value);
+int mt_udev_enumerate_add_match_tag(struct udev_enumerate *udev_enumerate,
+				    const char *tag);
+int mt_udev_enumerate_add_match_parent(struct udev_enumerate *udev_enumerate,
+				       struct udev_device *parent);
+int mt_udev_enumerate_add_match_is_initialized(struct udev_enumerate *udev_enumerate);
+int mt_udev_enumerate_add_syspath(struct udev_enumerate *udev_enumerate,
+				  const char *syspath);
+int mt_udev_enumerate_scan_devices(struct udev_enumerate *udev_enumerate);
+int mt_udev_enumerate_scan_subsystems(struct udev_enumerate *udev_enumerate);
+struct udev_list_entry *
+mt_udev_enumerate_get_list_entry(struct udev_enumerate *udev_enumerate);
+
+#endif
diff --git a/libmpathutil/mt-udev-wrap.h b/libmpathutil/mt-udev-wrap.h
new file mode 100644
index 0000000..f232821
--- /dev/null
+++ b/libmpathutil/mt-udev-wrap.h
@@ -0,0 +1,90 @@
+#ifndef MT_LIBUDEV_WRAP_HPP
+#define MT_LIBUDEV_WRAP_HPP
+#include "mt-libudev.h"
+
+#define udev_ref(udev)                       mt_udev_ref(udev)
+#define udev_unref(udev)                     mt_udev_unref(udev)
+#define udev_new()                           mt_udev_new()
+
+#define udev_list_entry_get_next(list_entry)             mt_udev_list_entry_get_next(list_entry)
+#define udev_list_entry_get_by_name(list_entry, name)    mt_udev_list_entry_get_by_name(list_entry, name)
+#define udev_list_entry_get_name(list_entry)             mt_udev_list_entry_get_name(list_entry)
+#define udev_list_entry_get_value(list_entry)            mt_udev_list_entry_get_value(list_entry)
+
+#define udev_list_entry_foreach(list_entry, first_entry)	\
+        for (list_entry = first_entry; \
+             list_entry; \
+             list_entry = udev_list_entry_get_next(list_entry))
+
+#define udev_device_new_from_syspath(udev, syspath)               mt_udev_device_new_from_syspath(udev, syspath)
+#define udev_device_new_from_devnum(udev, type, devnum)           mt_udev_device_new_from_devnum(udev, type, devnum)
+#define udev_device_new_from_subsystem_sysname(udev, subsystem, sysname) \
+                                                                  mt_udev_device_new_from_subsystem_sysname(udev, subsystem, sysname)
+#define udev_device_new_from_device_id(udev, id) mt_udev_device_new_from_device_id(udev, id)
+#define udev_device_new_from_environment(udev)                    mt_udev_device_new_from_environment(udev)
+
+#define udev_device_ref(udev_device)                      mt_udev_device_ref(udev_device)
+#define udev_device_unref(udev_device)                    mt_udev_device_unref(udev_device)
+#define udev_device_get_udev(udev_device)                 mt_udev_device_get_udev(udev_device)
+#define udev_device_get_parent(udev_device)               mt_udev_device_get_parent(udev_device)
+#define udev_device_get_parent_with_subsystem_devtype(udev_device, subsystem, devtype) \
+	mt_udev_device_get_parent_with_subsystem_devtype(udev_device, subsystem, devtype)
+#define udev_device_get_devpath(udev_device)              mt_udev_device_get_devpath(udev_device)
+#define udev_device_get_subsystem(udev_device)            mt_udev_device_get_subsystem(udev_device)
+#define udev_device_get_devtype(udev_device)              mt_udev_device_get_devtype(udev_device)
+#define udev_device_get_syspath(udev_device)              mt_udev_device_get_syspath(udev_device)
+#define udev_device_get_sysname(udev_device)              mt_udev_device_get_sysname(udev_device)
+#define udev_device_get_is_initialized(udev_device)       mt_udev_device_get_is_initialized(udev_device)
+#define udev_device_get_property_value(udev_device, key)  mt_udev_device_get_property_value(udev_device, key)
+#define udev_device_get_devnum(udev_device)               mt_udev_device_get_devnum(udev_device)
+#define udev_device_get_seqnum(udev_device)               mt_udev_device_get_seqnum(udev_device)
+#define udev_device_get_driver(udev_device)                       mt_udev_device_get_driver(udev_device)
+#define udev_device_get_devnode(udev_device)                      mt_udev_device_get_devnode(udev_device)
+#define udev_device_get_sysattr_value(udev_device, sysattr) \
+                                                          mt_udev_device_get_sysattr_value(udev_device, sysattr)
+#define udev_device_set_sysattr_value(udev_device, sysattr, value) \
+	mt_udev_device_set_sysattr_value(udev_device, sysattr, value)
+
+#define udev_device_get_devlinks_list_entry(udev_device)        mt_udev_device_get_devlinks_list_entry(udev_device)
+#define udev_device_get_properties_list_entry(udev_device)      mt_udev_device_get_properties_list_entry(udev_device)
+#define udev_device_get_tags_list_entry(udev_device)            mt_udev_device_get_tags_list_entry(udev_device)
+#define udev_device_get_current_tags_list_entry(udev_device)    mt_udev_device_get_current_tags_list_entry(udev_device)
+#define udev_device_get_sysattr_list_entry(udev_device)         mt_udev_device_get_sysattr_list_entry(udev_device)
+
+#define udev_monitor_new_from_netlink(udev, name)         mt_udev_monitor_new_from_netlink(udev, name)
+#define udev_monitor_ref(udev_monitor)                    mt_udev_monitor_ref(udev_monitor)
+#define udev_monitor_unref(udev_monitor)                  mt_udev_monitor_unref(udev_monitor)
+#define udev_monitor_enable_receiving(udev_monitor)       mt_udev_monitor_enable_receiving(udev_monitor)
+#define udev_monitor_get_fd(udev_monitor)                 mt_udev_monitor_get_fd(udev_monitor)
+#define udev_monitor_receive_device(udev_monitor)         mt_udev_monitor_receive_device(udev_monitor)
+#define udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, subsystem, devtype) \
+	mt_udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, subsystem, devtype)
+#define udev_monitor_set_receive_buffer_size(udev_monitor, size) \
+                                                          mt_udev_monitor_set_receive_buffer_size(udev_monitor, size)
+
+#define udev_enumerate_new(udev)                          mt_udev_enumerate_new(udev)
+#define udev_enumerate_unref(udev_enumerate)              mt_udev_enumerate_unref(udev_enumerate)
+#define udev_enumerate_add_match_subsystem(udev_enumerate, subsystem) \
+                                                          mt_udev_enumerate_add_match_subsystem(udev_enumerate, subsystem)
+#define udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem) \
+                                                          mt_udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem)
+#define udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value) \
+                                                          mt_udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value)
+#define udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value) \
+                                                          mt_udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value)
+#define udev_enumerate_add_match_property(udev_enumerate, property, value) \
+                                                          mt_udev_enumerate_add_match_property(udev_enumerate, property, value)
+#define udev_enumerate_add_match_tag(udev_enumerate, tag) mt_udev_enumerate_add_match_tag(udev_enumerate, tag)
+#define udev_enumerate_add_match_parent(udev_enumerate, parent) \
+                                                          mt_udev_enumerate_add_match_parent(udev_enumerate, parent)
+#define udev_enumerate_add_match_is_initialized(udev_enumerate) \
+                                                          mt_udev_enumerate_add_match_is_initialized(udev_enumerate)
+#define udev_enumerate_add_syspath(udev_enumerate, syspath) \
+                                                          mt_udev_enumerate_add_syspath(udev_enumerate, syspath)
+
+#define udev_enumerate_scan_devices(udev_enumerate)       mt_udev_enumerate_scan_devices(udev_enumerate)
+#define udev_enumerate_scan_device(udev_enumerate, syspath) \
+                                                          mt_udev_enumerate_scan_device(udev_enumerate, syspath)
+#define udev_enumerate_get_list_entry(udev_enumerate)     mt_udev_enumerate_get_list_entry(udev_enumerate)
+
+#endif
-- 
2.52.0

