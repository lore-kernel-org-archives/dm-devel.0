Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3FD30F945
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006506; cv=none; b=QLjFPQl+eKUNJf4qwlNkAiMFlSqXHObgORvehu6Z7wP3EyihaX3BhbRF5mT/siUIAKvorOSiahbP4VFN8K8BCKtcQWMfMv+nu8W0xg0o50/fisntjbLYxS6UAYIS67VR/Duk1epiaG7mvjZOYTNUxiPRNM5inw1oFrXwfTQ3XkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006506; c=relaxed/simple;
	bh=Z/7YtEQw4PyPd+tzFF728a1oo4vvYjDqPnGac9FxZEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee4LVJVDDQ/YezTmhnCvfz4JbZVf3L5BbOLDrJFgmgr4EM6/KL1nUZdxjdiskOYhA96Ykoa9novT7EWnqa6bNr0VjrHBk03qNpJsoMKa6jjgGfccjLZskQlF9jgehqacr/4d/axuJwgJ02IceOlegVsikVAkhGpVIF3geJhke+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TlSVozSe; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TlSVozSe"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7ffa421f1bso179200766b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006502; x=1766611302; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NatHhC+4KUev5OmGunjU+l2BwhZjl36Mz61MmqHuAUU=;
        b=TlSVozSetdEvPU1RiXB4oaFAhN1dzP16bmtLOK7NGhfz8bNlmRF2NKQtscTN0iB+q0
         NsQJymvK3AFmgHQpK7cSCIv4oesfuazrBX8At9zbUtjcuIYaUEAwn7g4jfkWzbl+X++Z
         tJrgAInIyFuiv+Me8zlcskSHHEFmoFEcTHPCDBro+ozqZsav0mVlSnvvCgr0mS/aY3yJ
         wLrkefyOAKCLXiSMbaaDYqrEYSDqEhR7WMsLYrYwkf4fpkey3PzZ3vILxPkyfkSfV4KU
         UtkoascA0zToC51UttBpNRCmIlvOoQdLQ7bEIWSiUJhcISwACGsXG4aV3Odek5AF0it3
         hVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006502; x=1766611302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NatHhC+4KUev5OmGunjU+l2BwhZjl36Mz61MmqHuAUU=;
        b=HAaytVC5qohFYHX/0dJmPZZ81ngeaN5ejYAKusIleLaIXSTYO/tucTuGHcHWvIHVqR
         wx2+Fce070dGcAzrV5J++XffW4XJyyJEqmMy2/IhK0q/o66j5balfCtW17+pnQPAvsy3
         HDcBauHpqk9tPacpkA7bFHteEyDLkBy8t/0rQjWUqU1NeSl+L45qpIReDNot38PqmaRk
         qoQda5ourbXEnTm9fJk/hEjiDOPiRnlIo7SSMw0dGQ3npFLb2BTMRN+tbC/gzdbq0hkM
         x13Ro/ICsMNd+H1mRO8kEMCE+83EhNkhanDIHCP+2DFE3dbJhqDkumc0+2N90L72qiVo
         NOYA==
X-Gm-Message-State: AOJu0YwhRilYNNVphPX+v/Iek+ahOBgFSkafosWExSe8CFGyHU8zYo3u
	TLOKpPE6L8RFho518LGbUVIgl1tmNhAqe5cL4/Gw7rxwJbiFzdgd9/9iwpwydSnN3ybq7CoeQKJ
	Ky8Zq
X-Gm-Gg: AY/fxX56fmIl57a/zmJig/QWiTgmr8DZ8ZSg6E48dAv4ZkBDy0PH9OZECTKiRMkM+Lb
	7pnmJ3oKRZ5Sv/JtA5Pr2eIuHMlXGoa+mPrO8tuw5GpeMLQTdT7hjkUOEI5yaQdAbYhgUcdbwYQ
	YaEtWgnrraqJayqbIi87LG8xtXX8kNDFFGBJf0xOq8oRFvpM/+V0FyOh3kI8pWyF8eF+++GjEQj
	O9gkus5mTfwbSrp9czsnduMQs8dmwwhSSvv4lRd5LeLU5ayFzXk38PNNO1J6gBDsh3RSSUF9s/L
	AQgXqXyEmCOLLbQxbe5jfo2SnCgFm7BjI/M90RJH+tiQEV+MlAYK/eZ6hwj0ml4KcLm9ffvUj39
	5M7ovq5ZGsGHNhBPoJqegqXv31TvTgf0Co/nq/ALD/bXrQo/ItWm1kSdBtV7UYN8Ghw934icfCs
	d22S1IU3v/u9jOh2piWarCqPWSBWHhxPL+fdqkwt/U54+4K8GwE0v2z4n2t8cxILDv6NHaCP2dc
	QgAegl25e1W
X-Google-Smtp-Source: AGHT+IF7AWrqEw2j/noKlwi8sEYYL45jokbeISYTkLj96H0sDp6XaQJnTux1Blp9QmYAyt53V10AEw==
X-Received: by 2002:a17:907:fdc1:b0:b5c:6e0b:3706 with SMTP id a640c23a62f3a-b80204a7878mr89292666b.13.1766006501456;
        Wed, 17 Dec 2025 13:21:41 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80234a2fa2sm27869566b.55.2025.12.17.13.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/21] libmpathutil: add wrapper code for libudev
Date: Wed, 17 Dec 2025 22:21:10 +0100
Message-ID: <20251217212113.234959-19-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
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
index 14aa083..4ce1da6 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -93,6 +93,68 @@ global:
 	log_thread_stop;
 	logsink;
 	msort;
+
+        mt_udev_ref;
+        mt_udev_unref;
+        mt_udev_new;
+
+        mt_udev_list_entry_get_next;
+        mt_udev_list_entry_get_by_name;
+        mt_udev_list_entry_get_name;
+        mt_udev_list_entry_get_value;
+
+        mt_udev_device_ref;
+        mt_udev_device_unref;
+        
+        mt_udev_device_new_from_syspath;
+        mt_udev_device_new_from_devnum;
+        mt_udev_device_new_from_subsystem_sysname;
+        mt_udev_device_new_from_device_id;
+        mt_udev_device_new_from_environment;
+
+        mt_udev_device_get_udev;
+        mt_udev_device_get_parent;
+        mt_udev_device_get_parent_with_subsystem_devtype;
+        mt_udev_device_get_devpath;
+        mt_udev_device_get_subsystem;
+	mt_udev_device_get_devtype;
+        mt_udev_device_get_syspath;
+        mt_udev_device_get_sysname;
+        mt_udev_device_get_devnum;
+        mt_udev_device_get_is_initialized;
+        mt_udev_device_get_property_value;
+        mt_udev_device_get_seqnum;
+        mt_udev_device_set_sysattr_value;
+        mt_udev_device_get_sysattr_value;
+        mt_udev_device_get_driver;
+        mt_udev_device_get_devnode;
+        
+        mt_udev_device_get_properties_list_entry;
+
+        mt_udev_monitor_new_from_netlink;
+        mt_udev_monitor_enable_receiving;
+        mt_udev_monitor_get_fd;
+        mt_udev_monitor_receive_device;
+        mt_udev_monitor_filter_add_match_subsystem_devtype;
+        mt_udev_monitor_ref;
+        mt_udev_monitor_unref;
+        mt_udev_monitor_set_receive_buffer_size;
+
+        mt_udev_enumerate_new;
+        mt_udev_enumerate_ref;
+        mt_udev_enumerate_unref;
+        mt_udev_enumerate_add_match_subsystem;
+        mt_udev_enumerate_scan_devices;
+        mt_udev_enumerate_get_list_entry;
+	mt_udev_enumerate_add_nomatch_subsystem;
+        mt_udev_enumerate_add_match_sysattr;
+        mt_udev_enumerate_add_nomatch_sysattr;
+        mt_udev_enumerate_add_match_property;
+        mt_udev_enumerate_add_match_tag;
+        mt_udev_enumerate_add_match_parent;
+        mt_udev_enumerate_add_match_is_initialized;
+        mt_udev_enumerate_add_syspath;
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

