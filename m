Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022524;
	b=hT7IRiabGC3U5/AF5wnV37dGlIYszaOlcb9LOOYIVS1ir3KgXnj0okKYlzsth6oblReP
	 ChJb+guJqNBIpmhStw2tYLt4A87jUcahCj401ucCbcI+Ggl1Q97blMApuaIP097Qhcoqe
	 J8iz1DjL1CCkAxa5m77DY9AKFl8YhqLaZ0dFfyTQTbRps4culWhJS4iPiRYnVDZHdAp9M
	 x4nQrt2G3W+pB/pLzwwcXUkmHUtjmqNkLqqSi4q9wreMZC0k3OjYz1s2Foj91N30cIGSf
	 Q5oGGtNfjedAEghEyRVV3Z3MdIOeGNZ+fxYXtJsUD1ATYYF7WBcfcgtcTCyppaJmKpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022524;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sd14T1fUB4Q14wsBGQFevFadETWy31cL3NXuCPpZvvQ=;
	b=k70RgkTVI9d4pALms3I4XbtB3zlEY3Le0chruYqeBlNoxcyKQY+j/tXLr7CBbNDAGRJJ
	 WDokuGGZyGbZmqGS9cqXcP7P4l6PhmUzysdkGDt6Vi7/0rleataPmTiGsaNkvXflvzwho
	 WFkN8fDuzkpGf7qraCIrl04I09sET55EIPjWUF71kYzXFY3mN4uCLjlxIaJ3h2hs8puc7
	 NETXYWNxVdH0gQJc6xdCcDCT0/grmmd4zprl1b1SFPZH1qst/nNzwHb0VVJZUWkV024qQ
	 8RdGva851izkONfHEpkxgncG4hDXzO8KCgpJ0qlItcZZfBBEhGeHcArNg8AzFTcbLKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KA42VOL1;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B97E606A338
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B97E606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KA42VOL1
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b3bf3bef9aso1237125a91.1
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022522; x=1795627322; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sd14T1fUB4Q14wsBGQFevFadETWy31cL3NXuCPpZvvQ=;
        b=KA42VOL1glZmJ8Iw0eOdnewzMuBEGdGo4bxtaDpPEc19/Nxg7N+thx/yUqwPPethLo
         8FOsX2i5SCSvBWntnizYxfeom3748uOPeNGBisCBiihpxVZ5qAPKDARBkS+U9IGJjuw1
         aHguXAdgWtPFnMnw8rZsSGYCsvfTD3ucmZ+p6vnVsxmXoBDMY+ZrDJ4CQUucE5Y+9ih3
         pNhPyjSCWXfRSKmEQQUH6AcOJs5v0jtzYZnYS6Pf9RE8V0C874p6miEWGvqictUivRBn
         JGNulqmZT8tIJ4GetBwwuBpXslY+IPqvgH7f/bOSXFKE9qchC+J7/l+Yq2KrZZVNyTvQ
         7RpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022522; x=1795627322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sd14T1fUB4Q14wsBGQFevFadETWy31cL3NXuCPpZvvQ=;
        b=jnNseDBqWk8a4SbZwJCLL7scWW6y0J0I7JNy4s3xwFsAoLmXIKk97R7hO+jpS7fEY+
         kq2SM3jEwbNLvoQ5IrQ3mpqguh+O2BPFkTMqJSzKZX/As9jYOxpBfhvmfDqG73LnbAks
         uAMvoXPJpL0I+p6aBZG8qLwBotP6GAw4ZGLNRL4t33hGnpfxEVVKzDglQ5/kWBQqLPzH
         liUeT8f8/aDvS/y7iuCROb3y0CymESbm5cKY276DCBKiFcIXNwKHEerdXRNF9mJ7hoj0
         ntPB7r+Wp5/PrAOpcKlugv3vf4x7g6JoOaNJ+s5bM6qooosrqN9nF5oZpDEENMmnPw/R
         r4WA==
X-Forwarded-Encrypted: i=1; AL+hErFkwpUjVrdXjDb7E4yaB1wAvbthobbFGj3MurlCPHy+OE52A5PclJtIxh0ww46e9ZegLeuCHDumug==@lists.linux.dev
X-Gm-Message-State: APuU4Z+Ujq0rgmADhttb5eaXP4XgUO7S6lRRvB4FshSZ0a87HUYd37Bq
	PaYkuy0nvL/qDw/ltfw/1ZXWfJWV73qbbk3+fE5QVFxaHHqGHYzUIsZD
X-Gm-Gg: AZFdTZfNafHv75/xqVOw4VyT78exyei27XGaZpTj1WCSnthUuuzss/GK6XDKzzQo/u2
	3wXdT15Ywhz5/D7su8TF/urZFaNm6Y7f340FLNFQVJmOjxdlO8CT474UMbnXJms6YurD4yJ6nsZ
	TCy1UxgDGDv6Cy67qjIzUBMZn54SkVknEVr7ZtR4QxA3FuHPWLiIUCp/Mf9HlOsmQhbgWFJZmxE
	NmiWhI9QeVmMaztHgWCNe+LQaK+uGipV5rxsnVbdIuN4h8Nb1gt7EzXI2T8tyAYNyzsHwQ6Udyb
	MnpT27ichs1VZZLQojgC6FUIque7rPNmhtg8PHWwUxyDzPC0NRekpxDJB/iVyJkNtwjHYcWlIIR
	WUzqYb189WGxx2ScTI8SJTCPDIvWBrYcfbcA4GG2zC96gNvyTaNfltzSk7LoacaXVBRH5aZJcHL
	Iun19/Mn1m4FH2ODoHnsHgqUmAUh6czQmqVUSMB3EPO7v7d1s1m8j942Ow59YDiRNt4lCqwUqTK
	F1/0Wunvd7fa9PAHKze8bMzk4FpzlVex640Hcju/rB8v1wsMMlYm4pruoXy0WH/4ghvHsTjy3W9
	nKYDE3kJcur9VL58H4/5U5qeOHbRyZIkFHKL+R2GIj2Vu4v9HCDrm07N6rlVF3CKjzpMK55yuCo
	sf/loSycB
X-Received: by 2002:a17:90a:d886:b0:3b0:9e2c:9b57 with SMTP id 98e67ed59e1d1-3b3d06a425cmr3642264a91.4.1795022522308;
        Wed, 18 Nov 2026 09:22:02 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f7067012sm135659a91.12.2026.11.18.09.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:22:01 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v2 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Thu, 19 Nov 2026 01:21:32 +0800
Message-ID: <20261118172133.689163-4-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

There is no way to see how much memory a particular dm-bufio client is
using, or to change one client's retain target without also affecting
every future client.

Add dm_bufio_client_sysfs_add(), which publishes a client as <name>
under a kobject supplied by its user, with the retain target writable
and the rest of its state read-only.  Callers that have no use for it
simply never call it.

The kobject is embedded in the client, which is therefore freed only
after the release method runs, as in dm-sysfs.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v2:
- Zero the kobject after a failed dm_bufio_client_sysfs_add() so a
  retried call cannot free the already-freed name again.
---
 .../ABI/testing/sysfs-kernel-dm-bufio         |  76 ++++++++
 .../admin-guide/device-mapper/dm-bufio.rst    |  54 ++++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 drivers/md/dm-bufio.c                         | 168 ++++++++++++++++++
 include/linux/dm-bufio.h                      |   9 +
 5 files changed, 308 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-dm-bufio
 create mode 100644 Documentation/admin-guide/device-mapper/dm-bufio.rst

diff --git a/Documentation/ABI/testing/sysfs-kernel-dm-bufio b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
new file mode 100644
index 000000000000..bccd679c1b60
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
@@ -0,0 +1,76 @@
+What:		/sys/block/<dm-device>/dm-bufio/<name>/
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Directory exposing one dm-bufio client whose user opted in
+		through dm_bufio_client_sysfs_add().  <name> is chosen by that
+		user; dm-verity, which places the directory under the block
+		device of its own dm device, uses <name> "hash" for the hash
+		tree client, "fec" for the FEC parity client and "fec-data"
+		for the FEC data client.  The directory lives from
+		registration until the client is destroyed, independently of
+		any device-mapper table loaded on the device, so a suspend or
+		table reload never leaves dangling entries behind.  The
+		read-only counters are instantaneous snapshots and may be
+		approximate.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Major and minor of the client's block device, in the form
+		<major>:<minor>.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev_name
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Name of the client's block device.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/block_size
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Block size of the client in bytes.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/retain_bytes
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of bytes dm-bufio tries to keep cached for this
+		client.  It is a floor applied by the memory shrinker, not a
+		cap, so the cache may grow past it when memory is plentiful.
+
+		Writable.  A non-zero value is rounded up to a block
+		boundary, so the target keeps at least as many bytes as
+		requested; zero restores the dm-bufio default.  Writing it
+		affects only this client, not the retain_bytes module
+		parameter and not other clients.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/current_bytes
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of bytes currently cached by this client.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/buffers
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of buffers currently cached by this client.
+		Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/minimum_buffers
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Minimum number of buffers the client keeps before cleanup
+		happens.  Read-only.
diff --git a/Documentation/admin-guide/device-mapper/dm-bufio.rst b/Documentation/admin-guide/device-mapper/dm-bufio.rst
new file mode 100644
index 000000000000..c35e415acacd
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-bufio.rst
@@ -0,0 +1,54 @@
+========
+dm-bufio
+========
+
+dm-bufio caches small metadata blocks on block devices for several
+device-mapper targets (dm-verity, dm-thin, dm-cache, dm-integrity and
+dm-ebs among others).  Each user creates clients on a block device; the
+caches are independent, even for clients on the same device.
+
+Retain target
+=============
+
+dm-bufio bounds nothing by itself: buffers live until the memory shrinker
+evicts them, and the shrinker stops once a client is back down to its
+retain target.  The target is a floor under memory pressure, not a cap,
+so a fully warmed cache may hold far more.
+
+The default is the ``retain_bytes`` module parameter of dm_bufio
+(256 KiB), which only affects clients created after it is changed.  One
+client changes its own target through the ``retain_bytes`` attribute of
+its sysfs directory or a target-specific message.
+
+sysfs interface
+===============
+
+A client may be published in sysfs with dm_bufio_client_sysfs_add(),
+passing the parent kobject and the directory name; dm-bufio does not
+choose where it lives.  The directory lives until the client is
+destroyed.  dm-verity registers its clients under the block device of
+its own dm device::
+
+  /sys/block/dm-N/dm-bufio/hash/        the hash tree client
+  /sys/block/dm-N/dm-bufio/fec/         the FEC parity client
+  /sys/block/dm-N/dm-bufio/fec-data/    the FEC data client
+
+The attributes, including the read-write ``retain_bytes``, are documented
+in Documentation/ABI/testing/sysfs-kernel-dm-bufio.
+
+Example
+=======
+
+Inspect the hash client of a dm-verity device::
+
+  # ls /sys/block/dm-1/dm-bufio/
+  fec  fec-data  hash
+
+  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  2535424
+
+  # echo 8388608 > /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  8388608
+
+The other clients keep their own targets.
diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index 73c1f2002134..3b6c348f71f5 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -8,6 +8,7 @@ Device Mapper
     cache-policies
     cache
     delay
+    dm-bufio
     dm-clone
     dm-crypt
     dm-dust
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 367f878c17dc..a2991dcd532f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -20,6 +20,9 @@
 #include <linux/rbtree.h>
 #include <linux/stacktrace.h>
 #include <linux/jump_label.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/completion.h>
 
 #include "dm.h"
 
@@ -995,6 +998,9 @@ struct dm_bufio_client {
 	unsigned int minimum_buffers;
 
 	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+	bool sysfs_added;
+	struct kobject kobj;
+	struct completion kobj_unregister;
 
 	sector_t start;
 
@@ -2505,6 +2511,165 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 	return count;
 }
 
+/*
+ * A client may be published in sysfs with dm_bufio_client_sysfs_add();
+ * the directory lives until the client is destroyed.
+ */
+
+static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
+				  char *buf);
+static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
+				   const char *buf, size_t size);
+
+#define DM_BUFIO_ATTR_RO(_name)						\
+	static struct attribute dm_bufio_attr_##_name =			\
+		{ .name = #_name, .mode = 0444 }
+
+#define DM_BUFIO_ATTR_RW(_name)						\
+	static struct attribute dm_bufio_attr_##_name =			\
+		{ .name = #_name, .mode = 0644 }
+
+DM_BUFIO_ATTR_RO(bdev);
+DM_BUFIO_ATTR_RO(bdev_name);
+DM_BUFIO_ATTR_RO(block_size);
+DM_BUFIO_ATTR_RW(retain_bytes);
+DM_BUFIO_ATTR_RO(current_bytes);
+DM_BUFIO_ATTR_RO(buffers);
+DM_BUFIO_ATTR_RO(minimum_buffers);
+
+static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
+				  char *buf)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	if (attr == &dm_bufio_attr_bdev)
+		return sysfs_emit(buf, "%d:%d\n", MAJOR(c->bdev->bd_dev),
+				  MINOR(c->bdev->bd_dev));
+	if (attr == &dm_bufio_attr_bdev_name)
+		return sysfs_emit(buf, "%pg\n", c->bdev);
+	if (attr == &dm_bufio_attr_block_size)
+		return sysfs_emit(buf, "%u\n", c->block_size);
+	if (attr == &dm_bufio_attr_retain_bytes)
+		return sysfs_emit(buf, "%lu\n", READ_ONCE(c->retain_bytes));
+	if (attr == &dm_bufio_attr_current_bytes)
+		return sysfs_emit(buf, "%llu\n",
+				  (u64)cache_total(&c->cache) * c->block_size);
+	if (attr == &dm_bufio_attr_buffers)
+		return sysfs_emit(buf, "%lu\n", cache_total(&c->cache));
+	if (attr == &dm_bufio_attr_minimum_buffers)
+		return sysfs_emit(buf, "%u\n", c->minimum_buffers);
+
+	return -EINVAL;
+}
+
+static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
+				   const char *buf, size_t size)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	if (attr == &dm_bufio_attr_retain_bytes) {
+		unsigned long new;
+
+		if (kstrtoul(buf, 0, &new))
+			return -EINVAL;
+
+		dm_bufio_set_retain_bytes(c, new);
+
+		return size;
+	}
+
+	return -EINVAL;
+}
+
+static struct attribute *dm_bufio_attrs[] = {
+	&dm_bufio_attr_bdev,
+	&dm_bufio_attr_bdev_name,
+	&dm_bufio_attr_block_size,
+	&dm_bufio_attr_retain_bytes,
+	&dm_bufio_attr_current_bytes,
+	&dm_bufio_attr_buffers,
+	&dm_bufio_attr_minimum_buffers,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dm_bufio);
+
+static const struct sysfs_ops dm_bufio_sysfs_ops = {
+	.show	= dm_bufio_attr_show,
+	.store	= dm_bufio_attr_store,
+};
+
+static void dm_bufio_kobj_release(struct kobject *kobj)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	/*
+	 * The client is freed only after this completes, as in dm-sysfs.
+	 */
+	complete(&c->kobj_unregister);
+}
+
+static const struct kobj_type dm_bufio_ktype = {
+	.sysfs_ops	= &dm_bufio_sysfs_ops,
+	.default_groups	= dm_bufio_groups,
+	.release	= dm_bufio_kobj_release,
+};
+
+static int dm_bufio_kobj_add(struct dm_bufio_client *c, struct kobject *parent,
+			     const char *name)
+{
+	init_completion(&c->kobj_unregister);
+
+	return kobject_init_and_add(&c->kobj, &dm_bufio_ktype, parent, "%s",
+				    name);
+}
+
+/* Drop the sysfs reference and wait for the release method to run. */
+static void dm_bufio_kobj_del(struct dm_bufio_client *c)
+{
+	kobject_put(&c->kobj);
+	wait_for_completion(&c->kobj_unregister);
+}
+
+int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
+			      const char *name)
+{
+	int r;
+
+	if (c->sysfs_added) {
+		if (c->kobj.state_in_sysfs)
+			return -EBUSY;
+		/* re-attaching after dm_bufio_client_sysfs_detach() */
+		init_completion(&c->kobj_unregister);
+		return kobject_add(&c->kobj, parent, "%s", name);
+	}
+
+	r = dm_bufio_kobj_add(c, parent, name);
+	if (r) {
+		/* kobject_cleanup() freed kobj.name; clear the kobject so
+		 * a retried add does not free the dangling pointer again. */
+		dm_bufio_kobj_del(c);
+		memset(&c->kobj, 0, sizeof(c->kobj));
+		return r;
+	}
+
+	c->sysfs_added = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_add);
+
+/*
+ * Remove the directory from sysfs without releasing the kobject; it is
+ * released in dm_bufio_client_destroy().  dm_bufio_client_sysfs_add()
+ * puts the directory back.
+ */
+void dm_bufio_client_sysfs_detach(struct dm_bufio_client *c)
+{
+	if (c->sysfs_added && c->kobj.state_in_sysfs)
+		kobject_del(&c->kobj);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_detach);
+
+
 /*
  * Create the buffering interface
  */
@@ -2661,6 +2826,9 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 {
 	unsigned int i;
 
+	if (c->sysfs_added)
+		dm_bufio_kobj_del(c);
+
 	drop_buffers(c);
 
 	shrinker_free(c->shrinker);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 9bf3f805c43c..ac168ac797e4 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -17,6 +17,7 @@
 
 struct dm_bufio_client;
 struct dm_buffer;
+struct kobject;
 
 /*
  * Flags for dm_bufio_client_create
@@ -165,6 +166,14 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
 unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
 
+/*
+ * Publish the client as <name> under <parent> in sysfs; removed in
+ * dm_bufio_client_destroy().
+ */
+int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
+			      const char *name);
+void dm_bufio_client_sysfs_detach(struct dm_bufio_client *c);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
-- 
2.43.0

