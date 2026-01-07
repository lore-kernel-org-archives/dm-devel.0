Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D653385A5
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817152; cv=none; b=U0nie7R/JKape8xh25ID6FWAEBTJK4w93INj+P5VYAh+LYckdfV6SvdJ4+osQ4rVkJjcNIg9zyJq4Mkf+e7u27hNQSWSmipJgfmmKMYTtXcWdfhRxLU9AUzYjk0IX8I7e/qsx1cmt+PcPnpe3FOKGeVd8N//t0FAz1yC5cxmNYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817152; c=relaxed/simple;
	bh=tgwEx2nTLvgjItY6ASGZP7s5Cxm3Hw/LugwJ2go124o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0gypkpaypqv0QXgvwlzBXRS41M0GOPHVsUrAVtvYK2NOJBlH6h+CqDutoS7b8r7KqbNauHSWDsqS9gxQC3R7tt6g0/KPDDqVV+w2u+6RlnqD2DyVLnp4AYHVF7vVfozUZJ4PvCkQYRQouAhgptA1qgaSUWY95T49hFYp8/Ifyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gSr73Srk; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gSr73Srk"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso3794061a12.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817145; x=1768421945; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3z/bwD55I0fqNpTZO0HvQVssdTjjr6FXPZsgFY1l3kE=;
        b=gSr73SrkEUfM1nh3oNUzCKIgJv+sRjZaoFpKKRRZQtkoUgumrSmFfSL6Fe7n7BOLen
         wYIG3Wv1LEYsb+AO2dki6Ibf5Uwvv4DmNYR3L9rm4OhwBqGi6dG7GeLxr2QnQgrcl6xO
         m08JlJjlAKpshTWi1/462/hLN4HIpqG6h78ZKp/dWu8pnECHZI0FcBogXrazMRyd4I3Q
         dd724R7FuaiEI3jEznsTWm7JauWR4q8fkSQH6uSDMxtDJpgto2h4pQl5JXfLgmun+QPH
         PAXdQBrbjx9qc+GDMpBn80bYZ2dlAVwlzomPFvNF1CDqhip6CxVQQWBbZJquJlBqh7x4
         zp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817145; x=1768421945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3z/bwD55I0fqNpTZO0HvQVssdTjjr6FXPZsgFY1l3kE=;
        b=GdX2RodYTyRViZnKEUwDlTnYp1HFqfKENq/H1V4/nbF0Yrn5JD3rsSonKAl7cm1CZV
         zvhN+qHw30JgZKv5KRNoaEnbqdntEnPfA2FUSGPJQhn50/mKEvppms201Hvcj+CQp2qU
         KEfTdN7uH1qnVCcaWNVBOQoLqOdaP+EtsGDxhjrC2YB1DqYrEIs2iFkSsDBcJ32Bl4Kr
         RFJJ4pb5xKRftByjsmT7rqI+bT8yw7yvbuH1sNQSRO83/L5LHUzHva/RUf9zogEWo8hb
         7mSbT/LUNe3pmXkB0Z4Wx275ngNprHrrfmhuFi15z8Bg1AP3Iozg0a8ePwEAE2NeA6IB
         3S/A==
X-Gm-Message-State: AOJu0YyaIStDG8DnyDm0uSOHNxISh7NJuNBB/gTehaxSZrwpVRZYlyn6
	J7xlDkzx/5Ob+gxN5cbqO6WjuIswpIZJuuPk7IhN7NYf4sgla6p/fzvf6qhlcMB6LkU=
X-Gm-Gg: AY/fxX69HTCIwN9bVGXxjK9rUrSqpxuEpkY+izHtGzJSXoQXQCo4LvwZ4LcfKcR8xym
	lBfxSSs25BafPlkxETWpYn3+qScaMkB/9u/ONdawQj3qHSyjUmB2RjZ3otFLXcHnLR613HfHM8a
	QdZLZR7gEHqdBtmvSmC260IuUeNMM3KO/DskXdkWlwe6vzVjpXhM00Xv5zZMpWNGug9UyRdOKWO
	Wr/oLWOiH3LykXwh2EopypReIHQUKH6sqDpqX6eO7eMd7O9w1yUclxrZyZJj+ODSQtqGrfC/j6W
	ZvGJQO6+jFlFQdu40KwdO3ouYo/iJiTikDDCNk363TJ5toPnB8L8I1XNWUvRRCBDvbZdHXdKBWO
	Y7zbTEDJNPDVclZfKXwv/sQCnV8rIH+UF+axsJ2Lq6ZHkn415Pi7xy1nEOhv+gFR/AsvjTVze9B
	CHuLnw+0LwJRrUVL3cJLFP9wKlvckFLga7xxn+QcddkEZQWeiYN3ZzL3Hhm47+uLeUZ5qA5Nonc
	rtTDCwHdtoP
X-Google-Smtp-Source: AGHT+IGQ7EArGtbzfbMfSEinJuSsrErP2HoM8UipMyJR+ORkmZqetyq8mAsT3wIjCwfeHxRT8kslRA==
X-Received: by 2002:a17:906:478d:b0:b73:78f3:15b3 with SMTP id a640c23a62f3a-b844536a598mr333284166b.47.1767817144487;
        Wed, 07 Jan 2026 12:19:04 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a5187afsm594626966b.58.2026.01.07.12.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:03 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 23/26] libmpathutil: add wrapper code for libudev
Date: Wed,  7 Jan 2026 21:18:23 +0100
Message-ID: <20260107201826.323977-24-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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

